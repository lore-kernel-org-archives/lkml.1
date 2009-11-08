Return-Path: <linux-kernel-owner+w=401wt.eu-S1752926AbZKHI3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbZKHI3W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 03:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbZKHI3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 03:29:21 -0500
Received: from home.kolivas.org ([59.167.196.135]:37940 "EHLO home.kolivas.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341AbZKHI3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 03:29:19 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: Intermittent early panic in try_to_wake_up
Date: Sun, 8 Nov 2009 19:29:53 +1100
User-Agent: KMail/1.12.1 (Linux/2.6.31-bfs310; KDE/4.3.2; x86_64; ; )
Cc: Kevin Winchester <kjwinchester@gmail.com>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney <paulmck"@linux.vnet.i
References: <4AE0EBBD.6090005@gmail.com> <4AF59F24.4010501@gmail.com> <1257611754.4108.12.camel@laptop>
In-Reply-To: <1257611754.4108.12.camel@laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911081929.53418.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Nov 2009 03:35:54 Peter Zijlstra wrote:
> On Sat, 2009-11-07 at 12:24 -0400, Kevin Winchester wrote:
> > Mike Galbraith wrote:
> > > On Fri, 2009-11-06 at 19:49 -0400, Kevin Winchester wrote:
> > >> The patch below does not apply to mainline, unless I'm doing something
> > >> wrong. It's against -tip, I assume?  Is it just as applicable to
> > >> mainline?
> > >
> > > It was mainline, but I had the scheduler pull request and another in
> > > for testing as well.  Linus has pulled, so it'll apply now, with
> > > offsets.
> >
> > It did end up applying, but did not have any effect.  Looking at the
> > patch again, I see that it appears to only affect CONFIG_SMP, which I am
> > not running (and in fact it adds a build warning for the !SMP case).  So
> > there was not much chance of it fixing anything, I suppose.
> >
> > Any other ideas?  I don't have a serial console, and the trace scrolls
> > off my console, so I don't know if any debug printks would help.  Would
> > it help if I copied the entire panic message entirely, including the Code
> > section? I can try that the next time it happens.
> 
> Use vga=ask boot_delay=100 select the highest res possible.
> 
> Possibly you could use a digital (video) camera to record the output.
> 

For what it's worth I've seen this on BFS and assumed it was a bfs issue until 
I spotted this thread so I'll tell you what I discovered when I was 
investigating it, but unfortunately I did not find the root cause.

Incredibly the bug happened in try_to_wake_up where the task struct that was 
in the call function (p) gets dereferenced before the rq lock is grabbed. Then 
when the rq lock is attempted to be grabbed it has no p to reference.

Further investigation showed it to always be ksoftirqd spawning on bootup only 
and never in any other situation. The factors that were common was that there 
would always be a conditional resched that occurred and that's how it would 
get lost. I tried stepping through the boot process on kvm but always came up 
stumped as to how on earth it even happened. The only common variable was that 
it -only- ever happened with voluntary preempt enabled, and not with full 
preempt or no-preempt. cond_resched is called 2 or 3 times during the boot 
sequence via might_sleep by that stage, but if I removed each might_sleep one 
at a time it would just happen from a different might_sleep, suggesting we 
weren't sleeping when we shouldn't. Since I'm anti-fan of voluntary preempt, I 
gave up trying to find the root cause and put this nonsense workaround in 
__cond_resched :

static void __cond_resched(void)
{
	if (unlikely(system_state != SYSTEM_RUNNING))
		return;

And it's still there in BFS, but it fixes the problem, in case someone wanted 
to use voluntary with bfs. I've long since lost the config that caused the 
problem reliably and can't guarantee that it's the same thing happening on 
mainline, but figured the information might be helpful.

Regards,
-- 
-ck
