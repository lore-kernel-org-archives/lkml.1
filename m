Return-Path: <linux-kernel-owner+w=401wt.eu-S1764837AbXGaPF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764837AbXGaPF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 11:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762202AbXGaPFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 11:05:19 -0400
Received: from ns1.coraid.com ([65.14.39.133]:14154 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762199AbXGaPFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 11:05:18 -0400
Date: Tue, 31 Jul 2007 11:03:24 -0400
From: "Ed L. Cashin" <ecashin@coraid.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, ak@suse.de
Subject: Re: ATA over ethernet swapping and obfuscated code
Message-ID: <20070731150324.GE3206@coraid.com>
References: <20070731135831.GA4604@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731135831.GA4604@elf.ucw.cz>
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 03:58:31PM +0200, Pavel Machek wrote:
> Hi!
> 
> I wanted to know if it is possible/okay to swap over AOE... 
> 
> According to
> http://www.coraid.com/support/linux/EtherDrive-2.6-HOWTO-5.html#ss5.20
> .. it runs OOM even during normal use, so I guess swapping over it is
> no-no?

It can be done (e.g., to create virtual memory for running xfs_check
on a diskless machine as a temporary measure), but it probably won't
be a good idea until there is a mechanism that allows write responses
to be (quickly recognized and then) received without allocating memory
when there are no free pages.

I think if we could register a very fast function to recognize write
responses, which would be called only when free memory was very low,
and then use a pre-allocated receive skb for receiving write
responses, then we'd be OK, and the common case wouldn't be affected.

> Can I build both client and server for these using free software?

Yes.  A popular free target is the vblade (aoetools.sourceforge.net),
and there are others.  The most popular free software initiator is the
aoe driver in Linux.

> In the process, I looked at the aoe code, and parts of it look like
> obfuscated C contest. The use of switch() as an if was particulary
> creative; I'm not even sure if I translated it properly... can you
> take a look?

I recently submitted a set of patches, and Andrew Morton asked me to
avoid the switch statement you are talking about, so thanks for the
patch, but that code is going to be patched soon anyway.

More below.

> (Patch is 
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> but I did not even compile test it)
>
> diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
> index 05a9719..38ba35d 100644
> --- a/drivers/block/aoe/aoedev.c
> +++ b/drivers/block/aoe/aoedev.c
> @@ -64,29 +64,26 @@ aoedev_newdev(ulong nframes)
>  
>  	d = kzalloc(sizeof *d, GFP_ATOMIC);
>  	f = kcalloc(nframes, sizeof *f, GFP_ATOMIC);
> - 	switch (!d || !f) {
> - 	case 0:
> - 		d->nframes = nframes;
> - 		d->frames = f;
> - 		e = f + nframes;
> - 		for (; f<e; f++) {
> - 			f->tag = FREETAG;
> - 			f->skb = new_skb(ETH_ZLEN);
> - 			if (!f->skb)
> - 				break;
> - 		}
> - 		if (f == e)
> - 			break;
> + 	if (!d || !f) {
> +		kfree(f);
> +		kfree(d);
> +		return NULL;
> +	}
> +
> +	d->nframes = nframes;
> +	d->frames = f;
> +	e = f + nframes;
> +	for (; f<e; f++) {
> +		f->tag = FREETAG;
> +		f->skb = new_skb(ETH_ZLEN);
> +		if (!f->skb)
> +			break;
> +	}
> +	if (f != e) {
>   		while (f > d->frames) {
>   			f--;
>   			dev_kfree_skb(f->skb);
>   		}
> - 	default:
> - 		if (f)
> - 			kfree(f);
> - 		if (d)
> - 			kfree(d);
> -		return NULL;
>  	}
>  	INIT_WORK(&d->work, aoecmd_sleepwork);
>  	spin_lock_init(&d->lock);
> 
> 
> aoedev_by_sysminor_m() returns with spinlock held in error case; I
> guess that's bad.
> 
> struct aoedev *
> aoedev_by_sysminor_m(ulong sysminor, ulong bufcnt)
> {
> 	struct aoedev *d;
> 	ulong flags;
> 
> 	spin_lock_irqsave(&devlist_lock, flags);
> 
> 	for (d=devlist; d; d=d->next)
> 		if (d->sysminor == sysminor)
> 			break;
> 
> 	if (d == NULL) {
> 		d = aoedev_newdev(bufcnt);
> 	 	if (d == NULL) {
> 			spin_unlock_irqrestore(&devlist_lock, flags);
> 			printk(KERN_INFO "aoe: aoedev_newdev
> failure.\n");
> 			return NULL;
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ here

I don't see what you mean.  There's an unlock two lines before the
return.

> 		}
> 		d->sysminor = sysminor;
> 		d->aoemajor = AOEMAJOR(sysminor);
> 		d->aoeminor = AOEMINOR(sysminor);
> 	}
> 
> 	spin_unlock_irqrestore(&devlist_lock, flags);
> 	return d;
> }
> 

-- 
  Ed L Cashin <ecashin@coraid.com>
