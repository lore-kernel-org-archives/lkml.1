Return-Path: <linux-kernel-owner+w=401wt.eu-S1760625AbXE1EtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760625AbXE1EtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 00:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754326AbXE1Esv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 00:48:51 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35703 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754260AbXE1Esu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 00:48:50 -0400
Date: Mon, 28 May 2007 14:48:45 +1000
From: Timothy Shimmin <tes@sgi.com>
To: David Chinner <dgc@sgi.com>, Neil Brown <neilb@suse.de>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, linux-raid@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Phillip Susi <psusi@cfl.rr.com>,
       Stefan Bader <Stefan.Bader@de.ibm.com>,
       Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
Message-ID: <980E945058C35F7E3117FE88@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <20070528024559.GA85884050@sgi.com>
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown>
 <20070528024559.GA85884050@sgi.com>
X-Mailer: Mulberry/4.0.8 (Mac OS X)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

--On 28 May 2007 12:45:59 PM +1000 David Chinner <dgc@sgi.com> wrote:

> On Mon, May 28, 2007 at 11:30:32AM +1000, Neil Brown wrote:
>>
>> Thanks everyone for your input.  There was some very valuable
>> observations in the various emails.
>> I will try to pull most of it together and bring out what seem to be
>> the important points.
>>
>>
>> 1/ A BIO_RW_BARRIER request should never fail with -EOPNOTSUP.
>
> Sounds good to me, but how do we test to see if the underlying
> device supports barriers? Do we just assume that they do and
> only change behaviour if -o nobarrier is specified in the mount
> options?
>
I would assume so.
Then when the block layer finds that they aren't supported and does
non-barrier ones, then it could report a message.
We, xfs, I guess can't take much other course of action
and we aint doing much now other than not requesting them
anymore and printing an error message.

>> 2/ Maybe barriers provide stronger semantics than are required.
>>
>>  All write requests are synchronised around a barrier write.  This is
>>  often more than is required and apparently can cause a measurable
>>  slowdown.
>>
>>  Also the FUA for the actual commit write might not be needed.  It is
>>  important for consistency that the preceding writes are in safe
>>  storage before the commit write, but it is not so important that the
>>  commit write is immediately safe on storage.  That isn't needed until
>>  a 'sync' or 'fsync' or similar.
>
> The use of barriers in XFS assumes the commit write to be on stable
> storage before it returns.  One of the ordering guarantees that we
> need is that the transaction (commit write) is on disk before the
> metadata block containing the change in the transaction is written
> to disk and the current barrier behaviour gives us that.
>
Yep, and that one is what we want the FUA for -
for the write into the log.

I'm taking it that the FUA write will just guarantee that that
particular write has made it to disk on i/o completion
(and no write cache flush is done).

The other XFS constraint is that we know when the metadata hits the disk
so that we can move the tail of the log.
And that is what we are effectively getting from the pre-write-flush
part of the barrier. It would ensure that any metadata not yet to disk would
be on disk before we overwrite the tail of the log.
If we could determine cases when we don't have to worry about overwriting
the tail of the log, then it would be good if we could
just do FUA writes for contraint 1 above. Is that possible?

--Tim


