Return-Path: <linux-kernel-owner+w=401wt.eu-S932919AbXIGP66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932919AbXIGP66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 11:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932334AbXIGP6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 11:58:50 -0400
Received: from 81-86-72-125.dsl.pipex.com ([81.86.72.125]:26498 "EHLO
	nick.local0.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755313AbXIGP6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 11:58:49 -0400
X-Greylist: delayed 1757 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Sep 2007 11:58:48 EDT
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Race in the inotify debug code
Date: Sat, 8 Sep 2007 11:27:06 +1000
User-Agent: KMail/1.9.5
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       christian.mandery@sap.com, amy.griffis@hp.com
References: <46CDA6DE.6010102@redhat.com> <20070905090547.1bd50b33.akpm@linux-foundation.org>
In-Reply-To: <20070905090547.1bd50b33.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709081127.06652.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 September 2007 02:05, Andrew Morton wrote:
> > On Thu, 23 Aug 2007 11:25:18 -0400 Chuck Ebbert <cebbert@redhat.com>
> > wrote: https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=248355
> >
> > Description of problem:
> > Warnings in the kernel log (dmesg):
> > BUG: warning at fs/inotify.c:172/set_dentry_child_flags() (Not tainted)
> >  [<c0497a37>] set_dentry_child_flags+0x67/0x13d
> >  [<c0497c27>] remove_watch_no_event+0x2f/0x3b
> >  [<c0497d15>] inotify_remove_watch_locked+0x12/0x3e
> >  [<c0600c17>] mutex_lock+0x1a/0x29
> >  [<c0497fdd>] inotify_rm_wd+0x6d/0x8a
> >  [<c04983b1>] sys_inotify_rm_watch+0x38/0x4f
> >  [<c0404f70>] syscall_call+0x7/0xb
> >
> > Appears randomly, about every second/third day.
> >
> > Still happening in kernel 2.6.22.
> >
> >
> > static void set_dentry_child_flags(struct inode *inode, int watched)
> > ...
> >         spin_lock(&dcache_lock);
> >         list_for_each_entry(alias, &inode->i_dentry, d_alias) {
> >                 struct dentry *child;
> >
> >                 list_for_each_entry(child, &alias->d_subdirs,
> > d_u.d_child) { if (!child->d_inode) {
> >                                 WARN_ON(child->d_flags &
> > DCACHE_INOTIFY_PARENT_WATCHED); continue;
> >                         }
> >
> > But in dcache.c, the locks are dropped before this flag is cleared,
> > leaving a race window:
> >
> > void d_delete(struct dentry * dentry)
> > ...
> >         spin_lock(&dcache_lock);
> >         spin_lock(&dentry->d_lock);
> >         isdir = S_ISDIR(dentry->d_inode->i_mode);
> >         if (atomic_read(&dentry->d_count) == 1) {
> >                 dentry_iput(dentry);  <================ drops dcache_lock
> > and dentry->d_lock fsnotify_nameremove(dentry, isdir);
> >
> >                 /* remove this and other inotify debug checks after
> > 2.6.18 */ dentry->d_flags &= ~DCACHE_INOTIFY_PARENT_WATCHED; return;
> >         }
> >
> > (The comment is nice, it says the debug code should have been removed
> > long ago.)
>
> We've been chasing this bug for a year or so.  Thanks for maybe-solving it.
> I forwarded your email to Nick a few days ago but he's presently tied up
> with kernel slummit.  Please let us not forget about this?


There is some race in the debug code, yes, but I think there could also be
a real race in there too. I've posted a trial patch for it in one of the other
inotify bug reports.

Anyway, yes I'm inclined to just fix that and rip out the debug code. OTOH,
I have been trying to get some tester to reproduce with patches and had
no takers as yet...

BTW, I will be away for the next few weeks so I'll be going slower than usual
