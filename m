Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299Ab0BLQwG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 11:52:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757063Ab0BLQwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 11:52:04 -0500
Date: Fri, 12 Feb 2010 08:51:29 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Takashi Iwai <tiwai@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] sound fixes
In-Reply-To: <s5hocjulb8f.wl%tiwai@suse.de>
Message-ID: <alpine.LFD.2.00.1002120848550.7792@localhost.localdomain>
References: <s5hocjulb8f.wl%tiwai@suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 12 Feb 2010, Takashi Iwai wrote:
> 
> Jody Bruchon (1):
>       ALSA: hda-intel: Avoid divide by zero crash

I pulled, but I really think it should look more like:

> 
> ---
>  sound/pci/hda/hda_intel.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
> index b8faa6d..e767c3f 100644
> --- a/sound/pci/hda/hda_intel.c
> +++ b/sound/pci/hda/hda_intel.c
> @@ -1893,6 +1893,12 @@ static int azx_position_ok(struct azx *chip, struct azx_dev *azx_dev)
>  
>  	if (!bdl_pos_adj[chip->dev_index])
>  		return 1; /* no delayed ack */
> +	if (azx_dev->period_bytes == 0) {
> +		printk(KERN_WARNING
> +		       "hda-intel: Divide by zero was avoided "
> +		       "in azx_dev->period_bytes.\n");
> +		return 0;
> +	}

	if (WARN_ONCE(!azx_dev->period_bytes, "hda-intel: zero azx_dev->period_bytes")
		return 0;

or something. It really doesn't want to warn multiple times, and by using 
a WARN_ONCE() it will also get picked up by kerneloops etc.

Or if that zero period_bytes is normal under certain circumstances, then 
there shouldn't be a printout at all.

		Linus
