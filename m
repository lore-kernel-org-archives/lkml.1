Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbYGUTCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbYGUTCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 15:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbYGUTCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 15:02:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60449 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbYGUTCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 15:02:19 -0400
Date: Mon, 21 Jul 2008 20:02:16 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: sage@newdream.net, zach.brown@oracle.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] vfs: fix vfs_rename_dir for FS_RENAME_DOES_D_MOVE
	filesystems
Message-ID: <20080721190215.GH28946@ZenIV.linux.org.uk>
References: <E1KKtlz-0008B9-BM@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KKtlz-0008B9-BM@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 01:41:47PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> vfs_rename_dir() doesn't properly account for filesystems with
> FS_RENAME_DOES_D_MOVE.  If new_dentry has a target inode attached, it
> unhashes the new_dentry prior to the rename() iop and rehashes it
> after, but doesn't account for the possibility that rename() may have
> swapped {old,new}_dentry.  For FS_RENAME_DOES_D_MOVE filesystems, it
> rehashes new_dentry (now the old renamed-from name, which d_move()
> expected to go away), such that a subsequent lookup will find it.
> 
> This was caught by the recently posted POSIX fstest suite, rename/10.t 
> test 62 (and others) on ceph.
> 
> Fix by not rehashing the new dentry.  Rehashing would only make sense
> if the rename failed (which should happen extremely rarely), but we
> cannot handle that case correctly 100% of the time anyway, so...

Lovely.  AFAICS, that's a fallout from
commit 349457ccf2592c14bdf13b6706170ae2e94931b1
Author: Mark Fasheh <mark.fasheh@oracle.com>
Date:   Fri Sep 8 14:22:21 2006 -0700

    [PATCH] Allow file systems to manually d_move() inside of ->rename()

that had allowed that crap for directories.  Note that d_rehash() used
to be needed (d_move() would unhash the source otherwise) and d_move()
used to be unconditional until the changeset above.

It's _probably_ OK now, but I'd really like to think about NFS behaviour.
There are subtle traps in that area.

BTW, failing rename() is trivial - just have a non-empty target...
