Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbYH1QFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbYH1QFe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 12:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbYH1QFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 12:05:09 -0400
Received: from viefep31-int.chello.at ([62.179.121.49]:64872 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592AbYH1QFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 12:05:07 -0400
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080828141513.GC31444@goodmis.org>
References: <20080819103301.787700742@chello.nl>
	 <20080819103844.459178947@chello.nl> <20080819110557.GA18608@elte.hu>
	 <20080828141513.GC31444@goodmis.org>
Content-Type: text/plain
Date: Thu, 28 Aug 2008 18:05:02 +0200
Message-Id: <1219939502.17355.30.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-28 at 10:15 -0400, Steven Rostedt wrote:

> My biggest concern about adding a limit to FIFO is that an RT developer
> would spend weeks trying to debug their system wondering why their
> planned CPU RT hog, is being preempted by a non-RT task.
> 
> For this, if this time limit does kick in, we should at the very least
> print something out to let the user know this happened. After all, this
> is more of a safety net anyway, and if we are hitting the limit, the
> user should be notified. Perhaps even tell the user that if this
> behaviour is expected, to up the sysctl <var> by more.

Should be easy enough to do - 

> Peter, another question. Is this limit for a single RT task running, or
> all RT tasks. I'm assuming here that it is a single RT task. If you have
> 20 RT tasks all running, would this let non RT tasks in? In that case,
> this could be even a bigger issues.

No its not per task. Its per group (and trivially the !group case is one
group).

All this bandwidth code comes from RT group scheduling. We do that by
assigning a bandwidth to each group so that within that bandwidth each
group can use RT tasks and have them behave like they should.

I don't fully agree with the statement that the most important thing for
SCHED_FIFO is to run as long as you want.

The most important thing SCHED_FIFO brings us are deterministic
scheduling rules. And RT group scheduling maintains that determinism by
using a constand bandwidth assignment.

Now the thing that we've been bickering about - bandwidth limits on the
root group, which just fell out of the whole ordeal due to symmertry.

On the one hand, a program that ran deterministic will still run
deterministically at n% (although of course, just like running on less
powerfull hardware, you could miss deadlines you previously did not). On
the other hand, people might not expect that.

Having a lower than 100% bandwidth limit by default gives a safer
environment because it avoids total starvation, nor does it take away
determinism [*].

It does however bring the risk of surprising a few folks.

[*] - there is some added jitter due to the throttling logic, and since
the default period might not align nicely with actual deadlines its not
perfect. An EDF based scheduler with <100% bandwidth caps would do
better.

Other scheduling classes have been mentioned... I've been on the point
of writing SCHED_ISO, a bandwidth throttled SCHED_FIFO that doesn't
require root priviligles and comes with say a 10% bandwidth limit.

Doing that should not be too hard - it will just add more code and a
bigger configuration space.



