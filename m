Return-Path: <linux-kernel-owner+w=401wt.eu-S1762122AbXGKSAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762122AbXGKSAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 14:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754469AbXGKR75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 13:59:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552AbXGKR74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 13:59:56 -0400
Message-ID: <46951A98.5060107@redhat.com>
Date: Wed, 11 Jul 2007 19:59:52 +0200
From: Michal Schmidt <mschmidt@redhat.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070622)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: destroy_workqueue can livelock
Content-Type: multipart/mixed;
 boundary="------------060303010607020402090906"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060303010607020402090906
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit

Hi,

While using SystemTap I noticed an interesting situation. When my stap
probe was exiting, there was a several seconds long delay, during which
the CPU was 100% loaded. I narrowed the problem down to destroy_workqueue.

The attached module is a minimized testcase. To reproduce it, load the
module and then try to rmmod it from a higher priority process:
 nice -n -10 rmmod wqtest.ko  # that's how SystemTap's staprun behaves
or:
 chrt -f  90 rmmod wqtest.ko  # this may be more reliably reproducible

I tested it (with "nice") on Linux 2.6.22. The rmmod process took about
55% CPU, the workqueue thread consumed the rest. This situation can last
for minutes. As soon as the rmmod process is reniced to 0, the workqueue
is destroyed successfully and the module is unloaded.

Here's what happens in detail:

When rmmod executes cancel_rearming_delayed_workqueue() ->
wait_on_work() -> wait_on_cpu_work(), the work is the current_work on
the workqueue (it's in ssleep(1)). So wait_on_cpu_work() inserts a
wq_barrier on the workqueue and waits for the completion. As soon as
wq_barrier_func signals the completion, it is most likely preempted by
the rmmod process. At this moment, the worklist is already empty, but
cwq->current_work still points to the barrier. run_workqueue() didn't
get to reset it to NULL yet.

Now rmmod calls destroy_workqueue() -> cleanup_workqueue_thread() ->
flush_cpu_workqueue(). Because cwq->current_work!=NULL it decides to
insert another wq_barrier and wait for it to complete. But
cwq->current_work will never be reset to NULL, so
cleanup_workqueue_thread() keeps trying flush_cpu_workqueue()
indefinitely, inserting wq_barriers and waiting for them.

If rmmod's priority is lowered, run_workqueue() will not be preempted by
it and manages to reset cwq->current_work. This ends the livelock.

Can this be fixed? Or is it just a case of "Don't do that then!"?
("that" meaning destroying workqueues from negatively reniced processes)

Michal

--------------060303010607020402090906
Content-Type: text/x-csrc;
 name="wqtest.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="wqtest.c"

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/workqueue.h>
#include <linux/delay.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Michal Schmidt");

static void wq_func(struct work_struct *w);
static DECLARE_DELAYED_WORK(wq_work, wq_func);
static struct workqueue_struct *wq;

static DECLARE_WAIT_QUEUE_HEAD(ctl_wq);

static void wq_func(struct work_struct *w)
{
	/*
	 * So that this work is most likely cwq->current_work
	 * when destroy_workqueue comes...
	 */
	ssleep(1);

	queue_delayed_work(wq, &wq_work, HZ/100);
}

static int wqtest_start(void)
{
	wq = create_workqueue("wqtest");
	if (!wq)
		return -1;

	queue_delayed_work(wq, &wq_work, HZ/100);

	return 0;
}

static void wqtest_stop(void)
{
	printk(KERN_CRIT "wqtest: cancelling the work\n");
	cancel_rearming_delayed_work(&wq_work);
	printk(KERN_CRIT "wqtest: destroying the wq\n");
	destroy_workqueue(wq);
	printk(KERN_CRIT "wqtest: done\n");
}

module_init(wqtest_start);
module_exit(wqtest_stop);


--------------060303010607020402090906--
