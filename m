Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828AbZHPTaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbZHPTaE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 15:30:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755879AbZHPTaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 15:30:01 -0400
Received: from mail-fx0-f215.google.com ([209.85.220.215]:49711 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880AbZHPT37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 15:29:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=NwQuOn9tO59a7EqZoUVVeUVHqJOrfJlYnucifHOdfJaot9AiN06YhcWx/8mIuvSrMk
         bGeg0vN5K9jY/rhfXEY+3SC8hTdxzMf494XwU4GOeukFiZduAjMdyFZwYMrEfQks1D9S
         kGu935h9Yafbabklh4xgQ8gganLXUzMEpuDys=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 16 Aug 2009 21:30:12 +0200
Message-Id: <20090816193012.3789.83965.sendpatchset@localhost.localdomain>
In-Reply-To: <20090816192934.3789.3648.sendpatchset@localhost.localdomain>
References: <20090816192934.3789.3648.sendpatchset@localhost.localdomain>
Subject: [PATCH 06/22] Staging: rtxxx0: PID checking fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rtxxx0: PID checking fixes

* rt3070:
  - add missing pid_nr() invocations

* rt{28,30}70:
  - do not treat PID 0 as valid

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/rt_linux.h      |    2 +-
 drivers/staging/rt2870/2870_main_dev.c |    6 +++---
 drivers/staging/rt2870/rt2870.h        |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

Index: b/drivers/staging/rt2860/rt_linux.h
===================================================================
--- a/drivers/staging/rt2860/rt_linux.h
+++ b/drivers/staging/rt2860/rt_linux.h
@@ -166,7 +166,7 @@ typedef	struct pid *	THREAD_PID;
 #define	THREAD_PID_INIT_VALUE	NULL
 #define	GET_PID(_v)	find_get_pid(_v)
 #define	GET_PID_NUMBER(_v)	pid_nr(_v)
-#define CHECK_PID_LEGALITY(_pid)	if (pid_nr(_pid) >= 0)
+#define CHECK_PID_LEGALITY(_pid)	if (pid_nr(_pid) > 0)
 #define KILL_THREAD_PID(_A, _B, _C)	kill_pid(_A, _B, _C)
 #endif
 
Index: b/drivers/staging/rt2870/2870_main_dev.c
===================================================================
--- a/drivers/staging/rt2870/2870_main_dev.c
+++ b/drivers/staging/rt2870/2870_main_dev.c
@@ -1061,7 +1061,7 @@ VOID RT28xxThreadTerminate(
 	}
 #endif
 #ifdef RT30xx
-	if (pObj->MLMEThr_pid)
+	if (pid_nr(pObj->MLMEThr_pid) > 0)
 	{
 		printk("Terminate the MLMEThr_pid=%d!\n", pid_nr(pObj->MLMEThr_pid));
 		mb();
@@ -1082,7 +1082,7 @@ VOID RT28xxThreadTerminate(
 		}
 	}
 
-	if (pObj->RTUSBCmdThr_pid >= 0)
+	if (pid_nr(pObj->RTUSBCmdThr_pid) > 0)
 	{
 		printk("Terminate the RTUSBCmdThr_pid=%d!\n", pid_nr(pObj->RTUSBCmdThr_pid));
 		mb();
@@ -1104,7 +1104,7 @@ VOID RT28xxThreadTerminate(
 			pObj->RTUSBCmdThr_pid = NULL;
 		}
 	}
-	if (pObj->TimerQThr_pid >= 0)
+	if (pid_nr(pObj->TimerQThr_pid) > 0)
 	{
 		POS_COOKIE pObj = (POS_COOKIE)pAd->OS_Cookie;
 		printk("Terminate the TimerQThr_pid=%d!\n", pid_nr(pObj->TimerQThr_pid));
Index: b/drivers/staging/rt2870/rt2870.h
===================================================================
--- a/drivers/staging/rt2870/rt2870.h
+++ b/drivers/staging/rt2870/rt2870.h
@@ -456,14 +456,14 @@ VOID RTUSBBulkRxComplete(purbb_t pUrb, s
 #define RTUSBMlmeUp(pAd)	        \
 {								    \
 	POS_COOKIE pObj = (POS_COOKIE) pAd->OS_Cookie;	\
-	if(pObj->MLMEThr_pid>0)		    \
+	if (pid_nr(pObj->MLMEThr_pid) > 0) \
         up(&(pAd->mlme_semaphore)); \
 }
 
 #define RTUSBCMDUp(pAd)	                \
 {									    \
 	POS_COOKIE pObj = (POS_COOKIE) pAd->OS_Cookie;	\
-	if(pObj->RTUSBCmdThr_pid>0)		    \
+	if (pid_nr(pObj->RTUSBCmdThr_pid) > 0) \
 	    up(&(pAd->RTUSBCmd_semaphore)); \
 }
 #endif
