Return-Path: <linux-kernel-owner+w=401wt.eu-S1752075AbYK3Hmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbYK3Hmk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 02:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750833AbYK3Hmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 02:42:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54394 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750830AbYK3Hma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 02:42:30 -0500
Date: Sat, 29 Nov 2008 23:41:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Mierswa <impulze@impulze.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] Fujitsu Amilo PA 1510 key-release events quirk
Message-Id: <20081129234148.d2b9904e.akpm@linux-foundation.org>
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

> From: Daniel Mierswa <impulze@impulze.org>
> Date: Sat, 29 Nov 2008 22:40:20 +0100
> Subject: [PATCH] Fujitsu Siemens Amilo PA 1510 quirks
> 
> The volume up and down keys on the Fujitsu Siemens Amilo PA 1510 laptop
> won't generate release events, so we have to do that. Use the same
> way that is already used with other models.
> ---
>  drivers/input/keyboard/atkbd.c |   22 ++++++++++++++++++++++
>  1 files changed, 22 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
> index 99ef522..1250242 100644
> --- a/drivers/input/keyboard/atkbd.c
> +++ b/drivers/input/keyboard/atkbd.c
> @@ -845,6 +845,19 @@ static void atkbd_disconnect(struct serio *serio)
>  				atkbd->force_release_mask);
>  
>  /*
> + * The volume up and volume down special keys on a Fujitsu Amilo PA 1510 laptop
> + * do not generate release events so we have to do it ourselves.
> + */
> +static void atkbd_amilopa1510_keymap_fixup(struct atkbd *atkbd)
> +{
> +	const unsigned int forced_release_keys[] = {
> +		0xb0, 0xae,
> +	};
> +
> +	GEN_RELEASE_EVENT
> +}

It's best to make forced_release_keys static as well - there is no need
to build this array on the stack at runtime.  The compiler _could_
perform this optimisation itself andallegedly it will sometimes do so. 
Last time I checked it did not.

> +/*
>   * Most special keys (Fn+F?) on Dell laptops do not generate release
>   * events so we have to do it ourselves.
>   */
> @@ -1463,6 +1476,15 @@ static struct dmi_system_id atkbd_dmi_quirk_table[] __initdata = {
>  		.driver_data = atkbd_dell_laptop_keymap_fixup,
>  	},
>  	{
> +		.ident = "Fujitsu Amilo PA 1510",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"), 
> +			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO Pa 1510"),
> +		},
> +		.callback = atkbd_setup_fixup,
> +		.driver_data = atkbd_amilopa1510_keymap_fixup,
> +	},
> +	{
>  		.ident = "HP 2133",
>  		.matches = {
>  			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
