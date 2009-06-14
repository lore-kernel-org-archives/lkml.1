Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbZFNLqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbZFNLqT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 07:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755719AbZFNLqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 07:46:13 -0400
Received: from mail2.shareable.org ([80.68.89.115]:34362 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266AbZFNLqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 07:46:12 -0400
Date: Sun, 14 Jun 2009 12:46:13 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Marco <marco.stornelli@gmail.com>
Cc: Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 00/14] Pramfs: Persistent and protected ram filesystem
Message-ID: <20090614114613.GC9514@shareable.org>
References: <4A33A7A2.1050608@gmail.com> <20090613155957.GA16220@shareable.org> <4A34A394.5040509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A34A394.5040509@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marco wrote:
> Simply because the ramdisk was not designed to work in a persistent
> environment.

One thing with persistent RAM disks is you _really_ want it to be
robust if the system crashes for any reason while it is being
modified.  The last thing you want is to reboot, and find various
directories containing configuration files or application files have
been corrupted or disappeared as a side effect of writing something else.

That's one of the advantages of using a log-structured filesystem such
as Nilfs, JFFS2, Logfs, UBIFS, Btrfs, ext3, reiserfs, XFS or JFS on a
ramdisk :-)

Does PRAMFS have this kind of robustness?

> In addition this kind of filesystem has been designed to work not
> only with classic ram. You can think at the situation where you have
> got an external SRAM with a battery for example. With it you can
> "remap" in an easy way the SRAM. Moreover there's the issue of
> memory protection that this filesystem takes care.  > Why is an
> entire filesystem needed, instead of simply a block driver > if the
> ramdisk driver cannot be used?  > >From documentation: "A relatively
> straight-forward solution is to write a simple block driver for the
> non-volatile RAM, and mount over it any disk-based filesystem such
> as ext2/ext3, reiserfs, etc.  But the disk-based fs over
> non-volatile RAM block driver approach has some drawbacks:
>
> 1. Disk-based filesystems such as ext2/ext3 were designed for
> optimum performance on spinning disk media, so they implement
> features such as block groups, which attempts to group inode data
> into a contiguous set of data blocks to minimize disk seeking when
> accessing files. For RAM there is no such concern; a file's data
> blocks can be scattered throughout the media with no access speed
> penalty at all. So block groups in a filesystem mounted over RAM
> just adds unnecessary complexity. A better approach is to use a
> filesystem specifically tailored to RAM media which does away with
> these disk-based features.  This increases the efficient use of
> space on the media, i.e. more space is dedicated to actual file data
> storage and less to meta-data needed to maintain that file data.

All true, I agree.  RAM-based databases use different structures to
disk-based databases for the same reasons.

Isn't there any good RAM-based filesystem already?  Some of the flash
filesystems and Nilfs seem promising, using fake MTD with a small
erase size.  All are robust on crashes.

> 2. If the backing-store RAM is comparable in access speed to system
> memory, there's really no point in caching the file I/O data in the
> page cache.
>
>    Better to move file data directly between the user buffers
>    and the backing store RAM, i.e. use direct I/O. This prevents the
>    unnecessary populating of the page cache with dirty pages.

Good idea.

>    However direct I/O has to be enabled at every file open. To
>    enable direct I/O at all times for all regular files requires
>    either that applications be modified to include the O_DIRECT flag
>    on all file opens, or that a new filesystem be used that always
>    performs direct I/O by default."

There are other ways to include the O_DIRECT flag automatically.  A
generic mount option would be enough.  I've seen other OSes with such
an option.  That code for that would be tiny.

But standard O_DIRECT direct I/O doesn't work for all applications: it
has to be aligned: device offset, application memory address and size
all have to be aligned.

(It would be a nice touch to produce a generic mount option
o_direct_when_possible, which turns on direct I/O but permits
unaligned I/O.  That could be used with all applications.)

As you say PRAMFS can work with special SRAMs needing memory
protection (and maybe cache coherence?), if you mmap() a file does it
need to use the page cache then?  If so, do you have issues with
coherency between mmap() and direct read/write?

> On this point I'd like to hear other embedded guys.

As one, I'd like to say if it can checksum the RAM at boot as well,
then I might like to use a small one in ordinary SRAM (at a fixed
reserved address) for those occasions when a reboot happens
(intentional or not) and I'd like to pass a little data to the next
running kernel about why the reboot happened, without touching flash
every time.

-- Jamie
