Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbXIUDl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbXIUDl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 23:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbXIUDlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 23:41:22 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:34344 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbXIUDlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 23:41:22 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, nigel@suspend2.net,
       Pavel Machek <pavel@ucw.cz>, "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump
References: <1190266447.21818.17.camel@caritas-dev.intel.com>
	<200709211120.00448.ncunningham@crca.org.au>
	<20070920184106.79e1858a.akpm@linux-foundation.org>
	<200709211157.28622.nigel@nigel.suspend2.net>
Date: Thu, 20 Sep 2007 21:33:28 -0600
In-Reply-To: <200709211157.28622.nigel@nigel.suspend2.net> (Nigel Cunningham's
	message of "Fri, 21 Sep 2007 11:57:26 +1000")
Message-ID: <m18x70ofp3.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nigel Cunningham <nigel@nigel.suspend2.net> writes:
>
> That's not true. Kexec will itself be an implementation, otherwise you'd end 
> up with people screaming about no hibernation support. 

There needs to be an implementation of hibernation based on kexec with
return yes.

> And it won't result in 
> the complete removal of the existing hibernation code from the kernel. At the 
> very least, it's going to want the kernel being hibernated to have an 
> interface by which it can find out which pages need to be saved.

That interface should be running kernel -> user space -> target kernel.
Not direct kernel to kernel.

> I wouldn't 
> be surprised if it also ends up with an interface in which the kernel being 
> hibernated tells it what bdev/sectors in which to save the image as well 
> (otherwise you're going to need a dedicated, otherwise untouched partition 
> exclusively for the kexec'd kernel to use), or what network settings to use 
> if it wants to try to save the image to a network storage device. 

initramfs.  We already seem to have that interface.  And distros
seems to do a pretty decent job of using it to configure systems.

> On top of 
> that, there are all the issues related to device reinitialisation and so on, 

Yes.

> and it looks like there's greatly increased pain for users wanting to 
> configure this new implementation. 

Not to be callous but that really is a user space and distro issue.

> Kexec is by no means proven to be the panacea for all the issues.

I agree.  I'm still not quite convinced it will do a satisfactory job.
But I think it does make sense to implement a general kexec with
return and see if that can reasonably be used for handling hibernation
issues.  If done cleanly and with care the implementation won't be
hibernation specific.

Frankly this looks like the best way I can see to implement a general
mechanism for calling silly firmware/BIOS/EFI services after we
have a kernel up and running.  It's a little bit like allowing
X to call iopl(3) and do inb/outb directly.

The configuration issues you raise pretty much exist for kexec on
panic, and they seem to be being resolved for that case in a
reasonable way.  I do agree that the current kexec+return effort seems
to be one of those unfortunate cases where we give every mechanism in
the kernel to do something in user space and then no one actually
implements the user space.  That doesn't do any one any good.

For hibernation we don't have the absolute need to step outside of the
current kernel that we do in the kexec on panic approach.  However we
have this practical fight about mechanism and policy, and kexec with
return has this seductive allure that it appears to be the minimal
necessary mechanism in the kernel.

No one has yet attacked the hard problem of coming up with separate
hibernate methods for drivers.  This should be the hard part of the
puzzle, and the recurring work from a kernel maintenance point of
view.  There is some reason to hope that things will be a maintenance
will be a little simpler because you can get at all of the distinct
pieces of the puzzle.

Currently kexec with return appears to require the minimal amount of
mechanism in the kernel and leaves the policy to someplace else, plus
the code is not hibernation specific.  We could use it to make runtime
EFI calls, or to implement cooperative multitasking between kernels.

My current opinion is that the patches are starting to get close
enough that it isn't a waste of my time reviewing them.  But there
is still a fair amount to be done before this code is in shape for
us to merge it into the kernel.

At 500 or so lines I don't feel bad about pushing back until all of
the core user interface issues are resolved, and we have the code
calling the proper driver methods.

Eric
