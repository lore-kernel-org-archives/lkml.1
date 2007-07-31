Return-Path: <linux-kernel-owner+w=401wt.eu-S1754200AbXGaHos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbXGaHos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 03:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbXGaHoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 03:44:39 -0400
Received: from mail.suse.de ([195.135.220.2]:43070 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569AbXGaHoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 03:44:38 -0400
Date: Tue, 31 Jul 2007 09:44:36 +0200
From: Jan Blunck <jblunck@suse.de>
To: Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Re: [RFC 12/26] ext2 white-out support
Message-ID: <20070731074436.GE5101@hasse.suse.de>
References: <20070730161323.100048969@weierstrass.suse.de> <20070730161324.261652101@weierstrass.suse.de> <20070731034515.GD25876@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731034515.GD25876@thunk.org>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG
	Nuernberg)
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, Theodore Tso wrote:

> On Mon, Jul 30, 2007 at 06:13:35PM +0200, Jan Blunck wrote:
> > Introduce white-out support to ext2.
> > 
> > Known Bugs:
> > - Needs a reserved inode number for white-outs
> 
> You picked different reserved inodes for the ext2 and ext3
> filesystems.  That's good for a NACK right there.  The codepoints
> (i.e., reserved inode numbers, feature bit masks, etc.) for ext2,
> ext3, and ext4 MUST not overlap.  After all, someone might use tune2fs
> -j to convert an ext2 filesystem to ext3, and is it's REALLY BAD that
> you're using a reserved inode of 7 for ext2, and 9 for ext3.

Ouch, right.

> Also, I note that you have created a new INCOMPAT feature flag support
> for whiteouts.  That's really unfortunate; we try to avoid introducing
> incompatible feature flags unless absolutely necessary; note that even
> adding a COMPAT feature flag means that you need a new version of
> e2fsprogs if you want e2fsck to be willing to touch that filesystem.
> 
> So --- if you're looking for a way to add whiteout support to
> ext2/ext3 without needing a feature bit, here's how.  We allocate a
> new inode flag in struct ext3_inode.i_flags:
> 
> #define EXT2_WHTOUT_FL	 0x00040000
> 
> We also allocate a new field in the ext2 superblock to store the
> "whiteout inode".  (Please coordinate with me so it's a superblock
> field not in use by ext3/ext4, and so it's reserved so that no one
> else uses it.)  The superblock field, call it s_whtout_ino, stores the
> inode number for the "white out inode".
> 
> When you create a new whiteout file, the code checks sb->s_whtout_ino,
> and if it is zero, it allocates a new inode, and creates it as a
> zero-length regular file (i_mode |= S_IFREG) with the EXT2_WHTOUT_FL
> flag set in the inode, and then store the inode number in
> sb->s_whtout_ino.  If sb->s_whtout_ino is non-zero, you must read in
> the inode and make sure that the EXT2_WHTOUT_FL is set.  If it is not,
> then allocate a new whiteout inode as described previously.  Then link
> the inode into the directory as before.
> 
> When reading an inode, if the EXT2_WHTOUT_FL flag is set, then set the
> in-memory mode of the inode to be S_IFWHT.  
> 
> That's pretty much about it.  For cleanliness sake, it would be good
> if ext2_delete_inode clears sb->s_whtout_ino if the last whiteout link
> has been deleted, but it's strictly speaking not necessary.  If you do
> it this way, the filesystem is completely backwards compatible; the
> whiteout files will just appear to links to a normal zero-lenth file.

Ok, this is pretty similar to the way I implemented this for tmpfs. The
problem is that the union mount code is explicitly checking if the filesystem
is supporting whiteout. I used to use a new filesystem flag (FS_WHITEOUT) for
this but thought that disk filesystem like ext2/3/4 will have problem with
that if you mount an old image. So I guess I still need a feature flag.

> I wouldn't bother with setting the directory type field to be DT_WHT,
> given that they will never be returned to userspace anyway.

At the moment I still rely on this for the current readdir implementation.
Viro already said that he doesn't want to see this (the readdir changes) in
the kernel but in userspace.

Thanks,
Jan
