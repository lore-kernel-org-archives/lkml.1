Return-Path: <linux-kernel-owner+w=401wt.eu-S1758431AbZCUO4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758431AbZCUO4V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 10:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754947AbZCUO4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 10:56:07 -0400
Received: from rtr.ca ([76.10.145.34]:42094 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754564AbZCUO4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 10:56:05 -0400
Message-ID: <49C4FFFB.5000601@rtr.ca>
Date: Sat, 21 Mar 2009 10:55:55 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mark Lord <liml@rtr.ca>, Norman Diamond <n0diamond@yahoo.co.jp>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Overagressive failing of disk reads, both LIBATA and IDE
References: <F79C774361EF45A6A68BC08F8621E406@DIAMOND8600>	 <49C30E67.4060702@rtr.ca> <1237645333.4600.9.camel@localhost.localdomain>
In-Reply-To: <1237645333.4600.9.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Thu, 2009-03-19 at 23:32 -0400, Mark Lord wrote:
..
>> Allow SCSI to continue with the remaining blocks of a request
>> after encountering a media error.  Otherwise, it may just fail
>> the entire request, even though some blocks were fine and needed
>> by a completely different process than the one that wanted the bad block(s).
>>
>> Signed-off-by: Mark Lord <mlord@pobox.com>
>>
>> --- linux-2.6.16.60-0.6/drivers/scsi/scsi_lib.c	2008-03-10 13:46:03.000000000 -0400
>> +++ linux/drivers/scsi/scsi_lib.c	2008-03-21 11:54:09.000000000 -0400
>> @@ -888,6 +888,12 @@
>>  	 */
>>  	if (sense_valid && !sense_deferred) {
>>  		switch (sshdr.sense_key) {
>> +		case MEDIUM_ERROR:
>> +		/* Bad sector.  Fail it, and then continue the rest of the request. */
>> +		if (scsi_end_request(cmd, 0, cmd->device->sector_size, 1) == NULL) {
>> +			cmd->retries = 0;       // go around again..
>> +			return;
>> +		}
> 
> But we've been over this.  You can't apply something like this because
> it ignores retries and chunks up the request a sector at a time.  For
> the enterprise that can increase failure time from a few seconds to
> hours for 512k transfers.
> 
> Using the disk supplied data about where the error occurred (provided
> the disk returns it) eliminates all the readahead problems like the one
> above.  Perhaps just turning of readahead for disks that don't supply
> error location information would be a reasonable workaround?
..

The patch *does* use the disk supplied data about the error,
and returns success for sectors up to that point.  Where it differs
from mainline SCSI, is that it then continues attempting the remaining
2000 sectors (or whatever) of the request, hoping that not all of
them are bad.

It's not perfect, and likely no longer applies/works cleanly on the
latest kernels.  And perhaps it really ought to fail a "block" rather
than a "sector" at a time as it seeks clean media after the fault.

I think it could be even more clever, using a binary search or something
on the remaining chunks, so that it takes less time to skip over a huge
stretch of sequential bad sectors (scratch on media).  That would probably
be best all around.

Cheers
