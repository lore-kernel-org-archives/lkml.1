Return-Path: <linux-kernel-owner+w=401wt.eu-S1754738AbXFYSud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbXFYSud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 14:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbXFYSuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 14:50:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123AbXFYSuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 14:50:24 -0400
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
From: Kristian =?ISO-8859-1?Q?H=F8gsberg?= <krh@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
In-Reply-To: <20070622215953.GA22917@elte.hu>
References: <20070622040014.234651401@goodmis.org>
	 <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org>
	 <20070622204058.GA11777@elte.hu>
	 <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org>
	 <20070622215953.GA22917@elte.hu>
Content-Type: text/plain
Date: Mon, 25 Jun 2007 14:48:44 -0400
Message-Id: <1182797325.1689.14.camel@hinata.boston.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-22 at 23:59 +0200, Ingo Molnar wrote:
> so how about the following, different approach: anyone who has a tasklet 
> in any performance-sensitive codepath, please yell now. We'll also do a 
> proactive search for such places. We can convert those places to 
> softirqs, or move them back into hardirq context. Once this is done - 
> and i doubt it will go beyond 1-2 places - we can just mass-convert the 
> other 110 places to the lame but compatible solution of doing them in a 
> global thread context.

OK, here's a yell.  I'm using tasklets in the new firewire stack for all
interrupt handling.  All my interrupt handler does is read out the event
mask and schedule the appropriate tasklets.  Most of these tasklets
typically just end up scheduling work or completing a completion, so
moving it to a workqueue is pretty pointless.  In particular, the
isochronous DMA events must be handled with as little latency as
possible, so a workqueue in that code path would be pretty bad.

I'm not strongly attached to tasklets, and it sounds like I got it wrong
and used the wrong delayed execution mechanism.  But that's just another
data point that suggests that there are too many of these.  I guess I
need to sit down and look into porting that to softirqs?

However, I don't really understand how you can discuss a wholesale
replacing of tasklets with workqueues, given the very different
execution sematics of the two mechanisms.  I would think that others
have used tasklets for similar purposes as I have and moving that to
workqueues just has to break a bunch of stuff.  I don't know the various
places tasklets are used as well as other people in this thread, but I
think deprecating them and moving code to either softirqs or workqueues
on a case by case basis is a better approach.  That way we also avoid
the gross wrappers.

Kristian


