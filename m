Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbZBHXV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbZBHXV3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 18:21:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbZBHXVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 18:21:20 -0500
Received: from minbar.dodds.net ([66.93.39.86]:47769 "EHLO minbar.dodds.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805AbZBHXVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 18:21:19 -0500
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Feb 2009 18:21:18 EST
Date: Sun, 8 Feb 2009 14:31:53 -0800
From: Steve Langasek <vorlon@debian.org>
To: Adam Tkac <vonsch@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Palfrader <weasel@debian.org>, linux-kernel@vger.kernel.org,
       debian-admin@lists.debian.org, team@security.debian.org,
       libpam-modules@packages.debian.org, stable@kernel.org
Subject: Re: 2.6.28, rlimits, performance and debian etch
Message-ID: <20090208223152.GC9083@dario.dodds.net>
Mail-Followup-To: Steve Langasek <vorlon@debian.org>,
	Adam Tkac <vonsch@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Palfrader <weasel@debian.org>, linux-kernel@vger.kernel.org,
	debian-admin@lists.debian.org, team@security.debian.org,
	libpam-modules@packages.debian.org, stable@kernel.org
References: <20090121115219.GA2754@anguilla.noreply.org> <20090127151703.c356c5db.akpm@linux-foundation.org> <20090129121900.GA2827@evileye.atkac.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129121900.GA2827@evileye.atkac.englab.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 01:19:00PM +0100, Adam Tkac wrote:
> Hi all,

> I don't think the "rlim_infinity" patch should be reverted. Let me try
> to explain why.

> First, code which sets limits to RLIM_INFINITY is very bad idea and
> that code is Debian specific. I downloaded original pam 0.79 (stripped):

> for(i = 0; i < RLIM_NLIMITS; i++) {
> 	...
> 	int r = getrlimit(i, &pl->limits[i].limit);
> 	...

> as you can see original pam sets limits to inherited defaults. After
> code written above Debian adds their patch:

> if (limits_not_defined_in_limits_conf) {
> 	...
> 	case RLIMIT_NOFILE:
> 	...
> 		pl->limits[i].limit.rlim_cur = RLIM_INFINITY;
> 		pl->limits[i].limit.rlim_max = RLIM_INFINITY;
> 	...
> }

> so as you can see inherited default limits are overriden to infinity.
> In my opinion Debian should revert their patch which is, at least,
> pretty incorrect and unsecure.

It has already been mentioned that this does not apply to the upcoming
Debian 5.0 release (lenny); this patch is only present in the 4.0 release
(etch), it was actually fixed in the development series to not use
RLIM_INFINITY *because* previous kernels didn't support this and would cause
pam_limits to throw log warnings.

Nevertheless, this is not "incorrect and [in]secure."  Raising the default
limits to their maximum values in Debian's Linux-PAM is a deliberate
decision to ensure that the limits applied when su'ing from another user are
the same as when logging in directly as that user, without requiring full
specification of all limits in limits.conf for all users.  It happens to
fail in this case because the default set by the kernel for all users is
different from the maximum allowed by the kernel; but if setting NOFILE to
RLIM_INFINITY isn't a sane thing to do, why does the kernel allow it?  Note
that reverting the Debian PAM change doesn't prevent a local admin from
accidentally triggering this problem because they want to unlimit one or
more of their users.

The purpose of pam_limits is to enable admins to easily apply resource
policies, not to dictate what the set of valid policies is.  If
RLIM_INFINITY is not a sane value for RLIMIT_NOFILE, the kernel should
disallow it.

> Next argument is POSIX compatibility (from setrlimit() specification):

> "The value RLIM_INFINITY, defined in <sys/resource.h>, shall be
> considered to be larger than any other limit value. If a call to
> getrlimit() returns RLIM_INFINITY for a resource, it means the
> implementation shall not enforce limits on that resource. Specifying
> RLIM_INFINITY as any resource limit value on a successful call to
> setrlimit() shall inhibit enforcement of that resource limit."

> So kernel does what is expected. If you want "unlimited" number of
> descriptors, you have it.

This is not a POSIX compliance issue.  POSIX does not require that
setrlimit(RLIMIT_NOFILE, RLIM_INFINITY) *succeeds*; it only requires that,
*if* it succeeds, it has the described semantics.

Cheers,
-- 
Steve Langasek                   Give me a lever long enough and a Free OS
Debian Developer                   to set it on, and I can move the world.
Ubuntu Developer                                    http://www.debian.org/
slangasek@ubuntu.com                                     vorlon@debian.org
