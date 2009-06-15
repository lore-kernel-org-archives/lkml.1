Return-Path: <linux-kernel-owner+w=401wt.eu-S934826AbZFOWKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934826AbZFOWKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 18:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754947AbZFOWKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 18:10:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:4150 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617AbZFOWKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 18:10:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ocODNzMMhsO03Y1E3tHRK/xc4/HE8+PDAXaj1ExdjHDucQDEbIR+K/yrJrrjpwkZQ8
         JZLqRSkPvQeZEbXG/Jiq4abhq+1YSSIjv1T/Sb6ZV4p1SjBHDZfsOfb6N2MPYoERmiKg
         3OJljKzsnMwizvQempNAHrRnznp0nh4UZ2WzM=
Date: Tue, 16 Jun 2009 02:10:32 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Matt Helsley <matthltc@us.ibm.com>, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, mingo@elte.hu, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/9] exec_path 1/9: introduce ->exec_path and switch
	/proc/*/exe
Message-ID: <20090615221032.GA4884@x200.localdomain>
References: <20090526113618.GJ28083@us.ibm.com> <20090526162415.fb9cefef.akpm@linux-foundation.org> <20090531215427.GA29534@x200.localdomain> <20090531151953.8f8b14b5.akpm@linux-foundation.org> <20090603230422.GB853@x200.localdomain> <20090606072244.GA13497@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090606072244.GA13497@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 06, 2009 at 08:22:44AM +0100, Al Viro wrote:
> On Thu, Jun 04, 2009 at 03:04:22AM +0400, Alexey Dobriyan wrote:
> > diff --git a/fs/binfmt_som.c b/fs/binfmt_som.c
> > index eff74b9..6c56262 100644
> > --- a/fs/binfmt_som.c
> > +++ b/fs/binfmt_som.c
> > @@ -174,6 +174,7 @@ static int map_som_binary(struct file *file,
> >  	up_write(&current->mm->mmap_sem);
> >  	if (retval > 0 || retval < -1024)
> >  		retval = 0;
> > +	set_task_exec_path(current, &bprm->file->f_path);
> 
> Oh?  Even on failure exits?

OK.

> > +	if (!path->mnt || !path->dentry)
> > +		return -ENOENT;
> 
> Umm...  I really don't like that.  Note that path with NULL vfsmount
> and non-NULL dentry should never happen.  If anything, we ought
> to add path_empty(path) (!(path)->mnt) and convert such places to it.

Why mntget/mntput handle NULL vfsmount?

> > +static inline void set_task_exec_path(struct task_struct *tsk, struct path *path)
> > +{
> > +	struct path old_path;
> > +
> > +	path_get(path);
> > +	task_lock(tsk);
> > +	old_path = tsk->exec_path;
> > +	tsk->exec_path = *path;
> > +	task_unlock(tsk);
> > +	path_put(&old_path);
> > +}
> 
> Do we ever have a right to do that to anything other than current?  Note
> that fork() is a special case anyway...

Locking wise? Yes, why not.
 
> > +	set_task_exec_path(tsk, &(struct path){ .mnt = NULL, .dentry = NULL });
> 
> Ew...

:^)

> > +	get_task_exec_path(current, &p->exec_path);
> > +
> 
> We already have that value sitting there, so why not get_path(&p->exec_path)?
> 
> The real problem I have with that we *really* can't umount the filesystem
> that used to host the binary anymore.  At all.

OTOH, you can always answer the question what is executing unless task is
sufficiently dead.

Now, I dont' think anyone unmaps old executable except malicious stuff.

> Frankly, I'm almost tempted to add explicit way to switch the damn thing
> via /proc/self/something - e.g. allow a binary to write a pathname to
> /proc/self/set_exec and have that switch the sucker.  The interesting
> part, of course, is figuring out the security implications of that...

I think nobody will use it.

I think /proc/*/exe should stay informational without task being able
to mangle it at will.
