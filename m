Return-Path: <linux-kernel-owner+w=401wt.eu-S1751530AbZIJWf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530AbZIJWf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 18:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbZIJWf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 18:35:27 -0400
Received: from kroah.org ([198.145.64.141]:48459 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbZIJWf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 18:35:27 -0400
Date: Thu, 10 Sep 2009 15:33:31 -0700
From: Greg KH <greg@kroah.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/48] 2.6.27.32-stable review
Message-ID: <20090910223331.GB5356@kroah.com>
References: <20090904201112.GA8274@kroah.com>
 <4AA43E92.8080708@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4AA43E92.8080708@imap.cc>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 07, 2009 at 12:58:26AM +0200, Tilman Schmidt wrote:
> Greg,
> 
> if at all possible, could you please include the patch below, with an
> 
> Acked-by: Tilman Schmidt <tilman@imap.cc>
> 
> tacked on? It applies fine to 2.6.27.31.

Ok, I'm confused.

What specific patch do you need applied?  What is the git commit id of
the patch in Linus's tree?  I tried the git ids below, and 2 of them
don't match up.

odd,

greg k-h


> ---- original message follows ----
> Message-ID: <4A9524BE.3060508@canonical.com>
> Date: Wed, 26 Aug 2009 14:04:14 +0200
> From: Stefan Bader <stefan.bader@canonical.com>
> To: stable@kernel.org
> CC: Tilman Schmidt <tilman@imap.cc>, 
>  "David S. Miller" <davem@davemloft.net>,
>  Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> Subject: [PATCH] Fix incorrect stable backport to bas_gigaset patch
> 
> This seems to affect 2.6.27.y and (discontinued) 2.6.28.y. Some code went into 
> gigaset_probe instead of gigaset_initcshw causing an oops when the hardware is 
> probed.
> [I added one pr_err statement from upstream, too)
> 
> -Stefan
> 
> From 944fd2dab4173cea4fdcd50732529639ec00cf5d Mon Sep 17 00:00:00 2001
> From: Stefan Bader <stefan.bader@canonical.com>
> Date: Tue, 25 Aug 2009 17:35:56 +0200
> Subject: [PATCH] UBUNTU: SAUCE: Fix incorrect stable backport to bas_gigaset
> 
> BugLink: http://bugs.launchpad.net/bugs/417732
> 
> commit 56f7efe48d57dda9e59e23ab161c118271cce815
> Author: Tilman Schmidt <tilman@imap.cc>
> Date:   Wed Apr 15 03:25:43 2009 -0700
> 
>     bas_gigaset: correctly allocate USB interrupt transfer buffer
> 
>     [ Upstream commit 170ebf85160dd128e1c4206cc197cce7d1424705 ]
> 
> This incorrect backport to 2.6.28.10 placed some code into the probe function
> which used a pointer before it was initialized. Moving this to the correct
> place (as it is in upstream).
> 
> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
> ---
>  drivers/isdn/gigaset/bas-gigaset.c |   16 +++++++++-------
>  1 files changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/isdn/gigaset/bas-gigaset.c b/drivers/isdn/gigaset/bas-gigaset.c
> index fcec2df..3990eae 100644
> --- a/drivers/isdn/gigaset/bas-gigaset.c
> +++ b/drivers/isdn/gigaset/bas-gigaset.c
> @@ -2140,8 +2140,16 @@ static int gigaset_initcshw(struct cardstate *cs)
>  	struct bas_cardstate *ucs;
>  
>  	cs->hw.bas = ucs = kmalloc(sizeof *ucs, GFP_KERNEL);
> -	if (!ucs)
> +	if (!ucs) {
> +		pr_err("out of memory\n");
> +		return 0;
> +	}
> +	ucs->int_in_buf = kmalloc(IP_MSGSIZE, GFP_KERNEL);
> +	if (!ucs->int_in_buf) {
> +		kfree(ucs);
> +		pr_err("out of memory\n");
>  		return 0;
> +	}
>  
>  	ucs->urb_cmd_in = NULL;
>  	ucs->urb_cmd_out = NULL;
> @@ -2236,12 +2244,6 @@ static int gigaset_probe(struct usb_interface *interface,
>  		}
>  		hostif = interface->cur_altsetting;
>  	}
> -	ucs->int_in_buf = kmalloc(IP_MSGSIZE, GFP_KERNEL);
> -	if (!ucs->int_in_buf) {
> -		kfree(ucs);
> -		pr_err("out of memory\n");
> -		return 0;
> -	}
>  
>  	/* Reject application specific interfaces
>  	 */
> -- 
> 1.5.4.3
> 
> -- 
> Tilman Schmidt                    E-Mail: tilman@imap.cc
> Bonn, Germany
> Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
> Ungeöffnet mindestens haltbar bis: (siehe Rückseite)
> 


