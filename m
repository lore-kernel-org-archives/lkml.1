Return-Path: <linux-kernel-owner+w=401wt.eu-S1760475AbYACPsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760475AbYACPsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:48:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759404AbYACPog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:44:36 -0500
Received: from rtr.ca ([76.10.145.34]:2520 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759372AbYACPod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:44:33 -0500
Message-ID: <477D02E0.5040301@rtr.ca>
Date: Thu, 03 Jan 2008 10:44:32 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
Cc: Mark Lord <lkml@rtr.ca>, Allen Martin <AMartin@nvidia.com>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Gabor Gombas <gombasg@sztaki.hu>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Kuan Luo <kluo@nvidia.com>,
       Peer Chen <pchen@nvidia.com>
Subject: Re: sata_nv + ADMA + Samsung disk problem
References: <20070808120804.GB5257@boogie.lpds.sztaki.hu> <20080101164416.GA29574@boogie.lpds.sztaki.hu> <477B0429.7040909@gmail.com> <477B0CFD.1030603@shaw.ca> <F72FA20C31DD4F4C997B91C5B3690A09505577@hqemmail07.nvidia.com> <477BDEA5.8040701@garzik.org> <F72FA20C31DD4F4C997B91C5B3690A0950557D@hqemmail07.nvidia.com> <477C2A99.9010208@shaw.ca> <477C61D3.30009@rtr.ca> <477C6A85.9020607@shaw.ca>
In-Reply-To: <477C6A85.9020607@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Mark Lord wrote:
>> Robert Hancock wrote:
>> ..
>>>  From some of the traces I took previously (posted on LKML as 
>>> "sata_nv ADMA controller lockup investigation" way back in Feb 07), 
>>> what seems to occur is that when the second command is issued very 
>>> rapidly (within less than 20 microseconds, or potentially longer) 
>>> after the previous command's completion, the ADMA status changes from 
>>> 0x500 (STOPPED and IDLE) to 0x400 (just IDLE) as it typically does, 
>>> but then it sticks there, no interrupt is ever raised, and CPB 
>>> response flags remain at 0.
>> ..
>>
>> Assuming that NVidia got their ADMA core logic from Pacific Digital
>> (the inventors), then it may have some of the same bugs as the original.
>>
>> One of those bugs is that the aGO trigger is sampled in a "racey" way,
>> such that it sometimes may miss a recent addition to the ring.
>>
>> The *only* way to guarantee things with the original Pacific Digital core
>> was to (1) always retrigger aGO for a full ring scan with each new 
>> addition,
>> and (2) poll periodically (every half second or so) rather than relying
>> exclusively on the IRQ actually working..
>>
>> Dunno about the NVidia version.
> 
> Theirs works rather differently - the GO bit is there, but there's 
> another append register which is used to tell the controller that a new 
> tag has been added to the CPB list.
..

The PacDigi core uses a "search count" register for that purpose,
but the buggy nature of the core required that it always be set
to "2 * ring_size" to ensure nothing got missed.

Here's some comments from the original ADMA driver.
Maybe something from here might help with the NV stuff, too.

       // There is a chance that the chip will skip over a CPB if a SERVICE interrupt
        // occurs while it's reading the CPB header.  This won't cause us to get
        // stuck anywhere, but it might slow down execution of the new CPB if
        // it has to wait for the next time we hit aGO.  So.. Dxxx/Dxxx suggest
        // that all we need to do is tell the chip to do two passes around the ring
        // from an aGO instead of one pass, so that it will find the "missed" CPB
        // on the second pass.  This isn't as bad as it first looks.
        //
        writew(channel->num_cpbs * 2, &adma_regs->cpb_search_count);

Or again, the NV stuff may be completely different (?).
