Return-Path: <linux-kernel-owner+w=401wt.eu-S1758706AbYHVVcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706AbYHVVcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 17:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755829AbYHVVcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 17:32:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752261AbYHVVci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 17:32:38 -0400
Date: Fri, 22 Aug 2008 14:31:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Constantin Baranov <const@const.mimas.ru>
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net
Subject: Re: [PATCH 2.6.27-rc3] led: driver for LEDs on PCEngines ALIX.2 and
 ALIX.3 boards
Message-Id: <20080822143143.4202f940.akpm@linux-foundation.org>
In-Reply-To: <48AF2ABF.8080901@const.mimas.ru>
References: <48AB019D.6080302@const.mimas.ru>
	<20080822115150.6b3907a4.akpm@linux-foundation.org>
	<48AF2ABF.8080901@const.mimas.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Aug 2008 02:08:15 +0500
Constantin Baranov <const@const.mimas.ru> wrote:

> >  static int alix_led_resume(struct platform_device *dev)
> >  {
> >  	int i;
> > +
> >  	for (i = 0; i < ARRAY_SIZE(alix_leds); i++)
> >  		led_classdev_resume(&alix_leds[i].cdev);
> >  	return 0;
> > @@ -92,7 +95,7 @@ static int __init alix_led_probe(struct 
> >  		ret = led_classdev_register(&pdev->dev, &alix_leds[i].cdev);
> >  
> >  	if (ret < 0) {
> > -		for (i = i - 2; i >= 0; i--)
> > +		while (--i >= 0)
> >  			led_classdev_unregister(&alix_leds[i].cdev);
> >  	}
> 
> At the first iteration this while-loop will attempt to unregister
> device that has failed and thus is not registered.
> My for-loop starts from device immediately before failed one.

ug, OK, the complex expression in that for-loop is to blame.

For maintinability we should aim for code which is as simple and as
straightfroward as possible and which adheres to oft-used and
well-understood kernel idioms.

For example, this?

static int __init alix_led_probe(struct platform_device *pdev)
{
	int i;
	int ret;

	for (i = 0; i < ARRAY_SIZE(alix_leds); i++) {
		ret = led_classdev_register(&pdev->dev, &alix_leds[i].cdev);
		if (ret < 0)
			goto fail;
	}
	return 0;

fail:
	while (--i >= 0)
		led_classdev_unregister(&alix_leds[i].cdev);
	return ret;
}

(note there's no longer a need for a fake initalisation of `ret')

> Note that probe routine originates from leds-ams-delta.c.

That's what you get for copying stuff :(
