Return-Path: <linux-kernel-owner+w=401wt.eu-S1762297AbXEWKZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762297AbXEWKZF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 06:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763880AbXEWKYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 06:24:52 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:59800 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763501AbXEWKYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 06:24:50 -0400
To: viro@ftp.linux.org.uk
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
In-reply-to: <E1HqnmR-0001dI-00@dorka.pomaz.szeredi.hu> (message from Miklos
	Szeredi on Wed, 23 May 2007 12:09:19 +0200)
Subject: Re: [RFC PATCH] file as directory
References: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu> <20070523095127.GQ4095@ftp.linux.org.uk> <E1HqnmR-0001dI-00@dorka.pomaz.szeredi.hu>
Message-Id: <E1Hqo0n-0001ho-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 23 May 2007 12:24:09 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > + * This is tricky, because for namespace modification we must take the
> > > + * namespace semaphore.  But mntput() is called from various places,
> > > + * sometimes with namespace_sem held.  Fortunately in those places the
> > > + * mount cannot yet have MNT_DIRONFILE, or at least that's what I
> > > + * hope...
> > > + *
> > > + * The umounting is done in two stages, first the mount is removed
> > > + * from the hashes.  This is done atomically wrt other mount lookups,
> > > + * so it's not possible to acquire a new ref to this dead mount that
> > > + * way.
> > > + *
> > > + * Then after having locked namespace_sem and relocked vfsmount_lock,
> > > + * the mount is properly detached.
> > > + */
> > > +static void umount_dironfile(struct vfsmount *mnt)
> > > +	__releases(vfsmount_lock)
> > > +{
> > > +	struct nameidata nd;
> > 
> > You've got to be kidding.  nameidata is *big*.  If anything, we want
> > to make detach_mnt() take struct path * instead, but even that is
> > lousy due to recursion.
> > 
> > I really don't like what's going on here.  The thing is, current code
> > is based on assumption that presence in the mount tree => holding a
> > reference.  We _might_ deal with that (there was an old plan to change
> > refcounting logics for vfsmounts), but that sort of games with locks
> > spells trouble.  What happens, for example, if namespace gets cloned
> > before you grab namespace_sem?
> 
> It _should_ work.  The mount in the new namespace will be created
> (with namespace_sem held, so we can't yet free this mount), and then
> dropped, because there are no refs to it.

BTW, I'm not saying I like this.  It's pretty ugly and fragile.  But
it's damn convenient to get rid of these mounts from mntput().

Is there a better alternative?

Miklos
