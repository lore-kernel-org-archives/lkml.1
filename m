Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbZIAMa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbZIAMa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 08:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbZIAMa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 08:30:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:60776 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837AbZIAMaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 08:30:55 -0400
Message-ID: <4A9D13F0.7010504@kernel.org>
Date: Tue, 01 Sep 2009 21:30:40 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Meelis Roos <mroos@linux.ee>
CC: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH] percpu: don't assume existence of cpu0
References: <Pine.SOC.4.64.0908311646150.20934@math.ut.ee> <20090831.142215.111904849.davem@davemloft.net> <Pine.SOC.4.64.0909011003460.10184@math.ut.ee> <4A9CC9E9.2070609@kernel.org> <4A9CCD92.4090909@kernel.org> <Pine.SOC.4.64.0909011032350.10835@math.ut.ee> <4A9CD41C.8060604@kernel.org> <Pine.SOC.4.64.0909011437270.20321@math.ut.ee>
In-Reply-To: <Pine.SOC.4.64.0909011437270.20321@math.ut.ee>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 01 Sep 2009 12:30:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

percpu incorrectly assumed that cpu0 was always there which led to the
following warning and eventual oops on sparc machines w/o cpu0.

  WARNING: at mm/percpu.c:651 pcpu_map+0xdc/0x100()
  Modules linked in:
  Call Trace:
    [000000000045eb70] warn_slowpath_common+0x50/0xa0
    [000000000045ebdc] warn_slowpath_null+0x1c/0x40
    [00000000004d493c] pcpu_map+0xdc/0x100
    [00000000004d59a4] pcpu_alloc+0x3e4/0x4e0
    [00000000004d5af8] __alloc_percpu+0x18/0x40
    [00000000005b112c] __percpu_counter_init+0x4c/0xc0
  ...
  Unable to handle kernel NULL pointer dereference
  ...
   I7: <sysfs_new_dirent+0x30/0x120>
   Disabling lock debugging due to kernel taint
   Caller[000000000053c1b0]: sysfs_new_dirent+0x30/0x120
   Caller[000000000053c7a4]: create_dir+0x24/0xc0
   Caller[000000000053c870]: sysfs_create_dir+0x30/0x80
   Caller[00000000005990e8]: kobject_add_internal+0xc8/0x200
  ...
   Kernel panic - not syncing: Attempted to kill the idle task!

This patch fixes the problem by backporting parts from devel branch to
make percpu core not depend on the existence of cpu0.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Meelis Roos <mroos@linux.ee>
Cc: David Miller <davem@davemloft.net>
---
Meelis Roos wrote:
>> Aha...  Does the following patch fix the problem?
> 
> Yes, yesterdays 2.6.31-rc8-git plus this patch seems to work fine, no 
> warnings/oopses/panics. It is happily churning on debian unstable 
> upgrade now.

Good to hear.  Will forward to Linus right away.  Thanks.

 mm/percpu.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 5fe3784..3311c89 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -197,7 +197,12 @@ static unsigned long pcpu_chunk_addr(struct pcpu_chunk *chunk,
 static bool pcpu_chunk_page_occupied(struct pcpu_chunk *chunk,
 				     int page_idx)
 {
-	return *pcpu_chunk_pagep(chunk, 0, page_idx) != NULL;
+	/*
+	 * Any possible cpu id can be used here, so there's no need to
+	 * worry about preemption or cpu hotplug.
+	 */
+	return *pcpu_chunk_pagep(chunk, raw_smp_processor_id(),
+				 page_idx) != NULL;
 }

 /* set the pointer to a chunk in a page struct */
@@ -297,6 +302,14 @@ static struct pcpu_chunk *pcpu_chunk_addr_search(void *addr)
 		return pcpu_first_chunk;
 	}

+	/*
+	 * The address is relative to unit0 which might be unused and
+	 * thus unmapped.  Offset the address to the unit space of the
+	 * current processor before looking it up in the vmalloc
+	 * space.  Note that any possible cpu id can be used here, so
+	 * there's no need to worry about preemption or cpu hotplug.
+	 */
+	addr += raw_smp_processor_id() * pcpu_unit_size;
 	return pcpu_get_page_chunk(vmalloc_to_page(addr));
 }

-- 
1.6.0.2

