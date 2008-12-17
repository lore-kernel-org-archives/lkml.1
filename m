Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752841AbYLQVlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbYLQVlr (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 16:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbYLQVlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 16:41:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751494AbYLQVlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 16:41:35 -0500
Date: Wed, 17 Dec 2008 13:40:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Louis Rilling <louis.rilling@kerlabs.com>
Cc: Joel.Becker@oracle.com, linux-kernel@vger.kernel.org,
        cluster-devel@redhat.com, swhiteho@redhat.com,
        louis.rilling@kerlabs.com, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] configfs: Silence lockdep on mkdir(), rmdir() and
 configfs_depend_item()
Message-Id: <20081217134020.42da55fc.akpm@linux-foundation.org>
In-Reply-To: <1229095751-23984-1-git-send-email-louis.rilling@kerlabs.com>
References: <20081212100615.GD19128@hawkmoon.kerlabs.com>
	<1229095751-23984-1-git-send-email-louis.rilling@kerlabs.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Dec 2008 16:29:11 +0100
Louis Rilling <louis.rilling@kerlabs.com> wrote:

> When attaching default groups (subdirs) of a new group (in mkdir() or
> in configfs_register()), configfs recursively takes inode's mutexes
> along the path from the parent of the new group to the default
> subdirs. This is needed to ensure that the VFS will not race with
> operations on these sub-dirs. This is safe for the following reasons:
> 
> - the VFS allows one to lock first an inode and second one of its
>   children (The lock subclasses for this pattern are respectively
>   I_MUTEX_PARENT and I_MUTEX_CHILD);
> - from this rule any inode path can be recursively locked in
>   descending order as long as it stays under a single mountpoint and
>   does not follow symlinks.
> 
> Unfortunately lockdep does not know (yet?) how to handle such
> recursion.
> 
> I've tried to use Peter Zijlstra's lock_set_subclass() helper to
> upgrade i_mutexes from I_MUTEX_CHILD to I_MUTEX_PARENT when we know
> that we might recursively lock some of their descendant, but this
> usage does not seem to fit the purpose of lock_set_subclass() because
> it leads to several i_mutex locked with subclass I_MUTEX_PARENT by
> the same task.
> 
> >From inside configfs it is not possible to serialize those recursive
> locking with a top-level one, because mkdir() and rmdir() are already
> called with inodes locked by the VFS. So using some
> mutex_lock_nest_lock() is not an option.
> 
> I am proposing two solutions:
> 1) one that wraps recursive mutex_lock()s with
>    lockdep_off()/lockdep_on().
> 2) (as suggested earlier by Peter Zijlstra) one that puts the
>    i_mutexes recursively locked in different classes based on their
>    depth from the top-level config_group created. This
>    induces an arbitrary limit (MAX_LOCK_DEPTH - 2 == 46) on the
>    nesting of configfs default groups whenever lockdep is activated
>    but this limit looks reasonably high. Unfortunately, this alos
>    isolates VFS operations on configfs default groups from the others
>    and thus lowers the chances to detect locking issues.
> 
> This patch implements solution 1).
> 
> Solution 2) looks better from lockdep's point of view, but fails with
> configfs_depend_item(). This needs to rework the locking
> scheme of configfs_depend_item() by removing the variable lock recursion
> depth, and I think that it's doable thanks to the configfs_dirent_lock.
> For now, let's stick to solution 1).
> 
> Signed-off-by: Louis Rilling <louis.rilling@kerlabs.com>
> ---
>  fs/configfs/dir.c |   59 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 59 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
> index 8e93341..9c23583 100644
> --- a/fs/configfs/dir.c
> +++ b/fs/configfs/dir.c
> @@ -553,12 +553,24 @@ static void detach_groups(struct config_group *group)
>  
>  		child = sd->s_dentry;
>  
> +		/*
> +		 * Note: we hide this from lockdep since we have no way
> +		 * to teach lockdep about recursive
> +		 * I_MUTEX_PARENT -> I_MUTEX_CHILD patterns along a path
> +		 * in an inode tree, which are valid as soon as
> +		 * I_MUTEX_PARENT -> I_MUTEX_CHILD is valid from a
> +		 * parent inode to one of its children.
> +		 */
> +		lockdep_off();
>  		mutex_lock(&child->d_inode->i_mutex);
> +		lockdep_on();
>
> [etc]
>

Oh dear, what an unpleasant patch.

Peter, can this be saved?
