Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbZAUREi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbZAUREi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 12:04:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbZAURE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 12:04:27 -0500
Received: from thunk.org ([69.25.196.29]:60122 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003AbZAURE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 12:04:26 -0500
Date: Wed, 21 Jan 2009 12:04:23 -0500
From: Theodore Tso <tytso@mit.edu>
To: Victor Pelt <victor.pelt@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ext4 no space left
Message-ID: <20090121170423.GJ31253@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Victor Pelt <victor.pelt@gmail.com>, linux-kernel@vger.kernel.org
References: <576cb9750901210619u3d2abfdclb818f0946f7bc663@mail.gmail.com> <20090121145513.GH31253@mit.edu> <576cb9750901210718u32aa98ecy87e7298a0f3444f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <576cb9750901210718u32aa98ecy87e7298a0f3444f@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 04:18:35PM +0100, Victor Pelt wrote:
> i set the number mounted counter to 31, which forced fsck to run on
> the next reboot. I rebooted, fsck didn't show any erros, but i still
> got the no space left error when i tried to copy files to the
> partition.

OK, if a reboot didn't help, I'll bet I know what happened.  E2fsprogs
changed the default default inode ratio, which means that number of
inodes being created is half what it was previously.  If you do a "df
-i", you'll probably see that you have exhausted the number of inodes
in the filesystem.

The default inode ratio controlled by /etc/mke2fs.conf, and is
currently 16k.  That is, it assumes the average size of files on the
filesystem is at least 16k.  (It previously was 8k.)  For large
filesystems, this is not a problem; I'm guessing that you have a small
root filesystem, and probably are using a hard-coded /dev partition,
so the large number of (zero-length) device files is throwing off the
average.  If you recreate the filesystem with mke2fs -I 8192, it
should allow you to copy over all of your files in the root
filesystem.

Finally, note that we made this change for all ext2/3/4 filesystems,
so this is not unique to ext4; it's just that you reformatted your
root filesystem for the first time since upgrading to a newer
e2fsprogs with the changed default, and you ran into this problem.  If
there are enough people who are using small root filesystems, maybe
we'll need to have some adjusted hueristics.  Right now we have
"floppy" for filesystems less than 3 megs, "small" for filesystems
less than 512 megs, and every thing else is default.  Maybe we need to
have a "medium" for filesystems smaller than 10 gigs, perhaps, and use
a default inode ratio of 8192 for medium-sized filesystems....

						- Ted
