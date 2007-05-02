Return-Path: <linux-kernel-owner+w=401wt.eu-S2992880AbXEBH50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992880AbXEBH50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 03:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992883AbXEBH50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 03:57:26 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:51260 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992880AbXEBH5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 03:57:25 -0400
To: lkml123@s2y4n2c.de
CC: linux-kernel@vger.kernel.org
In-reply-to: <1177873151.4343.29.camel@segv.aura.of.mankind> (message from utz
	lehmann on Sun, 29 Apr 2007 20:59:11 +0200)
Subject: Re: unprivileged mount problems: device permissions ignored, mount
	sharing
References: <1177873151.4343.29.camel@segv.aura.of.mankind>
Message-Id: <E1Hj9hk-00019p-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 02 May 2007 09:56:52 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I tried the unprivileged mount v5 patches with 2.6.21.1. I made some
> experiments with normal filesystems (ext3, xfs, iso9660). I removed the
> FS_SAFE checks for that.

Thanks for looking at this.

> Mounting and umounting as unprivileged user (user1) works, e.g.
> (/mnt/user1 is a mount owned by user1)
> 
> [user1@segv ~]$ mmount -t xfs /dev/mapper/vg00-test /mnt/user1
> 
> But the device permissions are ignored. The unprivileged user can mount
> the block device even there are no permissions to access it:
> 
> brw------- 1 root root 253, 5 Apr 29 18:32 /dev/mapper/vg00-test

Yes, I'm aware of this.  Before we enable FS_SAFE for block
filesystems, this must be addressed.

But I'm not sure _if_ we'll ever want this.  It is very likely that
there are some other security holes in most filesystems that are
difficult to address.  One example is checking for hard-linked
directories, which is normally only done during an fsck.

> And there is another problem with sharing the device (superblock?).
> If user1 mount a device readonly:
> 
> [user1@segv ~]$ mmount -r -t xfs /dev/mapper/vg00-test /mnt/user1
> 
> Than root cannot mount the device rw:
> 
> [root@segv ~]# mount /dev/mapper/vg00-test /mnt/test/
> mount: /dev/mapper/vg00-test already mounted or /mnt/test/ busy
> 
> Mounting ro works and than remounting rw work. But than /mnt/user1 is rw
> too.
> 
> This can DoS e.g. the automounter mounting /dev/mapper/vg00-test rw.

Right.

There are patches for enabling per-mount read-only, but this shows
well, that unprivileged block device mounts are far from trivial.

Miklos
