Return-Path: <linux-kernel-owner+w=401wt.eu-S1752569AbXCHRF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbXCHRF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 12:05:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbXCHRF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 12:05:56 -0500
Received: from mta9.adelphia.net ([68.168.78.199]:64587 "EHLO
	mta9.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbXCHRFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 12:05:55 -0500
Message-ID: <45F0426D.6020408@earthlink.net>
Date: Thu, 08 Mar 2007 12:05:49 -0500
From: Randy Cushman <rcushman_linux@earthlink.net>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Jaroslav Kysela <perex@suse.cz>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: mm snapshot broken-out-2007-03-05-02-22.tar.gz uploaded
References: <200703051024.l25AOIF3015951@shell0.pdx.osdl.net>	<45EEA3C4.7000501@googlemail.com>	<20070307104746.f08a2e84.akpm@linux-foundation.org>	<6bffcb0e0703071141j42309702w793e4a76b1b23bfa@mail.gmail.com>	<20070307115024.756c848f.akpm@linux-foundation.org>	<s5hvehcrdod.wl%tiwai@suse.de>	<45EF3B2C.9060801@googlemail.com>	<s5hfy8gbrmj.wl%tiwai@suse.de>	<45F02EE2.6040606@googlemail.com>	<s5h8xe7ognj.wl%tiwai@suse.de>	<6bffcb0e0703080852l4a06c0f9qeb51044a7a1a68a@mail.gmail.com> <s5hwt1rn0aj.wl%tiwai@suse.de>
In-Reply-To: <s5hwt1rn0aj.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> At Thu, 8 Mar 2007 17:52:43 +0100,
> Michal Piotrowski wrote:
>   
>> On 08/03/07, Takashi Iwai <tiwai@suse.de> wrote:
>>     
>>> At Thu, 08 Mar 2007 16:42:26 +0100,
>>> Michal Piotrowski wrote:
>>>       
>>>>> Also, it'd be helpful if you compare
>>>>> /proc/asound/card0/codec97#0/ac97#0-0+regs file before and after the
>>>>> patch.  This reveals which register bits differ actually.
>>>>>           
>>>> a2.txt is form 2.6.21-rc3 witchout 831466f4ad2b5fe23dff77edbe6a7c244435e973
>>>>
>>>> diff -uprN a2.txt /proc/asound/card0/codec97#0/ac97#0-0+regs
>>>> --- a2.txt      2007-03-08 16:36:47.000000000 +0100
>>>> +++ /proc/asound/card0/codec97#0/ac97#0-0+regs  2007-03-08 16:36:49.447083597 +0100
>>>> @@ -56,8 +56,8 @@
>>>>  0:6e = 0000
>>>>  0:70 = 0000
>>>>  0:72 = 0004
>>>> -0:74 = 1001
>>>> -0:76 = 64a4
>>>> +0:74 = 1201
>>>> +0:76 = 7ca4
>>>>  0:78 = 000c
>>>>  0:7a = 0000
>>>>  0:7c = 4144
>>>>         
>>> OK, some wrong bits there.  Could you try the patch below?
>>>       
>> Problem fixed. Thanks!
>>
>> (speaker-test -c6 -Dplug:surround51 is still broken)
>>     
>
> Hm, how about turning off "Spread Front To..." control and run
> speaker-test?
>
>
> Takashi
>
>
>   
Michal and Takashi,

I've been researching your issue this morning.  I just noticed that your 
exchange had ensued.

I configured my AD1986-based system as closely as I could to match your 
AD1985 mixer settings.  In doing so, I experienced results similar to 
what I'm assuming you described:  Only front channel sound came out of 
the surround and c/lfe jacks.

Here is what I had to change to get the appropriate multichannel sound:

1) The command "speaker-test -c6" does not work on my system.  I have to 
use "speaker-test -Dsurround51 -c6"  (Perhaps this is related to running 
an old version of speaker-test.)

2) I disabled "Spread Front to Surround and Center/LFE"

The explanation for 2) is this:  There can be only one source for each 
of the Surround and Center/LFE jacks active at one time.  When "Spread 
Front to Surround and Center/LFE" is disabled, the surround channels go 
to the the jacks; when this control is enabled, ONLY the front channels 
go to the surround and c/lfe jacks.

Considering the register values Michal provided and Takashi's patch:

The logic of the code is as follows:  (Slightly simplifying,) functions 
is_shared_linein() and is_shared_micin() return TRUE if the mixer is 
configured for shared jacks AND NOT for 6 channel mode.  In this case it 
is appropriate to
set these bits (LODIS and CLDIS).

Please double-check your mixer settings.  I added a byte to a structure, 
so the mixer settings can get messed up switching between alsa-kernel 
versions.

I don't understand why the other bit (OMS, 0x74 bit D9) is set.  This 
may have been an oversight on my part.

I am modifying alsa-kernel to run as an AD1985 on my system, to try to 
check these bits.

Randy Cushman


