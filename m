Return-Path: <linux-kernel-owner+w=401wt.eu-S1758101AbZIFSBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101AbZIFSBI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 14:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758070AbZIFSBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 14:01:05 -0400
Received: from mail-vw0-f195.google.com ([209.85.212.195]:50972 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758068AbZIFSBD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 14:01:03 -0400
MIME-Version: 1.0
In-Reply-To: <20090904065535.281876981@nick.local0.net>
References: <20090904065142.114706411@nick.local0.net>
	 <20090904065535.281876981@nick.local0.net>
Date: Sun, 6 Sep 2009 14:01:05 -0400
Message-ID: <7e0fb38c0909061101t6b4f337cvf691814c28bcf50e@mail.gmail.com>
Subject: Re: [patch 09/33] fs: dcache scale dentry refcount
From: Eric Paris <eparis@parisplace.org>
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 4, 2009 at 2:51 AM, <npiggin@suse.de> wrote:
> Make d_count non-atomic and protect it with d_lock. This allows us to
> ensure a 0 refcount dentry remains 0 without dcache_lock. It is also
> fairly natural when we start protecting many other dentry members with
> d_lock.

> +struct dentry *dget_parent(struct dentry *dentry)
> +{
> +       struct dentry *ret;
> +
> +repeat:
> +       spin_lock(&dentry->d_lock);
> +       ret = dentry->d_parent;
> +       if (!ret)
> +               goto out;
> +       if (!spin_trylock(&ret->d_lock)) {
> +               spin_unlock(&dentry->d_lock);
> +               goto repeat;
> +       }
> +       BUG_ON(!ret->d_count);
> +       ret->d_count++;
> +       spin_unlock(&ret->d_lock);
> +out:
> +       spin_unlock(&dentry->d_lock);
> +       return ret;
> +}
> +EXPORT_SYMBOL(dget_parent);


> Index: linux-2.6/fs/notify/inotify/inotify.c
> ===================================================================
> --- linux-2.6.orig/fs/notify/inotify/inotify.c
> +++ linux-2.6/fs/notify/inotify/inotify.c
> @@ -339,18 +339,26 @@ void inotify_dentry_parent_queue_event(s
>        if (!(dentry->d_flags & DCACHE_INOTIFY_PARENT_WATCHED))
>                return;
>
> +again:
>        spin_lock(&dentry->d_lock);
>        parent = dentry->d_parent;
> +       if (!spin_trylock(&parent->d_lock)) {
> +               spin_unlock(&dentry->d_lock);
> +               goto again;
> +       }
>        inode = parent->d_inode;
>
>        if (inotify_inode_watched(inode)) {
> -               dget(parent);
> +               dget_dlock(parent);
>                spin_unlock(&dentry->d_lock);
> +               spin_unlock(&parent->d_lock);
>                inotify_inode_queue_event(inode, mask, cookie, name,
>                                          dentry->d_inode);
>                dput(parent);
> -       } else
> +       } else {
>                spin_unlock(&dentry->d_lock);
> +               spin_unlock(&parent->d_lock);
> +       }

I don't think I understand why in both of these cases you don't need
to check for dentry->d_parent == dentry

> Index: linux-2.6/fs/notify/fsnotify.c
> ===================================================================
> --- linux-2.6.orig/fs/notify/fsnotify.c
> +++ linux-2.6/fs/notify/fsnotify.c
> @@ -87,13 +87,18 @@ void __fsnotify_parent(struct dentry *de
>        if (!(dentry->d_flags & DCACHE_FSNOTIFY_PARENT_WATCHED))
>                return;
>
> +again:
>        spin_lock(&dentry->d_lock);
>        parent = dentry->d_parent;
> +       if (parent != dentry && !spin_trylock(&parent->d_lock)) {
> +               spin_unlock(&dentry->d_lock);
> +               goto again;
> +       }
>        p_inode = parent->d_inode;
>
>        if (fsnotify_inode_watches_children(p_inode)) {
>                if (p_inode->i_fsnotify_mask & mask) {
> -                       dget(parent);
> +                       dget_dlock(parent);
>                        send = true;
>                }
>        } else {

And yet in this case we do check for dentry->d_parent == dentry.  (my
unknowing self thinks we'd want to check in all places)

-Eric
