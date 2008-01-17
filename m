Return-Path: <linux-kernel-owner+w=401wt.eu-S1754097AbYAQGAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbYAQGAg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 01:00:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbYAQGA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 01:00:26 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36676 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbYAQGAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 01:00:25 -0500
Date: Thu, 17 Jan 2008 06:00:17 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       hch@infradead.org, viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [UNIONFS] 00/29 Unionfs and related patches pre-merge review (v2)
Message-ID: <20080117060017.GC27894@ZenIV.linux.org.uk>
References: <11999771882152-git-send-email-ezk@cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11999771882152-git-send-email-ezk@cs.sunysb.edu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After grep for locking-related things:

	* lock_parent(): who said that you won't get dentry moved
before managing to grab i_mutex on parent?  While we are at it,
who said that you won't get dentry moved between fetching d_parent
and doing dget()?  In that case parent could've been _freed_ before
you get to dget().

	* in create_parents():
+                       struct inode *inode = lower_dentry->d_inode;
+                       /*
+                        * If we get here, it means that we created a new
+                        * dentry+inode, but copying permissions failed.
+                        * Therefore, we should delete this inode and dput
+                        * the dentry so as not to leave cruft behind.
+                        */
+                       if (lower_dentry->d_op && lower_dentry->d_op->d_iput)
+                               lower_dentry->d_op->d_iput(lower_dentry,
+                                                          inode);
+                       else
+                               iput(inode);
+                       lower_dentry->d_inode = NULL;
+                       dput(lower_dentry);
+                       lower_dentry = ERR_PTR(err);
+                       goto out;
Really?  So what happens if it had become positive after your test and
somebody had looked it up in lower layer and just now happens to be
in the middle of operations on it?  Will be thucking frilled by that...

	* __unionfs_rename():
+       lock_rename(lower_old_dir_dentry, lower_new_dir_dentry);
+       err = vfs_rename(lower_old_dir_dentry->d_inode, lower_old_dentry,
+                        lower_new_dir_dentry->d_inode, lower_new_dentry);
+       unlock_rename(lower_old_dir_dentry, lower_new_dir_dentry);

Uh-huh...  To start with, what guarantees that your lower_old_dentry
is still a child of your lower_old_dir_dentry?  What's more, you are
not checking the result of lock_rename(), i.e. asking for serious trouble.

	* revalidation stuff: err...  how the devil can it work for
directories, when there's nothing to prevent changes in underlying
layers between ->d_revalidate() and operation itself?  For the upper
layer (unionfs itself) everything's more or less fine, but the rest
of that...
