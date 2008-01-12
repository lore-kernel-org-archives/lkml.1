Return-Path: <linux-kernel-owner+w=401wt.eu-S1763435AbYALPGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763435AbYALPGv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 10:06:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbYALPGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 10:06:43 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:40293 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752190AbYALPGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 10:06:42 -0500
Date: Sat, 12 Jan 2008 10:06:21 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Tuomo Valkonen <tuomov@iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
Message-ID: <20080112150621.GC6751@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Tuomo Valkonen <tuomov@iki.fi>, linux-kernel@vger.kernel.org
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi> <18307.42821.166376.732473@stoffel.org> <slrnfo7auq.6m2.tuomov@jolt.modeemi.cs.tut.fi> <871w8r6ruc.fsf@barad-dur.regala.cx> <slrnfo9lqk.17l.tuomov@jolt.modeemi.cs.tut.fi> <20080110131659.GF10230@mit.edu> <20080110134111.GA6254@jolt.modeemi.cs.tut.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110134111.GA6254@jolt.modeemi.cs.tut.fi>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 03:41:11PM +0200, Tuomo Valkonen wrote:
> On 2008-01-10 08:16 -0500, Theodore Tso wrote:
> > > It displays just the right time. On boot anyway. (Linux has had some
> > > serious problems keeping the time after the switch from 2.6.7 to 2.6.14,
> > > advanding even 15 minutes a day -- that ntpd doesn't seem to be able 
> > > to keep up with -- requiring running adjtimexconfig every now and
> > > then for new settings. But the cmos clock displays the right time.)
> > 
> > What do you mean by "on boot"?  Which boot message, precisely?  Is the
> > time printed before or after e2fsck is run, and by which program?
> 
> The time is right as displayed by `date` after boot, i.e. after it has
> been loaded from the CMOS clock that does keep the (local, IIRC) time
> just allright. But then it often starts advancing very fast.

So running the "date" command after the boot sequence is completely
finished.  That doesn't mean that system clock was correct at the time
when fsck is run.  

See, here's the the problem.  You have the CMOS hardware clock, which
for people who are dual-booting with Windows, is unfortunately ticking
local time, instead of GMT time (or if you want to be pedantic, UTC
time; whatever).  When the kernel is first loaded and starts
executing, it will set the Linux system clock from the CMOS hardware
clock.  However, it has *no* idea whether the CMOS hardware clock is
ticking localtime or UTC time.  The Linux system clock (i.e., what is
returned via the gettimeofday() or time() functions) is always UTC
time.    

What happens later is that distribution init scripts will adjust the
system clock either forward or backwards if the system is set up so
that hardware is in Windows bug-compatibility mode where the CMOS
hwclock is ticking localtime.  If it is 1400 GMT, then in the
US/Eastern timezone, the clock will be 9:00am, so the clock will be
pushed four hours later.  If you are in the Central European Timezone,
then the local time will be 3pm, and the clock will be pushed
*backwards* by one hour.

The question is when does this happen.  In some buggy distributions,
this happens *after* e2fsck is run.  And it is in those distributions
e2fsck can sometimes get confused about when the last time the
filesystem was checked --- especially if the system is getting
rebooted a lot (which tends to be the case with people who are
dual-booting).  So the cases where this happens a lot are (a) people
who are using windows and so the CMOS hwclock is ticking localtime,
(b) distributions that don't adjust the Linux system clock before
e2fsck runs.  Unfortunately Ubuntu users in Europe fit this
demographic hugely, and Ubuntu refuses to fix this problem[1], so it's
been personally very vexing, because the users complain to *me*, and I
can't fix the problem, because it's a distribution init script issue.

So what I tell people is to upgrade to the latest e2fsprogs, and then
set in /etc/e2fsck.conf:

[options]
	buggy_init_scripts = 1

Maybe someday Ubuntu will get this right --- but I'm not counting on it.


[1] Something about installer CD's, and not wanting to ask the users
any questions, not even what time zone they are in, or some other
crazyness.  I never completely understood the argument and their
design constraints.

      	      	     	      	   	 - Ted

P.S.  If there are other scripts which are started, they can also get
confused because the time is getting warped backwards early-on.  I
haven't done an analysis to find out which sort programs might be
vulnerable to this, but this is not necessarily an e2fsck-specific
problems.  After all, it *is* reasonable to expect that the time
returned by time(0) or gettimeofday() is correct, and many programs do
make that assumption....
