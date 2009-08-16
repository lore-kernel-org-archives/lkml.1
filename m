Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbZHPTaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbZHPTaL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 15:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755789AbZHPTaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 15:30:08 -0400
Received: from mail-fx0-f215.google.com ([209.85.220.215]:49711 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879AbZHPTaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 15:30:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=G77N2UeB1E60WxFdiXT5jQjmXwDkvz51X7CgTz3TDRxAJ227NcmsqdxwY3CGbYv09A
         3D/Ud+OqP+6yf0NGiRb6+DxwFp6ZxEZMUGXla9w3WoQm+dPzNaOigWQXq5VEUe+pVFxj
         zhFaiLlSAccGJ+rPFr6oFAg7LnxEJTYxWGUsg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 16 Aug 2009 21:30:19 +0200
Message-Id: <20090816193019.3789.5319.sendpatchset@localhost.localdomain>
In-Reply-To: <20090816192934.3789.3648.sendpatchset@localhost.localdomain>
References: <20090816192934.3789.3648.sendpatchset@localhost.localdomain>
Subject: [PATCH 07/22] Staging: rt3070: kill TimerQThr thread first in RT28xxThreadTerminate()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt3070: kill TimerQThr thread first in RT28xxThreadTerminate()

* kill TimerQThr thread first in RT28xxThreadTerminate()
* remove the debugging printk() while at it

This makes rt3070 driver match rt2870 driver's behavior.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2870/2870_main_dev.c |   40 ++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 20 deletions(-)

Index: b/drivers/staging/rt2870/2870_main_dev.c
===================================================================
--- a/drivers/staging/rt2870/2870_main_dev.c
+++ b/drivers/staging/rt2870/2870_main_dev.c
@@ -1061,6 +1061,26 @@ VOID RT28xxThreadTerminate(
 	}
 #endif
 #ifdef RT30xx
+	if (pid_nr(pObj->TimerQThr_pid) > 0)
+	{
+		POS_COOKIE pObj = (POS_COOKIE)pAd->OS_Cookie;
+		printk("Terminate the TimerQThr_pid=%d!\n", pid_nr(pObj->TimerQThr_pid));
+		mb();
+		pAd->TimerFunc_kill = 1;
+		mb();
+		ret = kill_pid(pObj->TimerQThr_pid, SIGTERM, 1);
+		if (ret)
+		{
+			printk(KERN_WARNING "%s: unable to stop TimerQThread, pid=%d, ret=%d!\n",
+					pAd->net_dev->name, pid_nr(pObj->TimerQThr_pid), ret);
+		}
+		else
+		{
+			wait_for_completion(&pAd->TimerQComplete);
+			pObj->TimerQThr_pid = NULL;
+		}
+	}
+
 	if (pid_nr(pObj->MLMEThr_pid) > 0)
 	{
 		printk("Terminate the MLMEThr_pid=%d!\n", pid_nr(pObj->MLMEThr_pid));
@@ -1104,26 +1124,6 @@ VOID RT28xxThreadTerminate(
 			pObj->RTUSBCmdThr_pid = NULL;
 		}
 	}
-	if (pid_nr(pObj->TimerQThr_pid) > 0)
-	{
-		POS_COOKIE pObj = (POS_COOKIE)pAd->OS_Cookie;
-		printk("Terminate the TimerQThr_pid=%d!\n", pid_nr(pObj->TimerQThr_pid));
-		mb();
-		pAd->TimerFunc_kill = 1;
-		mb();
-		ret = kill_pid(pObj->TimerQThr_pid, SIGTERM, 1);
-		if (ret)
-		{
-			printk(KERN_WARNING "%s: unable to stop TimerQThread, pid=%d, ret=%d!\n",
-					pAd->net_dev->name, pid_nr(pObj->TimerQThr_pid), ret);
-		}
-		else
-		{
-			printk("wait_for_completion TimerQThr\n");
-			wait_for_completion(&pAd->TimerQComplete);
-			pObj->TimerQThr_pid = NULL;
-		}
-	}
 #endif
 
 	// Kill tasklets
