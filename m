Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809AbZLVPuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbZLVPuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 10:50:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbZLVPuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 10:50:12 -0500
Received: from chudak.whitesoft.cz ([81.92.149.98]:36739 "EHLO
	sahara.whitesoft.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753676AbZLVPuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 10:50:10 -0500
Message-ID: <4B30EAA8.5070004@century.cz>
Date: Tue, 22 Dec 2009 16:50:00 +0100
From: =?UTF-8?B?UGV0ciBUaXTEm3Jh?= <P.Titera@century.cz>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Wrong atime on recent kernels
References: <4B26AB7E.9020208@titera.eu>	 <1f1b08da0912141345ia574429k8b3e2fb73fdddb30@mail.gmail.com>	 <4B29494B.4010305@titera.eu>	 <1261020388.7245.27.camel@localhost.localdomain>	 <4B2A1051.9010808@century.cz>	 <1261106021.3466.76.camel@localhost.localdomain>	 <4B2EA55C.4030406@titera.eu>  <4B2EB3BC.6030900@titera.eu> <1261430174.5293.43.camel@localhost.localdomain>
In-Reply-To: <1261430174.5293.43.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz napsal(a):
> On Mon, 2009-12-21 at 00:31 +0100, Petr Titěra wrote: 
>   
>> Petr Titěra napsal(a):
>>     
>>> john stultz napsal(a):
>>>       
>>>> Let me know if you find anything that helps narrow this down.
>>>>
>>>>         
>>> I know its far fetched, but is there something what is preventing 
>>> xtime.tv_nsec to be exactly 999999999 near the end of update_wall_time 
>>> in kernel/time/timekeeping.c?
>>>
>>>       
>> Just to follow up. I'm asking because I see a lot of files with access 
>> and/or modify times near the top of thousanth of second (see 
>> `/etc/sysconfig/prelink' in my example) and I thing that addition of 1 
>> to xtime.tv_nsec ath the end of update_wall_time can 'owerflow' to whole 
>> second.
>>     
>
>
> Oof! Yikes.
>
> Yea, the sub-nanosecond rounding fix we added quite awhile back indeed
> opens a hole where xtime.tv_nsec could be exactly 1sec. Good eye!
>
> Of course, most of the timekeeping accessors handle this properly by
> normalizing the timespec before returning, so its likely just users of
> current_kernel_time() and direct accessors of xtime that might be bitten
> here. 
>
> And this probably was obscured before because the xtime_cache() was
> normalized. Did you verify that reverting that patch I pointed you to
> resolves the issue? If not, please do, so we can get this fixed up.
>
>   
I can confirm that I was not able to see any of those error after I've 
reverted that patch. But I was not able to repliace this at will. 
Considering that first files with this kind of error started to appear 
just about the time your patch went in I would propose that your 
explanation is plausible.

> Now I'm a little baffled why you see it all the time on your boxes. For
> this to trigger, you have to have an interrupt in the last ns of a
> second, and then the window for these odd filesystem stamps is only open
> for 1-10ms.
>
>   
I think my computer for some unknow reason had better chance of it. This 
is snip from filtered and sorted stats of files on my disk:

Access: 2009-12-16 21:51:55.659999999 +0100
Access: 2009-12-16 21:51:55.632000000 +0100
Access: 2009-12-16 21:51:55.552000004 +0100
Access: 2009-12-16 21:51:55.512000003 +0100
Access: 2009-12-16 21:51:55.436000005 +0100
Access: 2009-12-16 21:51:55.432000009 +0100
Access: 2009-12-16 21:51:55.363999951 +0100
Access: 2009-12-16 21:51:55.295999930 +0100
Access: 2009-12-16 21:51:55.287999689 +0100
Access: 2009-12-16 21:51:54.703999875 +0100
Access: 2009-12-16 21:51:54.683999001 +0100
Access: 2009-12-16 21:48:32.844000001 +0100
Access: 2009-12-16 21:48:31.375999999 +0100
Access: 2009-12-16 21:48:31.344000000 +0100
Access: 2009-12-16 21:48:31.047999999 +0100
Access: 2009-12-16 21:48:31.028000002 +0100
Access: 2009-12-16 21:48:31.015999998 +0100
Access: 2009-12-16 21:48:31.015999998 +0100

You see that in my case nanosecond times are sometimes oscilating 
withing edge of full milisecond. The sub millisecond part of time is 
mostly farr off of it.

Petr

> Sigh. Once we get the last of the non GENERIC_TIME arches converted to
> arch_gettimeoffset, we can kill all of those rounding hacks and just
> manage the sub-nanosecond portion sanely. I'm looking forward to that
> day!
>
>
> So again, Bravo on catching this!
>
> thanks
> -john
>
>
>
> __________ Informace od ESET Smart Security, verze databaze 4709 (20091222) __________
>
> Tuto zpravu proveril ESET Smart Security.
>
> http://www.eset.cz
>
>
>   



__________ Informace od ESET Smart Security, verze databaze 4709 (20091222) __________

Tuto zpravu proveril ESET Smart Security.

http://www.eset.cz


