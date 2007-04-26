Return-Path: <linux-kernel-owner+w=401wt.eu-S1031267AbXDZPYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031267AbXDZPYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 11:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031275AbXDZPYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 11:24:34 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:38786 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031267AbXDZPYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 11:24:33 -0400
To: serue@us.ibm.com
CC: miklos@szeredi.hu, serge@hallyn.com, hpa@zytor.com, linuxram@us.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       linux-security-module@vger.kernel.org, ebiederm@xmission.com,
       viro@ftp.linux.org.uk, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
In-reply-to: <20070426145733.GA10078@sergelap.austin.ibm.com>
	(serue@us.ibm.com)
Subject: Re: [patch] unprivileged mounts update
References: <E1HgcBv-00049Z-00@dorka.pomaz.szeredi.hu> <E1HgjG0-0005CN-00@dorka.pomaz.szeredi.hu> <462F87EA.1000002@zytor.com> <20070425172012.GA20336@sergelap.austin.ibm.com> <m1k5w0s5y0.fsf@ebiederm.dsl.xmission.com> <20070425175609.GB20165@vino.hallyn.com> <m1647ks3dm.fsf@ebiederm.dsl.xmission.com> <20070425185244.GA20688@vino.hallyn.com> <E1HgnFH-0006gR-00@dorka.pomaz.szeredi.hu> <20070426145733.GA10078@sergelap.austin.ibm.com>
Message-Id: <E1Hh5oQ-0000w1-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 26 Apr 2007 17:23:14 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Miklos Szeredi (miklos@szeredi.hu):
> > > Right, I figure if the normal action is to always do
> > > mnt->user = current->fsuid, then for the special case we
> > > pass a uid in someplace.  Of course...  do we not have a
> > > place to do that?  Would it be a no-no to use 'data' for
> > > a non-fs-specific arg?
> > 
> > I guess it would be OK for bind, but not for new- and remounts, where
> > 'data' is already used.
> > 
> > Maybe it's best to stay with fsuid after all, and live with having to
> > restore capabilities.  It's not so bad after all, this seems to do the
> > trick:
> > 
> > 	cap_t cap = cap_get_proc();
> > 	setfsuid(uid);
> > 	cap_set_proc(cap);
> > 
> > Unfortunately these functions are not in libc, but in a separate
> > "libcap" library.  Ugh.
> 
> Ok, are you still planning to nix the MS_SETUSER flag, though, as
> Eric suggested?  I think it's cleanest - always set the mnt->user
> field to current->fsuid, and require CAP_SYS_ADMIN if the
> mountpoint->mnt->user != current->fsuid.

It would be a nice cleanup, but I think it's unworkable for the
following reasons:

Up till now mount(2) and umount(2) always required CAP_SYS_ADMIN, and
we must make sure, that unless there's some explicit action by the
sysadmin, these rules are still enfoced.

For example, with just a check for mnt->mnt_uid == current->fsuid, a
fsuid=0 process could umount or submount all the "legacy" mounts even
without CAP_SYS_ADMIN.

This is a fundamental security problem, with getting rid of MS_SETUSER
and MNT_USER.

Another, rather unlikely situation is if an existing program sets
fsuid to non-zero before calling mount, hence unwantingly making that
mount owned by some user after these patches.

Also adding "user=0" to the options in /proc/mounts would be an
inteface breakage, that is probably harmless, but people wouldn't like
it.  Special casing the zero uid for this case is more ugly IMO, than
the problem we are trying to solve.

If we didn't have existing systems to deal with, then of course I'd
agree with Eric's suggestion.

Miklos
