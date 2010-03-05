Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434Ab0CEPDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 10:03:16 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:55560 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab0CEPDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 10:03:12 -0500
X-IronPort-AV: E=Sophos;i="4.49,587,1262581200"; 
   d="scan'208";a="86846530"
Subject: Infinite loop on boot in free_early_partial due to start==end on
 tip/master
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Yinghai Lu <yinghai@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Fri, 5 Mar 2010 15:03:10 +0000
Message-ID: <1267801390.11737.38014.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding some debug, including a WARN_ON(start >= end) I get:

(early) [    0.000000] pcpu_embed_first_chunk CPU0 copy and return the unused part ffff880001f1f000 0x0. unit_size 122880 size sum 122880
(early) [    0.000000] free_early_partial 0x1f1f000-0x1f1f000
(early) [    0.000000] ------------[ cut here ]------------
(early) [    0.000000] WARNING: at /local/scratch/ianc/devel/kernels/linux-2.6/kernel/early_res.c:359 free_early_partial+0x46/0x15c()
(early) [    0.000000] Modules linked in:(early) 
(early) [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-x86_64-xenU-tip+ #119
(early) [    0.000000] Call Trace:
(early) [    0.000000]  [<ffffffff81b3938e>] ? free_early_partial+0x46/0x15c
(early) [    0.000000]  [<ffffffff81047317>] warn_slowpath_common+0x77/0xa4
(early) [    0.000000]  [<ffffffff81047353>] warn_slowpath_null+0xf/0x11
(early) [    0.000000]  [<ffffffff81b3938e>] free_early_partial+0x46/0x15c
(early) [    0.000000]  [<ffffffff81b29a05>] pcpu_fc_free+0x1f/0x23
(early) [    0.000000]  [<ffffffff81b3fcf1>] pcpu_embed_first_chunk+0x22f/0x363
(early) [    0.000000]  [<ffffffff81b299e6>] ? pcpu_fc_free+0x0/0x23
(early) [    0.000000]  [<ffffffff81b29a09>] ? pcpu_fc_alloc+0x0/0xa9
(early) [    0.000000]  [<ffffffff81b29825>] setup_per_cpu_areas+0x82/0x238
(early) [    0.000000]  [<ffffffff81b1eabc>] start_kernel+0x14b/0x3ab
(early) [    0.000000]  [<ffffffff81b1e2ba>] x86_64_start_reservations+0xa5/0xa9
(early) [    0.000000]  [<ffffffff81b21d61>] xen_start_kernel+0x52e/0x535
(early) [    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---

I'm seeing this in a Xen guest but I don't think it relates to Xen
specifically. The problem occurs when ai->unit_size == size_sum in
pcpu_embed_first_chunk(). It looks like I just got unlucky with the
various sizes of stuff coming out of pcpu_build_alloc_info().

It's also possible that the presence or absence of PSE is responsible,
since it impacts atom_size which feeds into alloc_size and has an impact
on all these calculations.

I was able to reproduce on native 32 bit by disabling PSE and
artificially increasing dyn_size.

(early) [    0.000000] pcpu_build_alloc_info initial max_upa/upa is 1
(early) [    0.000000] pcpu_build_alloc_info after expansion best_upa/upa is 1
(early) [    0.000000] reserve_early_without_check: 0x1ce3000-0x1ce4000 "BOOTMEM"
(early) [    0.000000] pcpu_build_alloc_info unit_size 122880 == alloc_size 122880 / upa 1
(early) [    0.000000] pcpu_embed_first_chunk size_sum = 122880
(early) [    0.000000] pcpu_embed_first_chunk  static_size   = 91304
(early) [    0.000000] pcpu_embed_first_chunk  reserved_size = 8192
(early) [    0.000000] pcpu_embed_first_chunk  dyn_size      = 23384
(early) [    0.000000] pcpu_embed_first_chunk unit_size 122880

I guess the arises from fb90ef93 "early_res: Add free_early_partial"
since I don't see any other changes in this area recently.

Following patch fixes this specific issue and adds a warning to catch
future potential errors of this type.

--- 
Subject: x86: do not free zero sized per cpu areas

This avoids an infinite loop in free_early_partial().

Add a warning to free_early_partial to catch future problems.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index ef6370b..89a3205 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -140,7 +140,8 @@ static void __init pcpu_fc_free(void *ptr, size_t size)
 #ifdef CONFIG_NO_BOOTMEM
 	u64 start = __pa(ptr);
 	u64 end = start + size;
-	free_early_partial(start, end);
+	if (start < end)
+		free_early_partial(start, end);
 #else
 	free_bootmem(__pa(ptr), size);
 #endif
diff --git a/kernel/early_res.c b/kernel/early_res.c
index 3cb2c66..fbde443 100644
--- a/kernel/early_res.c
+++ b/kernel/early_res.c
@@ -333,6 +333,8 @@ void __init free_early_partial(u64 start, u64 end)
 	struct early_res *r;
 	int i;
 
+	WARN_ON(start>=end);
+
 try_next:
 	i = find_overlapped_early(start, end);
 	if (i >= max_early_res)


