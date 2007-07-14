Return-Path: <linux-kernel-owner+w=401wt.eu-S1764774AbXGNTxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764774AbXGNTxJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 15:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764498AbXGNTwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 15:52:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36452 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763990AbXGNTwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 15:52:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: david@lang.hm
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
Date: Sat, 14 Jul 2007 22:00:16 +0200
User-Agent: KMail/1.9.5
Cc: Jeremy Maitin-Shepard <jbms@cmu.edu>, "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <1184167831.12556.13.camel@caritas-dev.intel.com> <200707131341.35801.rjw@sisk.pl> <Pine.LNX.4.64.0707140017560.25614@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0707140017560.25614@asgard.lang.hm>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707142200.17515.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 14 July 2007 09:51, david@lang.hm wrote:
> On Fri, 13 Jul 2007, Rafael J. Wysocki wrote:
> 
> >> Ok, now we need a data channel from the old kernel to the hibernate
> >> kernel, to the restore kernel. and the messier the memory layout the
> >> larger this data channel needs to be (hmm, what's the status on the memory
> >> defrag patches being proposed?) if this list can be made small enough it
> >> would work to just have the old kernel put the data in a known location in
> >> ram, and let the other two parts find it (in ram for the hibernate kernel,
> >> in the hibernate image for the wakeup kernel).
> >
> > I think the hibernation kernel should mmap() the "old" kernel's (and it's
> > processes') memory available for saving, so that the image-saving process
> > can read its contents from the original locations.
> 
> but I'll bet that not all kernels keep the info in the same place (and 
> probably not even in the same format). I'm suggesting that a standard be 
> defined for the format of the data and the location of a pointer to it 
> that will be maintained across kernel versions.

Yes.

The image-saving kernel needs to have access to the hibernated kernel's
pages data, plus some additional information that should be passed in a
standard format.

> >> how do the existing hibernate processes store this?
> >
> > There are two approaches.  In the first of them (used in the mainline) we just
> > create copies of all pages eligible for saving (hence we can't create images
> > larger than 50% of RAM) atomically and then we save the contents of these
> > copies (either directly from the kernel or through a user space process).  This
> > way we don't need to worry that they may be modified before we can save
> > them.
> >
> > The other approach is the Nigel's one, in which all LRU pages are first saved
> > and then used as additional storage for copying the rest of memory contents.
> > This has a drawback that we are not 100% sure if the LRU won't be modified
> > after we've used them to store the copies of the other pages.
> 
> and since both current approaches use the same kernel for everything the 
> issues I'm thinking of simply don't apply.
> 
> >> since people are complaining about the amount of ram that a kexec kernel
> >> would take up I'm assuiming it's somethingmore complex then just a bitmap
> >> of all possible pages.
> >
> > No, it's just bitmaps, AFAICS, and the complaints are a bit overstated, IMO. ;-)
> 
> 1 bit for each 4k means 1m bits for 4g of ram, or 128k of bitmaps, growing 
> up to 1m of ram used for 32G of ram in the system. I guess this isn't bad 
> as long as it doesn't need to be contiguous for the new kernel to access 
> it.
> 
> ok, that makes it a pretty trivial thing to work with. I just need to 
> learn how to find the bitmaps.

They are created on the fly before the hibernation.  The format is described in
kernel/power/snapshot.c .

> >> most of the conversation so far has been around the process of makeing the
> >> snapshot and storing it. what are the processes and tools available to
> >> restore images?
> >
> > We have quite an efficient restoration code in the kernel right now.  It's
> > able to upload big images (something like total RAM minus the size of the
> > boot kernel, initrd and, optionally, the resume application), which is much
> > more than we're able to save. :-)
> >
> > It can work with images uploaded via /dev/snapshot from the user space
> > (specific image format is required, but that can be changed easily).
> 
> Ok, so it sounds as if the restore is basicly a solved problem, great!
> 
> so now I want to do a but-ugly hibernate configuration.
> 
> while I haven't done it yet I am very confident that I can enable kexec 
> and create a kernel and filesystem to boot into. I can then use perl to 
> get the bitmaps out of kmem (once I learn how to find them), and then can 
> read from kmem to a file to save the 4k chunks that I need to a file.
> 
> it'll be ugly and use lots of partitions, but it should end up being solid 
> from what I am understanding.
> 
> where can I learn how to find the bitmaps and what format things need to 
> be in to feed into /dev/snapshot?

Well, see above.

BTW, please read this message and tell me what you think:

http://lkml.org/lkml/2007/7/13/265

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
