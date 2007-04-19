Return-Path: <linux-kernel-owner+w=401wt.eu-S2993210AbXDSJFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993210AbXDSJFe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 05:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993211AbXDSJFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 05:05:34 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:38416 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993210AbXDSJFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 05:05:31 -0400
To: ebiederm@xmission.com
CC: serue@us.ibm.com, linuxram@us.ibm.com, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, containers@lists.osdl.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-reply-to: <E1HeEX8-0004Wy-00@dorka.pomaz.szeredi.hu> (message from Miklos
	Szeredi on Wed, 18 Apr 2007 20:05:34 +0200)
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
	<20070416195652.GA350@sergelap.austin.ibm.com>
	<m1k5wbjrsh.fsf@ebiederm.dsl.xmission.com>
	<E1HdlYr-00015O-00@dorka.pomaz.szeredi.hu>
	<m1zm56j27m.fsf@ebiederm.dsl.xmission.com>
	<E1HdsX6-0002Kl-00@dorka.pomaz.szeredi.hu>
	<m1vefuixp5.fsf@ebiederm.dsl.xmission.com>
	<E1He6C7-0003Xu-00@dorka.pomaz.szeredi.hu> <m1hcrdob8u.fsf@ebiederm.dsl.xmission.com> <E1HeEX8-0004Wy-00@dorka.pomaz.szeredi.hu>
Message-Id: <E1HeSWo-0005vU-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 19 Apr 2007 11:02:10 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Checking the permissions on the mountpoint to allow unmounting is
> 
>   - rather inelegant: user can't see those permissions, can only
>     determine if umount is allowed by trial and error
> 
>   - may be a security hole, e.g.:
> 
>       sysadmin:
> 
>           mkdir -m 777 /mnt/disk
>           mount /dev/hda2 /mnt/disk
> 
> Of course the user doesn't have the right to delete the contents of
> the mount, yet the permissions on the mountpoint would imply that s/he
> has permission to umount the disk.

It is becoming increasingly apparent, that mount/umount permission
based on file permissions is inherently broken:

1) there are user-writable files under /proc/$PID/, which definitely
   shouldn't be allowed to be overmounted

2) if user mounts an fs read-only, then wants to create a submount of
   this, it will fail with the current patchset

Solving 2) should be trivial: submounting a mount owned by the user
should be always allowed regardless of the file permissions.

Maybe this could be generaized to say, that a mount can be submounted
by an unprivileged user IFF parent mount is owned by said user.

This would get rid of some of the complications in the current
patchset, namely the functionality of MNT_ALLOWUSERMNT and MNT_USER
flags would be merged, and the permission checking would be removed.

For example on login, the user could get a private namespace set up
some that the home directory is owned by the user, and hence can be
freely submounted:

  clone(CLONE_NEWNS)
  mount --bind /home/$USER /home/$USER
  mount --remount -ouser=$USER /home/$USER

This is of course more limiting than allowing mounts based on file
permissions, but it's also a lot cleaner.

Hmm?

Miklos
