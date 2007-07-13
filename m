Return-Path: <linux-kernel-owner+w=401wt.eu-S933610AbXGMJWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933610AbXGMJWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 05:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761026AbXGMJWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 05:22:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58865 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757971AbXGMJWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 05:22:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: david@lang.hm
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
Date: Fri, 13 Jul 2007 11:29:33 +0200
User-Agent: KMail/1.9.5
Cc: "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <1184167831.12556.13.camel@caritas-dev.intel.com> <200707122134.29991.rjw@sisk.pl> <Pine.LNX.4.64.0707121953440.25614@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0707121953440.25614@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707131129.34974.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 13 July 2007 05:06, david@lang.hm wrote:
> On Thu, 12 Jul 2007, Rafael J. Wysocki wrote:
> 
> > On Thursday, 12 July 2007 20:57, david@lang.hm wrote:
> >> On Thu, 12 Jul 2007, Rafael J. Wysocki wrote:
> >>
> >>>> 2. Do not reserve memory for kexec kernel. That is, backup needed memory
> >>>> before kexec and restore them after kexec.
> >>>
> >>> I don't think this is very important initially.
> >>
> >> I agree, a stipped down hibernate kernel can be very small, not allocating
> >> this memory until it's needed is a step for the final polishing.
> >
> > I'm not sure if I agree with that.  In any case, having to use two different
> > kernels for hibernation would be a big drawback.
> 
> I see it as a big advantage to not have to use the main kernel for the 
> suspend. please keep it as an option at least.

That depends on what we would like to support.  For example, we may need to use
the same kernel for the suspend-to-disk-and-RAM feature.

> >>>> 3. Support the in-place kexec? The relocatable kernel is not necessary
> >>>> if this can be implemented.
> >>>> 4. Image writing/reading. (Only user space application is needed).
> >>>
> >>> And a kernel interface for that application.
> >>
> >> I do't understand this statement, this application is just useing the
> >> standard kernel interfaces (block devices to read/write to disk, network
> >> devices to read/write to a server, etc). no new interfaces needed.
> >
> > Yes, but it will have to know _what_ to save, no?
> >
> > Plus we need to figure out how to avoid corrupting filesystems and swap in use
> > by the "old" kernel and its processes (hint: a separate "hibernation partition"
> > is a no-go).
> 
> I thought the existing hibernation wrote to the swap partition as it's 
> dedicated space?
> 
> I didn't know that anyone was suggesting writing the hibernation image to 
> a filesystem that the kernel was activly accessing.

We can write to a swap file and Nigel can write to a nonswap file too.

Plus if we use swap for hibernation, we need to know which swap pages have been
allocated for normal use by the kernel.

> >>>> 5. A smooth resume process. Maybe it is not needed to kexec a new kernel
> >>>> for resume. For example, in the first stage of kernel boot, just first
> >>>> 16M (or a little more) RAM is used, if the resume image is found, the
> >>>> saved kernel image is resumed; if the resume image is not found, turn on
> >>>> the remaining RAM. This will depends on 3.
> >>>
> >>> I think that this is the most difficult part of the whole thing.
> >>
> >> don't try to get too fancy right now. stick with a simple 'boot hibernate
> >> kernel, it's userspace looks for an image to resume, and if it doesn't
> >> find one reboot to the normal system'
> >>
> >> I don't know how to do this with grub, but it would be a trivial shell
> >> script with lilo
> >
> > I think it's most portable to use initrd for that, which already makes things
> > complicated.  Then, we'll have to load the image and jump to the hibernated
> > kernel in such a way that it would be able to continue from where it stopped
> > before.  I don't think that is trivial.
> 
> I was talking about the scripts that would be used inside the initrd (or 
> boot partition of whatever type)
> 
> to start with don't worry about how the kexec kernel gets it's / 
> filesystem (for testing just use a real partition on your disk. after you 
> get everything working let the people who really understand the initrd and 
> consider it trivial switch it to an initrd image)

Well, my experience shows that you need to do everything yourself up to a
certain point.

> fo rthe current stage where we are trying to make things work don't worry 
> about packaging everything tight with initrd and re-useing partitions or 
> kernel images. once everything is working reliably then it's time to look 
> at useing the same kernel for multiple functions, writing to a partition 
> that's i use for other things, etc

I don't agree.  You need to think of many limitations in advance, because
they need to be taken into consideration in the design.

Otherwise we'll end up with something that will need to be bandaided like the
freezer. :-)

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
