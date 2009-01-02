Return-Path: <linux-kernel-owner+w=401wt.eu-S1758210AbZABMVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210AbZABMVe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 07:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757381AbZABMVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 07:21:25 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:34251 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757367AbZABMVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 07:21:25 -0500
Date: Fri, 2 Jan 2009 13:21:22 +0100
From: Andreas Mohr <andi@lisas.de>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Andreas Mohr <andi@lisas.de>, Sriram V <vshrirama@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Power Management with rootfs on SDMMC.
Message-ID: <20090102122122.GA2097@rhlx01.hs-esslingen.de>
References: <8bf247760901012235v20bb448ch5c34fb2791ea83ca@mail.gmail.com> <20090102102152.GA26603@rhlx01.hs-esslingen.de> <20090102122148.175cff4a@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090102122148.175cff4a@mjolnir.drzeus.cx>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 12:21:48PM +0100, Pierre Ossman wrote:
> On Fri, 2 Jan 2009 11:21:52 +0100
> Andreas Mohr <andi@lisas.de> wrote:
> 
> > 
> > There have been long threads on mobile phone and netbook related forums about issues
> > with seemingly "any slightly advanced use whatsoever" of partitions on SD cards.
> > 
> 
> As you may notice, you only get egg on your face when you suspend, so
> it's really just the single problem. Granted, it's still a big one.

The problem being that I (just like many other users) am trying to suspend 
"all the time" (my God-Given Right ;), with issues popping up "all the time"
(Intel VC switching, microcode module, ath5k, and SD slots, just to name
all resume issues - now mostly working - on one single machine recently).
And I'm just fed up with it, sorry to have to put it that bluntly.

> > IMHO in this strongly increasingly netbook- and mobile phone-enabled world it's
> > a bloody shame that:
> > - we have a hanging suspend/resume on an SD rootfs (often the only way of
> >   achieving serious Linux use on a mobile phone!)
> 
> I take it this is without CONFIG_MMC_UNSAFE_RESUME.

Indeed (and I admittedly haven't even done any .28 tests yet about the
previous observations of suspend hangs and resume hangs
and partition corruption).

But one of my items was that CONFIG_MMC_UNSAFE_RESUME itself seems a
pretty inflexible and _hard-wired-selectable_ workaround measure anyway.

> The fundamental problem is that we have no way of detecting if a card
> was removed during suspend, meaning we cannot guarantee that we'll
> return the hardware to the upper layers in the same state it was
> before the suspend.
> 
> There are two improvements that can be made here:
> 
> - Don't power down the card during suspend. This eats more power and
>   might not be supported on all systems, but it allows us to detect any
>   removal. This has been on my todo list for ages, but I haven't found
>   any time to implement it (or even test if I have any systems that
>   might support it).

While this would improve things, it seems to be the second-best solution only,
especially since this probably requires properly working removal
notification for _every_ controller type.

> - Have upper layers handle removal detection. E.g. in the common case
>   of rootfs, the filesystem driver verifies that the storage is in the
>   same state when it resumes as it was when it suspended. This requires
>   a lot of work though as AFAIK there is no suspend functionality in
>   either the block layer or the VFS.

To me this seems to be the clearly preferred method.
(CC'd VFS, already pondered before whether I should do this but decided not to yet)

> > - we lose partition mounts due to full device re-probing instead of re-using the
> >   same minor device ID after resume
> 
> This is a block layer issue, and I don't know if it's fixable.
> 
> Basically the problem is that someone is keeping the resources
> associated with the pre-suspend block device pinned in memory. When the
> post-suspend block device is created, it cannot reuse the device IDs
> since they are still in use.

I thought so, but someone would need to get to the bottom of this
and figure out a way to get a nice suspend routines support/workaround.

> > - installing a swap partition on an SD card and then resuming can easily
> >   go as far as __even completely corrupting__ the entire SD card partitioning
> >   plus first partition (corrupts first 1kB of the card: both table and partition)
> >   People then immediately resort to a non-helpful "Don't Do This, Ever" reply
> >   (using swap partition on SD and suspend, see http://dev.laptop.org/ticket/6532#comment:10),
> 
> Hmm... I was under the impression that they got this fixed nice and
> proper. Perhaps comment 34 should be sent to lkml and/or added to the
> kernel bugzilla.

Right, #34 seems to describe pretty much what I think should be done
(keep things powered-down, then resume and compare with existing remembered
media id and revive old device handle in case it's actually same card).

("media id" above preferrably being a generic kernel concept of a media id
mechanism supported for all sorts of different media that a controller
may allow the kernel to support).


As a side note, I'm voicing a "me too" of not being too happy
to see people hard-coding timeouts there to try to "fix" this issue
instead of directly trying to come up with a synchronized signalling method
to fix this race there.


Am I right in thinking that if this is fixed properly, it would be the
CONFIG_MMC_UNSAFE_RESUME way of handling things, just in a sufficiently safe
manner? (notwithstanding user stupidity, i.e. hard removal of cards)
(i.e. CONFIG_MMC_UNSAFE_RESUME would then just be made default?)
Or... hmm... perhaps CONFIG_MMC_UNSAFE_RESUME actually would already
work for me entirely with my PCIE hotplug controller
in case its driver already provides reliably timed controller reinit
 / media re-detection after resume...

Anyway, the general thinking here _has_ to be:
if a mounted card remains in the slot during suspend, then it _should_ get
re-assigned properly, and if it has been removed despite not being
unmounted, then after resume the kernel should actively discard all references
(and throw a warning or some such).
And having a special CONFIG_MMC_UNSAFE_RESUME isn't really helpful here AFAICS,
VFS (and all related layers) should be able to handle this on its own
in its entirety, and if it's not able to do this
then it is to be considered very buggy and ought to be fixed.

But this is all common wisdom anyway I'd think, someone would have to actually
implement things to correctly work this way.


I actually thought of digging into this myself some time, but as opposed
to libata UDMA issues or WLAN LED support it's way too problematic
to tackle for me since it's said to be deep in VFS lands and debugging on
this measly machine would additionally take ages (2 hours in case one
needs an entire kernel build), plus limited time.

Thanks for your comments!

Andreas Mohr
