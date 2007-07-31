Return-Path: <linux-kernel-owner+w=401wt.eu-S940534AbXGaDpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940534AbXGaDpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 23:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933560AbXGaDpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 23:45:25 -0400
Received: from thunk.org ([69.25.196.29]:50064 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759829AbXGaDpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 23:45:23 -0400
Date: Mon, 30 Jul 2007 23:45:15 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jan Blunck <jblunck@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Re: [RFC 12/26] ext2 white-out support
Message-ID: <20070731034515.GD25876@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jan Blunck <jblunck@suse.de>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bharata B Rao <bharata@linux.vnet.ibm.com>
References: <20070730161323.100048969@weierstrass.suse.de> <20070730161324.261652101@weierstrass.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070730161324.261652101@weierstrass.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 06:13:35PM +0200, Jan Blunck wrote:
> Introduce white-out support to ext2.
> 
> Known Bugs:
> - Needs a reserved inode number for white-outs

You picked different reserved inodes for the ext2 and ext3
filesystems.  That's good for a NACK right there.  The codepoints
(i.e., reserved inode numbers, feature bit masks, etc.) for ext2,
ext3, and ext4 MUST not overlap.  After all, someone might use tune2fs
-j to convert an ext2 filesystem to ext3, and is it's REALLY BAD that
you're using a reserved inode of 7 for ext2, and 9 for ext3.

Also, I note that you have created a new INCOMPAT feature flag support
for whiteouts.  That's really unfortunate; we try to avoid introducing
incompatible feature flags unless absolutely necessary; note that even
adding a COMPAT feature flag means that you need a new version of
e2fsprogs if you want e2fsck to be willing to touch that filesystem.

So --- if you're looking for a way to add whiteout support to
ext2/ext3 without needing a feature bit, here's how.  We allocate a
new inode flag in struct ext3_inode.i_flags:

#define EXT2_WHTOUT_FL	 0x00040000

We also allocate a new field in the ext2 superblock to store the
"whiteout inode".  (Please coordinate with me so it's a superblock
field not in use by ext3/ext4, and so it's reserved so that no one
else uses it.)  The superblock field, call it s_whtout_ino, stores the
inode number for the "white out inode".

When you create a new whiteout file, the code checks sb->s_whtout_ino,
and if it is zero, it allocates a new inode, and creates it as a
zero-length regular file (i_mode |= S_IFREG) with the EXT2_WHTOUT_FL
flag set in the inode, and then store the inode number in
sb->s_whtout_ino.  If sb->s_whtout_ino is non-zero, you must read in
the inode and make sure that the EXT2_WHTOUT_FL is set.  If it is not,
then allocate a new whiteout inode as described previously.  Then link
the inode into the directory as before.

When reading an inode, if the EXT2_WHTOUT_FL flag is set, then set the
in-memory mode of the inode to be S_IFWHT.  

That's pretty much about it.  For cleanliness sake, it would be good
if ext2_delete_inode clears sb->s_whtout_ino if the last whiteout link
has been deleted, but it's strictly speaking not necessary.  If you do
it this way, the filesystem is completely backwards compatible; the
whiteout files will just appear to links to a normal zero-lenth file.

I wouldn't bother with setting the directory type field to be DT_WHT,
given that they will never be returned to userspace anyway.

Regards,

						- Ted
