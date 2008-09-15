Return-Path: <linux-kernel-owner+w=401wt.eu-S1756762AbYIOVI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbYIOVI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 17:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756597AbYIOVGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 17:06:45 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:64412 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754933AbYIOVG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 17:06:27 -0400
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, matthew.dodd@sparta.com, trond.myklebust@fys.uio.no,
       bfields@fieldses.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: [RFC] Labeled NFS Take 2
Date: Mon, 15 Sep 2008 16:41:04 -0400
Message-Id: <1221511278-28051-1-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It has been six months since the last time we submitted a patch set to the
mailing list for review. In this time we have fixed almost all of the issues
that people have had with the last patch set and have added a new feature to
allow for process labels to be transported with the RPC request. Below I
review each of the issues raised with the last patch set and what was done to
fix them. I also list the features present in this patch set and known issues.

When reviewing the code please be critical of it. We have reached the point
where we think we have the proper set of initial features implemented so we
would like to address all of the major and minor concerns with the code so it
can be cleaned up and submitted for inclusion. If you want a tree with the
patches already applied we have posted a public git tree that is ready for
cloning and use. This tree can be found at http://git.selinuxproject.org/git
and can be cloned with the command below. You can also find information on how
to setup a labeled nfs mount at http://www.selinuxproject.org/page/Labeled_NFS
however the putclientlabel mount option specified in the setup document is no
longer supported.

git-clone git://git.selinuxproject.org/~dpquigl/lnfs.git

Features:

* Client
	* Obtains labels from server for NFS files while still allowing for
	SELinux context mounts to override untrusted labeled servers.
	* Allows setting labels on files over NFS via xattr interface.
	* New security flavor (auth_seclabel) to transport process label to
	  server. This is a derivative of auth_unix so it does not support
	  kerberos which has its own issues that need to be dealt with.
* Server
	* Exports labels to clients. As of the moment there is no ability to
	restrict this based on label components such as MLS levels.
	* Persistent storage of labels assuming exported file system supports
	it.
	* If present uses process label for permission checks on server. Only
	effective if both client and server are running the same MAC model and
	policy. This will be addressed later by the label translation work.

Known Limitations/Bugs

If you want to utilize process label transport and file labels properly each
side must implement the same MAC model and be running the same policy. It is
possible for two SELinux systems to talk to each other if they have different
policies however from a policy perspective you can't be guaranteed that a type
on the client means the same thing on the server. Work is being done on
providing a DOI translation framework but is currently on the back burner so
work can be done to polish up this prototype and work on the IETF documents.

Concerns from last submission:

The patch to add maclabel_getname has been removed and replaced with the
{get,set,notify}secctx hooks that were discussed on the mailing list.

The use of the iattr structure to pass label data up and down the call stack
has been replace with a method that mimics the NFSv4 ACL implementation. A new
structure nfs4_label has been added and is added to the necessary functions to
pass the data around. 

Andrew's request to make the name and value pointers to the vfs helper for
setxattr const has been addressed.

The lifecycle management patch for the fattr structure has not been addressed
because it will probably be replaced with a method similar to what we did to
fix the iattr problem. Also the maximum label size has been set at 4096. I
know there are some concerns with hard limits on label size but Trond and
Bruce have brought up issues with doing memory reallocation inside of the XDR
handlers. Since it isn't appropriate to realloc memory there and there is no
effective retry capability if the buffer isn't large enough this doesn't seem
like an option.

The mount code has been changed to use Eric Paris's new security parameter
and now it uses the new text based mount system.

---

 fs/Kconfig                          |   17 ++
 fs/nfs/client.c                     |   18 ++-
 fs/nfs/dir.c                        |   24 ++
 fs/nfs/getroot.c                    |   34 +++
 fs/nfs/inode.c                      |   61 +++++-
 fs/nfs/namespace.c                  |    3 +
 fs/nfs/nfs3proc.c                   |   10 +
 fs/nfs/nfs4proc.c                   |  447 +++++++++++++++++++++++++++++++---
 fs/nfs/nfs4xdr.c                    |   56 ++++-
 fs/nfs/proc.c                       |   12 +-
 fs/nfs/super.c                      |   29 +++-
 fs/nfsd/auth.c                      |   21 ++
 fs/nfsd/export.c                    |    3 +
 fs/nfsd/nfs4proc.c                  |   25 ++-
 fs/nfsd/nfs4xdr.c                   |  101 ++++++++-
 fs/nfsd/vfs.c                       |   22 ++
 fs/xattr.c                          |   55 ++++-
 include/linux/nfs4.h                |    8 +
 include/linux/nfs4_mount.h          |    8 +-
 include/linux/nfs_fs.h              |   48 ++++
 include/linux/nfs_fs_sb.h           |    2 +-
 include/linux/nfs_xdr.h             |    7 +
 include/linux/nfsd/export.h         |    5 +-
 include/linux/nfsd/nfsd.h           |    9 +-
 include/linux/nfsd/xdr4.h           |    3 +
 include/linux/security.h            |   75 ++++++
 include/linux/sunrpc/auth.h         |    4 +
 include/linux/sunrpc/msg_prot.h     |    1 +
 include/linux/sunrpc/svcauth.h      |    4 +
 include/linux/xattr.h               |    1 +
 net/sunrpc/Makefile                 |    1 +
 net/sunrpc/auth.c                   |   16 ++
 net/sunrpc/auth_seclabel.c          |  291 +++++++++++++++++++++++
 net/sunrpc/svc.c                    |    1 +
 net/sunrpc/svcauth.c                |    6 +
 net/sunrpc/svcauth_unix.c           |   97 ++++++++-
 security/security.c                 |   34 +++
 security/selinux/hooks.c            |  148 ++++++++++--
 security/selinux/include/security.h |    4 +
 security/selinux/ss/policydb.c      |    5 +-
 security/smack/smack_lsm.c          |   11 +
 41 files changed, 1627 insertions(+), 100 deletions(-)

