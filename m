Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbZETCqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbZETCqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 22:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbZETCqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 22:46:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59009 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbZETCqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 22:46:22 -0400
Subject: Re: [PATCH] IMA: Minimal IMA policy and boot param for TCB IMA
 policy
From: Eric Paris <eparis@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, jmorris@namei.org, safford@watson.ibm.com
In-Reply-To: <1242669140.3526.76.camel@dyn9002018117.watson.ibm.com>
References: <20090518160144.31953.95567.stgit@dhcp231-142.rdu.redhat.com>
	 <1242669140.3526.76.camel@dyn9002018117.watson.ibm.com>
Content-Type: text/plain
Date: Tue, 19 May 2009 22:44:04 -0400
Message-Id: <1242787444.2763.73.camel@dhcp231-142.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-18 at 13:52 -0400, Mimi Zohar wrote:
> On Mon, 2009-05-18 at 12:01 -0400, Eric Paris wrote: 
> > The IMA TCB policy is dangerous.  A normal use can use all of a system's
> > memory (which cannot be freed) simply by building and running lots of
> > executables.  The TCB policy is also nearly useless because logging in as root
> > often causes a policy violation when dealing with utmp, thus rendering the
> > measurements meaningless.
> > 
> > There is no good fix for this in the kernel.  A full TCB policy would need to
> > be loaded in userspace using LSM rule matching to get both a protected and
> > useful system.  But, if too little is measured before userspace can load a real
> > policy one again ends up with a meaningless set of measurements.  One option
> > would be to put the policy load inside the initrd in order to get it early
> > enough in the boot sequence to be useful, but this runs into trouble with the
> > LSM.  For IMA to measure the LSM policy and the LSM policy loading mechanism
> > it needs rules to do so, but we already talked about problems with defaulting
> > to such broad rules....
> 
> Exactly. Although it is possible to load the IMA policy in the initrd,
> the IMA policy would need to be enabled after the LSM policy is loaded
> in order to define LSM specific rules, but the SELinux policy itself
> would not be measured, as it is not defined in the initrd, but on the
> root filesystem. Measuring files really needs to start before the root
> filesystem is mounted.

Yes, quite the chicken/egg....

And I'm really questioning the whole IMA + readahead interaction issues.
I guess it makes readahead easier if we always measure all exec'd and
mmap for exec files, the cache will always be hot if you have enough
memory.

I'm pretty opposed to a default policy in which a non-priv user can
easily OOM a box (if only there were some way to free this memory...)

I'm going to sleep on it again tonight.  I sorta feel like my rule set
could be reasonable for many distro purposes, but at the same time,
those use cases might be willing to accept some period of startup
without continuous measurement (and thus willing to accept the no-rule
default)

In any case, I'm leaning toward the command line ima_tcb option so users
can avoid the nasty chicken/egg initrd/kernel_init/lsm_init/userspace
issues that having incomplete coverage early in the process would result
in if they so choose.

> The other option would be to define a file security/ima/enable, which
> could be enabled in the initrd, and defer calling ima_init_policy() to
> then. With no policy, the measurement list would only contain the boot
> aggregate. Either approach is fine.

I hacking the initrd to mount a securityfs and echo 1 into a magic file
better than a kernel command line option?  I don't think so, but maybe
others on list would disagree.....

