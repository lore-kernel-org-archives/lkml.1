Return-Path: <linux-kernel-owner+w=401wt.eu-S1765341AbXFER5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765341AbXFER5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 13:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbXFER5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 13:57:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755900AbXFER5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 13:57:04 -0400
Date: Tue, 5 Jun 2007 13:56:55 -0400
From: Jeff Layton <jlayton@redhat.com>
To: nfsv4@linux-nfs.org, nfs@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] nfsd: set the response bitmask for an EXCLUSIVE CREATE
Message-Id: <20070605135655.a58f0b41.jlayton@redhat.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

RFC 3530 says:

 If the server uses an attribute to store the exclusive
 create verifier, it will signify which attribute by setting the
 appropriate bit in the attribute mask that is returned in the
 results.

Linux uses the atime and mtime to store the verifier, but sends a zeroed out
bitmask back to the client. This patch makes sure that we set the correct
bits in the bitmask in this situation.

Signed-off-by: Jeff Layton <jlayton@redhat.com>

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 8522729..da20674 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -99,7 +99,15 @@ do_open_lookup(struct svc_rqst *rqstp, struct svc_fh *current_fh, struct nfsd4_o
 		status = nfsd_create_v3(rqstp, current_fh, open->op_fname.data,
 					open->op_fname.len, &open->op_iattr,
 					&resfh, open->op_createmode,
-					(u32 *)open->op_verf.data, &open->op_truncate, &created);
+					(u32 *)open->op_verf.data,
+					&open->op_truncate, &created);
+
+		/* If we ever decide to use different attrs to store the
+		 * verifier in nfsd_create_v3, then we'll need to change this
+		 */
+		if (open->op_createmode == NFS4_CREATE_EXCLUSIVE && status == 0)
+			open->op_bmval[1] |= (FATTR4_WORD1_TIME_ACCESS |
+						FATTR4_WORD1_TIME_MODIFY);
 	} else {
 		status = nfsd_lookup(rqstp, current_fh,
 				     open->op_fname.data, open->op_fname.len, &resfh);
