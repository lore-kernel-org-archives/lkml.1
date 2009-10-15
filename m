Return-Path: <linux-kernel-owner+w=401wt.eu-S1762661AbZJOLLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762661AbZJOLLA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 07:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761209AbZJOLK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 07:10:59 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:44524 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757601AbZJOLK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 07:10:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=A6bpY8XrrSEfFd9Ft2PYRVgVW8KQHZ6hYXs4lkgOUUXyckyU+4ItYR515RRTfzNMSn
         b8crtl+QnkVdzgrC/1UDit+ezY0bLdXkiaAvkzljWwE0T9TBbEyhgBvlvRoWcWaUV1Ss
         AvgPMKAjyI54F7dbQCH1v8hMvox5bHRmXtseE=
Date: Thu, 15 Oct 2009 13:08:59 +0200
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-input@vger.kernel.org
Subject: Re: [bisected regression] Touchpad "paste" stops working after
	suspend to RAM
Message-ID: <20091015110859.GA4713@Pilar.aei.mpg.de>
References: <20091013190819.GA7555@Pilar.aei.mpg.de> <20091013194654.GD21593@core.coreip.homeip.net> <20091013202459.GE21593@core.coreip.homeip.net> <20091013231641.GA4404@Pilar.aei.mpg.de> <20091013235607.GA28819@core.coreip.homeip.net> <20091013235701.GB28819@core.coreip.homeip.net> <20091014005131.GA4371@Pilar.aei.mpg.de> <20091014023008.GA29672@core.coreip.homeip.net> <20091014111325.GA4586@Pilar.aei.mpg.de> <20091015004451.GA2872@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091015004451.GA2872@core.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 14.Oct'09 at 17:44:52 -0700, Dmitry Torokhov wrote:
> Ok, so here is hopefullt the last patch, it automatically disables MUX
> mode on your Vaio since it is broken (you still need the previous patch
> that changes atkbd since - there are 2 diffrent issues). I'd appreciate
> if you could test it 

I tested the patch below on top of the atkbd patch, and paste still
works after s2ram

> - if it works then you should see mention of only 2
> serio ports in your dmesg and not 5.

And now I see this in the dmesg

PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice

so your patch did what you said it would.

Thanks Dmitry!


> Input: i8042 - add Sony Vaio VGN-FZ240E to the nomux list
> 
> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> On this model, when KBD is in active multiplexing mode, acknowledgements
> to reset and get ID commands issued on KBD port sometimes are delivered
> to AUX3 port (touchpad) which messes up device detection. Legacy KBC
> mode works fine and since there are no external PS/2 ports on this laptop
> and no support for docking station we can safely disable active MUX mode.
> 
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---
> 
>  drivers/input/serio/i8042-x86ia64io.h |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
> index 77ff205..a537925 100644
> --- a/drivers/input/serio/i8042-x86ia64io.h
> +++ b/drivers/input/serio/i8042-x86ia64io.h
> @@ -327,6 +327,17 @@ static struct dmi_system_id __initdata i8042_dmi_nomux_table[] = {
>  		},
>  	},
>  	{
> +		/*
> +		 * Reset and GET ID commands issued via KBD port are
> +		 * sometimes being delivered to AUX3.
> +		 */
> +		.ident = "Sony Vaio FZ-240E",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-FZ240E"),
> +		},
> +	},
> +	{
>  		.ident = "Amoi M636/A737",
>  		.matches = {
>  			DMI_MATCH(DMI_SYS_VENDOR, "Amoi Electronics CO.,LTD."),
