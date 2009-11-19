Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbZKSS2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbZKSS2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 13:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbZKSS2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 13:28:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbZKSS2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 13:28:32 -0500
Date: Thu, 19 Nov 2009 13:28:33 -0500
From: Jeff Layton <jlayton@redhat.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, pavel@ucw.cz
Subject: Re: [PATCH] procfs: make /proc style symlinks behave like "normal"
 symlinks
Message-ID: <20091119132833.30bc93a4@barsoom.rdu.redhat.com>
In-Reply-To: <m14ooq5tq3.fsf@fess.ebiederm.org>
References: <1258638251-20034-1-git-send-email-jlayton@redhat.com>
	<m14ooq5tq3.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Nov 2009 09:07:16 -0800
ebiederm@xmission.com (Eric W. Biederman) wrote:

> 
> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> This is broken.  If the referenced file is in a different mount namespace
> the path returned could point to a completely different path in your
> own mount namespace.  Even in your own mount namespace this makes the
> proc symlinks racy and not guaranteed to return the file of interest.
> 
> I don't see any hope of this approach ever working.
> 
> Eric
> 

Then is proc_pid_readlink broken in the same way?

> 
> Jeff Layton <jlayton@redhat.com> writes:
> 
> > -static int proc_pid_readlink(struct dentry * dentry, char __user * buffer, int buflen)
> > -{
> > -	int error = -EACCES;
> > -	struct inode *inode = dentry->d_inode;
> > +	struct page *page = NULL;
> >  	struct path path;
> > +	int error;
> >  
> >  	/* Are we allowed to snoop on the tasks file descriptors? */
> > -	if (!proc_fd_access_allowed(inode))
> > +	if (!proc_fd_access_allowed(inode)) {
> > +		pathname = ERR_PTR(-EACCES);
> >  		goto out;
> > +	}
> >  
> >  	error = PROC_I(inode)->op.proc_get_link(inode, &path);
> > -	if (error)
> > +	if (error) {
> > +		pathname = ERR_PTR(error);
> >  		goto out;
> > +	}
> > +
> > +	page = alloc_page(GFP_HIGHUSER);
> > +	if (!page) {
> > +		pathname = ERR_PTR(-ENOMEM);
> > +		goto out_path_put;
> > +	}
> > +
> > +	pathname = kmap(page);
> > +	pathname = d_path(&path, pathname, PAGE_SIZE);
> 
> This is just nonsense.
> 

How so? Care to elaborate?

> 
> > +	if (IS_ERR(pathname)) {
> > +		kunmap(page);
> > +		__free_page(page);
> > +		page = NULL;
> > +	}
> >  
> > -	error = do_proc_readlink(&path, buffer, buflen);
> > +out_path_put:
> >  	path_put(&path);
> >  out:
> > -	return error;
> > +	nd_set_link(nd, pathname);
> > +	return page;
> > +}


-- 
Jeff Layton <jlayton@redhat.com>
