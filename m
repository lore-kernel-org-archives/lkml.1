Return-Path: <linux-kernel-owner+w=401wt.eu-S1752534AbZAEC2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbZAEC2u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 21:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbZAEC2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 21:28:41 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:47839 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbZAEC2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 21:28:40 -0500
Date: Sun, 4 Jan 2009 18:28:27 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Sesterhenn <snakebyte@gmx.de>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, josh@freedesktop.org, dipankar@in.ibm.com
Subject: Re: [BUG] NULL pointer deref with rcutorture
Message-ID: <20090105022827.GA8080@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090102175853.GC6842@linux.vnet.ibm.com> <20090102185303.GC5743@linux.vnet.ibm.com> <20090102195326.GF6842@linux.vnet.ibm.com> <20090102231239.GA19778@alice> <20090103015748.GL6842@linux.vnet.ibm.com> <20090103094003.GA6149@alice> <20090104013254.GG6958@linux.vnet.ibm.com> <20090104145726.GA14895@alice> <20090104211349.GS6958@linux.vnet.ibm.com> <20090104233855.GA17021@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090104233855.GA17021@alice>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 12:38:55AM +0100, Eric Sesterhenn wrote:
> hi,
> 
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > On Sun, Jan 04, 2009 at 03:57:26PM +0100, Eric Sesterhenn wrote:
> > > 
> > > Just tell me what i need to do, I am not really familiar with ftrace.
> > > I am only able to test 2.6.28-04980-gb58602a, since current -git is not
> > > able to boot on this box :|
> > 
> > Very cool!
> > 
> > The idea is to have __call_rcu() in kernel/rcutree.c record the
> > address of the callback (argument "head") and the function (argument
> > "func").  In rcu_do_batch(), just before invoking list->func(list),
> > also record the address of the callback ("list") and the function
> > (again, "func").
> > 
> > The new ftrace package has some mechanisms for doing this, but there is
> > always the old-fashioned way of using printk(), for example in
> > rcu_do_batch():
> > 
> > 	prefetch(next);
> > 	if (rcu_dump_callbacks)
> > 		printk("rcu_head=%p, func=%p\n", list, func);
> > 	list->func(list);
> > 
> > Initialize rcu_dump_callbacks to zero, then use a small kernel module
> > (or some such) to set it to one just before running your test.
> 
> i did it via the ugly printk and captured it via netconsole

Good stuff!!!

> for the box with rcutree you can find the log here:
> http://www.cccmz.de/~snakebyte/200.log
> The interesting part seems start at 155.858923, thats when I load
> the rcutorture module

When I download this, I see an 82.100963 immediately followed by an
167.894017, no 155.858923.  Do I have the right log?

> with http://www.cccmz.de/~snakebyte/200_1.log i had another try,
> actually saw a rcu_do_batch: rcu_head=d1907720, func=(null) in the traces,
> box went into unresponsive mode afterwards

Interesting.  The original function is 0xd1902ad0, passed to __call_rcu()
at 157.364214 -- would you be able to tell me what function that
corresponds to?  (Looks to me like a module, perhaps rcutorture?)

Whatever function it is, the rcu_head definitely got corrupted some
time during the 8 milliseconds or so that the callback was waiting for
a grace period.  However, it did just fine being invoked several times
beforehand -- this is a very popular RCU callback function, it appears.

My guess is that the ensuing CPU 0 stall messages are due to CPU 0
having a heart attack trying to execute at address 0.

Are you swapping over NFS, or is the netpoll_send_udp() just garbage on
the stack?

> And just in case it helps somehow: http://www.cccmz.de/~snakebyte/200_3.log

Hmmm...  The main recent change to kernel/rcutorture.c is the addition
of a reboot notifier, so that rcutorture can shut itself down gracefully
should the system go down while rcutorture is still running.  This panic
occurs in rcu_torture_stutter(), which is shown below:

	static int
	rcu_torture_stutter(void *arg)
	{
		VERBOSE_PRINTK_STRING("rcu_torture_stutter task started");
		do {
			schedule_timeout_interruptible(stutter * HZ);
			stutter_pause_test = 1;
			if (!kthread_should_stop() && !fullstop)
				schedule_timeout_interruptible(stutter * HZ);
			stutter_pause_test = 0;
		} while (!kthread_should_stop() && !fullstop);
		VERBOSE_PRINTK_STRING("rcu_torture_stutter task stopping");
		return 0;
	}

I don't see any reason why this function would transfer control to
location 0x60, though I do see a bug in the new shutdown code.  I
don't expect this to make any difference, but a patch is included
nevertheless.

> for the one with rcupreemt you can find the log here:
> http://www.cccmz.de/~snakebyte/201.log
> rcutorture is loaded at 87.312399

Hmmm...  Offset 0x60 seems to be a common thread.  This lets
rcu_torture_ops off the hook, since it isn't that large.

Anyway, could you give the attached patch a go, even though I cannot see
how it would help?  ;-)

Do you get the same error running Classic RCU?

							Thanx, Paul

> Greetings, Eric

Fix an rcutorture bug that prevents the shutdown notifier from ever
actually having any effect, due to the fact that kthreads ignore all
signals.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 rcutorture.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index b310655..d54111c 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -136,7 +136,7 @@ static int stutter_pause_test = 0;
 #endif
 int rcutorture_runnable = RCUTORTURE_RUNNABLE_INIT;
 
-#define FULLSTOP_SIGNALED 1	/* Bail due to signal. */
+#define FULLSTOP_SHUTDOWN 1	/* Bail due to system shutdown/panic. */
 #define FULLSTOP_CLEANUP  2	/* Orderly shutdown. */
 static int fullstop;		/* stop generating callbacks at test end. */
 DEFINE_MUTEX(fullstop_mutex);	/* protect fullstop transitions and */
@@ -151,12 +151,10 @@ rcutorture_shutdown_notify(struct notifier_block *unused1,
 {
 	if (fullstop)
 		return NOTIFY_DONE;
-	if (signal_pending(current)) {
-		mutex_lock(&fullstop_mutex);
-		if (!ACCESS_ONCE(fullstop))
-			fullstop = FULLSTOP_SIGNALED;
-		mutex_unlock(&fullstop_mutex);
-	}
+	mutex_lock(&fullstop_mutex);
+	if (!fullstop)
+		fullstop = FULLSTOP_SHUTDOWN;
+	mutex_unlock(&fullstop_mutex);
 	return NOTIFY_DONE;
 }
 
@@ -624,7 +622,7 @@ rcu_torture_writer(void *arg)
 		rcu_stutter_wait();
 	} while (!kthread_should_stop() && !fullstop);
 	VERBOSE_PRINTK_STRING("rcu_torture_writer task stopping");
-	while (!kthread_should_stop() && fullstop != FULLSTOP_SIGNALED)
+	while (!kthread_should_stop() && fullstop != FULLSTOP_SHUTDOWN)
 		schedule_timeout_uninterruptible(1);
 	return 0;
 }
@@ -649,7 +647,7 @@ rcu_torture_fakewriter(void *arg)
 	} while (!kthread_should_stop() && !fullstop);
 
 	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task stopping");
-	while (!kthread_should_stop() && fullstop != FULLSTOP_SIGNALED)
+	while (!kthread_should_stop() && fullstop != FULLSTOP_SHUTDOWN)
 		schedule_timeout_uninterruptible(1);
 	return 0;
 }
@@ -759,7 +757,7 @@ rcu_torture_reader(void *arg)
 	VERBOSE_PRINTK_STRING("rcu_torture_reader task stopping");
 	if (irqreader && cur_ops->irqcapable)
 		del_timer_sync(&t);
-	while (!kthread_should_stop() && fullstop != FULLSTOP_SIGNALED)
+	while (!kthread_should_stop() && fullstop != FULLSTOP_SHUTDOWN)
 		schedule_timeout_uninterruptible(1);
 	return 0;
 }
