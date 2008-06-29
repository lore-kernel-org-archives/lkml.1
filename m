Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbYF2X3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbYF2X3Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 19:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbYF2X2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 19:28:54 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:34747 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbYF2X2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 19:28:52 -0400
Date: Sun, 29 Jun 2008 16:28:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Noah Watkins <noahwatkins@gmail.com>
Cc: Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG RT] 2.6.25.8-rt7 on 8-way
Message-ID: <20080629232844.GB8494@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <7618ba960806291432l20b7b6b5lea4b60bafa68c3bf@mail.gmail.com> <1214778205.13292.6.camel@dd.thebigcorporation.com> <7618ba960806291618r7a95908aq459d1bbb63a175cc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7618ba960806291618r7a95908aq459d1bbb63a175cc@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2008 at 06:18:46PM -0500, Noah Watkins wrote:
> That eliminated the messages.

Does the patch below allow you to re-enable CONFIG_PREEMPT_RCU_BOOST
without getting these messages?  (I sent this out previously, but
am to lazy to search for the original posting.)

						Thanx, Paul

> - Noah
> 
> On Sun, Jun 29, 2008 at 5:23 PM, Sven-Thorsten Dietrich
> <sven@thebigcorporation.com> wrote:
> > On Sun, 2008-06-29 at 16:32 -0500, Noah Watkins wrote:
> >> My kernel is very, very noisy with the following bug:
> >>
> >> - Full dmesg below
> >> - Please CC me
> >>
> >
> > I found this as well (adding Paul).
> >
> > If you disable CONFIG_PREEMPT_RCU_BOOST, does it go away?
> >
> > Regards,
> > Sven

Signed-off-by: Paul E. McKenney <paulmck@us.ibm.com>
---

diff -urpNa -X dontdiff linux-2.6.25.8-rt7/kernel/rcupreempt-boost.c linux-2.6.25.8-rt7-preemptfix/kernel/rcupreempt-boost.c
--- linux-2.6.25.8-rt7/kernel/rcupreempt-boost.c	2008-06-24 14:14:52.000000000 -0700
+++ linux-2.6.25.8-rt7-preemptfix/kernel/rcupreempt-boost.c	2008-06-24 14:38:59.000000000 -0700
@@ -205,11 +205,23 @@ RCU_BOOST_TRACE_FUNC_DECL(boost_readers)
 RCU_BOOST_TRACE_FUNC_DECL(try_unboost_readers)
 RCU_BOOST_TRACE_FUNC_DECL(unboost_readers)
 RCU_BOOST_TRACE_FUNC_DECL(over_taken)
+static void rcu_trace_boost_boost_called_preempt(void)
+{
+	preempt_disable();
+	rcu_trace_boost_boost_called(RCU_BOOST_ME);
+	preempt_enable();
+}
+static void rcu_trace_boost_unboost_called_preempt(void)
+{
+	preempt_disable();
+	rcu_trace_boost_unboost_called(RCU_BOOST_ME);
+	preempt_enable();
+}
 #else /* CONFIG_RCU_TRACE */
 /* These were created by the above macro "RCU_BOOST_TRACE_FUNC_DECL" */
-# define rcu_trace_boost_task_boost_called(rbd) do { } while (0)
+# define rcu_trace_boost_task_boost_called_preempt(rbd) do { } while (0)
 # define rcu_trace_boost_task_boosted(rbd) do { } while (0)
-# define rcu_trace_boost_boost_called(rbd) do { } while (0)
+# define rcu_trace_boost_boost_called_preempt(rbd) do { } while (0)
 # define rcu_trace_boost_try_boost(rbd) do { } while (0)
 # define rcu_trace_boost_boosted(rbd) do { } while (0)
 # define rcu_trace_boost_unboost_called(rbd) do { } while (0)
@@ -261,7 +273,7 @@ void __rcu_preempt_boost(void)
 
 	WARN_ON(!current->rcu_read_lock_nesting);
 
-	rcu_trace_boost_boost_called(RCU_BOOST_ME);
+	rcu_trace_boost_boost_called_preempt();
 
 	/* check to see if we are already boosted */
 	if (unlikely(rcu_is_boosted(curr)))
@@ -313,7 +325,7 @@ void __rcu_preempt_unboost(void)
 	int prio;
 	unsigned long flags;
 
-	rcu_trace_boost_unboost_called(RCU_BOOST_ME);
+	rcu_trace_boost_unboost_called_preempt();
 
 	/* if not boosted, then ignore */
 	if (likely(!rcu_is_boosted(curr)))
