Return-Path: <linux-kernel-owner+w=401wt.eu-S1753703AbXDIQuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703AbXDIQuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 12:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbXDIQuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 12:50:40 -0400
Received: from mail.gmx.net ([213.165.64.20]:38742 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752135AbXDIQuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 12:50:39 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+KbgoTaxmKwniTPwj1Ep4Bgntc6ayMjDs3OhUF/g
	gI/hRPWTHmQEXG
Subject: Re: Ten percent test
From: Mike Galbraith <efault@gmx.de>
To: Ed Tomlinson <edt@aei.ca>
Cc: Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
In-Reply-To: <200704090726.01928.edt@aei.ca>
References: <200703290237.38777.kernel@kolivas.org>
	 <200704080909.00472.edt@aei.ca>
	 <1176097101.6355.89.camel@Homer.simpson.net>
	 <200704090726.01928.edt@aei.ca>
Content-Type: text/plain
Date: Mon, 09 Apr 2007 18:50:33 +0200
Message-Id: <1176137433.6109.59.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-09 at 07:26 -0400, Ed Tomlinson wrote:
> On Monday 09 April 2007 01:38, Mike Galbraith wrote:
> > On Sun, 2007-04-08 at 09:08 -0400, Ed Tomlinson wrote:
> > > Hi,
> > > 
> > > I am one of those who have been happily testing Con's patches.  
> > > 
> > > They work better than mainline here.
> > 
> > (I tried a UP kernel yesterday, and even a single kernel build would
> > make noticeable hitches if I move a window around. YMMV etc.)
> 
> Interesting.  I run UP amd64, 1000HZ, 1.25G, preempt off (on causes kernel 
> stalls with no messages - but that is another story).  I do not notice a single 
> make.   When several are running the desktop slows down a bit.  I do not have 
> X niced.  Wonder why we see such different results?

Probably because with your processor, in general cc1 can get the job
done faster, as can X.  The latency big hit happens when you hit the end
of the rotation.  You simply don't hit it as often as I do.  Anyone with
an old PIII box should hit the wall very quickly indeed.  I haven't had
time to try it here.
 
> I am not saying that SD is perfect - I fully expect that more bugs will turn up
> in its code (some will affect mainline too).  I do however like the idea of a 
> scheduler that does not need alchemy to achieve good results.  Nor do I
> necessarily expect it to be 100% transparent.  If one changes something
> as basic as the scheduler some tweaking should be expected.  IMO this
> is fine as long as we get consistant results.

Alchemy is a rather colorful word for arithmetic, but I see your point.

> > > If one really needs some sort of interactivity booster (I do not with SD), why
> > > not move it into user space?  With SD it would be simple enough to export
> > > some info on estimated latency.  With this user space could make a good
> > > attempt to keep latency within bounds for a set of tasks just by renicing.... 
> > 
> > I don't think you can have very much effect on latency using nice with
> > SD once the CPU is fully utilized.  See below.
> > 
> > /*
> >  * This contains a bitmap for each dynamic priority level with empty slots
> >  * for the valid priorities each different nice level can have. It allows
> >  * us to stagger the slots where differing priorities run in a way that
> >  * keeps latency differences between different nice levels at a minimum.
> >  * ie, where 0 means a slot for that priority, priority running from left to
> >  * right:
> >  * nice -20 0000000000000000000000000000000000000000
> >  * nice -10 1001000100100010001001000100010010001000
> >  * nice   0 0101010101010101010101010101010101010101
> >  * nice   5 1101011010110101101011010110101101011011
> >  * nice  10 0110111011011101110110111011101101110111
> >  * nice  15 0111110111111011111101111101111110111111
> >  * nice  19 1111111111111111111011111111111111111111
> >  */
> > 
> > Nice allocates bandwidth, but as long as the CPU is busy, tasks always
> > proceed downward in priority until they hit the expired array.  That's
> > the design.  If X gets busy and expires, and a nice 20 CPU hog wakes up
> > after it's previous rotation has ended, but before the current rotation
> > is ended (ie there is 1 task running at wakeup time), X will take a
> > guaranteed minimum 160ms latency hit (quite noticeable) independent of
> > nice level.  The only way to avoid it is to use a realtime class.
> > 
> > A nice -20 task has maximum bandwidth allocated, but that also makes it
> > a bigger target for preemption from tasks at all nice levels as it
> > proceeds downward toward expiration.  AFAIKT, low latency scheduling
> > just isn't possible once the CPU becomes 100% utilized, but it is
> > bounded to runqueue length.  In mainline OTOH, a nice -20 task will
> > always preempt a nice 0 task, giving it instant gratification, and
> > latency of lower priority tasks is bounded by the EXPIRED_STARVING(rq)
> > safety net.
> 
> Mike I made no mention of low latency.

You did say that Con's patch works better than mainline, and you seemed
very much to be talking about the desktop.  X very definitely is a
latency sensitive application, and often a CPU hog to boot.  The point I
illustrated above is a salient point.

If you don't want to hear about anything other than this idea about
using nice from userland, skip to my last sentence :)

>   I did mention predictable latency.  If
> you are 100% utilized, and have a nice -20 task cpu hog, I would expect it to run 
> and that it _should_ affect other tasks - thats why it runs with -20...

:-/  It does the user of X absolutely no good to be able to predict, as
I did above, that we are absolutely _going_ to take a 160ms + remaining
task ticks latency hit.

Nice -20 was used only to show clearly what SD trades away, and it's not
only the desktop it's trading for mundane latency, it's trading any
possibility of low latency, and dismissing burst loads as if they don't
even exist.  The current scheduler is dynamic.  SD is utterly rigid.

Apply what I wrote to X at the recommended nice -10.  It makes no
difference what bandwidth you allocate if the latency sensitive
application _will_ take a very major latency hit if it uses it.  X does
do that, so it will take those hits by design.

> This is why I suggest that user space may be a better place to boost interactive
> tasks.  A daemon that posted a message telling me that the nice -20 cpu hog
> is causing 300ms delays for X would, IMHO, be a good thing.  That same daemon
> could then propose a fix telling me the expected latencies and let me decide if 
> I want to change priorities.  It could also be set to automaticily adjust nice levels...

Re-read what I wrote.  You simply can't get there from here, by design.

If I'm wrong, someone please show me where.

	-Mike

