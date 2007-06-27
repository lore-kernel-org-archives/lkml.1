Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbXF0AMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbXF0AMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 20:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbXF0ALu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 20:11:50 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:50193 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbXF0ALt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 20:11:49 -0400
Date: Tue, 26 Jun 2007 20:11:41 -0400
Message-Id: <200706270011.l5R0BfPO011424@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: jjohansen@suse.de
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [RFD 1/4] Pass no useless nameidata to the create, lookup, and permission IOPs 
In-reply-to: Your message of "Tue, 26 Jun 2007 16:15:11 PDT."
             <20070626231541.697783295@suse.de> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20070626231541.697783295@suse.de>, jjohansen@suse.de writes:
> The create, lookup, and permission inode operations are all passed a
> full nameidata.  This is unfortunate because in nfsd and the mqueue
> filesystem, we must instantiate a struct nameidata but cannot provide
> all of the same information that a regular lookup would provide.  The
> unused fields take up space on the stack, but more importantly, it is
> not obvious which fields have meaningful values and which don't, and so
> things might easily break.
> 
> This patch introduces struct nameidata2 with only the fields that make
> sense independent of an actual lookup, and uses that struct in those
> places where a full nameidat is not needed.

I agree w/ Trond that a better name is needed other than 'nameidata2',
esp. for something that's a sub-structure (perhaps start it with a '__'?)

These changes would probably help stackable file systems (e.g., eCryptfs and
esp. Unionfs) a lot, b/c stackable f/s often call the lower f/s to lookup
files and such; and in most cases, we just need to pass the intent down, not
the full VFS-level state info.

> +/**
> + * Fields shared between nameidata and nameidata2 -- nameidata2 could
> + * simply be embedded in nameidata, but then the vfs code would become
> + * cluttered with dereferences.
> + */
> +#define __NAMEIDATA2				\
> +	struct dentry	*dentry;		\
> +	struct vfsmount *mnt;			\
> +	unsigned int	flags;			\
> +						\
> +	union {					\
> +		struct open_intent open;	\
> +	} intent;

Perhaps it is also time to put the dentry + mnt into a single struct path?
It's a small change, but it emphasizes that the two items here, dentry+mnt,
really define a single path to be passed around:

#define __NAMEIDATA			\
	struct path path;		\
	unsigned int flags;		\
	...

Of course, you'll have to change instances of nd->dentry to nd->path.dentry
and so on.

Erez.
