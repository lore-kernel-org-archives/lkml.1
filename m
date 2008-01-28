Return-Path: <linux-kernel-owner+w=401wt.eu-S1758520AbYA1WJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520AbYA1WJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:09:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbYA1WJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:09:13 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:46366 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013AbYA1WJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:09:12 -0500
Date: Tue, 29 Jan 2008 00:09:38 +0200
From: Adrian Bunk <bunk@kernel.org>
To: paul.moore@hp.com, James Morris <jmorris@namei.org>, sds@tycho.nsa.gov,
       eparis@parisplace.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] security/selinux/netlabel.c: fix double free
Message-ID: <20080128220938.GH8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a double free (security_netlbl_sid_to_secattr() already 
calls netlbl_secattr_destroy() when it returns !0) introduced by
commit 45c950e0f839fded922ebc0bfd59b1081cc71b70 and spotted by the 
Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
--- linux-2.6/security/selinux/netlabel.c.old	2008-01-23 00:38:19.000000000 +0200
+++ linux-2.6/security/selinux/netlabel.c	2008-01-23 00:39:09.000000000 +0200
@@ -58,22 +58,22 @@ static int selinux_netlbl_sock_setsid(st
 	rc = security_netlbl_sid_to_secattr(sid, &secattr);
 	if (rc != 0)
 		goto sock_setsid_return;
 	rc = netlbl_sock_setattr(sk, &secattr);
 	if (rc == 0) {
 		spin_lock_bh(&sksec->nlbl_lock);
 		sksec->nlbl_state = NLBL_LABELED;
 		spin_unlock_bh(&sksec->nlbl_lock);
 	}
 
-sock_setsid_return:
 	netlbl_secattr_destroy(&secattr);
+sock_setsid_return:
 	return rc;
 }
 
 /**
  * selinux_netlbl_cache_invalidate - Invalidate the NetLabel cache
  *
  * Description:
  * Invalidate the NetLabel security attribute mapping cache.
  *
  */

