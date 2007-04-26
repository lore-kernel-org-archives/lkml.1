Return-Path: <linux-kernel-owner+w=401wt.eu-S1031336AbXDZQUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031336AbXDZQUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 12:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031335AbXDZQUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 12:20:03 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:55527 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031332AbXDZQUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:20:01 -0400
Date: Thu, 26 Apr 2007 11:19:29 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: serge@hallyn.com, hpa@zytor.com, linuxram@us.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       linux-security-module@vger.kernel.org, ebiederm@xmission.com,
       viro@ftp.linux.org.uk, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch] unprivileged mounts update
Message-ID: <20070426161929.GA6439@sergelap.austin.ibm.com>
References: <E1HgjG0-0005CN-00@dorka.pomaz.szeredi.hu> <462F87EA.1000002@zytor.com> <20070425172012.GA20336@sergelap.austin.ibm.com> <m1k5w0s5y0.fsf@ebiederm.dsl.xmission.com> <20070425175609.GB20165@vino.hallyn.com> <m1647ks3dm.fsf@ebiederm.dsl.xmission.com> <20070425185244.GA20688@vino.hallyn.com> <E1HgnFH-0006gR-00@dorka.pomaz.szeredi.hu> <20070426145733.GA10078@sergelap.austin.ibm.com> <E1Hh5oQ-0000w1-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Hh5oQ-0000w1-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Miklos Szeredi (miklos@szeredi.hu):
> > Quoting Miklos Szeredi (miklos@szeredi.hu):
> > > > Right, I figure if the normal action is to always do
> > > > mnt->user = current->fsuid, then for the special case we
> > > > pass a uid in someplace.  Of course...  do we not have a
> > > > place to do that?  Would it be a no-no to use 'data' for
> > > > a non-fs-specific arg?
> > > 
> > > I guess it would be OK for bind, but not for new- and remounts, where
> > > 'data' is already used.
> > > 
> > > Maybe it's best to stay with fsuid after all, and live with having to
> > > restore capabilities.  It's not so bad after all, this seems to do the
> > > trick:
> > > 
> > > 	cap_t cap = cap_get_proc();
> > > 	setfsuid(uid);
> > > 	cap_set_proc(cap);
> > > 
> > > Unfortunately these functions are not in libc, but in a separate
> > > "libcap" library.  Ugh.
> > 
> > Ok, are you still planning to nix the MS_SETUSER flag, though, as
> > Eric suggested?  I think it's cleanest - always set the mnt->user
> > field to current->fsuid, and require CAP_SYS_ADMIN if the
> > mountpoint->mnt->user != current->fsuid.
> 
> It would be a nice cleanup, but I think it's unworkable for the
> following reasons:
> 
> Up till now mount(2) and umount(2) always required CAP_SYS_ADMIN, and
> we must make sure, that unless there's some explicit action by the
> sysadmin, these rules are still enfoced.
> 
> For example, with just a check for mnt->mnt_uid == current->fsuid, a
> fsuid=0 process could umount or submount all the "legacy" mounts even
> without CAP_SYS_ADMIN.
>
> This is a fundamental security problem, with getting rid of MS_SETUSER
> and MNT_USER.
> 
> Another, rather unlikely situation is if an existing program sets
> fsuid to non-zero before calling mount, hence unwantingly making that
> mount owned by some user after these patches.
> 
> Also adding "user=0" to the options in /proc/mounts would be an
> inteface breakage, that is probably harmless, but people wouldn't like
> it.  Special casing the zero uid for this case is more ugly IMO, than
> the problem we are trying to solve.
> 
> If we didn't have existing systems to deal with, then of course I'd
> agree with Eric's suggestion.
> 
> Miklos

So then as far as you're concerned, the patches which were in -mm will
remain unchanged?

-serge

