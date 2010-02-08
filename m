Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab0BHVD3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 16:03:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33922 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752130Ab0BHVD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 16:03:27 -0500
Date: Mon, 8 Feb 2010 13:02:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Bill Gatliff <bgat@billgatliff.com>,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] of/gpio: Implement GPIOLIB notifier hooks
Message-Id: <20100208130248.72febd68.akpm@linux-foundation.org>
In-Reply-To: <20100205203236.GC1475@oksana.dev.rtsoft.ru>
References: <20100205203201.GA32281@oksana.dev.rtsoft.ru>
	<20100205203236.GC1475@oksana.dev.rtsoft.ru>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Feb 2010 23:32:36 +0300
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> This patch implements GPIOLIB notifier hooks, and thus makes device-enabled
> GPIO chips (i.e. the ones that have gpio_chip->dev specified) automatically
> attached to the OpenFirmware subsystem. Which means that now we can handle
> I2C and SPI GPIO chips almost* transparently.
> 
> * "Almost" because some chips still require platform data, and for these
>   chips OF-glue is still needed, though with this support the glue will
>   be much smaller.
> 

We can clean this up a little with the WARN_ON trick:

diff -puN drivers/of/gpio.c~of-gpio-implement-gpiolib-notifier-hooks-fix drivers/of/gpio.c
--- a/drivers/of/gpio.c~of-gpio-implement-gpiolib-notifier-hooks-fix
+++ a/drivers/of/gpio.c
@@ -255,10 +255,8 @@ static int of_gpiochip_register_simple(s
 {
 	struct of_gpio_chip *of_gc;
 
-	if (np->data) {
-		WARN_ON(1);
+	if (WARN_ON(np->data))
 		return -EBUSY;
-	}
 
 	of_gc = kzalloc(sizeof(*of_gc), GFP_KERNEL);
 	if (!of_gc)
@@ -287,10 +285,8 @@ static int of_gpiochip_unregister(struct
 {
 	struct of_gpio_chip *of_gc = np->data;
 
-	if (!of_gc || of_gc->chip != chip) {
-		WARN_ON(1);
+	if (WARN_ON(!of_gc || of_gc->chip != chip))
 		return -EINVAL;
-	}
 
 	np->data = NULL;
 	kfree(of_gc);
_

