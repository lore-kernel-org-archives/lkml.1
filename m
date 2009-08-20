Return-Path: <linux-kernel-owner+w=401wt.eu-S1754771AbZHTO64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbZHTO64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 10:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754693AbZHTO64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 10:58:56 -0400
Received: from smtp.infotech.no ([82.134.31.41]:44239 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676AbZHTO6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 10:58:54 -0400
Message-ID: <4A8D64A5.9060003@interlog.com>
Date: Thu, 20 Aug 2009 10:58:45 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Ric Wheeler <rwheeler@redhat.com>
CC: Mark Lord <liml@rtr.ca>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, xfs@oss.sgi.com,
       linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Neil Brown <neilb@suse.de>
Subject: Re: [PATCH, RFC] xfs: batched discard support
References: <20090816004705.GA7347@infradead.org> <20090819203916.GA25296@elte.hu> <4A8CA956.2060406@rtr.ca> <4A8D5442.1000302@redhat.com>
In-Reply-To: <4A8D5442.1000302@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ric Wheeler wrote:
> On 08/19/2009 09:39 PM, Mark Lord wrote:
>> [resending, after fixing the Cc: list; somebody trimmed it earlier]
>>
>> Jamie Lokier wrote:
>> ..
>>> I don't remember - does TRIM guarantee the blocks read zeros afterwards?
>> ..
>>
>> No, it doesn't.
>>
>> A drive can optionally support "deterministic TRIM", whereby it will 
>> return
>> consistent data for any given trimmed sector afterwards, but that 
>> doesn't mean zeros.
>>
>> -ml
> 
> Note that returning consistent data is critical for devices that are 
> used in a RAID group since you will need each RAID block that is used to 
> compute the parity to continue to return the same data until you 
> overwrite it with new data :-)
> 
> If we have a device that does not support this (or is misconfigured not 
> to do this), we should not use those devices in an MD group & do discard 
> against it...

A closer reading of d2015r2-ATAATAPI_Command_Set_-_2_ACS-2.pdf
section 7.10.3.2 (latest ACS-2 draft from www.t13.org) shows
that there are 3 possible variants for data read from a logical
block that has been trimmed (or "unmapped"):
    a) indeterminate
    b) determinate
    c) determinate, return all zeroes

In the case of b) the same data is returned for each
subsequent read. And that data must not be something
that has previously be written to some other LBA!

In the case of SCSI (sbc3r19.pdf) case b) is not
supported (very sensibly IMO).


Another difference I noticed between SCSI and ATA
drafts is with the SECURITY ERASE UNIT command which
is somewhat similar to the SCSI FORMAT UNIT command
(which includes a security erase option). The ATA
draft says that all blocks are determinate ("mapped"
in the SCSI state model) after a SECURITY ERASE UNIT.
The SCSI draft says that all logical blocks may be
unmapped after FORMAT UNIT.

Doug Gilbert
