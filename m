Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbYFXHA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbYFXHA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 03:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbYFXHAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 03:00:07 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:43617 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbYFXHAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 03:00:05 -0400
To: akpm@linux-foundation.org, viro@ZenIV.linux.org.uk
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
       "dm-devel@redhat.com" <dm-devel@redhat.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       axboe@kernel.dk, mtk.manpages@googlemail.com
Subject: [PATCH 0/3] freeze feature ver 1.6
Message-Id: <20080624155919t-sato@mail.jp.nec.com>
Mime-Version: 1.0
X-Mailer: WeMail32[2.51] ID:1K0086
From: Takashi Sato <t-sato@yk.jp.nec.com>
Date: Tue, 24 Jun 2008 15:59:19 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew and Alexander,

I have implemented the ioctls for the filesystem freeze feature
and discussed its implementation on the ML (linux-ext4, xfs,
linux-fsdevel, linux-kernel) for five months.  All of the comments are
addressed in my patch-set.
Could you consider merging it into Linux?

The filesystem freeze feature can suspend accesses to the filesystem
keeping the filesystem's consistency.  We can take the consistent backup
with it cooperating with the backup software.

The patches are re-based from linux-2.6.26-rc3 to linux-2.6.26-rc7
There is no functional change from the previous version.
The patch-set consists of the following three patches.

[PATCH 1/3] Implement generic freeze feature
  I have modified to set the suitable error number (EOPNOTSUPP)
  in case the filesystem doesn't support the freeze feature.

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

[PATCH 2/3] Remove XFS specific ioctl interfaces for freeze feature
  It removes XFS specific ioctl interfaces and request codes
  for freeze feature.
  This patch has been supplied by David Chinner.

[PATCH 3/3] Add timeout feature
  The timeout feature is added to freeze ioctl.  And new ioctl
  to reset the timeout period is added.
  o Freeze the filesystem
    int ioctl(int fd, int FIFREEZE, long *timeval)
      fd: The file descriptor of the mountpoint
      FIFREEZE: request code for the freeze
      timeval: the timeout period in seconds
               If it's 0 or 1, the timeout isn't set.
               This special case of "1" is implemented to keep
               the compatibility with XFS applications.
      Return value: 0 if the operation succeeds. Otherwise, -1

  o Reset the timeout period
    This is useful for the application to set the timeval more accurately.
    For example, the freezer resets the timeval to 10 seconds every 5
    seconds.  In this approach, even if the freezer causes a deadlock
    by accessing the frozen filesystem, it will be solved by the timeout
    in 10 seconds and the freezer can recognize that at the next reset
    of timeval.
    int ioctl(int fd, int FIFREEZE_RESET_TIMEOUT, long *timeval)
      fd:file descriptor of mountpoint
      FIFREEZE_RESET_TIMEOUT: request code for reset of timeout period
      timeval: new timeout period in seconds
      Return value: 0 if the operation succeeds. Otherwise, -1
      Error number: If the filesystem has already been unfrozen,
                    errno is set to EINVAL.

Any comments are very welcome.

Cheers, Takashi
