Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbYJ0NA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbYJ0NA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 09:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbYJ0M7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 08:59:48 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:40188 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbYJ0M7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 08:59:46 -0400
To: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "dm-devel@redhat.com" <dm-devel@redhat.com>,
       "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
       "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>,
       "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] freeze feature ver 1.14
Message-Id: <20081027215811t-sato@mail.jp.nec.com>
Mime-Version: 1.0
X-Mailer: WeMail32[2.51] ID:1K0086
From: Takashi Sato <t-sato@yk.jp.nec.com>
Date: Mon, 27 Oct 2008 21:58:11 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

We need to discuss about the timeout feature more,
so I send patches only of the generic freeze feature.

I've addressed the comment from Shaggy,
combined patches that were divided into each filesystems into one patch 
because of the avoidance of a bisection.

Currently, ext3 in mainline Linux doesn't have the freeze feature which
suspends write requests.  So, we cannot take a backup which keeps
the filesystem's consistency with the storage device's features
(snapshot and replication) while it is mounted.
In many case, a commercial filesystem (e.g. VxFS) has
the freeze feature and it would be used to get the consistent backup.
If Linux's standard filesystem ext3 has the freeze feature, we can do it
without a commercial filesystem.

So I have implemented the ioctls of the freeze feature.
I think we can take the consistent backup with the following steps.
1. Freeze the filesystem with the freeze ioctl.
2. Separate the replication volume or create the snapshot
   with the storage device's feature.
3. Unfreeze the filesystem with the unfreeze ioctl.
4. Take the backup from the separated replication volume
   or the snapshot.

[PATCH 1/3] Add error handling of write_super_lockfs and unlockfs
  VFS:
  Changed the type of write_super_lockfs and unlockfs from "void"
  to "int" so that they can return an error. 
  Rename write_super_lockfs and unlockfs of the super block operation
  freeze_fs and unfreeze_fs to avoid a confusion.

  ext3, ext4, xfs, gfs2, jfs:
  Changed the type of write_super_lockfs and unlockfs from "void"
  to "int" so that write_super_lockfs returns an error if needed,
  and unlockfs always returns 0.

  reiserfs:
  Changed the type of write_super_lockfs and unlockfs from "void"
  to "int" so that they always return 0 (success) to keep a current behavior.

[PATCH 2/3] Implement generic freeze feature
  The ioctls for the generic freeze feature are below.
  o Freeze the filesystem
    int ioctl(int fd, int FIFREEZE, arg)
      fd: The file descriptor of the mountpoint
      FIFREEZE: request code for the freeze
      arg: Ignored
      Return value: 0 if the operation succeeds. Otherwise, -1

  o Unfreeze the filesystem
    int ioctl(int fd, int FITHAW, arg)
      fd: The file descriptor of the mountpoint
      FITHAW: request code for unfreeze
      arg: Ignored
      Return value: 0 if the operation succeeds. Otherwise, -1
      Error number: If the filesystem has already been unfrozen,
                    errno is set to EINVAL.

[PATCH 3/3] Remove XFS specific ioctl interfaces for freeze feature
  It removes XFS specific ioctl interfaces and request codes
  for freeze feature.
  This patch has been supplied by David Chinner.

Any comments are very welcome.

Cheers, Takashi
