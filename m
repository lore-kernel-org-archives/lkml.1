Return-Path: <linux-kernel-owner+w=401wt.eu-S1751161AbZHSEp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751161AbZHSEp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 00:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbZHSEpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 00:45:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49329 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751114AbZHSEpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 00:45:20 -0400
Date: Wed, 19 Aug 2009 00:44:44 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: esandeen@redhat.com, eteo@redhat.com, eparis@redhat.com,
       Amerigo Wang <amwang@redhat.com>, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, sds@tycho.nsa.gov,
       hirofumi@mail.parknet.co.jp, viro@zeniv.linux.org.uk
Message-Id: <20090819044709.5380.28436.sendpatchset@localhost.localdomain>
In-Reply-To: <20090819044658.5380.43869.sendpatchset@localhost.localdomain>
References: <20090819044658.5380.43869.sendpatchset@localhost.localdomain>
Subject: [Patch 1/2] selinux: adjust rules for ATTR_FORCE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[PATCH] selinux: adjust rules for ATTR_FORCE

From: Amerigo Wang <amwang@redhat.com>

As suggested by OGAWA Hirofumi in thread: http://lkml.org/lkml/2009/8/7/132,
we should let selinux_inode_setattr() to match our ATTR_* rules.
ATTR_FORCE should not force things like ATTR_SIZE.

Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: WANG Cong <amwang@redhat.com>
[tweaked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> ]
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>

---
 security/selinux/hooks.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN security/selinux/hooks.c~selinux-truncate-fix security/selinux/hooks.c
--- linux-2.6/security/selinux/hooks.c~selinux-truncate-fix	2009-08-18 06:27:58.000000000 +0900
+++ linux-2.6-hirofumi/security/selinux/hooks.c	2009-08-18 16:10:50.000000000 +0900
@@ -2711,12 +2711,18 @@ static int selinux_inode_permission(stru
 static int selinux_inode_setattr(struct dentry *dentry, struct iattr *iattr)
 {
 	const struct cred *cred = current_cred();
+	unsigned int ia_valid = iattr->ia_valid;
 
-	if (iattr->ia_valid & ATTR_FORCE)
-		return 0;
+	/* ATTR_FORCE is just used for ATTR_KILL_S[UG]ID. */
+	if (ia_valid & ATTR_FORCE) {
+		ia_valid &= ~(ATTR_KILL_SUID | ATTR_KILL_SGID | ATTR_MODE |
+			      ATTR_FORCE);
+		if (!ia_valid)
+			return 0;
+	}
 
-	if (iattr->ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID |
-			       ATTR_ATIME_SET | ATTR_MTIME_SET))
+	if (ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID |
+			ATTR_ATIME_SET | ATTR_MTIME_SET | ATTR_TIMES_SET))
 		return dentry_has_perm(cred, NULL, dentry, FILE__SETATTR);
 
 	return dentry_has_perm(cred, NULL, dentry, FILE__WRITE);
_
