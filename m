Return-Path: <linux-kernel-owner+w=401wt.eu-S1756902AbZGOBWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902AbZGOBWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 21:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756859AbZGOBWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 21:22:21 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:50858 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855AbZGOBWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 21:22:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=HTVB6FeY7JrAVb2ZOfjdWbWEN9od5vHb6KmKdSLrHTCPMuezZMCNxgUkJ6P36RHkvP
         DqK5FNxwqa/QJc2v84+D35cJvE0gzStcENN1nmdoU604g7XWCRms3VfqpTOlTSNNVaGb
         DyH1XFG+dkP6bklg3mZ0hGhbfSSA5CMzNLcRw=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] add "VmUsers: N" to /proc/$PID/status
Date: Wed, 15 Jul 2009 03:22:18 +0200
User-Agent: KMail/1.8.2
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907150322.18123.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Was disscussed sometime ago: http://lkml.org/lkml/2007/8/27/53

This patch aims to improve memory usage info collection
from userspace. It addresses the problem when userspace
monitoring cannot determine when two (or more) processes
share the VM, but they are not threads.

In Linux, you can clone a process with CLONE_VM, but without
CLONE_THREAD, and as a result it will get new PID, and its own,
visible /proc/PID entry.

It creates a problem: userspace tools will think that this is
just another, separate process. There is no way it can
figure out that /proc/PID1 and /proc/PID2
correspond to two processes which share VM,
and if ir will sum memory usage over the whole of /proc/*,
it will count their memory usage twice.

It can be nice to know how many such CLONE_VM'ed processes
share VM with given /proc/PID. Then it would be possible to do
more accurate accounting of memory usage. Say, by dividing
all memory usage numbers of this process by this number.

After this patch, CLONE_VM'ed processes have a new line,
"VmUsers:", in /proc/$PID/status:
...
VmUsers:        2
Threads:        1
...

The value is obtained simply by atomic_read(&mm->mm_users).

One concern is that the counter may be larger
than real value, if other CPU did get_task_mm() on the VM
while we were generating /proc/$PID/status. Better ideas?


Test program is below:

#include <sched.h>
#include <sys/types.h>
#include <linux/unistd.h>
#include <errno.h>
#include <syscall.h>
/* Defeat glibc "pid caching" */
#define GETPID() ((int)syscall(SYS_getpid))
#define GETTID() ((int)syscall(SYS_gettid))
char stack[8*1024];
int f(void *arg) {
        printf("child %d (%d)\n", GETPID(),  GETTID());
        sleep(1000);
        _exit(0);
}
int main() {
        int n;
        memset(malloc(1234*1024), 1, 1234*1024);
        printf("parent %d (%d)\n", GETPID(), GETTID());
        // Create a process with shared VM, but not a thread
        n = clone(f, stack + sizeof(stack)/2, CLONE_VM, 0);
        printf("clone returned %d\n", n);
        sleep(1000);
        _exit(0);
}

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
-- 
vda


--- linux-2.6.31-rc2/fs/proc/task_mmu.c	Wed Jun 10 05:05:27 2009
+++ linux-2.6.31-rc2.VmUsers/fs/proc/task_mmu.c	Wed Jul 15 02:54:45 2009
@@ -18,6 +18,7 @@
 {
 	unsigned long data, text, lib;
 	unsigned long hiwater_vm, total_vm, hiwater_rss, total_rss;
+	unsigned num_vmusers;
 
 	/*
 	 * Note: to minimize their overhead, mm maintains hiwater_vm and
@@ -36,6 +37,7 @@
 	data = mm->total_vm - mm->shared_vm - mm->stack_vm;
 	text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK)) >> 10;
 	lib = (mm->exec_vm << (PAGE_SHIFT-10)) - text;
+	num_vmusers = atomic_read(&mm->mm_users) - 1;
 	seq_printf(m,
 		"VmPeak:\t%8lu kB\n"
 		"VmSize:\t%8lu kB\n"
@@ -46,7 +48,8 @@
 		"VmStk:\t%8lu kB\n"
 		"VmExe:\t%8lu kB\n"
 		"VmLib:\t%8lu kB\n"
-		"VmPTE:\t%8lu kB\n",
+		"VmPTE:\t%8lu kB\n"
+		"VmUsers:\t%u\n",
 		hiwater_vm << (PAGE_SHIFT-10),
 		(total_vm - mm->reserved_vm) << (PAGE_SHIFT-10),
 		mm->locked_vm << (PAGE_SHIFT-10),
@@ -54,7 +57,8 @@
 		total_rss << (PAGE_SHIFT-10),
 		data << (PAGE_SHIFT-10),
 		mm->stack_vm << (PAGE_SHIFT-10), text, lib,
-		(PTRS_PER_PTE*sizeof(pte_t)*mm->nr_ptes) >> 10);
+		(PTRS_PER_PTE*sizeof(pte_t)*mm->nr_ptes) >> 10,
+		num_vmusers);
 }
 
 unsigned long task_vsize(struct mm_struct *mm)
--- linux-2.6.31-rc2/fs/proc/task_nommu.c	Wed Jun 10 05:05:27 2009
+++ linux-2.6.31-rc2.VmUsers/fs/proc/task_nommu.c	Wed Jul 15 02:54:39 2009
@@ -20,7 +20,8 @@
 	struct vm_region *region;
 	struct rb_node *p;
 	unsigned long bytes = 0, sbytes = 0, slack = 0, size;
-        
+	unsigned num_vmusers;
+
 	down_read(&mm->mmap_sem);
 	for (p = rb_first(&mm->mm_rb); p; p = rb_next(p)) {
 		vma = rb_entry(p, struct vm_area_struct, vm_rb);
@@ -67,11 +68,14 @@
 
 	bytes += kobjsize(current); /* includes kernel stack */
 
+	num_vmusers = atomic_read(&mm->mm_users) - 1;
+
 	seq_printf(m,
 		"Mem:\t%8lu bytes\n"
 		"Slack:\t%8lu bytes\n"
-		"Shared:\t%8lu bytes\n",
-		bytes, slack, sbytes);
+		"Shared:\t%8lu bytes\n"
+		"VmUsers:\t%u\n",
+		bytes, slack, sbytes, num_vmusers);
 
 	up_read(&mm->mmap_sem);
 }
