Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbZHPTaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbZHPTaV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 15:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755854AbZHPTaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 15:30:19 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:45385 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788AbZHPTaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 15:30:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=AK7b1n2NKXEoxiAY7+FlQ9BDD5fwBf9nkha/qph/0cllT0g0PyrN7hYrHEHXYIMqix
         xIOOAJ/xKH+hnN2FnQLwXETKAudm5fFtRYBa5KxFFSum81+ehfhN7I6grL0t1R25dcJ6
         X68OatMPD6YhDc9v39tpQ6bzup29qjM2GB7OU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 16 Aug 2009 21:30:25 +0200
Message-Id: <20090816193025.3789.87640.sendpatchset@localhost.localdomain>
In-Reply-To: <20090816192934.3789.3648.sendpatchset@localhost.localdomain>
References: <20090816192934.3789.3648.sendpatchset@localhost.localdomain>
Subject: [PATCH 08/22] Staging: rtxxx0: kill PID macros
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rtxxx0: kill PID macros

* kill PID macros
* unify now identical RT30xx and !RT30xx code

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/rt_linux.h              |   16 ----
 drivers/staging/rt2870/2870_main_dev.c         |   86 -------------------------
 drivers/staging/rt2870/common/2870_rtmp_init.c |   48 +------------
 drivers/staging/rt2870/common/rtusb_io.c       |    2 
 drivers/staging/rt2870/rt2870.h                |   17 ----
 5 files changed, 9 insertions(+), 160 deletions(-)

Index: b/drivers/staging/rt2860/rt_linux.h
===================================================================
--- a/drivers/staging/rt2860/rt_linux.h
+++ b/drivers/staging/rt2860/rt_linux.h
@@ -161,15 +161,6 @@ typedef int (*HARD_START_XMIT_FUNC)(stru
 #define NDIS_PACKET_TYPE_BROADCAST		2
 #define NDIS_PACKET_TYPE_ALL_MULTICAST	3
 
-#ifndef RT30xx
-typedef	struct pid *	THREAD_PID;
-#define	THREAD_PID_INIT_VALUE	NULL
-#define	GET_PID(_v)	find_get_pid(_v)
-#define	GET_PID_NUMBER(_v)	pid_nr(_v)
-#define CHECK_PID_LEGALITY(_pid)	if (pid_nr(_pid) > 0)
-#define KILL_THREAD_PID(_A, _B, _C)	kill_pid(_A, _B, _C)
-#endif
-
 struct os_lock  {
 	spinlock_t		lock;
 	unsigned long  	flags;
@@ -185,16 +176,9 @@ struct os_cookie {
 #ifdef RT2870
 	struct usb_device		*pUsb_Dev;
 
-#ifndef RT30xx
-	THREAD_PID				MLMEThr_pid;
-	THREAD_PID				RTUSBCmdThr_pid;
-	THREAD_PID				TimerQThr_pid;
-#endif
-#ifdef RT30xx
 	struct pid	*MLMEThr_pid;
 	struct pid	*RTUSBCmdThr_pid;
 	struct pid	*TimerQThr_pid;
-#endif
 #endif // RT2870 //
 
 	struct tasklet_struct 	rx_done_task;
Index: b/drivers/staging/rt2870/2870_main_dev.c
===================================================================
--- a/drivers/staging/rt2870/2870_main_dev.c
+++ b/drivers/staging/rt2870/2870_main_dev.c
@@ -346,12 +346,7 @@ INT MlmeThread(
 	 */
 	DBGPRINT(RT_DEBUG_TRACE,( "<---%s\n",__func__));
 
-#ifndef RT30xx
-	pObj->MLMEThr_pid = THREAD_PID_INIT_VALUE;
-#endif
-#ifdef RT30xx
 	pObj->MLMEThr_pid = NULL;
-#endif
 
 	complete_and_exit (&pAd->mlmeComplete, 0);
 	return 0;
@@ -459,12 +454,7 @@ INT RTUSBCmdThread(
 	 */
 	DBGPRINT(RT_DEBUG_TRACE,( "<---RTUSBCmdThread\n"));
 
-#ifndef RT30xx
-	pObj->RTUSBCmdThr_pid = THREAD_PID_INIT_VALUE;
-#endif
-#ifdef RT30xx
 	pObj->RTUSBCmdThr_pid = NULL;
-#endif
 
 	complete_and_exit (&pAd->CmdQComplete, 0);
 	return 0;
@@ -558,12 +548,8 @@ INT TimerQThread(
 	 */
 	DBGPRINT(RT_DEBUG_TRACE,( "<---%s\n",__func__));
 
-#ifndef RT30xx
-	pObj->TimerQThr_pid = THREAD_PID_INIT_VALUE;
-#endif
-#ifdef RT30xx
 	pObj->TimerQThr_pid = NULL;
-#endif
+
 	complete_and_exit(&pAd->TimerQComplete, 0);
 	return 0;
 
@@ -994,76 +980,11 @@ VOID RT28xxThreadTerminate(
 	RTUSBCancelPendingIRPs(pAd);
 
 	// Terminate Threads
-#ifndef RT30xx
-	CHECK_PID_LEGALITY(pObj->TimerQThr_pid)
-	{
-		POS_COOKIE pObj = (POS_COOKIE)pAd->OS_Cookie;
-
-		printk("Terminate the TimerQThr_pid=%d!\n", GET_PID_NUMBER(pObj->TimerQThr_pid));
-		mb();
-		pAd->TimerFunc_kill = 1;
-		mb();
-		ret = KILL_THREAD_PID(pObj->TimerQThr_pid, SIGTERM, 1);
-		if (ret)
-		{
-			printk(KERN_WARNING "%s: unable to stop TimerQThread, pid=%d, ret=%d!\n",
-					pAd->net_dev->name, GET_PID_NUMBER(pObj->TimerQThr_pid), ret);
-		}
-		else
-		{
-			wait_for_completion(&pAd->TimerQComplete);
-			pObj->TimerQThr_pid = THREAD_PID_INIT_VALUE;
-		}
-	}
-
-	CHECK_PID_LEGALITY(pObj->MLMEThr_pid)
-	{
-		printk("Terminate the MLMEThr_pid=%d!\n", GET_PID_NUMBER(pObj->MLMEThr_pid));
-		mb();
-		pAd->mlme_kill = 1;
-		//RT28XX_MLME_HANDLER(pAd);
-		mb();
-		ret = KILL_THREAD_PID(pObj->MLMEThr_pid, SIGTERM, 1);
-		if (ret)
-		{
-			printk (KERN_WARNING "%s: unable to Mlme thread, pid=%d, ret=%d!\n",
-					pAd->net_dev->name, GET_PID_NUMBER(pObj->MLMEThr_pid), ret);
-		}
-		else
-		{
-			//wait_for_completion (&pAd->notify);
-			wait_for_completion (&pAd->mlmeComplete);
-			pObj->MLMEThr_pid = THREAD_PID_INIT_VALUE;
-		}
-	}
 
-	CHECK_PID_LEGALITY(pObj->RTUSBCmdThr_pid)
-	{
-		printk("Terminate the RTUSBCmdThr_pid=%d!\n", GET_PID_NUMBER(pObj->RTUSBCmdThr_pid));
-		mb();
-		NdisAcquireSpinLock(&pAd->CmdQLock);
-		pAd->CmdQ.CmdQState = RT2870_THREAD_STOPED;
-		NdisReleaseSpinLock(&pAd->CmdQLock);
-		mb();
-		//RTUSBCMDUp(pAd);
-		ret = KILL_THREAD_PID(pObj->RTUSBCmdThr_pid, SIGTERM, 1);
-		if (ret)
-		{
-			printk(KERN_WARNING "%s: unable to RTUSBCmd thread, pid=%d, ret=%d!\n",
-					pAd->net_dev->name, GET_PID_NUMBER(pObj->RTUSBCmdThr_pid), ret);
-		}
-		else
-		{
-			//wait_for_completion (&pAd->notify);
-			wait_for_completion (&pAd->CmdQComplete);
-			pObj->RTUSBCmdThr_pid = THREAD_PID_INIT_VALUE;
-		}
-	}
-#endif
-#ifdef RT30xx
 	if (pid_nr(pObj->TimerQThr_pid) > 0)
 	{
 		POS_COOKIE pObj = (POS_COOKIE)pAd->OS_Cookie;
+
 		printk("Terminate the TimerQThr_pid=%d!\n", pid_nr(pObj->TimerQThr_pid));
 		mb();
 		pAd->TimerFunc_kill = 1;
@@ -1116,7 +1037,7 @@ VOID RT28xxThreadTerminate(
 		{
 			printk(KERN_WARNING "%s: unable to RTUSBCmd thread, pid=%d, ret=%d!\n",
 					pAd->net_dev->name, pid_nr(pObj->RTUSBCmdThr_pid), ret);
-	}
+		}
 		else
 		{
 			//wait_for_completion (&pAd->notify);
@@ -1124,7 +1045,6 @@ VOID RT28xxThreadTerminate(
 			pObj->RTUSBCmdThr_pid = NULL;
 		}
 	}
-#endif
 
 	// Kill tasklets
 	pAd->mlme_kill = 0;
Index: b/drivers/staging/rt2870/common/2870_rtmp_init.c
===================================================================
--- a/drivers/staging/rt2870/common/2870_rtmp_init.c
+++ b/drivers/staging/rt2870/common/2870_rtmp_init.c
@@ -699,14 +699,9 @@ NDIS_STATUS AdapterBlockAllocateMemory(
 
 	usb_dev = pObj->pUsb_Dev;
 
-#ifndef RT30xx
-	pObj->MLMEThr_pid		= THREAD_PID_INIT_VALUE;
-	pObj->RTUSBCmdThr_pid	= THREAD_PID_INIT_VALUE;
-#endif
-#ifdef RT30xx
 	pObj->MLMEThr_pid	= NULL;
 	pObj->RTUSBCmdThr_pid	= NULL;
-#endif
+
 	*ppAd = (PVOID)vmalloc(sizeof(RTMP_ADAPTER));
 
 	if (*ppAd)
@@ -761,75 +756,42 @@ NDIS_STATUS	 CreateThreads(
 	init_completion (&pAd->TimerQComplete);
 
 	// Creat MLME Thread
-#ifndef RT30xx
-	pObj->MLMEThr_pid= THREAD_PID_INIT_VALUE;
-	pid_number = kernel_thread(MlmeThread, pAd, CLONE_VM);
-	if (pid_number < 0)
-	{
-#endif
-#ifdef RT30xx
 	pObj->MLMEThr_pid = NULL;
 	pid_number = kernel_thread(MlmeThread, pAd, CLONE_VM);
 	if (pid_number < 0)
 	{
-#endif
 		printk (KERN_WARNING "%s: unable to start Mlme thread\n",pAd->net_dev->name);
 		return NDIS_STATUS_FAILURE;
 	}
 
-#ifndef RT30xx
-	pObj->MLMEThr_pid = GET_PID(pid_number);
-#endif
-#ifdef RT30xx
 	pObj->MLMEThr_pid = find_get_pid(pid_number);
-#endif
+
 	// Wait for the thread to start
 	wait_for_completion(&(pAd->mlmeComplete));
 
 	// Creat Command Thread
-#ifndef RT30xx
-	pObj->RTUSBCmdThr_pid= THREAD_PID_INIT_VALUE;
-	pid_number = kernel_thread(RTUSBCmdThread, pAd, CLONE_VM);
-	if (pid_number < 0)
-#endif
-#ifdef RT30xx
 	pObj->RTUSBCmdThr_pid = NULL;
 	pid_number = kernel_thread(RTUSBCmdThread, pAd, CLONE_VM);
 	if (pid_number < 0)
-#endif
 	{
 		printk (KERN_WARNING "%s: unable to start RTUSBCmd thread\n",pAd->net_dev->name);
 		return NDIS_STATUS_FAILURE;
 	}
 
-#ifndef RT30xx
-	pObj->RTUSBCmdThr_pid = GET_PID(pid_number);
-#endif
-#ifdef RT30xx
 	pObj->RTUSBCmdThr_pid = find_get_pid(pid_number);
-#endif
+
 	wait_for_completion(&(pAd->CmdQComplete));
 
-#ifndef RT30xx
-	pObj->TimerQThr_pid= THREAD_PID_INIT_VALUE;
-	pid_number = kernel_thread(TimerQThread, pAd, CLONE_VM);
-	if (pid_number < 0)
-#endif
-#ifdef RT30xx
 	pObj->TimerQThr_pid = NULL;
 	pid_number = kernel_thread(TimerQThread, pAd, CLONE_VM);
 	if (pid_number < 0)
-#endif
 	{
 		printk (KERN_WARNING "%s: unable to start TimerQThread\n",pAd->net_dev->name);
 		return NDIS_STATUS_FAILURE;
 	}
-#ifndef RT30xx
-	pObj->TimerQThr_pid = GET_PID(pid_number);
-#endif
-#ifdef RT30xx
+
 	pObj->TimerQThr_pid = find_get_pid(pid_number);
-#endif
+
 	// Wait for the thread to start
 	wait_for_completion(&(pAd->TimerQComplete));
 
Index: b/drivers/staging/rt2870/common/rtusb_io.c
===================================================================
--- a/drivers/staging/rt2870/common/rtusb_io.c
+++ b/drivers/staging/rt2870/common/rtusb_io.c
@@ -984,7 +984,7 @@ NDIS_STATUS	RTUSBEnqueueCmdFromNdis(
 	POS_COOKIE pObj = (POS_COOKIE) pAd->OS_Cookie;
 
 #ifndef RT30xx
-	CHECK_PID_LEGALITY(pObj->RTUSBCmdThr_pid)
+	if (pid_nr(pObj->RTUSBCmdThr_pid) > 0)
 #endif
 #ifdef RT30xx
 	if (pObj->RTUSBCmdThr_pid < 0)
Index: b/drivers/staging/rt2870/rt2870.h
===================================================================
--- a/drivers/staging/rt2870/rt2870.h
+++ b/drivers/staging/rt2870/rt2870.h
@@ -437,22 +437,6 @@ VOID RTUSBBulkOutRTSFrameComplete(purbb_
 VOID RTUSBBulkOutPsPollComplete(purbb_t pUrb, struct pt_regs *pt_regs);
 VOID RTUSBBulkRxComplete(purbb_t pUrb, struct pt_regs *pt_regs);
 
-#ifndef RT30xx
-#define RTUSBMlmeUp(pAd)	        \
-{								    \
-	POS_COOKIE pObj = (POS_COOKIE) pAd->OS_Cookie;	\
-	CHECK_PID_LEGALITY(pObj->MLMEThr_pid)		    \
-        up(&(pAd->mlme_semaphore)); \
-}
-
-#define RTUSBCMDUp(pAd)	                \
-{									    \
-	POS_COOKIE pObj = (POS_COOKIE) pAd->OS_Cookie;	\
-	CHECK_PID_LEGALITY(pObj->RTUSBCmdThr_pid)	    \
-	    up(&(pAd->RTUSBCmd_semaphore)); \
-}
-#endif
-#ifdef RT30xx
 #define RTUSBMlmeUp(pAd)	        \
 {								    \
 	POS_COOKIE pObj = (POS_COOKIE) pAd->OS_Cookie;	\
@@ -466,7 +450,6 @@ VOID RTUSBBulkRxComplete(purbb_t pUrb, s
 	if (pid_nr(pObj->RTUSBCmdThr_pid) > 0) \
 	    up(&(pAd->RTUSBCmd_semaphore)); \
 }
-#endif
 
 static inline NDIS_STATUS RTMPAllocateMemory(
 	OUT PVOID *ptr,
