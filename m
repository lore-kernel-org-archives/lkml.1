Return-Path: <linux-kernel-owner+w=401wt.eu-S1751353AbYAMLGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbYAMLGn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 06:06:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbYAMLGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 06:06:32 -0500
Received: from [212.12.190.216] ([212.12.190.216]:35753 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752108AbYAMLGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 06:06:30 -0500
From: Al Boldi <a1426z@gawab.com>
To: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [RFD] Incremental fsck
Date: Sun, 13 Jan 2008 14:05:42 +0300
User-Agent: KMail/1.5
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200801090022.55589.a1426z@gawab.com> <200801091452.14890.a1426z@gawab.com> <20080112145140.GB6751@mit.edu>
In-Reply-To: <20080112145140.GB6751@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200801131405.42083.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Wed, Jan 09, 2008 at 02:52:14PM +0300, Al Boldi wrote:
> > Ok, but let's look at this a bit more opportunistic / optimistic.
> >
> > Even after a black-out shutdown, the corruption is pretty minimal, using
> > ext3fs at least.
>
> After a unclean shutdown, assuming you have decent hardware that
> doesn't lie about when blocks hit iron oxide, you shouldn't have any
> corruption at all.  If you have crappy hardware, then all bets are off....

Maybe with barriers...

> > So let's take advantage of this fact and do an optimistic fsck, to
> > assure integrity per-dir, and assume no external corruption.  Then
> > we release this checked dir to the wild (optionally ro), and check
> > the next.  Once we find external inconsistencies we either fix it
> > unconditionally, based on some preconfigured actions, or present the
> > user with options.
>
> So what can you check?  The *only* thing you can check is whether or
> not the directory syntax looks sane, whether the inode structure looks
> sane, and whether or not the blocks reported as belong to an inode
> looks sane.

Which would make this dir/area ready for read/write access.

> What is very hard to check is whether or not the link count on the
> inode is correct.  Suppose the link count is 1, but there are actually
> two directory entries pointing at it.  Now when someone unlinks the
> file through one of the directory hard entries, the link count will go
> to zero, and the blocks will start to get reused, even though the
> inode is still accessible via another pathname.  Oops.  Data Loss.

We could buffer this, and only actually overwrite when we are completely 
finished with the fsck.

> This is why doing incremental, on-line fsck'ing is *hard*.  You're not
> going to find this while doing each directory one at a time, and if
> the filesystem is changing out from under you, it gets worse.  And
> it's not just the hard link count.  There is a similar issue with the
> block allocation bitmap.  Detecting the case where two files are
> simultaneously can't be done if you are doing it incrementally, and if
> the filesystem is changing out from under you, it's impossible, unless
> you also have the filesystem telling you every single change while it
> is happening, and you keep an insane amount of bookkeeping.

Ok, you have a point, so how about we change the implementation detail a bit, 
from external fsck to internal fsck, leveraging the internal fs bookkeeping, 
while allowing immediate but controlled read/write access.


Thanks for more thoughts!

--
Al

