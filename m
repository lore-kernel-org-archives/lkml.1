Return-Path: <linux-kernel-owner+w=401wt.eu-S1759946AbXIZQOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759946AbXIZQOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 12:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbXIZQOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 12:14:39 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:41908 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbXIZQOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 12:14:38 -0400
Subject: Re: missing mnt_drop_write() on open error
From: Dave Hansen <haveblue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <E1IaSPW-0005M4-00@dorka.pomaz.szeredi.hu>
References: <E1IaJc0-000541-00@dorka.pomaz.szeredi.hu>
	 <1190769669.26982.325.camel@localhost>
	 <E1IaSPW-0005M4-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Wed, 26 Sep 2007 09:14:32 -0700
Message-Id: <1190823272.30530.16.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-26 at 10:38 +0200, Miklos Szeredi wrote: 
> > On Wed, 2007-09-26 at 01:14 +0200, Miklos Szeredi wrote:
> > > I get this at umount, if there was a failed open():
> > > 
> > > WARNING: at fs/namespace.c:586 __mntput()
> > > 
> > > I think the problem is that may_open() calls mnt_want_write(), but if
> > > open doesn't succeed, mnt_drop_write() will not be called.
> > 
> > Does this help?
> 
> It didn't fix it for me, but the patch looks OK.
> 
> In __dentry_open() there's still a few places where fput() won't be
> called, notably when ->open fails, which is what I'm triggering I
> think.
>
> Also even more horrible things can happen because of the
> nd->intent.open.file thing.  For example if the lookup routine calls
> lookup_instantiate_filp(), and after this, but before may_open() some
> error happens, then release_open_intent() will call fput() on the
> file, which will cause mnt_drop_write() to be called, even though a
> matching mnt_want_write() hasn't yet been called.  Ugly, eh?

I used to have a patch that didn't completely trust that all files with
FMODE_WRITE set to have taken a write on the mnt.  I think I used a flag
to indicate whether or not a particular file had a mnt_want_write() done
on its behalf.  It somewhat artificially keeps the mnt write count
balanced, but I think it will let us detect when things like this go on.

> > I'm also thinking that we should change the open_namei*
> > functions to simply return 'struct file *'.  Those are the only users
> > other than NFS, and forcing the return of a file like that will force
> > users to do the fput() on it if they don't want it any more.  We'd just
> > need to make sure no new may_open() users pop up.  Any thoughts on that?
> 
> Yeah, something needs to be done with open, because currently it's way
> too convoluted.

Sounds like Christoph has some ideas...

-- Dave

