Return-Path: <linux-kernel-owner+w=401wt.eu-S1756179AbYEXKwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbYEXKwg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 06:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754051AbYEXKw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 06:52:27 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:46481 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbYEXKw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 06:52:26 -0400
Date: Sat, 24 May 2008 13:49:56 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Steve French <smfrench@gmail.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: kernel coding style for if ... else which cross #ifdef
Message-ID: <20080524104956.GD4886@cs181133002.pp.htv.fi>
References: <524f69650805231211r315be4e4u5890aa0f914bcb4f@mail.gmail.com> <48374D3F.1080502@zytor.com> <20080524054301.GA3773@uranus.ravnborg.org> <4837AAE2.9090102@zytor.com> <20080524064201.GA4133@uranus.ravnborg.org> <4837E89D.9040008@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4837E89D.9040008@goop.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2008 at 11:06:21AM +0100, Jeremy Fitzhardinge wrote:
> Sam Ravnborg wrote:
>> On Fri, May 23, 2008 at 10:42:58PM -0700, H. Peter Anvin wrote:
>>   
>>> Sam Ravnborg wrote:
>>>     
>>>>> *However*, the best would really be if we changed Kconfig to emit 
>>>>> configuration constants what were 0/1 instead of 
>>>>> undefined/defined. That way we could do:
>>>>>
>>>>> 	if (CONFIG_SOMETHING && foo) {
>>>>> 		/* ... something ... */
>>>>> 	} else if ((mode & S_IWUGO) == 0) {
>>>>> 		/* ... */
>>>>>         
>>>> We could do that - but then it would need another
>>>> name not to clash with all the places where we rely
>>>> on CONFIG_FOO='n' => CONFIG_FOO is not defined.
>>>>
>>>> We could teach kconfig to emit something like:
>>>> #define KFOO 0   (for the 'n' value)
>>>> And 1 or 2 for the y and m values.
>>>>
>>>>       
>>> I don't think we want to use "1 or 2"... I suspect we want to use the 
>>> same booleans we currently have.
>>>     
>> I'm a bit dense (or I need more coffe - it's morning here).
>> What "same booleans"?
>>   
>
> They should be plain 0/1 booleans.  For a bool/tristate option FOO, it  
> would define:
>
> Enabled y:
>
>    #define CONFIG_FOO
>    #define CFG_FOO   1
>    #undef CONFIG_FOO_MODULE
>    #define CFG_FOO_MODULE 0
>
>
> Enabled m:
>
>    #define CONFIG_FOO
>    #define CFG_FOO   1
>    #define CONFIG_FOO_MODULE
>    #define CFG_FOO_MODULE 1
>...

A quite common pattern in the kernel is:
#if defined(CONFIG_FOO) || (defined(CONFIG_FOO_MODULE) && defined(MODULE))

Your suggestion would require them to be changed to:
#if (defined(CONFIG_FOO) && !defined(CONFIG_FOO_MODULE)) || (defined(CONFIG_FOO_MODULE) && defined(MODULE))

(We could push these cases to kconfig, but there might also be other 
 cases where changing the existing semantics of CONFIG_FOO could cause
 breakages.)

We see daily in kconfig that mixing tristates with bools is tricky 
(especially since bools are used with different intended semantics),
and I don't think doing the same in the source files would be an 
improvement.

We might be able to do (without any CFG_FOO_MODULE at all):

Enabled m:

    #undef CONFIG_FOO
    #define CFG_FOO   0
    #define CONFIG_FOO_MODULE

And let everyone who want's "either y or m" semantics to convert the 
tristate to a bool with this semantics in kconfig himself:

config FOO
	tristate

config BAR
	def_bool FOO

Especially since this is actually a relatively unusual (and not nice) 
case since usually adding a module does not (and should) not change the 
kernel image.

>    J

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

