Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbZBWD7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbZBWD7c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 22:59:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZBWD7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 22:59:22 -0500
Received: from smtp112.mail.mud.yahoo.com ([209.191.84.65]:41292 "HELO
	smtp112.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751104AbZBWD7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 22:59:21 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=JiikZAgLRIu0g7rl7Bbrte5eQGba+CtcQOzSrJ6ezJGN/7+8uxEZsZXDQDQFzo2M4psB//v28hLRZuq2yRzJeLegiJ8rPp5jipgWLqwOkjcP+bBskb2jGCSiq620Dy0X0SNgIHsebZ8NDzqLtbGOIx9bwfVslFUDsTYs/DmlXYo=  ;
X-YMail-OSG: OX2kFKAVM1nUQMP6PVC60mSJGubkhS84q4aTApPPgplfHdMUVsxIEFalLrfMCW45NGtl.lYezXCDza5.51xxlHVb_tunsfhK9V2rmnHTnBF9Z_xAKwCv6xJ3zVyeHVZZgVfvMxKx5bXNcNXbI60gmVWdds.4zRJSu0GTtP0WttFX7yGOvrXm4hBl5MdL21LhVClBCq3GRxnIcqu_dO5knIhnqSBpzVK5xAw-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Francis Moreau <francis.moro@gmail.com>
Subject: Re: Question regarding concurrent accesses through block device and fs
Date: Mon, 23 Feb 2009 14:58:32 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <m2hc2yulrw.fsf@gmail.com> <200902200044.48328.nickpiggin@yahoo.com.au> <38b2ab8a0902200610i6c91725cjc91adca31042daa9@mail.gmail.com>
In-Reply-To: <38b2ab8a0902200610i6c91725cjc91adca31042daa9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902231458.32911.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 February 2009 01:10:24 Francis Moreau wrote:
> On Thu, Feb 19, 2009 at 2:44 PM, Nick Piggin <nickpiggin@yahoo.com.au> 
> > This is done for only newly allocated on-disk blocks, (which is what
> > buffer_new means, not new in-memory buffers). And it is only there to
> > synchronize buffercache access by the filesystem for its metadata, rather
> > than trying to make /dev/bdev access coherent with file access.
>
> Well I'm (still) confused by 2 things:
>
>   - the comments of unmap_underlying_metadata() doesn't sound that we're
>     dealing with meta data only:
>
>     " ... we don't want any output from any buffer-cache aliases starting
> ... "
>
>     note the word *any*. But I must admit that I don't understand the whole
>     comment.

Well buffer cache is (almost) always metadata from the filesystem pov. The
comment *could* be talking about access to /dev/bdev, but in that case the
code is doing the wrong thing WRT coherency anyway (clearing dirty bit), so
I don't see how it could be talking about that.


>   - looking at unmap_underlying_metadata(), there's no code to deal with
>     meta data buffers. It gets the buffer and unmap it whatever the type of
>     data it contains.

That's why I say it only really works for buffer cache used by the same
filesystem that is now known to be unused.


> But at least the name of this function is now more clear.
>
> > Basically what can happen is that a filesystem will have perhaps
> > allocated a block for an array of indirect pointers. The filesystem
> > manages this via the buffercache and writes a few pointers into it. Then
> > suppose the file is truncated and that block becomes unused so it can be
> > freed by the filesystem block allocator. And the filesystem may also call
> > bforget to prevent the now useless buffer from being written out in
> > future.
>
> ok, so now  the buffercache is discarded and its content is either
> discarded or is writing back.
>
> > Now suppose a new block required for *file* data, and the filesystem
> > happens to reallocate that block. So now we may still have that old
> > buffercache and buffer head around, but we also have this new pagecache
> > and buffer head for the file that points to the same block (buffer_new
> > will be set on this new buffer head, btw, to reflect that it is a newly
> > allocated block).
>
> ok
>
> > All fine so far.
> >
> > Now there is a potential problem because the old buffer can *still be
> > under writeback* dating back from when it was still good metadata and
> > before bforget was called. That's a problem because the new buffer is
> > expecting to be the owner and master of the block and its data.
>
> Now I don't see the problem.
>
> Even if the old meta data is under writeback process, the new buffer can
> still be used: since it's new there's no point to do IOs to read its
> content. If we need to write it to disk then the IOs will overwrite the old
> meta data, there's
> no risk that the old meta data overwrite the new data.
>
> What am I missing ?

That we might complete the write of the new buffer before the
old buffer is finished writing out?

Or, I suppose it also covers filesystems that do not always
discard old buffers with bforget, so they don't have dirty
bit cleared (but I don't know 100% sure if this is considered a
filesystem bug or not -- but at least unmap_underlying_metadata
protects against it).

