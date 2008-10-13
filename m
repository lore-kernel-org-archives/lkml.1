Return-Path: <linux-kernel-owner+w=401wt.eu-S932687AbYJMKQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687AbYJMKQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764905AbYJMKH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 06:07:29 -0400
Received: from xenbox.codefidence.com ([92.48.73.16]:40907 "EHLO
	xenbox.codefidence.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764912AbYJMKH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 06:07:27 -0400
X-Greylist: delayed 1414 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Oct 2008 06:07:27 EDT
Message-ID: <48F3185F.9070700@codefidence.com>
Date: Mon, 13 Oct 2008 11:43:59 +0200
From: Gilad Ben-Yossef <gilad@codefidence.com>
Organization: Codefidence Ltd.
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Neshama Parhoti <pneshama@gmail.com>
CC: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: section mismatch with a platform driver
References: <912ec82a0810130119g795c91ffr1083d7e8459a6db1@mail.gmail.com>	 <20081013085111.GB29938@cs181140183.pp.htv.fi> <912ec82a0810130228m3e9e11bcyfcabe1ab46fb0b6b@mail.gmail.com>
In-Reply-To: <912ec82a0810130228m3e9e11bcyfcabe1ab46fb0b6b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neshama Parhoti wrote:

> Hi Adrian and thank you for the help!
>
> On Mon, Oct 13, 2008 at 10:51 AM, Adrian Bunk <bunk@kernel.org> wrote:
>   
>> On Mon, Oct 13, 2008 at 10:19:05AM +0200, Neshama Parhoti wrote:
>>     
>>> WARNING: vmlinux.o(.data+0x44bc4): Section mismatch: reference to
>>> .init.text:my_probe_func (between 'my_platform_struct' and
>>> 'debug_level_variable')
>>>
>>> If I understand correctly, it shouts about my probe function being
>>> referenced from the data section:
>>>
>>> static struct platform_driver my_platform_struct = {
>>>       .probe          = my_probe_func,
>>>       .remove         = my_remove,
>>>       .suspend        = my_suspend,
>>>       .resume         = my_resume,
>>>       .driver         = {
>>>               .name = DRIVER_NAME,
>>>       },
>>> };
>>>
>>>       
>> It complains about "my_probe_func", and that's not even in the code
>> you posted.
>>     
>
> It happens even if I use an empty function like this:
>
> static int __init my_probe_func(struct platform_device *pdev)
> {
> 	return 0;
> }
>
>
> any idea what's the problem ?
>   
That __init macro marks the probe function as "throw after init" - it 
tells the compiler to put this function in  a separate ELF section that 
the kernel automatically frees when module init is done, but you are 
referencing this function in a structure that is not marked as "throw 
after init".

Can't be sure without seeing the whole picture, but the most probable 
solution is to drop that __init from the probe function. It's seems 
wrong as in theory the probe function can be called at any time in the 
life of the kernel, not just in this module init, even if in practice 
this will never happen, as I suspect is the case with such a platform 
driver.

Gilad



-- 
Gilad Ben-Yossef 
Chief Coffee Drinker

Codefidence Ltd.
The code is free, your time isn't.(TM)

Web:    http://codefidence.com
Email:  gilad@codefidence.com
Office: +972-8-9316883 ext. 201
Fax:    +972-8-9316885
Mobile: +972-52-8260388

	The Doctor: Don't worry, Reinette, just a nightmare. 
	Everyone has nightmares. Even monsters from under the 
	bed have nightmares, don't you, monster?
	Reinette: What do monsters have nightmares about?
	The Doctor: Me! 

