Return-Path: <linux-kernel-owner+w=401wt.eu-S1761715AbZCaGKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761715AbZCaGKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 02:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbZCaGKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 02:10:04 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:33096 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbZCaGKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 02:10:01 -0400
Message-ID: <49D1B3B7.9000109@oss.ntt.co.jp>
Date: Tue, 31 Mar 2009 15:09:59 +0900
From: =?windows-1252?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       chris.mason@oracle.com, david@fromorbit.com, tj@kernel.org
Subject: Re: [PATCH 1/7] block: Add block_flush_device()
References: <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49D0B535.2010106@oss.ntt.co.jp> <49D0B687.1030407@oss.ntt.co.jp> <200903301707.46212.bzolnier@gmail.com>
In-Reply-To: <200903301707.46212.bzolnier@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> On Monday 30 March 2009, Fernando Luis Vázquez Cao wrote:
>> This patch adds a helper function that should be used by filesystems that need
>> to flush the underlying block device on fsync()/fdatasync().
>>
>> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
>> ---
>>
>> diff -urNp linux-2.6.29-orig/fs/buffer.c linux-2.6.29/fs/buffer.c
>> --- linux-2.6.29-orig/fs/buffer.c	2009-03-24 08:12:14.000000000 +0900
>> +++ linux-2.6.29/fs/buffer.c	2009-03-30 15:27:04.000000000 +0900
>> @@ -165,6 +165,17 @@ void end_buffer_write_sync(struct buffer
>>   	put_bh(bh);
>>   }
>>
>> +/* Issue flush of write caches on the block device */
>> +int block_flush_device(struct block_device *bdev)
> 
> I don't consider this an improvement over using blkdev_issue_flush().

The reason I used a wrapper is that I did not like the semantics provided
by blkdev_issue_flush(). On the one hand, I did not want to pass -EOPNOTSUPP
to filesystems (it is not an error filesystems should care about). On the
other hand it is weird that some filesystems use blkdev_issue_flush() when
they want emit a barrier. blkdev_issue_flush() happens to be implemented
as an empty (block layer) barrier, but I think that is an implementation
detail filesystems should not neet to know about. Indeed I am working on a
patch that implements blkdev_issue_empty_barrier(), so that we can optimize
fsync() flushes and filesystem-originated barriers independently in the block
layer.

Judging from your comments below, it seems we are in the same page regarding
this issue.

Again, thank you for you feedback!

- Fernando

>> +{
>> +	int ret = 0;
>> +
>> +	ret = blkdev_issue_flush(bdev, NULL);
> 
> The problem lies in using NULL for error_sector argument which shows
> a subtle deficiency of the current implementation/usage of barriers
> based on a write cache flushing.
> 
> I intend to document the issue with adding the FIXME to the current
> users of blkdev_issue_flush() so the problem is at least known and not
> forgotten (fixing it would require some work from both block and fs
> sides and unfortunately there wasn't even a willingness to discuss
> possible solutions few years back when the original code was added).
> 
> Thanks,
> Bart

