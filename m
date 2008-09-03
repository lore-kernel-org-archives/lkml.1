Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbYICWxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbYICWxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 18:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbYICWxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 18:53:06 -0400
Received: from webmail.mrv.com ([66.43.110.11]:24563 "EHLO
	chmailsrv.int.mrv.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751834AbYICWxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 18:53:05 -0400
Date: Wed, 3 Sep 2008 15:53:02 -0700
From: Nye Liu <nyet@mrv.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nye Liu <nyet@nyet.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] INITRAMFS: Add option to preserve mtime from INITRAMFS
	cpio images
Message-ID: <20080903225302.GA9893@mrv.com>
References: <20080805195232.GA5183@curtisfong.org> <20080903202938.GA9065@curtisfong.org> <20080903152231.6b82d9bf.akpm@linux-foundation.org> <20080903224130.GA16630@curtisfong.org> <20080903154840.69c049cf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080903154840.69c049cf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 03 Sep 2008 22:54:57.0582 (UTC) FILETIME=[167944E0:01C90E18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 03:48:40PM -0700, Andrew Morton wrote:
> On Wed, 3 Sep 2008 15:41:31 -0700
> Nye Liu <nyet@nyet.org> wrote:
> 
> > > >  	collected[N_ALIGN(name_len) + body_len] = '\0';
> > > >  	clean_path(collected, 0);
> > > >  	sys_symlink(collected + N_ALIGN(name_len), collected);
> > > >  	sys_lchown(collected, uid, gid);
> > > > +	do_lutime(collected, &mtime);
> > > >  	state = SkipIt;
> > > >  	next_state = Reset;
> > > >  	return 0;
> > > > @@ -466,6 +520,7 @@ static char * __init unpack_to_rootfs(char *buf, unsigned len, int check_only)
> > > >  		buf += inptr;
> > > >  		len -= inptr;
> > > >  	}
> > > > +	dir_utime();
> > > 
> > > Perhaps this is the simplest implementation - I didn't check the fine
> > > details.  What's your thinking here?  
> > > 
> > 
> > The main problem is that i need to save off the entire list for later
> > processing of the directory mtimes... if i process the directory mtimes
> > in the same pass as the file/link mtimes, touching the directory inode
> > when creating/modifying the file/links updates the directory mtime, and
> > overwrites whatever mtime i set the directory to when i created it.
> > 
> > The only solution is to do a two pass, which is why the list is
> > necessary. If there is a better way, i did not find it :(
> > 
> > It could be that i misunderstood your question though :)
> 
> I'm wondering whether this code need to use `struct utimbuf' at all. 
> Or at least, as much as it does.  utimbuf is more a userspace-facing
> thing whereas in-kernel timespecs and timevals are more common.
> 
> The code as you have it does a fair few conversions into utimbuf format
> (both directly and via the existing functions which it calls).  Would
> it be simpler if it dealt in terms of timespecs?
> 

It could be. Heck, it would be even simpler to just use a single time_t (since
cpio doesn't have timespecs OR seperate atime/mtimes):

static __initdata LIST_HEAD(dir_list);
struct dir_entry {
        struct list_head list;
        char *name;
        time_t mtime;
};

then make a simple wrapper for sys_utime() to convert the time_t into a the
utimbuf:

static void __init do_utime(char *name, time_t mtime)
{
        struct utimbuf time;
        time.actime=time.modtime=mtime;
        sys_utime(name, &time);
}

I can try it that way and resubmit. Gimme a bit to compose a patch

ALSO it disturbs me about the alloc problem you mentioned, especially since
i did NOT TEST on anything but our embedded (ppc/powerpc) target.

-- 
Nye Liu
nliu@mrv.com
(818) 772-6235x248
(818) 772-0576 fax

"Who would be stupid enough to quote a fictitious character?"
	-- Don Quixote
