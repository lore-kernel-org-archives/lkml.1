Return-Path: <linux-kernel-owner+w=401wt.eu-S1755073AbZC2VzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbZC2VzG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 17:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbZC2Vyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 17:54:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42115 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbZC2Vyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 17:54:51 -0400
Date: Sun, 29 Mar 2009 23:48:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Hugh Dickins <hugh@veritas.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Malicki <jmalicki@metacarta.com>, Michael Itz <mitz@metacarta.com>,
       Kenneth Baker <bakerk@metacarta.com>,
       Chris Wright <chrisw@sous-sol.org>, David Howells <dhowells@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] fix setuid sometimes wouldn't
Message-ID: <20090329214855.GA26717@redhat.com>
References: <Pine.LNX.4.64.0903282307050.14892@blonde.anvils> <Pine.LNX.4.64.0903282320271.15432@blonde.anvils> <20090329111958.GA3468@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090329111958.GA3468@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29, Alexey Dobriyan wrote:
>
> On Sat, Mar 28, 2009 at 11:21:27PM +0000, Hugh Dickins wrote:
> >
> > -static struct fs_struct *get_fs_struct(struct task_struct *task)
> > +static int get_fs_path(struct task_struct *task, struct path *path, bool root)
> >  {
> >  	struct fs_struct *fs;
> > +	int result = -ENOENT;
> > +
> >  	task_lock(task);
> >  	fs = task->fs;
> > -	if(fs)
> > -		atomic_inc(&fs->count);
> > +	if (fs) {
> > +		read_lock(&fs->lock);
> > +		*path = root ? fs->root : fs->pwd;
> > +		path_get(path);
> > +		read_unlock(&fs->lock);
> > +		result = 0;
> > +	}
> >  	task_unlock(task);
> > -	return fs;
> > +	return result;
> >  }
>
> I think it's better to open-code. "root" parameter is unnatural.

IMHO, open-coding doesn't improve readability. I am not even talking
about code size (it doesn't matter of course, the kernel is so tiny ;).

Perhaps "enum what" is more natural compared to "bool root", but this
helper is simple enough.

Personally, I think this patch makes sense even if it didn't fix the
bug, it cleanups the code and makes it more readable.

Oleg.

