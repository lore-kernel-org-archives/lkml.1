Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbZC2WjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbZC2WjE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 18:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbZC2Wiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 18:38:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48552 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbZC2Wit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 18:38:49 -0400
Date: Sun, 29 Mar 2009 23:37:40 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Hugh Dickins <hugh@veritas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Malicki <jmalicki@metacarta.com>, Michael Itz <mitz@metacarta.com>,
       Kenneth Baker <bakerk@metacarta.com>,
       Chris Wright <chrisw@sous-sol.org>, David Howells <dhowells@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] fix setuid sometimes wouldn't
Message-ID: <20090329223740.GK28946@ZenIV.linux.org.uk>
References: <Pine.LNX.4.64.0903282307050.14892@blonde.anvils> <Pine.LNX.4.64.0903282320271.15432@blonde.anvils> <20090329111958.GA3468@x200.localdomain> <20090329214855.GA26717@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090329214855.GA26717@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 29, 2009 at 11:48:55PM +0200, Oleg Nesterov wrote:
> On 03/29, Alexey Dobriyan wrote:
> >
> > On Sat, Mar 28, 2009 at 11:21:27PM +0000, Hugh Dickins wrote:
> > >
> > > -static struct fs_struct *get_fs_struct(struct task_struct *task)
> > > +static int get_fs_path(struct task_struct *task, struct path *path, bool root)
> > >  {
> > >  	struct fs_struct *fs;
> > > +	int result = -ENOENT;
> > > +
> > >  	task_lock(task);
> > >  	fs = task->fs;
> > > -	if(fs)
> > > -		atomic_inc(&fs->count);
> > > +	if (fs) {
> > > +		read_lock(&fs->lock);
> > > +		*path = root ? fs->root : fs->pwd;
> > > +		path_get(path);
> > > +		read_unlock(&fs->lock);
> > > +		result = 0;
> > > +	}
> > >  	task_unlock(task);
> > > -	return fs;
> > > +	return result;
> > >  }
> >
> > I think it's better to open-code. "root" parameter is unnatural.
> 
> IMHO, open-coding doesn't improve readability. I am not even talking
> about code size (it doesn't matter of course, the kernel is so tiny ;).
> 
> Perhaps "enum what" is more natural compared to "bool root", but this
> helper is simple enough.
> 
> Personally, I think this patch makes sense even if it didn't fix the
> bug, it cleanups the code and makes it more readable.

Aye.  Applied, with enum, but an anonymous one; no point breeding
tags without a reason.

Another note: chroot_fs_refs() shouldn't bump refcount at all; it should
do replacements, count them and then do path_release(old_root) that many
times - after having gone through all tasks.

I'm taking fs_struct handling into a new file (fs/fs_struct.c, unless
somebody has a better name), will do that in the same patch.
