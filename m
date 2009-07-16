Return-Path: <linux-kernel-owner+w=401wt.eu-S933384AbZGPU7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933384AbZGPU7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 16:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933375AbZGPU7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 16:59:24 -0400
Received: from mail.lang.hm ([64.81.33.126]:52495 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933374AbZGPU7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 16:59:23 -0400
Date: Thu, 16 Jul 2009 13:59:06 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: James Smart <James.Smart@Emulex.Com>, Boaz Harrosh <bharrosh@panasas.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: deterministic scsi order with async scan
In-Reply-To: <1247774170.6606.305.camel@mulgrave.site>
Message-ID: <alpine.DEB.1.10.0907161355180.9159@asgard>
References: <alpine.DEB.1.10.0907151801040.9159@asgard>  <4A5F100E.9000107@panasas.com> <alpine.DEB.1.10.0907161017180.9159@asgard>  <4A5F723B.7070408@emulex.com>  <alpine.DEB.1.10.0907161143010.9159@asgard>  <1247773155.6606.265.camel@mulgrave.site> 
 <alpine.DEB.1.10.0907161245470.9159@asgard> <1247774170.6606.305.camel@mulgrave.site>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jul 2009, James Bottomley wrote:

> On Thu, 2009-07-16 at 12:48 -0700, david@lang.hm wrote:
>> On Thu, 16 Jul 2009, James Bottomley wrote:
>>
>>> On Thu, 2009-07-16 at 11:43 -0700, david@lang.hm wrote:
>>>> On Thu, 16 Jul 2009, James Smart wrote:
>>>>
>>>>> david@lang.hm wrote:
>>>>>> On Thu, 16 Jul 2009, Boaz Harrosh wrote:
>>>>>>
>>>>>>
>>>>>>> It is highly discouraged to setup any kind of system that depends
>>>>>>> on device-names for block-devices. mounts have the mount by-label
>>>>>>> or mount by-uuid. Any other subsystem should go by /dev/disk/by-id/*
>>>>>>> slinks to find a persistent raw block-device. the id is generated
>>>>>>> from characteristics inside the disk itself so it will be the same
>>>>>>> no matter what host connection or bus it is connected too (almost).
>>>>>>>
>>>>>>> This is because even if the boot order is consistent, the device-name
>>>>>>> is so volatile in the life-span of a system. Did I boot with a removable
>>>>>>> USB inserted. that camera or printer was on or off, disk was connected
>>>>>>> to the other port. Any such change will break things and give you a very
>>>>>>> poor user experience.
>>>>>>>
>>>>>>
>>>>>> for a laptop you areprobably correct, but for a server or embedded system
>>>>>> that doesn't have it's hardware changing all the time you are not correct.
>>>>>>
>>>>>> especially on a system with lots of drives, why should I have to create an
>>>>>> initrd that goes and searches dozens or hundreds of drives to find out
>>>>>> which one to boot from?
>>>>>>
>>>>> Boaz is correct. Many enterprise SCSI subsystems (FC, SAS) do not have hard
>>>>> transport addresses for each device like Parallel SCSI used to.  Thus, any
>>>>> difference in order of appearance of the devices (power-up ordering, FC ALPA
>>>>> assignment based on who's loop master, order that switch reports them, is an
>>>>> array in a failover mode with 1 controller non-existent), or if LUN
>>>>> configuration on an array changes, or as a drive may fail (especially with
>>>>> hundreds), there's no guarantee you will see the same thing in the same order
>>>>> w/o name binding. Same thing is true if one of those adapters fails or is
>>>>> swapped out.
>>>>
>>>> yes, but does your system change the order of your internal direct
>>>> attached drives with your FC/SAN drives?
>>>
>>> Certainly, it can.  The way BIOS booting gets around this is either to
>>> use some type of physical indicator (like phy number for SAS) to find C:
>>> or to use a persistent ID mapping scheme (which is pretty much
>>> equivalent to our /dev/disk/by-id/ udev one).
>>
>> so if I don't use udev but do want the async detection my only option to
>> have it boot from card 1 instead of card 2 is to just keep rebooting the
>> machine until it guesses right?
>
> Well, for multiple cards that's effectively true with or without async
> scanning ... the kernel doesn't know how you've enabled the bios scans
> on the cards, so it takes first bus discovery order, so your boot drive
> can always end up as /dev/sdb etc.

that's what I am attempting to do, but it's not stable.

I fully agree that if you move cards or change the bios scan order things 
will change. I'm not talking about a case like that. I'm talking about a 
case where the hardware and BIOS do not change.

> In theory, async probing shouldn't be racy, but we've likely got a
> problem between async SCSI scanning and async sd driver attachment, so
> when those are sorted out it should be no worse with than without.

so is there something that I can do to debug this case where it is racy? 
I have a repeatable test case right now. if there is something I can do to 
test this to help track down the race I will do so, otherwise I will need 
to disable the async scanning as being unreliable.

David Lang
