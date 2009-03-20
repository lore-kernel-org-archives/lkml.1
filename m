Return-Path: <linux-kernel-owner+w=401wt.eu-S1761034AbZCTTqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761034AbZCTTqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 15:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755786AbZCTTqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 15:46:25 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:42857 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbZCTTqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 15:46:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HLgQb2r+UizgAy1WK7hS6LMoMr4qHBVq2+j25PSpBYj3Yyeh0VyU5Tj1L4m2++cOD3
         jLfHjjbjwu9hfbjDtbMTDS2sqdQYp30ane2KXa+pIF1KiS080emrqkqLY/yBU/5HS8ih
         PAxPcrr/BVZDvRjHrOmJoARpPAUotaLR28Xrs=
Date: Fri, 20 Mar 2009 20:46:18 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/5] [GIT PULL] updates for tip/tracing/ftrace
Message-ID: <20090320194617.GA5934@nowhere>
References: <20090318031423.981603258@goodmis.org> <20090318055924.GA24627@elte.hu> <20090318073903.GA31341@elte.hu> <20090319073357.GA14615@elte.hu> <alpine.DEB.2.00.0903191309170.16987@gandalf.stny.rr.com> <20090320174331.GH6698@linux.vnet.ibm.com> <20090320183642.GA2070@elte.hu> <20090320183849.GA3657@elte.hu> <20090320191926.GJ6698@linux.vnet.ibm.com> <20090320192721.GI6224@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090320192721.GI6224@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 08:27:21PM +0100, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Fri, Mar 20, 2009 at 07:38:49PM +0100, Ingo Molnar wrote:
> > > 
> > > * Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > > > This looks like it is RCU/stop_machine related. The CPU is 
> > > > > > stuck in in stop_machine? I see that rcu_torture is running. 
> > > > > > Does this go away if you turn off rcu_torture?
> > > > > 
> > > > > Grasping at straws...  Does Lai's rcu_barrier() fix help?
> > > > 
> > > > which one is that?
> > > 
> > > ok, found it. Will know in about ~24 hours whether it helps.
> > 
> > http://lkml.org/lkml/2009/3/20/71 was the one I was thinking of, 
> > just to double-check.
> 
> Yeah - i just picked it up into tip:core/rcu.
> 
> I didnt immediately connect the two things, as 'tracer self-test' 
> does not lend itself to 'CPU hotplug and RCU race fix' - but indeed 
> in the case of the function tracer there's a dependency due to 
> stop_machine_run(). Thanks for point it out!
> 
> 	Ingo


I've successfully triggered a crash, the problem is that I can't be sure this is
the same because I don't have a serial line on my x86-64, and the trace goes too far.
Moreover boot_delay=N make it disappear.

I can trigger it each time I boot with ftrace=function_graph and
the following patch applied:

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 7c4142a..e9914a8 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -616,7 +616,7 @@ rcu_torture_writer(void *arg)
 	static DEFINE_RCU_RANDOM(rand);
 
 	VERBOSE_PRINTK_STRING("rcu_torture_writer task started");
-	set_user_nice(current, 19);
+	set_user_nice(current, -1);
 
 	do {
 		schedule_timeout_uninterruptible(1);
@@ -736,7 +736,7 @@ rcu_torture_reader(void *arg)
 	struct timer_list t;
 
 	VERBOSE_PRINTK_STRING("rcu_torture_reader task started");
-	set_user_nice(current, 19);
+	set_user_nice(current, -1);
 	if (irqreader && cur_ops->irqcapable)
 		setup_timer_on_stack(&t, rcu_torture_timer, 0);
 


