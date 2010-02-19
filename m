Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab0BSRNi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:13:38 -0500
Received: from kroah.org ([198.145.64.141]:57503 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684Ab0BSRAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:32 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:40 2010
Message-Id: <20100219163239.911121165@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [33/93] NFSv4: Dont allow posix locking against servers that dont support it
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 8e469ebd6dc32cbaf620e134d79f740bf0ebab79 upstream.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/nfs4_fs.h  |    1 +
 fs/nfs/nfs4proc.c |    7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -141,6 +141,7 @@ enum {
 	NFS_O_RDWR_STATE,		/* OPEN stateid has read/write state */
 	NFS_STATE_RECLAIM_REBOOT,	/* OPEN stateid server rebooted */
 	NFS_STATE_RECLAIM_NOGRACE,	/* OPEN stateid needs to recover state */
+	NFS_STATE_POSIX_LOCKS,		/* Posix locks are supported */
 };
 
 struct nfs4_state {
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1573,6 +1573,8 @@ static int _nfs4_do_open(struct inode *d
 	status = PTR_ERR(state);
 	if (IS_ERR(state))
 		goto err_opendata_put;
+	if ((opendata->o_res.rflags & NFS4_OPEN_RESULT_LOCKTYPE_POSIX) != 0)
+		set_bit(NFS_STATE_POSIX_LOCKS, &state->flags);
 	nfs4_opendata_put(opendata);
 	nfs4_put_state_owner(sp);
 	*res = state;
@@ -4060,8 +4062,11 @@ static int _nfs4_proc_setlk(struct nfs4_
 {
 	struct nfs_inode *nfsi = NFS_I(state->inode);
 	unsigned char fl_flags = request->fl_flags;
-	int status;
+	int status = -ENOLCK;
 
+	if ((fl_flags & FL_POSIX) &&
+			!test_bit(NFS_STATE_POSIX_LOCKS, &state->flags))
+		goto out;
 	/* Is this a delegated open? */
 	status = nfs4_set_lock_state(state, request);
 	if (status != 0)


