Return-Path: <linux-kernel-owner+w=401wt.eu-S1755044AbZDNW6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbZDNW6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 18:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZDNW6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 18:58:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56198 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751132AbZDNW6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 18:58:08 -0400
Date: Tue, 14 Apr 2009 15:53:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: dmitry.torokhov@gmail.com, jirislaby@gmail.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       hans-christian.egtvedt@atmel.com, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH] Input: add wm97xx accelerated driver for Atmel
 microprocessors
Message-Id: <20090414155357.76501a93.akpm@linux-foundation.org>
In-Reply-To: <1239357192-27726-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1239357192-27726-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Apr 2009 10:53:11 +0100
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
> 
> This patch adds an accelerated driver for Atmel AVR32 AT32AP700X
> microprocessors. It uses interrupts on the channel B in the AC97
> controller. Thus, offloading the work queue in the wm97xx-ts driver.
> 
> The driver has been tested with Atmel AVR32 AT32AP7000 and Wolfson
> WM9712 codec.
> 
> The driver can also be easily modified to support Atmel AT91 devices, as
> AT91 and AVR32 share the same AC97C module.
> 
> [Fixed leak of atmel_wm97xx when probe fails. -- broonie]
> 
>
> ...
>
> +static void atmel_wm97xx_acc_pen_up(struct wm97xx *wm)
> +{
> +	struct atmel_wm97xx *atmel_wm97xx = platform_get_drvdata(wm->touch_dev);
> +	int pen_down = gpio_get_value(atmel_wm97xx->gpio_pen);
> +
> +	if (pen_down != 0) {
> +		mod_timer(&atmel_wm97xx->pen_timer, jiffies
> +				+ msecs_to_jiffies(1));

I'd be more comfortable if there was a del_timer_sync() somewhere in
this driver?

> +	} else {
> +		input_report_abs(wm->input_dev, ABS_PRESSURE, 0);
> +		input_report_key(wm->input_dev, BTN_TOUCH, 0);
> +		input_sync(wm->input_dev);
> +	}
> +}
> +

