Return-Path: <linux-kernel-owner+w=401wt.eu-S1031492AbXDZUIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031492AbXDZUIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 16:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031495AbXDZUIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 16:08:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51499 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031492AbXDZUIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 16:08:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Date: Thu, 26 Apr 2007 22:12:26 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Kenneth Crudup <kenny@panix.com>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Con Kolivas <kernel@kolivas.org>,
       suspend2-devel@lists.suspend2.net, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
References: <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org> <alpine.LFD.0.98.0704251702290.9964@woody.linux-foundation.org> <alpine.LFD.0.98.0704251706200.9964@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704251706200.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704262212.27535.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 26 April 2007 02:34, Linus Torvalds wrote:
> 
> On Wed, 25 Apr 2007, Linus Torvalds wrote:
> > 
> > The *thaw* needs to happen with devices quiescent. 
> 
> Btw, I sure as hell hope you didn't use "suspend()" for that. You're 
> (again) much better off having a totally separate function that just 
> freezes stuff.
> 
> So in the "snapshot+shutdown" path, you should have:
> 
>  - prepare_to_snapshot() - allocate memory, and possibly return errors
> 
>    We can skip this, if we just make the rule be that any devices that 
>    want to support snapshotting must always have the memory required for 
>    snapshotting pre-allocated. Most devices really do allocate memory for 
>    their state anyway, and the only real reason for the "prepare" stage 
>    here is becasue the final snapshot has to happen with interrupts off, 
>    obviously. So *if* we don't need to allocate any memory, and if we 
>    don't expect to want to accept some early error case, this is likely 
>    useless.

I think we need this.  Apparently, some device drivers need as much as 30 meg
of RAM at later stages (I don't know why and what for).

>  - snapshot() - actually save device state that is consistent with the 
>    memory image at the time. Called with interrupts off, but the device 
>    has to be usable both before and afterwards!
> 
> And I would seriously suggest that "snapshot()" be documented to not rely 
> on any DMA memory, exactly because the device has to be accessible both 
> before and after (before - because we're running and allocating memory, 
> and after - because we'll be writing thigns out). But see later:

Please note that some drivers are compiled as modules and they may deal with
uninitialized hardware (or worse, with the hardware initialized by the BIOS in
a crazy way) after restart_snapshot().  It may be better for them to actually
quiesce the devices here too to avoid problems after restart_snapshot() .

> For the "resume snapshot" path, I would suggest having 
> 
>  - freeze(): quiesce the device. This literally just does the absolute 
>    minimum to make sure that the device doesn't do anything surprising (no 
>    interrupts, no DMA, no nothing). For many devices, it's a no-op, even 
>    if they can do DMA (eg most disk controllers will do DMA, but only as 
>    an actual result of a request, and upper layers will be quiescent 
>    anyway, so they do *not* need to disable DMA)
> 
>    NOTE! The "freeze()" gets called from the *old* kernel just _before_ a
>    snapshot unpacking!!

Yes, and usually the majority of modules is not loaded at that time.

>  - restart_snapshot() - actually restart the snapshot (and usually this 
>    would involve re-setting the device, not so much trying to restore all 
>    the saved state. IOW, it's easier to just re-initialize the DMA command 
>    queues than to try to make them "atomic" in the snapshot).
> 
>    NOTE! This gets called by the *new* kernel _after_ the snapshot resume!

I think devices _should_ be resetted in restart_snapshot(), unless it's
possible to check if they have already been initialized by the "old" kernel -
but this information would have to be available from the device itself.

> And if you *want* to, I can see that you might want to actually do a 
> "unfreeze()" thing too, and make the actual shapshotting be:

What unfreeze() would be needed for in that case?

> 	/* We may not even need this.. */
> 	for_each_device() {
> 		err = prepare_to_snapshot();
> 		if (err)
> 			return err;
> 	}

We need to free as much memory as we'll need for the image creation at this
point.

> 	/* This is the real work for snapshotting */
> 	cli();
> 	for_each_device()
> 		freeze(dev);

You've added freeze() here, but it's not on your list above?

> 	for_each_device()
> 		snapshot(dev);
> 	.. snapshot current memory image ..
> 	for_each_device_depth_first()
> 		unfreeze(dev);
> 	sti();
> 
> and maybe it's worth it, but I would almost suggest that you just make the 
> rule be that any DMA etc just *has* to be re-initialized by 
> "restart_snapshot()", in which case it's not even necessary to 
> freeze/unfreeze over the device, and "snapshot()" itself only needs to 
> make sure any non-DMA data is safe.
>
> But adding the freeze/unfreeze (which is a no-op for most hardware anyway) 
> might make things easier to think about, so I would certainly not *object* 
> to it, even if I suspect it's not necessary.

I think it's not necessary.

> Anyway, the restore_snapshot() sequence should be:
> 
> 	/* Old kernel.. Normal boot, load snapshot image */
> 	cli()
> 	for_each_device()
> 		freeze(dev);
> 	restore_snapshot_image();
> 	restore_regs_and_jump_to_image();
> 	/* noreturn */
> 
> 
> 	/* New kernel, gets called at the snapshot restore address
> 	 * with interrupts off and devices frozen, and memory image
> 	 * constsntent with what it was at "snapshot()" time
> 	 */
> 	for_each_dev_depth_first()
> 		restore_snapshot(dev);
> 	/* And if you want to, just to be "symmetric"
> 
> 		for_each_dev_depth_first()
> 			unfreeze(dev)
> 
> 	   although I think you could just make "restore_snapshot()" 
> 	   implicitly unfreeze it too..

Agreed.

> 	 */
> 	sti();
> 	/* We're up */
> 
> and notice how *different* this is from what happens for s2ram. There 
> really isn't anything in common here. Exactly because s2ram simply doesn't 
> _have_ any of the issues with atomic memory images.

Agreed again.

Moreover, in the s2ram case there are no problems with device drivers compiled
as modules.

Greetings,
Rafael
