Return-Path: <linux-kernel-owner+w=401wt.eu-S1753321AbYFAQvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbYFAQvP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 12:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbYFAQu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 12:50:57 -0400
Received: from lazybastard.de ([212.112.238.170]:54026 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbYFAQu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 12:50:56 -0400
Date: Sun, 1 Jun 2008 18:50:48 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: arnd@arndb.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [RFC 2/7] cramfs: create unique inode numbers
Message-ID: <20080601165048.GC13094@logfs.org>
References: <20080531152013.031903990@arndb.de> <20080531153510.692084580@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080531153510.692084580@arndb.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 May 2008 17:20:15 +0200, arnd@arndb.de wrote:
> 
> This changes the inode number in cramfs to be based on
> the location of the dentry instead of the file, in order
> to make inodes unique.

Couldn't this cause problems for NFS?  The same inode no longer has a
stable inode number across reboots.  Basing on dentry location can also
be an information leak and cause problems on 64bit machines with old
userspace.

We could keep the original approach and use a static counter otherwise.
Something roughly like this:

static ino_t cramfs_get_ino(struct super_block *sb,
			struct cramfs_inode *cramfs_inode)
{
	static ino_t counter;
	struct inode *inode;

	if (cramfs_inode->offset && cramfs_inode->size)
		return cramfs_inode->offset << 2;

	for (;;) {
		counter++;
		if (!counter & 3)
			counter++; /* skip numbers that could be offsets */
		inode = cramfs_iget(sb, counter);
		if (!inode)
			return counter; /* free to use */
		iput(inode);
	}
}

> This lets us change and unlink files in a later patch
> without changing all other files that contain the same
> data, and it fixes a user-visible bug with 'cp -a'
> trying to hardlink empty directories when copying from
> a cramfs source.
> 
> A slight disadvantage is that identical files no longer
> share a common page cache, so the data has to be read
> from disk for each file individually.

That seems to be solved with above approach as well.

Jörn

-- 
You can take my soul, but not my lack of enthusiasm.
-- Wally
