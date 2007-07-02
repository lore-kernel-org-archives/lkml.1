Return-Path: <linux-kernel-owner+w=401wt.eu-S1757320AbXGBTQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320AbXGBTQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 15:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbXGBTQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 15:16:35 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:56433 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbXGBTQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 15:16:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fPG8R1vmPBLKY+UU93wixJoT99DuYALMMT+oLVhGPbvAU9TiJUUM3yfOh64lBW+yLLYr8A/VePPa2ZRIP/jVoUr53y7g5VPNpRUim/FBSuy+fNYKMo0wTV0ypYoQLKNY3t1yBTgIP7tHtaKjRpdDms4/4mk1nF9Ppa5RM1C3xYQ=
Message-ID: <d120d5000707021216y1a3641b1rbc0c741e2d7d4e70@mail.gmail.com>
Date: Mon, 2 Jul 2007 15:16:30 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Stephen Hemminger" <shemminger@linux-foundation.org>
Subject: Re: [PATCH] fujtisu application panel driver
Cc: "Len Brown" <lenb@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
In-Reply-To: <20070702111724.43ee5b43@freepuppy.localdomain.hemminger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070702111724.43ee5b43@freepuppy.localdomain.hemminger.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 7/2/07, Stephen Hemminger <shemminger@linux-foundation.org> wrote:
> This driver supports the application buttons on some Fujitsu Lifebook laptops.
> These buttons are read via the SMBus, for more details see:
>        http://apanel.sourceforge.net/tech.php
> The buttons are handled as by the regular input system.
> Two models are detected now, but other Fujitsu laptop's have
> keys that may work similarly.
>
> It is based on the earlier apanel driver done by Jochen Eisenger, but
> with many changes.  The original driver used ioctl's and a separate
> user space program; this version hooks into the input subsystem so
> that the normal Gnome/KDE shortcuts work without any userspace
> changes.
>

Thank you very much for updating the patch. I have a couple of requests though:

1. LEDs shoud use the generic led subsystem instead of input layer. I
do not have plans of adding any more LED_XXX constants and I think
that adding any LEDs not directly relating to keyboard state was a
mistake.

2. It would be nice if driver supported changing its keymaps now that
we allow overriding default getkeycode() and setkeycode().

3. Do not aaccess input_dev->private directly. input_set_drvdata() and
input+_getdrvdata shoudl be used.

> +static int apanel_event(struct input_dev *dev, unsigned int type,
> +                       unsigned int code, int value)
> +{
> +       struct apanel *ap = dev->private;

Also I don't think the above is correct. I think you need the following here:

   struct input_polled_dev *polldev = input_get_drvdata(dev);
   struct apanal *ap = polldev->private;

4:
> +       ipdev->input->cdev.dev = &ap->client.dev;

Please change to "ipdev->input->dev.parent = &ap->client.dev;"

5:
> +       ipdev->input->private = ap;

polledev uses input->private for its own purposed, you need to use
ipdev->private.

Thank you.

-- 
Dmitry
