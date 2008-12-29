Return-Path: <linux-kernel-owner+w=401wt.eu-S1753550AbYL2XzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbYL2XzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 18:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbYL2Xyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 18:54:51 -0500
Received: from mail.gmx.net ([213.165.64.20]:37570 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751222AbYL2Xyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 18:54:51 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/FxlUsfPbFIrcl4DmctscH4vnu5w2Pc4goLOH944
	O9zUdabv+t8Rc1
Date: Tue, 30 Dec 2008 00:54:51 +0100 (CET)
From: Guennadi Liakhovetski <lg@denx.de>
X-X-Sender: lyakh@axis700.grange
To: Andrew Morton <akpm@linux-foundation.org>
cc: ben-linux@fluff.org, linux-kernel@vger.kernel.org, rpurdie@rpsys.net
Subject: Re: [PATCH v2] leds: add a dac124s085 SPI LED driver
In-Reply-To: <20081229151152.5699d59c.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0812300016030.8962@axis700.grange>
References: <Pine.LNX.4.64.0812181213540.5510@axis700.grange>
 <20081218120619.GJ12431@fluff.org.uk> <Pine.LNX.4.64.0812181346440.5510@axis700.grange>
 <20081229151152.5699d59c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Dec 2008, Andrew Morton wrote:

> On Thu, 18 Dec 2008 13:51:06 +0100 (CET)
> Guennadi Liakhovetski <lg@denx.de> wrote:
> 
> > +static void dac124s085_led_work(struct work_struct *work)
> > +{
> > +	struct dac124s085_led *led = container_of(work, struct dac124s085_led,
> > +						  work);
> > +	u16 word;
> > +
> > +	mutex_lock(&led->mutex);
> > +	word = cpu_to_le16(((led->id) << 14) | REG_WRITE_UPDATE |
> > +			   (led->brightness & 0xfff));
> > +	spi_write(led->spi, (const u8 *)&word, sizeof(word));
> 
> This looks like it might have endianness issues?

Actually this was an attempt to fix the endianness issue pointed out in an 
earlier review by Ben Dooks, have I done it wrong?

> > +	mutex_unlock(&led->mutex);
> > +}
> > +
> > +static void dac124s085_set_brightness(struct led_classdev *ldev,
> > +				      enum led_brightness brightness)
> > +{
> > +	struct dac124s085_led *led = container_of(ldev, struct dac124s085_led,
> > +						  ldev);
> > +
> > +	spin_lock(&led->lock);
> > +	led->brightness = brightness;
> > +	schedule_work(&led->work);
> > +	spin_unlock(&led->lock);
> > +}
> 
> So..  why do we need to defer this to a workqueue rather than just
> performing the operation synchronously?

Here's why (from include/linux/leds.h):

	/* Set LED brightness level */
	/* Must not sleep, use a workqueue if needed */
	void		(*brightness_set)(struct led_classdev *led_cdev,
					  enum led_brightness brightness);

> What happens if there are two calls to set_brightness() in quick
> succession, and the second occurs before the first has completed?  I
> think the schedule_work() fails and the second write gets lost?

This seems to be a common "feature" of multiple leds drivers. In fact, if 
the two calls are successive, then the queue will take care of the 
execution order. If they are "simultaneous," i.e., the callers didn't 
synchronise, how do we know who is the first and who is the second? Isn't 
the one that _completes_ first actually the first? Or am I missing 
something?

Thanks for the review!
Guennadi
---
Guennadi Liakhovetski, Ph.D.

DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
