Return-Path: <linux-kernel-owner+w=401wt.eu-S1755946AbZBSNpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbZBSNpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 08:45:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbZBSNpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 08:45:21 -0500
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:47743 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750826AbZBSNpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 08:45:21 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=shhQ+I18ErfFEJYvLghW9X73y9icLfM0GouOy7NduLAMLzKx9pv4EYRz6wa1q3Wb7r6/2UwUxkNQbYGennvSpiUW79cerq3SlxqNUurG+VShBS3dMSDDn2tvivt83dD7dcFBcZibwGk8EYe9JtJngsazqs76g5/aguv8jNP9P74=  ;
X-YMail-OSG: ieDnOaQVM1loFTsAYgrUkwG6DcEA_yoQcsMB1mOearMQnDy10Dr3v5uJd4PzyHQTMR.d10N9p6kFFuEa62MSrqoVq51zsyiSWfevZYROnvoGwOfDmqECd5oeb3nool7jaGejnR0o7yLIOzjn0hykGeeNJSd_sw4Bv_.ifW1AqM2CMJEe2PmFFLmWqleR0Q--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Francis Moreau <francis.moro@gmail.com>
Subject: Re: Question regarding concurrent accesses through block device and fs
Date: Fri, 20 Feb 2009 00:44:47 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <m2hc2yulrw.fsf@gmail.com> <38b2ab8a0902190307p214a6928v2f66b8ad5e9564e6@mail.gmail.com>
In-Reply-To: <38b2ab8a0902190307p214a6928v2f66b8ad5e9564e6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902200044.48328.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 February 2009 22:07:42 Francis Moreau wrote:
> [ Resend to LKLM, hopping to get a wider audience ;) and to Andrew Morton
> since he wrote that part of the code, I think ]
>
> Hello,
>
> I have a question regarding the page cache/buffer heads behaviour when
> some blocks are accessed through a regular file and through the block
> dev hosting this file.
>
> First it looks like when accessing some blocks through a block device,
> the same mechanisms are used as when reading a file through a file
> system: the page cache is used.

Yes. page cache of the block device is also sometimes called buffer cache,
for historical reasons.


> That means that a block could be mapped by several buffers at the same
> time.
>
> I don't see any issues to this (if we agree that the behaviour is undefined
> in that case) but looking at __block_prepare_write(), it seems that we
> don't want this to happen since it does:
>
>        [...]
>        if (buffer_new(bh)) {
>                unmap_underlying_metadata(bh->b_bdev, bh->b_blocknr);
>                [...]
>        }
>
> where unmap_underlying_metadata() unmaps the blockdev buffer
> which maps b_blocknr block.
>
> This code seems to catch only the case where the buffer is new (I don't
> see why only this case is treated).
>
> Also this call seems unneeded if __block_prepare_write() is called
> when writing through the block dev since we already know that the buffer
> doesn't exist (we are here to create it).
>
> I already read the comment of the function unmap_underlying_metadata()
> but I failed to understand it...
>
> Could anybody tell me what is the actual policy ?

This is done for only newly allocated on-disk blocks, (which is what
buffer_new means, not new in-memory buffers). And it is only there to
synchronize buffercache access by the filesystem for its metadata, rather
than trying to make /dev/bdev access coherent with file access.

Basically what can happen is that a filesystem will have perhaps allocated
a block for an array of indirect pointers. The filesystem manages this
via the buffercache and writes a few pointers into it. Then suppose the file
is truncated and that block becomes unused so it can be freed by the
filesystem block allocator. And the filesystem may also call bforget to
prevent the now useless buffer from being written out in future.

Now suppose a new block required for *file* data, and the filesystem happens
to reallocate that block. So now we may still have that old buffercache and
buffer head around, but we also have this new pagecache and buffer head for
the file that points to the same block (buffer_new will be set on this new
buffer head, btw, to reflect that it is a newly allocated block).

All fine so far.

Now there is a potential problem because the old buffer can *still be under
writeback* dating back from when it was still good metadata and before
bforget was called. That's a problem because the new buffer is expecting
to be the owner and master of the block and its data. 

That is what the second paragraph in the comment refers to. I don't actaully
quite know what the problem is that is described in the first paragraph.
Andrew do you know?

