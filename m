Return-Path: <linux-kernel-owner+w=401wt.eu-S937765AbXHGWet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937765AbXHGWet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933649AbXHGWdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 18:33:11 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:39858 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757262AbXHGWdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 18:33:05 -0400
Subject: [RFC][PATCH 3/5] pagemap: remove open-coded sizeof(unsigned long)
To: mpm@selenic.com
Cc: linux-kernel@vger.kernel.org, serue@us.ibm.com,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Tue, 07 Aug 2007 15:33:02 -0700
References: <20070807223300.9228E0E0@kernel>
In-Reply-To: <20070807223300.9228E0E0@kernel>
Message-Id: <20070807223302.B275F4FC@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I think the code gets easier to read when we give symbolic names
to some of the operations we're performing.  I was sure we needed
this when I saw the header being built like this:

	...
	buf[2] = sizeof(unsigned long)
	buf[3] = sizeof(unsigned long)

I really couldn't remember what either field did ;(

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/proc/task_mmu.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN fs/proc/task_mmu.c~pagemap-use-ENTRY_SIZE fs/proc/task_mmu.c
--- lxc/fs/proc/task_mmu.c~pagemap-use-ENTRY_SIZE	2007-08-07 15:30:53.000000000 -0700
+++ lxc-dave/fs/proc/task_mmu.c	2007-08-07 15:30:53.000000000 -0700
@@ -560,14 +560,15 @@ struct pagemapread {
 	unsigned long __user *out;
 };
 
+#define PAGEMAP_ENTRY_SIZE_BYTES sizeof(unsigned long)
+
 static int add_to_pagemap(unsigned long addr, unsigned long pfn,
 			  struct pagemapread *pm)
 {
 	__put_user(pfn, pm->out);
 	pm->out++;
-	pm->pos += sizeof(unsigned long);
-	pm->count -= sizeof(unsigned long);
-	pm->next = addr + PAGE_SIZE;
+	pm->pos += PAGEMAP_ENTRY_SIZE_BYTES;
+	pm->count -= PAGEMAP_ENTRY_SIZE_BYTES;
 	return 0;
 }
 
@@ -653,13 +654,13 @@ static ssize_t pagemap_read(struct file 
 		goto out;
 
 	ret = -EIO;
-	svpfn = src / sizeof(unsigned long);
+	svpfn = src / PAGEMAP_ENTRY_SIZE_BYTES;
 	addr = PAGE_SIZE * svpfn;
-	if (svpfn * sizeof(unsigned long) != src)
+	if (svpfn * PAGEMAP_ENTRY_SIZE_BYTES != src)
 		goto out;
 	evpfn = min((src + count) / sizeof(unsigned long),
 		    ((~0UL) >> PAGE_SHIFT) + 1);
-	count = (evpfn - svpfn) * sizeof(unsigned long);
+	count = (evpfn - svpfn) * PAGEMAP_ENTRY_SIZE_BYTES;
 	end = PAGE_SIZE * evpfn;
 	//printk("src %ld svpfn %d evpfn %d count %d\n", src, svpfn, evpfn, count);
 
_
