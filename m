Return-Path: <linux-kernel-owner+w=401wt.eu-S1758908AbZBZEWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908AbZBZEWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 23:22:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbZBZEWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 23:22:43 -0500
Received: from vsmtp03.dti.ne.jp ([202.216.231.138]:63879 "EHLO
	vsmtp03.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbZBZEWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 23:22:42 -0500
From: hooanon05@yahoo.co.jp
Subject: Re: New filesystem for Linux kernel 
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: Theodore Tso <tytso@mit.edu>, Tomas M <tomas@slax.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1235577214.15148.77.camel@moss-terrapins.epoch.ncsc.mil>
References: <7558.1235374266@jrobl> <7769.1235374482@jrobl> <49A268A7.1010708@slax.org> <49A26ACC.90804@slax.org> <49A3AC14.2050107@slax.org> <20090224141548.GB5482@mit.edu> <1235488695.15148.49.camel@moss-terrapins.epoch.ncsc.mil> <14799.1235490088@jrobl> <1235577214.15148.77.camel@moss-terrapins.epoch.ncsc.mil>
Date: Thu, 26 Feb 2009 13:21:26 +0900
Message-ID: <7326.1235622086@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thank you for searching.

"David P. Quigley":
> "And unionfs is the wrong thing do use for this.  Unioning is a complex
> namespace operation and needs to be implemented in the VFS or at least
> needs a lot of help from the VFS.  Getting namespace cache coherency
> and especially locking right is impossible with out that."
> 
> I'd suggest getting the VFS maintainers to chime in on your code. If
> their opinion on this has changed then you are in much better shape for
> getting AUFS2 merged.

It may not be apropriate to ask you "especially locking right" in
detail. But if it means what I am guessing, this description may be the
answer.

(from [RFC 3/8] Aufs2: lookup)
Revalidate Dentry and UDBA (User's Direct Branch Access)
----------------------------------------------------------------------
Generally VFS helpers re-validate a dentry as a part of lookup.
0. digging down the directory hierarchy.
1. lock the parent dir by its i_mutex.
2. lookup the final (child) entry.
3. revalidate it.
4. call the actual operation (create, unlink, etc.)
5. unlock the parent dir

If the filesystem implements its ->d_revalidate() (step 3), then it is
called. Actually aufs implements it and checks the dentry on a branch is
still valid.
But it is not enough. Because aufs has to release the lock for the
parent dir on a branch at the end of ->lookup() (step 2) and
->d_revalidate() (step 3) while the i_mutex of the aufs dir is still
held by VFS.
If the file on a branch is changed directly, eg. bypassing aufs, after
aufs released the lock, then the subsequent operation may cause
something unpleasant result.

This situation is a result of VFS architecture, ->lookup() and
->d_revalidate() is separated. But I never say it is wrong. It is a good
design from VFS's point of view. It is just not suitable for sub-VFS
character in aufs.

Aufs supports such case by three level of revalidation which is
selectable by user.
1. Simple Revalidate
   Addition to the native flow in VFS's, confirm the child-parent
   relationship on the branch just after locking the parent dir on the
   branch in the "actual operation" (step 4). When this validation
   fails, aufs returns EBUSY. ->d_revalidate() (step 3) in aufs still
   checks the validation of the dentry on branches.
2. Monitor Changes Internally by Inotify
   Addition to above, in the "actual operation" (step 4) aufs re-lookup
   the dentry on the branch, and returns EBUSY if it finds different
   dentry.
   Additionally, aufs sets the inotify watch for every dir on branches
   during it is in cache. When the event is notified, aufs registers a
   function to kernel 'events' thread by schedule_work(). And the
   function sets some special status to the cached aufs dentry and inode
   private data. If they are not cached, then aufs has nothing to
   do. When the same file is accessed through aufs (step 0-3) later,
   aufs will detect the status and refresh all necessary data.
   In this mode, aufs has to ignore the event which is fired by aufs
   itself.
3. No Extra Validation
   This is the simplest test and doesn't add any additional revalidation
   test, and skip therevalidatin in step 4. It is useful and improves
   aufs performance when system surely hide the aufs branches from user,
   by over-mounting something (or another method).
----------------------------------------------------------------------


> This may sound like a copout but unfortunately it seems my logs were on
> my hard drive that died a few months back. Regardless though since you
> did a major rewrite for AUFS2 those comments could possibly no longer be
> valid. Regardless since there was a major rewrite since your last review
> several people should review the code base.

I have no objection about reviewing, entirely agreed.
Because I could guess it is hard work to read 40k lines, I posted
documents which describe design first.


J. R. Okajima
