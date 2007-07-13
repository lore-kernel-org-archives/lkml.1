Return-Path: <linux-kernel-owner+w=401wt.eu-S1758202AbXGMLwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202AbXGMLwb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 07:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbXGMLwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 07:52:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59735 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755171AbXGMLwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 07:52:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: david@lang.hm
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
Date: Fri, 13 Jul 2007 13:59:52 +0200
User-Agent: KMail/1.9.5
Cc: "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <1184167831.12556.13.camel@caritas-dev.intel.com> <200707131129.34974.rjw@sisk.pl> <Pine.LNX.4.64.0707130227310.25614@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0707130227310.25614@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707131359.53309.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 13 July 2007 11:38, david@lang.hm wrote:
> On Fri, 13 Jul 2007, Rafael J. Wysocki wrote:
> 
> > On Friday, 13 July 2007 05:06, david@lang.hm wrote:
> >> On Thu, 12 Jul 2007, Rafael J. Wysocki wrote:
> >>
> >>> On Thursday, 12 July 2007 20:57, david@lang.hm wrote:
> >>>> On Thu, 12 Jul 2007, Rafael J. Wysocki wrote:
> >>>>
> >>>>>> 2. Do not reserve memory for kexec kernel. That is, backup needed memory
> >>>>>> before kexec and restore them after kexec.
> >>>>>
> >>>>> I don't think this is very important initially.
> >>>>
> >>>> I agree, a stipped down hibernate kernel can be very small, not allocating
> >>>> this memory until it's needed is a step for the final polishing.
> >>>
> >>> I'm not sure if I agree with that.  In any case, having to use two different
> >>> kernels for hibernation would be a big drawback.
> >>
> >> I see it as a big advantage to not have to use the main kernel for the
> >> suspend. please keep it as an option at least.
> >
> > That depends on what we would like to support.  For example, we may need to use
> > the same kernel for the suspend-to-disk-and-RAM feature.
> 
> I missed this discussion. is this idea to suspend, write to disk, but 
> leave things in ram so that if you wakeup soon enough you have everything 
> for ram, but if you don't and the battery dies you can restore from disk?
> 
> if so I think it's a mistake to mix the two. it would be better to just 
> suspend to ram, and wake up once in a while to check the battery state and 
> when the battery gets low enough do the suspend to disk.
> 
> otherwise you end up mixing the requirements of the two types of suspend, 
> which is how things got so ugly in the first place.

Not necessarily.  If we don't put devices into low power states before creating
the image, that should work just fine (quiesce devices, create the image or
kexec the new kernel, reprobe devices, save the image, suspend to RAM,
resume from RAM, continue - or restore from the image if power failed in the
meantime).  Still, for this purpose, both kernels need to be able to handle the
same set of devices.

> >>>>>> 5. A smooth resume process. Maybe it is not needed to kexec a new kernel
> >>>>>> for resume. For example, in the first stage of kernel boot, just first
> >>>>>> 16M (or a little more) RAM is used, if the resume image is found, the
> >>>>>> saved kernel image is resumed; if the resume image is not found, turn on
> >>>>>> the remaining RAM. This will depends on 3.
> >>>>>
> >>>>> I think that this is the most difficult part of the whole thing.
> >>>>
> >>>> don't try to get too fancy right now. stick with a simple 'boot hibernate
> >>>> kernel, it's userspace looks for an image to resume, and if it doesn't
> >>>> find one reboot to the normal system'
> >>>>
> >>>> I don't know how to do this with grub, but it would be a trivial shell
> >>>> script with lilo
> >>>
> >>> I think it's most portable to use initrd for that, which already makes things
> >>> complicated.  Then, we'll have to load the image and jump to the hibernated
> >>> kernel in such a way that it would be able to continue from where it stopped
> >>> before.  I don't think that is trivial.
> >>
> >> I was talking about the scripts that would be used inside the initrd (or
> >> boot partition of whatever type)
> >>
> >> to start with don't worry about how the kexec kernel gets it's /
> >> filesystem (for testing just use a real partition on your disk. after you
> >> get everything working let the people who really understand the initrd and
> >> consider it trivial switch it to an initrd image)
> >
> > Well, my experience shows that you need to do everything yourself up to a
> > certain point.
> 
> true, but if you get something that can work reliably, even if ugly, you 
> get a lot more people willing to polish it then is you are asking them to 
> help you implement the core features.

In theory and maybe.  And if you forget of something crucial from the
beginning, then you've just lost time (except for having some fun, perhaps).

> remember release early, release often (with something that functions)
> 
> >> fo rthe current stage where we are trying to make things work don't worry
> >> about packaging everything tight with initrd and re-useing partitions or
> >> kernel images. once everything is working reliably then it's time to look
> >> at useing the same kernel for multiple functions, writing to a partition
> >> that's i use for other things, etc
> >
> > I don't agree.  You need to think of many limitations in advance, because
> > they need to be taken into consideration in the design.
> >
> > Otherwise we'll end up with something that will need to be bandaided like the
> > freezer. :-)
> 
> on the other hand, worrying about all the possible ways to do things can 
> paralize you.
> 
> the big advantage of the kexec approach is that the new userspace that's 
> setup with the new kernel can do _anything_.

No, it can't.  For example, it can't access filesystems mounted by the
hibernated kernel, or they may get corrupted after the restore (if they are
journaling, it can't even read from them).

Which reminds me of one more issue, which is that the image-saving kernel
won't be able to use these filesystems either, so its modules and user space
will have to be available from somewhere else (like a RAM disk or dedicated
partition).  So things get ugly.

Apart from this, the new kernel's user space cannot blindly modify swap space
that might be in use by the hibernated kernel.

> if/when this works you will see people doing things that you probably never
> imagined (a simple one is to suspend a machine at work, send the image
> over the network and resume on a different machine at home). and all these
> strange things are encapsulated so that you don't have to worry about how
> they will be done now.
> 
> it's good to try and find the places where you have fundamental changes to 
> make to support them, but there are a lot of things that boil down to 
> implementation details, everyone agrees that it can be done reliably, the 
> decisions on how just need to be made.

The problem is, we don't know if that can be done reliably, yet.

To convince everyone, we'll need to have a proof-of-concept implementation
working reliably.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
