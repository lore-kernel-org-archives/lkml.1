Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbYICXbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbYICXbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 19:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYICXbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 19:31:05 -0400
Received: from chmailsrv.int.mrv.com ([66.43.110.11]:26672 "EHLO
	chmailsrv.int.mrv.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751944AbYICXbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 19:31:04 -0400
Date: Wed, 3 Sep 2008 16:30:56 -0700
From: Nye Liu <nyet@mrv.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: nyet@nyet.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] INITRAMFS: Add option to preserve mtime from INITRAMFS
	cpio images
Message-ID: <20080903233056.GA17404@mrv.com>
References: <20080805195232.GA5183@curtisfong.org> <20080903202938.GA9065@curtisfong.org> <20080903152231.6b82d9bf.akpm@linux-foundation.org> <20080903224130.GA16630@curtisfong.org> <20080903154840.69c049cf.akpm@linux-foundation.org> <20080903230430.GA13874@mrv.com> <20080903161955.fef7362e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080903161955.fef7362e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 03 Sep 2008 23:32:51.0658 (UTC) FILETIME=[61EDBAA0:01C90E1D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 04:19:55PM -0700, Andrew Morton wrote:
> On Wed, 3 Sep 2008 16:04:30 -0700
> Nye Liu <nyet@mrv.com> wrote:
> 
> > On Wed, Sep 03, 2008 at 03:48:40PM -0700, Andrew Morton wrote:
> > > On Wed, 3 Sep 2008 15:41:31 -0700
> > > Nye Liu <nyet@nyet.org> wrote:
> > > 
> > > > > >  	collected[N_ALIGN(name_len) + body_len] = '\0';
> > > > > >  	clean_path(collected, 0);
> > > > > >  	sys_symlink(collected + N_ALIGN(name_len), collected);
> > > > > >  	sys_lchown(collected, uid, gid);
> > > > > > +	do_lutime(collected, &mtime);
> > > > > >  	state = SkipIt;
> > > > > >  	next_state = Reset;
> > > > > >  	return 0;
> > > > > > @@ -466,6 +520,7 @@ static char * __init unpack_to_rootfs(char *buf, unsigned len, int check_only)
> > > > > >  		buf += inptr;
> > > > > >  		len -= inptr;
> > > > > >  	}
> > > > > > +	dir_utime();
> > > > > 
> > > > > Perhaps this is the simplest implementation - I didn't check the fine
> > > > > details.  What's your thinking here?  
> > > > > 
> > > > 
> > > > The main problem is that i need to save off the entire list for later
> > > > processing of the directory mtimes... if i process the directory mtimes
> > > > in the same pass as the file/link mtimes, touching the directory inode
> > > > when creating/modifying the file/links updates the directory mtime, and
> > > > overwrites whatever mtime i set the directory to when i created it.
> > > > 
> > > > The only solution is to do a two pass, which is why the list is
> > > > necessary. If there is a better way, i did not find it :(
> > > > 
> > > > It could be that i misunderstood your question though :)
> > > 
> > > I'm wondering whether this code need to use `struct utimbuf' at all. 
> > > Or at least, as much as it does.  utimbuf is more a userspace-facing
> > > thing whereas in-kernel timespecs and timevals are more common.
> > > 
> > > The code as you have it does a fair few conversions into utimbuf format
> > > (both directly and via the existing functions which it calls).  Would
> > > it be simpler if it dealt in terms of timespecs?
> > > 
> > 
> > or maybe this, this one ONLY using do_utimes() and a single wrapper
> > to convert the time_t
> 
> Getting better ;)
> 
> > diff --git a/init/initramfs.c b/init/initramfs.c
> > index 644fc01..1360a67 100644
> > --- a/init/initramfs.c
> > +++ b/init/initramfs.c
> > @@ -6,6 +6,7 @@
> >  #include <linux/delay.h>
> >  #include <linux/string.h>
> >  #include <linux/syscalls.h>
> > +#include <linux/utime.h>
> >  
> >  static __initdata char *message;
> >  static void __init error(char *x)
> > @@ -72,6 +73,51 @@ static void __init free_hash(void)
> >  	}
> >  }
> >  
> > +static long __init do_utime(char __user *filename,
> > +	time_t mtime)
> 
> Please avoid wrapping things which don't need it.

Hard to avoid, unless you want me composing the following every place 
i'm currently calling do_utime():

> > +{
> > +	struct timespec t[2];
> > +
> > +	t[0].tv_sec = mtime;
> > +	t[0].tv_nsec = 0;
> > +	t[1].tv_sec = mtime;
> > +	t[1].tv_nsec = 0;
> 
> Sub-second information is lost.  It'd be nice to preserve it if we're
> going to do this thing.

Can't! cpio isn't that smart!

> 
> > +	return do_utimes(AT_FDCWD, filename, t, AT_SYMLINK_NOFOLLOW);
> > +}
> > +
> > +static __initdata LIST_HEAD(dir_list);
> > +struct dir_entry {
> > +	struct list_head list;
> > +	char *name;
> > +	time_t mtime;
> > +};
> > +
> > +static void __init dir_add(const char *name, time_t mtime)
> > +{
> > +	struct dir_entry *de = kmalloc(sizeof(struct dir_entry), GFP_KERNEL);
> > +	if (!de)
> > +		panic("can't allocate dir_entry buffer");
> > +	INIT_LIST_HEAD(&de->list);
> > +	de->name = kstrdup(name, GFP_KERNEL);
> 
> Alas, kstrdup() can fail too.
> 
> It's all a bit silly checking for kmalloc() failures at this stage in
> the boot process.  Particularly if all we can do is panic - we might as
> well blunder ahead and dereference the NULL pointer, which gives us
> just as much info as the panic.  And there's not much point in handling
> the allocation and continuing the boot, because the system obviously
> won't be booting.
> 
> So it'd be understandable to just omit the error-checking here, despite
> my earlier mentioning of its absence ;)

LOL. You're the boss.

> 
> > +	de->mtime = mtime;
> > +	list_add(&de->list, &dir_list);
> > +}
> > +
> > +static void __init dir_utime(void)
> > +{
> > +	struct list_head *e, *tmp;
> > +	list_for_each_safe(e, tmp, &dir_list) {
> > +		struct dir_entry *de = list_entry(e, struct dir_entry, list);
> 
> could use list_for_each_entry_safe() here.

static void __init dir_utime(void)
{
        struct dir_entry *de, *tmp;
        list_for_each_entry_safe(de, tmp, &dir_list, list) {
                list_del(de);
                do_utime(de->name, de->mtime);
                kfree(de->name);
                kfree(de);
        }
}

something like that? I assume list_del(de) is fine.

> > +		list_del(e);
> > +		do_utime(de->name, de->mtime);
> > +		kfree(de->name);
> > +		kfree(de);
> > +	}
> > +}
> 

-- 
Nye Liu
nliu@mrv.com
(818) 772-6235x248
(818) 772-0576 fax

"Who would be stupid enough to quote a fictitious character?"
	-- Don Quixote
