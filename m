Return-Path: <linux-kernel-owner+w=401wt.eu-S1758777AbYAXRA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777AbYAXRA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:00:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758274AbYAXQ6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:58:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757140AbYAXQ6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:58:37 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 08/19] dlm: use fixed errno values in messages
Date: Thu, 24 Jan 2008 10:50:31 -0600
Message-Id: <1201193442-8260-9-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some errno values differ across platforms. So if we return things like
-EINPROGRESS from one node it can get misinterpreted or rejected on
another one.

This patch fixes up the errno values passed on the wire so that they
match the x86 ones (so as not to break the protocol), and re-instates
the platform-specific ones at the other end.

Many thanks to Fabio for testing this patch.
Initial patch from Patrick.

Signed-off-by: Patrick Caulfield <pcaulfie@redhat.com>
Signed-off-by: Fabio M. Di Nitto <fabbione@ubuntu.com>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/util.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/fs/dlm/util.c b/fs/dlm/util.c
index 38dcfeb..11c6a45 100644
--- a/fs/dlm/util.c
+++ b/fs/dlm/util.c
@@ -14,6 +14,14 @@
 #include "rcom.h"
 #include "util.h"
 
+#define DLM_ERRNO_EDEADLK		35
+#define DLM_ERRNO_EBADR			53
+#define DLM_ERRNO_EBADSLT		57
+#define DLM_ERRNO_EPROTO		71
+#define DLM_ERRNO_EOPNOTSUPP		95
+#define DLM_ERRNO_ETIMEDOUT	       110
+#define DLM_ERRNO_EINPROGRESS	       115
+
 static void header_out(struct dlm_header *hd)
 {
 	hd->h_version		= cpu_to_le32(hd->h_version);
@@ -30,6 +38,51 @@ static void header_in(struct dlm_header *hd)
 	hd->h_length		= le16_to_cpu(hd->h_length);
 }
 
+/* higher errno values are inconsistent across architectures, so select
+   one set of values for on the wire */
+
+static int to_dlm_errno(int err)
+{
+	switch (err) {
+	case -EDEADLK:
+		return -DLM_ERRNO_EDEADLK;
+	case -EBADR:
+		return -DLM_ERRNO_EBADR;
+	case -EBADSLT:
+		return -DLM_ERRNO_EBADSLT;
+	case -EPROTO:
+		return -DLM_ERRNO_EPROTO;
+	case -EOPNOTSUPP:
+		return -DLM_ERRNO_EOPNOTSUPP;
+	case -ETIMEDOUT:
+		return -DLM_ERRNO_ETIMEDOUT;
+	case -EINPROGRESS:
+		return -DLM_ERRNO_EINPROGRESS;
+	}
+	return err;
+}
+
+static int from_dlm_errno(int err)
+{
+	switch (err) {
+	case -DLM_ERRNO_EDEADLK:
+		return -EDEADLK;
+	case -DLM_ERRNO_EBADR:
+		return -EBADR;
+	case -DLM_ERRNO_EBADSLT:
+		return -EBADSLT;
+	case -DLM_ERRNO_EPROTO:
+		return -EPROTO;
+	case -DLM_ERRNO_EOPNOTSUPP:
+		return -EOPNOTSUPP;
+	case -DLM_ERRNO_ETIMEDOUT:
+		return -ETIMEDOUT;
+	case -DLM_ERRNO_EINPROGRESS:
+		return -EINPROGRESS;
+	}
+	return err;
+}
+
 void dlm_message_out(struct dlm_message *ms)
 {
 	struct dlm_header *hd = (struct dlm_header *) ms;
@@ -53,7 +106,7 @@ void dlm_message_out(struct dlm_message *ms)
 	ms->m_rqmode		= cpu_to_le32(ms->m_rqmode);
 	ms->m_bastmode		= cpu_to_le32(ms->m_bastmode);
 	ms->m_asts		= cpu_to_le32(ms->m_asts);
-	ms->m_result		= cpu_to_le32(ms->m_result);
+	ms->m_result		= cpu_to_le32(to_dlm_errno(ms->m_result));
 }
 
 void dlm_message_in(struct dlm_message *ms)
@@ -79,7 +132,7 @@ void dlm_message_in(struct dlm_message *ms)
 	ms->m_rqmode		= le32_to_cpu(ms->m_rqmode);
 	ms->m_bastmode		= le32_to_cpu(ms->m_bastmode);
 	ms->m_asts		= le32_to_cpu(ms->m_asts);
-	ms->m_result		= le32_to_cpu(ms->m_result);
+	ms->m_result		= from_dlm_errno(le32_to_cpu(ms->m_result));
 }
 
 static void rcom_lock_out(struct rcom_lock *rl)
-- 
1.5.3.3

