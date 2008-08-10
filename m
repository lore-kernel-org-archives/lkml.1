Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbYHJNwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbYHJNwp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 09:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbYHJNwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 09:52:36 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58909 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbYHJNwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 09:52:35 -0400
In-Reply-To: <20080809185340.GC22905@infradead.org>
References: <20080808184349.999902616@linux.vnet.ibm.com> <1218221761.4444.13.camel@localhost.localdomain> <20080809185340.GC22905@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com,
       Mimi Zohar <zohar@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/4] integrity: Linux Integrity Module(LIM)
X-KeepSent: 0AEBDCA2:1E27B823-852574A1:000FEE48;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.0.1 February 07, 2008
Message-ID: <OF0AEBDCA2.1E27B823-ON852574A1.000FEE48-852574A1.004C3185@us.ibm.com>
From: Mimi Zohar <zohar@us.ibm.com>
Date: Sun, 10 Aug 2008 09:52:13 -0400
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Build V85_M1_05262008|May 26, 2008) at
 08/10/2008 09:52:13,
	Serialize complete at 08/10/2008 09:52:13
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> wrote on 08/09/2008 02:53:40 PM:

> > +      if (integrity_inode_alloc(inode)) {
> > +         if (inode->i_sb->s_op->destroy_inode)
> > +            inode->i_sb->s_op->destroy_inode(inode);
> > +         else
> > +            kmem_cache_free(inode_cachep, (inode));
> > +         return NULL;
> > +      }
> > +
> 
> Please factor this and the lsm failure case out into a single
> out_free_inode goto label.

ok

> >  int vfs_permission(struct nameidata *nd, int mask)
> >  {
> > -   return inode_permission(nd->path.dentry->d_inode, mask);
> > +   int retval;
> > +
> > +   retval = inode_permission(nd->path.dentry->d_inode, mask);
> > +   if (retval)
> > +      return retval;
> > +   return integrity_inode_permission(NULL, &nd->path,
> > +                 mask & (MAY_READ | MAY_WRITE |
> > +                    MAY_EXEC));
> >  }
> > 
> >  /**
> > @@ -306,7 +314,14 @@ int vfs_permission(struct nameidata *nd,
> >   */
> >  int file_permission(struct file *file, int mask)
> >  {
> > -   return inode_permission(file->f_path.dentry->d_inode, mask);
> > +   int retval;
> > +
> > +   retval = inode_permission(file->f_path.dentry->d_inode, mask);
> > +   if (retval)
> > +      return retval;
> > +   return integrity_inode_permission(file, NULL,
> > +                 mask & (MAY_READ | MAY_WRITE |
> > +                    MAY_EXEC));
> 
> Please put your hook into inode_permission.  Note that in inode
> permission and lots of callers there is no path available so don't pass
> it.  Please pass the full MAY_FOO mask for new interfaces and do
> filtering that won't break if new ones are introduced.
 
We started out with the integrity_inode_permission() hook call in 
inode_permission(), but because of the removal of the nameidata 
parameter in the last merge, based on discussions
http://marc.info/?l=linux-security-module&m=121797845308246&w=2,
the call to integrity_inode_permission() was moved up to the caller,
where either a file or path are available.  Any suggestions?
 
> > +#ifdef CONFIG_INTEGRITY
> > +   void         *i_integrity;
> > +#endif
> 
> Sorry, but I don't think we can bloat the inode even further for this.

The original version of IMA was LSM based, using i_security. Based
on discussions on the LSM mailing list, it was decided that the LSM hooks
were meant only for access control.  During the same time frame, there 
was a lot of work done in stacking LSM modules and i_security, but that
approach was dropped. It was suggested that we define a separate set of
hooks for integrity, which this patch set provides. Caching integrity 
results is an important aspect. Any suggestions in lieu of defining 
i_integrity?

> > +/*
> > + * integrity.h
> 
> don't bother to mention the filename in the top of file comment.
 
ok

Mimi
