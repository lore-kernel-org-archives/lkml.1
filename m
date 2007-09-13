Return-Path: <linux-kernel-owner+w=401wt.eu-S932360AbXIMTfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360AbXIMTfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 15:35:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761434AbXIMTe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 15:34:59 -0400
Received: from mail.fieldses.org ([66.93.2.214]:56967 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757830AbXIMTe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 15:34:58 -0400
Date: Thu, 13 Sep 2007 15:34:39 -0400
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Pavel Emelyanov <xemul@openvz.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH] Memory shortage can result in inconsistent flocks state
Message-ID: <20070913193439.GA18052@fieldses.org>
References: <46E68C35.7040001@openvz.org> <46E98F0C.10504@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E98F0C.10504@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 03:27:08PM -0400, Chuck Ebbert wrote:
> On 09/11/2007 08:38 AM, Pavel Emelyanov wrote:
> > diff --git a/fs/locks.c b/fs/locks.c
> > index 0db1a14..f59d066 100644
> > --- a/fs/locks.c
> > +++ b/fs/locks.c
> > @@ -732,6 +732,14 @@ static int flock_lock_file(struct file *
> >  	lock_kernel();
> >  	if (request->fl_flags & FL_ACCESS)
> >  		goto find_conflict;
> > +
> > +	if (request->fl_type != F_UNLCK) {
> > +		error = -ENOMEM;
> > +		new_fl = locks_alloc_lock();
> > +		if (new_fl == NULL)
> > +			goto out;
> > +	}
> > +
> >  	for_each_lock(inode, before) {
> >  		struct file_lock *fl = *before;
> >  		if (IS_POSIX(fl))
> > @@ -753,10 +761,6 @@ static int flock_lock_file(struct file *
> >  		goto out;
> >  	}
> >  
> > -	error = -ENOMEM;
> > -	new_fl = locks_alloc_lock();
> > -	if (new_fl == NULL)
> > -		goto out;
> >  	/*
> >  	 * If a higher-priority process was blocked on the old file lock,
> >  	 * give it the opportunity to lock the file.
> 
> Doesn't that create a leak in some cases?
> 
> >         for_each_lock(inode, before) {
> >                 struct file_lock *fl = *before;
> >                 if (IS_POSIX(fl))
> >                         break;
> >                 if (IS_LEASE(fl))
> >                         continue;
> >                 if (filp != fl->fl_file)
> >                         continue;
> >                 if (request->fl_type == fl->fl_type)
> >                         goto out;  <<<<<<<<<<<<<<<< LEAK?

You mean, a leak of the memory allocated for new_fl?  That's freed at
the exit labeled with "out".  It's the only exit:

	out:
	        unlock_kernel();
		if (new_fl)
			locks_free_lock(new_fl);
		return error;

And new_fl is initially NULL, assigned only once by the allocation, then
assigned to NULL only at the very end when we know we've succeeded.

Am I missing something else?

--b.

> >                 found = 1;
> >                 locks_delete_lock(before);
> >                 break;
> >         }
