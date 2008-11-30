Return-Path: <linux-kernel-owner+w=401wt.eu-S1751816AbYK3Hiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbYK3Hiq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 02:38:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750924AbYK3Hih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 02:38:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750898AbYK3Hig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 02:38:36 -0500
Date: Sat, 29 Nov 2008 23:38:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Mierswa <impulze@impulze.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] Fujitsu Amilo PA 1510 key-release events quirk
Message-Id: <20081129233826.be959cae.akpm@linux-foundation.org>
In-Reply-To: <4931BB48.9010706@impulze.org>
References: <4931BB48.9010706@impulze.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Nov 2008 22:59:36 +0100 Daniel Mierswa <impulze@impulze.org> wrote:

> heya,
> the fujitsu amilo pa 1510 laptop needs a little lovin' regarding the 
> release event of the volume up and down keys. I attached a format-patch 
> (against torvalds/linux-2.6.git ed313489badef16d7) which separates the 
> generation of release events for certain scancodes into a macro since 3 
> dmi matches are already using it and generation of the missing release 
> events for that particular laptop. Please post back with any advice and 
> thoughts for that patch.
> 

Please don't send more than one patch per email.  I shall comment on
the two patches in two separate replies.

> From a197dfb0eed23b87418c0a7fe6a562910046576e Mon Sep 17 00:00:00 2001
> From: Daniel Mierswa <impulze@impulze.org>
> Date: Sat, 29 Nov 2008 22:39:34 +0100
> Subject: [PATCH] Separate macro for generation of keyrelease events
> 
> ---
>  drivers/input/keyboard/atkbd.c |   23 +++++++++++++----------
>  1 files changed, 13 insertions(+), 10 deletions(-)

Please also cc linux-input@vger.kernel.org on input-related patches.

> diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
> index 22016ca..99ef522 100644
> --- a/drivers/input/keyboard/atkbd.c
> +++ b/drivers/input/keyboard/atkbd.c
> @@ -834,6 +834,17 @@ static void atkbd_disconnect(struct serio *serio)
>  }
>  
>  /*
> + * generate release events for the keycodes given in forced_release_keys[]
> + */
> +#define GEN_RELEASE_EVENT \
> +	int i; \
> +\
> +	if (atkbd->set == 2) \
> +		for (i = 0; i < ARRAY_SIZE(forced_release_keys); i++) \
> +			__set_bit(forced_release_keys[i], \
> +				atkbd->force_release_mask);
> +
> +/*
>   * Most special keys (Fn+F?) on Dell laptops do not generate release
>   * events so we have to do it ourselves.
>   */
> @@ -842,12 +853,8 @@ static void atkbd_dell_laptop_keymap_fixup(struct atkbd *atkbd)
>  	const unsigned int forced_release_keys[] = {
>  		0x85, 0x86, 0x87, 0x88, 0x89, 0x8a, 0x8b, 0x8f, 0x93,
>  	};
> -	int i;
>  
> -	if (atkbd->set == 2)
> -		for (i = 0; i < ARRAY_SIZE(forced_release_keys); i++)
> -			__set_bit(forced_release_keys[i],
> -				  atkbd->force_release_mask);
> +	GEN_RELEASE_EVENT
>  }
>  
>  /*
> @@ -859,12 +866,8 @@ static void atkbd_hp_keymap_fixup(struct atkbd *atkbd)
>  	const unsigned int forced_release_keys[] = {
>  		0x94,
>  	};
> -	int i;
>  
> -	if (atkbd->set == 2)
> -		for (i = 0; i < ARRAY_SIZE(forced_release_keys); i++)
> -			__set_bit(forced_release_keys[i],
> -					atkbd->force_release_mask);
> +	GEN_RELEASE_EVENT
>  }

oh my.  Please, no.  Just write a C function:

void atkbd_gen_release_event(unsigned int *keys, unsigned nr_keys)
{
	...
}


