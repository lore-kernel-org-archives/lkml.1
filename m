Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbZA0Ut5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbZA0Ut5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 15:49:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbZA0Utt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 15:49:49 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:48281 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbZA0Uts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 15:49:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uy64tS940Oa2EE3qCJeYk2aLc4sDNnmsu84c3RvL8FZuM3eNSQ8m83ruGJASbOqlrD
         AhUSsXBceIXib6LKEScUPtHLNorI0C3+S/M2yF5Xi4MArHzuKgZr2O/4Hxl0KziiIoO/
         Nurz8sFbrvETvKiv0JSKlW9RMhdOPAzM/XVsw=
MIME-Version: 1.0
In-Reply-To: <497F60A3.6020608@nerdgrounds.com>
References: <497E4531.20800@nerdgrounds.com>
	 <5bdc1c8b0901261859g58a413e1x52208a6f2c1f9ccd@mail.gmail.com>
	 <497E968F.3020708@nerdgrounds.com>
	 <5bdc1c8b0901271018k7603e413o92de334e8d28d1d7@mail.gmail.com>
	 <497F60A3.6020608@nerdgrounds.com>
Date: Tue, 27 Jan 2009 12:49:46 -0800
Message-ID: <5bdc1c8b0901271249n467a8835n645da642bccd170a@mail.gmail.com>
Subject: Re: Vramfs: filesystem driver to utilize extra RAM on VGA devices
From: Mark Knecht <markknecht@gmail.com>
To: Jonathan Campbell <jon@nerdgrounds.com>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 11:29 AM, Jonathan Campbell <jon@nerdgrounds.com> wrote:
>
> On Mon, Jan 26, 2009 at 9:07 PM, Jonathan Campbell <jon@nerdgrounds.com>
> wrote:
>
>
> Can the GPU use the data placed in your file system?
>
>
> Assuming the GPU can access any part of VRAM, yes. Files created in vramfs
> will always have content that exists somewhere in video ram. A file you
> create never moves, and is always contiguous in memory. All your program
> needs to direct the GPU to it is the block offset from the start of VRAM,
> which can be obtained by an ioctl() or bmap().
>
> I thought the best possible design would be for any process to create a file
> in vramfs, and then direct the attention of whoever's managing the GPU to
> that file (perhaps a user-space daemon), who could open the file and use
> bmap or an ioctl to locate it and direct the GPU to operate on it.
>
>
>
> Yep, as I said in the response to Eric a number of us had talked in
> the past about using the GPU for some audio operations that are just
> too CPU intensive - reverb, multi-band compressors, etc. See Jamin as
> an example of a great app that brings most DAW type boxes to their
> knees.
>
> http://jamin.sourceforge.net/en/about.html
>
>
>
> I'd also like to point out the filesystem structures themselves are never
> placed in VRAM on purpose. I'd hate for files to suddenly disappear from the
> filesystem because of an errant GPU bug or pixel shader gone amok; the worst
> that can happen by doing it that way is that a bunch of files go blank or
> get filled with garbage and no harm done.
>
>
> Do you have strong control as to exactly how the data is mapped into VRAM?
>
>
> Not exactly. When you create a file you get whatever free space is
> available. However, vramfs does guarantee that your file is never
> fragmented, never sparse, and will always exist for the life of the file
> from it's offset in video ram to the offset plus the file size. I believe
> I've written the code to be flexible enough however to allow stronger
> control if needed.
>
>
> So what happens to the file system if the user changes screen
> resolution, color depth, etc.? There must be features to manage stuff
> like that?
>
>
> That depends on the framebuffer driver. Some drivers like radeonfb don't
> clear the VRAM on mode change, so they remain intact until stomped on by
> fbcon or anyone else using /dev/fb0. However, vramfs creates a default
> "framebuffer" file to occupy that region of VRAM for this reason, so as long
> as the default file is large enough to cover any possible framebuffer you
> could set up, and nobody reads/writes /dev/fb0 that far, the files will be
> fine. Vramfs doesn't really need to interact much with the framebuffer
> system.
>
> Again, filesystem structures are never stored in VRAM for this reason: so
> that in the worst case scenario files are overwritten with bitmaps, garbage,
> or cleared. No additional harm done. I wouldn't want the kernel oopses or
> hangs associated with storing kernel structures there.
>
> I suppose vramfs could ask the kernel which framebuffer is attached to the
> PCI device, and ask it the highest possible resolution and bits per pixel
> count (not necessarily supported by the monitor, I mean highest possible
> supported by the CRTC and DACs)

I think it unlikely that any audio engineer is going to purposely
change screen resolutions while doing a mix so I'd not want you to
complicate things for situations like that.

What would happen a lot I think is that while X is running someone
might drop into the console to do something or switch to another
desktop in Gnome or KDE. I suspect those aren't issues but it would be
important not to corrupt any file system data when those happen. For
instance, someone might run a GPU program on one desktop and then move
to their main desktop for mixing, etc. None of that effects the size
of framebuffers as far as I know.

If I was to build this and try it our (not saying I have time right
now though) then as root how do I determine what size file system I
can build? Do I run fdisk against /dev/fb0 and look at what portion is
unallocated?

Thanks,
Mark
