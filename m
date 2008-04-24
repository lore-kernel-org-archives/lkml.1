Return-Path: <linux-kernel-owner+w=401wt.eu-S1758955AbYDXR1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955AbYDXR1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 13:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755813AbYDXR06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 13:26:58 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37962 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbYDXR05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 13:26:57 -0400
Date: Thu, 24 Apr 2008 13:25:58 -0400
Message-Id: <200804241725.m3OHPwIs015778@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, dave@linux.vnet.ibm.com,
       ezk@cs.sunysb.edu, mhalcrow@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts 
In-reply-to: Your message of "Thu, 24 Apr 2008 14:48:26 BST."
             <20080424134826.GD15214@ZenIV.linux.org.uk> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20080424134826.GD15214@ZenIV.linux.org.uk>, Al Viro writes:
> On Thu, Apr 24, 2008 at 03:05:21PM +0200, Miklos Szeredi wrote:
[...]
> And yes, we need the counterpart for superblock-level stuff, to deal with
> remaining races (look at fs_may_remount_ro() and puke - it's still racy
> as hell).  E.g. unlink should do sb-level "will write" when it drops
> i_nlink to 0 and final removal of inode should do "won't write".

Al, any near-term plans for sb-level "want write" locking as we discussed
briefly at LSF?  Being able to do so for copyup in unionfs will hopefully
allow me to prevent concurrent topology changes.

And while we're digressing.  It appears to me that when someone wants to
change a single meta-data item in a f/s, then locking rules are simple:
e.g., lock the directory inode.  But when you want to modify more than one,
you need a different kind of lock -- hence the s_vfs_rename_mutex.  The
latter requires calling lock_rename to find the lowest common ancestor of
the two directories that need locking.  This rename-locking protocol appears
to be a special case of the sb-level "want write" idea, right?  Moreover, I
don't believe that cross-directory renames are that common, so replacing the
s_vfs_rename_mutex and its use with a more generic sb-level multi-operation
write-lock should have a negligible performance impact.

Thanks,
Erez.
