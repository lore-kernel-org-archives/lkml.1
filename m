Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab0BSREa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:04:30 -0500
Received: from kroah.org ([198.145.64.141]:57828 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755078Ab0BSRBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:01:14 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:54 2010
Message-Id: <20100219163254.575072774@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:30:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Chuck Lever <chuck.lever@oracle.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [85/93] NFS: Too many GETATTR and ACCESS calls after direct I/O
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit 65d269538a1129495ac45a14a777cd11cfe881d8 upstream.

The cached read and write paths initialize fattr->time_start in their
setup procedures.  The value of fattr->time_start is propagated to
read_cache_jiffies by nfs_update_inode().  Subsequent calls to
nfs_attribute_timeout() will then use a good time stamp when
computing the attribute cache timeout, and squelch unneeded GETATTR
calls.

Since the direct I/O paths erroneously leave the inode's
fattr->time_start field set to zero, read_cache_jiffies for that inode
is set to zero after any direct read or write operation.  This
triggers an otw GETATTR or ACCESS call to update the file's attribute
and access caches properly, even when the NFS READ or WRITE replies
have usable post-op attributes.

Make sure the direct read and write setup code performs the same fattr
initialization as the cached I/O paths to prevent unnecessary GETATTR
calls.

This was likely introduced by commit 0e574af1 in 2.6.15, which appears
to add new nfs_fattr_init() call sites in the cached read and write
paths, but not in the equivalent places in fs/nfs/direct.c.  A
subsequent commit in the same series, 33801147, introduces the
fattr->time_start field.

Interestingly, the direct write reschedule path already has a call to
nfs_fattr_init() in the right place.

Reported-by: Quentin Barnes <qbarnes@yahoo-inc.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/direct.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -342,6 +342,7 @@ static ssize_t nfs_direct_read_schedule_
 		data->res.fattr = &data->fattr;
 		data->res.eof = 0;
 		data->res.count = bytes;
+		nfs_fattr_init(&data->fattr);
 		msg.rpc_argp = &data->args;
 		msg.rpc_resp = &data->res;
 
@@ -575,6 +576,7 @@ static void nfs_direct_commit_schedule(s
 	data->res.count = 0;
 	data->res.fattr = &data->fattr;
 	data->res.verf = &data->verf;
+	nfs_fattr_init(&data->fattr);
 
 	NFS_PROTO(data->inode)->commit_setup(data, &msg);
 
@@ -766,6 +768,7 @@ static ssize_t nfs_direct_write_schedule
 		data->res.fattr = &data->fattr;
 		data->res.count = bytes;
 		data->res.verf = &data->verf;
+		nfs_fattr_init(&data->fattr);
 
 		task_setup_data.task = &data->task;
 		task_setup_data.callback_data = data;


