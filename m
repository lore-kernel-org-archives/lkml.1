Return-Path: <linux-kernel-owner+w=401wt.eu-S1761444AbYEXShC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761444AbYEXShC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 14:37:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760468AbYEXSgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 14:36:51 -0400
Received: from www.tglx.de ([62.245.132.106]:55852 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760323AbYEXSgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 14:36:51 -0400
Date: Sat, 24 May 2008 20:35:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Walker <dwalker@mvista.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] futex: fix miss ordered wakeups
In-Reply-To: <1211649860.18130.182.camel@localhost.localdomain>
Message-ID: <alpine.LFD.1.10.0805242031560.3295@apollo.tec.linutronix.de>
References: <20080523042923.594531457@mvista.com>  <20080523042923.916202203@mvista.com>  <alpine.LFD.1.10.0805241039220.3295@apollo.tec.linutronix.de>  <1211643165.18130.166.camel@localhost.localdomain>  <alpine.LFD.1.10.0805241852490.3295@apollo.tec.linutronix.de>
 <1211649860.18130.182.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 May 2008, Daniel Walker wrote:
> On Sat, 2008-05-24 at 19:03 +0200, Thomas Gleixner wrote:
> > On Sat, 24 May 2008, Daniel Walker wrote:
> > > On Sat, 2008-05-24 at 10:55 +0200, Thomas Gleixner wrote:
> > > 
> > > > Normal futexes have no ordering guarantees at all. There is no
> > > > mechanism to prevent lock stealing from lower priority tasks. So why
> > > > should we care about the once a year case, where a sleepers priority
> > > > is modified ?
> > > 
> > > Lock stealing?
> > 
> > Do you have the faintest idea how the futex code works at all ? There
> > is no guarantee that the task which is woken up first gets the futex.
> 
> Thomas if you want to be abusive, talk to someone else.

See below.
 
> > A) A task on another CPU can get it independent of its priority
> > B) In case of multiple waiters wakeup there is no guarantee either
> 
> This is how I would imagine the pre-plist code would work.

And it works this way even after the plist code.

May I politely suggest, that you carefully read futex_wake() and the
corresponding libc implementation and figure out why there is no
guarantee and why there can't be one?

Sorry, I'm not abusive. You make claims about correctness and you seem
to believe that the plist code gives guarantees except for the
setscheduler corner case, but your hypothesis is simply wrong:

There is no kernel side controlled handover of a normal futex. The
woken up waiters race for it and a low prio thread on another CPU can
steal it even if there is a high prio waiter woken up.

So you try to tell me about the correctness of code where you just
imagine how it works. 

The plist add on works correct in most of the cases, nothing else. To
achieve full correctness there is much more necessary than this
setscheduler issue. The plist changes were accepted because the
overhead is really minimal, but achieving full correctness would hurt
performance badly.

> > > > There are more issues vs. pi futexes as well. The simple case of
> > > > futex_wait() vs. futex_adjust_waiters will just upset lockdep, but
> > > > there are real dealocks vs. unqueue_me_pi waiting.
> > > 
> > > You mean the lock ordering would cause the deadlock vs. unqueue_me_pi ,
> > > or are you talking about something else?
> > 
> > Do I write Chinese or what ?
> 
> I guess so .. 

So maybe you should take some private lessons in Chinese. Then we
could easier communicate.

Thanks,
	tglx
