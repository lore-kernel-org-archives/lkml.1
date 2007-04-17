Return-Path: <linux-kernel-owner+w=401wt.eu-S1753669AbXDQLKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbXDQLKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 07:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753681AbXDQLKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 07:10:47 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:41249 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662AbXDQLKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 07:10:46 -0400
To: ebiederm@xmission.com
CC: serue@us.ibm.com, miklos@szeredi.hu, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, viro@ftp.linux.org.uk,
       containers@lists.osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-reply-to: <m1k5wbjrsh.fsf@ebiederm.dsl.xmission.com>
Subject: Re: [Devel] Re: [patch 05/10] add "permit user mounts in new namespace" clone flag
References: <20070412164620.588752236@szeredi.hu>
	<20070412203208.GG27772@sergelap.austin.ibm.com>
	<m1mz1cq3v6.fsf@ebiederm.dsl.xmission.com>
	<1176713221.9488.17.camel@ram.us.ibm.com>
	<E1HdNZn-0006i9-00@dorka.pomaz.szeredi.hu>
	<1176716941.9488.57.camel@ram.us.ibm.com>
	<E1HdNwV-0006l2-00@dorka.pomaz.szeredi.hu>
	<m18xcsl3yc.fsf@ebiederm.dsl.xmission.com>
	<E1HdTag-0007bd-00@dorka.pomaz.szeredi.hu>
	<m1zm58jfj3.fsf@ebiederm.dsl.xmission.com>
	<20070416195652.GA350@sergelap.austin.ibm.com> <m1k5wbjrsh.fsf@ebiederm.dsl.xmission.com>
Message-Id: <E1HdlYr-00015O-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 17 Apr 2007 13:09:25 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Interesting....
> 
> So far even today these things can happen, however they are sufficiently
> unlikely the tools don't account for them.
> 
> Once a hostile user can cause them things are more of a problem.
> 
> > (Unless you want to tackle each problem legacy tool one at a time to
> > remove problems - i.e. deluser should umount everything under
> > /home/hallyn before deleting, backup should be spawned from it's own
> > namespace cloned right after boot or just back up on one filesystem,
> > etc.)
> 
> I don't see a way that backup and deluser won't need to be modified
> to work properly in a system where non-priveleged mounts are allowed,
> at least they will need to account for /share.
> 
> That said it is clearly a hazard if we enable this functionality by
> default.
> 
> If we setup a pam module that triggers on login and perhaps when
> cron and at jobs run to setup an additional mount namespace I think
> keeping applications locked away in their own mount namespace is
> sufficient to avoid hostile users from doing unexpected things to
> the initial mount namespace.  So unless I am mistake it should be
> relatively simple to prevent user space from encountering problems.
> 
> That still leaves the question of how we handle systems with an old
> user space that is insufficiently robust to deal with mounts occurring
> at unexpected locations.
> 
> 
>   I think a simple sysctl to enable/disable of non-priveleged mounts 
>   defaulting to disabled is enough.
> 
> Am I correct or will it be more difficult than just a little pam
> module to ensure non-trusted users never run in the initial mount
> namespace?

I'm still not sure, what your problem is.

With the v3 of the usermounts patchset, by default, user mounts are
disabled, because the "allow unpriv submounts" flag is cleared on all
mounts.

There are several options available to sysadmins and distro builders
to enable user mounts in a secure way:

  - pam module, which creates a private namespace, and sets "allow
    unpriv submounts" on the mounts within the namespace

  - pam module, which rbinds / onto /mnt/ns/$USER, and chroots into
    /mnt/ns/$USER, then sets the "allow unpriv submounts" on the
    mounts under /mnt/ns/$USER.

  - sysadmin creates /mnt/usermounts writable to all users, with
    sticky bit (same as /tmp), does "mount --bind /mnt/usermounts
    /mnt/usermounts" and sets the "allow unpriv submounts" on
    /mnt/usermounts.

All of these are perfectly safe wrt userdel and backup (assuming it
doesn't try back up /mnt).

Miklos
