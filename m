Return-Path: <linux-kernel-owner+w=401wt.eu-S1758625AbXFCOpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625AbXFCOpS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 10:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756198AbXFCOl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 10:41:56 -0400
Received: from web50102.mail.re2.yahoo.com ([206.190.38.30]:36511 "HELO
	web50102.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755396AbXFCOlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 10:41:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=VgipWo/sJhPQ+FrTUDF7vmsHFgoT34NKFiPMMx9m6HKXFmNyrdQn58piIxyUwZOYkYqJOEVGc04YyPKILTJwWmB74dXgE0wQxU3Tj3SewIc3JuuzExdhQZuMDnMke+jt7P8gASKHEmewt3TXNNFSyK/YfZNP6iqCZXWrTnhii4I=;
X-YMail-OSG: jIk1sHoVM1kZel1q4FWK4JJF3l6vTdzzvvSiP4E39KdM3psY1Z09Esd8Jc9kd23vCfD8TsfWu8UrB24K3b6T8s7U0w9.4KRsp7xhUmWFdbfTBG89uxHdxK6hUbpCXU59tliGMMZFPwU-
Date: Sun, 3 Jun 2007 07:41:54 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: [PATCH 18/36] drivers edac mod assert error check
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <398248.77538.qm@web50102.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Dave Jiang <djiang@mvista.com>

Change error check and clear variable from an atomic to an int


Signed-off-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Douglas Thompson <dougthompson@xmission.com

---

Index: linux-2.6.21.1/drivers/edac/edac_mc.c
===================================================================
--- linux-2.6.21.1.orig/drivers/edac/edac_mc.c
+++ linux-2.6.21.1/drivers/edac/edac_mc.c
@@ -222,18 +222,15 @@ static struct mem_ctl_info *find_mci_by_
  */
 static int edac_mc_assert_error_check_and_clear(void)
 {
-	int vreg;
+	int old_state;
 
 	if(edac_op_state == EDAC_OPSTATE_POLL)
 		return 1;
 
-	vreg = atomic_read(&edac_err_assert);
-	if(vreg) {
-		atomic_set(&edac_err_assert, 0);
-		return 1;
-	}
+	old_state = edac_err_assert;
+	edac_err_assert = 0;
 
-	return 0;
+	return old_state;
 }
 
 /*
Index: linux-2.6.21.1/drivers/edac/edac_stub.c
===================================================================
--- linux-2.6.21.1.orig/drivers/edac/edac_stub.c
+++ linux-2.6.21.1/drivers/edac/edac_stub.c
@@ -20,7 +20,7 @@ EXPORT_SYMBOL(edac_op_state);
 atomic_t edac_handlers = ATOMIC_INIT(0);
 EXPORT_SYMBOL(edac_handlers);
 
-atomic_t edac_err_assert = ATOMIC_INIT(0);
+int edac_err_assert = 0;
 EXPORT_SYMBOL(edac_err_assert);
 
 inline int edac_handler_set(void)
@@ -37,6 +37,6 @@ EXPORT_SYMBOL(edac_handler_set);
  */
 inline void edac_atomic_assert_error(void)
 {
-	atomic_set(&edac_err_assert, 1);
+	edac_err_assert++;
 }
 EXPORT_SYMBOL(edac_atomic_assert_error);
Index: linux-2.6.21.1/include/linux/edac.h
===================================================================
--- linux-2.6.21.1.orig/include/linux/edac.h
+++ linux-2.6.21.1/include/linux/edac.h
@@ -20,8 +20,8 @@
 #define EDAC_OPSTATE_INT	2
 
 extern int edac_op_state;
+extern int edac_err_assert;
 extern atomic_t edac_handlers;
-extern atomic_t edac_err_assert;
 
 extern int edac_handler_set(void);
 extern void edac_atomic_assert_error(void);

