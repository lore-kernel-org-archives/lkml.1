Return-Path: <linux-kernel-owner+w=401wt.eu-S1753126AbZG3Vdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbZG3Vdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 17:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbZG3Vdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 17:33:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56122 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616AbZG3Vds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 17:33:48 -0400
Date: Thu, 30 Jul 2009 23:29:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: Possible memory leak via alloc_pid()
Message-ID: <20090730212956.GA26863@redhat.com>
References: <b0943d9e0907081433y599e6d51j285c390f18d7b32c@mail.gmail.com> <20090729170315.f62066c0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090729170315.f62066c0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29, Andrew Morton wrote:
>
> On Wed, 8 Jul 2009 22:33:31 +0100
> Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> > Hi,
> >
> > There's a kmemleak report of a struct pid allocation in alloc_pid()
> > which somehow gets lost:
> >
> > unreferenced object 0xc307aa00 (size 44):
> >   comm "gdm", pid 2734, jiffies 4294902040
> >   backtrace:
> >     [<c01e721a>] create_object+0xfa/0x250
> >     [<c01e73cd>] kmemleak_alloc+0x5d/0x70
> >     [<c01e0ad6>] kmem_cache_alloc+0x156/0x1a0
> >     [<c01552f9>] alloc_pid+0x19/0x350
> >     [<c013e6e0>] copy_process+0x800/0x1230
> >     [<c013f17f>] do_fork+0x6f/0x370
> >     [<c0101986>] sys_clone+0x36/0x40
> >     [<c010319c>] sysenter_do_call+0x12/0x38
> >     [<ffffffff>] 0xffffffff
> >
> > This is the gdm fork for starting Xorg (with pid 2739). It first
> > logged me in automatically, after which I logged out and gdm started
> > another Xorg. The pid structure for the first Xorg is reported as a
> > leak. The Xorg with pid 2739 is no longer present on my system.
> >
> > Using gdb vmlinux /proc/kcore shows that the pid->count is 2, so
> > that's why it probably wasn't freed by put_pid():
> >
> > (gdb) print ({struct pid}0xc307aa00)
> > $20 = {count = {counter = 2}, level = 0, tasks = {{first = 0x0}, {
> >       first = 0x0}, {first = 0x0}}, rcu = {next = 0xc24bfd64,
> >     func = 0xc0154e90 <delayed_put_pid>}, numbers = {{nr = 2739,
> >       ns = 0xc0737540, pid_chain = {next = 0x0, pprev = 0x200200}}}}
> >
> > Note that kmemleak is aware of and scans pid_hash (which was recorded
> > in kmemleak as a 16KB object).

This pid is detached and unhanshed. God knows who did the unbalanced
get_pid().

Since you can reproduce the problem easily, perhaps you can use the
hack above to track get/put ?

	$ echo pid_of_Xorg > /proc/sys/kernel/xxx

Oleg.

--- CPUHP/kernel/sysctl.c~TRACK_PID	2009-06-28 18:14:27.000000000 +0200
+++ CPUHP/kernel/sysctl.c	2009-07-30 23:12:43.000000000 +0200
@@ -244,6 +244,10 @@ static int min_wakeup_granularity_ns;			
 static int max_wakeup_granularity_ns = NSEC_PER_SEC;	/* 1 second */
 #endif
 
+extern int xxx_pid;
+int set_xxx_pid(struct ctl_table *, int, struct file *,
+				void __user *, size_t *, loff_t *);
+
 static struct ctl_table kern_table[] = {
 #ifdef CONFIG_SCHED_DEBUG
 	{
@@ -989,7 +993,15 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
-
+	{
+		.ctl_name	= 666,
+		.procname	= "xxx",
+		.data		= &xxx_pid,
+		.maxlen		= sizeof (int),
+		.mode		= 0666,
+		.proc_handler	= &set_xxx_pid,
+		.strategy	= sysctl_intvec,
+	},
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt
--- CPUHP/include/linux/pid.h~TRACK_PID	2009-04-06 00:03:41.000000000 +0200
+++ CPUHP/include/linux/pid.h	2009-07-30 23:10:32.000000000 +0200
@@ -57,6 +57,7 @@ struct upid {
 struct pid
 {
 	atomic_t count;
+	int trackme;
 	unsigned int level;
 	/* lists of tasks that use this pid */
 	struct hlist_head tasks[PIDTYPE_MAX];
@@ -74,8 +75,14 @@ struct pid_link
 
 static inline struct pid *get_pid(struct pid *pid)
 {
-	if (pid)
+	if (pid) {
+		if (pid->trackme) {
+			printk(KERN_INFO "XXXXX(%d) ++%d\n",
+				pid->numbers[0].nr, atomic_read(&pid->count));
+			dump_stack();
+		}
 		atomic_inc(&pid->count);
+	}
 	return pid;
 }
 
--- CPUHP/kernel/pid.c~TRACK_PID	2009-07-13 17:39:44.000000000 +0200
+++ CPUHP/kernel/pid.c	2009-07-30 23:12:05.000000000 +0200
@@ -207,6 +207,12 @@ void put_pid(struct pid *pid)
 	if (!pid)
 		return;
 
+	if (pid->trackme) {
+		printk(KERN_INFO "XXXXX(%d) --%d\n",
+			pid->numbers[0].nr, atomic_read(&pid->count));
+		dump_stack();
+	}
+
 	ns = pid->numbers[pid->level].ns;
 	if ((atomic_read(&pid->count) == 1) ||
 	     atomic_dec_and_test(&pid->count)) {
@@ -250,6 +256,7 @@ struct pid *alloc_pid(struct pid_namespa
 	pid = kmem_cache_alloc(ns->pid_cachep, GFP_KERNEL);
 	if (!pid)
 		goto out;
+	pid->trackme = 0;
 
 	tmp = ns;
 	for (i = ns->level; i >= 0; i--) {
@@ -491,6 +498,30 @@ struct pid *find_ge_pid(int nr, struct p
 	return pid;
 }
 
+int xxx_pid;
+
+int set_xxx_pid(ctl_table *table, int write, struct file *file,
+		void __user *buffer, size_t *length, loff_t *ppos)
+{
+	struct pid *pid;
+
+	proc_dointvec_minmax(table, write, file, buffer, length, ppos);
+	if (!write)
+		return 0;
+
+	rcu_read_lock();
+	pid = find_vpid(xxx_pid);
+	if (pid) {
+		printk(KERN_INFO "XXXXX(%d) ==%d\n", xxx_pid, atomic_read(&pid->count));
+		pid->trackme = 1;
+	} else {
+		printk(KERN_INFO "XXXXX(%d) not found\n", xxx_pid);
+	}
+	rcu_read_unlock();
+
+	return 0;
+}
+
 /*
  * The pid hash table is scaled according to the amount of memory in the
  * machine.  From a minimum of 16 slots up to 4096 slots at one gigabyte or

