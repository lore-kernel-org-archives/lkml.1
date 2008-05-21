Return-Path: <linux-kernel-owner+w=401wt.eu-S935815AbYEUTJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935815AbYEUTJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbYEUTJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:09:45 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:37095 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbYEUTJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:09:44 -0400
To: trond.myklebust@fys.uio.no
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
In-reply-to: <1211393793.7486.15.camel@localhost> (message from Trond
	Myklebust on Wed, 21 May 2008 14:16:33 -0400)
Subject: Re: [patch 11/14] vfs: move executable checking into ->permission()
References: <20080521171458.077908538@szeredi.hu>
	 <20080521171557.399850407@szeredi.hu> <1211393793.7486.15.camel@localhost>
Message-Id: <E1Jytgu-00068N-Tp@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 21 May 2008 21:09:36 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +/**
> > + * exec_permission - check for general execute permission on file
> > + * @inode:	inode to check access rights for
> > + * @mask:	right to check for
> > + *
> > + * Exec permission on a regular file is denied if none of the execute
> > + * bits are set.
> > + *
> > + * This needs to be called by filesystems which define a
> > + * ->permission() method, and don't call generic_permission().
> > + */
> > +int exec_permission(struct inode *inode, int mask)
> > +{
> > +	if ((mask & MAY_EXEC) && S_ISREG(inode->i_mode) &&
> > +	    !(inode->i_mode & S_IXUGO))
> > +		return -EACCES;
> > +
> > +	return 0;
> > +}
> 
> Hmm... What if !(mask & MAY_EXEC)? AFAICS, the above will return 0.
> A better approach would be to use something like
> 
> 	if (!(mask & MAY_EXEC))
> 		return -EACCES;
> 	if (S_ISREG(inode->i_mode) && !(inode->i_mode & S_IXUGO))
> 		return -EACCES;
> 	return 0;

No, we don't want to deny read or write (that's up to the filesystem
how it handles it), just want to deny execute if no x bits are set in
the mode.

I didn't really pay attention to individual filesystems, including
NFS, just mechanically moved the check from permission() to
->permission().  So it's possible that the code could be further
optimized in some cases.

Miklos
