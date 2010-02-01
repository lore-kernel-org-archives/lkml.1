Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab0BAWaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 17:30:09 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:34953 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab0BAWaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 17:30:06 -0500
Date: Mon, 1 Feb 2010 23:30:01 +0100
From: Andreas Mohr <andi@lisas.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Sebastian Siewior <bigeasy@linutronix.de>, Greg KH <greg@kroah.com>,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: USB mass storage and ARM cache coherency
Message-ID: <20100201223001.GA17627@rhlx01.hs-esslingen.de>
References: <20100129185434.GH19501@one-eyed-alien.net> <1265045354.25750.52.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265045354.25750.52.camel@pc1117.cambridge.arm.com>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC Takashi]

On Mon, Feb 01, 2010 at 05:29:14PM +0000, Catalin Marinas wrote:
> On Fri, 2010-01-29 at 18:54 +0000, Matthew Dharm wrote:
> > HOWEVER, I firmly believe that the cache-management functions belong with
> > the driver that actually talks to the low-level hardware, as that's the
> > only place where you can be 100% certain of what cache operations are
> > needed.  After all, I think someone is working on a USB-over-IP transport,
> > and trying to manage cache at the usb-storage level in that scenario is
> > just silly.
> > 
> > So, let's put this in the HCD drivers and be done with it.
> 
> The patch below is what fixes the I-D cache incoherency issues on ARM. I
> don't particularly like the solution but it seems to be the only one
> available.

Thanks very much for working on this amazingly large problem!

I took some time to add your patch to ehci-q.c / ohci-q.c
(for my *hci-ssb.c ASUS WL-500gP v2), on my now _heavily_ patched-up 2.6.31.9,
but _UNFORTUNATELY_ it kept locking up the same way as always when stopping
playback despite being damn sure this time that this patch could have
the potential to finally fix it ;)
(I had to replace memory.h with page.h on my arch though, to fix the build)

This is on MIPSEL (not one of my many ARM devices, unfortunately ;),
with usb-audio, and the madplay process crashes in __bzero(),
which strongly indicates cache coherency issues (other subsequent backtraces
have lots of mmap and vma listed, see also my "snd_usb_audio OOPS on MIPSEL -
is that the mmap issue?").

Next thing I'll do is fire up gdb and get a good backtrace of the
__bzero() address to find out which page handling in mpd exactly
is hampered with crashes. This is now ~ the third patch that I applied
on-the-go and that didn't help, so it's probably time to do
some earnest analysis on what's really going on locally.

Note that usb-storage itself does work on this platform though.

Rather annoying to be so close (sound works) yet so far away,
especially after all that USB host trouble I already had.

Thanks a lot again,

Andreas Mohr
