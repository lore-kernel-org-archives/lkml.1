Return-Path: <linux-kernel-owner+w=401wt.eu-S1764923AbYFGB1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764923AbYFGB1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760811AbYFGBJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:09:53 -0400
Received: from sous-sol.org ([216.99.217.87]:42574 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760748AbYFGBJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:09:34 -0400
Message-Id: <20080607010630.821493223@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:56 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: [patch 41/50] Smack: fuse mount hang fix
Content-Disposition: inline; filename=smack-fuse-mount-hang-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Casey Schaufler <casey@schaufler-ca.com>

upstream commit: e97dcb0eadbb821eccd549d4987b653cf61e2374

The d_instantiate hook for Smack can hang on the root inode of a
filesystem if the file system code has not really done all the set-up.
Fuse is known to encounter this problem.

This change detects an attempt to instantiate a root inode and addresses
it early in the processing, before any attempt is made to do something
that might hang.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Tested-by: Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 security/smack/smack_lsm.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1865,6 +1865,18 @@ static void smack_d_instantiate(struct d
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

-- 
