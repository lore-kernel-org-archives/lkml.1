Return-Path: <linux-kernel-owner+w=401wt.eu-S1755703AbYGGQxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703AbYGGQxc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbYGGQuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:50:15 -0400
Received: from aa2005110791d2e6c28a.userreverse.dion.ne.jp ([210.230.194.138]:20574
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755094AbYGGQuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:50:13 -0400
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jul 2008 12:49:54 EDT
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/20] selinux: fix endianness bug in network node address handling
Date: Tue,  8 Jul 2008 01:42:11 +0900
Message-Id: <1215448942-17581-10-git-send-email-jmorris@namei.org>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1215448942-17581-1-git-send-email-jmorris@namei.org>
References: <1215448942-17581-1-git-send-email-jmorris@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Smalley <sds@tycho.nsa.gov>

Fix an endianness bug in the handling of network node addresses by
SELinux.  This yields no change on little endian hardware but fixes
the incorrect handling on big endian hardware.  The network node
addresses are stored in network order in memory by checkpolicy, not in
cpu/host order, and thus should not have cpu_to_le32/le32_to_cpu
conversions applied upon policy write/read unlike other data in the
policy.

Bug reported by John Weeks of Sun, who noticed that binary policy
files built from the same policy source on x86 and sparc differed and
tracked it down to the ipv4 address handling in checkpolicy.

Signed-off-by:  Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: James Morris <jmorris@namei.org>
---
 security/selinux/ss/policydb.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
index 84f8cc7..2391761 100644
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -1478,7 +1478,8 @@ int policydb_read(struct policydb *p, void *fp)
 	struct ocontext *l, *c, *newc;
 	struct genfs *genfs_p, *genfs, *newgenfs;
 	int i, j, rc;
-	__le32 buf[8];
+	__le32 buf[4];
+	u32 nodebuf[8];
 	u32 len, len2, config, nprim, nel, nel2;
 	char *policydb_str;
 	struct policydb_compat_info *info;
@@ -1749,11 +1750,11 @@ int policydb_read(struct policydb *p, void *fp)
 					goto bad;
 				break;
 			case OCON_NODE:
-				rc = next_entry(buf, fp, sizeof(u32) * 2);
+				rc = next_entry(nodebuf, fp, sizeof(u32) * 2);
 				if (rc < 0)
 					goto bad;
-				c->u.node.addr = le32_to_cpu(buf[0]);
-				c->u.node.mask = le32_to_cpu(buf[1]);
+				c->u.node.addr = nodebuf[0]; /* network order */
+				c->u.node.mask = nodebuf[1]; /* network order */
 				rc = context_read_and_validate(&c->context[0], p, fp);
 				if (rc)
 					goto bad;
@@ -1782,13 +1783,13 @@ int policydb_read(struct policydb *p, void *fp)
 			case OCON_NODE6: {
 				int k;
 
-				rc = next_entry(buf, fp, sizeof(u32) * 8);
+				rc = next_entry(nodebuf, fp, sizeof(u32) * 8);
 				if (rc < 0)
 					goto bad;
 				for (k = 0; k < 4; k++)
-					c->u.node6.addr[k] = le32_to_cpu(buf[k]);
+					c->u.node6.addr[k] = nodebuf[k];
 				for (k = 0; k < 4; k++)
-					c->u.node6.mask[k] = le32_to_cpu(buf[k+4]);
+					c->u.node6.mask[k] = nodebuf[k+4];
 				if (context_read_and_validate(&c->context[0], p, fp))
 					goto bad;
 				break;
-- 
1.5.5.1

