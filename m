Return-Path: <linux-kernel-owner+w=401wt.eu-S2992530AbXCWQxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992530AbXCWQxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 12:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992532AbXCWQxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 12:53:48 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:48906 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992530AbXCWQxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 12:53:46 -0400
Subject: [Patch -mm 1/1] SLIM LSM getprocattr hook API change
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: safford@watson.ibm.com, serue@linux.vnet.ibm.com,
       kjhall@linux.vnet.ibm.com, zohar@us.ibm.com, akpm@osdl.org
Content-Type: text/plain
Date: Fri, 23 Mar 2007 12:52:08 -0400
Message-Id: <1174668728.18725.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch addresses the 2.6.21-rc4 LSM getprocattr hook API change.

signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
Index: linux-2.6.21-rc4-mm1/security/slim/slm_main.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/security/slim/slm_main.c
+++ linux-2.6.21-rc4-mm1/security/slim/slm_main.c
@@ -1269,25 +1269,29 @@ static int slm_setprocattr(struct task_s
 }
 
 static int slm_getprocattr(struct task_struct *tsk,
-				  char *name, void *value, size_t size)
+				  char *name, char **value)
 {
 	struct slm_tsec_data *tsec = tsk->security;
 	size_t len = 0;
+	int buf_size = 31;
+	char buf[buf_size];
 
 	if (is_kernel_thread(tsk))
-		len = snprintf(value, size, "KERNEL");
+		len = snprintf(buf, buf_size, "KERNEL");
 	else {
 		spin_lock(&tsec->lock);
 		if (tsec->iac_wx != tsec->iac_r)
-			len = snprintf(value, size, "GUARD wx:%s r:%s",
+			len = snprintf(buf, buf_size, "GUARD wx:%s r:%s",
 				       slm_iac_str[tsec->iac_wx],
 				       slm_iac_str[tsec->iac_r]);
 		else
-			len = snprintf(value, size, "%s",
+			len = snprintf(buf, buf_size, "%s",
 				       slm_iac_str[tsec->iac_wx]);
 		spin_unlock(&tsec->lock);
 	}
-	return min(len, size);
+	*value = kzalloc(len, GFP_KERNEL);
+	memcpy(*value, buf, len);
+	return len;
 }
 
 /*



