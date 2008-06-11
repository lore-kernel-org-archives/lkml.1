Return-Path: <linux-kernel-owner+w=401wt.eu-S1758596AbYFKARd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596AbYFKARd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 20:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbYFKAR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 20:17:26 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:22588 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754407AbYFKARZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 20:17:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=yoqmqQYB90ByW2559vOS8NX57s7951FRqeor6/A5IraAl6RqzRw6XxSQTLph+aTLFfXQwwpApA/Lb48t1kDP3vEG+Mjuq2+VkrUOM/JgI+7+MzKkjunPSKBCdpCd56+pRW3f5bh+P8gVbw9UNjtsoFrGnhcrurx5BdVG2aRKzUg=  ;
X-YMail-OSG: P.5tDkcVM1ljaQN828BYXhFiDc70e0bK4Syl_kqKB5VyAqjxU3F7lcAQDb4OdHhwHa_hms3WVQuk8PimzPy9ILqNUnSXRQH7TCA8zhnbINcqKYV.wdBSDbzvzM5On6n5jmcW_mKSKggQ6NTiC3GULiPd
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [WARNING] local_bh_enable with irqs disabled:
Date: Tue, 10 Jun 2008 17:15:52 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0806031529520.21106@axis700.grange> <20080605223917.0a02804d.akpm@linux-foundation.org> <Pine.LNX.4.64.0806060751240.14536@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0806060751240.14536@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806101715.52830.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 June 2008, Guennadi Liakhovetski wrote:
> Sorry, this was a 2.6.26-rc3 based kernel with the gpio-sysfs patch from 
> David, e.g., http://marc.info/?l=linux-kernel&m=121107105300923&w=2,
> which introduces a call to device_unregister via gpiochip_unexport(chip); 
> in gpiochip_remove. 

Right.  Obviously that wasn't tested with "rmmod" of a modular
GPIO expander ... I only have one board which supports such an
expander right now, and it's not been in use recently.

A fix is obvious; any problems with what's below?

- Dave


--- g26.orig/drivers/gpio/gpiolib.c	2008-06-10 16:56:01.000000000 -0700
+++ g26/drivers/gpio/gpiolib.c	2008-06-10 16:55:39.000000000 -0700
@@ -726,12 +726,15 @@ int gpiochip_remove(struct gpio_chip *ch
 		}
 	}
 	if (status == 0) {
-		gpiochip_unexport(chip);
 		for (id = chip->base; id < chip->base + chip->ngpio; id++)
 			gpio_desc[id].chip = NULL;
 	}
 
 	spin_unlock_irqrestore(&gpio_lock, flags);
+
+	if (status == 0)
+		gpiochip_unexport(chip);
+
 	return status;
 }
 EXPORT_SYMBOL_GPL(gpiochip_remove);

