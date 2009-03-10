Return-Path: <linux-kernel-owner+w=401wt.eu-S1756664AbZCJWEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbZCJWEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 18:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755467AbZCJWEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 18:04:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52327 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755080AbZCJWET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 18:04:19 -0400
Date: Tue, 10 Mar 2009 15:00:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, syrjala@sci.fi, johnpol@2ka.mipt.ru,
       david-b@pacbell.net
Subject: Re: [PATCH] drivers/w1/masters/w1-gpio.c: fix read_bit()
Message-Id: <20090310150059.ce64548a.akpm@linux-foundation.org>
In-Reply-To: <20090310091800.GC3263@buzzloop.caiaq.de>
References: <1236614530-11153-1-git-send-email-daniel@caiaq.de>
	<20090309191419.98699220.akpm@linux-foundation.org>
	<20090310091800.GC3263@buzzloop.caiaq.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009 10:18:00 +0100
Daniel Mack <daniel@caiaq.de> wrote:

> On Mon, Mar 09, 2009 at 07:14:19PM -0700, Andrew Morton wrote:
> > > --- a/drivers/w1/masters/w1-gpio.c
> > > +++ b/drivers/w1/masters/w1-gpio.c
> > > @@ -39,7 +39,7 @@ static u8 w1_gpio_read_bit(void *data)
> > >  {
> > >  	struct w1_gpio_platform_data *pdata = data;
> > >  
> > > -	return gpio_get_value(pdata->pin);
> > > +	return gpio_get_value(pdata->pin) ? 1 : 0;
> > >  }
> > >  
> > >  static int __init w1_gpio_probe(struct platform_device *pdev)
> > 
> > We recently merged a patch (I forget where) which fixed one
> > gpio_get_value() implementation so that it always returns 0 or 1.
> > 
> > From which I deduce that the correct fix for <whatever problem you're
> > seeing> is to fix <whichever driver that is>?
> 
> I agree those functions should return 0 and 1 only, but my patch fixes
> the w1-gpio driver for all platforms at once, so people can use it.
> 
> On the other hand, I will submit a patch which modifies PXA's
> gpio_get_value() and see what the maintainers say, but I can't go thru
> all the implemenations of all architectures to do this.
> 
> So for the time being, the above patch helps many users of that driver.
> 

Problem is, the patch will just conceal bugs.

How about this?

--- a/drivers/w1/masters/w1-gpio.c~a
+++ a/drivers/w1/masters/w1-gpio.c
@@ -38,8 +38,12 @@ static void w1_gpio_write_bit_val(void *
 static u8 w1_gpio_read_bit(void *data)
 {
 	struct w1_gpio_platform_data *pdata = data;
+	u8 ret;
 
-	return gpio_get_value(pdata->pin);
+	ret = gpio_get_value(pdata->pin);
+	if (WARN_ONCE(ret > 1, "gpio_get_value(): invalid return: %u\n", ret))
+		ret = !!ret
+	return ret;
 }
 
 static int __init w1_gpio_probe(struct platform_device *pdev)
_

