Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbYLAQmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbYLAQmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 11:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbYLAQkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 11:40:06 -0500
Received: from zombie2.ncsc.mil ([144.51.88.133]:56964 "EHLO zombie2.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655AbYLAQjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 11:39:52 -0500
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, matthew.dodd@sparta.com, trond.myklebust@fys.uio.no,
       bfields@fieldses.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       labeled-nfs@linux-nfs.org
Subject: [Labeled-nfs] [RFC v4] Security Label Support for NFSv4
Date: Wed, 26 Nov 2008 16:03:00 -0500
Message-Id: <1227733394-1114-1-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

This is the latest version of the NFS label support patch set. The set
contains one patch which will be removed when it makes it's way upstream from
the NFS maintainers' trees. This is the patch to fix a use before init bug in
the nfs4recovery code. Changes since the last patchset are listed below.

If you want a tree with the patches already applied we have posted a public
git tree that is ready for cloning and use. This tree can be found at
http://git.selinuxproject.org/git. You can find information on how to build
and setup a labeled nfs at http://www.selinuxproject.org/page/Labeled_NFS. 

Features:

* Client
	* Obtains labels from server for NFS files while still allowing for
	SELinux context mounts to override untrusted labeled servers.
	* Allows setting labels on files over NFS via xattr interface.
* Server
	* Exports labels to clients. As of the moment there is no ability to
	restrict this based on label components such as MLS levels.
	* Persistent storage of labels assuming exported file system supports
	it.

Changes since last patchset:

The life cycle management patch has been fixed to return the error from kmalloc
up the call stack. The patch use to have a panic in the case of memory
allocation failure which was a temporary measure until this was ready.

Inode locking was added around the functions in the NFS server code which
assign the label to the inode when received from the wire.

Memory allocations were changed from GFP_ATOMIC to GFP_KERNEL

An bug that resulted in memory corruption when MLS support was enabled has
also been fixed.

The process label transport mechanism has been removed from the patchset since
a new version of it is in the works. This new method provides the security
guarantees needed for our purposes while providing compatibility with
existing rpcsec flavors and fixing a potential MITM attack against kerberos. A
more detailed explanation of the mechanism will be given when the design has
been solidified and we have an initial implementation.

 fs/Kconfig                          |   30 +++
 fs/nfs/client.c                     |   16 ++
 fs/nfs/dir.c                        |   32 +++-
 fs/nfs/getroot.c                    |   44 +++-
 fs/nfs/inode.c                      |   69 +++++-
 fs/nfs/namespace.c                  |    3 +
 fs/nfs/nfs3proc.c                   |    7 +
 fs/nfs/nfs4proc.c                   |  489 +++++++++++++++++++++++++++++++---
 fs/nfs/nfs4xdr.c                    |   55 ++++-
 fs/nfs/proc.c                       |   12 +-
 fs/nfs/super.c                      |   46 ++++-
 fs/nfs/unlink.c                     |   12 +-
 fs/nfsd/export.c                    |    3 +
 fs/nfsd/nfs4proc.c                  |   35 +++-
 fs/nfsd/nfs4recover.c               |    6 +-
 fs/nfsd/nfs4xdr.c                   |  106 +++++++-
 fs/nfsd/vfs.c                       |   28 ++
 fs/xattr.c                          |   55 +++-
 include/linux/nfs4.h                |    8 +
 include/linux/nfs4_mount.h          |    6 +-
 include/linux/nfs_fs.h              |   26 ++
 include/linux/nfs_fs_sb.h           |    2 +-
 include/linux/nfs_xdr.h             |    7 +
 include/linux/nfsd/export.h         |    5 +-
 include/linux/nfsd/nfsd.h           |    9 +-
 include/linux/nfsd/xdr4.h           |    3 +
 include/linux/security.h            |   88 +++++++
 include/linux/xattr.h               |    1 +
 security/capability.c               |   29 ++
 security/security.c                 |   32 +++
 security/selinux/hooks.c            |  141 +++++++++--
 security/selinux/include/security.h |    4 +
 security/selinux/ss/policydb.c      |    5 +-
 security/smack/smack_lsm.c          |   10 +
 34 files changed, 1315 insertions(+), 109 deletions(-)

