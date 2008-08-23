Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbYHWRMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbYHWRMa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 13:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbYHWRMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 13:12:01 -0400
Received: from const.mimas.ru ([88.200.217.78]:44319 "EHLO const.mimas.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805AbYHWRMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 13:12:00 -0400
Message-ID: <48B044DC.5040700@const.mimas.ru>
Date: Sat, 23 Aug 2008 22:11:56 +0500
From: Constantin Baranov <const@const.mimas.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.16) Gecko/20080805 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, rpurdie@rpsys.net
Subject: Re: [PATCH 2.6.27-rc3] led: driver for LEDs on PCEngines ALIX.2 and
 ALIX.3 boards
References: <48AB019D.6080302@const.mimas.ru>	<20080822115150.6b3907a4.akpm@linux-foundation.org>	<48AF2ABF.8080901@const.mimas.ru> <20080822143143.4202f940.akpm@linux-foundation.org>
In-Reply-To: <20080822143143.4202f940.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 23 Aug 2008 02:08:15 +0500
> Constantin Baranov <const@const.mimas.ru> wrote:
> 
>>>  static int alix_led_resume(struct platform_device *dev)
>>>  {
>>>  	int i;
>>> +
>>>  	for (i = 0; i < ARRAY_SIZE(alix_leds); i++)
>>>  		led_classdev_resume(&alix_leds[i].cdev);
>>>  	return 0;
>>> @@ -92,7 +95,7 @@ static int __init alix_led_probe(struct 
>>>  		ret = led_classdev_register(&pdev->dev, &alix_leds[i].cdev);
>>>  
>>>  	if (ret < 0) {
>>> -		for (i = i - 2; i >= 0; i--)
>>> +		while (--i >= 0)
>>>  			led_classdev_unregister(&alix_leds[i].cdev);
>>>  	}
>> At the first iteration this while-loop will attempt to unregister
>> device that has failed and thus is not registered.
>> My for-loop starts from device immediately before failed one.
> 
> ug, OK, the complex expression in that for-loop is to blame.
> 
> For maintinability we should aim for code which is as simple and as
> straightfroward as possible and which adheres to oft-used and
> well-understood kernel idioms.
> 
> For example, this?
> 
> static int __init alix_led_probe(struct platform_device *pdev)
> {
> 	int i;
> 	int ret;
> 
> 	for (i = 0; i < ARRAY_SIZE(alix_leds); i++) {
> 		ret = led_classdev_register(&pdev->dev, &alix_leds[i].cdev);
> 		if (ret < 0)
> 			goto fail;
> 	}
> 	return 0;
> 
> fail:
> 	while (--i >= 0)
> 		led_classdev_unregister(&alix_leds[i].cdev);
> 	return ret;
> }
> 
> (note there's no longer a need for a fake initalisation of `ret')
> 
>> Note that probe routine originates from leds-ams-delta.c.
> 
> That's what you get for copying stuff :(

Well, this variant looks better and correct and still works.
Should I post again patch or fix-patch?
