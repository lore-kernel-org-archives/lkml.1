Return-Path: <linux-kernel-owner+w=401wt.eu-S1761729AbZEAN2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761729AbZEAN2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 09:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761417AbZEAN2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 09:28:31 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:56800 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761026AbZEAN23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 09:28:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hrw7jGnazxFdwVNyJ2X5lchZ1P4rt5OL8/uEapC9G8QRlx+9Fb5d9RzoxAOqrXjzyk
         KvQ73gJ+VBs6zmeR2ntPdFRM1qQXtqb36GbSEJTYe3OiL4I6wu8XDobH3IMfIzT7hsDk
         gU6r1FAyaedv15lxrickWeev7aGSQc7Gc79x0=
Date: Fri, 1 May 2009 15:28:25 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Alessio Igor Bogani <abogani@texware.it>,
       Jonathan Corbet <corbet@lwn.net>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/6] kill-the-BKL/reiserfs: release write lock on
	fs_changed()
Message-ID: <20090501132825.GE6011@nowhere>
References: <1241145862-21700-1-git-send-email-fweisbec@gmail.com> <1241145862-21700-2-git-send-email-fweisbec@gmail.com> <878wlhpc5r.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878wlhpc5r.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 08:31:12AM +0200, Andi Kleen wrote:
> Frederic Weisbecker <fweisbec@gmail.com> writes:
> >
> > diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
> > index 6587b4e..397d281 100644
> > --- a/include/linux/reiserfs_fs.h
> > +++ b/include/linux/reiserfs_fs.h
> > @@ -1302,7 +1302,13 @@ static inline loff_t max_reiserfs_offset(struct inode *inode)
> >  #define get_generation(s) atomic_read (&fs_generation(s))
> >  #define FILESYSTEM_CHANGED_TB(tb)  (get_generation((tb)->tb_sb) != (tb)->fs_gen)
> >  #define __fs_changed(gen,s) (gen != get_generation (s))
> > -#define fs_changed(gen,s) ({cond_resched(); __fs_changed(gen, s);})
> > +#define fs_changed(gen,s)		\
> > +({					\
> > +	reiserfs_write_unlock(s);	\
> > +	cond_resched();			\
> > +	reiserfs_write_lock(s);		\
> 
> Did you try writing that 
> 
>     if (need_resched()) {               \
> 	reiserfs_write_unlock(s);	\
> 	cond_resched();			\  (or schedule(), but cond_resched does a loop)
> 	reiserfs_write_lock(s);		\
>     }				
> 
> ? That might give better performance under load because users will be better
> batched and you don't release the lock unnecessarily in the unloaded case.



Good catch!
And I guess this pattern matches most of the cond_resched()
all over the code (the only condition is that we must already hold
the write lock).

I will merge your idea and Ingo's one, write a
reiserfs_cond_resched() to have a helper which
factorizes this pattern.

Thanks.


 
> -Andi
> 
> -- 
> ak@linux.intel.com -- Speaking for myself only.

