Return-Path: <linux-kernel-owner+w=401wt.eu-S932994AbXCFH1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994AbXCFH1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 02:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932913AbXCFH1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 02:27:49 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:38342 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932994AbXCFH1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 02:27:48 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 5 Mar 2007 23:27:45 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Avi Kivity <avi@argo.co.il>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] epoll use a single inode ...
In-Reply-To: <45ED046A.5010508@argo.co.il>
Message-ID: <Pine.LNX.4.64.0703052325310.4907@alien.or.mcafeemobile.com>
References: <45ED046A.5010508@argo.co.il>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2007, Avi Kivity wrote:

> >  /* File callbacks that implement the eventpoll file behaviour */
> >  static const struct file_operations eventpoll_fops = {
> >  	.release	= ep_eventpoll_close,
> > @@ -763,15 +767,18 @@
> >  	 * using the inode number.
> >  	 */
> >  	error = -ENOMEM;
> > -	sprintf(name, "[%lu]", inode->i_ino);
> > +	sprintf(name, "[%p]", ep);
> >  	this.name = name;
> >  	this.len = strlen(name);
> > -	this.hash = inode->i_ino;
> > +	this.hash = 0;
> >  	dentry = d_alloc(eventpoll_mnt->mnt_sb->s_root, &this);
> >  	if (!dentry)
> >  		goto eexit_4;
> >  	dentry->d_op = &eventpollfs_dentry_operations;
> > -	d_add(dentry, inode);
> > +	/* Do not publish this dentry inside the global dentry hash table */
> > +	dentry->d_flags &= ~DCACHE_UNHASHED;
> > +	d_instantiate(dentry, inode);
> > +
> >   
> 
> I've used d_alloc_anon() in similar code in kvmfs.  You lose the ep 
> pointer in the name, but as a kernel address it isn't particularly 
> useful to userspace.

That ends up calling two times the find alias for an unhashed dentry, no?
And this linearly scans the inode's dentry list, no?



- Davide


