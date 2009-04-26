Return-Path: <linux-kernel-owner+w=401wt.eu-S1753618AbZDZGhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618AbZDZGhK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 02:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbZDZGg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 02:36:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:42814 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117AbZDZGgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 02:36:55 -0400
Date: Sun, 26 Apr 2009 08:36:54 +0200
From: Nick Piggin <npiggin@suse.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 05/27] fs: brlock vfsmount_lock
Message-ID: <20090426063654.GC28555@wotan.suse.de>
References: <20090425012020.457460929@suse.de> <20090425012209.656162021@suse.de> <20090425035040.GW8633@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090425035040.GW8633@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 25, 2009 at 04:50:40AM +0100, Al Viro wrote:
> On Sat, Apr 25, 2009 at 11:20:25AM +1000, npiggin@suse.de wrote:
> 
> [overall: sane idea, but...]
> 
> > +void vfsmount_read_lock(void)
> > +{
> > +	spinlock_t *lock;
> > +
> > +	lock = &get_cpu_var(vfsmount_lock);
> > +	spin_lock(lock);
> > +}
> > +
> > +void vfsmount_read_unlock(void)
> > +{
> > +	spinlock_t *lock;
> > +
> > +	lock = &__get_cpu_var(vfsmount_lock);
> > +	spin_unlock(lock);
> > +	put_cpu_var(vfsmount_lock);
> > +}
> 
> These might be hot enough to be worth inlining, at least in fs/namei.c
> users.  Or not - really needs testing.

Hmm, no you could be right. Most of the code is still OOL in the
spinlock call, so avoiding one level of call chain is probably
going to be a win. I'll see how much it increases code size.

 
> > @@ -68,9 +113,9 @@ static int mnt_alloc_id(struct vfsmount
> >  
> >  retry:
> >  	ida_pre_get(&mnt_id_ida, GFP_KERNEL);
> > -	spin_lock(&vfsmount_lock);
> > +	vfsmount_write_lock();
> >  	res = ida_get_new(&mnt_id_ida, &mnt->mnt_id);
> > -	spin_unlock(&vfsmount_lock);
> > +	vfsmount_write_unlock();
> 
> Yuck.  _Really_ an overkill here.
> 
> >  static void mnt_free_id(struct vfsmount *mnt)
> >  {
> > -	spin_lock(&vfsmount_lock);
> > +	vfsmount_write_lock();
> >  	ida_remove(&mnt_id_ida, mnt->mnt_id);
> > -	spin_unlock(&vfsmount_lock);
> > +	vfsmount_write_unlock();
> >  }
> 
> Ditto.

Yeah, wanted to try going as simple as possible for the first cut.
Shall I just add another spinlock for it?

> Missing: description of when we need it for read/when we need it for write.

OK, I'll work on the documentation.

