Return-Path: <linux-kernel-owner+w=401wt.eu-S1754923AbZBBQUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbZBBQUv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 11:20:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbZBBQUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 11:20:42 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:5911 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbZBBQUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 11:20:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FV5Pjv8d4w1DQ+F55xtxlDVxTSPEfwUjm0mkjwgu4KzpmBvPWvfTJLStb2vn5Ig6ez
         H2dD2EomfofNbDVaH7hidJWMBSn4JIidE0eMBa/i5L6oo2lJcGCEI9QMIdO0edCejOYr
         Odeme5p1ZQrnMyEuDT7sZwgKYQMkSAQtlC4v4=
Date: Mon, 2 Feb 2009 17:20:00 +0100
From: Adam Tkac <vonsch@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Palfrader <weasel@debian.org>, linux-kernel@vger.kernel.org,
       debian-admin@lists.debian.org, team@security.debian.org,
       libpam-modules@packages.debian.org, stable@kernel.org
Subject: Re: 2.6.28, rlimits, performance and debian etch
Message-ID: <20090202162000.GA3050@evileye.atkac.englab.brq.redhat.com>
References: <20090121115219.GA2754@anguilla.noreply.org> <20090127151703.c356c5db.akpm@linux-foundation.org> <20090129121900.GA2827@evileye.atkac.englab.brq.redhat.com> <20090129100509.6969970f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129100509.6969970f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 10:05:09AM -0800, Andrew Morton wrote:
> On Thu, 29 Jan 2009 13:19:00 +0100 Adam Tkac <vonsch@gmail.com> wrote:
> 
> > 
> > Hi all,
> > 
> > I don't think the "rlim_infinity" patch should be reverted. Let me try
> > to explain why.
> > 
> > First, code which sets limits to RLIM_INFINITY is very bad idea and
> > that code is Debian specific. I downloaded original pam 0.79 (stripped):
> > 
> > for(i = 0; i < RLIM_NLIMITS; i++) {
> > 	...
> > 	int r = getrlimit(i, &pl->limits[i].limit);
> > 	...
> > 
> > as you can see original pam sets limits to inherited defaults. After
> > code written above Debian adds their patch:
> > 
> > if (limits_not_defined_in_limits_conf) {
> > 	...
> > 	case RLIMIT_NOFILE:
> > 	...
> > 		pl->limits[i].limit.rlim_cur = RLIM_INFINITY;
> > 		pl->limits[i].limit.rlim_max = RLIM_INFINITY;
> > 	...
> > }
> > 
> > so as you can see inherited default limits are overriden to infinity.
> > In my opinion Debian should revert their patch which is, at least,
> > pretty incorrect and unsecure.
> > 
> > Next argument is POSIX compatibility (from setrlimit() specification):
> > 
> > "The value RLIM_INFINITY, defined in <sys/resource.h>, shall be
> > considered to be larger than any other limit value. If a call to
> > getrlimit() returns RLIM_INFINITY for a resource, it means the
> > implementation shall not enforce limits on that resource. Specifying
> > RLIM_INFINITY as any resource limit value on a successful call to
> > setrlimit() shall inhibit enforcement of that resource limit."
> > 
> > So kernel does what is expected. If you want "unlimited" number of
> > descriptors, you have it.
> > 
> > Please consider again where exactly problem is, if in Debian patch or
> > in kernel patch. From my point of view Debian patch should be
> > reverted, not the kernel one.
> > 
> 
> Sure, debian might well be wrong.  But the bottom line is that the
> kernel changed, and people's machines broke.
> 
> If the kernel change was really really important then we might just
> grit our teeth and live with the breakage.  But this change _wasn't_ a
> terribly important one.  So I think we should back it out while we find
> another way of implementing it which does not break currently deployed
> installations.

Well, if we should fix Debian's problem I think better would be to set
limit of files to reasonable number instead of sysctl_nr_open (for
example 4096 or 8192).

Adam
