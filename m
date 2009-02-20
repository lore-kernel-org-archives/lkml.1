Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbZBTOKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbZBTOKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 09:10:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbZBTOK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 09:10:27 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:62606 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbZBTOK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 09:10:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ldE+KjgS6K2HjAxRFBFIUnyuPQZ1Ahf6+mvVJFQxjAh/4lFDGZQO+rW2+t8u9kqaMu
         M8LWdZk83g9tBF2RkhBkuX2fNiwrdRvqpD/06Nxf5O7LMZCRRMkEfYMYiqrUXT9bjXNJ
         bXt4Xy1iC0Setufm7kB50HZzbxx7uJoBuGkUc=
MIME-Version: 1.0
In-Reply-To: <200902200044.48328.nickpiggin@yahoo.com.au>
References: <m2hc2yulrw.fsf@gmail.com>
	 <38b2ab8a0902190307p214a6928v2f66b8ad5e9564e6@mail.gmail.com>
	 <200902200044.48328.nickpiggin@yahoo.com.au>
Date: Fri, 20 Feb 2009 15:10:24 +0100
Message-ID: <38b2ab8a0902200610i6c91725cjc91adca31042daa9@mail.gmail.com>
Subject: Re: Question regarding concurrent accesses through block device and 
	fs
From: Francis Moreau <francis.moro@gmail.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Thanks a lot for your explanations !

On Thu, Feb 19, 2009 at 2:44 PM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> On Thursday 19 February 2009 22:07:42 Francis Moreau wrote:
>>
>> First it looks like when accessing some blocks through a block device,
>> the same mechanisms are used as when reading a file through a file
>> system: the page cache is used.
>
> Yes. page cache of the block device is also sometimes called buffer cache,
> for historical reasons.

I didn't know this term before.

> This is done for only newly allocated on-disk blocks, (which is what
> buffer_new means, not new in-memory buffers). And it is only there to
> synchronize buffercache access by the filesystem for its metadata, rather
> than trying to make /dev/bdev access coherent with file access.

Well I'm (still) confused by 2 things:

  - the comments of unmap_underlying_metadata() doesn't sound that we're
    dealing with meta data only:

    " ... we don't want any output from any buffer-cache aliases starting ... "

    note the word *any*. But I must admit that I don't understand the whole
    comment.

  - looking at unmap_underlying_metadata(), there's no code to deal with
    meta data buffers. It gets the buffer and unmap it whatever the type of
    data it contains.

But at least the name of this function is now more clear.

>
> Basically what can happen is that a filesystem will have perhaps allocated
> a block for an array of indirect pointers. The filesystem manages this
> via the buffercache and writes a few pointers into it. Then suppose the file
> is truncated and that block becomes unused so it can be freed by the
> filesystem block allocator. And the filesystem may also call bforget to
> prevent the now useless buffer from being written out in future.
>

ok, so now  the buffercache is discarded and its content is either discarded
or is writing back.

> Now suppose a new block required for *file* data, and the filesystem happens
> to reallocate that block. So now we may still have that old buffercache and
> buffer head around, but we also have this new pagecache and buffer head for
> the file that points to the same block (buffer_new will be set on this new
> buffer head, btw, to reflect that it is a newly allocated block).
>

ok

> All fine so far.
>
> Now there is a potential problem because the old buffer can *still be under
> writeback* dating back from when it was still good metadata and before
> bforget was called. That's a problem because the new buffer is expecting
> to be the owner and master of the block and its data.

Now I don't see the problem.

Even if the old meta data is under writeback process, the new buffer can still
be used: since it's new there's no point to do IOs to read its content. If
we need to write it to disk then the IOs will overwrite the old meta
data, there's
no risk that the old meta data overwrite the new data.

What am I missing ?

Thanks
-- 
Francis
