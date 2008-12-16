Return-Path: <linux-kernel-owner+w=401wt.eu-S1756883AbYLPBxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbYLPBxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 20:53:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYLPBwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 20:52:53 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47288 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbYLPBww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 20:52:52 -0500
Subject: Re: [PATCH 3/3] fsnotify: use the new open-exec hook for inotify
 and dnotify
From: Eric Paris <eparis@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, akpm@linux-foundation.org
In-Reply-To: <20081216100418.06CD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081215164016.2018.4813.stgit@paris.rdu.redhat.com>
	 <20081215164419.2018.11097.stgit@paris.rdu.redhat.com>
	 <20081216100418.06CD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain
Date: Mon, 15 Dec 2008 20:52:45 -0500
Message-Id: <1229392365.23523.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-16 at 10:12 +0900, KOSAKI Motohiro wrote:
> > diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
> > index 88265dd..a7122c6 100644
> > --- a/include/linux/fsnotify.h
> > +++ b/include/linux/fsnotify.h
> > @@ -170,6 +170,12 @@ static inline void fsnotify_modify(struct dentry *dentry)
> >   */
> >  static inline void fsnotify_open_exec(struct file *file)
> >  {
> > +	struct dentry *dentry = file->f_path.dentry;
> > +	struct inode *inode = dentry->d_inode;
> > +
> > +	dnotify_parent(dentry, DN_ACCESS);
> > +	inotify_dentry_parent_queue_event(dentry, IN_ACCESS, 0, dentry->d_name.name);
> > +	inotify_inode_queue_event(inode, IN_ACCESS, 0, NULL, NULL);
> >  }
> 
> Current fsnotify_open() has following code
> 
> 	static inline void fsnotify_open(struct dentry *dentry)
> 	{
> 	        struct inode *inode = dentry->d_inode;
> 	        u32 mask = IN_OPEN;
> 	
> 	        if (S_ISDIR(inode->i_mode))
> 	                mask |= IN_ISDIR;
> 	
> 	        inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
> 	        inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
> 	}
> 
> they are two different.
> 
> 1) Call dnotify_parent() or not
> 2) Use IN_OPEN or IN_ACCESS
> 
> The patch description doesn't explain any reason.
> 
> 
> IOW, IN_ACCESS is usually used by read(). but linux has demand paging
> mechanism. then exec() only do open and mmap.
> actual reading is processed by page fault.
> 
> I guess you have the reason of this design choice.
> but it isn't described.

The original logic was all predicated on my thoughts on how my new
fanotify would want these events and how I felt that open for exec was
worth the separate hook.  None of that is useful at this time and in any
case IN_OPEN makes a lot more sense than IN_ACCESS.  Since you've got me
looking at these as freestanding patchs I do tend to think that the
easiest thing for now would be to just drop patch 2 and make the call
sites from patch 2 call fsnotify_open directly.

I'll resend in the morning a single patch to call directly to
fsnotify_open.  (and another single patch to immediately do the rename
that I want done which I'll send as the full normal diff since it'll be
freestanding)

