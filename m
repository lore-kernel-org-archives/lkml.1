Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933487Ab0CKTHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 14:07:46 -0500
Received: from enyo.dsw2k3.info ([195.71.86.239]:47892 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439Ab0CKTHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 14:07:44 -0500
Date: Thu, 11 Mar 2010 20:07:29 +0100
From: Matthias Schniedermeyer <ms@citd.de>
To: david@lang.hm
Cc: Mathias Buren <mathias.buren@ie.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: RAID + LUKS + LVM performance
Message-ID: <20100311190729.GA18153@citd.de>
References: <OF8365E100.57191C87-ON802576E3.0046BDEA-802576E3.0047EFDF@ie.ibm.com> <20100311173604.GA17659@citd.de> <alpine.DEB.2.00.1003110949290.5131@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1003110949290.5131@asgard.lang.hm>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.03.2010 09:51, david@lang.hm wrote:
> On Thu, 11 Mar 2010, Matthias Schniedermeyer wrote:
>
>> On 11.03.2010 13:08, Mathias Buren wrote:
>>>
>>> Hi,
>>>
>>> (please cc me as I'm not subscribed)
>>>
>>> I've a friend who's going to set up a fileserver consisting of 8x 1.5TB
>>> HDDs, an 8-port PCI-E RAID card (Areca ARC-1220 @
>>> http://www.areca.com.tw/products/pcie.htm ) etc.
>>> The plan is create a RAID5 array spanning all the disks, then create 4
>>> partitions. These 4 partitions would be encrypted using LUKS (Twofish or
>>> AES256).
>>> These 4 encrypted partition would be set up in RAID0 using Linux' software
>>> (mdadm), then LVM would be used on top of that (one big PV, one big VG and
>>> a big LV or so).
>>>
>>> The reason for this is that kcryptd is not multithreaded (afaik). By having
>>> 4 encrypted partitions, then md0 on top of them, I'm forcing 4 kcryptd
>>> processes to run on all four cpu cores whenever something is written to the
>>> disks, which should improve (encryption) performance.
>>>
>>> Is this a good way of doing it, or is there a smarter way?
>>
>> The setup you describe would only work with SSDs. HDDs would seek
>> themselves to death.
>>
>> The problem is the RAID-0 over the 4 partitions. At that point you would
>> need, instead of the 4 partitions, something that is round-robin. So
>> that the mapping of the (physical) blocks from the upper to the lower
>> would be effectivly linear/unchanged.
>>
>> AFAIK something like that is (currently) not possible.
>
> linux software raid (the md tools) support linear or striped modes for  
> raid0, so what you are looking for is available.

Nope. What i meant is:

Let say you had a block-device which has 16 blocks:
0-15
With the OPs description the blocks would be distributed like this:
Part 0: 00 01 02 03
Part 1: 04 05 06 07
Part 2: 08 09 10 11
Part 3: 12 13 14 15

What you need is a distribution like this:
Device 0: 01 05 09 13 
Device 1: 02 06 10 14
Device 2: 03 07 11 15
Device 3: 04 08 12 16

IOW:
Blocks % 4 == 0 on device 0
Blocks % 4 == 1 on device 1
Blocks % 4 == 2 on device 2
Blocks % 4 == 3 on device 3

I still other words:
You don't want a cake in exactly 4 same size parts. You want a cake in a 
million parts and then every 4th starting from the first piece in one 
set, every 4th starting from the second in the next and so on.

> however I think that defeats part of the OPs purpose, which was to try 
> and spread the I/O across all 4 partitions to be able to use multiple 
> cores for the encryption.

I think i just didn't make clear enough what i meant.




Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

