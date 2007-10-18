Return-Path: <linux-kernel-owner+w=401wt.eu-S1763667AbXJRBIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763667AbXJRBIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 21:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758972AbXJRBHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 21:07:37 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:20688 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762996AbXJRBHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 21:07:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=CoHk6EwniP4GZ5O+lKUareheZG7WVeEJNeXeehaTWakNcr8jndTeg6/lSqUlqEyeJYLxXAiGf9HIhZOq0HP7V+GEqaECVtQYTG18qomSxEwgbL2JQdrz9g5u1MF90nS8iNEl1JcSGLgb2LZYfdaNr2eQb94SfuDnsKx3difxX9U=  ;
X-YMail-OSG: WNYLDRoVM1my5wZqPPxNnKmi8SJb2ShNJYxS.5apKNfTBmGrkrRI5eqP09QgWnbd.y1oUI2WWQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch][rfc] rewrite ramdisk
Date: Thu, 18 Oct 2007 11:06:56 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
References: <200710151028.34407.borntraeger@de.ibm.com> <200710172249.13877.nickpiggin@yahoo.com.au> <m1k5pleg0w.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1k5pleg0w.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710181106.57317.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 October 2007 04:45, Eric W. Biederman wrote:
> At this point my concern is what makes a clean code change in the
> kernel.  Because user space can currently play with buffer_heads
> by way of the block device and cause lots of havoc (see the recent

Well if userspace is writing to the filesystem metadata via the
blockdevice while it is running... that's the definition of havoc,
isn't it? ;) Whether or not the writes are going via a unified
metadata/blockdev cache or separate ones.

You really just have to not do that.

The actual reiserfs problem being seen is not because of userspace
going silly, but because ramdisk is hijacking the dirty bits.


> If that change is made then it happens that the current ramdisk
> would not need to worry about buffer heads and all of that
> nastiness and could just lock pages in the page cache.  It would not
> be quite as good for testing filesystems but retaining the existing
> characteristics would be simple.

No, it wouldn't. Because if you're proposing to split up the buffer
cache and the metadata cache, then you're back to a 2 cache
solution which is basically has the memory characteristics of my
proposal while still being horribly incestuous with the pagecache.


> After having looked a bit deeper the buffer_heads and the block
> devices don't look as intricately tied up as I had first thought.
> We still have the nasty case of:
> 	if (buffer_new(bh))
> 		unmap_underlying_metadata(bh->b_bdev, bh->b_blocknr);
> That I don't know how it got merged.  But otherwise the caches
> are fully separate.

Well its needed because some filesystems forget about their old
metadata. It's not really there to solve aliasing with the blockdev
pagecache.


> So currently it looks to me like there are two big things that will
> clean up that part of the code a lot:
> - moving the metadata buffer_heads to a magic filesystem inode.
> - Using a simpler non-buffer_head returning version of get_block
>   so we can make simple generic code for generating BIOs.

Although this is going off the track of the ramdisk problem. For
that we should just do the rewrite.
