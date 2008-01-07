Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbYAGEM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbYAGEM3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 23:12:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbYAGEMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 23:12:19 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:31677 "EHLO
	pd4mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbYAGEMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 23:12:17 -0500
Date: Sun, 06 Jan 2008 22:11:28 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Believed resolved: SATA kern-buffRd read slow: based on promise
 driver bug
In-reply-to: <fa.leUU92dZvqrjftqKQxk4q8qTM64@ifi.uio.no>
To: Linda Walsh <lkml@tlinx.org>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Message-id: <4781A670.3000507@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.o9uy6Qaq3PtHs2Z9lAKGUKvD85I@ifi.uio.no>
 <fa.MP5rgMp4TS2+Cfemd/uFOQOuquQ@ifi.uio.no>
 <fa.K6LghyRzngM8LZiR3Md+1999xh4@ifi.uio.no>
 <fa.7jD9zpCEjhqr9wMenw8PLx0AHyY@ifi.uio.no>
 <fa.vg33sDPLrdDUNnRMIgKMOA12eKs@ifi.uio.no>
 <fa.leUU92dZvqrjftqKQxk4q8qTM64@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linda Walsh wrote:
> Mikael Pettersson wrote:
>> Linda Walsh writes:
>>  > Mikael Pettersson wrote:
>>  > > Linda Walsh writes:
>>  > >  > > Linda Walsh wrote:
>>  > >  > >>>> read rate began falling; (.25 - .3);  > >  > more 
>> importantly; a chronic error message associated
>>  > >  > with drive may be causing some or all of the problem(s):
>>  > >  > ---
>>  > >  > ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
>>  > >  > ata1.00: port_status 0x20080000
>>  > >  > ata1.00: cmd c8/00:10:30:06:03/00:00:00:00:00/e0 tag 0 cdb 0x0 
>> data 8192 in
>>  > >  >          res 50/00:00:3f:06:03/00:00:00:00:00/e0 Emask 0x2 
>> (HSM violation)
>>  > >  > ata1: limiting SATA link speed to 1.5 Gbps
>>  > >
>>  > > Looks like the Promise ASIC SG bug. Apply
>>  > > 
>> <http://user.it.uu.se/~mikpe/linux/patches/sata_promise/patch-sata_promise-1-asic-sg-bug-fix-v3-2.6.23> 
>>
>>  > > and let us know if things improve.
>>  > > /Mikael
>>  > ---
>>  >     Yep!  Hope that's making it into a patch soon or, at least 2.6.24.
>>  >     Kernel buffered
>> Good to hear that it solved this problem.
>> The patch is in 2.6.24-rc2 and newer kernels, and will be sent
>> to -stable for the 2.6.23 and 2.6.22 series.
>>   
> ---
>    Will 'likely' wait till -stable since I use the machine as a 'server'
> for just about any/everything that needs "serving" or "proxy" services.
>>  >  That and I'd like to find out why TCQ/NCQ doesn't work with the 
>> Seagate drives --
>>
>> The driver doesn't yet support NCQ.
> ----
>    Is 'main' diff between NCQ/TCQ that TCQ can re-arrange 'write'
> priority under driver control, whereas NCQ is mostly a FIFO queue?

First off one has to distinguish between ATA TCQ and SCSI TCQ. ATA TCQ 
is essentially abandoned, very few drives and fewer still controllers 
and matching drivers ever supported it.

SCSI TCQ has "head of queue", "ordered" and "simple" queueing modes. ATA 
NCQ effectively only has "simple" where the drive always decides what 
order to service the requests in. There is a FUA mode, which tells the 
drive that the command (normally a write) has to access the physical 
media before reporting completion.

> 
>    On a Journal'ed file system, isn't "write-order" control required
> for integrity?  That would seem to imply TCQ could be used, but
> NCQ doesn't seem to offer much benefit, since the higher level
> kernel drivers usually have a "larger picture" of sectors that need
> to be written.  The only advantage I can see for NCQ drives might

There are cases where writes need to complete in a specific order. This 
can be done either by using FUA bits (though libata doesn't do this by 
default currently) or by issuing cache flushes before and after certain 
commands.

> be that the kernel may not know the drive's internal physical
> structure nor where the disk is in its current revolution.  That could
> allow drive write re-ordering where based on the exact-current state
> of the drive that the kernel might not have access to, but it seems
> this would be a minor benefit -- and, depending on firmware,
> possibly higher overhead in command processing?

That's a big part of it. The kernel doesn't necessarily know what 
sectors will be the fastest to access at any given time whereas the 
drive can.

Also, NCQ has some other improvements that are independent of actually 
queueing commands - for instance, because the drive controls the DMA 
data transfer, it can transfer the data for one request in an 
out-of-order fashion instead of having to transfer to the host strictly 
from beginning to end as in traditional ATA.

> 
> Am trying to differentiate NCQ/TCQ and SAS v. SCSI benefits.
> It seems both support (SAS & SATA) some type of port-multiplier/
> multiplexor/ option to allow more disks/port.
> 
> However, (please correct?) SATA uses a hub type architecture while
> SAS uses a switch architecture.  My experience with network hubs vs.
> switches is that network hubs can be much slower if there is
> communication contention.  Is the word 'hub' being used in the
> "shared-communication media sense", or is someone using the term
> 'hub' as a [sic] replacement for a 'switch'?

I believe that they're essentially the same in that regard, though 
someone can correct me if I'm wrong..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

