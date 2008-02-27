Return-Path: <linux-kernel-owner+w=401wt.eu-S1762198AbYB0XKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762198AbYB0XKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759187AbYB0XIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:08:35 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:44341 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756200AbYB0XI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:08:26 -0500
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hch@infradead.org, viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no,
       bfields@fieldses.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: RFC Labeled NFS Initial Code Review
Date: Wed, 27 Feb 2008 17:11:23 -0500
Message-Id: <1204150294-4678-1-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.5.3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch set is the first submission to fs-devel and lkml for the purpose of
code review. To test the patch set you need patches to nfs-utils as well. Since
this is just a code review I haven't posted the patch to nfs-utils however if
you want to test the code feel free to e-mail me and I will send you the
necessary patch.

Out of all of the functionality we have prototyped I have narrowed it down to
these items which I believe is the solid base for initial kernel inclusion.
These patches provide the mechanism to allow the server to provide security
labels to the client and a method for the client to change labels on the server.
The next revision of this patch set will allow for the client's subject
(process) label to be transmitted with the access requests so the server can
also make access decisions against the acting local policy. This part of the
patch set will be made substantially cleaner by the credentials patches
proposed by David Howells.

Known Issues:

Eventually stronger notification of security label changes will be added. For
now this is accomplished by using NFS's normal cache invalidation (timeout).

When acting as root on a root_squashed export changing the label on a file
manages to set the label locally in the NFS inode but doesn't set it on the
exported file system. In this case the fault is the server is returning OK for
the setattr option instead of EPERM. This will be fixed in the next version.

 fs/Kconfig                          |   17 ++
 fs/attr.c                           |   43 ++++
 fs/nfs/client.c                     |   16 ++
 fs/nfs/dir.c                        |  101 ++++++++++-
 fs/nfs/getroot.c                    |   33 +++
 fs/nfs/inode.c                      |   58 ++++++-
 fs/nfs/namespace.c                  |    3 +
 fs/nfs/nfs3proc.c                   |   15 ++
 fs/nfs/nfs4proc.c                   |  369 +++++++++++++++++++++++++++++++++--
 fs/nfs/nfs4xdr.c                    |   49 +++++
 fs/nfs/proc.c                       |   13 ++-
 fs/nfs/super.c                      |   25 +++-
 fs/nfsd/export.c                    |    3 +
 fs/nfsd/nfs4xdr.c                   |   90 +++++++++-
 fs/nfsd/vfs.c                       |    7 +
 fs/xattr.c                          |   33 +++-
 include/linux/fcntl.h               |    1 +
 include/linux/fs.h                  |   11 +
 include/linux/fsnotify.h            |    6 +
 include/linux/inotify.h             |    3 +-
 include/linux/nfs4.h                |    2 +
 include/linux/nfs4_mount.h          |    3 +-
 include/linux/nfs_fs.h              |   41 ++++
 include/linux/nfs_fs_sb.h           |    1 +
 include/linux/nfs_mount.h           |    3 +-
 include/linux/nfs_xdr.h             |    4 +
 include/linux/nfsd/export.h         |    5 +-
 include/linux/nfsd/nfsd.h           |    7 +-
 include/linux/security.h            |   19 ++
 include/linux/xattr.h               |    1 +
 security/dummy.c                    |   13 ++
 security/security.c                 |   17 ++
 security/selinux/hooks.c            |   89 ++++++++--
 security/selinux/include/security.h |    2 +
 security/selinux/ss/policydb.c      |    5 +-
 35 files changed, 1059 insertions(+), 49 deletions(-)

