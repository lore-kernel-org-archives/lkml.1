Return-Path: <linux-kernel-owner+w=401wt.eu-S1763529AbYGBHYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763529AbYGBHYG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 03:24:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762983AbYGBHXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 03:23:09 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50576 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762957AbYGBHXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 03:23:07 -0400
To: jmorris@namei.org
CC: miklos@szeredi.hu, jjohansen@suse.de, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       serue@us.ibm.com, morgan@kernel.org
In-reply-to: <Xine.LNX.4.64.0807021604120.26138@us.intercode.com.au> (message
	from James Morris on Wed, 2 Jul 2008 16:12:44 +1000 (EST))
Subject: Re: [patch] security: fix dummy xattr functions
References: <E1KDmeW-0006KB-2x@pomaz-ex.szeredi.hu> <Xine.LNX.4.64.0807021604120.26138@us.intercode.com.au>
Message-Id: <E1KDwg7-0007OX-5D@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 02 Jul 2008 09:22:59 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2008, James Morris wrote:
> On Tue, 1 Jul 2008, Miklos Szeredi wrote:
> 
> > Hi James,
> > 
> > If this (untested) patch looks OK, could you please apply it to your
> > tree?
> 
> As I understand it, filesystem capabilities is only enabled when either 
> LSM is disabled, or the LSM capabilities module is built.
> 
> In both cases, security/commoncap.o is built.  With LSM disabled, the 
> correct cap_inode_xxx functions will be linked.  With LSM+capabilities, 
> either the capability LSM will be loaded, or another LSM will need to 
> deliberately stack it.
> 
> So, I think the existing code is correct.

So where do the dummy_ functions figure into this?  As I understand,
they are called whenever LSM is disabled, but the LSM doesn't define a
particular hook, so there's a default implementation.  Is that correct?

If so, then in theory it is still theoretically possible that with
LSM+capabilities, the LSM doesn't explicitly stack inode_setxattr and
inode_removexattr, and so the dummy implementation should do that
instead.  What am I missing?

Thanks,
Miklos

> 
> > 
> > Replace open coded xattr checks with cap_inode_xxx() function calls in
> > dummy_inode_setxattr() and dummy_inode_removexattr().  The old ones
> > were out of sync with the cap_inode_xxx() implementation, which could
> > even be a security problem.
> > 
> > Noticed by John Johansen.
> > 
> > CC: John Johansen <jjohansen@suse.de>
> > Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> > ---
> >  security/dummy.c |   12 ++----------
> >  1 file changed, 2 insertions(+), 10 deletions(-)
> > 
> > Index: linux-2.6/security/dummy.c
> > ===================================================================
> > --- linux-2.6.orig/security/dummy.c	2008-07-01 21:44:03.000000000 +0200
> > +++ linux-2.6/security/dummy.c	2008-07-01 21:51:08.000000000 +0200
> > @@ -370,11 +370,7 @@ static void dummy_inode_delete (struct i
> >  static int dummy_inode_setxattr (struct dentry *dentry, const char *name,
> >  				 const void *value, size_t size, int flags)
> >  {
> > -	if (!strncmp(name, XATTR_SECURITY_PREFIX,
> > -		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
> > -	    !capable(CAP_SYS_ADMIN))
> > -		return -EPERM;
> > -	return 0;
> > +	return cap_inode_setxattr(dentry, name, value, size, flags);
> >  }
> >  
> >  static void dummy_inode_post_setxattr (struct dentry *dentry, const char *name,
> > @@ -395,11 +391,7 @@ static int dummy_inode_listxattr (struct
> >  
> >  static int dummy_inode_removexattr (struct dentry *dentry, const char *name)
> >  {
> > -	if (!strncmp(name, XATTR_SECURITY_PREFIX,
> > -		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
> > -	    !capable(CAP_SYS_ADMIN))
> > -		return -EPERM;
> > -	return 0;
> > +	return cap_inode_removexattr(dentry, name);
> >  }
> >  
> >  static int dummy_inode_need_killpriv(struct dentry *dentry)
> > 
> 
> -- 
> James Morris
> <jmorris@namei.org>
> 
