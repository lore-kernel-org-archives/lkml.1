Return-Path: <linux-kernel-owner+w=401wt.eu-S1754205AbYESFWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbYESFWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 01:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbYESFWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 01:22:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:38918 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbYESFWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 01:22:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=SlaIFsAuapr+R7SKPCYdpYy5itXgRyOp1dODtOtpvhedJRErwEZsUqPyzCZc6a/5BjmhMvNRzC19urqLEup1YEoSxWLh0i9gSBcfdvZUC1QIQnAqW710AuKORIHt0YYyYhw/xKqL5ZZWelBj0leGSCLeCYacEKrdAyQW4PYQuAs=
Message-ID: <84144f020805182222h41b9bffx463eef7e502c87f2@mail.gmail.com>
Date: Mon, 19 May 2008 08:22:07 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Pau Oliva Fora" <pau@eslack.org>
Subject: Re: [PATCH] Add support for HTC Shift Touchscreen
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, sam@ravnborg.org,
       marcin.slusarz@gmail.com
In-Reply-To: <4830F10B.5070303@eslack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <482ED31E.2000009@eslack.org> <4830F10B.5070303@eslack.org>
X-Google-Sender-Auth: a218dc62756c37a3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 6:16 AM, Pau Oliva Fora <pau@eslack.org> wrote:
> The patch below adds support for HTC Shift UMPC touchscreen.
>
> Signed-off-by: Pau Oliva Fora <pau@eslack.org>
>
> ---
>
> Patch against linux-2.6.25.4, should apply clean on other versions too.
> Includes all the suggestions by Sam Ravnborg, Pekka Enberg and Marcin
> Slusarz.
>
>
> diff -uprN linux-2.6.25.4/drivers/input/touchscreen/htcpen.c
> linux/drivers/input/touchscreen/htcpen.c
> --- linux-2.6.25.4/drivers/input/touchscreen/htcpen.c   1970-01-01
> 01:00:00.000000000 +0100
> +++ linux/drivers/input/touchscreen/htcpen.c    2008-05-19
> 04:44:16.000000000 +0200
> @@ -0,0 +1,199 @@
> +/*
> + * HTC Shift touchscreen driver
> + *
> + * Copyright (C) 2008 Pau Oliva Fora <pof@eslack.org>
> + *
> + * Thanks to:
> + *     Heikki Linnakangas - Penmount LPC touchscreen driver
> + *     Wacom / Ping Cheng - Help on linuxwacom-devel
> + *     Esteve Espuna      - Ideas, tips, moral support :)
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation.
> + */
> +
> +#include <linux/errno.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/input.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/init.h>
> +#include <linux/irq.h>
> +#include <linux/isa.h>
> +
> +#define DRIVER_VERSION "0.7"
> +#define DRIVER_DESC    "HTC Shift touchscreen driver v" DRIVER_VERSION
> +
> +MODULE_AUTHOR("Pau Oliva Fora <pau@eslack.org>");
> +MODULE_DESCRIPTION(DRIVER_DESC);
> +MODULE_VERSION(DRIVER_VERSION);
> +MODULE_LICENSE("GPL");
> +
> +#define HTCPEN_PORT_IRQ_CLEAR 0x068
> +#define HTCPEN_PORT_INIT 0x06c
> +#define HTCPEN_PORT_INDEX 0x0250
> +#define HTCPEN_PORT_DATA 0x0251
> +#define HTCPEN_IRQ 3
> +
> +#define X_INDEX 3
> +#define Y_INDEX 5
> +#define LSB_XY_INDEX 0xc
> +#define X_AXIS_MAX 2040
> +#define Y_AXIS_MAX 2040
> +#define DEVICE_ENABLE 0xa2
> +
> +static int inverse_x;
> +module_param(inverse_x, bool, 0644);
> +MODULE_PARM_DESC(inverse_x, "If set X axis is inversed");
> +static int inverse_y;
> +module_param(inverse_y, bool, 0644);
> +MODULE_PARM_DESC(inverse_y, "If set Y axis is inversed");
> +
> +struct input_dev *htcpen_dev;

The point of converting to isa_register_driver() is to use
dev_set_drvdata()/dev_get_drvdata() instead of having a global
variable like this.
