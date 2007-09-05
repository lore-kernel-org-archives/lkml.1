Return-Path: <linux-kernel-owner+w=401wt.eu-S932319AbXIEQHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319AbXIEQHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 12:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756874AbXIEQG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 12:06:57 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55710 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756821AbXIEQG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 12:06:56 -0400
Date: Wed, 5 Sep 2007 09:05:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org, christian.mandery@sap.com,
       amy.griffis@hp.com, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: Race in the inotify debug code
Message-Id: <20070905090547.1bd50b33.akpm@linux-foundation.org>
In-Reply-To: <46CDA6DE.6010102@redhat.com>
References: <46CDA6DE.6010102@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 23 Aug 2007 11:25:18 -0400 Chuck Ebbert <cebbert@redhat.com> wrote:
> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=248355
> 
> Description of problem:
> Warnings in the kernel log (dmesg):
> BUG: warning at fs/inotify.c:172/set_dentry_child_flags() (Not tainted)
>  [<c0497a37>] set_dentry_child_flags+0x67/0x13d
>  [<c0497c27>] remove_watch_no_event+0x2f/0x3b
>  [<c0497d15>] inotify_remove_watch_locked+0x12/0x3e
>  [<c0600c17>] mutex_lock+0x1a/0x29
>  [<c0497fdd>] inotify_rm_wd+0x6d/0x8a
>  [<c04983b1>] sys_inotify_rm_watch+0x38/0x4f
>  [<c0404f70>] syscall_call+0x7/0xb
> 
> Appears randomly, about every second/third day.
> 
> Still happening in kernel 2.6.22.
> 
> 
> static void set_dentry_child_flags(struct inode *inode, int watched)
> ...
>         spin_lock(&dcache_lock);
>         list_for_each_entry(alias, &inode->i_dentry, d_alias) {
>                 struct dentry *child;
> 
>                 list_for_each_entry(child, &alias->d_subdirs, d_u.d_child) {
>                         if (!child->d_inode) {
>                                 WARN_ON(child->d_flags & DCACHE_INOTIFY_PARENT_WATCHED);
>                                 continue;
>                         }
> 
> But in dcache.c, the locks are dropped before this flag is cleared, leaving
> a race window:
> 
> void d_delete(struct dentry * dentry)
> ...
>         spin_lock(&dcache_lock);
>         spin_lock(&dentry->d_lock);
>         isdir = S_ISDIR(dentry->d_inode->i_mode);
>         if (atomic_read(&dentry->d_count) == 1) {
>                 dentry_iput(dentry);  <================ drops dcache_lock and dentry->d_lock
>                 fsnotify_nameremove(dentry, isdir);
> 
>                 /* remove this and other inotify debug checks after 2.6.18 */
>                 dentry->d_flags &= ~DCACHE_INOTIFY_PARENT_WATCHED;
>                 return;
>         }
> 
> (The comment is nice, it says the debug code should have been removed long ago.)

We've been chasing this bug for a year or so.  Thanks for maybe-solving it.
I forwarded your email to Nick a few days ago but he's presently tied up
with kernel slummit.  Please let us not forget about this?
