Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbXDVHFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbXDVHFb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 03:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbXDVHFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 03:05:31 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:57571 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbXDVHFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 03:05:30 -0400
To: ebiederm@xmission.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, serue@us.ibm.com,
       viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
In-reply-to: <m1wt05kgy8.fsf@ebiederm.dsl.xmission.com>
Subject: Re: [patch 1/8] add user mounts to the kernel
References: <20070420102532.385211890@szeredi.hu>
	<20070420102624.975879175@szeredi.hu> <m1wt05kgy8.fsf@ebiederm.dsl.xmission.com>
Message-Id: <E1HfW5I-00044y-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sun, 22 Apr 2007 09:02:08 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > The MNT_USER flag is not copied on any kind of mount cloning:
> > namespace creation, binding or propagation.
> 
> I half agree, and as an initial approximation this works.
> Ultimately we should be at the point that for mount propagation
> that we copy the owner of the from the owner of our parent mount
> at the propagation destination.

Yes, that sounds the most sane.

Ram, what do you think?

> > +	if (mnt->mnt_flags & MNT_USER)
> > +		seq_printf(m, ",user=%i", mnt->mnt_uid);
> How about making the test "if (mnt->mnt_user != &root_user)"

We don't want to treat root_user special.  That's what capabilities
were invented for.

> > Index: linux/include/linux/fs.h
> > ===================================================================
> > --- linux.orig/include/linux/fs.h	2007-04-20 11:55:02.000000000 +0200
> > +++ linux/include/linux/fs.h	2007-04-20 11:55:05.000000000 +0200
> > @@ -123,6 +123,7 @@ extern int dir_notify_enable;
> >  #define MS_SLAVE	(1<<19)	/* change to slave */
> >  #define MS_SHARED	(1<<20)	/* change to shared */
> >  #define MS_RELATIME	(1<<21)	/* Update atime relative to mtime/ctime. */
> > +#define MS_SETUSER	(1<<22) /* set mnt_uid to current user */
> 
> If we unconditionally use the fsuid I think we can get away without
> this flag.

That coudl work if we wouldn't have to worry about breaking the user
interface.  As it is, we cannot be sure, that existing callers of
mount(2) don't have fsuid set to some random value.

> >  #define MNT_SHRINKABLE	0x100
> > +#define MNT_USER	0x200
> 
> If we assign a user to all mount points and root gets to own the
> initial set of mounts then we don't need the internal MNT_USER
> flag.

I think we do want to treat "owned" mounts special, rather than
treating user=0 mounts special.

> > +
> > +	uid_t mnt_uid;			/* owner of the mount */
> 
> Can we please make this a user struct.   That requires a bit of
> reference counting but it has uid namespace benefits as well
> as making it easy to implement per user mount rlimits.

OK, can you ellaborate, what the uid namespace benifits are?

Miklos
