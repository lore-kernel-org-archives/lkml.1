Return-Path: <linux-kernel-owner+w=401wt.eu-S1758899AbZDAGeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899AbZDAGeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 02:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755897AbZDAGeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 02:34:09 -0400
Received: from ozlabs.org ([203.10.76.45]:43822 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755864AbZDAGeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 02:34:08 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: 2.6.29 boot hang
Date: Wed, 1 Apr 2009 17:03:57 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       andreas.herrmann3@amd.com, Andrew Morton <akpm@linux-foundation.org>
References: <49D280EF.1080507@oracle.com> <200904011012.11527.rusty@rustcorp.com.au> <49D2F2D4.9090008@oracle.com>
In-Reply-To: <49D2F2D4.9090008@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904011703.58179.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 April 2009 15:21:32 Randy Dunlap wrote:
> Rusty Russell wrote:
> > On Wednesday 01 April 2009 07:15:35 Randy Dunlap wrote:
> >> On a 4-proc x86_64 (HP BladeCenter, AMD CPUs) system, booting 2.6.29
> >> (or earlier, back to 2.6.28-6921-g873392c) hangs during boot.
> >>
> >> git bisect says:
> >> 873392ca514f87eae39f53b6944caf85b1a047cb is first bad commit
> >> commit 873392ca514f87eae39f53b6944caf85b1a047cb
> >> Author: Rusty Russell <rusty@rustcorp.com.au>
> >> Date:   Wed Dec 31 23:54:56 2008 +1030
> >>
> >>     PCI: work_on_cpu: use in drivers/pci/pci-driver.c
> > 
> > ...
> > 
> >> If I change CONFIG_MICROCODE_AMD=y to CONFIG_MICROCODE_AMD=n & rebuild,
> >> the kernel boots successfully.
> > 
> > How very very odd.  My first thought was a deadlock with keventd used
> > by work_on_cpu (changed in latest Linus tree), but the microcode code at
> > that version doesn't use work_on_cpu.
> 
> Yep, I thought it a bit odd also.
> 
> > So I don't think that's it, but this patch should canonically eliminate it:
> > 
> > Subject: work_on_cpu(): rewrite it to create a kernel thread on demand
> > From: Andrew Morton <akpm@linux-foundation.org>
> 
> This patch doesn't apply to 2.6.29-final, but it does apply to 2.6.29-git8,

Err, it has 14 line offset.  But here's an adjusted one.

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 1f0c509..08bd795 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -971,20 +971,20 @@ undo:
 }
 
 #ifdef CONFIG_SMP
-static struct workqueue_struct *work_on_cpu_wq __read_mostly;
 
 struct work_for_cpu {
-	struct work_struct work;
+	struct completion completion;
 	long (*fn)(void *);
 	void *arg;
 	long ret;
 };
 
-static void do_work_for_cpu(struct work_struct *w)
+static int do_work_for_cpu(void *_wfc)
 {
-	struct work_for_cpu *wfc = container_of(w, struct work_for_cpu, work);
-
+	struct work_for_cpu *wfc = _wfc;
 	wfc->ret = wfc->fn(wfc->arg);
+	complete(&wfc->completion);
+	return 0;
 }
 
 /**
@@ -995,17 +995,23 @@ static void do_work_for_cpu(struct work_struct *w)
  *
  * This will return the value @fn returns.
  * It is up to the caller to ensure that the cpu doesn't go offline.
+ * The caller must not hold any locks which would prevent @fn from completing.
  */
 long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
 {
-	struct work_for_cpu wfc;
-
-	INIT_WORK(&wfc.work, do_work_for_cpu);
-	wfc.fn = fn;
-	wfc.arg = arg;
-	queue_work_on(cpu, work_on_cpu_wq, &wfc.work);
-	flush_work(&wfc.work);
-
+	struct task_struct *sub_thread;
+	struct work_for_cpu wfc = {
+		.completion = COMPLETION_INITIALIZER_ONSTACK(wfc.completion),
+		.fn = fn,
+		.arg = arg,
+	};
+
+	sub_thread = kthread_create(do_work_for_cpu, &wfc, "work_for_cpu");
+	if (IS_ERR(sub_thread))
+		return PTR_ERR(sub_thread);
+	kthread_bind(sub_thread, cpu);
+	wake_up_process(sub_thread);
+	wait_for_completion(&wfc.completion);
 	return wfc.ret;
 }
 EXPORT_SYMBOL_GPL(work_on_cpu);
@@ -1021,8 +1027,4 @@ void __init init_workqueues(void)
 	hotcpu_notifier(workqueue_cpu_callback, 0);
 	keventd_wq = create_workqueue("events");
 	BUG_ON(!keventd_wq);
-#ifdef CONFIG_SMP
-	work_on_cpu_wq = create_workqueue("work_on_cpu");
-	BUG_ON(!work_on_cpu_wq);
-#endif
 }
