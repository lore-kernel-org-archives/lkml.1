Return-Path: <linux-kernel-owner+w=401wt.eu-S1754924AbZI3Rly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbZI3Rly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 13:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754905AbZI3Rlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 13:41:53 -0400
Received: from cobra.newdream.net ([66.33.216.30]:55071 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906AbZI3Rlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 13:41:51 -0400
Date: Wed, 30 Sep 2009 10:41:55 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       yehuda@newdream.net
Subject: Re: [PATCH 03/21] ceph: client types
In-Reply-To: <20090929165758.1b7df6c9.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0909301040250.16283@cobra.newdream.net>
References: <1253641129-28434-1-git-send-email-sage@newdream.net>
 <1253641129-28434-2-git-send-email-sage@newdream.net>
 <1253641129-28434-3-git-send-email-sage@newdream.net>
 <1253641129-28434-4-git-send-email-sage@newdream.net>
 <20090929165758.1b7df6c9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Sep 2009, Andrew Morton wrote:

> On Tue, 22 Sep 2009 10:38:31 -0700
> Sage Weil <sage@newdream.net> wrote:
> 
> > We first define constants, types, and prototypes for the kernel client
> > proper.
> > 
> > A few subsystems are defined separately later: the MDS, OSD, and
> > monitor clients, and the messaging layer.
> > 
> >
> > ...
> >
> > +static inline bool ceph_i_test(struct inode *inode, unsigned mask)
> > +{
> > +	struct ceph_inode_info *ci = ceph_inode(inode);
> > +	bool r;
> > +
> > +	spin_lock(&inode->i_lock);
> > +	r = (ci->i_ceph_flags & mask) == mask;
> > +	spin_unlock(&inode->i_lock);
> > +	return r;
> > +}
> 
> I'm not sure that the locking in ceph_i_test() makes much sense.  The
> condition we just checked could change one femtosecond after we dropped
> the lock, so why take the lock?

Right.  Would I need an smb_mb() or something in it's place?



> > +
> > +/* find a specific frag @f */
> > +static inline struct ceph_inode_frag *
> > +__ceph_find_frag(struct ceph_inode_info *ci, u32 f)
> > +{
> > +	struct rb_node *n = ci->i_fragtree.rb_node;
> > +
> > +	while (n) {
> > +		struct ceph_inode_frag *frag =
> > +			rb_entry(n, struct ceph_inode_frag, node);
> > +		int c = frag_compare(f, frag->frag);
> > +		if (c < 0)
> > +			n = n->rb_left;
> > +		else if (c > 0)
> > +			n = n->rb_right;
> > +		else
> > +			return frag;
> > +	}
> > +	return NULL;
> > +}
> 
> Please review the entire fs and verify that all inlining decisions were
> appropriate.  Unless this function has a single call site, this
> decision wasn't appropriate.
>
> And if it _does_ have a single callsite, it should be defined in the
> relevant .c file, not in .h

Yep!

> > +/*
> > + * choose fragment for value @v.  copy frag content to pfrag, if leaf
> > + * exists
> > + */
> > +extern u32 ceph_choose_frag(struct ceph_inode_info *ci, u32 v,
> > +			    struct ceph_inode_frag *pfrag,
> > +			    int *found);
> > +
> >
> > ...
> >
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
