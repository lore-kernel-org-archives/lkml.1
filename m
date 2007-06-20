Return-Path: <linux-kernel-owner+w=401wt.eu-S1762064AbXFTI5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762064AbXFTI5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 04:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755035AbXFTI4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 04:56:53 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:2080 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbXFTI4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 04:56:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qitxAJFRtztEr6L8EJvBo3XD8wmC1B9F+SeL2zx/Y1GRW7WGT6pN1rrgBaHwHEx82jiE9SnDV9+FxyOuiUTIRTKeoH/JoaJKgjiJzDY7ouoxRcAkw5cs+mM4sizogPn+pMs4lg8XUXDbnFeaDqjX5ANKVaoD/hgsfkwUrmOUIdw=
Message-ID: <344eb09a0706200156l2d22ac65o49b893aa29b17291@mail.gmail.com>
Date: Wed, 20 Jun 2007 14:26:52 +0530
From: "Bharata B Rao" <bharata.rao@gmail.com>
To: "Jan Blunck" <jblunck@suse.de>
Subject: Re: [RFC PATCH 3/4] Lookup changes to support union mount.
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <f5amau$foi$3@sea.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070620055050.GB4267@in.ibm.com>
	 <20070620055326.GE4267@in.ibm.com> <f5amau$foi$3@sea.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/20/07, Jan Blunck <jblunck@suse.de> wrote:
> On Wed, 20 Jun 2007 11:23:26 +0530, Bharata B Rao wrote:
>
> > +/*
> > + * Looks for the given @name in dcache by walking through all the layers
> > + * of the union stack, starting from the top.
> > + * FIXME: If we don't find the dentry in a upper layer, we descend to the
> > + * next layer. So there is a chance to miss this dentry in the top layer
> > + * if this is the _first_ time lookup of the dentry in this layer. A real
> > + * lookup might have fetched a valid dentry in this layer itself, while we
> > + * chose to descend to the next lower layer. One solution is not have this
> > + * function itself, do the toplevel lookup in dcache and if it fails proceed
> > + * to real_lookup_union() directly.
> > + */
> > +struct dentry *__d_lookup_union(struct nameidata *nd, struct qstr *name)
> > +{
> > +     struct dentry *dentry;
> > +     struct nameidata nd_tmp;
> > +     struct vfsmount *mnt = mntget(nd->mnt);
> > +     struct qstr this;
> > +     int err;
> > +
> > +     nd_tmp.mnt = nd->mnt;
> > +     nd_tmp.dentry = nd->dentry;
> > +
> > +     this.name = name->name;
> > +     this.len = name->len;
> > +     this.hash = name->hash;
> > +
> > +     do {
> > +             /* d_hash() is a repetition for the top layer. */
> > +             if (nd_tmp.dentry->d_op && nd_tmp.dentry->d_op->d_hash) {
> > +                     err = nd_tmp.dentry->d_op->d_hash(nd_tmp.dentry, &this);
> > +                     if (err < 0)
> > +                             goto out;
> > +             }
> > +
> > +             dentry = __d_lookup(nd_tmp.dentry, &this);
> > +             if (dentry) {
> > +                     if (dentry->d_inode) {
> > +                             if (nd->mnt != nd_tmp.mnt) {
> > +                                     mntput(nd->mnt);
> > +                                     nd->mnt = mntget(nd_tmp.mnt);
> > +                             }
> > +                             mntput(mnt);
> > +                             return dentry;
> > +                     } else {
> > +                             dput(dentry);
> > +                     }
> > +             }
> > +     } while (next_union_mount(&nd_tmp));
> > +out:
> > +     mntput(mnt);
> > +     return NULL;
> > +}
> > +
>
> The reference counting for vfsmount is wrong. next_union_mount() should be
> something similar to follow_down(). You should grab the reference to the
> underlying mount before doing the lookup. Ok ok, you already have a valid
> reference in struct union_mount but anyway.

The idea is that a reference to the top layer's vfsmount and dentry is
taken by the user of the union mount point/directory (eg. lookup,
readdir etc) and that should ensure that all the bottom layers are
valid until the top level reference is held.

Regards,
Bharata.
-- 
"Men come and go but mountains remain" -- Ruskin Bond.
