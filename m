Return-Path: <linux-kernel-owner+w=401wt.eu-S1759562AbYKEAB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759562AbYKEAB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 19:01:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757572AbYKEABK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 19:01:10 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:21293 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757988AbYKEABI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 19:01:08 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=_1xi8uX4wxalnw9Fj0gA:9 a=1SMxgIzKM6L2yTW5wZhspzjcEMIA:4 a=j0CMlSstq6wA:10 a=eNxp2uuuQYoA:10
Message-ID: <4910E240.4000801@shaw.ca>
Date: Tue, 04 Nov 2008 18:01:04 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata hibernation fixes
References: <fa.Ast7pgG6P20u1PcyOsfgzoaX5YA@ifi.uio.no> <fa.1+JQHm7yjIiZJxAzR0eBPn39a9M@ifi.uio.no> <fa.+bfipgmFkcLlZMtnFL0Ks2zyN8Q@ifi.uio.no> <fa.Iek0GbTZLinM2sOi6+b7bsCgnfs@ifi.uio.no>
In-Reply-To: <fa.Iek0GbTZLinM2sOi6+b7bsCgnfs@ifi.uio.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Rafael J. Wysocki wrote:
>> On Tuesday, 4 of November 2008, Linus Torvalds wrote:
>>> On Tue, 4 Nov 2008, Jeff Garzik wrote:
>>>> This adds code at a late stage (heading towards -rc4), but does
>>>> eliminate a particular spin-up overcycling behavior associated with
>>>> hibernation.
>>> What does this have to do with hibernation?
>>> If it's a hibernation-only issue, then there is something wrong. 
>>
>> No, it is not.  On some machines it is a power-off issue, on the 
>> others it is
>> hibernation and power-off issue.
>>
>>> Also, if it is an issue for normal power-off as well, then I wonder 
>>> why this isn't an issue on Windows. Does windows not spin down disks 
>>> at all?
>>
>> In fact, AFAICS, it is an issue on Windows as well, at least if
>> other-than-HP-preloaded version of Windows is used.
>>
>>> IOW, I really don't think this is correct.
>>> I _do_ think that correct might be:
>>>
>>>  - maybe we just do something odd and different, triggering some BIOS 
>>>    behavior that isn't there under Windows.
>>>
>>>    So we should power down thigns differently so that the BIOS.
>>>
>>>  - quite possibly: we just should not spin down disks at all, and 
>>> just    flush them and do the "park" command thing. If we're _really_ 
>>> powering    off, the disks will spin down on their own when power 
>>> goes away. Maybe    that's what Windows does?
>>>
>>> So I really don't want to pull this, because I want to get more of an 
>>> explanation for why we need to do this at all. I also don't think 
>>> this is even appropriate at this stage in -rc.
>>>
>>> Is it a regression? If so, that just strengthens the questions above 
>>> - what did _we_ start doing wrong that this is needed at all? Let's 
>>> just stop doing that, not add some idiotic black-list for somethign 
>>> that _we_ do wrong.
>>
>> This is a regression, but from something like 2.6.25 or even earlier.
>> I think what happened is we started to power-off disks at one point 
>> and these
>> BIOS-es just don't like that.
>>
>> [Note that the issue only appears in _some_ HP boxes, other vendors don't
>> seem to be affected at all.]
> .
> 
> So, what happens if we just don't ever spin them down from the kernel?
> Presumably they still spin-down normally (HP or otherwise) when the BIOS
> actually cuts the power at the end of all of this?
> 
> Just curious..

On many disks (especially laptops) just cutting the power without 
spinning the disk down is a bad thing to do, as it causes an emergency 
head unload which causes much more disk wear than a normal controlled 
unload (which a commanded spindown causes). This is much worse than the 
problem here, where the disk is spun down, spun up and down again.

On these systems, not spinning the disk down is fine because the BIOS 
does it. However this would cause problems on systems where the BIOS 
doesn't do so as it will cause an emergency unload on power-down.

 From what I have heard, the problem on the HP laptops is thought to be 
something to do with the disk spinning up and back down when it gets an 
IDLE IMMEDIATE command (from the BIOS' SMI code, or whatever it is) when 
it's already spun down (by the kernel). If that's truly the case it's 
pretty retarded behavior on the disk's part..
