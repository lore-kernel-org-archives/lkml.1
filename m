Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbYALXFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbYALXFS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 18:05:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbYALXFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 18:05:04 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:60474 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbYALXFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 18:05:00 -0500
Date: Sat, 12 Jan 2008 17:04:37 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: PROBLEM REMAINS: [sata_nv ADMA breaks ATAPI] Crash on	accessing
 DVD-RAM
In-reply-to: <1200170117.3656.66.camel@localhost.localdomain>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alexander <aledin@mail.ru>, linux-kernel@vger.kernel.org,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Tejun Heo <htejun@gmail.com>
Message-id: <47894785.2050508@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.krOVfyFmB2aqGjJIoHCLmQxecWc@ifi.uio.no>
 <478702C7.80401@shaw.ca> <47887982.6050805@mail.ru> <47891426.1020604@shaw.ca>
 <1200170117.3656.66.camel@localhost.localdomain>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
>>> With mem<=4098M or sata_nv.adma=0 it still mounts and works ok.
>> As I wrote, it would appear that somehow the blk_queue_bounce_limit 
>> setting that the driver has made is not being respected and the block 
>> layer is still trying to feed it addresses over 4GB. Any ideas anyone?
> 
> Actually, I'd be very sceptical that the blk_queue_bounce_limit isn't
> working as advertised; there'd be a large number of failures if it were
> not.
> 
> However, the "as advertised" part doesn't seem to be generally well
> understood.  The point being that block commands are only bounced if
> they come from the filesystem or the user, not if they're generated
> directly inside the kernel.  Since the fault occurs before mount, it's
> suggestive of the latter.
> 
> A long time ago, GFP_KERNEL allocations meant that the memory allocated
> was physically under 4GB.  Then x86_64 (and before it ia64) wanted to
> break this.  So they introduced a new flag:  GFP_DMA32 that behaved like
> the old GFP_KERNEL and then changed GFP_KERNEL on their architectures to
> return memory from anywhere.  I'd strongly suggest some piece of kernel
> memory was allocated for a transfer buffer without GFP_DMA32 and then
> passed in to the driver.  Unfortunately, that could be anywhere inside
> cdrom or sr.  Knowing what the actual command is might help ... some of
> the distinctive MMC media ones only have a single source.

Just to give some background on what sata_nv is trying to do:

There are two sets of static DMA memory allocations that sata_nv does, 
the legacy ATA PRD and padding buffer which need to be in the lower 4GB, 
and the ADMA APRD and CPB areas which can be anywhere in 64-bit memory. 
With this patch, this is done by setting a 32-bit DMA mask before 
allocating the legacy areas and setting a 64-bit DMA mask before 
allocating the ADMA areas. Previously the driver just set a 64-bit mask 
before the legacy PRD got allocated so it could end up above 4GB, in 
which case legacy DMA couldn't possibly work. That part of the problem 
appears to be successfully fixed by the patch in question.

There's a further problem with runtime DMA mapping, however. Normally 
when ADMA is enabled the controller can reach anywhere in 64-bit memory. 
However, if an ATAPI device is connected, since ADMA doesn't work with 
ATAPI commands we have to switch it off on that port and use legacy DMA, 
which is limited to 32-bit. This is where the blk_queue_bounce_limit 
call comes in, it's trying to make the block layer bounce requests above 
4GB when legacy DMA is in use.

I don't think the problem is that there's some buffer which is getting 
allocated above 4GB and never bounced, since the problem goes away if 
ADMA is disabled entirely and the DMA mask remains 32-bit always. My 
guess is something is basing its decision on whether to bounce or not on 
the device DMA mask. That can't possibly work properly for sata_nv since 
the same PCI device has 2 ports, one of which can be in ADMA mode and 
64-bit capable and the other can be in legacy mode and only 32-bit capable.

Tejun, I believe you had a patch that was printing warnings when libata 
tried to program a legacy PRD with an address over 4GB. Could we change 
that to WARN_ON and get someone experiencing this to try it and
see what the stack trace points to?
