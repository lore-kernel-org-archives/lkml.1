Return-Path: <linux-kernel-owner+w=401wt.eu-S1763940AbYDXT45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763940AbYDXT45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 15:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759300AbYDXT4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 15:56:45 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:50295 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758295AbYDXT4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 15:56:43 -0400
Date: Thu, 24 Apr 2008 15:56:24 -0400
Message-Id: <200804241956.m3OJuOVE000991@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, Miklos Szeredi <miklos@szeredi.hu>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       dave@linux.vnet.ibm.com, mhalcrow@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts 
In-reply-to: Your message of "Thu, 24 Apr 2008 18:30:13 BST."
             <20080424173013.GA5882@ZenIV.linux.org.uk> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20080424173013.GA5882@ZenIV.linux.org.uk>, Al Viro writes:
> On Thu, Apr 24, 2008 at 01:25:58PM -0400, Erez Zadok wrote:
> > Al, any near-term plans for sb-level "want write" locking as we discussed
> > briefly at LSF?  Being able to do so for copyup in unionfs will hopefully
> > allow me to prevent concurrent topology changes.
> 
> That's pretty close to the top.
> 
> > the two directories that need locking.  This rename-locking protocol appears
> > to be a special case of the sb-level "want write" idea, right?
> 
> Not really - that one doesn't provide any exclusion between writers and
> that's what we want from rename/rename.

When you say "that one", do you mean the sb-level idea?  If the sb-level
"want write" not provide exclusion among writers, then how can I prevent
lower topology changes while copyup takes place?

If your sb-level "want write" idea won't provide that exclusion at the sb
level, then how about we elevate the s_vfs_rename_mutex into a generic
s_vfs_multi_dir_change_mutex of sorts, which can be used by rename as well
as copyup?

> Take a look at Documentation/filesystems/directory-locking for details
> of locking scheme...

OK.  lock_rename() at most locks one "parent" and one "child" inodes.  So
what happens to all the ones in b/t?  Suppose I have a path /a/b/c/d/e/f and
someone wants to mv /a/b/c/d/e to /a/b/; in that case lock_rename at least
grabs the mutex on /a/b, right?  Can someone go in the middle and try to
muck with the "c/d/" parts in between?

>From what I gathered, lock_rename won't be enough for me to prevent topology
changes during copyup; I'd really need to lock an entire arbitrarily deep
path of inodes.  That just seems so complex and prone to bugs, that it might
just be easier to have a single sb-level mutex for these complex
multi-directory operations.  I'm not sure how much performance hit this'd
be, thou, and if there's a more efficient way to do so.

If you think lock_rename will be sufficient for me to deal with copyups
vs. topology changes, then I'll start using it.

Thanks,
Erez.
