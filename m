Return-Path: <linux-kernel-owner+w=401wt.eu-S1758466AbXFUQkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758466AbXFUQkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 12:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbXFUQk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 12:40:26 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:38548 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797AbXFUQkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 12:40:24 -0400
Date: Thu, 21 Jun 2007 12:40:20 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Bharata B Rao <bharata.rao@gmail.com>
Cc: Jan Blunck <jblunck@suse.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 2/4] Mount changes to support union mount.
Message-ID: <20070621164020.GB9457@filer.fsl.cs.sunysb.edu>
References: <20070620055050.GB4267@in.ibm.com> <20070620055241.GD4267@in.ibm.com> <f5am1v$foi$2@sea.gmane.org> <344eb09a0706200153j3b856dcvb983218714d1eda0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <344eb09a0706200153j3b856dcvb983218714d1eda0@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 02:23:30PM +0530, Bharata B Rao wrote:
> (replying from a different ID as you didn't copy me on reply)
> 
> On 6/20/07, Jan Blunck <jblunck@suse.de> wrote:
> >On Wed, 20 Jun 2007 11:22:41 +0530, Bharata B Rao wrote:
> >
> >> +/*
> >> + * When propagating mount events to peer group, this is called under
> >> + * vfsmount_lock. Hence using GFP_ATOMIC for kmalloc here.
> >> + * TODO: Can we use a separate kmem cache for union_mount ?
> >> + */
> >> +struct union_mount *alloc_union_mount(struct vfsmount *src_mnt,
> >> +     struct dentry *src_dentry, struct vfsmount *dst_mnt,
> >> +     struct dentry *dst_dentry)
> >> +{
> >> +     struct union_mount *u;
> >> +     u = kmalloc(sizeof(struct union_mount), GFP_ATOMIC);
> >> +     if (!u)
> >> +             return u;
> >> +     u->dst_mnt = mntget(dst_mnt);
> >> +     u->dst_dentry = dget(dst_dentry);
> >> +     u->src_mnt = src_mnt;
> >> +     u->src_dentry = dget(src_dentry);
> >> +     INIT_LIST_HEAD(&u->hash);
> >> +     INIT_LIST_HEAD(&u->list);
> >> +     return u;
> >> +}
> >
> >Hmm, you pin the dentries in memory until umount. This isn't good. Besides
> >that this doesn't work with file systems that do invalidate their
> >dentries. The file system must have a chance to replace the dentry in the
> >union structure.
> 
> Yes, both top level and next level dentries are pinned until umount of
> the upper layer. I was thinking if we could prune these from
> prune_dcache(). What do you think ?
> 
> Ok, I haven't thought about filesystem invalidating the dentries. Yet
> to understand the dentry invalidation, but would filesystem invalidate
> an inuse dentry ?
 
NFS, and quite possibly other network/cluster filesystems can encounter all
sort of odd conditions where the dentry might change, no?

Josef "Jeff" Sipek.

-- 
Hegh QaQ law'
quvHa'ghach QaQ puS
