Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116Ab0A1JYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab0A1JYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 04:24:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756018Ab0A1JYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 04:24:52 -0500
Received: from smtp.rozsnyo.com ([77.93.220.61]:57478 "EHLO smtp.rozsnyo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755195Ab0A1JYt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 04:24:49 -0500
Message-ID: <4B6157DB.6080502@rozsnyo.com>
Date: Thu, 28 Jan 2010 10:24:43 +0100
From: =?UTF-8?B?IkluZy4gRGFuaWVsIFJvenNuecOzIg==?= <daniel@rozsnyo.com>
Organization: REAS
User-Agent: Thunderbird 2.0.0.23 (X11/20091216)
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: Milan Broz <mbroz@redhat.com>, Marti Raudsepp <marti@juffo.org>,
       linux-kernel@vger.kernel.org
Subject: Re: bio too big - in nested raid setup
References: <4B5C963D.8040802@rozsnyo.com>	<5ec358371001250725l40b13060md880001c96be165f@mail.gmail.com>	<4B5DE2A9.4030500@redhat.com> <20100128132812.2d01f211@notabene>
In-Reply-To: <20100128132812.2d01f211@notabene>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown wrote:
> On Mon, 25 Jan 2010 19:27:53 +0100
> Milan Broz <mbroz@redhat.com> wrote:
> 
>> On 01/25/2010 04:25 PM, Marti Raudsepp wrote:
>>> 2010/1/24 "Ing. Daniel Rozsnyó" <daniel@rozsnyo.com>:
>>>> Hello,
>>>>  I am having troubles with nested RAID - when one array is added to the
>>>> other, the "bio too big device md0" messages are appearing:
>>>>
>>>> bio too big device md0 (144 > 8)
>>>> bio too big device md0 (248 > 8)
>>>> bio too big device md0 (32 > 8)
>>> I *think* this is the same bug that I hit years ago when mixing
>>> different disks and 'pvmove'
>>>
>>> It's a design flaw in the DM/MD frameworks; see comment #3 from Milan Broz:
>>> http://bugzilla.kernel.org/show_bug.cgi?id=9401#c3
>> Hm. I don't think it is the same problem, you are only adding device to md array...
>> (adding cc: Neil, this seems to me like MD bug).
>>
>> (original report for reference is here http://lkml.org/lkml/2010/1/24/60 )
> 
> No, I think it is the same problem.
> 
> When you have a stack of devices, the top level client needs to know the
> maximum restrictions imposed by lower level devices to ensure it doesn't
> violate them.
> However there is no mechanism for a device to report that its restrictions
> have changed.
> So when md0 gains a linear leg and so needs to reduce the max size for
> requests, there is no way to tell DM, so DM doesn't know.  And as the
> filesystem only asks DM for restrictions, it never finds out about the
> new restrictions.

Neil, why does it even reduce its block size? I've tried with both 
"linear" and "raid0" (as they are the only way to get 2T from 4x500G) 
and both behave the same (sda has 512, md0 127, linear 127 and raid0 has 
512 kb block size).

I do not see the mechanism how 512:127 or 512:512 leads to 4 kb limit

Is it because:
  - of rebuilding the array?
  - of non-multiplicative max block size
  - of non-multiplicative total device size
  - of nesting?
  - of some other fallback to 1 page?

I ask because I can not believe that a pre-assembled nested stack would 
result in 4kb max limit. But I haven't tried yet (e.g. from a live cd).

The block device should not do this kind of "magic", unless the higher 
layers support it. Which one has proper support then?
  - standard partition table?
  - LVM?
  - filesystem drivers?

> This should be fixed by having the filesystem not care about restrictions,
> and the lower levels just split requests as needed, but that just hasn't
> happened....
> 
> If you completely assemble md0 before activating the LVM stuff on top of it,
> this should work.
> 
> NeilBrown

