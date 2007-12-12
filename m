Return-Path: <linux-kernel-owner+w=401wt.eu-S1759190AbXLLQc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759190AbXLLQc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 11:32:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756493AbXLLQcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 11:32:21 -0500
Received: from mail.hauppauge.com ([167.206.143.4]:4081 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756319AbXLLQcU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 11:32:20 -0500
X-Greylist: delayed 1838 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Dec 2007 11:32:19 EST
Message-ID: <476005AE.7070401@linuxtv.org>
From: mkrufky@linuxtv.org
To: mchehab@infradead.org
Cc: toralf.foerster@gmx.de, linux-kernel@vger.kernel.org,
       v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kbuild@vger.kernel.org
Subject: =?utf-8?B?UmU6IFt2NGwtZHZiLW1haW50YWluZXJdIGJ1aWxkICMzNDAgZmFp?=
	=?utf-8?B?bGVkIGZvciAyLjYuMjQtcmM1LWc3NWI4YzEzIGluCWxpbnV4L2RyaXZlcnMv?=
	=?utf-8?B?bWVkaWEvdmlkZW8vdHVuZXIua28=?=
Date: Wed, 12 Dec 2007 11:00:46 -0500
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2657.72)
in-reply-to: <1197470781.4744.41.camel@gaivota>
x-originalarrivaltime: 12 Dec 2007 15:57:30.0365 (UTC) FILETIME=[B349C2D0:01C83CD7]
user-agent: Thunderbird 2.0.0.9 (Windows/20071031)
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab wrote:
> Em Qua, 2007-12-12 às 08:42 -0500, Michael Krufky escreveu:
>   
>>> ERROR: "tea5761_attach" [drivers/media/video/tuner.ko] undefined!
>>> ERROR: "tea5761_autodetection" [drivers/media/video/tuner.ko] undefined!
>>> ERROR: "tea5767_autodetection" [drivers/media/video/tuner.ko] undefined!
>>> ERROR: "tea5767_attach" [drivers/media/video/tuner.ko] undefined!
>>>       
>
>   
>> It looks like the problem has something to do with VIDEO_TUNER=m while
>> both TUNER_TEA5761 & TUNER_TEA5767 are set to 'y'.
>>
>> I thought that we had already seen this issue and fixed it, but I guess
>> not :-/
>>
>> One would think that this could be fixed by making TUNER_TEA5761 &
>> TUNER_TEA5767 both depend on VIDEO_TUNER , but that would be wrong,
>> since each of those modules can be attached directly to a bridge driver
>> without tuner.ko being present at all (although this is not done in
>> practice right now, but it *is* the case with some other tuner drivers)
>>     
>
> I don't see any issue on making both dependent on VIDEO_TUNER for
> 2.6.24, since they are currently used only by tuner core module
> (tuner.ko).
>   
This could create confusion in the future.  It would fix the situation 
in 2.6.24 for the tea576x drivers, but would create bigger problems for 
the other tuner drivers.
> Yet, the same kind of trouble can happen with other drivers that can be
> shared by both V4L and DVB cores, like tda9887 and tda8290.
>   
Exactly,  except that tda9887 is an analog-only driver.  We CAN make 
TUNER_TDA9887 depend on VIDEO_TUNER, but it doesn't have to, for the 
same reasons described above.

We must _not_ make tda827x, tda8290, or mt20xx depend on VIDEO_TUNER.  
Same goes for tda18271, but that doesn't appear in the kernel until 2.6.25.
> The proper solution for 2.6.25 seems to create a drivers/media/tuners
> directory and write some different rules at Kconfig.
>
>   
I agree, although we spoke about this on linux-dvb last year and people 
didn't like the idea.  However, now the situation is different, due to 
hybrid tuner refactoring.  I can put together an RFC and handle it on 
the v4l / dvb mailing lists, hopefully have something ready for the 
2.6.25 merge window.  ( Do I have at least a month's time before then? )

--

What we really need is to make the Kconfig selection behave as if it 
depends on VIDEO_TUNER, but only if VIDEO_TUNER is selected.  I know 
that sounds redundant, but that would actually solve the problem.

If VIDEO_TUNER is not selected, then the driver can be built as either Y 
or M,  If, however, VIDEO_TUNER is selected, then the driver must be 
built as whatever VIDEO_TUNER was selected as.

Roman, do you have any ideas?

If not, I think that the best thing that we can do for 2.6.24 is force 
the selection of the tuner sub-drivers, although I'm not even sure that 
it would fix the problem...

Toralf, can you try the following, and let us know if this works?  I 
haven't had time to test it myself, yet.

Edit the file:  linux/drivers/media/Kconfig

scroll down to "config VIDEO_TUNER"

remove the bit " if !VIDEO_TUNER_CUSTOMIZE" , such that the select lines 
will read:

        select TUNER_MT20XX
        select TUNER_TDA8290
        select TUNER_TEA5761
        select TUNER_TEA5767
        select TUNER_SIMPLE
        select TUNER_TDA9887

instead of:

        select TUNER_MT20XX if !VIDEO_TUNER_CUSTOMIZE
        select TUNER_TDA8290 if !VIDEO_TUNER_CUSTOMIZE
        select TUNER_TEA5761 if !VIDEO_TUNER_CUSTOMIZE
        select TUNER_TEA5767 if !VIDEO_TUNER_CUSTOMIZE
        select TUNER_SIMPLE if !VIDEO_TUNER_CUSTOMIZE
        select TUNER_TDA9887 if !VIDEO_TUNER_CUSTOMIZE

If this fixes the problem, then I think it would be a good temporary fix 
for 2.6.24, until we can make a better, more drastic fix for 2.6.25

Thanks for testing.

Regards,
Mike Krufky

