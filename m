Return-Path: <linux-kernel-owner+w=401wt.eu-S1764807AbZFQICx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764807AbZFQICx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 04:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbZFQICg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 04:02:36 -0400
Received: from mail.gmx.net ([213.165.64.20]:39970 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751727AbZFQICb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 04:02:31 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18PA4dpIlsP2zNTLez9nimOlP8j1cIg/vPOi1NUdR
	VCmsDip42bqVzl
Subject: Re: Scheduler fails to allow for "niceness" with new/fast processes
From: Mike Galbraith <efault@gmx.de>
To: Robert Bradbury <robert.bradbury@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <deaa866a0906160723k78c3c54bv35e2e2406e3d13d1@mail.gmail.com>
References: <deaa866a0906160723k78c3c54bv35e2e2406e3d13d1@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 10:02:28 +0200
Message-Id: <1245225748.13620.92.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2009-06-16 at 10:23 -0400, Robert Bradbury wrote:
> I primarily use my system (Gentoo) for 3 tasks: (a) Browsing the web
> related to biomedical research (I may often have dozens of windows and
> hundreds of tabs open in several browsers); (b) Running fairly CPU &
> Disk I/O intensive genetics programs; (c) Performing low priority
> rebuilds of various packages (Gentoo packages, firefox/chrome
> releases, etc.
> 
> Now (a) is my top priority -- I want my active browser to get all of
> the CPU if it requires it (fast window/tab opens, quick page reloads &
> redraws, etc.);  (b) is of lesser priority and (c) is lowest priority.
>  This is on a 2.8 GHz Pentium IV (Prescott) with 3GB of RAM and 12GB
> of swap on two drives.
> 
> Now I normally run (c) processes at nice -n 19 to (in theory) get the
> least CPU allocation.  But it would appear that this does not work.

Can you some supporting data?  I don't think anyone is aware of such a
CPU distribution problem.

BTW, which kernel are you running, and which filesystem?

>   I
> often experience extremely poor user (esp. browser) performance when
> running package builds.  In monitoring the package builds I find that
> they seem to be stopping at nothing, presumably because the build
> tools, directories, etc. are all cached in memory as are most of the
> header files (Gentoo ebuilds have a cache for this).  If the package
> source files are small or disk read-ahead is working or the source
> files are entirely cached (many packages which have just been unpacked
> during the build preparation process are presumably still in the
> system buffer cache) -- there is no I/O required for them to build.

You still have to get the output to disk, so there is IO.  VM limits and
IO schedulers come into play, which affect your browsers and whatnot.

> I believe I glanced at an IBM technical report a number of months ago
> that suggested something to the effect that ongoing "handoffs" to
> newly started processes could be a way to bypass the regulation of
> process priorities by the kernel.  This being due to some bias in how
> the scheduler works in that one has to accumulate some minimum amount
> of CPU time in order for process "niceness" to have any effect.  (One
> could imagine setting up a shared memory region to retain any data in
> memory and continually execing new processes which attach to the
> memory and avoid any sysadmin imposed CPU use restrictions).

Pointer?

> So my questions are:
> 1) Are people aware of this problem (CPU intensive cached programs
> severely impact User Interface program performance and nicing the CPU
> intensive programs (if they execute quickly) fails to correct the
> problem)?

I'm aware of _IO_ negatively affecting interactivity, but I'm not aware
of any CPU distribution problem.

WRT IO, if you're using the CFQ elevator you can try ionice -c3 -p $$
for your package build shell.

>From the scheduler side, nice 19 tasks will still wakeup preempt higher
priority tasks if they haven't had their fair share of CPU already.  You
can run your package builds as SCHED_BATCH to avoid that.  There is also
a SCHED_IDLE scheduling policy which only gives tasks CPU if there is
nothing else runnable on their current CPU.  This class of task will
never preempt, and will always be preempted by SCHED_NORMAL tasks.

I don't know what tool distributions provide for juggling scheduling
policies, but I have a tool (schedctl - posted to LKML some years ago)
that I hack up regularly.  If you don't have such a tool, and want to
try these policies, I can send you a copy offline.

> 2) Can this be resolved in any way by altering the scheduler or its
> parameters in Linux configuration?

We don't yet know that the problems you're experiencing are process
scheduler related.  As Arjan mentioned, running latencytop may shed some
light.  Any data or method of reproduction wrt bad behaviors much
appreciated.

>From my own experiences, I strongly suspect IO, but certainly don't want
to exclude the possibility of a scheduler bug.

> 3) Is there any quick "hack" to the kernel (sched.c?) which forces it
> to more strongly favor UI programs over niced background tasks (to the
> extent that if the UI programs, e.g. firefox-bin, X, bash, etc. *want*
> the CPU or disk (or network even) then they immediately get it by
> preempting niced processes.  I.e. UI programs always preferentially go
> to the head of various queues?

Aside from the normal nice levels (which absolutely must work as
advertised), recent kernels support group scheduling, ie CPU bandwidth
allocation for groups of tasks.

> The trend seems to be to migrate towards multi-core CPU's rather than
> fix the scheduler so that "nice" *really* means "only run this if you
> have nothing else to do".

It may appear that way from your perspective, but I assure you that this
is not the case.  Nice levels are critical core scheduler functionality.

	-Mike

