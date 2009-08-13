Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbZHMOpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbZHMOpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 10:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbZHMOpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 10:45:03 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:42351 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753942AbZHMOpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 10:45:02 -0400
Subject: Re: kmemleak: Protect the seq start/next/stop sequence
	byrcu_read_lock()
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090813094437.GB22762@elte.hu>
References: <20090812205215.GA21451@elte.hu>
	 <1250115375.11496.25.camel@pc1117.cambridge.arm.com>
	 <20090813065253.GC12143@elte.hu>
	 <1250156396.13180.24.camel@pc1117.cambridge.arm.com>
	 <20090813094437.GB22762@elte.hu>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 13 Aug 2009 15:44:40 +0100
Message-Id: <1250174680.14019.24.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Aug 2009 14:44:41.0241 (UTC) FILETIME=[9711D890:01CA1C24]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-13 at 11:44 +0200, Ingo Molnar wrote:
> i still have the full crashlog (attached below) - you can see all 
> the mappings (and other details) in that.
> 
> It's a fairly regular whitebox PC with 1GB of RAM:
> 
> [    0.000000] initial memory mapped : 0 - 20000000
> [    0.000000] init_memory_mapping: 0000000000000000-000000003fff0000
> [    0.000000]  0000000000 - 003fe00000 page 2M
> [    0.000000]  003fe00000 - 003fff0000 page 4k
> [    0.000000] kernel direct mapping tables up to 3fff0000 @ 10000-13000

So the kmemleak fault address 0020000000 should be valid. Is this true
for all contexts? A later message in the log shows this:

> [    0.000000] Mapping aperture over 65536 KB of RAM @ 20000000

This comes from allocate_aperture() in arch/x86/kernel/aperture_64.c.
Does it mean that the kernel direct mapping at 0x20000000 may be
unmapped? Or is it initially mapped and unmapped later, possibly when
kmemleak is scanning the memory?

Since now kmemleak tracks alloc_bootmem() blocks, it will scan the
aperture above as well. An annotation would tell kmemleak to ignore it:

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 676debf..cb690b3 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -94,6 +94,11 @@ static u32 __init allocate_aperture(void)
 	 * code for safe
 	 */
 	p = __alloc_bootmem_nopanic(aper_size, aper_size, 512ULL<<20);
+	/*
+	 * Kmemleak should not scan this block as it may not be mapped via the
+	 * kernel direct mapping.
+	 */
+	kmemleak_ignore(p);
 	if (!p || __pa(p)+aper_size > 0xffffffff) {
 		printk(KERN_ERR
 			"Cannot allocate aperture memory hole (%p,%uK)\n",

We could as well use kmemleak_no_scan(p) instead of kmemleak_ignore().

Could you please let me know if the patch solves the page fault?

Thanks.

-- 
Catalin

