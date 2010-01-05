Return-Path: <linux-kernel-owner+w=401wt.eu-S932181Ab0AEUi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181Ab0AEUi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:38:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754488Ab0AEUiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:38:00 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:51853 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780Ab0AEUh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:37:59 -0500
From: serue@us.ibm.com
To: greg@kroah.com
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, rsc@swtch.com,
       Ashwin Ganti <ashwin.ganti@gmail.com>, ericvh@gmail.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/6] p9auth: set fsuid
Date: Tue,  5 Jan 2010 14:37:25 -0600
Message-Id: <1262723850-9870-1-git-send-email-serue@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Serge E. Hallyn <serue@us.ibm.com>

fsuid should always trail euid changes.  So p9auth should
set fsuid as well when it sets ruid and euid.  Whether the
suid should also be set is an open question - keeping the
old uid in suid may be useful, or may just serve to trick
lazy userspace.

Note that so long as we do not also set suid, the setuid_fixup()
code will not (when we later switch to setresuid()) fully
fill/clear capability sets.  So while I had previously thought
that keeping suid unchanged would be useful, I think it is
better to change all uids.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Greg KH <greg@kroah.com>
cc: rsc@swtch.com
Cc: Ashwin Ganti <ashwin.ganti@gmail.com>
Cc: ericvh@gmail.com
Cc: devel@linuxdriverproject.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/staging/p9auth/p9auth.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/p9auth/p9auth.c b/drivers/staging/p9auth/p9auth.c
index db79626..70ef45b 100644
--- a/drivers/staging/p9auth/p9auth.c
+++ b/drivers/staging/p9auth/p9auth.c
@@ -275,10 +275,14 @@ static ssize_t cap_write(struct file *filp, const char __user *buf,
 					goto out;
 				}
 				/*
-				 * What all id's need to be changed here? uid,
-				 * euid, fsid, savedids ??  Currently I am
-				 * changing the effective user id since most of
-				 * the authorisation decisions are based on it
+				 * Change all uids.  It might be useful to
+				 * keep suid unchanged, however that will
+				 * mean that changing from uid=0 to uid=!0
+				 * pP is not emptied (only pE is), and when
+				 * changing from  uid=!0 to  uid=0, sets are
+				 * not filled.  They will be correct after
+				 * the next exec, but this is IMO not
+				 * sufficient.  So change all uids.
 				 */
 				new = prepare_creds();
 				if (!new) {
@@ -286,7 +290,7 @@ static ssize_t cap_write(struct file *filp, const char __user *buf,
 					goto out;
 				}
 				new->uid = (uid_t) target_int;
-				new->euid = (uid_t) target_int;
+				new->suid = new->fsuid = new->euid = new->uid;
 				retval = commit_creds(new);
 				if (retval)
 					goto out;
-- 
1.6.1

