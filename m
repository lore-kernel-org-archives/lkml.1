Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbYADX3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbYADX3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 18:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbYADX3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 18:29:37 -0500
Received: from smtprelay10.ispgateway.de ([80.67.29.24]:56597 "EHLO
	smtprelay10.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbYADX3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 18:29:36 -0500
Message-ID: <477EC158.102@selhorst.net>
Date: Sat, 05 Jan 2008 00:29:28 +0100
From: Marcel Selhorst <tpm@selhorst.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071117)
MIME-Version: 1.0
To: Kent Yoder <shpedoikal@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       David Smith <davidsmith@acm.org>
CC: Andrew Morton <akpm@osdl.org>,
       TPM Device Driver List <tpmdd-devel@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [tpmdd-devel] [PATCH] - TPM save state before suspending to ram
References: <477D491F.1060001@selhorst.net> <20080104163917.GB27447@elf.ucw.cz> <499d6ed30801041209o4da54b3bw39335f3342e528f0@mail.gmail.com>
In-Reply-To: <499d6ed30801041209o4da54b3bw39335f3342e528f0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.1-5; AVE: 7.6.0.46; VDF: 7.0.1.194; host: mail)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kent is right, the solution from David is way better. I wanted to be consistent
with the other functions in tpm.c, but it definitely makes more sense in Davids
way. So please consider my patch as reverted and his patch as

Signed-off-by: Marcel Selhorst <tpm@selhorst.net>

Thanks,
Marcel

Kent Yoder schrieb:
> On Jan 4, 2008 10:39 AM, Pavel Machek <pavel@ucw.cz> wrote:
>> On Thu 2008-01-03 21:44:15, Marcel Selhorst wrote:
>>> Dear list,
>>>
>>> this patch fixes a bug, that prevents the TPM chip to resume correctly from a
>>> suspended state.
>>>
>>> Signed-off-by: Marcel Selhorst <tpm@selhorst.net>
> [cut]
>> I'm not sure if we want to use variable-size array on stack. What
>> hacks are you doing with max_t/max?
>>                                                                         Pavel
> 
> Hi Pavel,
> 
>   Here's an alternate solution from David, signoffs pending --
> 
> commit 058f1e3c4d4e2de5a7188608a1c2e0722498fd4b
> Author: David Smith <davidsmith@acm.org>
> Date:   Fri Jan 4 03:33:11 2008 +0900
> 
>     Fix for TPM suspend/resume failure
> 
> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> index 9bb5429..79d2fd5 100644
> --- a/drivers/char/tpm/tpm.c
> +++ b/drivers/char/tpm/tpm.c
> @@ -1046,12 +1046,6 @@ void tpm_remove_hardware(struct device *dev)
>  }
>  EXPORT_SYMBOL_GPL(tpm_remove_hardware);
> 
> -static u8 savestate[] = {
> -	0, 193,			/* TPM_TAG_RQU_COMMAND */
> -	0, 0, 0, 10,		/* blob length (in bytes) */
> -	0, 0, 0, 152		/* TPM_ORD_SaveState */
> -};
> -
>  /*
>   * We are about to suspend. Save the TPM state
>   * so that it can be restored.
> @@ -1059,8 +1053,14 @@ static u8 savestate[] = {
>  int tpm_pm_suspend(struct device *dev, pm_message_t pm_state)
>  {
>  	struct tpm_chip *chip = dev_get_drvdata(dev);
> +        u8 savestate[] = {
> +          0, 193,		/* TPM_TAG_RQU_COMMAND */
> +          0, 0, 0, 10,		/* blob length (in bytes) */
> +          0, 0, 0, 152		/* TPM_ORD_SaveState */
> +        };
> +
>  	if (chip == NULL)
> -		return -ENODEV;
> +          return -ENODEV;
> 
>  	tpm_transmit(chip, savestate, sizeof(savestate));
>  	return 0;

