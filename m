Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbXDPLHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbXDPLHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 07:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbXDPLGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 07:06:41 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:34404 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081AbXDPLGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 07:06:37 -0400
Message-Id: <20070416110308.739051445@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Mon, 16 Apr 2007 13:03:08 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, serue@us.ibm.com, viro@ftp.linux.org.uk,
       linuxram@us.ibm.com, ebiederm@xmission.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: [patch 00/10]  mount ownership and unprivileged mount syscall (v3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support for keeping mount ownership information in
the kernel, and allow unprivileged mount(2) and umount(2) in certain
cases.

This can be useful for the following reasons:

- mount(8) can store ownership ("user=XY" option) in the kernel
  instead, or in addition to storing it in /etc/mtab.  For example if
  private namespaces are used with mount propagations /etc/mtab
  becomes unworkable, but using /proc/mounts works fine

- fuse won't need a special suid-root mount/umount utility.  Plain
  umount(8) can easily be made to work with unprivileged fuse mounts

- users can use bind mounts without having to pre-configure them in
  /etc/fstab

The following security measures are taken for unprivileged mounts:

 - only allow submounting under mounts which have a special mount flag set
 - only allow mounting on files/directories writable by the user
 - limit the number of user mounts
 - force "nosuid,nodev" mount options

Changes from the previous submissions:

 - add mount flags to set/clear mnt_flags individually
 - add "usermnt" mount flag.  If it is set, then allow unprivileged
   submounts under this mount
 - make max number of user mounts default to 1024, since now the
   usermnt flag will prevent user mounts by default

--
