Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbZHVJXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbZHVJXR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 05:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005AbZHVJXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 05:23:17 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:54324 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045AbZHVJXP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 05:23:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CXyiQlxEc8pfTFYsmTWJyK7nFCaORoNgEgu2yqSCEEwSyOGxLifvJs7UdJYeayNvff
         H88oKfKWkH4GStD9dAvzHxnia01VOWLxq54nlo/YJAAJ1se89pB+fxZTDfW+6icDCzGl
         3yD/Ddjl3e6mKpeDF6xBCS4TE80N8/Z7RowNg=
MIME-Version: 1.0
In-Reply-To: <20090821225925.GA27625@kroah.com>
References: <20090821225925.GA27625@kroah.com>
Date: Sat, 22 Aug 2009 10:23:16 +0100
Message-ID: <9b2b86520908220223v4bd58129sfcb22258896592b8@mail.gmail.com>
Subject: Re: [PATCH] Samsung laptop driver
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Soeren Sonnenburg <bugreports@nn7.de>,
       =?ISO-8859-1?Q?J=E9r=E9mie_Huchet?= <jeremie@lamah.info>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/21/09, Greg KH <greg@kroah.com> wrote:
> Well, it turns out that for the Samsung laptops, we aren't supposed to
> be poking into the raw PCI config space to control the backlight,
> there's a SMI way to do it instead (Matthew, you were right.)
>
> So here's an updated version of the driver, with lots of debugging still
> left in it, that controls the backlight on a N130 through the "proper"
> way.
>
> It's bigger than the last driver, as I've added lots of documenation
> about this new interface.  I'm also working on adding wireless LED
> support, as well as maybe CPU temperature monitoring to the driver, as
> that can be controlled through this interface.
>
> Soeren and Jérémie, I took out support for both of your laptops, as I
> didn't know if it supported this type of interface.  Could you load the
> driver with the "force=1" parameter:
> 	modprobe samsung-laptop force=1
> and tell me what the kernel log shows for your laptop?  If it works,
> I'll add the DMI values back to the driver.
>
> Jesse, I don't know how this is going to play with your recently added
> backlight support for the i915 driver.  As you don't have control over
> the LEDs and other stuff that this driver is going to support, I think
> we need some way to keep the i915 driver from messing with the backlight
> values, don't you think?
>
> thanks,
>
> greg k-h
>
> --------------
>
>
> From: Greg Kroah-Hartman <gregkh@suse.de>
> Subject: Samsung laptop driver
>
> This driver implements backlight controls for Samsung laptops that
> currently do not have ACPI support for this control.
>
> It has been tested on the N130 laptop and properly works there.
>
> Many thanks to Dmitry Torokhov <dmitry.torokhov@gmail.com> for cleanups
> and other suggestions on how to make the driver simpler.
>
> Cc: Soeren Sonnenburg <bugreports@nn7.de>
> Cc: Jérémie Huchet <jeremie@lamah.info>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> ---
>  drivers/platform/x86/Kconfig          |   12
>  drivers/platform/x86/Makefile         |    1
>  drivers/platform/x86/samsung-laptop.c |  420
> ++++++++++++++++++++++++++++++++++
>  3 files changed, 433 insertions(+)

> +static struct dmi_system_id __initdata samsung_dmi_table[] = {
> +	{
> +		.ident = "N120",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "N120"),
> +			DMI_MATCH(DMI_BOARD_NAME, "N120"),
> +		},
> +		.callback = dmi_check_cb,
> +	},
> +	{
> +		.ident = "N130",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "N130"),
> +			DMI_MATCH(DMI_BOARD_NAME, "N130"),
> +		},
> +		.callback = dmi_check_cb,
> +	},
> +	{ },
> +};

...

> +MODULE_ALIAS("dmi:*:svnSAMSUNGELECTRONICSCO.,LTD.:pnN120:*:rnN120:*");
> +MODULE_ALIAS("dmi:*:svnSAMSUNGELECTRONICSCO.,LTD.:pnN130:*:rnN130:*");

Can't you just use MODULE_DEVICE_TABLE(dmi, samsung_dmi_table)?

Regards
Alan
