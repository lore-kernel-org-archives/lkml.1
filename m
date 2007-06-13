Return-Path: <linux-kernel-owner+w=401wt.eu-S1759091AbXFMQOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759091AbXFMQOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 12:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758387AbXFMQOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 12:14:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:33648 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbXFMQOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 12:14:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kB9L5dfMlm6QfS2k907xXkJy+NoT6sEvYMM08gHnDl4rs0siDJyVXt8tW44rJejKmgJMzyNsYRpPVWlPF6ti6LunijE8jtAqixHeVYxy3ZunU9Sg1CS/U5M1hA30PXQv9qXZuya0/CifBTiPhSgAH1bRp586f2sDPDsD5q8j9Q4=
Message-ID: <787b0d920706130914l676a24cau62525e90a90b5839@mail.gmail.com>
Date: Wed, 13 Jun 2007 12:14:40 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: "Chris Mason" <chris.mason@oracle.com>
Subject: Re: [ANNOUNCE] Btrfs: a copy on write, snapshotting FS
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, snitzer@gmail.com
In-Reply-To: <20070613120037.GA28279@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <787b0d920706122245j3a2ff7e8ja611ecf41cc67a4c@mail.gmail.com>
	 <20070613120037.GA28279@think.oraclecorp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/13/07, Chris Mason <chris.mason@oracle.com> wrote:
> On Wed, Jun 13, 2007 at 01:45:28AM -0400, Albert Cahalan wrote:

> > The usual wishlist:
> >
> > * inode-to-pathnames mapping
>
> This one I'll code, it will help with inode link count verification.  I
> want to be able to detect at run time that an inode with a link count of
> zero is still actually in a directory. So there will be back pointers
> from the inode to the directory.

Great, but fsck improvement wasn't on my mind. This is
a desirable feature for the NFS server, and for regular users.
Think about a backup program trying to maintain hard links.

> Also, the incremental backup code will be able to walk the btree to find
> inodes that have changed, and the backpointers will help make a list of
> file names that need to be rsync'd or whatever.
>
> > * a subvolume that is a single file (disk image, database, etc.)
>
> subvolumes can be made that have a single file in them, but they have to
> be directories right now.  Doing otherwise would complicate mounts and
> other management tools (inside the btree, it doesn't really matter).

Bummer. As I understand it, ZFS provides this. :-)

> > * directory indexes to better support Wine and Samba
> > * secure delete via destruction of per-file or per-block random crypto keys
>
> I'd rather keep secure delete as a userland problem (or a layered FS
> problem).  When you take backups and other copies of the file into
> account, it's a bigger problem than btrfs wants to tackle right now.

It can't be a userland problem if you allow disk blocks to move.
Volume resizing, logging/journalling, etc. -- they combine to make
the userland solution essentially impossible. (one could wipe the
whole partition, or maybe fill ALL space on the volume)

I think it needs to be per-extent.

At each level in the btree, you place a randomly generated key
for the more leafward nodes. This means that secure deletion is
merely the act of wiping the key... which can itself occur by
wiping the key of the more rootward node.

> > * atomic creation of copy-on-write directory trees
>
> Do you mean something more fine grained than the current snapshotting
> system?

I believe so. Example: I have a linux-2.6 directory. It's not
a mount point or anything special like that. I want to copy
it to a new directory called wip, without actually copying
all the blocks. To all the normal POSIX API stuff, this copy
should look like the result of "cp -a", not hard links.

> > * insert/delete ability (add/remove a chunk in the middle of a file)
>
> The disk format makes this O(extent records past the chunk).  It's
> possible to code but it would not be optimized.

That's understandable, but note that Reiserfs can support this.
