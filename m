Return-Path: <linux-kernel-owner+w=401wt.eu-S1762816AbXH0UZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762816AbXH0UZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 16:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761214AbXH0UXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 16:23:06 -0400
Received: from mail.fieldses.org ([66.93.2.214]:43337 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759194AbXH0UW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 16:22:59 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: linux-kernel@vger.kernel.org
Cc: nfs@lists.sourceforge.net, Neil Brown <neilb@suse.de>,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [PATCH 06/15] knfsd: demote some printk()s to dprintk()s
Date: Mon, 27 Aug 2007 16:22:47 -0400
Message-Id: <1188246177195-git-send-email-bfields@fieldses.org>
X-Mailer: git-send-email 1.5.3.rc6.48.g17437
In-Reply-To: <11882461771774-git-send-email-bfields@fieldses.org>
References: <11882461763072-git-send-email-bfields@fieldses.org>
 <1188246176681-git-send-email-bfields@fieldses.org>
 <1188246176897-git-send-email-bfields@fieldses.org>
 <1188246177833-git-send-email-bfields@fieldses.org>
 <11882461773576-git-send-email-bfields@fieldses.org>
 <11882461771774-git-send-email-bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: J. Bruce Fields <bfields@citi.umich.edu>

To quote a recent mail from Andrew Morton:

	Look: if there's a way in which an unprivileged user can trigger
	a printk we fix it, end of story.

OK.  I assume that goes double for printk()s that might be triggered by
random hosts on the internet.  So, disable some printk()s that look like
they could be triggered by malfunctioning or malicious clients.  For
now, just downgrade them to dprintk()s.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
---
 fs/nfsd/nfs4proc.c  |    4 ++--
 fs/nfsd/nfs4state.c |   20 ++++++++++----------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 29b7e63..18ead17 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -238,12 +238,12 @@ nfsd4_open(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 			break;
              	case NFS4_OPEN_CLAIM_DELEGATE_PREV:
 			open->op_stateowner->so_confirmed = 1;
-			printk("NFSD: unsupported OPEN claim type %d\n",
+			dprintk("NFSD: unsupported OPEN claim type %d\n",
 				open->op_claim_type);
 			status = nfserr_notsupp;
 			goto out;
 		default:
-			printk("NFSD: Invalid OPEN claim type %d\n",
+			dprintk("NFSD: Invalid OPEN claim type %d\n",
 				open->op_claim_type);
 			status = nfserr_inval;
 			goto out;
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 578d809..2b20eb8 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -509,7 +509,7 @@ check_name(struct xdr_netobj name) {
 	if (name.len == 0) 
 		return 0;
 	if (name.len > NFS4_OPAQUE_LIMIT) {
-		printk("NFSD: check_name: name too long(%d)!\n", name.len);
+		dprintk("NFSD: check_name: name too long(%d)!\n", name.len);
 		return 0;
 	}
 	return 1;
@@ -1742,7 +1742,7 @@ out:
 	if (open->op_claim_type == NFS4_OPEN_CLAIM_PREVIOUS
 			&& flag == NFS4_OPEN_DELEGATE_NONE
 			&& open->op_delegate_type != NFS4_OPEN_DELEGATE_NONE)
-		printk("NFSD: WARNING: refusing delegation reclaim\n");
+		dprintk("NFSD: WARNING: refusing delegation reclaim\n");
 	open->op_delegate_type = flag;
 }
 
@@ -2151,7 +2151,7 @@ nfs4_preprocess_seqid_op(struct svc_fh *current_fh, u32 seqid, stateid_t *statei
 	*sopp = NULL;
 
 	if (ZERO_STATEID(stateid) || ONE_STATEID(stateid)) {
-		printk("NFSD: preprocess_seqid_op: magic stateid!\n");
+		dprintk("NFSD: preprocess_seqid_op: magic stateid!\n");
 		return nfserr_bad_stateid;
 	}
 
@@ -2202,7 +2202,7 @@ nfs4_preprocess_seqid_op(struct svc_fh *current_fh, u32 seqid, stateid_t *statei
 	}
 
 	if ((flags & CHECK_FH) && nfs4_check_fh(current_fh, stp)) {
-		printk("NFSD: preprocess_seqid_op: fh-stateid mismatch!\n");
+		dprintk("NFSD: preprocess_seqid_op: fh-stateid mismatch!\n");
 		return nfserr_bad_stateid;
 	}
 
@@ -2218,22 +2218,22 @@ nfs4_preprocess_seqid_op(struct svc_fh *current_fh, u32 seqid, stateid_t *statei
 		goto check_replay;
 
 	if (sop->so_confirmed && flags & CONFIRM) {
-		printk("NFSD: preprocess_seqid_op: expected"
+		dprintk("NFSD: preprocess_seqid_op: expected"
 				" unconfirmed stateowner!\n");
 		return nfserr_bad_stateid;
 	}
 	if (!sop->so_confirmed && !(flags & CONFIRM)) {
-		printk("NFSD: preprocess_seqid_op: stateowner not"
+		dprintk("NFSD: preprocess_seqid_op: stateowner not"
 				" confirmed yet!\n");
 		return nfserr_bad_stateid;
 	}
 	if (stateid->si_generation > stp->st_stateid.si_generation) {
-		printk("NFSD: preprocess_seqid_op: future stateid?!\n");
+		dprintk("NFSD: preprocess_seqid_op: future stateid?!\n");
 		return nfserr_bad_stateid;
 	}
 
 	if (stateid->si_generation < stp->st_stateid.si_generation) {
-		printk("NFSD: preprocess_seqid_op: old stateid!\n");
+		dprintk("NFSD: preprocess_seqid_op: old stateid!\n");
 		return nfserr_old_stateid;
 	}
 	renew_client(sop->so_client);
@@ -2245,7 +2245,7 @@ check_replay:
 		/* indicate replay to calling function */
 		return nfserr_replay_me;
 	}
-	printk("NFSD: preprocess_seqid_op: bad seqid (expected %d, got %d)\n",
+	dprintk("NFSD: preprocess_seqid_op: bad seqid (expected %d, got %d)\n",
 			sop->so_seqid, seqid);
 	*sopp = NULL;
 	return nfserr_bad_seqid;
@@ -2858,7 +2858,7 @@ nfsd4_lockt(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 			file_lock.fl_type = F_WRLCK;
 		break;
 		default:
-			printk("NFSD: nfs4_lockt: bad lock type!\n");
+			dprintk("NFSD: nfs4_lockt: bad lock type!\n");
 			status = nfserr_inval;
 		goto out;
 	}
-- 
1.5.3.rc5.19.g0734d

