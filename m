Return-Path: <linux-kernel-owner+w=401wt.eu-S1761272AbXJXXDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761272AbXJXXDx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 19:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756830AbXJXXDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 19:03:43 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33095 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756755AbXJXXDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 19:03:42 -0400
Date: Wed, 24 Oct 2007 16:03:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: dtor@insightbb.com, pavel@ucw.cz, lenb@kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fujitsu application panel driver
Message-Id: <20071024160300.85e1cbda.akpm@linux-foundation.org>
In-Reply-To: <20071023125555.38d63567@shemminger-laptop>
References: <20070702111724.43ee5b43@freepuppy.localdomain.hemminger.net>
	<200709140130.59732.dtor@insightbb.com>
	<20070916215516.2934abad@oldman.hemminger.net>
	<200709161623.00286.dtor@insightbb.com>
	<20071023125555.38d63567@shemminger-laptop>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007 12:55:55 -0700
Stephen Hemminger <shemminger@linux-foundation.org> wrote:

> This driver supports the application buttons on some Fujitsu Lifebook
> laptops. It is based on the earlier apanel driver done by Jochen
> Eisenger, but with many changes.  The original driver used ioctl's and
> a separate user space program (see http://apanel.sourceforge.net). This
> driver hooks into the input subsystem so that the normal keys act as
> expected without a daemon. In addition to buttons, the Mail Led is
> handled via LEDs class device.
> 
> The driver now supports redefinable keymaps and no longer has to
> have a DMI table for all Fujitsu laptops.
> 
> I thought about mixing this driver should be integrated into the Fujitsu laptop
> extras driver that handles backlight, but rejected the idea because
> it wasn't clear if all the Fujitsu laptops supported both.
> 
> ...
>
> +
> +/* Magic constants in BIOS that tell about buttons */
> +enum apanel_devid {
> +	APANEL_DEV_NONE	  = 0,
> +	APANEL_DEV_APPBTN = 1,
> +	APANEL_DEV_CDBTN  = 2,
> +	APANEL_DEV_LCD	  = 3,
> +	APANEL_DEV_LED	  = 4,
> +	APANEL_DEV_MAX,
> +};

APANEL_DEV_MAX == 5.

> +enum apanel_chip {
> +	CHIP_NONE    = 0,
> +	CHIP_OZ992C  = 1,
> +	CHIP_OZ163T  = 2,
> +	CHIP_OZ711M3 = 4,
> +};
> +
> +/* Result of BIOS snooping/probing -- what features are supported */
> +static enum apanel_chip device_chip[APANEL_DEV_MAX];
> +
> +/* names for APANEL_XXX */
> +static const char *device_names[APANEL_DEV_MAX] __initdata = {

We just wasted sizeof(char *)?

> +	[APANEL_DEV_APPBTN] = "Application Buttons",
> +	[APANEL_DEV_LCD]    = "LCD",
> +	[APANEL_DEV_LED]    = "LED",
> +	[APANEL_DEV_CDBTN]  = "CD Buttons",
> +};
> +
> +
> +/* Poll for key changes
> + *
> + * Read Application keys via SMI
> + *  A (0x4), B (0x8), Internet (0x2), Email (0x1).
> + *
> + * CD keys:
> + * Forward (0x100), Rewind (0x200), Stop (0x400), Pause (0x800)
> + */
> +static void apanel_poll(struct input_polled_dev *ipdev)
> +{
> +	struct apanel *ap = ipdev->private;
> +	struct input_dev *idev = ipdev->input;
> +	u8 cmd = device_chip[APANEL_DEV_APPBTN] == CHIP_OZ992C ? 0 : 8;
> +	s32 data;
> +	int i;
> +
> +	data = i2c_smbus_read_word_data(&ap->client, cmd);
> +	if (data < 0)
> +		return;	/* ignore errors (due to ACPI??) */
> +
> +	/* write back to clear latch */
> +	i2c_smbus_write_word_data(&ap->client, cmd, 0);
> +
> +	if (!data)
> +		return;
> +
> +	dev_dbg(&ipdev->input->dev, APANEL ": data %#x\n", data);
> +	for (i = 0; i < ipdev->input->keycodemax; i++)
> +		if (1ul << i & data)

You made me google for the c precedence table.

> +			report_key(idev, ap->keymap[i]);
> +}
>
> ...
>

