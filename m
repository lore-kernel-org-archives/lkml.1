Return-Path: <linux-kernel-owner+w=401wt.eu-S1161117AbXAZSFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161117AbXAZSFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 13:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161120AbXAZSFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 13:05:55 -0500
Received: from mx1.suse.de ([195.135.220.2]:34344 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161117AbXAZSFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 13:05:54 -0500
Date: Fri, 26 Jan 2007 10:04:57 -0800
From: Greg KH <greg@kroah.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: xiphmont@xiph.org, Pierre Ossman <drzeus@drzeus.cx>,
       fedora-desktop-list@redhat.com, alsa-devel@alsa-project.org,
       jrb@redhat.com, linux-kernel@vger.kernel.org, mclasen@redhat.com,
       Lennart Poettering <lennart@poettering.net>, perex@suse.cz
Subject: Re: [Alsa-devel] [PATCH] alsa: correct nonsensical sysfs device symlinks
Message-ID: <20070126180457.GA29543@kroah.com>
References: <806dafc20701251007n69bc9b3cse023b51369501d42@mail.gmail.com> <s5h4pqfufs8.wl%tiwai@suse.de> <806dafc20701251034l59fc5be7ta881606046eb819a@mail.gmail.com> <s5h1wljuf2f.wl%tiwai@suse.de> <806dafc20701251051p2750cb34sab88a38282020497@mail.gmail.com> <20070125194933.GA27857@kroah.com> <806dafc20701251240t70335055l74c47ecdd09d1944@mail.gmail.com> <20070125215943.GC3126@kroah.com> <806dafc20701260253r145fee43kc6db1ca6de1ab3e6@mail.gmail.com> <s5hejpivwwg.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hejpivwwg.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 26, 2007 at 12:40:31PM +0100, Takashi Iwai wrote:
> At Fri, 26 Jan 2007 05:53:36 -0500,
> xiphmont@xiph.org wrote:
> > 
> > On 1/25/07, Greg KH <greg@kroah.com> wrote:
> > 
> > > Is there anything else left to fix?
> > 
> > Once that testing is done, no.  But don't trust the two patches I sent
> > yet, I'll resumbit the patch resulting from more thorough testing in a
> > few hours (much thanks to Takashi for giving me the parent device
> > feedback I was trolling for).
> 
> After rechecking the current code regarding this sysfs change at last
> night, I found out that it's more broken for some devices like
> sound/arm/*.  They refer to card->dev to obtain the device for memory
> allocation, etc, and passing card* object will screw them up.
> 
> The below is my current fix.  Hoepfully all evils got away now...  and
> thanks for Monty for heading up this issue!
> 
> 
> Takashi
> 
> ====
> [PATCH] ALSA: Fix sysfs breakage
> 
> The recent change for a new sysfs tree with card* object breaks the
> /sys/class/sound tree if CONFIG_SYSFS_DEPRECATED is enabled.
> The device in each entry doesn't point the correct device object:
> 
>   /sys/class/sound
>   ...
>   |-- pcmC0D0c
>   |   |-- dev
>   |   |-- device -> ../../../class/sound/card0
>   |   |-- pcm_class
>   |   |-- power
>   |   |   `-- wakeup
>   |   |-- subsystem -> ../../../class/sound
>   |   `-- uevent
> 
> Also, this change breaks some drivers (like sound/arm/*) referring
> card->dev directly to obtain the device object for memory handling.
> 
> This patch reverts the semantics of card->dev to the former version,
> which points to a real device object.  The card* object is stored in a
> new card->card_dev field, instead.  The device parent is chosen either
> card->dev or card->card_dev according to CONFIG_SYSFS_DEPRECATED to
> keep the tree compatibility.
> Also, card* isn't created if CONFIG_SYSFS_DEPRECATED is enabled.  The
> reason of card* object is a root of all beloing devices, and it makes
> little sense if each sound device points to the real device object
> directly.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Thanks for working on tracking this down, sorry I forgot all about this
when doing this original conversion.

greg k-h
