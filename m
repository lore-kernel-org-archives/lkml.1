Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210AbYCOXTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbYCOXTx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 19:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbYCOXTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 19:19:43 -0400
Received: from mail.lang.hm ([64.81.33.126]:54510 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753012AbYCOXTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 19:19:42 -0400
Date: Sat, 15 Mar 2008 16:22:20 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Daniel Phillips <phillips@phunq.net>
cc: Willy Tarreau <w@1wt.eu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Newall <davidn@davidnewall.com>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
In-Reply-To: <200803151533.10797.phillips@phunq.net>
Message-ID: <alpine.DEB.1.00.0803151540150.22040@asgard.lang.hm>
References: <200803092346.17556.phillips@phunq.net> <200803151417.13899.phillips@phunq.net> <20080315215427.GC13012@1wt.eu> <200803151533.10797.phillips@phunq.net>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Mar 2008, Daniel Phillips wrote:

> On Saturday 15 March 2008 14:54, Willy Tarreau wrote:
>> I think it could get major adoption with ordered writes.
>
> It already has ordered write when it is in flush mode.
>
> OK, I hear you. There will be an ordered write mode that uses barriers
> to decide the ordering.  It will greatly reduce the speed at which
> ramback can flush dirty data because of the need to wait synchronously
> on every barrier, of which there are many.  And thus will widen out the
> window during which UPS power must remain available if power goes out,
> in order to get all acknowledged transactions on to stable media.  The
> advantage is, the stable media always has a point-in-time version of
> the filesystem.

it will mean that the window is larger, but it will also mean that if 
something else goes wrong and that window is not available the data that 
was written out will be useable (recent data will be lost, but older data 
will still be available)

as for things that can go wrong

the UPS battery can go bad
you can have multiple power failures in a short time so your battery is not fully charged
capacitors in the UPS can go bad
capacitors in the power supply can go bad
capacitors on the motherboard can go bad
a kernel bug can crash the system
a bug in a device driver (say nvidia graphics driver) can crash the system
a card in the system can lock up the system bus
the system power supply can die
the system fans can die and cause the system to overheat
cooling in the room the system is in can fail and cause the system to overheat
airflow to the computer can get blocked and cause the system to overheat
some other component in the computer can short out and cause the system to loose power internally

I have had every single one of these things happen to me over the years. 
Some on personal equipment, some on work equipment. At work I recently had 
a series of disasters where capacitors in a 7 figure UPS blew up, and a 
few days later during a power outage when we were running on generator, a 
fuel company made a mistake while adding fuel to the generator and knocked 
it out.

Even if you spend millions on equipment and professionals to set it up and 
maintain it, you can still go down.

You may not care about it on your system (becouse you copy data elsewhere 
and don't change it rapidly), but most people do. with your current 
approach you are slightly better then a couple shell scripts from an 
availability point of view, you are no better in performance, but your 
failure mode is complete disaster.

comparing you to 'cp drive ramdisk' at startup and 'rsync ramdisk drive' 
periodicly and at shutdown you are faster at startup, close enough at 
shutdown as to be in the noise (either one could be faster, depending on 
the exact conditions)

you have a failback mode that when the UPS tells you it has failed you 
switch to write-through mode, that's some use (but only if you get 
everything flushed first)

another off-the-shelf option is that you could use DRDB between the 
ramdisk and the real drive, and when you loose power reconfigure to do 
syncronous updates instead of write-behind updates. that would still be 
far safer then ramback in it's current mode.

> Don't expect this mode in the immediate future though, there are bugs
> to fix in the current driver, which already implements the required
> performance and stability requirements for a broad range of users.

and when those users ask why this functionality isn't in the kernel they 
will read this thread and learn how many risks they are taking (in spite 
of you promising them that they are perfectly safe)

anyone who has run any significant number of systems will not believe your 
statement that hardware and software is reliable enough to be trusted like 
this. by continuing to make this claim you are going to be ignored by 
those people, and franky, they will distrust any of your work as a result.

>>> That is why I keep recommending that a ramback setup be replicated or
>>> mirrored, which people in this thread keep glossing over.  When
>>> replicated or mirrored, you still get the microsecond-level transaction
>>> times, and you get the safety too.

but a straight ramdisk can be replicated or mirrored. there's no need to 
have ramback to do this.

>> I agree, but in this case, you should present it this way. You have been
>> insisting too much on the average PC's reliability, the fact that no kernel
>> ever crashed for you, etc... So you are demonstrating that your product is
>> good provided that everything goes perfectly. All people who have experienced
>> software or hardware problems in the past (ie mostly everyone here) will not
>> trust your code because it relies on pre-requisites they know they do not
>> have.
>
> That would have been a miscommunication then.  I see arguments coming
> in that suggest embedded solutions, EMC for example, are inherently more
> reliable than a Linux based solution.  Well guess what?  Some of those
> embedded solutions already use Linux.

they aren't arguing that the embedded solutions are more safe becouse they 
don't use linux. they are arguing that they are more safe becouse they 
have different enginnering then normal machines, and it's that engineering 
that makes them safer, not the software.

the reason why battery backed ram on a raid card is safer than a UPS on a 
general purpose machine is becouse the battery backed ram is static ram, 
while the ram in your system is dynamid ram. static ram only needs power 
to retain it's memory, dynamic ram needs a preocessor running to access 
the ram continuously to refresh it.

you see 'battery+ram' in both cases and argue that they are equally safe. 
that just isn't the case.

the raid card can be pulled from one machine and put into another, in some 
cases the ram can be pulled from one card and plugged into another. it can 
sit on a shelf unplugged form anything but the battery for several days. 
this means that unless something physicaly damages the ram and enough 
drives to fail the raid array, the data is safe.

EMC, Netapp, and the other enterprise vendors have special purpose 
hardware to implement this safety. how much special hardware they have 
varies by company and equipment, but they all have some.

David Lang
