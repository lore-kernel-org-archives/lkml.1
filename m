Return-Path: <linux-kernel-owner+w=401wt.eu-S1763721AbYALOwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763721AbYALOwi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 09:52:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758704AbYALOw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 09:52:29 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:38876 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757316AbYALOw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 09:52:28 -0500
Date: Sat, 12 Jan 2008 09:51:40 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Al Boldi <a1426z@gawab.com>
Cc: Valerie Henson <val.henson@gmail.com>, Rik van Riel <riel@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFD] Incremental fsck
Message-ID: <20080112145140.GB6751@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Al Boldi <a1426z@gawab.com>,
	Valerie Henson <val.henson@gmail.com>,
	Rik van Riel <riel@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <200801090022.55589.a1426z@gawab.com> <200801090740.12989.a1426z@gawab.com> <70b6f0bf0801082345vf57951ey642e35c3d6e5194f@mail.gmail.com> <200801091452.14890.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801091452.14890.a1426z@gawab.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 02:52:14PM +0300, Al Boldi wrote:
> 
> Ok, but let's look at this a bit more opportunistic / optimistic.
> 
> Even after a black-out shutdown, the corruption is pretty minimal, using 
> ext3fs at least.
>

After a unclean shutdown, assuming you have decent hardware that
doesn't lie about when blocks hit iron oxide, you shouldn't have any
corruption at all.  If you have crappy hardware, then all bets are off....

> So let's take advantage of this fact and do an optimistic fsck, to
> assure integrity per-dir, and assume no external corruption.  Then
> we release this checked dir to the wild (optionally ro), and check
> the next.  Once we find external inconsistencies we either fix it
> unconditionally, based on some preconfigured actions, or present the
> user with options.

So what can you check?  The *only* thing you can check is whether or
not the directory syntax looks sane, whether the inode structure looks
sane, and whether or not the blocks reported as belong to an inode
looks sane.

What is very hard to check is whether or not the link count on the
inode is correct.  Suppose the link count is 1, but there are actually
two directory entries pointing at it.  Now when someone unlinks the
file through one of the directory hard entries, the link count will go
to zero, and the blocks will start to get reused, even though the
inode is still accessible via another pathname.  Oops.  Data Loss.

This is why doing incremental, on-line fsck'ing is *hard*.  You're not
going to find this while doing each directory one at a time, and if
the filesystem is changing out from under you, it gets worse.  And
it's not just the hard link count.  There is a similar issue with the
block allocation bitmap.  Detecting the case where two files are
simultaneously can't be done if you are doing it incrementally, and if
the filesystem is changing out from under you, it's impossible, unless
you also have the filesystem telling you every single change while it
is happening, and you keep an insane amount of bookkeeping.

One that you *might* be able to do, is to mount a filesystem readonly,
check it in the background while you allow users to access it
read-only.  There are a few caveats, however ---- (1) some filesystem
errors may cause the data to be corrupt, or in the worst case, could
cause the system to panic (that's would arguably be a
filesystem/kernel bug, but we've not necessarily done as much testing
here as we should.)  (2) if there were any filesystem errors found,
you would beed to completely unmount the filesystem to flush the inode
cache and remount it before it would be safe to remount the filesystem
read/write.  You can't just do a "mount -o remount" if the filesystem
was modified under the OS's nose.

> All this could be per-dir or using some form of on-the-fly file-block-zoning.
> 
> And there probably is a lot more to it, but it should conceptually be 
> possible, with more thoughts though...

Many things are possible, in the NASA sense of "with enough thrust,
anything will fly".  Whether or not it is *useful* and *worthwhile*
are of course different questions!  :-)

						- Ted
