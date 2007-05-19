Return-Path: <linux-kernel-owner+w=401wt.eu-S1763861AbXESKeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763861AbXESKeT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 06:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757528AbXESKeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 06:34:06 -0400
Received: from as3.cineca.com ([130.186.84.211]:49838 "EHLO as3.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758423AbXESKeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 06:34:04 -0400
Message-ID: <464ED292.8020202@users.sourceforge.net>
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.3) Gecko/20070326 Thunderbird/2.0.0.0 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Bernd Eckenfels <ecki@lina.inka.de>
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
       linux-mm@kvack.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] log out-of-virtual-memory events (was: [RFC] log out-of-virtual-memory
 events)
References: <E1Hp5RZ-0001CF-00@calista.eckenfels.net>
In-Reply-To: <E1Hp5RZ-0001CF-00@calista.eckenfels.net>
X-Enigmail-Version: 0.95.0
OpenPGP: id=77CEF397;
	url=keyserver.veridis.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Date: Sat, 19 May 2007 12:34:01 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Eckenfels wrote:
> In article <464DCC52.7090403@users.sourceforge.net> you wrote:
>> +       printk(KERN_INFO
>> +              "out of virtual memory for process %d (%s): total_vm=%lu, uid=%d\n",
>> +               current->pid, current->comm, total_vm, current->uid);
> 
> And align this one with the print_fatal layout:
> 
>        printk(KERN_WARNING
>               "%s/%d process cannot request more virtual memory: total_vm=%lu, uid=%d\n",
>                current->comm, current->pid, total_vm, current->uid);
> 

Depends on print_fatal_signals patch.

---

Print informations about userspace processes that fail to allocate new virtual
memory.

Signed-off-by: Andrea Righi <a.righi@cineca.it>

diff -urpN linux-2.6.22-rc1-mm1/mm/mmap.c linux-2.6.22-rc1-mm1-vm-log-enomem/mm/mmap.c
--- linux-2.6.22-rc1-mm1/mm/mmap.c	2007-05-19 11:25:24.000000000 +0200
+++ linux-2.6.22-rc1-mm1-vm-log-enomem/mm/mmap.c	2007-05-19 11:55:05.000000000 +0200
@@ -77,6 +77,31 @@ int sysctl_overcommit_ratio = 50;	/* def
 int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
 atomic_t vm_committed_space = ATOMIC_INIT(0);
 
+extern int print_fatal_signals;
+
+/*
+ * Print current process informations when it fails to allocate new virtual
+ * memory.
+ */
+static inline void log_vm_enomem(void)
+{
+	unsigned long total_vm = 0;
+	struct mm_struct *mm;
+
+	if (unlikely(!printk_ratelimit()))
+		return;
+
+	task_lock(current);
+	mm = current->mm;
+	if (mm)
+		total_vm = mm->total_vm;
+	task_unlock(current);
+
+	printk(KERN_WARNING
+	       "%s/%d process cannot request more virtual memory: total_vm=%lu, uid=%d\n",
+	       current->comm, current->pid, total_vm, current->uid);
+}
+
 /*
  * Check that a process has enough memory to allocate a new virtual
  * mapping. 0 means there is enough memory for the allocation to
@@ -177,6 +202,9 @@ int __vm_enough_memory(long pages, int c
 error:
 	vm_unacct_memory(pages);
 
+	if (print_fatal_signals)
+		log_vm_enomem();
+
 	return -ENOMEM;
 } 
