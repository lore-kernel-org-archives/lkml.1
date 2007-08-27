Return-Path: <linux-kernel-owner+w=401wt.eu-S1763646AbXH0U27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763646AbXH0U27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 16:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762104AbXH0UXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 16:23:17 -0400
Received: from mail.fieldses.org ([66.93.2.214]:43359 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760170AbXH0UXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 16:23:02 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: linux-kernel@vger.kernel.org
Cc: nfs@lists.sourceforge.net, Neil Brown <neilb@suse.de>,
       "Luiz Fernando N. Capitulino" <lcapitulino@gmail.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [PATCH 10/15] knfsd: Validate filehandle type in fsid_source
Date: Mon, 27 Aug 2007 16:22:51 -0400
Message-Id: <11882461773221-git-send-email-bfields@fieldses.org>
X-Mailer: git-send-email 1.5.3.rc6.48.g17437
In-Reply-To: <1188246177192-git-send-email-bfields@fieldses.org>
References: <11882461763072-git-send-email-bfields@fieldses.org>
 <1188246176681-git-send-email-bfields@fieldses.org>
 <1188246176897-git-send-email-bfields@fieldses.org>
 <1188246177833-git-send-email-bfields@fieldses.org>
 <11882461773576-git-send-email-bfields@fieldses.org>
 <11882461771774-git-send-email-bfields@fieldses.org>
 <1188246177195-git-send-email-bfields@fieldses.org>
 <11882461773396-git-send-email-bfields@fieldses.org>
 <1188246177259-git-send-email-bfields@fieldses.org>
 <1188246177192-git-send-email-bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Brown <neilb@suse.de>

fsid_source decided where to get the 'fsid' number to
return for a GETATTR based on the type of filehandle.
It can be from the device, from the fsid, or from the
UUID.

It is possible for the filehandle to be inconsistent
with the export information, so make sure the export information
actually has the info implied by the value returned by
fsid_source.

Signed-off-by: Neil Brown <neilb@suse.de>
Cc: "Luiz Fernando N. Capitulino" <lcapitulino@gmail.com>
Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
---
 fs/nfsd/nfsfh.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
index 0eb464a..7011d62 100644
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -566,13 +566,23 @@ enum fsid_source fsid_source(struct svc_fh *fhp)
 	case FSID_DEV:
 	case FSID_ENCODE_DEV:
 	case FSID_MAJOR_MINOR:
-		return FSIDSOURCE_DEV;
+		if (fhp->fh_export->ex_dentry->d_inode->i_sb->s_type->fs_flags
+		    & FS_REQUIRES_DEV)
+			return FSIDSOURCE_DEV;
+		break;
 	case FSID_NUM:
-		return FSIDSOURCE_FSID;
-	default:
 		if (fhp->fh_export->ex_flags & NFSEXP_FSID)
 			return FSIDSOURCE_FSID;
-		else
-			return FSIDSOURCE_UUID;
+		break;
+	default:
+		break;
 	}
+	/* either a UUID type filehandle, or the filehandle doesn't
+	 * match the export.
+	 */
+	if (fhp->fh_export->ex_flags & NFSEXP_FSID)
+		return FSIDSOURCE_FSID;
+	if (fhp->fh_export->ex_uuid)
+		return FSIDSOURCE_UUID;
+	return FSIDSOURCE_DEV;
 }
-- 
1.5.3.rc5.19.g0734d

