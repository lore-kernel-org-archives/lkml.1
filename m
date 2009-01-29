Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059AbZA2MTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbZA2MTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 07:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752417AbZA2MTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 07:19:08 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:6963 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbZA2MTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 07:19:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SkeJqn/6tUYtaPvo4v5FykKYmJBd96f6u2MFEVkOvxKVrFzkhNj5y1PMpGg4ztE5sS
         dCfkBWIqDmVA95raRqBYpWdJ1bT+k4vVY1EYLI2i+oQB9c2Ad+IRQFp0qyymSR/RwHoQ
         hIAxOujE4w4u0/A/1namycA/XsqukrgUpseGE=
Date: Thu, 29 Jan 2009 13:19:00 +0100
From: Adam Tkac <vonsch@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Palfrader <weasel@debian.org>, linux-kernel@vger.kernel.org,
       debian-admin@lists.debian.org, team@security.debian.org,
       libpam-modules@packages.debian.org, stable@kernel.org
Subject: Re: 2.6.28, rlimits, performance and debian etch
Message-ID: <20090129121900.GA2827@evileye.atkac.englab.brq.redhat.com>
References: <20090121115219.GA2754@anguilla.noreply.org> <20090127151703.c356c5db.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090127151703.c356c5db.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 03:17:03PM -0800, Andrew Morton wrote:
> On Wed, 21 Jan 2009 12:52:19 +0100
> Peter Palfrader <weasel@debian.org> wrote:
> 
> > Hi,
> > 
> > I spent several hours trying to get to the bottom of a serious
> > performance issue that appeared on one of our servers after upgrading to
> > 2.6.28.  In the end it's what could be considered a userspace bug that
> > was triggered by a change in 2.6.28.  Since this might also affect other
> > people I figured I'd at least document what I found here, and maybe we
> > can even do something about it:
> > 
> > 
> > So, I upgraded some of debian.org's machines to 2.6.28.1 and immediately
> > the team maintaining our ftp archive complained that one of their
> > scripts that previously ran in a few minutes still hadn't even come
> > close to being done after an hour or so.  Downgrading to 2.6.27 fixed
> > that.
> > 
> > Turns out that script is forking a lot and something in it or python or
> > whereever closes all the file descriptors it doesn't want to pass on.
> > That is, it starts at zero and goes up to ulimit -n/RLIMIT_NOFILE and
> > closes them all with a few exceptions.
> > 
> > Turns out that takes a long time when your limit -n is now 2^20 (1048576).
> > 
> > With 2.6.27.* the ulimit -n was the standard 1024, but with 2.6.28 it is
> > now a thousand times that.
> > 
> > 2.6.28 included a patch titled "rlimit: permit setting RLIMIT_NOFILE to
> > RLIM_INFINITY" (0c2d64fb6cae9aae480f6a46cfe79f8d7d48b59f)[1] that
> > allows, as the title implies, to set the limit for number of files to
> > infinity.
> > 
> > Closer investigation showed that the broken default ulimit did not apply
> > to "system" processes (like stuff started from init).  In the end I
> > could establish that all processes that passed through pam_limit at one
> > point had the bad resource limit.
> > 
> > Apparently the pam library in Debian etch (4.0) initializes the limits
> > to some default values when it doesn't have any settings in limit.conf
> > to override them.  Turns out that for nofiles this is RLIM_INFINITY.
> > Commenting out "case RLIMIT_NOFILE" in pam_limit.c:267 of our pam
> > package version 0.79-5 fixes that - tho I'm not sure what side effects
> > that has.
> > 
> > Debian lenny (the upcoming 5.0 version) doesn't have this issue as it
> > uses a different pam (version).
> > 
> > 
> > I'm a bit unsure where to go from here.  Maybe the pam library in etch
> > should be fixed.  Maybe the patch should be reverted (but then it may be
> > more correct now and that's what the changelog entry suggests).
> > As a stopgap measure I could also just define nofile in limits.conf.
> > 
> > Thanks for listening.  Also thanks to Rik and Nocholas who helped track
> > some of this down.
> > 
> > Cheers,
> > Peter
> > 1. http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0c2d64fb6cae9aae480f6a46cfe79f8d7d48b59f
> >    http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=0c2d64fb6cae9aae480f6a46cfe79f8d7d48b59f
> 
> Ho hum, thanks.
> 
> Well, I think we just revert it for now.  We can bring it back later
> if someone is thus inclined.  Along with some sort of opt-in control,
> perhaps in /proc.  Which defaults to "off".
> 

Hi all,

I don't think the "rlim_infinity" patch should be reverted. Let me try
to explain why.

First, code which sets limits to RLIM_INFINITY is very bad idea and
that code is Debian specific. I downloaded original pam 0.79 (stripped):

for(i = 0; i < RLIM_NLIMITS; i++) {
	...
	int r = getrlimit(i, &pl->limits[i].limit);
	...

as you can see original pam sets limits to inherited defaults. After
code written above Debian adds their patch:

if (limits_not_defined_in_limits_conf) {
	...
	case RLIMIT_NOFILE:
	...
		pl->limits[i].limit.rlim_cur = RLIM_INFINITY;
		pl->limits[i].limit.rlim_max = RLIM_INFINITY;
	...
}

so as you can see inherited default limits are overriden to infinity.
In my opinion Debian should revert their patch which is, at least,
pretty incorrect and unsecure.

Next argument is POSIX compatibility (from setrlimit() specification):

"The value RLIM_INFINITY, defined in <sys/resource.h>, shall be
considered to be larger than any other limit value. If a call to
getrlimit() returns RLIM_INFINITY for a resource, it means the
implementation shall not enforce limits on that resource. Specifying
RLIM_INFINITY as any resource limit value on a successful call to
setrlimit() shall inhibit enforcement of that resource limit."

So kernel does what is expected. If you want "unlimited" number of
descriptors, you have it.

Please consider again where exactly problem is, if in Debian patch or
in kernel patch. From my point of view Debian patch should be
reverted, not the kernel one.

Please add me to CC, I'm not member of the list.

Regards, Adam

___
Adam Tkac
