Return-Path: <linux-kernel-owner+w=401wt.eu-S1760304AbXFTIxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760304AbXFTIxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 04:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbXFTIxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 04:53:32 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:9110 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbXFTIxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 04:53:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WRQww7kE1ocaVh/Og42aLG/YdKyRrwsJA30+ON4j9lyqyKtR3Iy08Z2UrUQ4VJDiXe/B3iIleJS02mn9/bACG4RIEx789JBns8NNVsaDFz1TWUlp1+GwwQmBJ8cLqF0XFcby+4Gd24kzB0DQh6P9o3MIKPI7iTUqstNCaWjLHdA=
Message-ID: <344eb09a0706200153j3b856dcvb983218714d1eda0@mail.gmail.com>
Date: Wed, 20 Jun 2007 14:23:30 +0530
From: "Bharata B Rao" <bharata.rao@gmail.com>
To: "Jan Blunck" <jblunck@suse.de>
Subject: Re: [RFC PATCH 2/4] Mount changes to support union mount.
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       bharata@linux.vnet.ibm.com
In-Reply-To: <f5am1v$foi$2@sea.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070620055050.GB4267@in.ibm.com>
	 <20070620055241.GD4267@in.ibm.com> <f5am1v$foi$2@sea.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(replying from a different ID as you didn't copy me on reply)

On 6/20/07, Jan Blunck <jblunck@suse.de> wrote:
> On Wed, 20 Jun 2007 11:22:41 +0530, Bharata B Rao wrote:
>
> > +/*
> > + * When propagating mount events to peer group, this is called under
> > + * vfsmount_lock. Hence using GFP_ATOMIC for kmalloc here.
> > + * TODO: Can we use a separate kmem cache for union_mount ?
> > + */
> > +struct union_mount *alloc_union_mount(struct vfsmount *src_mnt,
> > +     struct dentry *src_dentry, struct vfsmount *dst_mnt,
> > +     struct dentry *dst_dentry)
> > +{
> > +     struct union_mount *u;
> > +     u = kmalloc(sizeof(struct union_mount), GFP_ATOMIC);
> > +     if (!u)
> > +             return u;
> > +     u->dst_mnt = mntget(dst_mnt);
> > +     u->dst_dentry = dget(dst_dentry);
> > +     u->src_mnt = src_mnt;
> > +     u->src_dentry = dget(src_dentry);
> > +     INIT_LIST_HEAD(&u->hash);
> > +     INIT_LIST_HEAD(&u->list);
> > +     return u;
> > +}
>
> Hmm, you pin the dentries in memory until umount. This isn't good. Besides
> that this doesn't work with file systems that do invalidate their
> dentries. The file system must have a chance to replace the dentry in the
> union structure.

Yes, both top level and next level dentries are pinned until umount of
the upper layer. I was thinking if we could prune these from
prune_dcache(). What do you think ?

Ok, I haven't thought about filesystem invalidating the dentries. Yet
to understand the dentry invalidation, but would filesystem invalidate
an inuse dentry ?

Regards,
Bharata.
-- 
"Men come and go but mountains remain" -- Ruskin Bond.
