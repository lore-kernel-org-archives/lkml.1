Return-Path: <linux-kernel-owner+w=401wt.eu-S1764201AbYD3WkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764201AbYD3WkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933982AbYD3WjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:39:12 -0400
Received: from mail.hauppauge.com ([167.206.143.4]:2398 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765220AbYD3WjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:39:10 -0400
Message-ID: <4818F4EE.8050004@linuxtv.org>
From: mkrufky@linuxtv.org
To: xyzzy@speakeasy.org
Cc: akpm@linux-foundation.org, sfr@canb.auug.org.au,
       video4linux-list@redhat.com, torvalds@linux-foundation.org,
       efault@gmx.de, linux-kernel@vger.kernel.org, mchehab@infradead.org,
       linux-dvb-maintainer@linuxtv.org, mingo@elte.hu, sam@ravnborg.org,
       davem@davemloft.net
Subject: Re: [v4l-dvb-maintainer] [patch, -git] drivers/media build fix fo
	r modular builds
Date: Wed, 30 Apr 2008 18:38:38 -0400
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2657.72)
in-reply-to: <Pine.LNX.4.58.0804301442010.9894@shell4.speakeasy.net>
x-originalarrivaltime: 30 Apr 2008 22:35:29.0057 (UTC) FILETIME=[7DEE0110:01C8AB12]
user-agent: Thunderbird 2.0.0.12 (Windows/20080213)
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trent Piepho wrote:
> On Wed, 30 Apr 2008, Andrew Morton wrote:
>   
>> Does this make it feel better?
>>
>> --- a/drivers/media/video/tuner-core.c~a
>> +++ a/drivers/media/video/tuner-core.c
>> @@ -40,11 +40,11 @@
>>  	typeof(&FUNCTION) __a = symbol_request(FUNCTION); \
>>  	if (__a) { \
>>  		__r = (int) __a(ARGS); \
>> +		symbol_put(FUNCTION); \
>>  	} else { \
>>  		printk(KERN_ERR "TUNER: Unable to find " \
>>  				"symbol "#FUNCTION"()\n"); \
>>  	} \
>> -	symbol_put(FUNCTION); \
>>  	__r; \
>>  })
>>     
>
> Should the symbol_put be done at all?  When I wrote the code this is based
> on, it would check if FUNCTION failed or not.  If it failed, the symbol
was
> put.  But if it worked, then one was returned a handle into FUNCTION's
> module, and so the symbol was not put.  If it was, the module's refcount
> would be zero but the caller would have a handle into the module.
>
> So if FUNCTION does anything that creates references to the module, and it
> doesn't inc it's own refcount, then the symbol_put shouldn't be done.
>
>   
Trent,

The symbol_put is correct in this case.  This macro above is called 
"tuner_symbol_probe" , used only within tuner-core.c

This macro is used to call the probe function of a tuner sub-module 
(tea5761, tea5767, tda8290).  Regardless of whether the probe succeeds 
or fails, we do the symbol_put.  If the probe succeeds, tuner-core will 
proceed to dvb_attach(that_tuner_attach, params), which does the actual 
module use count increase.

Regards,

Mike
