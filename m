Return-Path: <linux-kernel-owner+w=401wt.eu-S1752206AbXCDS0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbXCDS0t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 13:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbXCDS0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 13:26:49 -0500
Received: from rtr.ca ([64.26.128.89]:4963 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbXCDS0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 13:26:48 -0500
Message-ID: <45EB0F69.5070002@rtr.ca>
Date: Sun, 04 Mar 2007 13:26:49 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       bluez-devel@lists.sourceforge.net, marcel@holtmann.org,
       Andrew Morton <akpm@osdl.org>,
       "David S. Miller" <davem@sunset.davemloft.net>
Subject: [PATCH] Fix 2.6.21 rfcomm lockups (2.6.21 regression)
References: <45EADD78.1030300@rtr.ca> <45EAE1D6.10900@rtr.ca> <45EB0814.5030306@rtr.ca>
In-Reply-To: <45EB0814.5030306@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Any attempt to open/use a bluetooth rfcomm device locks up
> scheduling completely on my machine.
>
> Interrupts (ping, alt-sysrq) seem to be alive, but nothing else.
>
> This was working fine in 2.6.20, broken now in 2.6.21-rc2-git*

Further info:  Reverting this change (below) fixes it:

| author    Marcel Holtmann <marcel@holtmann.org>
|      Sat, 17 Feb 2007 22:58:57 +0000 (23:58 +0100)
| committer    David S. Miller <davem@sunset.davemloft.net>
|      Mon, 26 Feb 2007 19:42:41 +0000 (11:42 -0800)
| commit    c1a3313698895d8ad4760f98642007bf236af2e8
| tree    337a876f727061362b6a169f8759849c105b8f7a    tree | snapshot
| parent    f5ffd4620aba9e55656483ae1ef5c79ba81f5403    commit | diff
| | [Bluetooth] Make use of device_move() for RFCOMM TTY devices
| | In the case of bound RFCOMM TTY devices the parent is not available
| before its usage. So when opening a RFCOMM TTY device, move it to
| the corresponding ACL device as a child. When closing the device,
| move it back to the virtual device tree.
| Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

The simplest fix for this bug is to prevent sysfs_move_dir()
from self-deadlocking when (old_parent == new_parent).

This patch prevents total system lockup when using rfcomm devices.

Signed-off-by:  Mark Lord <mlord@pobox.com>
---
--- 2.6.21/fs/sysfs/dir.c	2007-03-04 13:19:00.000000000 -0500
+++ linux/fs/sysfs/dir.c	2007-03-04 13:20:45.000000000 -0500
@@ -431,6 +431,8 @@
 	new_parent_dentry = new_parent ?
 		new_parent->dentry : sysfs_mount->mnt_sb->s_root;
 
+	if (old_parent_dentry->d_inode == new_parent_dentry->d_inode)
+		return 0;	/* nothing to move */
 again:
 	mutex_lock(&old_parent_dentry->d_inode->i_mutex);
 	if (!mutex_trylock(&new_parent_dentry->d_inode->i_mutex)) {
