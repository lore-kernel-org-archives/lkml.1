Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbYGIVa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbYGIVa6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 17:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbYGIVav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 17:30:51 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:46697 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750881AbYGIVau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:30:50 -0400
Date: Wed, 9 Jul 2008 17:30:48 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jan Willem van den Brand <janwillem.dev@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] ext3/jbd, kernel 2.6.13, make ext3 mountable as ext2
	when journal is empty.
Message-ID: <20080709213048.GC8517@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jan Willem van den Brand <janwillem.dev@googlemail.com>,
	linux-kernel@vger.kernel.org
References: <c56f29cb0807090821x74d0652ekc3ae4bb5725df76c@mail.gmail.com> <c56f29cb0807090824k727b0da7se1a019394cdbeea7@mail.gmail.com> <20080709162715.GC11797@mit.edu> <c56f29cb0807091404u29acc1d7nd24071c74f33e060@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c56f29cb0807091404u29acc1d7nd24071c74f33e060@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 11:04:28PM +0200, Jan Willem van den Brand wrote:
> First of all, I totally agree that this should never be default. The
> patch is usefull for us because the SD-card with ext3 file system is
> (possibly unsafely) pulled out of our TomTom device (which is built
> into a car) and then inserted in a Windows PC which only supports
> ext2. We are also considering ext3 on Windows or running e2fsck to
> replay the journal and then continue as ext2. But for now we are
> accessing the file system as ext2.

Ah, that was the missing piece.  You have an ext2-only driver under
Windows, and the SD card has to be usable there.  It makes *much* more
sense now.  :-)

I'll note that the code to run the journal is available in userspace,
and while I didn't originally write it so I can only offer it to you
under GPL, it wouldn't be that hard to make it work under Windows.  At
various times I've taken patches to make parts of e2fsprogs work under
Windows.  (In fact, the original version of resize2fs was paid for by
the folks who make PartitionMagic program, and helped pay for the down
payment on my house.  :-) Check out lib/ext2fs/dosio.c in the
e2fsprogs sources.  I don't think anyone has tried building e2fsprogs
on a Windows/Dos environment in quite some time, so I'm sure some
patches will be necessary, but it maybe quite a bit easier than you
think.  (As part of the PartitionMagic contract I also made parts of
e2fsck and mke2fs work on Windows as well, although that was over ten
years ago by now.)

That being said, I have to ask the question --- if the goal is Windows
compatibility, why aren't you using FAT?  Is the performance benefit
critical for your application?  Or do you need a POSIX-compliant
filesystem?

> The amount of writing is indeed limited. We actually considered
> unmounting and then mounting again but dropped that idea because we do
> not want to close files that are opened for reading. I thought that
> remounting ro did not flush the journal and reset the INCOMPAT_RECOVER
> flag. I will experiment with remounting, thanks!

Yes, remounting read/only will flush the journal and clear the
INCOMPAT_RECOVER bit.

							- Ted
