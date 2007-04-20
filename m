Return-Path: <linux-kernel-owner+w=401wt.eu-S1767048AbXDTKaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767048AbXDTKaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 06:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423053AbXDTK3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 06:29:49 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:57031 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423043AbXDTK3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 06:29:39 -0400
Message-Id: <20070420102532.385211890@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 20 Apr 2007 12:25:32 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, serue@us.ibm.com, viro@ftp.linux.org.uk,
       linuxram@us.ibm.com, ebiederm@xmission.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: [patch 0/8]  mount ownership and unprivileged mount syscall (v4)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset has now been bared to the "lowest common denominator"
that everybody can agree on.  Or at least there weren't any objections
to this proposal.

Andrew, please consider it for -mm.

Thanks,
Miklos
----

v3 -> v4:

 - simplify interface as much as possible, now only a single option
   ("user=UID") is used to control everything
 - no longer allow/deny mounting based on file/directory permissions,
   that approach does not always make sense

----
This patchset adds support for keeping mount ownership information in
the kernel, and allow unprivileged mount(2) and umount(2) in certain
cases.

The mount owner has the following privileges:

  - unmount the owned mount
  - create a submount under the owned mount

The sysadmin can set the owner explicitly on mount and remount.  When
an unprivileged user creates a mount, then the owner is automatically
set to the user.

The following use cases are envisioned:

1) Private namespace, with selected mounts owned by user.
   E.g. /home/$USER is a good candidate for allowing unpriv mounts and
   unmounts within.

2) Private namespace, with all mounts owned by user and having the
   "nosuid" flag.  User can mount and umount anywhere within the
   namespace, but suid programs will not work.

3) Global namespace, with a designated directory, which is a mount
   owned by the user.  E.g. /mnt/users/$USER is set up so that it is
   bind mounted onto itself, and set to be owned by $USER.  The user
   can add/remove mounts only under this directory.

The following extra security measures are taken for unprivileged
mounts:

 - usermounts are limited by a sysctl tunable
 - force "nosuid,nodev" mount options on the created mount

--
