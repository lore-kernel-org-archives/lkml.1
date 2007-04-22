Return-Path: <linux-kernel-owner+w=401wt.eu-S964988AbXDVGuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964988AbXDVGuM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 02:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964974AbXDVGuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 02:50:12 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:46906 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964988AbXDVGuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 02:50:10 -0400
To: ebiederm@xmission.com
CC: akpm@linux-foundation.org, miklos@szeredi.hu, serue@us.ibm.com,
       viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
In-reply-to: <m11widlwgp.fsf@ebiederm.dsl.xmission.com>
Subject: Re: [patch 2/8] allow unprivileged umount
References: <20070420102532.385211890@szeredi.hu>
	<20070420102626.825263599@szeredi.hu>
	<20070421005506.6a315bec.akpm@linux-foundation.org>
	<E1HfAf8-0002Ky-00@dorka.pomaz.szeredi.hu>
	<20070421013622.1f2a7d00.akpm@linux-foundation.org> <m11widlwgp.fsf@ebiederm.dsl.xmission.com>
Message-Id: <E1HfVr9-000431-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sun, 22 Apr 2007 08:47:31 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Sat, 21 Apr 2007 10:09:42 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> >> > > +static bool permit_umount(struct vfsmount *mnt, int flags)
> >> > > +{
> >> > >
> >> > > ...
> >> > >
> >> > > +	return mnt->mnt_uid == current->uid;
> >> > > +}
> >> > 
> >> > Yes, this seems very wrong.  I'd have thought that comparing user_struct*'s
> >> > would get us a heck of a lot closer to being able to support aliasing of
> >> > UIDs between different namespaces.
> >> > 
> >> 
> >> OK, I'll fix this up.
> >> 
> >> Actually an earlier version of this patch did use user_struct's but
> >> I'd changed it to uids, because it's simpler.
> >
> > OK..
> >
> >>  I didn't think about
> >> this being contrary to the id namespaces thing.
> >
> > Well I was madly assuming that when serarate UID namespaces are in use, UID
> > 42 in container A will have a different user_struct from UID 42 in
> > container B.  I'd suggest that we provoke an opinion from Eric & co before
> > you do work on this.
> 
> That is what I what I have been thinking as well,

Does this mean, that containers will need this?  Or that you don't
know yet?

> storing a user struct on each mount point seems sane, plus it allows
> per user mount rlimits which is major plus.  Especially since we
> seem to be doing accounting only for user mounts a per user rlimit
> seems good.

I'm not against per-user rlimits for mounts, but I'd rather do this
later...

> To get the user we should be user fs_uid as HPA suggested.

fsuid is exclusively used for checking file permissions, which we
don't do here anymore.  So while it could be argued, that mount() _is_
a filesystem operation, it is really a different sort of filesystem
operation than the rest.

OTOH it wouldn't hurt to use fsuid instead of ruid...

> Finally I'm pretty certain the capability we should care about in
> this context is CAP_SETUID.  Instead of CAP_SYS_ADMIN.
> 
> If we have CAP_SETUID we can become which ever user owns the mount,
> and the root user in a container needs this, so he can run login
> programs.  So changing the appropriate super user checks from
> CAP_SYS_ADMIN to CAP_SETUID I think is the right thing todo.

That's a flawed logic.  If you want to mount as a specific user, and
you have CAP_SETUID, then just use set*uid() and then mount().

Changing the capability check for mount() would break the userspace
ABI.

Miklos
