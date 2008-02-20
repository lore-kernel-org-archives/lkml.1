Return-Path: <linux-kernel-owner+w=401wt.eu-S1764426AbYBTVDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764426AbYBTVDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 16:03:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753665AbYBTVCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 16:02:53 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:36471 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbYBTVCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 16:02:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BgaePTHYHbkpmlhrpl9D4vGluF3R7EARyXQGHQmh8oQ7H0jiCkifFXvJt7ogZiRvB8Ho95DpSd8SPIgxiVVCBRDTNN/zAc7cYGWB8V2x+nYgWFc1GlORYNt8mUvQRN/PdXzla22ba9y29tdtL2NLlOi654Q1kyc7r6rxgvw7S2o=
Subject: [PATCH] nfs: fix sparse warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1203540206.17505.3.camel@heimdal.trondhjem.org>
References: <1203538246.25307.14.camel@brick>
	 <1203540206.17505.3.camel@heimdal.trondhjem.org>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 13:03:05 -0800
Message-Id: <1203541385.25307.29.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/nfs/nfs4state.c:788:34: warning: Using plain integer as NULL pointer
fs/nfs/delegation.c:52:34: warning: Using plain integer as NULL pointer
fs/nfs/idmap.c:312:12: warning: Using plain integer as NULL pointer
fs/nfs/callback_xdr.c:257:6: warning: Using plain integer as NULL pointer
fs/nfs/callback_xdr.c:270:6: warning: Using plain integer as NULL pointer
fs/nfs/callback_xdr.c:281:6: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Rollup patches 1-4.
 fs/nfs/callback_xdr.c |    6 +++---
 fs/nfs/delegation.c   |    2 +-
 fs/nfs/idmap.c        |    2 +-
 fs/nfs/nfs4state.c    |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/nfs/callback_xdr.c b/fs/nfs/callback_xdr.c
index c63eb72..13619d2 100644
--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -254,7 +254,7 @@ static __be32 encode_attr_change(struct xdr_stream *xdr, const uint32_t *bitmap,
 	if (!(bitmap[0] & FATTR4_WORD0_CHANGE))
 		return 0;
 	p = xdr_reserve_space(xdr, 8);
-	if (unlikely(p == 0))
+	if (unlikely(!p))
 		return htonl(NFS4ERR_RESOURCE);
 	p = xdr_encode_hyper(p, change);
 	return 0;
@@ -267,7 +267,7 @@ static __be32 encode_attr_size(struct xdr_stream *xdr, const uint32_t *bitmap, u
 	if (!(bitmap[0] & FATTR4_WORD0_SIZE))
 		return 0;
 	p = xdr_reserve_space(xdr, 8);
-	if (unlikely(p == 0))
+	if (unlikely(!p))
 		return htonl(NFS4ERR_RESOURCE);
 	p = xdr_encode_hyper(p, size);
 	return 0;
@@ -278,7 +278,7 @@ static __be32 encode_attr_time(struct xdr_stream *xdr, const struct timespec *ti
 	__be32 *p;
 
 	p = xdr_reserve_space(xdr, 12);
-	if (unlikely(p == 0))
+	if (unlikely(!p))
 		return htonl(NFS4ERR_RESOURCE);
 	p = xdr_encode_hyper(p, time->tv_sec);
 	*p = htonl(time->tv_nsec);
diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index b9eadd1..00a5e44 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -49,7 +49,7 @@ static int nfs_delegation_claim_locks(struct nfs_open_context *ctx, struct nfs4_
 	struct file_lock *fl;
 	int status;
 
-	for (fl = inode->i_flock; fl != 0; fl = fl->fl_next) {
+	for (fl = inode->i_flock; fl != NULL; fl = fl->fl_next) {
 		if (!(fl->fl_flags & (FL_POSIX|FL_FLOCK)))
 			continue;
 		if (nfs_file_open_context(fl->fl_file) != ctx)
diff --git a/fs/nfs/idmap.c b/fs/nfs/idmap.c
index 8ae5dba..86147b0 100644
--- a/fs/nfs/idmap.c
+++ b/fs/nfs/idmap.c
@@ -309,7 +309,7 @@ nfs_idmap_name(struct idmap *idmap, struct idmap_hashtable *h,
 	mutex_lock(&idmap->idmap_im_lock);
 
 	he = idmap_lookup_id(h, id);
-	if (he != 0) {
+	if (he) {
 		memcpy(name, he->ih_name, he->ih_namelen);
 		ret = he->ih_namelen;
 		goto out;
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 6233eb5..b962397 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -785,7 +785,7 @@ static int nfs4_reclaim_locks(struct nfs4_state_recovery_ops *ops, struct nfs4_s
 	struct file_lock *fl;
 	int status = 0;
 
-	for (fl = inode->i_flock; fl != 0; fl = fl->fl_next) {
+	for (fl = inode->i_flock; fl != NULL; fl = fl->fl_next) {
 		if (!(fl->fl_flags & (FL_POSIX|FL_FLOCK)))
 			continue;
 		if (nfs_file_open_context(fl->fl_file)->state != state)
-- 
1.5.4.2.200.g99e75



