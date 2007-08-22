Return-Path: <linux-kernel-owner+w=401wt.eu-S1762661AbXHVOE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762661AbXHVOE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 10:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754730AbXHVOEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 10:04:52 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39610 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928AbXHVOEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 10:04:51 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <htejun@gmail.com>
Cc: cornelia.huck@de.ibm.com, greg@kroah.com, linux-kernel@vger.kernel.org,
       satyam@infradead.org, stern@rowland.harvard.edu,
       containers@lists.osdl.org
Subject: Re: [PATCHSET] Sysfs cleanups from Eric W. Biederman
References: <11876133893720-git-send-email-htejun@gmail.com>
Date: Wed, 22 Aug 2007 08:04:07 -0600
In-Reply-To: <11876133893720-git-send-email-htejun@gmail.com> (Tejun Heo's
	message of "Mon, 20 Aug 2007 21:36:29 +0900")
Message-ID: <m1ejhvpsx4.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <htejun@gmail.com> writes:

> Hello, all.
>
> This is subset of Eric W. Biederman's "Sysfs cleanups & tagged
> directory support" patchset[1] with the following modifications.

As a base: 
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

>
> * fix-i_mutex-locking-in-sysfs_get_dentry patch is added at the top
>   and #14-Don_t-use-lookup_one_len_kern and
>   #15-vfs-Remove-lookup_one_len_kern are dropped.  This is because #14
>   contained had a bug where it might created dentry/inode for an
>   already deleted sysfs_dirent.  I think it's benefitial to keep
>   single lookup path.

I think I disagree with the bug spotting.

At least in net we the sysfs_rename_mutex which keeps parent
directories from disappearing.  Further we have a reference
to the leaf sysfs_dirent and are actively manipulating it, so
the sysfs_dirent should not disappear on us.

> * Rewrote simplify-sysfs_get_dentry patch and
>   #08-Implement-__sysfs_get_dentry,
>   #09-Move-sysfs_get_dentry-below-__sysfs_get_dentry and
>   #10-Rewrite-sysfs_get_dentry-in-terms-of-__sysfs_get_dentry are
>   omitted as __sysfs_get_dentry() isn't used by anyone.

Right.  __sysfs_get_dentry is an optimization that has makes
the best case for sysfs_get_dentry O(1) instead of O(depth).
However this doesn't matter because sysfs_get_dentry is not
on any fast path and the maximum depth of sysfs directories
is fairly shallow and programmer controlled.

The only user other user of __sysfs_get_dentry is in the tagged
directory support, and even that user doesn't strictly need it.
Although it is a bit silly to populate the dcache just so you
can invalidate it a moment later...

Just doing the dget(sysfs_sb->s_root) is a bit clearer in
sysfs_get_dentry then knowing implicitly that is what
__sysfs_get_dentry does in the worst cased.

> * #16, 19-25 are omitted as it isn't clear yet how the tagged entry
>   support will end up.
>
> * readdir simplification fixed.
>
> * sysfs_mutex double locking fixed.
>
> The patchset is on top of the current -gregkh.

Eric
