Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744AbZHCLVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbZHCLVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 07:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbZHCLVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 07:21:24 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60432 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421AbZHCLVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 07:21:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 3 Aug 2009 20:19:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mike Smith <scgtrp@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       Amerigo Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Subject: [BUGFIX][PATCH 3/3] kcore: /proc/kcore should use vread
Message-Id: <20090803201937.2a7de358.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090803201418.040bb3ee.kamezawa.hiroyu@jp.fujitsu.com>
References: <bug-13850-10286@http.bugzilla.kernel.org/>
	<20090728160527.1da52682.akpm@linux-foundation.org>
	<20090729084825.1363c880.kamezawa.hiroyu@jp.fujitsu.com>
	<525c5a6c0907281946t249ef288v77ee94edd16f054@mail.gmail.com>
	<20090803201418.040bb3ee.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

/proc/kcore has its own routine to access vmallc area. It can be replaced
with vread(). And by this, /proc/kcore can do safe access to vmalloc area.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
---
 fs/proc/kcore.c |   35 ++---------------------------------
 1 file changed, 2 insertions(+), 33 deletions(-)

Index: linux-2.6.31-rc5/fs/proc/kcore.c
===================================================================
--- linux-2.6.31-rc5.orig/fs/proc/kcore.c	2009-08-03 19:50:58.000000000 +0900
+++ linux-2.6.31-rc5/fs/proc/kcore.c	2009-08-03 19:56:01.000000000 +0900
@@ -328,43 +328,12 @@
 				return -EFAULT;
 		} else if (is_vmalloc_addr((void *)start)) {
 			char * elf_buf;
-			struct vm_struct *m;
-			unsigned long curstart = start;
-			unsigned long cursize = tsz;
 
 			elf_buf = kzalloc(tsz, GFP_KERNEL);
 			if (!elf_buf)
 				return -ENOMEM;
-
-			read_lock(&vmlist_lock);
-			for (m=vmlist; m && cursize; m=m->next) {
-				unsigned long vmstart;
-				unsigned long vmsize;
-				unsigned long msize = m->size - PAGE_SIZE;
-
-				if (((unsigned long)m->addr + msize) < 
-								curstart)
-					continue;
-				if ((unsigned long)m->addr > (curstart + 
-								cursize))
-					break;
-				vmstart = (curstart < (unsigned long)m->addr ? 
-					(unsigned long)m->addr : curstart);
-				if (((unsigned long)m->addr + msize) > 
-							(curstart + cursize))
-					vmsize = curstart + cursize - vmstart;
-				else
-					vmsize = (unsigned long)m->addr + 
-							msize - vmstart;
-				curstart = vmstart + vmsize;
-				cursize -= vmsize;
-				/* don't dump ioremap'd stuff! (TA) */
-				if (m->flags & VM_IOREMAP)
-					continue;
-				memcpy(elf_buf + (vmstart - start),
-					(char *)vmstart, vmsize);
-			}
-			read_unlock(&vmlist_lock);
+			vread(elf_buf, (char *)start, tsz);
+			/* we have to zero-fill user buffer even if no read */
 			if (copy_to_user(buffer, elf_buf, tsz)) {
 				kfree(elf_buf);
 				return -EFAULT;

