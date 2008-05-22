Return-Path: <linux-kernel-owner+w=401wt.eu-S1765742AbYEVH6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765742AbYEVH6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 03:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759865AbYEVH6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 03:58:30 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:40826 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759141AbYEVH63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 03:58:29 -0400
To: zippel@linux-m68k.org
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
In-reply-to: <Pine.LNX.4.64.0805212232500.18302@localhost.localdomain>
	(message from Roman Zippel on Wed, 21 May 2008 22:35:23 +0200 (CEST))
Subject: Re: [patch 06/14] hfsplus: remove hfsplus_permission()
References: <20080521171458.077908538@szeredi.hu> <20080521171549.964767446@szeredi.hu> <Pine.LNX.4.64.0805212232500.18302@localhost.localdomain>
Message-Id: <E1Jz5gq-0007F4-AQ@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 22 May 2008 09:58:20 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > I'm not sure what this function is trying to achieve, but it's not
> > succeeding: the condition for which it is returning zero is exactly
> > the same as checked by permission(), which results in -EACCES.
> > 
> > So in the end this is equivalent to the default action.
> 
> No, it's not, it allows for HFS+ specific special case to allow the lookup 
> of the resource fork.

Sorry I just don't see how that code would allow anything.  The only
place hfsplus_permission() is called is from permission() in namei.c,
and in that case it _is_ equivalent.  Look:

hfsplus_permission():

	if (S_ISREG(inode->i_mode) && mask & MAY_EXEC && !(inode->i_mode & 0111))
		return 0;

permission():

		retval = inode->i_op->permission(inode, submask, nd);
		if (!retval) {
			/*
			 * Exec permission on a regular file is denied if none
			 * of the execute bits are set.
			 *
			 * This check should be done by the ->permission()
			 * method.
			 */
			if ((mask & MAY_EXEC) && S_ISREG(inode->i_mode) &&
			    !(inode->i_mode & S_IXUGO))
				return -EACCES;

Miklos
