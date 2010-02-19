Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab0BSRAo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:00:44 -0500
Received: from kroah.org ([198.145.64.141]:57532 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729Ab0BSRAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:36 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:41 2010
Message-Id: <20100219163241.268365398@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [38/93] NFS: Fix the mapping of the NFSERR_SERVERFAULT error
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit fdcb45777a3d1689c5541e1f85ee3ebbd197d2c1 upstream.

It was recently pointed out that the NFSERR_SERVERFAULT error, which is
designed to inform the user of a serious internal error on the server, was
being mapped to an error value that is internal to the kernel.

This patch maps it to the error EREMOTEIO, which is exported to userland
through errno.h.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/mount_clnt.c |    2 +-
 fs/nfs/nfs2xdr.c    |    2 +-
 fs/nfs/nfs4xdr.c    |    6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

--- a/fs/nfs/mount_clnt.c
+++ b/fs/nfs/mount_clnt.c
@@ -120,7 +120,7 @@ static struct {
 	{ .status = MNT3ERR_INVAL,		.errno = -EINVAL,	},
 	{ .status = MNT3ERR_NAMETOOLONG,	.errno = -ENAMETOOLONG,	},
 	{ .status = MNT3ERR_NOTSUPP,		.errno = -ENOTSUPP,	},
-	{ .status = MNT3ERR_SERVERFAULT,	.errno = -ESERVERFAULT,	},
+	{ .status = MNT3ERR_SERVERFAULT,	.errno = -EREMOTEIO,	},
 };
 
 struct mountres {
--- a/fs/nfs/nfs2xdr.c
+++ b/fs/nfs/nfs2xdr.c
@@ -699,7 +699,7 @@ static struct {
 	{ NFSERR_BAD_COOKIE,	-EBADCOOKIE	},
 	{ NFSERR_NOTSUPP,	-ENOTSUPP	},
 	{ NFSERR_TOOSMALL,	-ETOOSMALL	},
-	{ NFSERR_SERVERFAULT,	-ESERVERFAULT	},
+	{ NFSERR_SERVERFAULT,	-EREMOTEIO	},
 	{ NFSERR_BADTYPE,	-EBADTYPE	},
 	{ NFSERR_JUKEBOX,	-EJUKEBOX	},
 	{ -1,			-EIO		}
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -4554,7 +4554,7 @@ static int decode_sequence(struct xdr_st
 	 * If the server returns different values for sessionID, slotID or
 	 * sequence number, the server is looney tunes.
 	 */
-	status = -ESERVERFAULT;
+	status = -EREMOTEIO;
 
 	if (memcmp(id.data, res->sr_session->sess_id.data,
 		   NFS4_MAX_SESSIONID_LEN)) {
@@ -5678,7 +5678,7 @@ static struct {
 	{ NFS4ERR_BAD_COOKIE,	-EBADCOOKIE	},
 	{ NFS4ERR_NOTSUPP,	-ENOTSUPP	},
 	{ NFS4ERR_TOOSMALL,	-ETOOSMALL	},
-	{ NFS4ERR_SERVERFAULT,	-ESERVERFAULT	},
+	{ NFS4ERR_SERVERFAULT,	-EREMOTEIO	},
 	{ NFS4ERR_BADTYPE,	-EBADTYPE	},
 	{ NFS4ERR_LOCKED,	-EAGAIN		},
 	{ NFS4ERR_SYMLINK,	-ELOOP		},
@@ -5705,7 +5705,7 @@ nfs4_stat_to_errno(int stat)
 	}
 	if (stat <= 10000 || stat > 10100) {
 		/* The server is looney tunes. */
-		return -ESERVERFAULT;
+		return -EREMOTEIO;
 	}
 	/* If we cannot translate the error, the recovery routines should
 	 * handle it.


