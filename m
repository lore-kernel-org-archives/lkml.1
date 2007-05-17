Return-Path: <linux-kernel-owner+w=401wt.eu-S1756944AbXEQQYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944AbXEQQYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 12:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755555AbXEQQYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 12:24:35 -0400
Received: from as4.cineca.com ([130.186.84.213]:43209 "EHLO as4.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755472AbXEQQYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 12:24:35 -0400
Message-ID: <464C81B5.8070101@users.sourceforge.net>
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.3) Gecko/20070326 Thunderbird/2.0.0.0 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: [RFC] log out-of-virtual-memory events
X-Enigmail-Version: 0.95.0
OpenPGP: id=77CEF397;
	url=keyserver.veridis.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Date: Thu, 17 May 2007 18:24:28 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm looking for a way to keep track of the processes that fail to allocate new
virtual memory. What do you think about the following approach (untested)?

--

Print informations about the processes that fail to allocate virtual memory.

Signed-off-by: Andrea Righi <a.righi@cineca.it>

diff -urpN linux-2.6.21/mm/mmap.c linux-2.6.21-vm-log-enomem/mm/mmap.c
--- linux-2.6.21/mm/mmap.c	2007-04-26 05:08:32.000000000 +0200
+++ linux-2.6.21-vm-log-enomem/mm/mmap.c	2007-05-17 18:05:39.000000000 +0200
@@ -77,6 +77,26 @@ int sysctl_max_map_count __read_mostly =
 atomic_t vm_committed_space = ATOMIC_INIT(0);
 
 /*
+ * Print current process informations when it fails to allocate new virtual
+ * memory.
+ */
+static inline void log_vm_enomem(void)
+{
+	unsigned long total_vm = 0;
+	struct mm_struct *mm;
+
+	task_lock(current);
+	mm = current->mm;
+	if (mm)
+		total_vm = mm->total_vm;
+	task_unlock(current);
+
+	printk(KERN_INFO
+	       "out of virtual memory for process %d (%s): total_vm=%lu, uid=%d\n",
+	       current->pid, current->comm, total_vm, current->uid);
+}
+
+/*
  * Check that a process has enough memory to allocate a new virtual
  * mapping. 0 means there is enough memory for the allocation to
  * succeed and -ENOMEM implies there is not.
@@ -175,6 +195,7 @@ int __vm_enough_memory(long pages, int c
 		return 0;
 error:
 	vm_unacct_memory(pages);
+	log_vm_enomem();
 
 	return -ENOMEM;
 }
