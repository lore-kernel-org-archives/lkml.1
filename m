Return-Path: <linux-kernel-owner+w=401wt.eu-S1030966AbXDRDUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030966AbXDRDUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 23:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031319AbXDRDUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 23:20:11 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:41489 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030966AbXDRDUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 23:20:08 -0400
Date: Wed, 18 Apr 2007 08:57:08 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH  5/15] Introduce union stack
Message-ID: <20070418032708.GA5870@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070417131459.GA4001@in.ibm.com> <20070417131920.GF4001@in.ibm.com> <20070417220848.GA22586@sergelap.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417220848.GA22586@sergelap.austin.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 05:08:48PM -0500, Serge E. Hallyn wrote:
> Quoting Bharata B Rao (bharata@linux.vnet.ibm.com):
> > From: Jan Blunck <j.blunck@tu-harburg.de>
> > Subject: Introduce union stack.
> > 
> > Adds union stack infrastructure to the dentry structure and provides
> > locking routines to walk the union stack.
> > 
> > Signed-off-by: Jan Blunck <j.blunck@tu-harburg.de>
> > Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> > ---
> >  fs/Makefile                  |    2 
> >  fs/dcache.c                  |    5 
> >  fs/union.c                   |   53 +++++++++
> >  include/linux/dcache.h       |   11 +
> >  include/linux/dcache_union.h |  243 +++++++++++++++++++++++++++++++++++++++++++
> >  5 files changed, 314 insertions(+)
> > 
> > --- a/fs/Makefile
> > +++ b/fs/Makefile
> > @@ -49,6 +49,8 @@ obj-$(CONFIG_FS_POSIX_ACL)	+= posix_acl.
> >  obj-$(CONFIG_NFS_COMMON)	+= nfs_common/
> >  obj-$(CONFIG_GENERIC_ACL)	+= generic_acl.o
> > 
> > +obj-$(CONFIG_UNION_MOUNT)	+= union.o
> > +
> >  obj-$(CONFIG_QUOTA)		+= dquot.o
> >  obj-$(CONFIG_QFMT_V1)		+= quota_v1.o
> >  obj-$(CONFIG_QFMT_V2)		+= quota_v2.o
> > --- a/fs/dcache.c
> > +++ b/fs/dcache.c
> > @@ -936,6 +936,11 @@ struct dentry *d_alloc(struct dentry * p
> >  #ifdef CONFIG_PROFILING
> >  	dentry->d_cookie = NULL;
> >  #endif
> > +#ifdef CONFIG_UNION_MOUNT
> > +	dentry->d_overlaid = NULL;
> > +	dentry->d_topmost = NULL;
> > +	dentry->d_union = NULL;
> > +#endif
> >  	INIT_HLIST_NODE(&dentry->d_hash);
> >  	INIT_LIST_HEAD(&dentry->d_lru);
> >  	INIT_LIST_HEAD(&dentry->d_subdirs);
> > --- /dev/null
> > +++ b/fs/union.c
> > @@ -0,0 +1,53 @@
> > +/*
> > + * VFS based union mount for Linux
> > + *
> > + * Copyright ? 2004-2007 IBM Corporation
> > + *   Author(s): Jan Blunck (j.blunck@tu-harburg.de)
> > + *
> > + * This program is free software; you can redistribute it and/or modify it
> > + * under the terms of the GNU General Public License as published by the Free
> > + * Software Foundation; either version 2 of the License, or (at your option)
> > + * any later version.
> > + */
> > +
> > +#include <linux/fs.h>
> > +
> > +struct union_info * union_alloc(void)
> > +{
> > +	struct union_info *info;
> > +
> > +	info = kmalloc(sizeof(*info), GFP_ATOMIC);
> > +	if (!info)
> > +		return NULL;
> > +
> > +	mutex_init(&info->u_mutex);
> > +	mutex_lock(&info->u_mutex);
> > +	atomic_set(&info->u_count, 1);
> > +	UM_DEBUG_LOCK("allocate union %p\n", info);
> > +	return info;
> > +}
> > +
> > +struct union_info * union_get(struct union_info *info)
> > +{
> > +	BUG_ON(!info);
> > +	BUG_ON(!atomic_read(&info->u_count));
> > +	atomic_inc(&info->u_count);
> > +	UM_DEBUG_LOCK("get union %p (count=%d)\n", info,
> > +		      atomic_read(&info->u_count));
> > +	return info;
> > +}
> 
> The locking here needs to be laid out.  It looks like union_get() needs
> to be called under union_lock(), while union_get2() (horrible name)
> grabs that lock itself, and returns with the lock held?
> 
> Similarly union_put clearly needs to be called under union_lock(), so
> that should be commented here.

Agreed. This whole thing needs a fresh look and we need to establish
some rules and consistency here. After you pointed out this, even
union_alloc2() is looking suspect to me. Same goes for union_release()
also. Thanks for pointing this out.

Regards,
Bharata.
