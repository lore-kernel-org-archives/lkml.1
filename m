Return-Path: <linux-kernel-owner+w=401wt.eu-S1757426AbYIABCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426AbYIABCV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 21:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbYIABCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 21:02:12 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:61605 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbYIABCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 21:02:12 -0400
Date: Sun, 31 Aug 2008 21:01:44 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Linux-2.6.27-rc5, drm errors in log
In-reply-to: <21d7e9970808311356n47285341s217353ee892a295e@mail.gmail.com>
To: "Dave Airlie" <airlied@gmail.com>
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
Message-id: <200808312101.44483.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <898503EB1E15BA4F944D1BE69D55AAC8AB540A@storexmb1.amd.com>
 <200808311423.11311.gene.heskett@gmail.com>
 <21d7e9970808311356n47285341s217353ee892a295e@mail.gmail.com>
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 31 August 2008, Dave Airlie wrote:
>On Mon, Sep 1, 2008 at 4:23 AM, Gene Heskett <gene.heskett@gmail.com> wrote:
>> On Sunday 31 August 2008, Gene Heskett wrote:
>>>On Sunday 31 August 2008, Dave Airlie wrote:
>>>>On Sun, Aug 31, 2008 at 12:19 PM, Gene Heskett <gene.heskett@verizon.net>
>>
>> wrote:
>>>>> On Saturday 30 August 2008, Bridgman, John wrote:
>>>>>>))I'm drowning in these errors:
>>>>>>))
>>>>>>))Aug 30 13:21:05 coyote kernel: [14927.850078] [drm] wait for fifo
>>>>>> failed status : 0x80076100 0x00000000
>>>>>>
>>>>>>I'm just going on the code in your email - can't view git until later
>>>>>> today - but in this case it seems like the timeouts were always
>>>>>> happening and now there is code to print an error message.
>>>>>>
>>>>>>IIRC the usual fix is to bump the timeout but (Michael ?) has suggested
>>>>>> a couple of times that the ideal solution would be to change the logic
>>>>>> so that the driver never times out while the chip is making progress
>>>>>> (ie while the number of slots available in the fifo is increasing,
>>>>>> even if it hasn't increased enough yet).
>>>>>
>>>>> FWIW, I added the 3 lines that cause that printout to the 2.6.27-rc4
>>>>> tree and rebuilt it.  There are no more errors being reported now by
>>>>> 2.6.27-rc4, and there were none without those 3 added lines prior to
>>>>> this, so it is rc5 specific.
>>>>
>>>>Hmm I'm just looking at the patches I put in for rc5, and there is no
>>>>functional difference to the
>>>>r200 codepath that I can see from those patches apart from the debug
>>>> prints.
>>>
>>>Update: there were 3 of those in the log after I sent the denial msg.
>>>======
>>>Aug 30 23:48:34 coyote kernel: [ 7242.890000] [drm] wait for fifo failed
>>> status : 0x80076100 0x00000000 Aug 30 23:57:51 coyote kernel: [
>>> 7800.370001] [drm] wait for fifo failed status : 0x8003C100 0x00000000
>>> Aug 30 23:57:51 coyote kernel: [ 7800.458000] [drm] wait for fifo failed
>>> status
>>>
>>> : 0x8007C100 0x00000000 ======
>>>
>>>So this is a real, pre-rc5 problem, but without the reporting that
>>> enabled.
>>>
>>>>Can you get a clean -rc4 and apply just
>>>> 54f961a628b737f66710eca0b0d95346645dd33e to it.
>>>
>>>Yes I can, but how do I get that specific patch?  Or is that the git # for
>>> the patch I first applied to -rc2, which added the firmware/radeon stuff?
>>> I'm familiar with patch, but not on a first name basis with git, sorry.
>>>
>>>So I'm going to do a bisect, my style.  I will rebuild, starting with
>>> -rc3, using only the -rcX patch and the firmware addition patch, which
>>> applied to -rc3 as follows:
>>>now applying [PATCH]radeon_cp-use-request_firmware
>>>
>>>patching file drivers/gpu/drm/radeon/radeon_cp.c
>>>patching file drivers/gpu/drm/radeon/radeon_drv.h
>>>patching file drivers/gpu/drm/radeon/radeon_microcode.h
>>>patching file firmware/Makefile
>>>Hunk #1 FAILED at 34.
>>>1 out of 1 hunk FAILED -- saving rejects to file firmware/Makefile.rej
>>>===So I added that into the firmware/Makefile at line 28 by hand===
>>>patching file firmware/WHENCE
>>>Hunk #1 succeeded at 339 (offset -233 lines).
>>>patching file firmware/radeon/R100_cp.bin.ihex
>>>patching file firmware/radeon/R200_cp.bin.ihex
>>>patching file firmware/radeon/R300_cp.bin.ihex
>>>patching file firmware/radeon/R420_cp.bin.ihex
>>>patching file firmware/radeon/R520_cp.bin.ihex
>>>patching file firmware/radeon/RS600_cp.bin.ihex
>>>patching file firmware/radeon/RS690_cp.bin.ihex
>>>
>>>patch [PATCH]radeon_cp-use-request_firmware done
>>>
>>>=== and I'm watching the build for errors===
>>>It got past the MK_FW for those ok.
>>>However there were 6 section miss-matches reported, and the suggested
>>>addition to .config did not make it any noisier so I'm no smarter.
>>>Now I've added those 3 reporter lines to radeon_cp.c, rebuilt again and
>>>will reboot to -rc3 for effects, reporting after a few hours uptime.
>>
>> Ok Dave, I have chased it all the way back to rc1 by adding those 3 lines
>> of reporter, and at 2.6.27-rc1 it is still doing it.  This is without the
>> radeon firmware patch, but since the microcode is still there in
>> /lib/firmware, the log says it is still being loaded.
>>
>> I am beginning to think this is a very old bug, and this evening I will
>> try those 3 reporter lines added to 2.6.25.4 as I still have that src tree
>> here.
>
>I think you've probably always had the problem, we just never reported
>it before.

I'm thinking along those lines myself.  And I'm assuming that -rc5 is 10x 
worse because the added code in user space is now slow enough to trigger it 
easier.

That also takes me back to one of my original Q's , and that was the question 
about it using an R300 call on an RV280 card. 

>There are some timeouts that may be set too low somewhere in userspace
>and we may need to adjust them.
>
>Dave.

Thanks Dave.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Live Free or Live in Massachusettes.
