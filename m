Return-Path: <linux-kernel-owner+w=401wt.eu-S1762332AbYA3Q4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762332AbYA3Q4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 11:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754196AbYA3Q4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 11:56:23 -0500
Received: from rtr.ca ([76.10.145.34]:4334 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbYA3Q4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 11:56:20 -0500
Message-ID: <47A0AC33.1060504@rtr.ca>
Date: Wed, 30 Jan 2008 11:56:19 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
Cc: ltuikov@yahoo.com, linux-arch@vger.kernel.org,
       ide <linux-ide@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: DMA mapping on SCSI device?
References: <896139.88121.qm@web31812.mail.mud.yahoo.com> <479FDA52.8050204@shaw.ca>
In-Reply-To: <479FDA52.8050204@shaw.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Luben Tuikov wrote:
>> --- On Mon, 1/28/08, Robert Hancock <hancockr@shaw.ca> wrote:
>>> The trick is that if an ATAPI device is connected, we (as
>>> far as I'm aware) can't use ADMA mode, so we have to switch that
>>> port into legacy mode.
>>
>> Can you double check this with the HW architect of the
>> HW DMA engine of the ASIC?
> 
> Will do so. However, previous statements from NVIDIA fairly clearly 
> indicate that this is the case.
> 
>>
>>> This means it's only capable of 32-bit DMA.
>>> However the other port on the controller may be connected to a hard 
>>> drive and therefore still capable of 64-bit DMA.
>>
>> If this is indeed the case as you've presented it here,
>> it sounds like a HW shortcoming.  I cannot see how the device
>> type (or protocol) dictate how the DMA engine operates.
>> They live in two different domains.
> 
> Well, there is an indirect link. The ADMA interface (which supports 
> 64-bit DMA) cannot be used to issue ATAPI commands, so if an ATAPI 
> device is connected we have to go to legacy mode, which supports only 
> 32-bit DMA.
> 
> I'm not sure why ADMA mode doesn't support ATAPI. The only reason I can 
> think of is that there's issues since ATAPI commands can potentially be 
> of unpredictable transfer size. The "real" ADMA spec that the NVIDIA 
> implementation is loosely based on does have some special "ignore 
> excess" controls that don't seem to be in the NVIDIA version (or at 
> least not to the knowledge I have on this hardware).
..

The original Pacific Digital ADMA cores *do* support most ATAPI commands
in ADMA mode, including READ_CD, READ_10, etc..  With the caveat that if
DSC completion state is required, the driver has to drop out of ADMA
and poll for it after the ADMA command completes.

Commands which were not ADMA compatible (eg. MODE_SENSE, TEST_UNIT_READY, ..)
were simply handled with PIO (in the driver) rather than any form of DMA,
which is okay because those commands are relatively infrequent.

Note that Pacific Digital "officially" said "no ATAPI" for the ADMA design,
but I implemented it regardless (for Linux) and it worked rather well.
We could burn DVDs and back-up to tape simultaneously, with the burner
and the tape unit sharing a single IDE cable/channel.

Cheers
