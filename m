Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbYHXKJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbYHXKJW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 06:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbYHXKJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 06:09:13 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:42214 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbYHXKJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 06:09:12 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48B13334.9060406@s5r6.in-berlin.de>
Date: Sun, 24 Aug 2008 12:08:52 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Constantin Baranov <const@const.mimas.ru>, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH 2.6.27-rc3] led: driver for LEDs on PCEngines ALIX.2 and
 ALIX.3 boards
References: <48AB019D.6080302@const.mimas.ru> <20080822115150.6b3907a4.akpm@linux-foundation.org>
In-Reply-To: <20080822115150.6b3907a4.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 19 Aug 2008 22:23:41 +0500
> Constantin Baranov <const@const.mimas.ru> wrote:
>> --- linux-2.6.27-rc3/drivers/leds/leds-alix.c	1970-01-01 04:00:00.000000000 +0400
>> +++ linux-2.6.27-rc3-alix/drivers/leds/leds-alix.c	2008-08-19 21:59:05.207153570 +0500
...
>> +static int __init alix_led_probe(struct platform_device *pdev)
>> +{
>> +	int i;
>> +	int ret = 0;
>> +	
>> +	for (i = 0; i < ARRAY_SIZE(alix_leds) && ret >= 0; i++)
>> +		ret = led_classdev_register(&pdev->dev, &alix_leds[i].cdev);
>> +
>> +	if (ret < 0) {
>> +		for (i = i - 2; i >= 0; i--)
> 
> this is off-by-one, surely.
> 
> If we get here with i==1, we'll loop 4 billion times.
> 
>> +			led_classdev_unregister(&alix_leds[i].cdev);
>> +	}
>> +
>> +	return ret;
>> +}
...
> How's this look?
...
> @@ -92,7 +95,7 @@ static int __init alix_led_probe(struct 
>  		ret = led_classdev_register(&pdev->dev, &alix_leds[i].cdev);
>  
>  	if (ret < 0) {
> -		for (i = i - 2; i >= 0; i--)
> +		while (--i >= 0)
>  			led_classdev_unregister(&alix_leds[i].cdev);
>  	}


Really?  Constantin's code looks correct to me.  He increments i once 
more after failure.

Perhaps write it easier to read; i.e. in the same way as most error 
return checks everywhere in the kernel:

	for (i = 0; i < ARRAY_SIZE(alix_leds); i++) {
		ret = led_classdev_register(...etc...);
		if (ret < 0)
			break;
	}

	if (ret < 0)
		while (i--)
			led_classdev_unregister(&alix_leds[i].cdev);


Or		while (--i >= 0)

or		for (i--; i >= 0; i--)
-- 
Stefan Richter
-=====-==--- =--- ==---
http://arcgraph.de/sr/
