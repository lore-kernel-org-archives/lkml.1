Return-Path: <linux-kernel-owner+w=401wt.eu-S1757865AbXISWKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865AbXISWKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 18:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbXISWJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 18:09:56 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:30711 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbXISWJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 18:09:56 -0400
Date: Wed, 19 Sep 2007 15:07:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docuement filesystem helpers for custom 'struct file's
Message-Id: <20070919150724.4e64829a.randy.dunlap@oracle.com>
In-Reply-To: <1190224043.26982.112.camel@localhost>
References: <20070917182718.70494C9B@kernel>
	<20070917182718.A6B9F7FD@kernel>
	<20070919172611.GA20917@infradead.org>
	<1190224043.26982.112.camel@localhost>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007 10:47:23 -0700 Dave Hansen wrote:

> On Wed, 2007-09-19 at 18:26 +0100, Christoph Hellwig wrote:
> > On Mon, Sep 17, 2007 at 11:27:18AM -0700, Dave Hansen wrote:
> > > 
> > > Christoph H. says this stands on its own and can go in before the
> > > rest of the r/o bind mount set.  
> > > 
> > > ---
> > > 
> > > Some filesystems forego the vfs and may_open() and create their
> > > own 'struct file's.
> > > 
> > > This patch creates a couple of helper functions which can be
> > > used by these filesystems, and will provide a unified place
> > > which the r/o bind mount code may patch.
> > > 
> > > Also, rename an existing, static-scope init_file() to a less
> > > generic name.
> > 
> > Looks good.  But please provide a patch ontop of your patchkit to
> > add kernel-doc comments for the two new exported functions.
> 
> Appended.  I started to write the comments to describe the function
> arguments, but they all looked pretty retarded.  

Hi Dave,

They aren't quite in kernel-doc format.  Holler if you need help
with that, or see examples, or
Documentation/kernel-doc-nano-HOWTO.txt.

> > Are there any direct caller of get_empty_filp left after this patch?
> > We really should get rid of that export to stop people from shooting
> > themselves in the foot.
> 
> Yeah, there are a few left.  But, they're in the middle of what is
> sometimes tricky error handling, so I think we should trickle those in
> later. 
> 
> 
> -- Dave
> 
>  lxc-dave/fs/file_table.c |   22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
> 
> diff -puN fs/file_table.c~document fs/file_table.c
> --- lxc/fs/file_table.c~document	2007-09-19 10:31:13.000000000 -0700
> +++ lxc-dave/fs/file_table.c	2007-09-19 10:39:34.000000000 -0700
> @@ -137,6 +137,18 @@ fail:
>  
>  EXPORT_SYMBOL(get_empty_filp);
>  
> +/**
> + * alloc_file - allocate and initialize a 'struct file' with
> + * the given arguments

    * function_name - short description (on one line)
    * @param1: descr1
    * @param2: descr2
  etc.

> + *
> + * Use this instead of get_empty_filp() to get a new
> + * 'struct file'.  Do so because of the same initialization
> + * pitfalls reasons listed for init_file().  This is a
> + * preferred interface to using init_file().
> + *
> + * If all the callers of init_file() are eliminated, its
> + * code should be moved into this function.
> + */
>  struct file *alloc_file(struct vfsmount *mnt, struct dentry *dentry,
>  		mode_t mode, const struct file_operations *fop)
>  {
> @@ -152,7 +164,15 @@ struct file *alloc_file(struct vfsmount 
>  }
>  EXPORT_SYMBOL(alloc_file);
>  
> -/*
> +/**
> + * init_file - initialize a 'struct file'
> + * @file: the already allocated 'struct file' to initialized
> + * @mnt: the vfsmount on which the file resides
> + *
> + * Use this instead of setting the members directly.  Doing so
> + * avoids making mistakes like forgetting the mntget() or
> + * forgetting to take a write on the mnt.
> + *
>   * Note: This is a crappy interface.  It is here to make
>   * merging with the existing users of get_empty_filp()
>   * who have complex failure logic easier.  All users

OK, that one looks better.  :)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
