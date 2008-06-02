Return-Path: <linux-kernel-owner+w=401wt.eu-S1755134AbYFBREw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134AbYFBREw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 13:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbYFBREn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 13:04:43 -0400
Received: from smtp103.prem.mail.sp1.yahoo.com ([98.136.44.58]:41459 "HELO
	smtp103.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752225AbYFBREn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:04:43 -0400
X-YMail-OSG: DGWf43MVM1n_2sYN0PJvNCn2iPbIm9k2sx41_hFuARTfibQSn_nbcy.xRZn1V2AuJzza.KAYrQn0Z0M7P9MLqcB9SJtoy7blYZnbxg--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <48442820.3080400@schaufler-ca.com>
Date: Mon, 02 Jun 2008 10:04:32 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Miklos Szeredi <miklos@szeredi.hu>, lcapitulino@mandriva.com.br
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] Smack: fuse mount hang fix
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Casey Schaufler <casey@schaufler-ca.com>

The d_instantiate hook for Smack can hang on the root
inode of a filesystem if the file system code has not
really done all the set-up. Fuse is known to encounter
this problem. This change detects an attempt to
instantiate a root inode and addresses it early in the
processing, before any attempt is made to do something
that might hang.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---

security/smack/smack_lsm.c |   12 ++++++++++++
1 file changed, 12 insertions(+)

diff -uprN -X linux-2.6.25-g0530-base/Documentation/dontdiff linux-2.6.25-g0530-base/security/smack/smack_lsm.c linux-2.6.25-g0530/security/smack/smack_lsm.c
--- linux-2.6.25-g0530-base/security/smack/smack_lsm.c	2008-06-01 14:41:06.000000000 -0700
+++ linux-2.6.25-g0530/security/smack/smack_lsm.c	2008-06-01 20:29:57.000000000 -0700
@@ -1881,6 +1881,18 @@ static void smack_d_instantiate(struct d
	final = sbsp->smk_default;

	/*
+	 * If this is the root inode the superblock
+	 * may be in the process of initialization.
+	 * If that is the case use the root value out
+	 * of the superblock.
+	 */
+	if (opt_dentry->d_parent == opt_dentry) {
+		isp->smk_inode = sbsp->smk_root;
+		isp->smk_flags |= SMK_INODE_INSTANT;
+		goto unlockandout;
+	}
+
+	/*
	 * This is pretty hackish.
	 * Casey says that we shouldn't have to do
	 * file system specific code, but it does help




