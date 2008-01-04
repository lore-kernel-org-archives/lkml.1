Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbYADQjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbYADQjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 11:39:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbYADQjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 11:39:12 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35179 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752677AbYADQjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 11:39:11 -0500
Date: Fri, 4 Jan 2008 17:39:17 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Selhorst <tpm@selhorst.net>
Cc: TPM Device Driver List <tpmdd-devel@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] - TPM save state before suspending to ram
Message-ID: <20080104163917.GB27447@elf.ucw.cz>
References: <477D491F.1060001@selhorst.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477D491F.1060001@selhorst.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-01-03 21:44:15, Marcel Selhorst wrote:
> Dear list,
> 
> this patch fixes a bug, that prevents the TPM chip to resume correctly from a
> suspended state.
> 
> Signed-off-by: Marcel Selhorst <tpm@selhorst.net>
> ---
> --- linux-tpm/drivers/char/tpm/tpm.c	2008-01-03 20:44:43.000000000 +0100
> +++ linux/drivers/char/tpm/tpm.c	2008-01-03 21:08:13.000000000 +0100
> @@ -1041,7 +1041,7 @@ void tpm_remove_hardware(struct device *
>  }
>  EXPORT_SYMBOL_GPL(tpm_remove_hardware);
> 
> -static u8 savestate[] = {
> +static const u8 savestate[] = {
>  	0, 193,			/* TPM_TAG_RQU_COMMAND */
>  	0, 0, 0, 10,		/* blob length (in bytes) */
>  	0, 0, 0, 152		/* TPM_ORD_SaveState */
> @@ -1053,11 +1053,13 @@ static u8 savestate[] = {
>   */
>  int tpm_pm_suspend(struct device *dev, pm_message_t pm_state)
>  {
> +	u8 data[max_t(int, max(ARRAY_SIZE(savestate), ARRAY_SIZE(savestate)), 10)];
>  	struct tpm_chip *chip = dev_get_drvdata(dev);
>  	if (chip == NULL)
>  		return -ENODEV;
> 
> -	tpm_transmit(chip, savestate, sizeof(savestate));
> +	memcpy(data, savestate, sizeof(savestate));
> +	tpm_transmit(chip, data, sizeof(data));
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(tpm_pm_suspend);

I'm not sure if we want to use variable-size array on stack. What
hacks are you doing with max_t/max?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
