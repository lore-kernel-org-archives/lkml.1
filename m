Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858Ab0BQXSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 18:18:14 -0500
Received: from kroah.org ([198.145.64.141]:43002 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757753Ab0BQXSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 18:18:11 -0500
Date: Wed, 17 Feb 2010 14:38:48 -0800
From: Greg KH <greg@kroah.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <gregkh@suse.de>, Neil Brown <neilb@suse.de>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: differentiate  between locking links and
 non-links
Message-ID: <20100217223848.GA31557@kroah.com>
References: <19314.1869.847327.15190@notabene.brown>
 <20100210230625.GB678@suse.de>
 <m1fx57zbyl.fsf@fess.ebiederm.org>
 <20100211223235.GC30430@suse.de>
 <m1bpfvz8wy.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1bpfvz8wy.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 02:47:57PM -0800, Eric W. Biederman wrote:
> Greg KH <gregkh@suse.de> writes:
> 
> > On Thu, Feb 11, 2010 at 01:42:10PM -0800, Eric W. Biederman wrote:
> >> Greg KH <gregkh@suse.de> writes:
> >> 
> >> > On Wed, Feb 10, 2010 at 12:09:33PM +1100, Neil Brown wrote:
> >> >> 
> >> >> Hi,
> >> >>  I've just spent a while sorting out some lockdep complaints triggered
> >> >>  by the recent addition of the "s_active" lockdep annotation in sysfs
> >> >>   (commit 846f99749ab68bbc7f75c74fec305de675b1a1bf)
> >> >> 
> >> >>  Some of them are genuine and I have submitted a fix for those.
> >> >>  Some are, I think, debatable and I get to that is a minute.  I've
> >> >>  submitted a fix for them anyway.
> >> >>  But some are to my mind clearly bogus and I'm hoping that can be
> >> >>  fixed by the change below (or similar).
> >> >>  The 'bogus' ones are triggered by writing to a sysfs attribute file
> >> >>  for which the handler tries to delete a symlink from sysfs.
> >> >>  This appears to be a recursion on s_active as s_active is held while
> >> >>  the handler runs and is again needed to effect the delete.  However
> >> >>  as the thing being deleted is a symlink, it is very clearly a
> >> >>  different object to the thing triggering the delete, so there is no
> >> >>  real loop.
> >> >> 
> >> >>  The following patch splits the lockdep context in two - one for
> >> >>  symlink and one for everything else.  This removes the apparent loop.
> >> >>  (An example report can be seen in
> >> >>      http://bugzilla.kernel.org/show_bug.cgi?id=15142).
> >> >> 
> >> >>  The "debatable" dependency loops happen when writing to one attribute
> >> >>  causes a different attribute to be deleted.  In my (md) case this can
> >> >>  actually cause a deadlock as both the attributes take the same lock
> >> >>  while the handler is running.  This is because deleting the attribute
> >> >>  will block until the all accesses of that attribute have completed (I
> >> >>  think).
> >> >>  However it should be possible to delete a name from sysfs while there
> >> >>  are still accesses pending (it works for normal files!!).  So if
> >> >>  sysfs could be changed to simply unlink the file and leave deletion to
> >> >>  happen when the refcount become zero it would certainly make my life
> >> >>  a lot easier, and allow the removal of some ugly code from md.c.
> >> >>  I don't know sysfs well enough to suggest a patch though.
> >> >> 
> >> >> Thanks,
> >> >> NeilBrown
> >> >> 
> >> >> 
> >> >> 
> >> >> commit 2e502cfe444b68f6ef6b8b2abe83b6112564095b
> >> >> Author: NeilBrown <neilb@suse.de>
> >> >> Date:   Wed Feb 10 09:43:45 2010 +1100
> >> >> 
> >> >>     sysfs: differentiate  between locking links and non-links for sysfs
> >> >>     
> >> >>     symlinks and non-symlink is sysfs are very different.
> >> >>     A symlink can never be locked (active) while an attribute
> >> >>     modification routine is running.  So removing symlink from an
> >> >>     attribute 'store' routine should be permitted without any lockdep
> >> >>     warnings.
> >> >>     
> >> >>     So split the lockdep context for 's_active' in two, one for symlinks
> >> >>     and other for everything else.
> >> >>     
> >> >>     Signed-off-by: NeilBrown <neilb@suse.de>
> >> >
> >> > Nice patch, I'll queue it up for .34.
> >> 
> >> Note the patch does not compile with lockdep disabled.
> >
> > Ugh, why not?
> >
> > Neil, care to fix this up?
> 
>  
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
> -#define sysfs_dirent_init_lockdep(sd)				\
> +#define sysfs_dirent_init_lockdep(sd, type)			\
>  do {								\
>  	static struct lock_class_key __key;			\
>  								\
> -	lockdep_init_map(&sd->dep_map, "s_active", &__key, 0);	\
> +	lockdep_init_map(&sd->dep_map, "s_active_" type, &__key, 0);	\
>  } while(0)
>  #else
>  #define sysfs_dirent_init_lockdep(sd) do {} while(0)

Got it, I've fixed this by hand.

thanks,

greg k-h
