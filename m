Return-Path: <linux-kernel-owner+w=401wt.eu-S1754266AbZG0TOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbZG0TOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 15:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbZG0TOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 15:14:24 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:35824 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326AbZG0TOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 15:14:23 -0400
From: Nicolas Palix <npalix@diku.dk>
To: gregkh@suse.de, hjanssen@microsoft.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] Staging: hv: Transform typedef HANDLE into void *
Date: Mon, 27 Jul 2009 21:11:34 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907272111.35259.npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove typedef HANDLE which aliases a void pointer and use void *
anywhere HANDLE was used.

Here is the semantic patch to perform this transformation:
(http://www.emn.fr/x-info/coccinelle/)

//<smpl>
@rem_handle@
@@
-typedef void *HANDLE;

@fix_handle@
typedef HANDLE;
@@
-HANDLE
+void *

@fix_sizeof_handle@
@@
-sizeof(HANDLE)
+sizeof(void *)
//</smpl>

Signed-off-by: Nicolas Palix <npalix@diku.dk>
---
 drivers/staging/hv/ChannelMgmt.h  |    8 ++++----
 drivers/staging/hv/Hv.c           |    4 ++--
 drivers/staging/hv/Hv.h           |    4 ++--
 drivers/staging/hv/NetVsc.h       |    2 +-
 drivers/staging/hv/RndisFilter.c  |    2 +-
 drivers/staging/hv/StorVsc.c      |    4 ++--
 drivers/staging/hv/VmbusPrivate.h |    4 ++--
 drivers/staging/hv/include/osd.h  |   25 ++++++++++++-------------
 drivers/staging/hv/osd.c          |   24 ++++++++++++------------
 9 files changed, 38 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/hv/ChannelMgmt.h b/drivers/staging/hv/ChannelMgmt.h
index b7afeca..9567e66 100644
--- a/drivers/staging/hv/ChannelMgmt.h
+++ b/drivers/staging/hv/ChannelMgmt.h
@@ -47,7 +47,7 @@ typedef struct _VMBUS_CHANNEL {
 
 	DEVICE_OBJECT*				DeviceObject;
 
-	HANDLE						PollTimer; // SA-111 workaround
+	void 					*PollTimer; // SA-111 workaround
 
 	VMBUS_CHANNEL_STATE			State;
 
@@ -64,10 +64,10 @@ typedef struct _VMBUS_CHANNEL {
 	RING_BUFFER_INFO			Outbound;	// send to parent
 	RING_BUFFER_INFO			Inbound;	// receive from parent
 	spinlock_t inbound_lock;
-	HANDLE						ControlWQ;
+	void 					*ControlWQ;
 
 	// Channel callback are invoked in this workqueue context
-	//HANDLE						dataWorkQueue;
+	//void 					*dataWorkQueue;
 
 	PFN_CHANNEL_CALLBACK		OnChannelCallback;
 	void *						ChannelCallbackContext;
@@ -113,7 +113,7 @@ typedef struct _VMBUS_CHANNEL_MSGINFO {
 	LIST_ENTRY		SubMsgList;
 
 	// Synchronize the request/response if needed
-	HANDLE			WaitEvent;
+	void 			*WaitEvent;
 
 	VMBUS_CHANNEL_MESSAGE_RESPONSE Response;
 
diff --git a/drivers/staging/hv/Hv.c b/drivers/staging/hv/Hv.c
index 3a833ad..f1ceaef 100644
--- a/drivers/staging/hv/Hv.c
+++ b/drivers/staging/hv/Hv.c
@@ -237,8 +237,8 @@ HvInit (
 
 	DPRINT_ENTER(VMBUS);
 
-	memset(gHvContext.synICEventPage, 0, sizeof(HANDLE)*MAX_NUM_CPUS);
-	memset(gHvContext.synICMessagePage, 0, sizeof(HANDLE)*MAX_NUM_CPUS);
+	memset(gHvContext.synICEventPage,   0, sizeof(void *) * MAX_NUM_CPUS);
+	memset(gHvContext.synICMessagePage, 0, sizeof(void *) * MAX_NUM_CPUS);
 
 	if (!HvQueryHypervisorPresence())
 	{
diff --git a/drivers/staging/hv/Hv.h b/drivers/staging/hv/Hv.h
index dbe9bb8..de10eea 100644
--- a/drivers/staging/hv/Hv.h
+++ b/drivers/staging/hv/Hv.h
@@ -119,8 +119,8 @@ typedef struct {
 	HV_INPUT_SIGNAL_EVENT_BUFFER *SignalEventBuffer;
 	HV_INPUT_SIGNAL_EVENT *SignalEventParam; // 8-bytes aligned of the buffer above
 
-	HANDLE	synICMessagePage[MAX_NUM_CPUS];
-	HANDLE	synICEventPage[MAX_NUM_CPUS];
+	void   *synICMessagePage[MAX_NUM_CPUS];
+	void   *synICEventPage[MAX_NUM_CPUS];
 } HV_CONTEXT;
 
 extern HV_CONTEXT gHvContext;
diff --git a/drivers/staging/hv/NetVsc.h b/drivers/staging/hv/NetVsc.h
index d6b0d67..84e163b 100644
--- a/drivers/staging/hv/NetVsc.h
+++ b/drivers/staging/hv/NetVsc.h
@@ -78,7 +78,7 @@ typedef struct _NETVSC_DEVICE {
 	PNVSP_1_RECEIVE_BUFFER_SECTION	ReceiveSections;
 
 	// Used for NetVSP initialization protocol
-	HANDLE							ChannelInitEvent;
+	void 							*ChannelInitEvent;
 	NVSP_MESSAGE					ChannelInitPacket;
 
 	NVSP_MESSAGE					RevokePacket;
diff --git a/drivers/staging/hv/RndisFilter.c b/drivers/staging/hv/RndisFilter.c
index 714f23e..7d5923b 100644
--- a/drivers/staging/hv/RndisFilter.c
+++ b/drivers/staging/hv/RndisFilter.c
@@ -61,7 +61,7 @@ typedef struct _RNDIS_DEVICE {
 
 typedef struct _RNDIS_REQUEST {
 	LIST_ENTRY					ListEntry;
-	HANDLE						WaitEvent;
+	void 						*WaitEvent;
 
 	// FIXME: We assumed a fixed size response here. If we do ever need to handle a bigger response,
 	// we can either define a max response message or add a response buffer variable above this field
diff --git a/drivers/staging/hv/StorVsc.c b/drivers/staging/hv/StorVsc.c
index 439c447..238f8e7 100644
--- a/drivers/staging/hv/StorVsc.c
+++ b/drivers/staging/hv/StorVsc.c
@@ -47,7 +47,7 @@ typedef struct _STORVSC_REQUEST_EXTENSION {
 	DEVICE_OBJECT					*Device;
 
 	// Synchronize the request/response if needed
-	HANDLE							WaitEvent;
+	void 							*WaitEvent;
 
 	VSTOR_PACKET					VStorPacket;
 } STORVSC_REQUEST_EXTENSION;
@@ -68,7 +68,7 @@ typedef struct _STORVSC_DEVICE{
     unsigned char						TargetId;
 
 	//LIST_ENTRY					OutstandingRequestList;
-	//HANDLE						OutstandingRequestLock;
+	//void 						*OutstandingRequestLock;
 
 	// Used for vsc/vsp channel reset process
 	STORVSC_REQUEST_EXTENSION	InitRequest;
diff --git a/drivers/staging/hv/VmbusPrivate.h b/drivers/staging/hv/VmbusPrivate.h
index 686d05f..2f15560 100644
--- a/drivers/staging/hv/VmbusPrivate.h
+++ b/drivers/staging/hv/VmbusPrivate.h
@@ -86,7 +86,7 @@ typedef struct _VMBUS_CONNECTION {
 	LIST_ENTRY							ChannelList;
 	spinlock_t channel_lock;
 
-	HANDLE								WorkQueue;
+	void 								*WorkQueue;
 } VMBUS_CONNECTION;
 
 
@@ -95,7 +95,7 @@ typedef struct _VMBUS_MSGINFO {
 	LIST_ENTRY			MsgListEntry;
 
 	// Synchronize the request/response if needed
-	HANDLE				WaitEvent;
+	void 				*WaitEvent;
 
 	// The message itself
 	unsigned char		Msg[0];
diff --git a/drivers/staging/hv/include/osd.h b/drivers/staging/hv/include/osd.h
index 3878a2f..2c1d4bc 100644
--- a/drivers/staging/hv/include/osd.h
+++ b/drivers/staging/hv/include/osd.h
@@ -46,7 +46,6 @@ typedef struct _DLIST_ENTRY {
 // Other types
 //
 //typedef unsigned char		GUID[16];
-typedef void*				HANDLE;
 
 typedef struct {
 	unsigned char	Data[16];
@@ -117,18 +116,18 @@ extern void PageFree(void* page, unsigned int count);
 extern void* MemMapIO(unsigned long phys, unsigned long size);
 extern void MemUnmapIO(void* virt);
 
-extern HANDLE TimerCreate(PFN_TIMER_CALLBACK pfnTimerCB, void* context);
-extern void TimerClose(HANDLE hTimer);
-extern int TimerStop(HANDLE hTimer);
-extern void TimerStart(HANDLE hTimer, u32 expirationInUs);
+extern void *TimerCreate(PFN_TIMER_CALLBACK pfnTimerCB, void *context);
+extern void  TimerClose(void *hTimer);
+extern int   TimerStop(void *hTimer);
+extern void  TimerStart(void *hTimer, u32 expirationInUs);
 
-extern HANDLE WaitEventCreate(void);
-extern void WaitEventClose(HANDLE hWait);
-extern void WaitEventSet(HANDLE hWait);
-extern int	WaitEventWait(HANDLE hWait);
+extern void *WaitEventCreate(void);
+extern void  WaitEventClose(void *hWait);
+extern void  WaitEventSet(void *hWait);
+extern int   WaitEventWait(void *hWait);
 
 // If >0, hWait got signaled. If ==0, timeout. If < 0, error
-extern int	WaitEventWaitEx(HANDLE hWait, u32 TimeoutInMs);
+extern int	WaitEventWaitEx(void *hWait, u32 TimeoutInMs);
 
 
 #define GetVirtualAddress Physical2LogicalAddr
@@ -143,9 +142,9 @@ void* PageMapVirtualAddress(unsigned long Pfn);
 void PageUnmapVirtualAddress(void* VirtAddr);
 
 
-extern HANDLE WorkQueueCreate(char* name);
-extern void WorkQueueClose(HANDLE hWorkQueue);
-extern int WorkQueueQueueWorkItem(HANDLE hWorkQueue, PFN_WORKITEM_CALLBACK workItem, void* context);
+extern void *WorkQueueCreate(char* name);
+extern void  WorkQueueClose(void *hWorkQueue);
+extern int   WorkQueueQueueWorkItem(void *hWorkQueue, PFN_WORKITEM_CALLBACK workItem, void *context);
 
 extern void QueueWorkItem(PFN_WORKITEM_CALLBACK workItem, void* context);
 
diff --git a/drivers/staging/hv/osd.c b/drivers/staging/hv/osd.c
index 3cc2bb3..f26db86 100644
--- a/drivers/staging/hv/osd.c
+++ b/drivers/staging/hv/osd.c
@@ -191,7 +191,7 @@ void TimerCallback(unsigned long data)
 	t->callback(t->context);
 }
 
-HANDLE TimerCreate(PFN_TIMER_CALLBACK pfnTimerCB, void* context)
+void *TimerCreate(PFN_TIMER_CALLBACK pfnTimerCB, void *context)
 {
 	TIMER* t = kmalloc(sizeof(TIMER), GFP_KERNEL);
 	if (!t)
@@ -209,7 +209,7 @@ HANDLE TimerCreate(PFN_TIMER_CALLBACK pfnTimerCB, void* context)
 	return t;
 }
 
-void TimerStart(HANDLE hTimer, u32 expirationInUs)
+void TimerStart(void *hTimer, u32 expirationInUs)
 {
 	TIMER* t  = (TIMER* )hTimer;
 
@@ -217,14 +217,14 @@ void TimerStart(HANDLE hTimer, u32 expirationInUs)
 	add_timer(&t->timer);
 }
 
-int TimerStop(HANDLE hTimer)
+int TimerStop(void *hTimer)
 {
 	TIMER* t  = (TIMER* )hTimer;
 
 	return del_timer(&t->timer);
 }
 
-void TimerClose(HANDLE hTimer)
+void TimerClose(void *hTimer)
 {
 	TIMER* t  = (TIMER* )hTimer;
 
@@ -232,7 +232,7 @@ void TimerClose(HANDLE hTimer)
 	kfree(t);
 }
 
-HANDLE WaitEventCreate(void)
+void *WaitEventCreate(void)
 {
 	WAITEVENT* wait = kmalloc(sizeof(WAITEVENT), GFP_KERNEL);
 	if (!wait)
@@ -245,20 +245,20 @@ HANDLE WaitEventCreate(void)
 	return wait;
 }
 
-void WaitEventClose(HANDLE hWait)
+void WaitEventClose(void *hWait)
 {
 	WAITEVENT* waitEvent = (WAITEVENT* )hWait;
 	kfree(waitEvent);
 }
 
-void WaitEventSet(HANDLE hWait)
+void WaitEventSet(void *hWait)
 {
 	WAITEVENT* waitEvent = (WAITEVENT* )hWait;
 	waitEvent->condition = 1;
 	wake_up_interruptible(&waitEvent->event);
 }
 
-int WaitEventWait(HANDLE hWait)
+int WaitEventWait(void *hWait)
 {
 	int ret=0;
 	WAITEVENT* waitEvent = (WAITEVENT* )hWait;
@@ -269,7 +269,7 @@ int WaitEventWait(HANDLE hWait)
 	return ret;
 }
 
-int WaitEventWaitEx(HANDLE hWait, u32 TimeoutInMs)
+int WaitEventWaitEx(void *hWait, u32 TimeoutInMs)
 {
 	int ret=0;
 	WAITEVENT* waitEvent = (WAITEVENT* )hWait;
@@ -311,7 +311,7 @@ void WorkItemCallback(struct work_struct *work)
 	kfree(w);
 }
 
-HANDLE WorkQueueCreate(char* name)
+void *WorkQueueCreate(char *name)
 {
 	WORKQUEUE *wq = kmalloc(sizeof(WORKQUEUE), GFP_KERNEL);
 	if (!wq)
@@ -323,7 +323,7 @@ HANDLE WorkQueueCreate(char* name)
 	return wq;
 }
 
-void WorkQueueClose(HANDLE hWorkQueue)
+void WorkQueueClose(void *hWorkQueue)
 {
 	WORKQUEUE *wq = (WORKQUEUE *)hWorkQueue;
 
@@ -332,7 +332,7 @@ void WorkQueueClose(HANDLE hWorkQueue)
 	return;
 }
 
-int WorkQueueQueueWorkItem(HANDLE hWorkQueue, PFN_WORKITEM_CALLBACK workItem, void* context)
+int WorkQueueQueueWorkItem(void *hWorkQueue, PFN_WORKITEM_CALLBACK workItem, void *context)
 {
 	WORKQUEUE *wq = (WORKQUEUE *)hWorkQueue;
 

-- 
1.6.0.4


-- 
Nicolas Palix
