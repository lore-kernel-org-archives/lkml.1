Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965572Ab0BZRri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 12:47:38 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:34758 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965483Ab0BZRrh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 12:47:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SB1zPtTx3yUIviXwHM/vufUqV+MrnkMuJa0pyIbXFWoDKZYt2/dpCcvT3dFjFy297r
         LDfQa5nlEeFCtSUT9Xx4U00Fhqp/xX6IexjX8+x/CILLeytz/59G40zeMMeiseRIgVeP
         iY0Jnwoc5AysUFKz1Z6cH5g/hhIn2sr4062iU=
MIME-Version: 1.0
In-Reply-To: <20100224184505.1d8d3380@droptest.queued.net>
References: <808c8e9d1002231455q379b26acq4b4a50188c5d73be@mail.gmail.com>
	 <20100224184505.1d8d3380@droptest.queued.net>
Date: Fri, 26 Feb 2010 11:47:35 -0600
Message-ID: <808c8e9d1002260947k281782al889db51e20073648@mail.gmail.com>
Subject: Re: [PATCH] OLPC: ALSA: fix cs5535audio's MIC GPIO to enable input
From: Ben Gardner <gardner.ben@gmail.com>
To: Andres Salomon <dilinger@collabora.co.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andres,

> Previously the MIC GPIO was set to output mode, and when checking the status
> after setting it we were checking OUTPUT_VAL.  This worked, though I'm not
> quite sure why. Instead, if we actually check the READ_BACK value, it
> doesn't work unless the GPIO is in bidirectional mode.  Thus, enable
> input mode as well.

The cs5535-gpio driver was reading output value, not the sensed input value.
When that was fixed, this OLPC code failed because the input wasn't
enabled, so the gpio_get_value() call didn't return anything useful.
At reset the CS5535/6 GPIOs have both input and output disabled.

> Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
> ---
>  sound/pci/cs5535audio/cs5535audio_olpc.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/sound/pci/cs5535audio/cs5535audio_olpc.c b/sound/pci/cs5535audio/cs5535audio_olpc.c
> index 50da49b..f5574f2 100644
> --- a/sound/pci/cs5535audio/cs5535audio_olpc.c
> +++ b/sound/pci/cs5535audio/cs5535audio_olpc.c
> @@ -157,6 +157,7 @@ int __devinit olpc_quirks(struct snd_card *card, struct snd_ac97 *ac97)
>                return -EIO;
>        }
>        gpio_direction_output(OLPC_GPIO_MIC_AC, 0);
> +       gpio_direction_input(OLPC_GPIO_MIC_AC);
>
>        /* drop the original AD1888 HPF control */
>        memset(&elem, 0, sizeof(elem));

This will only work because the cs5535-gpio driver and gpiolib are
both 'broken'.

The problem with gpiolib is that it only allows a GPIO pin to be
either an input or output, but not both.
It has two separate functions to configure the direction
(gpio_direction_input/gpio_direction_output), where one should do (ie,
gpio_set_direction).
>From what I can tell, when direction_input() is called, the GPIO chip
is expected to disable the output and enable the input. If that really
occurred, then the above code would still be broken.

The cs5535-gpio driver doesn't follow that input-or-output convention.
It never disables the direction that wasn't requested.

I'm working on a gpiolib patch that will combine gpio_direction_output
and gpio_direction_input into one function.  That would enable the
above driver to be 'obviously correct'.

Ben
