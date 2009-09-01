Return-Path: <linux-kernel-owner+w=401wt.eu-S1755109AbZIAQ6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109AbZIAQ6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 12:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755058AbZIAQ6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 12:58:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438AbZIAQ6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 12:58:12 -0400
Date: Tue, 1 Sep 2009 18:52:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: arjan@infradead.org, jeremy@goop.org, mschmidt@redhat.com,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tj@kernel.org, tglx@linutronix.de,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-tip-commits@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 0/1] kthreads: simplify !kthreadd_task logic, kill
	kthreadd_task_init_done
Message-ID: <20090901165235.GA9105@redhat.com>
References: <20090829182718.10f566b1@leela> <tip-23386d63bbb3199cf247313ec088878d72debcfd@git.kernel.org> <20090901100351.GA3361@elte.hu> <20090901113914.GA23578@elte.hu> <20090901130436.GA22514@redhat.com> <20090901131440.GA29783@elte.hu> <20090901133709.GA24041@redhat.com> <20090901135925.GA9083@elte.hu> <20090901145526.GA31317@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090901145526.GA31317@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01, Oleg Nesterov wrote:
>
> On 09/01, Ingo Molnar wrote:
> >
> > * Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > > On 09/01, Ingo Molnar wrote:
> > > >
> > > > * Oleg Nesterov <oleg@redhat.com> wrote:
> > > >
> > > > > Yes, this should work. But I _think_ we can make the better fix...
> > > > >
> > > > > I'll try to make the patch soon. Afaics we don't need
> > > > > kthreadd_task_init_done.
> > > >
> > > > ok.
> > >
> > > Just in case, the patch is ready. [...]
> >
> > yes - that's roughly the cleanup i referred to in the commit log.
> >
> > way too late for -rc8 though - the minimal fix i did _might_ be
> > eligible.
> >
> > agreed?
>
> Agreed. Then I will sent the patch on top of this change.

OK, I am sending the patch on top of your fix. Not sure how to really
test it, but at least the kernel works when I apply the debugging patch
below on top.

Oleg.

--- WAIT/init/main.c~DBG	2009-09-01 15:49:36.000000000 +0200
+++ WAIT/init/main.c	2009-09-01 17:53:28.000000000 +0200
@@ -455,7 +455,6 @@ static noinline void __init_refok rest_i
 {
 	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
 	numa_default_policy();
-	kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
 	unlock_kernel();
 
 	/*
@@ -466,6 +465,12 @@ static noinline void __init_refok rest_i
 	rcu_scheduler_starting();
 	preempt_enable_no_resched();
 	schedule();
+
+	printk(KERN_INFO "XXX rest_init - sleeeeep\n");
+//	schedule_timeout_interruptible(HZ);
+	kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
+	printk(KERN_INFO "XXX rest_init - kthreadd started\n");
+
 	preempt_disable();
 
 	/* Call into cpu_idle with preempt disabled */
@@ -877,10 +882,18 @@ static noinline int init_post(void)
 	panic("No init found.  Try passing init= option to kernel.");
 }
 
+int ktfunc(void *arg)
+{
+	printk(KERN_INFO "XXX ktfunc - alive!\n");
+	return 0;
+}
+
 static int __init kernel_init(void * unused)
 {
 	lock_kernel();
 
+	printk(KERN_INFO "XXX kernel_init - call kthread_run, kthreadd=%p\n", kthreadd_task);
+	kthread_run(ktfunc, NULL, "xxx");
 	/*
 	 * init can allocate pages on any node
 	 */

