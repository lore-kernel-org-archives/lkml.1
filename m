Return-Path: <linux-kernel-owner+w=401wt.eu-S937711AbXHHS5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937711AbXHHS5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 14:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764744AbXHHS5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 14:57:07 -0400
Received: from ns.suse.de ([195.135.220.2]:49796 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764112AbXHHS5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 14:57:06 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Subject: Re: [RFC 04/10] Temporary struct vfs_lookup in file_permission
Date: Wed, 8 Aug 2007 20:56:20 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, John Johansen <jjohansen@suse.de>,
       Jan Blunck <jblunck@suse.de>, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
References: <20070808171622.632749741@suse.de> <20070808171643.922193525@suse.de> <20070808175807.GA31221@filer.fsl.cs.sunysb.edu>
In-Reply-To: <20070808175807.GA31221@filer.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708082056.20442.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 August 2007 19:58, Josef Sipek wrote:
> On Wed, Aug 08, 2007 at 07:16:26PM +0200, Andreas Gruenbacher wrote:
> > Create a temporary struct vfs_lookup in file_permission() instead of
> > passing a NULL value.
> > 
> > Signed-off-by: Andreas Gruenbacher <ag@bestbits.at>
> > 
> > ---
> >  fs/namei.c |   11 ++++++-----
> >  1 file changed, 6 insertions(+), 5 deletions(-)
> > 
> > --- a/fs/namei.c
> > +++ b/fs/namei.c
> > @@ -292,14 +292,15 @@ int vfs_permission(struct vfs_lookup *lo
> >   *
> >   * Used to check for read/write/execute permissions on an already opened
> >   * file.
> > - *
> > - * Note:
> > - *	Do not use this function in new code.  All access checks should
> > - *	be done using vfs_permission().
> 
> Should this comment be removed?

IMO yes. If vfs_permission() works for a piece of code it's the obvious 
preference. If on the other hand you really need to check permissions on a 
file, then why not use this function?

> >   */
> >  int file_permission(struct file *file, int mask)
> >  {
> > -	return permission(file->f_path.dentry->d_inode, mask, NULL);
> > +	struct vfs_lookup lookup;
> > +
> > +	lookup.path = file->f_path;
> > +	lookup.flags = 0;
> 
> I tend to find this little bit cleaner:
> 
> struct vfs_lookup lookup = {
> 	.path	= file->f_path,
> 	.flags	= 0,
> };

I didn't use initializers because they initialize the entire data structure. 
In case of struct vfs_lookup, unless the LOOKUP_OPEN flag is set, then the 
open_intent doesn't need initialization. We could use a DEFINE_... macro; not 
sure this would improve anything though.

> > +
> > +	return permission(file->f_path.dentry->d_inode, mask, &lookup);
> >  }
> >  
> >  /*

Thanks,
Andreas
