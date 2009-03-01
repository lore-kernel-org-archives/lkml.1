Return-Path: <linux-kernel-owner+w=401wt.eu-S1757263AbZCAPdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263AbZCAPdg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 10:33:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755110AbZCAPd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 10:33:27 -0500
Received: from smtp116.mail.mud.yahoo.com ([209.191.84.165]:36838 "HELO
	smtp116.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753601AbZCAPd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 10:33:26 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=JaZm35ERwV07UAMzUpGFxlKS1UhWGODOp3sf99cyh2NB8jMMsZOX5NoYek+5aFqbsu2JrOmmYI05vfhHgz/W9MHLTaHJXZjofTdk7wSv/1ULQqjEa2+yDBfFh/93L6e2ccYKmrVzcxy0UzrvPVsbpb/4HCmgDuFLgxUytbRwr9Y=  ;
X-YMail-OSG: dXsndPIVM1kzKuo4bIZRUznLAIyKQDsZSB_NkndWmmXSOvTEHWRth1MiyMvXOI6WqkE78OREqofWVR7fSNPFFdt9sxtqJaP9221_JBdGaLMeOerHKUZ.bU0s_RqHm2QmszCWuR_7TJsFkhQsgP1sKeUGeazo5swPvCWn5R.WDf6MbKbGgGbQmQIpAzoT_LXB..ma5fhtl6pTtwHP.qo9GJBha4E4qcxA65g-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Francis Moreau <francis.moro@gmail.com>
Subject: Re: Question regarding concurrent accesses through block device and fs
Date: Mon, 2 Mar 2009 02:32:48 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <m2hc2yulrw.fsf@gmail.com> <200902231458.32911.nickpiggin@yahoo.com.au> <m2ab85nw28.fsf@gmail.com>
In-Reply-To: <m2ab85nw28.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903020232.48311.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 March 2009 01:42:55 Francis Moreau wrote:
> [ Sorry for being long to answer but I was off, I'm slow and there are
>   a lot of complex code to dig out ! ]
>
> Nick Piggin <nickpiggin@yahoo.com.au> writes:
> > On Saturday 21 February 2009 01:10:24 Francis Moreau wrote:
>
> [...]
>
> >>   - looking at unmap_underlying_metadata(), there's no code to deal with
> >>     meta data buffers. It gets the buffer and unmap it whatever the type
> >> of data it contains.
> >
> > That's why I say it only really works for buffer cache used by the same
> > filesystem that is now known to be unused.
>
> hum, I still don't know what you mean by this, sorry to be slow.

OK, the "buffercache", the cache of block device contents, is normally
thought of as metadata when it is being used by the filesystem (eg.
usually via bread() etc), or data when it is being read/written from
userspace via /dev/<blockdevice>.

In the former case, the buffer.c/filesystem code together know when a
metadata buffer is unused (because the filesystem has deallocated it),
so unmap_underlying_metadata will work there.

And it is insane to have a mounted filesystem and have userspace working
on the same block device, so unmap_underlying_metadata doesn't have to
care about that case. (IIRC some filesystem tools can do this, but there
are obviously a lot of tricks to it)


> >> What am I missing ?
> >
> > That we might complete the write of the new buffer before the
> > old buffer is finished writing out?
>
> Ah yes actually I realize that I don't know where and when the inode
> blocks are effectively written to the disk !
>
> It seems that write_inode(), called after data are commited to the
> disk, only marks the inode buffers as dirty but it performs no IO (at
> least it looks so for ext2 when its 'do_sync' parameter is 0 which is
> the case when this method is called by write_inode()).
>
> Could you enlight me one more time ?

Depends on the filesystem. Many do just use the buffercache as a
writeback cache for their metadata, and are happy to just let the
dirty page flushers write it out when it suits them (or when there
are explicit sync instructions given).

Most of the time, these filesystems don't really know or care when
exactly their metadata is under writeback.

