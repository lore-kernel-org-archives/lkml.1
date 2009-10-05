Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbZJEWwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbZJEWwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 18:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755124AbZJEWwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 18:52:12 -0400
Received: from cobra.newdream.net ([66.33.216.30]:49297 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966AbZJEWwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 18:52:09 -0400
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: yehuda@newdream.net, Sage Weil <sage@newdream.net>
Subject: [PATCH 00/21] ceph distributed file system client
Date: Mon,  5 Oct 2009 15:50:30 -0700
Message-Id: <1254783051-26217-1-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is v0.16 of the Ceph distributed file system client.  This version 
addresses comments from Andrew and Andi, and fixes a few bugs.  Changes 
since v0.15 include:

 - corrected much inline abuse
 - marked init only methods with __init
 - use KMEM_CACHE where possible
 - use sockaddr_storage for on-wire types (for eventual ipv6 support)
 - slightly improved ceph_buffer use of vmalloc
 - use pr_fmt
 - use smp_mb instead of spinlock for ceph_i_test
 - xattr cleanups
 - fix invalidate bug
 - fix msgr queue accounting bug

Unless anyone sees any major problems here, I plan to send this to 
Stephen shortly for inclusion in linux-next, and will ask Linus to pull 
during the .33 window.

Thank you everyone who has taken the time for review so far!

sage


Kernel client git tree:
        git://ceph.newdream.net/linux-ceph-client.git

System:
	git://ceph.newdream.net/ceph.git

---
 Documentation/filesystems/ceph.txt   |  139 ++
 Documentation/ioctl/ioctl-number.txt |    1 +
 MAINTAINERS                          |    9 +
 fs/Kconfig                           |    1 +
 fs/Makefile                          |    1 +
 fs/ceph/Kconfig                      |   26 +
 fs/ceph/Makefile                     |   36 +
 fs/ceph/addr.c                       | 1115 +++++++++++++
 fs/ceph/buffer.c                     |   34 +
 fs/ceph/buffer.h                     |   55 +
 fs/ceph/caps.c                       | 2830 +++++++++++++++++++++++++++++++++
 fs/ceph/ceph_debug.h                 |   37 +
 fs/ceph/ceph_frag.c                  |   21 +
 fs/ceph/ceph_frag.h                  |  109 ++
 fs/ceph/ceph_fs.c                    |   80 +
 fs/ceph/ceph_fs.h                    |  629 ++++++++
 fs/ceph/ceph_strings.c               |  163 ++
 fs/ceph/ceph_ver.h                   |    6 +
 fs/ceph/crush/crush.c                |  140 ++
 fs/ceph/crush/crush.h                |  188 +++
 fs/ceph/crush/hash.h                 |   90 ++
 fs/ceph/crush/mapper.c               |  589 +++++++
 fs/ceph/crush/mapper.h               |   20 +
 fs/ceph/debugfs.c                    |  425 +++++
 fs/ceph/decode.h                     |  136 ++
 fs/ceph/dir.c                        | 1212 ++++++++++++++
 fs/ceph/export.c                     |  223 +++
 fs/ceph/file.c                       |  904 +++++++++++
 fs/ceph/inode.c                      | 1620 +++++++++++++++++++
 fs/ceph/ioctl.c                      |  157 ++
 fs/ceph/ioctl.h                      |   39 +
 fs/ceph/mds_client.c                 | 2912 ++++++++++++++++++++++++++++++++++
 fs/ceph/mds_client.h                 |  321 ++++
 fs/ceph/mdsmap.c                     |  166 ++
 fs/ceph/mdsmap.h                     |   53 +
 fs/ceph/messenger.c                  | 2019 +++++++++++++++++++++++
 fs/ceph/messenger.h                  |  243 +++
 fs/ceph/mon_client.c                 |  694 ++++++++
 fs/ceph/mon_client.h                 |  109 ++
 fs/ceph/msgpool.c                    |  167 ++
 fs/ceph/msgpool.h                    |   26 +
 fs/ceph/msgr.h                       |  157 ++
 fs/ceph/osd_client.c                 | 1294 +++++++++++++++
 fs/ceph/osd_client.h                 |  144 ++
 fs/ceph/osdmap.c                     |  875 ++++++++++
 fs/ceph/osdmap.h                     |  123 ++
 fs/ceph/rados.h                      |  372 +++++
 fs/ceph/snap.c                       |  897 +++++++++++
 fs/ceph/super.c                      |  936 +++++++++++
 fs/ceph/super.h                      |  890 +++++++++++
 fs/ceph/types.h                      |   28 +
 fs/ceph/xattr.c                      |  833 ++++++++++
 52 files changed, 24294 insertions(+), 0 deletions(-)
---
 Documentation/filesystems/ceph.txt   |  139 ++
 Documentation/ioctl/ioctl-number.txt |    1 +
 MAINTAINERS                          |    9 +
 fs/Kconfig                           |    1 +
 fs/Makefile                          |    1 +
 fs/ceph/Kconfig                      |   26 +
 fs/ceph/Makefile                     |   36 +
 fs/ceph/addr.c                       | 1115 +++++++++++++
 fs/ceph/buffer.c                     |   34 +
 fs/ceph/buffer.h                     |   55 +
 fs/ceph/caps.c                       | 2830 +++++++++++++++++++++++++++++++++
 fs/ceph/ceph_debug.h                 |   37 +
 fs/ceph/ceph_frag.c                  |   21 +
 fs/ceph/ceph_frag.h                  |  109 ++
 fs/ceph/ceph_fs.c                    |   80 +
 fs/ceph/ceph_fs.h                    |  629 ++++++++
 fs/ceph/ceph_strings.c               |  163 ++
 fs/ceph/ceph_ver.h                   |    6 +
 fs/ceph/crush/crush.c                |  140 ++
 fs/ceph/crush/crush.h                |  188 +++
 fs/ceph/crush/hash.h                 |   90 ++
 fs/ceph/crush/mapper.c               |  589 +++++++
 fs/ceph/crush/mapper.h               |   20 +
 fs/ceph/debugfs.c                    |  425 +++++
 fs/ceph/decode.h                     |  136 ++
 fs/ceph/dir.c                        | 1212 ++++++++++++++
 fs/ceph/export.c                     |  223 +++
 fs/ceph/file.c                       |  904 +++++++++++
 fs/ceph/inode.c                      | 1620 +++++++++++++++++++
 fs/ceph/ioctl.c                      |  157 ++
 fs/ceph/ioctl.h                      |   39 +
 fs/ceph/mds_client.c                 | 2912 ++++++++++++++++++++++++++++++++++
 fs/ceph/mds_client.h                 |  321 ++++
 fs/ceph/mdsmap.c                     |  166 ++
 fs/ceph/mdsmap.h                     |   53 +
 fs/ceph/messenger.c                  | 2019 +++++++++++++++++++++++
 fs/ceph/messenger.h                  |  243 +++
 fs/ceph/mon_client.c                 |  694 ++++++++
 fs/ceph/mon_client.h                 |  109 ++
 fs/ceph/msgpool.c                    |  167 ++
 fs/ceph/msgpool.h                    |   26 +
 fs/ceph/msgr.h                       |  157 ++
 fs/ceph/osd_client.c                 | 1294 +++++++++++++++
 fs/ceph/osd_client.h                 |  144 ++
 fs/ceph/osdmap.c                     |  875 ++++++++++
 fs/ceph/osdmap.h                     |  123 ++
 fs/ceph/rados.h                      |  372 +++++
 fs/ceph/snap.c                       |  897 +++++++++++
 fs/ceph/super.c                      |  936 +++++++++++
 fs/ceph/super.h                      |  890 +++++++++++
 fs/ceph/types.h                      |   28 +
 fs/ceph/xattr.c                      |  833 ++++++++++
 52 files changed, 24294 insertions(+), 0 deletions(-)
