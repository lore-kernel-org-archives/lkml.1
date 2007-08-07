Return-Path: <linux-kernel-owner+w=401wt.eu-S1755235AbXHGGBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbXHGGBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 02:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbXHGGBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 02:01:38 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:48637 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbXHGGBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 02:01:36 -0400
To: trond.myklebust@fys.uio.no
CC: miklos@szeredi.hu, jlayton@redhat.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mikulas@artax.karlin.mff.cuni.cz,
       zippel@linux-m68k.org, joel.becker@oracle.com, wli@holomorphy.com,
       dhowells@redhat.com, bfennema@falcon.csc.calpoly.edu
In-reply-to: <1186435419.6616.136.camel@localhost> (message from Trond
	Myklebust on Mon, 06 Aug 2007 17:23:39 -0400)
Subject: Re: [fuse-devel] [PATCH 01/25] VFS: move attr_kill logic from
	notify_change into helper function
References: <200708061354.l76Ds6sq002260@dantu.rdu.redhat.com>
	 <E1II6cM-0004yj-00@dorka.pomaz.szeredi.hu>
	 <20070806141333.0f54ab17.jlayton@redhat.com>
	 <E1II7JR-0005BN-00@dorka.pomaz.szeredi.hu>
	 <1186427063.6616.59.camel@localhost>
	 <E1II8Nw-0005XH-00@dorka.pomaz.szeredi.hu> <1186435419.6616.136.camel@localhost>
Message-Id: <E1III7U-0006ju-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 07 Aug 2007 08:00:40 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(cutting out lists from CC)

> > > > Your patch is changing the API in a very unsafe way, since there will
> > > > be no error or warning on an unconverted fs.  And that could lead to
> > > > security holes.
> > > > 
> > > > If we would rename the setattr method to setattr_new as well as
> > > > changing it's behavior, that would be fine.  But I guess we do not
> > > > want to do that.
> > > 
> > > Which "unconverted fses"? If we're talking out of tree stuff, then too
> > > bad: it is _their_ responsibility to keep up with kernel changes.
> > 
> > It is usually a good idea to not change the semantics of an API in a
> > backward incompatible way without changing the syntax as well.
> 
> We're taking two setattr flags ATTR_KILL_SGID, and ATTR_KILL_SUID which
> have existed for several years in the VFS, and making them visible to
> the filesystems. Out-of-tree filesystems that care can check for them in
> a completely backward compatible way: you don't even need to add a
> #define.

Making flags visible is not the problem.

Making another flag invisible (ATTR_MODE) at the same time _is_.

> > This is true regardless of whether we care about out-of-tree code or
> > not (and we should care to some degree).  And especially true if the
> > change in question is security sensitive.
> 
> It is not true "regardless": the in-tree code is being converted.
> Out-of-tree code is the only "problem" here, and their only problem is
> that they may have to add support for the new flags if they also support
> suid/sgid mode bits.

Yes.  And there would be no problem with that, as long as it would be
breaking the API in a visible way.  It does not do that and that is
unsafe.

The other thing with this change is, that it's generally a good idea
to let the VFS do as much as possible, because then filesystem writers
won't get it wrong.

In this case the suid/sgid check needs to be omitted for _very_ few
filesystems (NFS and fuse).  So it makes sense to leave the check
outside filesystem code, and move it inside only when necessary.

> Are you advocating reserving a new filesystem bit every time we need to
> add an attribute flag?

No, just adding a flag does not constitute a backward incompatible
change.

Miklos
