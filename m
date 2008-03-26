Return-Path: <linux-kernel-owner+w=401wt.eu-S1761320AbYCZWDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761320AbYCZWDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 18:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758201AbYCZWDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 18:03:38 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60305 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756661AbYCZWD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 18:03:26 -0400
Date: Wed, 26 Mar 2008 17:03:24 -0500
From: Dean Nelson <dcn@sgi.com>
To: jes@sgi.com, tony.luck@intel.com, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org
Subject: [Patch 3/5] prepare XPC and XPNET for future support of SGIs UV architecture -v3
Message-ID: <20080326220324.GC31138@sgi.com>
References: <20080326215807.GF31340@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=generic-xp
In-Reply-To: <20080326215807.GF31340@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepared XPC and XPNET for future support of SGI's UV architecture. Made
changes so it compiles on x86_64. Added support for up to 256 partitions.
Cleaned up BTE error conversion for is64 sn2.

Signed-off-by: Dean Nelson <dcn@sgi.com>

---

 arch/ia64/sn/kernel/setup.c     |    4
 drivers/misc/Kconfig            |    2
 drivers/misc/xp/Makefile        |    5
 drivers/misc/xp/xp.h            |  382 ++++++++++----------
 drivers/misc/xp/xp_main.c       |  181 ++++++---
 drivers/misc/xp/xp_nofault.S    |    2
 drivers/misc/xp/xp_sn2.c        |  487 ++++++++++++++++++++++++++
 drivers/misc/xp/xp_uv.c         |  194 ++++++++++
 drivers/misc/xp/xpc.h           |  594 +++++++++++++++----------------
 drivers/misc/xp/xpc_channel.c   |  357 +++++++++----------
 drivers/misc/xp/xpc_main.c      |  273 +++++++-------
 drivers/misc/xp/xpc_partition.c |  670 +++++++++++++++---------------------
 drivers/misc/xp/xpnet.c         |  280 ++++++---------
 include/asm-ia64/sn/arch.h      |    5
 include/asm-ia64/sn/bte.h       |    5
 15 files changed, 2010 insertions(+), 1431 deletions(-)

Index: linux-2.6/drivers/misc/xp/xp.h
===================================================================
--- linux-2.6.orig/drivers/misc/xp/xp.h	2008-03-26 10:40:03.156341458 -0500
+++ linux-2.6/drivers/misc/xp/xp.h	2008-03-26 10:41:15.529157874 -0500
@@ -3,7 +3,7 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  *
- * Copyright (C) 2004-2005 Silicon Graphics, Inc. All rights reserved.
+ * Copyright (C) 2004-2008 Silicon Graphics, Inc. All rights reserved.
  */
 
 
@@ -12,15 +12,28 @@
  */
 
 
-#ifndef _ASM_IA64_SN_XP_H
-#define _ASM_IA64_SN_XP_H
+#ifndef _DRIVERS_MISC_XP_XP_H
+#define _DRIVERS_MISC_XP_XP_H
 
 
 #include <linux/cache.h>
 #include <linux/hardirq.h>
 #include <linux/mutex.h>
-#include <asm/sn/types.h>
-#include <asm/sn/bte.h>
+#ifdef CONFIG_IA64
+#include <asm/sn/arch.h>
+#endif
+
+/* >>> Add these two #defines to some linux header file some day. */
+#define BYTES_PER_WORD	sizeof(void *)
+#define BITS_PER_WORD	(BYTES_PER_WORD * BITS_PER_BYTE)
+
+#if defined(CONFIG_IA64)
+#define U64_ELL "l"
+#elif defined(CONFIG_X86_64)
+#define U64_ELL "ll"
+#else
+#error architecture is NOT supported
+#endif
 
 
 #ifdef USE_DBUG_ON
@@ -30,6 +43,23 @@
 #endif
 
 
+#ifndef is_shub1
+#define is_shub1()	0
+#endif
+
+#ifndef is_shub2
+#define is_shub2()	0
+#endif
+
+#ifndef is_shub
+#define is_shub()	0
+#endif
+
+#ifndef is_uv
+#define is_uv()		0
+#endif
+
+
 /*
  * Define the maximum number of logically defined partitions the system
  * can support. It is constrained by the maximum number of hardware
@@ -41,60 +71,15 @@
  * maximum number of nodes in the entire system divided by the minimum number
  * of nodes that comprise an access protection grouping.
  */
-#define XP_MAX_PARTITIONS	64
-
-
-/*
- * Define the number of u64s required to represent all the C-brick nasids
- * as a bitmap.  The cross-partition kernel modules deal only with
- * C-brick nasids, thus the need for bitmaps which don't account for
- * odd-numbered (non C-brick) nasids.
- */
-#define XP_MAX_PHYSNODE_ID	(MAX_NUMALINK_NODES / 2)
-#define XP_NASID_MASK_BYTES	((XP_MAX_PHYSNODE_ID + 7) / 8)
-#define XP_NASID_MASK_WORDS	((XP_MAX_PHYSNODE_ID + 63) / 64)
-
+#define XP_NPARTITIONS		64	/* #of partitions allowed */
+#define XP_MAX_NPARTITIONS	256	/* max #of partitions possible */
 
-/*
- * Wrapper for bte_copy() that should it return a failure status will retry
- * the bte_copy() once in the hope that the failure was due to a temporary
- * aberration (i.e., the link going down temporarily).
- *
- * 	src - physical address of the source of the transfer.
- *	vdst - virtual address of the destination of the transfer.
- *	len - number of bytes to transfer from source to destination.
- *	mode - see bte_copy() for definition.
- *	notification - see bte_copy() for definition.
- *
- * Note: xp_bte_copy() should never be called while holding a spinlock.
- */
-static inline bte_result_t
-xp_bte_copy(u64 src, u64 vdst, u64 len, u64 mode, void *notification)
-{
-	bte_result_t ret;
-	u64 pdst = ia64_tpa(vdst);
-
-
-	/*
-	 * Ensure that the physically mapped memory is contiguous.
-	 *
-	 * We do this by ensuring that the memory is from region 7 only.
-	 * If the need should arise to use memory from one of the other
-	 * regions, then modify the BUG_ON() statement to ensure that the
-	 * memory from that region is always physically contiguous.
-	 */
-	BUG_ON(REGION_NUMBER(vdst) != RGN_KERNEL);
-
-	ret = bte_copy(src, pdst, len, mode, notification);
-	if ((ret != BTE_SUCCESS) && BTE_ERROR_RETRY(ret)) {
-		if (!in_interrupt()) {
-			cond_resched();
-		}
-		ret = bte_copy(src, pdst, len, mode, notification);
-	}
+#if XP_NPARTITIONS > XP_MAX_NPARTITIONS
+#error  XP_NPARTITIONS exceeds MAXIMUM possible.
+#endif
 
-	return ret;
-}
+#define XP_MIN_PARTID		1			/* inclusive */
+#define XP_MAX_PARTID		(XP_NPARTITIONS - 1)	/* inclusive */
 
 
 /*
@@ -115,11 +100,11 @@ xp_bte_copy(u64 src, u64 vdst, u64 len, 
 #define XPC_MEM_CHANNEL		0	/* memory channel number */
 #define	XPC_NET_CHANNEL		1	/* network channel number */
 
-#define	XPC_NCHANNELS		2	/* #of defined channels */
-#define XPC_MAX_NCHANNELS	8	/* max #of channels allowed */
+#define	XPC_NCHANNELS		2	/* #of channels allowed */
+#define XPC_MAX_NCHANNELS	8	/* max #of channels possible */
 
 #if XPC_NCHANNELS > XPC_MAX_NCHANNELS
-#error	XPC_NCHANNELS exceeds MAXIMUM allowed.
+#error	XPC_NCHANNELS exceeds MAXIMUM possible.
 #endif
 
 
@@ -133,7 +118,7 @@ xp_bte_copy(u64 src, u64 vdst, u64 len, 
  *      +----------------------------------------+
  *      |     payload (user-defined message)     |
  *      |                                        |
- *         		:
+ *			:
  *      |                                        |
  *      +----------------------------------------+
  *
@@ -169,106 +154,103 @@ struct xpc_msg {
 /*
  * Define the return values and values passed to user's callout functions.
  * (It is important to add new value codes at the end just preceding
- * xpcUnknownReason, which must have the highest numerical value.)
+ * xpUnknownReason, which must have the highest numerical value.)
  */
-enum xpc_retval {
-	xpcSuccess = 0,
-
-	xpcNotConnected,	/*  1: channel is not connected */
-	xpcConnected,		/*  2: channel connected (opened) */
-	xpcRETIRED1,		/*  3: (formerly xpcDisconnected) */
-
-	xpcMsgReceived,		/*  4: message received */
-	xpcMsgDelivered,	/*  5: message delivered and acknowledged */
-
-	xpcRETIRED2,		/*  6: (formerly xpcTransferFailed) */
-
-	xpcNoWait,		/*  7: operation would require wait */
-	xpcRetry,		/*  8: retry operation */
-	xpcTimeout,		/*  9: timeout in xpc_allocate_msg_wait() */
-	xpcInterrupted,		/* 10: interrupted wait */
-
-	xpcUnequalMsgSizes,	/* 11: message size disparity between sides */
-	xpcInvalidAddress,	/* 12: invalid address */
+enum xp_retval {
+	xpSuccess = 0,
 
-	xpcNoMemory,		/* 13: no memory available for XPC structures */
-	xpcLackOfResources,	/* 14: insufficient resources for operation */
-	xpcUnregistered,	/* 15: channel is not registered */
-	xpcAlreadyRegistered,	/* 16: channel is already registered */
+	xpNotConnected,		/*  1: channel is not connected */
+	xpConnected,		/*  2: channel connected (opened) */
+	xpRETIRED1,		/*  3: (formerly xpDisconnected) */
 
-	xpcPartitionDown,	/* 17: remote partition is down */
-	xpcNotLoaded,		/* 18: XPC module is not loaded */
-	xpcUnloading,		/* 19: this side is unloading XPC module */
+	xpMsgReceived,		/*  4: message received */
+	xpMsgDelivered,		/*  5: message delivered and acknowledged */
 
-	xpcBadMagic,		/* 20: XPC MAGIC string not found */
+	xpRETIRED2,		/*  6: (formerly xpTransferFailed) */
 
-	xpcReactivating,	/* 21: remote partition was reactivated */
+	xpNoWait,		/*  7: operation would require wait */
+	xpRetry,		/*  8: retry operation */
+	xpTimeout,		/*  9: timeout in xpc_allocate_msg_wait() */
+	xpInterrupted,		/* 10: interrupted wait */
 
-	xpcUnregistering,	/* 22: this side is unregistering channel */
-	xpcOtherUnregistering,	/* 23: other side is unregistering channel */
+	xpUnequalMsgSizes,	/* 11: message size disparity between sides */
+	xpInvalidAddress,	/* 12: invalid address */
 
-	xpcCloneKThread,	/* 24: cloning kernel thread */
-	xpcCloneKThreadFailed,	/* 25: cloning kernel thread failed */
+	xpNoMemory,		/* 13: no memory available for XPC structures */
+	xpLackOfResources,	/* 14: insufficient resources for operation */
+	xpUnregistered,		/* 15: channel is not registered */
+	xpAlreadyRegistered,	/* 16: channel is already registered */
 
-	xpcNoHeartbeat,		/* 26: remote partition has no heartbeat */
+	xpPartitionDown,	/* 17: remote partition is down */
+	xpNotLoaded,		/* 18: XPC module is not loaded */
+	xpUnloading,		/* 19: this side is unloading XPC module */
 
-	xpcPioReadError,	/* 27: PIO read error */
-	xpcPhysAddrRegFailed,	/* 28: registration of phys addr range failed */
+	xpBadMagic,		/* 20: XPC MAGIC string not found */
 
-	xpcBteDirectoryError,	/* 29: maps to BTEFAIL_DIR */
-	xpcBtePoisonError,	/* 30: maps to BTEFAIL_POISON */
-	xpcBteWriteError,	/* 31: maps to BTEFAIL_WERR */
-	xpcBteAccessError,	/* 32: maps to BTEFAIL_ACCESS */
-	xpcBtePWriteError,	/* 33: maps to BTEFAIL_PWERR */
-	xpcBtePReadError,	/* 34: maps to BTEFAIL_PRERR */
-	xpcBteTimeOutError,	/* 35: maps to BTEFAIL_TOUT */
-	xpcBteXtalkError,	/* 36: maps to BTEFAIL_XTERR */
-	xpcBteNotAvailable,	/* 37: maps to BTEFAIL_NOTAVAIL */
-	xpcBteUnmappedError,	/* 38: unmapped BTEFAIL_ error */
+	xpReactivating,		/* 21: remote partition was reactivated */
 
-	xpcBadVersion,		/* 39: bad version number */
-	xpcVarsNotSet,		/* 40: the XPC variables are not set up */
-	xpcNoRsvdPageAddr,	/* 41: unable to get rsvd page's phys addr */
-	xpcInvalidPartid,	/* 42: invalid partition ID */
-	xpcLocalPartid,		/* 43: local partition ID */
+	xpUnregistering,	/* 22: this side is unregistering channel */
+	xpOtherUnregistering,	/* 23: other side is unregistering channel */
 
-	xpcOtherGoingDown,	/* 44: other side going down, reason unknown */
-	xpcSystemGoingDown,	/* 45: system is going down, reason unknown */
-	xpcSystemHalt,		/* 46: system is being halted */
-	xpcSystemReboot,	/* 47: system is being rebooted */
-	xpcSystemPoweroff,	/* 48: system is being powered off */
+	xpCloneKThread,		/* 24: cloning kernel thread */
+	xpCloneKThreadFailed,	/* 25: cloning kernel thread failed */
 
-	xpcDisconnecting,	/* 49: channel disconnecting (closing) */
+	xpNoHeartbeat,		/* 26: remote partition has no heartbeat */
 
-	xpcOpenCloseError,	/* 50: channel open/close protocol error */
+	xpPioReadError,		/* 27: PIO read error */
+	xpPhysAddrRegFailed,	/* 28: registration of phys addr range failed */
 
-	xpcDisconnected,	/* 51: channel disconnected (closed) */
+	xpRETIRED3,		/* 29: (formerly xpBteDirectoryError) */
+	xpRETIRED4,		/* 30: (formerly xpBtePoisonError) */
+	xpRETIRED5,		/* 31: (formerly xpBteWriteError) */
+	xpRETIRED6,		/* 32: (formerly xpBteAccessError) */
+	xpRETIRED7,		/* 33: (formerly xpBtePWriteError) */
+	xpRETIRED8,		/* 34: (formerly xpBtePReadError) */
+	xpRETIRED9,		/* 35: (formerly xpBteTimeOutError) */
+	xpRETIRED10,		/* 36: (formerly xpBteXtalkError) */
+	xpRETIRED11,		/* 37: (formerly xpBteNotAvailable) */
+	xpRETIRED12,		/* 38: (formerly xpBteUnmappedError) */
 
-	xpcBteSh2Start,		/* 52: BTE CRB timeout */
+	xpBadVersion,		/* 39: bad version number */
+	xpVarsNotSet,		/* 40: the XPC variables are not set up */
+	xpNoRsvdPageAddr,	/* 41: unable to get rsvd page's phys addr */
+	xpInvalidPartid,	/* 42: invalid partition ID */
+	xpLocalPartid,		/* 43: local partition ID */
 
-				/* 53: 0x1 BTE Error Response Short */
-	xpcBteSh2RspShort = xpcBteSh2Start + BTEFAIL_SH2_RESP_SHORT,
+	xpOtherGoingDown,	/* 44: other side going down, reason unknown */
+	xpSystemGoingDown,	/* 45: system is going down, reason unknown */
+	xpSystemHalt,		/* 46: system is being halted */
+	xpSystemReboot,		/* 47: system is being rebooted */
+	xpSystemPoweroff,	/* 48: system is being powered off */
 
-				/* 54: 0x2 BTE Error Response Long */
-	xpcBteSh2RspLong = xpcBteSh2Start + BTEFAIL_SH2_RESP_LONG,
+	xpDisconnecting,	/* 49: channel disconnecting (closing) */
 
-				/* 56: 0x4 BTE Error Response DSB */
-	xpcBteSh2RspDSB = xpcBteSh2Start + BTEFAIL_SH2_RESP_DSP,
+	xpOpenCloseError,	/* 50: channel open/close protocol error */
 
-				/* 60: 0x8 BTE Error Response Access */
-	xpcBteSh2RspAccess = xpcBteSh2Start + BTEFAIL_SH2_RESP_ACCESS,
+	xpDisconnected,		/* 51: channel disconnected (closed) */
 
-				/* 68: 0x10 BTE Error CRB timeout */
-	xpcBteSh2CRBTO = xpcBteSh2Start + BTEFAIL_SH2_CRB_TO,
+	xpBteCopyError,		/* 52: bte_copy() returned error */
+	xpSalError,		/* 53: sn SAL error */
+	xpNeedMoreInfo,		/* 54: more info is needed by SAL */
 
-				/* 84: 0x20 BTE Error NACK limit */
-	xpcBteSh2NACKLimit = xpcBteSh2Start + BTEFAIL_SH2_NACK_LIMIT,
+	xpUnsupported,		/* 55: unsupported functionality or resource */
+	xpUnknownReason		/* 56: unknown reason (must be last in list) */
+};
 
-				/* 115: BTE end */
-	xpcBteSh2End = xpcBteSh2Start + BTEFAIL_SH2_ALL,
 
-	xpcUnknownReason	/* 116: unknown reason -- must be last in list */
-};
+/* the following are valid xp_set_amo() ops */
+#define XP_AMO_OR	1	/* set variable to (variable | operand) */
+#define XP_AMO_AND	2	/* set variable to (variable & operand) */
+
+/* the following are valid xp_get_amo() ops */
+#define XP_AMO_LOAD	1	/* get variable contents */
+#define XP_AMO_CLEAR	2	/* get variable contents and clear variable */
+
+/* the following are valid xp_change_memprotect() ops */
+#define XP_MEMPROT_DISALLOW_ALL		0
+#define XP_MEMPROT_ALLOW_CPU_AMO	1
+#define XP_MEMPROT_ALLOW_CPU_MEM	2
+#define XP_MEMPROT_ALLOW_ALL		3	/* Shub 1.1 only */
 
 
 /*
@@ -302,83 +284,83 @@ enum xpc_retval {
  *
  * Reason Code          | Cause                          | Optional Data
  * =====================+================================+=====================
- * xpcConnected         | connection has been established| max #of entries
+ * xpConnected          | connection has been established| max #of entries
  *                      | to the specified partition on  | allowed in message
  *                      | the specified channel          | queue
  * ---------------------+--------------------------------+---------------------
- * xpcMsgReceived       | an XPC message arrived from    | address of payload
+ * xpMsgReceived        | an XPC message arrived from    | address of payload
  *                      | the specified partition on the |
  *                      | specified channel              | [the user must call
  *                      |                                | xpc_received() when
  *                      |                                | finished with the
  *                      |                                | payload]
  * ---------------------+--------------------------------+---------------------
- * xpcMsgDelivered      | notification that the message  | NA
+ * xpMsgDelivered       | notification that the message  | NA
  *                      | was delivered to the intended  |
  *                      | recipient and that they have   |
  *                      | acknowledged its receipt by    |
  *                      | calling xpc_received()         |
  * =====================+================================+=====================
- * xpcUnequalMsgSizes   | can't connect to the specified | NULL
+ * xpUnequalMsgSizes    | can't connect to the specified | NULL
  *                      | partition on the specified     |
  *                      | channel because of mismatched  |
  *                      | message sizes                  |
  * ---------------------+--------------------------------+---------------------
- * xpcNoMemory          | insufficient memory avaiable   | NULL
+ * xpNoMemory           | insufficient memory avaiable   | NULL
  *                      | to allocate message queue      |
  * ---------------------+--------------------------------+---------------------
- * xpcLackOfResources   | lack of resources to create    | NULL
+ * xpLackOfResources    | lack of resources to create    | NULL
  *                      | the necessary kthreads to      |
  *                      | support the channel            |
  * ---------------------+--------------------------------+---------------------
- * xpcUnregistering     | this side's user has           | NULL or NA
+ * xpUnregistering      | this side's user has           | NULL or NA
  *                      | unregistered by calling        |
  *                      | xpc_disconnect()               |
  * ---------------------+--------------------------------+---------------------
- * xpcOtherUnregistering| the other side's user has      | NULL or NA
+ * xpOtherUnregistering | the other side's user has      | NULL or NA
  *                      | unregistered by calling        |
  *                      | xpc_disconnect()               |
  * ---------------------+--------------------------------+---------------------
- * xpcNoHeartbeat       | the other side's XPC is no     | NULL or NA
+ * xpNoHeartbeat        | the other side's XPC is no     | NULL or NA
  *                      | longer heartbeating            |
  *                      |                                |
  * ---------------------+--------------------------------+---------------------
- * xpcUnloading         | this side's XPC module is      | NULL or NA
+ * xpUnloading          | this side's XPC module is      | NULL or NA
  *                      | being unloaded                 |
  *                      |                                |
  * ---------------------+--------------------------------+---------------------
- * xpcOtherUnloading    | the other side's XPC module is | NULL or NA
+ * xpOtherUnloading     | the other side's XPC module is | NULL or NA
  *                      | is being unloaded              |
  *                      |                                |
  * ---------------------+--------------------------------+---------------------
- * xpcPioReadError      | xp_nofault_PIOR() returned an  | NULL or NA
+ * xpPioReadError       | xp_nofault_PIOR() returned an  | NULL or NA
  *                      | error while sending an IPI     |
  *                      |                                |
  * ---------------------+--------------------------------+---------------------
- * xpcInvalidAddress    | the address either received or | NULL or NA
+ * xpInvalidAddress     | the address either received or | NULL or NA
  *                      | sent by the specified partition|
  *                      | is invalid                     |
  * ---------------------+--------------------------------+---------------------
- * xpcBteNotAvailable   | attempt to pull data from the  | NULL or NA
- * xpcBtePoisonError    | specified partition over the   |
- * xpcBteWriteError     | specified channel via a        |
- * xpcBteAccessError    | bte_copy() failed              |
- * xpcBteTimeOutError   |                                |
- * xpcBteXtalkError     |                                |
- * xpcBteDirectoryError |                                |
- * xpcBteGenericError   |                                |
- * xpcBteUnmappedError  |                                |
+ * xpBteNotAvailable    | attempt to pull data from the  | NULL or NA
+ * xpBtePoisonError     | specified partition over the   |
+ * xpBteWriteError      | specified channel via a        |
+ * xpBteAccessError     | bte_copy() failed              |
+ * xpBteTimeOutError    |                                |
+ * xpBteXtalkError      |                                |
+ * xpBteDirectoryError  |                                |
+ * xpBteGenericError    |                                |
+ * xpBteUnmappedError   |                                |
  * ---------------------+--------------------------------+---------------------
- * xpcUnknownReason     | the specified channel to the   | NULL or NA
+ * xpUnknownReason      | the specified channel to the   | NULL or NA
  *                      | specified partition was        |
  *                      | unavailable for unknown reasons|
  * =====================+================================+=====================
  */
 
-typedef void (*xpc_channel_func)(enum xpc_retval reason, partid_t partid,
+typedef void (*xpc_channel_func)(enum xp_retval reason, short partid,
 		int ch_number, void *data, void *key);
 
-typedef void (*xpc_notify_func)(enum xpc_retval reason, partid_t partid,
+typedef void (*xpc_notify_func)(enum xp_retval reason, short partid,
 		int ch_number, void *key);
 
 
@@ -418,12 +400,12 @@ struct xpc_registration {
 struct xpc_interface {
 	void (*connect)(int);
 	void (*disconnect)(int);
-	enum xpc_retval (*allocate)(partid_t, int, u32, void **);
-	enum xpc_retval (*send)(partid_t, int, void *);
-	enum xpc_retval (*send_notify)(partid_t, int, void *,
+	enum xp_retval (*allocate)(short, int, u32, void **);
+	enum xp_retval (*send)(short, int, void *);
+	enum xp_retval (*send_notify)(short, int, void *,
 						xpc_notify_func, void *);
-	void (*received)(partid_t, int, void *);
-	enum xpc_retval (*partid_to_nasids)(partid_t, void *);
+	void (*received)(short, int, void *);
+	enum xp_retval (*partid_to_nasids)(short, void *);
 };
 
 
@@ -431,55 +413,91 @@ extern struct xpc_interface xpc_interfac
 
 extern void xpc_set_interface(void (*)(int),
 		void (*)(int),
-		enum xpc_retval (*)(partid_t, int, u32, void **),
-		enum xpc_retval (*)(partid_t, int, void *),
-		enum xpc_retval (*)(partid_t, int, void *, xpc_notify_func,
+		enum xp_retval (*)(short, int, u32, void **),
+		enum xp_retval (*)(short, int, void *),
+		enum xp_retval (*)(short, int, void *, xpc_notify_func,
 								void *),
-		void (*)(partid_t, int, void *),
-		enum xpc_retval (*)(partid_t, void *));
+		void (*)(short, int, void *),
+		enum xp_retval (*)(short, void *));
 extern void xpc_clear_interface(void);
 
 
-extern enum xpc_retval xpc_connect(int, xpc_channel_func, void *, u16,
+extern enum xp_retval xpc_connect(int, xpc_channel_func, void *, u16,
 						u16, u32, u32);
 extern void xpc_disconnect(int);
 
-static inline enum xpc_retval
-xpc_allocate(partid_t partid, int ch_number, u32 flags, void **payload)
+static inline enum xp_retval
+xpc_allocate(short partid, int ch_number, u32 flags, void **payload)
 {
 	return xpc_interface.allocate(partid, ch_number, flags, payload);
 }
 
-static inline enum xpc_retval
-xpc_send(partid_t partid, int ch_number, void *payload)
+static inline enum xp_retval
+xpc_send(short partid, int ch_number, void *payload)
 {
 	return xpc_interface.send(partid, ch_number, payload);
 }
 
-static inline enum xpc_retval
-xpc_send_notify(partid_t partid, int ch_number, void *payload,
+static inline enum xp_retval
+xpc_send_notify(short partid, int ch_number, void *payload,
 			xpc_notify_func func, void *key)
 {
 	return xpc_interface.send_notify(partid, ch_number, payload, func, key);
 }
 
 static inline void
-xpc_received(partid_t partid, int ch_number, void *payload)
+xpc_received(short partid, int ch_number, void *payload)
 {
 	return xpc_interface.received(partid, ch_number, payload);
 }
 
-static inline enum xpc_retval
-xpc_partid_to_nasids(partid_t partid, void *nasids)
+static inline enum xp_retval
+xpc_partid_to_nasids(short partid, void *nasids)
 {
 	return xpc_interface.partid_to_nasids(partid, nasids);
 }
 
+extern short xp_partition_id;
+extern u8 xp_region_size;
+extern unsigned long xp_rtc_cycles_per_second;
+extern enum xp_retval (*xp_remote_memcpy)(void *, const void *, size_t);
+extern enum xp_retval (*xp_register_remote_amos)(u64, size_t);
+extern enum xp_retval (*xp_unregister_remote_amos)(u64, size_t);
+extern int xp_sizeof_nasid_mask;
+extern int xp_sizeof_amo;
+extern u64 *(*xp_alloc_amos)(int);
+extern void (*xp_free_amos)(u64 *, int);
+extern enum xp_retval (*xp_set_amo)(u64 *, int, u64, int);
+extern enum xp_retval (*xp_set_amo_with_interrupt)(u64 *, int, u64, int, int,
+						    int, int);
+extern enum xp_retval (*xp_get_amo)(u64 *, int, u64 *);
+extern enum xp_retval (*xp_get_partition_rsvd_page_pa)(u64, u64 *, u64 *,
+							size_t *);
+extern enum xp_retval (*xp_change_memprotect)(u64, size_t, int, u64 *);
+extern void (*xp_change_memprotect_shub_wars_1_1)(int);
+extern void (*xp_allow_IPI_ops)(void);
+extern void (*xp_disallow_IPI_ops)(void);
+
+extern int (*xp_cpu_to_nasid)(int);
+extern int (*xp_node_to_nasid)(int);
 
 extern u64 xp_nofault_PIOR_target;
 extern int xp_nofault_PIOR(void *);
 extern int xp_error_PIOR(void);
 
 
-#endif /* _ASM_IA64_SN_XP_H */
+static inline int
+xp_partid_mask_words(int npartitions)
+{
+	return DIV_ROUND_UP(npartitions, BITS_PER_WORD);
+}
+
+static inline int
+xp_nasid_mask_words(void)
+{
+	return DIV_ROUND_UP(xp_sizeof_nasid_mask, BYTES_PER_WORD);
+}
+
+
+#endif /* _DRIVERS_MISC_XP_XP_H */
 
Index: linux-2.6/drivers/misc/xp/xp_main.c
===================================================================
--- linux-2.6.orig/drivers/misc/xp/xp_main.c	2008-03-26 10:40:03.160341945 -0500
+++ linux-2.6/drivers/misc/xp/xp_main.c	2008-03-26 10:41:24.502251175 -0500
@@ -3,7 +3,7 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  *
- * Copyright (c) 2004-2005 Silicon Graphics, Inc.  All Rights Reserved.
+ * Copyright (c) 2004-2008 Silicon Graphics, Inc.  All Rights Reserved.
  */
 
 
@@ -17,41 +17,77 @@
 
 
 #include <linux/kernel.h>
-#include <linux/interrupt.h>
 #include <linux/module.h>
-#include <linux/mutex.h>
-#include <asm/sn/intr.h>
-#include <asm/sn/sn_sal.h>
-#include <asm/sn/xp.h>
+#include <linux/device.h>
+#include "xp.h"
 
+/* Define the XP debug device structures to be used with dev_dbg() et al */
+
+struct device_driver xp_dbg_name = {
+	.name = "xp"
+};
+
+struct device xp_dbg_subname = {
+	.bus_id = {0},			/* set to "" */
+	.driver = &xp_dbg_name
+};
+
+struct device *xp = &xp_dbg_subname;
 
 /*
  * Target of nofault PIO read.
  */
 u64 xp_nofault_PIOR_target;
 
+short xp_partition_id;
+u8 xp_region_size;
+unsigned long xp_rtc_cycles_per_second;
 
-/*
- * xpc_registrations[] keeps track of xpc_connect()'s done by the kernel-level
- * users of XPC.
- */
-struct xpc_registration xpc_registrations[XPC_NCHANNELS];
+enum xp_retval (*xp_remote_memcpy)(void *dst, const void *src, size_t len);
+
+enum xp_retval (*xp_register_remote_amos)(u64 paddr, size_t len);
+enum xp_retval (*xp_unregister_remote_amos)(u64 paddr, size_t len);
+
+int xp_sizeof_nasid_mask;
+int xp_sizeof_amo;
+
+u64 *(*xp_alloc_amos)(int n_amos);
+void (*xp_free_amos)(u64 *amos_page, int n_amos);
+
+enum xp_retval (*xp_set_amo)(u64 *amo_va, int op, u64 operand, int remote);
+enum xp_retval (*xp_set_amo_with_interrupt)(u64 *amo_va, int op, u64 operand,
+					     int remote, int nasid,
+					     int phys_cpuid, int vector);
+
+enum xp_retval (*xp_get_amo)(u64 *amo_va, int op, u64 *amo_value_addr);
+
+enum xp_retval (*xp_get_partition_rsvd_page_pa)(u64 buf, u64 *cookie,
+						 u64 *paddr, size_t *len);
+
+enum xp_retval (*xp_change_memprotect)(u64 paddr, size_t len, int request,
+					u64 *nasid_array);
+void (*xp_change_memprotect_shub_wars_1_1)(int request);
+void (*xp_allow_IPI_ops)(void);
+void (*xp_disallow_IPI_ops)(void);
+
+int (*xp_cpu_to_nasid)(int cpuid);
+int (*xp_node_to_nasid)(int nid);
 
 
 /*
  * Initialize the XPC interface to indicate that XPC isn't loaded.
  */
-static enum xpc_retval xpc_notloaded(void) { return xpcNotLoaded; }
+static enum xp_retval xpc_notloaded(void) { return xpNotLoaded; }
 
 struct xpc_interface xpc_interface = {
 	(void (*)(int)) xpc_notloaded,
 	(void (*)(int)) xpc_notloaded,
-	(enum xpc_retval (*)(partid_t, int, u32, void **)) xpc_notloaded,
-	(enum xpc_retval (*)(partid_t, int, void *)) xpc_notloaded,
-	(enum xpc_retval (*)(partid_t, int, void *, xpc_notify_func, void *))
+	(enum xp_retval (*)(short, int, u32, void **)) xpc_notloaded,
+	(enum xp_retval (*)(short, int, void *)) xpc_notloaded,
+	(enum xp_retval (*)(short, int, void *, xpc_notify_func, void *))
 							xpc_notloaded,
-	(void (*)(partid_t, int, void *)) xpc_notloaded,
-	(enum xpc_retval (*)(partid_t, void *)) xpc_notloaded
+	(void (*)(short, int, void *)) xpc_notloaded,
+	(enum xp_retval (*)(short, void *)) xpc_notloaded
 };
 
 
@@ -61,12 +97,12 @@ struct xpc_interface xpc_interface = {
 void
 xpc_set_interface(void (*connect)(int),
 		void (*disconnect)(int),
-		enum xpc_retval (*allocate)(partid_t, int, u32, void **),
-		enum xpc_retval (*send)(partid_t, int, void *),
-		enum xpc_retval (*send_notify)(partid_t, int, void *,
+		enum xp_retval (*allocate)(short, int, u32, void **),
+		enum xp_retval (*send)(short, int, void *),
+		enum xp_retval (*send_notify)(short, int, void *,
 						xpc_notify_func, void *),
-		void (*received)(partid_t, int, void *),
-		enum xpc_retval (*partid_to_nasids)(partid_t, void *))
+		void (*received)(short, int, void *),
+		enum xp_retval (*partid_to_nasids)(short, void *))
 {
 	xpc_interface.connect = connect;
 	xpc_interface.disconnect = disconnect;
@@ -86,20 +122,27 @@ xpc_clear_interface(void)
 {
 	xpc_interface.connect = (void (*)(int)) xpc_notloaded;
 	xpc_interface.disconnect = (void (*)(int)) xpc_notloaded;
-	xpc_interface.allocate = (enum xpc_retval (*)(partid_t, int, u32,
+	xpc_interface.allocate = (enum xp_retval (*)(short, int, u32,
 					void **)) xpc_notloaded;
-	xpc_interface.send = (enum xpc_retval (*)(partid_t, int, void *))
+	xpc_interface.send = (enum xp_retval (*)(short, int, void *))
 					xpc_notloaded;
-	xpc_interface.send_notify = (enum xpc_retval (*)(partid_t, int, void *,
+	xpc_interface.send_notify = (enum xp_retval (*)(short, int, void *,
 				    xpc_notify_func, void *)) xpc_notloaded;
-	xpc_interface.received = (void (*)(partid_t, int, void *))
+	xpc_interface.received = (void (*)(short, int, void *))
 					xpc_notloaded;
-	xpc_interface.partid_to_nasids = (enum xpc_retval (*)(partid_t, void *))
+	xpc_interface.partid_to_nasids = (enum xp_retval (*)(short, void *))
 					xpc_notloaded;
 }
 
 
 /*
+ * xpc_registrations[] keeps track of xpc_connect()'s done by the kernel-level
+ * users of XPC.
+ */
+struct xpc_registration xpc_registrations[XPC_NCHANNELS];
+
+
+/*
  * Register for automatic establishment of a channel connection whenever
  * a partition comes up.
  *
@@ -116,14 +159,14 @@ xpc_clear_interface(void)
  *		       this large enough to hold their largest message.
  *	nentries - max #of XPC message entries a message queue can contain.
  *		   The actual number, which is determined when a connection
- * 		   is established and may be less then requested, will be
- *		   passed to the user via the xpcConnected callout.
+ *		   is established and may be less then requested, will be
+ *		   passed to the user via the xpConnected callout.
  *	assigned_limit - max number of kthreads allowed to be processing
- * 			 messages (per connection) at any given instant.
+ *			 messages (per connection) at any given instant.
  *	idle_limit - max number of kthreads allowed to be idle at any given
- * 		     instant.
+ *		     instant.
  */
-enum xpc_retval
+enum xp_retval
 xpc_connect(int ch_number, xpc_channel_func func, void *key, u16 payload_size,
 		u16 nentries, u32 assigned_limit, u32 idle_limit)
 {
@@ -138,13 +181,13 @@ xpc_connect(int ch_number, xpc_channel_f
 	registration = &xpc_registrations[ch_number];
 
 	if (mutex_lock_interruptible(&registration->mutex) != 0) {
-		return xpcInterrupted;
+		return xpInterrupted;
 	}
 
 	/* if XPC_CHANNEL_REGISTERED(ch_number) */
 	if (registration->func != NULL) {
 		mutex_unlock(&registration->mutex);
-		return xpcAlreadyRegistered;
+		return xpAlreadyRegistered;
 	}
 
 	/* register the channel for connection */
@@ -159,7 +202,7 @@ xpc_connect(int ch_number, xpc_channel_f
 
 	xpc_interface.connect(ch_number);
 
-	return xpcSuccess;
+	return xpSuccess;
 }
 
 
@@ -214,43 +257,26 @@ xpc_disconnect(int ch_number)
 	return;
 }
 
+extern enum xp_retval xp_init_sn2(void);
+extern enum xp_retval xp_init_uv(void);
 
 int __init
 xp_init(void)
 {
-	int ret, ch_number;
-	u64 func_addr = *(u64 *) xp_nofault_PIOR;
-	u64 err_func_addr = *(u64 *) xp_error_PIOR;
+	enum xp_retval ret;
+	int ch_number;
 
+	if (is_shub())
+		ret = xp_init_sn2();
+	else if (is_uv())
+		ret = xp_init_uv();
+	else
+		ret = xpUnsupported;
 
-	if (!ia64_platform_is("sn2")) {
+	if (ret != xpSuccess) {
 		return -ENODEV;
 	}
 
-	/*
-	 * Register a nofault code region which performs a cross-partition
-	 * PIO read. If the PIO read times out, the MCA handler will consume
-	 * the error and return to a kernel-provided instruction to indicate
-	 * an error. This PIO read exists because it is guaranteed to timeout
-	 * if the destination is down (AMO operations do not timeout on at
-	 * least some CPUs on Shubs <= v1.2, which unfortunately we have to
-	 * work around).
-	 */
-	if ((ret = sn_register_nofault_code(func_addr, err_func_addr,
-						err_func_addr, 1, 1)) != 0) {
-		printk(KERN_ERR "XP: can't register nofault code, error=%d\n",
-			ret);
-	}
-	/*
-	 * Setup the nofault PIO read target. (There is no special reason why
-	 * SH_IPI_ACCESS was selected.)
-	 */
-	if (is_shub2()) {
-		xp_nofault_PIOR_target = SH2_IPI_ACCESS0;
-	} else {
-		xp_nofault_PIOR_target = SH1_IPI_ACCESS;
-	}
-
 	/* initialize the connection registration mutex */
 	for (ch_number = 0; ch_number < XPC_NCHANNELS; ch_number++) {
 		mutex_init(&xpc_registrations[ch_number].mutex);
@@ -260,17 +286,16 @@ xp_init(void)
 }
 module_init(xp_init);
 
+extern void xp_exit_sn2(void);
+extern void xp_exit_uv(void);
 
 void __exit
 xp_exit(void)
 {
-	u64 func_addr = *(u64 *) xp_nofault_PIOR;
-	u64 err_func_addr = *(u64 *) xp_error_PIOR;
-
-
-	/* unregister the PIO read nofault code region */
-	(void) sn_register_nofault_code(func_addr, err_func_addr,
-					err_func_addr, 1, 0);
+	if (is_shub())
+		xp_exit_sn2();
+	else if (is_uv())
+		xp_exit_uv();
 }
 module_exit(xp_exit);
 
@@ -279,8 +304,26 @@ MODULE_AUTHOR("Silicon Graphics, Inc.");
 MODULE_DESCRIPTION("Cross Partition (XP) base");
 MODULE_LICENSE("GPL");
 
-EXPORT_SYMBOL(xp_nofault_PIOR);
-EXPORT_SYMBOL(xp_nofault_PIOR_target);
+EXPORT_SYMBOL(xp_partition_id);
+EXPORT_SYMBOL(xp_region_size);
+EXPORT_SYMBOL(xp_rtc_cycles_per_second);
+EXPORT_SYMBOL(xp_remote_memcpy);
+EXPORT_SYMBOL(xp_register_remote_amos);
+EXPORT_SYMBOL(xp_unregister_remote_amos);
+EXPORT_SYMBOL(xp_sizeof_nasid_mask);
+EXPORT_SYMBOL(xp_sizeof_amo);
+EXPORT_SYMBOL(xp_alloc_amos);
+EXPORT_SYMBOL(xp_free_amos);
+EXPORT_SYMBOL(xp_set_amo);
+EXPORT_SYMBOL(xp_set_amo_with_interrupt);
+EXPORT_SYMBOL(xp_get_amo);
+EXPORT_SYMBOL(xp_get_partition_rsvd_page_pa);
+EXPORT_SYMBOL(xp_change_memprotect);
+EXPORT_SYMBOL(xp_change_memprotect_shub_wars_1_1);
+EXPORT_SYMBOL(xp_allow_IPI_ops);
+EXPORT_SYMBOL(xp_disallow_IPI_ops);
+EXPORT_SYMBOL(xp_cpu_to_nasid);
+EXPORT_SYMBOL(xp_node_to_nasid);
 EXPORT_SYMBOL(xpc_registrations);
 EXPORT_SYMBOL(xpc_interface);
 EXPORT_SYMBOL(xpc_clear_interface);
Index: linux-2.6/drivers/misc/xp/xpc.h
===================================================================
--- linux-2.6.orig/drivers/misc/xp/xpc.h	2008-03-26 10:40:03.160341945 -0500
+++ linux-2.6/drivers/misc/xp/xpc.h	2008-03-26 10:41:38.940010397 -0500
@@ -3,7 +3,7 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  *
- * Copyright (c) 2004-2007 Silicon Graphics, Inc.  All Rights Reserved.
+ * Copyright (c) 2004-2008 Silicon Graphics, Inc.  All Rights Reserved.
  */
 
 
@@ -11,8 +11,8 @@
  * Cross Partition Communication (XPC) structures and macros.
  */
 
-#ifndef _ASM_IA64_SN_XPC_H
-#define _ASM_IA64_SN_XPC_H
+#ifndef _DRIVERS_MISC_XP_XPC_H
+#define _DRIVERS_MISC_XP_XPC_H
 
 
 #include <linux/interrupt.h>
@@ -22,12 +22,15 @@
 #include <linux/completion.h>
 #include <asm/pgtable.h>
 #include <asm/processor.h>
-#include <asm/sn/bte.h>
-#include <asm/sn/clksupport.h>
-#include <asm/sn/addrs.h>
-#include <asm/sn/mspec.h>
-#include <asm/sn/shub_mmr.h>
-#include <asm/sn/xp.h>
+#if defined(CONFIG_IA64)
+#include <asm/sn/intr.h>
+#elif defined(CONFIG_X86_64)
+#define SGI_XPC_ACTIVATE 0x30
+#define SGI_XPC_NOTIFY 0xe7
+#else
+#error architecture is NOT supported
+#endif
+#include "xp.h"
 
 
 /*
@@ -43,7 +46,7 @@
 /*
  * The next macros define word or bit representations for given
  * C-brick nasid in either the SAL provided bit array representing
- * nasids in the partition/machine or the AMO_t array used for
+ * nasids in the partition/machine or the array of AMO variables used for
  * inter-partition initiation communications.
  *
  * For SN2 machines, C-Bricks are alway even numbered NASIDs.  As
@@ -51,11 +54,7 @@
  * passed from SAL always be packed for C-Bricks and the
  * cross-partition interrupts use the same packing scheme.
  */
-#define XPC_NASID_W_INDEX(_n)	(((_n) / 64) / 2)
-#define XPC_NASID_B_INDEX(_n)	(((_n) / 2) & (64 - 1))
-#define XPC_NASID_IN_ARRAY(_n, _p) ((_p)[XPC_NASID_W_INDEX(_n)] & \
-				    (1UL << XPC_NASID_B_INDEX(_n)))
-#define XPC_NASID_FROM_W_B(_w, _b) (((_w) * 64 + (_b)) * 2)
+#define XPC_NASID_IN_ARRAY(_n, _p) ((_p)[BIT_WORD((_n)/2)] & BIT_MASK((_n)/2))
 
 #define XPC_HB_DEFAULT_INTERVAL		5	/* incr HB every x secs */
 #define XPC_HB_CHECK_DEFAULT_INTERVAL	20	/* check HB every x secs */
@@ -80,8 +79,8 @@
  *     The first cacheline of the reserved page contains the header
  *     (struct xpc_rsvd_page). Before SAL initialization has completed,
  *     SAL has set up the following fields of the reserved page header:
- *     SAL_signature, SAL_version, partid, and nasids_size. The other
- *     fields are set up by XPC. (xpc_rsvd_page points to the local
+ *     SAL_signature, SAL_version, SAL_partid, and SAL_nasids_size. The
+ *     other fields are set up by XPC. (xpc_rsvd_page points to the local
  *     partition's reserved page.)
  *
  *   part_nasids mask
@@ -112,16 +111,16 @@
 struct xpc_rsvd_page {
 	u64 SAL_signature;	/* SAL: unique signature */
 	u64 SAL_version;	/* SAL: version */
-	u8 partid;		/* SAL: partition ID */
+	u8 SAL_partid;		/* SAL: partition ID */
 	u8 version;
-	u8 pad1[6];		/* align to next u64 in cacheline */
-	volatile u64 vars_pa;
+	u8 pad[6];
+	volatile u64 vars_pa;	/* physical address of struct xpc_vars */
 	struct timespec stamp;	/* time when reserved page was setup by XPC */
 	u64 pad2[9];		/* align to last u64 in cacheline */
-	u64 nasids_size;	/* SAL: size of each nasid mask in bytes */
+	u64 SAL_nasids_size;	/* SAL: size of each nasid mask in bytes */
 };
 
-#define XPC_RP_VERSION _XPC_VERSION(1,1) /* version 1.1 of the reserved page */
+#define XPC_RP_VERSION _XPC_VERSION(2,0) /* version 2.0 of the reserved page */
 
 #define XPC_SUPPORTS_RP_STAMP(_version) \
 			(_version >= _XPC_VERSION(1,1))
@@ -162,65 +161,109 @@ xpc_compare_stamps(struct timespec *stam
  */
 struct xpc_vars {
 	u8 version;
-	u64 heartbeat;
-	u64 heartbeating_to_mask;
-	u64 heartbeat_offline;	/* if 0, heartbeat should be changing */
+	short partid;
+	short npartitions;	/* value of XPC_NPARTITIONS */
 	int act_nasid;
 	int act_phys_cpuid;
 	u64 vars_part_pa;
-	u64 amos_page_pa;	/* paddr of page of AMOs from MSPEC driver */
-	AMO_t *amos_page;	/* vaddr of page of AMOs from MSPEC driver */
+	u64 amos_page_pa;	/* paddr of first page of AMOs variables */
+	u64 *amos_page;		/* vaddr of first page of AMOs variables */
+	u64 heartbeat;
+	u64 heartbeat_offline;	/* if 0, heartbeat should be changing */
+	u64 heartbeating_to_mask[BITS_TO_LONGS(XP_MAX_NPARTITIONS)];
 };
 
-#define XPC_V_VERSION _XPC_VERSION(3,1) /* version 3.1 of the cross vars */
+#define XPC_V_VERSION _XPC_VERSION(4,0) /* version 4.0 of the cross vars */
 
 #define XPC_SUPPORTS_DISENGAGE_REQUEST(_version) \
 			(_version >= _XPC_VERSION(3,1))
 
 
 static inline int
-xpc_hb_allowed(partid_t partid, struct xpc_vars *vars)
+xpc_hb_allowed(short partid, struct xpc_vars *vars)
 {
-	return ((vars->heartbeating_to_mask & (1UL << partid)) != 0);
+	return test_bit(partid, vars->heartbeating_to_mask);
+}
+
+static inline int
+xpc_any_hbs_allowed(struct xpc_vars *vars)
+{
+	return !bitmap_empty((unsigned long *)vars->heartbeating_to_mask,
+			     vars->npartitions);
 }
 
 static inline void
-xpc_allow_hb(partid_t partid, struct xpc_vars *vars)
+xpc_allow_hb(short partid, struct xpc_vars *vars)
 {
-	u64 old_mask, new_mask;
+	set_bit(partid, vars->heartbeating_to_mask);
+}
 
-	do {
-		old_mask = vars->heartbeating_to_mask;
-		new_mask = (old_mask | (1UL << partid));
-	} while (cmpxchg(&vars->heartbeating_to_mask, old_mask, new_mask) !=
-							old_mask);
+static inline void
+xpc_disallow_hb(short partid, struct xpc_vars *vars)
+{
+	clear_bit(partid, vars->heartbeating_to_mask);
 }
 
 static inline void
-xpc_disallow_hb(partid_t partid, struct xpc_vars *vars)
+xpc_disallow_all_hbs(struct xpc_vars *vars)
 {
-	u64 old_mask, new_mask;
+	int nlongs = BITS_TO_LONGS(vars->npartitions);
+	int i;
 
-	do {
-		old_mask = vars->heartbeating_to_mask;
-		new_mask = (old_mask & ~(1UL << partid));
-	} while (cmpxchg(&vars->heartbeating_to_mask, old_mask, new_mask) !=
-							old_mask);
+	for (i = 0; i < nlongs; i++)
+		vars->heartbeating_to_mask[i] = 0;
 }
 
 
 /*
- * The AMOs page consists of a number of AMO variables which are divided into
- * four groups, The first two groups are used to identify an IRQ's sender.
- * These two groups consist of 64 and 128 AMO variables respectively. The last
- * two groups, consisting of just one AMO variable each, are used to identify
- * the remote partitions that are currently engaged (from the viewpoint of
- * the XPC running on the remote partition).
+ * The AMOs page(s) consists of a number of AMO variables which are divided into
+ * four groups, The first group consists of one AMO per partition, each of which
+ * reflects state changes of up to eight channels and are accompanied by the
+ * receipt of a NOTIFY IRQ. The second group represents a bitmap of nasids by
+ * which to identify an ACTIVATE IRQ's sender. The last two groups, each
+ * representing a bitmap of partids, are used to identify the remote partitions
+ * that are currently engaged (from the viewpoint of the XPC running on the
+ * remote partition).
+ *
+ * The following #defines reflect an AMO index into these AMOS page(s).
  */
-#define XPC_NOTIFY_IRQ_AMOS	   0
-#define XPC_ACTIVATE_IRQ_AMOS	   (XPC_NOTIFY_IRQ_AMOS + XP_MAX_PARTITIONS)
-#define XPC_ENGAGED_PARTITIONS_AMO (XPC_ACTIVATE_IRQ_AMOS + XP_NASID_MASK_WORDS)
-#define XPC_DISENGAGE_REQUEST_AMO  (XPC_ENGAGED_PARTITIONS_AMO + 1)
+
+/* get offset to beginning of notify IRQ AMOs */
+static inline int
+xpc_notify_irq_amos(void)
+{
+	return 0;
+}
+
+/* get offset to beginning of activate IRQ AMOs */
+static inline int
+xpc_activate_irq_amos(int npartitions)
+{
+	return xpc_notify_irq_amos() + npartitions;
+}
+
+/* get offset to beginning of engaged partitions AMOs */
+static inline int
+xpc_engaged_partitions_amos(int npartitions)
+{
+	return xpc_activate_irq_amos(npartitions) + xp_nasid_mask_words();
+}
+
+/* get offset to beginning of disengaged request AMOs */
+static inline int
+xpc_disengage_request_amos(int npartitions)
+{
+	return xpc_engaged_partitions_amos(npartitions) +
+					xp_partid_mask_words(npartitions);
+}
+
+/* get total number of AMOs */
+static inline int
+xpc_number_of_amos(int npartitions)
+{
+	return xpc_disengage_request_amos(npartitions) +
+					xp_partid_mask_words(npartitions);
+}
 
 
 /*
@@ -239,7 +282,7 @@ struct xpc_vars_part {
 	u64 openclose_args_pa;	/* physical address of open and close args */
 	u64 GPs_pa;		/* physical address of Get/Put values */
 
-	u64 IPI_amo_pa;		/* physical address of IPI AMO_t structure */
+	u64 IPI_amo_pa;		/* physical address of IPI AMO variable */
 	int IPI_nasid;		/* nasid of where to send IPIs */
 	int IPI_phys_cpuid;	/* physical CPU ID of where to send IPIs */
 
@@ -264,12 +307,14 @@ struct xpc_vars_part {
 /* the reserved page sizes and offsets */
 
 #define XPC_RP_HEADER_SIZE	L1_CACHE_ALIGN(sizeof(struct xpc_rsvd_page))
-#define XPC_RP_VARS_SIZE 	L1_CACHE_ALIGN(sizeof(struct xpc_vars))
+#define XPC_RP_VARS_SIZE	L1_CACHE_ALIGN(sizeof(struct xpc_vars))
 
-#define XPC_RP_PART_NASIDS(_rp) (u64 *) ((u8 *) _rp + XPC_RP_HEADER_SIZE)
-#define XPC_RP_MACH_NASIDS(_rp) (XPC_RP_PART_NASIDS(_rp) + xp_nasid_mask_words)
-#define XPC_RP_VARS(_rp)	((struct xpc_vars *) XPC_RP_MACH_NASIDS(_rp) + xp_nasid_mask_words)
-#define XPC_RP_VARS_PART(_rp)	(struct xpc_vars_part *) ((u8 *) XPC_RP_VARS(rp) + XPC_RP_VARS_SIZE)
+#define XPC_RP_PART_NASIDS(_rp) (u64 *)((u8 *)(_rp) + XPC_RP_HEADER_SIZE)
+#define XPC_RP_MACH_NASIDS(_rp) (XPC_RP_PART_NASIDS(_rp) + \
+				 xp_nasid_mask_words())
+#define XPC_RP_VARS(_rp)	(struct xpc_vars *)(XPC_RP_MACH_NASIDS(_rp) + \
+				 xp_nasid_mask_words())
+#define XPC_RP_VARS_PART(_rp)	(struct xpc_vars_part *)((u8 *)XPC_RP_VARS(_rp) + XPC_RP_VARS_SIZE)
 
 
 /*
@@ -428,11 +473,11 @@ struct xpc_notify {
  *	messages.
  */
 struct xpc_channel {
-	partid_t partid;		/* ID of remote partition connected */
+	short partid;			/* ID of remote partition connected */
 	spinlock_t lock;		/* lock for updating this structure */
 	u32 flags;			/* general flags */
 
-	enum xpc_retval reason;		/* reason why channel is disconnect'g */
+	enum xp_retval reason;		/* reason why channel is disconnect'g */
 	int reason_line;		/* line# disconnect initiated from */
 
 	u16 number;			/* channel # */
@@ -481,16 +526,11 @@ struct xpc_channel {
 
 	/* kthread management related fields */
 
-// >>> rethink having kthreads_assigned_limit and kthreads_idle_limit; perhaps
-// >>> allow the assigned limit be unbounded and let the idle limit be dynamic
-// >>> dependent on activity over the last interval of time
 	atomic_t kthreads_assigned;	/* #of kthreads assigned to channel */
-	u32 kthreads_assigned_limit; 	/* limit on #of kthreads assigned */
+	u32 kthreads_assigned_limit;	/* limit on #of kthreads assigned */
 	atomic_t kthreads_idle;		/* #of kthreads idle waiting for work */
 	u32 kthreads_idle_limit;	/* limit on #of kthreads idle */
 	atomic_t kthreads_active;	/* #of kthreads actively working */
-	// >>> following field is temporary
-	u32 kthreads_created;		/* total #of kthreads created */
 
 	wait_queue_head_t idle_wq;	/* idle kthread wait queue */
 
@@ -538,6 +578,8 @@ struct xpc_partition {
 	/* XPC HB infrastructure */
 
 	u8 remote_rp_version;		/* version# of partition's rsvd pg */
+	short remote_npartitions;	/* value of XPC_NPARTITIONS */
+	u32 flags;			/* general flags */
 	struct timespec remote_rp_stamp;/* time when rsvd pg was initialized */
 	u64 remote_rp_pa;		/* phys addr of partition's rsvd pg */
 	u64 remote_vars_pa;		/* phys addr of partition's vars */
@@ -547,10 +589,11 @@ struct xpc_partition {
 	int remote_act_nasid;		/* active part's act/deact nasid */
 	int remote_act_phys_cpuid;	/* active part's act/deact phys cpuid */
 	u32 act_IRQ_rcvd;		/* IRQs since activation */
-	spinlock_t act_lock;		/* protect updating of act_state */
+	spinlock_t lock;		/* protect updating of act_state and */
+					/* the general flags */
 	u8 act_state;			/* from XPC HB viewpoint */
 	u8 remote_vars_version;		/* version# of partition's vars */
-	enum xpc_retval reason;		/* reason partition is deactivating */
+	enum xp_retval reason;		/* reason partition is deactivating */
 	int reason_line;		/* line# deactivation initiated from */
 	int reactivate_nasid;		/* nasid in partition to reactivate */
 
@@ -601,9 +644,9 @@ struct xpc_partition {
 
 	int remote_IPI_nasid;	    /* nasid of where to send IPIs */
 	int remote_IPI_phys_cpuid;  /* phys CPU ID of where to send IPIs */
-	AMO_t *remote_IPI_amo_va;   /* address of remote IPI AMO_t structure */
+	u64 *remote_IPI_amo_va;	    /* address of remote IPI AMO variable */
 
-	AMO_t *local_IPI_amo_va;    /* address of IPI AMO_t structure */
+	u64 *local_IPI_amo_va;      /* address of IPI AMO variable */
 	u64 local_IPI_amo;	    /* IPI amo flags yet to be handled */
 	char IPI_owner[8];	    /* IPI owner's name */
 	struct timer_list dropped_IPI_timer; /* dropped IPI timer */
@@ -618,14 +661,17 @@ struct xpc_partition {
 
 } ____cacheline_aligned;
 
+/* struct xpc_partition flags */
+
+#define	XPC_P_RAMOSREGISTERED	0x00000001 /* remote AMOs were registered */
 
 /* struct xpc_partition act_state values (for XPC HB) */
 
-#define	XPC_P_INACTIVE		0x00	/* partition is not active */
-#define XPC_P_ACTIVATION_REQ	0x01	/* created thread to activate */
-#define XPC_P_ACTIVATING	0x02	/* activation thread started */
-#define XPC_P_ACTIVE		0x03	/* xpc_partition_up() was called */
-#define XPC_P_DEACTIVATING	0x04	/* partition deactivation initiated */
+#define	XPC_P_AS_INACTIVE	0x00	/* partition is not active */
+#define XPC_P_AS_ACTIVATION_REQ	0x01	/* created thread to activate */
+#define XPC_P_AS_ACTIVATING	0x02	/* activation thread started */
+#define XPC_P_AS_ACTIVE		0x03	/* xpc_partition_up() was called */
+#define XPC_P_AS_DEACTIVATING	0x04	/* partition deactivation initiated */
 
 
 #define XPC_DEACTIVATE_PARTITION(_p, _reason) \
@@ -634,10 +680,10 @@ struct xpc_partition {
 
 /* struct xpc_partition setup_state values */
 
-#define XPC_P_UNSET		0x00	/* infrastructure was never setup */
-#define XPC_P_SETUP		0x01	/* infrastructure is setup */
-#define XPC_P_WTEARDOWN		0x02	/* waiting to teardown infrastructure */
-#define XPC_P_TORNDOWN		0x03	/* infrastructure is torndown */
+#define XPC_P_SS_UNSET		0x00	/* infrastructure was never setup */
+#define XPC_P_SS_SETUP		0x01	/* infrastructure is setup */
+#define XPC_P_SS_WTEARDOWN	0x02	/* waiting to teardown infrastructure */
+#define XPC_P_SS_TORNDOWN	0x03	/* infrastructure is torndown */
 
 
 
@@ -646,7 +692,7 @@ struct xpc_partition {
  * dropped IPIs. These occur whenever an IPI amo write doesn't complete until
  * after the IPI was received.
  */
-#define XPC_P_DROPPED_IPI_WAIT	(0.25 * HZ)
+#define XPC_DROPPED_IPI_WAIT_INTERVAL	(0.25 * HZ)
 
 
 /* number of seconds to wait for other partitions to disengage */
@@ -656,7 +702,7 @@ struct xpc_partition {
 #define XPC_DISENGAGE_PRINTMSG_INTERVAL		10
 
 
-#define XPC_PARTID(_p)	((partid_t) ((_p) - &xpc_partitions[0]))
+#define XPC_PARTID(_p)	((short) ((_p) - &xpc_partitions[0]))
 
 
 
@@ -682,41 +728,41 @@ extern int xpc_exiting;
 extern struct xpc_vars *xpc_vars;
 extern struct xpc_rsvd_page *xpc_rsvd_page;
 extern struct xpc_vars_part *xpc_vars_part;
-extern struct xpc_partition xpc_partitions[XP_MAX_PARTITIONS + 1];
+extern struct xpc_partition xpc_partitions[XP_NPARTITIONS + 1];
 extern char *xpc_remote_copy_buffer;
 extern void *xpc_remote_copy_buffer_base;
 extern void *xpc_kmalloc_cacheline_aligned(size_t, gfp_t, void **);
 extern struct xpc_rsvd_page *xpc_rsvd_page_init(void);
-extern void xpc_allow_IPI_ops(void);
-extern void xpc_restrict_IPI_ops(void);
 extern int xpc_identify_act_IRQ_sender(void);
 extern int xpc_partition_disengaged(struct xpc_partition *);
-extern enum xpc_retval xpc_mark_partition_active(struct xpc_partition *);
+extern enum xp_retval xpc_mark_partition_active(struct xpc_partition *);
+extern void xpc_deactivate_partition(const int, struct xpc_partition *,
+						enum xp_retval);
 extern void xpc_mark_partition_inactive(struct xpc_partition *);
+extern enum xp_retval xpc_register_remote_amos(struct xpc_partition *);
+extern void xpc_unregister_remote_amos(struct xpc_partition *);
 extern void xpc_discovery(void);
 extern void xpc_check_remote_hb(void);
-extern void xpc_deactivate_partition(const int, struct xpc_partition *,
-						enum xpc_retval);
-extern enum xpc_retval xpc_initiate_partid_to_nasids(partid_t, void *);
+extern enum xp_retval xpc_initiate_partid_to_nasids(short, void *);
 
 
 /* found in xpc_channel.c */
 extern void xpc_initiate_connect(int);
 extern void xpc_initiate_disconnect(int);
-extern enum xpc_retval xpc_initiate_allocate(partid_t, int, u32, void **);
-extern enum xpc_retval xpc_initiate_send(partid_t, int, void *);
-extern enum xpc_retval xpc_initiate_send_notify(partid_t, int, void *,
+extern enum xp_retval xpc_initiate_allocate(short, int, u32, void **);
+extern enum xp_retval xpc_initiate_send(short, int, void *);
+extern enum xp_retval xpc_initiate_send_notify(short, int, void *,
 						xpc_notify_func, void *);
-extern void xpc_initiate_received(partid_t, int, void *);
-extern enum xpc_retval xpc_setup_infrastructure(struct xpc_partition *);
-extern enum xpc_retval xpc_pull_remote_vars_part(struct xpc_partition *);
+extern void xpc_initiate_received(short, int, void *);
+extern enum xp_retval xpc_setup_infrastructure(struct xpc_partition *);
+extern enum xp_retval xpc_pull_remote_vars_part(struct xpc_partition *);
 extern void xpc_process_channel_activity(struct xpc_partition *);
 extern void xpc_connected_callout(struct xpc_channel *);
 extern void xpc_deliver_msg(struct xpc_channel *);
 extern void xpc_disconnect_channel(const int, struct xpc_channel *,
-					enum xpc_retval, unsigned long *);
-extern void xpc_disconnect_callout(struct xpc_channel *, enum xpc_retval);
-extern void xpc_partition_going_down(struct xpc_partition *, enum xpc_retval);
+					enum xp_retval, unsigned long *);
+extern void xpc_disconnect_callout(struct xpc_channel *, enum xp_retval);
+extern void xpc_partition_going_down(struct xpc_partition *, enum xp_retval);
 extern void xpc_teardown_infrastructure(struct xpc_partition *);
 
 
@@ -769,7 +815,7 @@ xpc_part_deref(struct xpc_partition *par
 
 
 	DBUG_ON(refs < 0);
-	if (refs == 0 && part->setup_state == XPC_P_WTEARDOWN) {
+	if (refs == 0 && part->setup_state == XPC_P_SS_WTEARDOWN) {
 		wake_up(&part->teardown_wq);
 	}
 }
@@ -781,7 +827,7 @@ xpc_part_ref(struct xpc_partition *part)
 
 
 	atomic_inc(&part->references);
-	setup = (part->setup_state == XPC_P_SETUP);
+	setup = (part->setup_state == XPC_P_SS_SETUP);
 	if (!setup) {
 		xpc_part_deref(part);
 	}
@@ -811,145 +857,123 @@ xpc_part_ref(struct xpc_partition *part)
 static inline void
 xpc_mark_partition_engaged(struct xpc_partition *part)
 {
-	unsigned long irq_flags;
-	AMO_t *amo = (AMO_t *) __va(part->remote_amos_page_pa +
-				(XPC_ENGAGED_PARTITIONS_AMO * sizeof(AMO_t)));
-
-
-	local_irq_save(irq_flags);
+	u64 *amo_va = __va(part->remote_amos_page_pa +
+			(xpc_engaged_partitions_amos(part->remote_npartitions) +
+			BIT_WORD(xp_partition_id)) * xp_sizeof_amo);
 
 	/* set bit corresponding to our partid in remote partition's AMO */
-	FETCHOP_STORE_OP(TO_AMO((u64) &amo->variable), FETCHOP_OR,
-						(1UL << sn_partition_id));
-	/*
-	 * We must always use the nofault function regardless of whether we
-	 * are on a Shub 1.1 system or a Shub 1.2 slice 0xc processor. If we
-	 * didn't, we'd never know that the other partition is down and would
-	 * keep sending IPIs and AMOs to it until the heartbeat times out.
-	 */
-	(void) xp_nofault_PIOR((u64 *) GLOBAL_MMR_ADDR(NASID_GET(&amo->
-				variable), xp_nofault_PIOR_target));
-
-	local_irq_restore(irq_flags);
+	(void)xp_set_amo(amo_va, XP_AMO_OR, BIT_MASK(xp_partition_id), 1);
 }
 
 static inline void
 xpc_mark_partition_disengaged(struct xpc_partition *part)
 {
-	unsigned long irq_flags;
-	AMO_t *amo = (AMO_t *) __va(part->remote_amos_page_pa +
-				(XPC_ENGAGED_PARTITIONS_AMO * sizeof(AMO_t)));
-
-
-	local_irq_save(irq_flags);
+	u64 *amo_va = __va(part->remote_amos_page_pa +
+			(xpc_engaged_partitions_amos(part->remote_npartitions) +
+			BIT_WORD(xp_partition_id)) * xp_sizeof_amo);
 
 	/* clear bit corresponding to our partid in remote partition's AMO */
-	FETCHOP_STORE_OP(TO_AMO((u64) &amo->variable), FETCHOP_AND,
-						~(1UL << sn_partition_id));
-	/*
-	 * We must always use the nofault function regardless of whether we
-	 * are on a Shub 1.1 system or a Shub 1.2 slice 0xc processor. If we
-	 * didn't, we'd never know that the other partition is down and would
-	 * keep sending IPIs and AMOs to it until the heartbeat times out.
-	 */
-	(void) xp_nofault_PIOR((u64 *) GLOBAL_MMR_ADDR(NASID_GET(&amo->
-				variable), xp_nofault_PIOR_target));
-
-	local_irq_restore(irq_flags);
+	(void)xp_set_amo(amo_va, XP_AMO_AND, ~BIT_MASK(xp_partition_id), 1);
 }
 
 static inline void
 xpc_request_partition_disengage(struct xpc_partition *part)
 {
-	unsigned long irq_flags;
-	AMO_t *amo = (AMO_t *) __va(part->remote_amos_page_pa +
-				(XPC_DISENGAGE_REQUEST_AMO * sizeof(AMO_t)));
-
-
-	local_irq_save(irq_flags);
+	u64 *amo_va = __va(part->remote_amos_page_pa +
+			(xpc_disengage_request_amos(part->remote_npartitions) +
+			BIT_WORD(xp_partition_id)) * xp_sizeof_amo);
 
 	/* set bit corresponding to our partid in remote partition's AMO */
-	FETCHOP_STORE_OP(TO_AMO((u64) &amo->variable), FETCHOP_OR,
-						(1UL << sn_partition_id));
-	/*
-	 * We must always use the nofault function regardless of whether we
-	 * are on a Shub 1.1 system or a Shub 1.2 slice 0xc processor. If we
-	 * didn't, we'd never know that the other partition is down and would
-	 * keep sending IPIs and AMOs to it until the heartbeat times out.
-	 */
-	(void) xp_nofault_PIOR((u64 *) GLOBAL_MMR_ADDR(NASID_GET(&amo->
-				variable), xp_nofault_PIOR_target));
-
-	local_irq_restore(irq_flags);
+	(void)xp_set_amo(amo_va, XP_AMO_OR, BIT_MASK(xp_partition_id), 1);
 }
 
 static inline void
 xpc_cancel_partition_disengage_request(struct xpc_partition *part)
 {
-	unsigned long irq_flags;
-	AMO_t *amo = (AMO_t *) __va(part->remote_amos_page_pa +
-				(XPC_DISENGAGE_REQUEST_AMO * sizeof(AMO_t)));
-
-
-	local_irq_save(irq_flags);
+	u64 *amo_va = __va(part->remote_amos_page_pa +
+			(xpc_disengage_request_amos(part->remote_npartitions) +
+			BIT_WORD(xp_partition_id)) * xp_sizeof_amo);
 
 	/* clear bit corresponding to our partid in remote partition's AMO */
-	FETCHOP_STORE_OP(TO_AMO((u64) &amo->variable), FETCHOP_AND,
-						~(1UL << sn_partition_id));
-	/*
-	 * We must always use the nofault function regardless of whether we
-	 * are on a Shub 1.1 system or a Shub 1.2 slice 0xc processor. If we
-	 * didn't, we'd never know that the other partition is down and would
-	 * keep sending IPIs and AMOs to it until the heartbeat times out.
-	 */
-	(void) xp_nofault_PIOR((u64 *) GLOBAL_MMR_ADDR(NASID_GET(&amo->
-				variable), xp_nofault_PIOR_target));
-
-	local_irq_restore(irq_flags);
+	(void)xp_set_amo(amo_va, XP_AMO_AND, ~BIT_MASK(xp_partition_id), 1);
 }
 
-static inline u64
-xpc_partition_engaged(u64 partid_mask)
+static inline int
+xpc_any_partition_engaged(void)
 {
-	AMO_t *amo = xpc_vars->amos_page + XPC_ENGAGED_PARTITIONS_AMO;
+	enum xp_retval ret;
+	int w_index;
+	u64 *amo_va = (u64 *)((u64)xpc_vars->amos_page +
+			xpc_engaged_partitions_amos(xpc_vars->npartitions) *
+			xp_sizeof_amo);
+	u64 amo;
+
+	for (w_index = 0; w_index < xp_partid_mask_words(xpc_vars->npartitions);
+	     w_index++) {
+		ret = xp_get_amo(amo_va, XP_AMO_LOAD, &amo);
+		BUG_ON(ret != xpSuccess);  /* should never happen */
+		if (amo != 0)
+			return 1;
 
-
-	/* return our partition's AMO variable ANDed with partid_mask */
-	return (FETCHOP_LOAD_OP(TO_AMO((u64) &amo->variable), FETCHOP_LOAD) &
-								partid_mask);
+		amo_va = (u64 *)((u64)amo_va + xp_sizeof_amo);
+	}
+	return 0;
 }
 
 static inline u64
-xpc_partition_disengage_requested(u64 partid_mask)
+xpc_partition_engaged(short partid)
 {
-	AMO_t *amo = xpc_vars->amos_page + XPC_DISENGAGE_REQUEST_AMO;
+	enum xp_retval ret;
+	u64 *amo_va = (u64 *)((u64)xpc_vars->amos_page +
+			(xpc_engaged_partitions_amos(xpc_vars->npartitions) +
+			BIT_WORD(partid)) * xp_sizeof_amo);
+	u64 amo;
+
+	/* return our partition's AMO variable ANDed with partid mask */
+	ret = xp_get_amo(amo_va, XP_AMO_LOAD, &amo);
+	BUG_ON(ret != xpSuccess);  /* should never happen */
+	return (amo & BIT_MASK(partid));
+}
 
+static inline u64
+xpc_partition_disengage_requested(short partid)
+{
+	enum xp_retval ret;
+	u64 *amo_va = (u64 *)((u64)xpc_vars->amos_page +
+			(xpc_disengage_request_amos(xpc_vars->npartitions) +
+			BIT_WORD(partid)) * xp_sizeof_amo);
+	u64 amo;
 
-	/* return our partition's AMO variable ANDed with partid_mask */
-	return (FETCHOP_LOAD_OP(TO_AMO((u64) &amo->variable), FETCHOP_LOAD) &
-								partid_mask);
+	/* return our partition's AMO variable ANDed with partid mask */
+	ret = xp_get_amo(amo_va, XP_AMO_LOAD, &amo);
+	BUG_ON(ret != xpSuccess);  /* should never happen */
+	return (amo & BIT_MASK(partid));
 }
 
 static inline void
-xpc_clear_partition_engaged(u64 partid_mask)
+xpc_clear_partition_engaged(short partid)
 {
-	AMO_t *amo = xpc_vars->amos_page + XPC_ENGAGED_PARTITIONS_AMO;
+	enum xp_retval ret;
+	u64 *amo_va = (u64 *)((u64)xpc_vars->amos_page +
+			(xpc_engaged_partitions_amos(xpc_vars->npartitions) +
+			BIT_WORD(partid)) * xp_sizeof_amo);
 
-
-	/* clear bit(s) based on partid_mask in our partition's AMO */
-	FETCHOP_STORE_OP(TO_AMO((u64) &amo->variable), FETCHOP_AND,
-								~partid_mask);
+	/* clear bit corresponding to partid in our partition's AMO */
+	ret = xp_set_amo(amo_va, XP_AMO_AND, ~BIT_MASK(partid), 0);
+	BUG_ON(ret != xpSuccess);  /* should never happen */
 }
 
 static inline void
-xpc_clear_partition_disengage_request(u64 partid_mask)
+xpc_clear_partition_disengage_request(short partid)
 {
-	AMO_t *amo = xpc_vars->amos_page + XPC_DISENGAGE_REQUEST_AMO;
-
+	enum xp_retval ret;
+	u64 *amo_va = (u64 *)((u64)xpc_vars->amos_page +
+			(xpc_disengage_request_amos(xpc_vars->npartitions) +
+			BIT_WORD(partid)) * xp_sizeof_amo);
 
-	/* clear bit(s) based on partid_mask in our partition's AMO */
-	FETCHOP_STORE_OP(TO_AMO((u64) &amo->variable), FETCHOP_AND,
-								~partid_mask);
+	/* clear bit corresponding to partid in our partition's AMO */
+	ret = xp_set_amo(amo_va, XP_AMO_AND, ~BIT_MASK(partid), 0);
+	BUG_ON(ret != xpSuccess);  /* should never happen */
 }
 
 
@@ -961,40 +985,6 @@ xpc_clear_partition_disengage_request(u6
  * the other that is associated with channel activity (SGI_XPC_NOTIFY).
  */
 
-static inline u64
-xpc_IPI_receive(AMO_t *amo)
-{
-	return FETCHOP_LOAD_OP(TO_AMO((u64) &amo->variable), FETCHOP_CLEAR);
-}
-
-
-static inline enum xpc_retval
-xpc_IPI_send(AMO_t *amo, u64 flag, int nasid, int phys_cpuid, int vector)
-{
-	int ret = 0;
-	unsigned long irq_flags;
-
-
-	local_irq_save(irq_flags);
-
-	FETCHOP_STORE_OP(TO_AMO((u64) &amo->variable), FETCHOP_OR, flag);
-	sn_send_IPI_phys(nasid, phys_cpuid, vector, 0);
-
-	/*
-	 * We must always use the nofault function regardless of whether we
-	 * are on a Shub 1.1 system or a Shub 1.2 slice 0xc processor. If we
-	 * didn't, we'd never know that the other partition is down and would
-	 * keep sending IPIs and AMOs to it until the heartbeat times out.
-	 */
-	ret = xp_nofault_PIOR((u64 *) GLOBAL_MMR_ADDR(NASID_GET(&amo->variable),
-				xp_nofault_PIOR_target));
-
-	local_irq_restore(irq_flags);
-
-	return ((ret == 0) ? xpcSuccess : xpcPioReadError);
-}
-
-
 /*
  * IPIs associated with SGI_XPC_ACTIVATE IRQ.
  */
@@ -1004,44 +994,53 @@ xpc_IPI_send(AMO_t *amo, u64 flag, int n
  */
 static inline void
 xpc_activate_IRQ_send(u64 amos_page_pa, int from_nasid, int to_nasid,
-			int to_phys_cpuid)
+		      int to_phys_cpuid, int remote_amo, int npartitions)
 {
-	int w_index = XPC_NASID_W_INDEX(from_nasid);
-	int b_index = XPC_NASID_B_INDEX(from_nasid);
-	AMO_t *amos = (AMO_t *) __va(amos_page_pa +
-				(XPC_ACTIVATE_IRQ_AMOS * sizeof(AMO_t)));
-
-
-	(void) xpc_IPI_send(&amos[w_index], (1UL << b_index), to_nasid,
-				to_phys_cpuid, SGI_XPC_ACTIVATE);
+	enum xp_retval ret;
+	/* SN nodes are always even numbered nasids */
+	u64 *amo_va = (u64 *)__va(amos_page_pa +
+				  (xpc_activate_irq_amos(npartitions) +
+				  BIT_WORD(from_nasid/2)) * xp_sizeof_amo);
+
+	ret = xp_set_amo_with_interrupt(amo_va, XP_AMO_OR,
+					BIT_MASK(from_nasid/2),
+					remote_amo, to_nasid,
+					to_phys_cpuid, SGI_XPC_ACTIVATE);
+	BUG_ON(!remote_amo && ret != xpSuccess); /* should never happen*/
 }
 
 static inline void
 xpc_IPI_send_activate(struct xpc_vars *vars)
 {
-	xpc_activate_IRQ_send(vars->amos_page_pa, cnodeid_to_nasid(0),
-				vars->act_nasid, vars->act_phys_cpuid);
+	xpc_activate_IRQ_send(vars->amos_page_pa, xp_node_to_nasid(0),
+			      vars->act_nasid, vars->act_phys_cpuid, 1,
+			      vars->npartitions);
 }
 
 static inline void
 xpc_IPI_send_activated(struct xpc_partition *part)
 {
-	xpc_activate_IRQ_send(part->remote_amos_page_pa, cnodeid_to_nasid(0),
-			part->remote_act_nasid, part->remote_act_phys_cpuid);
+	xpc_activate_IRQ_send(part->remote_amos_page_pa, xp_node_to_nasid(0),
+			      part->remote_act_nasid,
+			      part->remote_act_phys_cpuid, 1,
+			      part->remote_npartitions);
 }
 
 static inline void
 xpc_IPI_send_reactivate(struct xpc_partition *part)
 {
 	xpc_activate_IRQ_send(xpc_vars->amos_page_pa, part->reactivate_nasid,
-				xpc_vars->act_nasid, xpc_vars->act_phys_cpuid);
+			      xpc_vars->act_nasid, xpc_vars->act_phys_cpuid, 0,
+			      xpc_vars->npartitions);
 }
 
 static inline void
 xpc_IPI_send_disengage(struct xpc_partition *part)
 {
-	xpc_activate_IRQ_send(part->remote_amos_page_pa, cnodeid_to_nasid(0),
-			part->remote_act_nasid, part->remote_act_phys_cpuid);
+	xpc_activate_IRQ_send(part->remote_amos_page_pa, xp_node_to_nasid(0),
+			      part->remote_act_nasid,
+			      part->remote_act_phys_cpuid, 1,
+			      part->remote_npartitions);
 }
 
 
@@ -1061,26 +1060,25 @@ xpc_notify_IRQ_send(struct xpc_channel *
 			unsigned long *irq_flags)
 {
 	struct xpc_partition *part = &xpc_partitions[ch->partid];
-	enum xpc_retval ret;
+	enum xp_retval ret;
+
 
+	if (unlikely(part->act_state == XPC_P_AS_DEACTIVATING))
+		return;
 
-	if (likely(part->act_state != XPC_P_DEACTIVATING)) {
-		ret = xpc_IPI_send(part->remote_IPI_amo_va,
-					(u64) ipi_flag << (ch->number * 8),
+	ret = xp_set_amo_with_interrupt(part->remote_IPI_amo_va, XP_AMO_OR,
+					((u64)ipi_flag << (ch->number * 8)), 1,
 					part->remote_IPI_nasid,
 					part->remote_IPI_phys_cpuid,
 					SGI_XPC_NOTIFY);
-		dev_dbg(xpc_chan, "%s sent to partid=%d, channel=%d, ret=%d\n",
-			ipi_flag_string, ch->partid, ch->number, ret);
-		if (unlikely(ret != xpcSuccess)) {
-			if (irq_flags != NULL) {
-				spin_unlock_irqrestore(&ch->lock, *irq_flags);
-			}
-			XPC_DEACTIVATE_PARTITION(part, ret);
-			if (irq_flags != NULL) {
-				spin_lock_irqsave(&ch->lock, *irq_flags);
-			}
-		}
+	dev_dbg(xpc_chan, "%s sent to partid=%d, channel=%d, ret=%d\n",
+		ipi_flag_string, ch->partid, ch->number, ret);
+	if (unlikely(ret != xpSuccess)) {
+		if (irq_flags != NULL)
+			spin_unlock_irqrestore(&ch->lock, *irq_flags);
+		XPC_DEACTIVATE_PARTITION(part, ret);
+		if (irq_flags != NULL)
+			spin_lock_irqsave(&ch->lock, *irq_flags);
 	}
 }
 
@@ -1097,11 +1095,14 @@ static inline void
 xpc_notify_IRQ_send_local(struct xpc_channel *ch, u8 ipi_flag,
 				char *ipi_flag_string)
 {
-	struct xpc_partition *part = &xpc_partitions[ch->partid];
+	enum xp_retval ret;
+	u64 *amo_va = xpc_partitions[ch->partid].local_IPI_amo_va;
 
+	/* set IPI flag corresponding to channel in partition's local AMO */
+	ret = xp_set_amo(amo_va, XP_AMO_OR, ((u64)ipi_flag << (ch->number * 8)),
+			 0);
+	BUG_ON(ret != xpSuccess);  /* should never happen */
 
-	FETCHOP_STORE_OP(TO_AMO((u64) &part->local_IPI_amo_va->variable),
-			FETCHOP_OR, ((u64) ipi_flag << (ch->number * 8)));
 	dev_dbg(xpc_chan, "%s sent local from partid=%d, channel=%d\n",
 		ipi_flag_string, ch->partid, ch->number);
 }
@@ -1126,8 +1127,8 @@ xpc_notify_IRQ_send_local(struct xpc_cha
 #define XPC_GET_IPI_FLAGS(_amo, _c)	((u8) (((_amo) >> ((_c) * 8)) & 0xff))
 #define XPC_SET_IPI_FLAGS(_amo, _c, _f)	(_amo) |= ((u64) (_f) << ((_c) * 8))
 
-#define	XPC_ANY_OPENCLOSE_IPI_FLAGS_SET(_amo) ((_amo) & __IA64_UL_CONST(0x0f0f0f0f0f0f0f0f))
-#define XPC_ANY_MSG_IPI_FLAGS_SET(_amo)       ((_amo) & __IA64_UL_CONST(0x1010101010101010))
+#define	XPC_ANY_OPENCLOSE_IPI_FLAGS_SET(_amo) ((_amo) & 0x0f0f0f0f0f0f0f0fUL)
+#define XPC_ANY_MSG_IPI_FLAGS_SET(_amo)       ((_amo) & 0x1010101010101010UL)
 
 
 static inline void
@@ -1185,53 +1186,16 @@ xpc_IPI_send_local_msgrequest(struct xpc
 }
 
 
-/*
- * Memory for XPC's AMO variables is allocated by the MSPEC driver. These
- * pages are located in the lowest granule. The lowest granule uses 4k pages
- * for cached references and an alternate TLB handler to never provide a
- * cacheable mapping for the entire region. This will prevent speculative
- * reading of cached copies of our lines from being issued which will cause
- * a PI FSB Protocol error to be generated by the SHUB. For XPC, we need 64
- * AMO variables (based on XP_MAX_PARTITIONS) for message notification and an
- * additional 128 AMO variables (based on XP_NASID_MASK_WORDS) for partition
- * activation and 2 AMO variables for partition deactivation.
- */
-static inline AMO_t *
+static inline u64 *
 xpc_IPI_init(int index)
 {
-	AMO_t *amo = xpc_vars->amos_page + index;
-
-
-	(void) xpc_IPI_receive(amo);	/* clear AMO variable */
-	return amo;
-}
-
-
-
-static inline enum xpc_retval
-xpc_map_bte_errors(bte_result_t error)
-{
-	if (error == BTE_SUCCESS)
-		return xpcSuccess;
-
-	if (is_shub2()) {
-		if (BTE_VALID_SH2_ERROR(error))
-			return xpcBteSh2Start + error;
-		return xpcBteUnmappedError;
-	}
-	switch (error) {
-	case BTE_SUCCESS:	return xpcSuccess;
-	case BTEFAIL_DIR:	return xpcBteDirectoryError;
-	case BTEFAIL_POISON:	return xpcBtePoisonError;
-	case BTEFAIL_WERR:	return xpcBteWriteError;
-	case BTEFAIL_ACCESS:	return xpcBteAccessError;
-	case BTEFAIL_PWERR:	return xpcBtePWriteError;
-	case BTEFAIL_PRERR:	return xpcBtePReadError;
-	case BTEFAIL_TOUT:	return xpcBteTimeOutError;
-	case BTEFAIL_XTERR:	return xpcBteXtalkError;
-	case BTEFAIL_NOTAVAIL:	return xpcBteNotAvailable;
-	default:		return xpcBteUnmappedError;
-	}
+	enum xp_retval ret;
+	u64 *amo_va = (u64 *)((u64)xpc_vars->amos_page + index *
+				xp_sizeof_amo);
+
+	ret = xp_get_amo(amo_va, XP_AMO_CLEAR, NULL);
+	BUG_ON(ret != xpSuccess);  /* should never happen */
+	return amo_va;
 }
 
 
@@ -1243,11 +1207,13 @@ xpc_map_bte_errors(bte_result_t error)
 static inline void
 xpc_check_for_channel_activity(struct xpc_partition *part)
 {
+	enum xp_retval ret;
 	u64 IPI_amo;
 	unsigned long irq_flags;
 
 
-	IPI_amo = xpc_IPI_receive(part->local_IPI_amo_va);
+	ret = xp_get_amo(part->local_IPI_amo_va, XP_AMO_CLEAR, &IPI_amo);
+	BUG_ON(ret != xpSuccess);  /* should never happen */
 	if (IPI_amo == 0) {
 		return;
 	}
@@ -1256,12 +1222,12 @@ xpc_check_for_channel_activity(struct xp
 	part->local_IPI_amo |= IPI_amo;
 	spin_unlock_irqrestore(&part->IPI_lock, irq_flags);
 
-	dev_dbg(xpc_chan, "received IPI from partid=%d, IPI_amo=0x%lx\n",
-		XPC_PARTID(part), IPI_amo);
+	dev_dbg(xpc_chan, "received IPI from partid=%d, IPI_amo=0x%" U64_ELL
+		"x\n", XPC_PARTID(part), IPI_amo);
 
 	xpc_wakeup_channel_mgr(part);
 }
 
 
-#endif /* _ASM_IA64_SN_XPC_H */
+#endif /* _DRIVERS_MISC_XP_XPC_H */
 
Index: linux-2.6/drivers/misc/xp/xpc_channel.c
===================================================================
--- linux-2.6.orig/drivers/misc/xp/xpc_channel.c	2008-03-26 10:40:03.160341945 -0500
+++ linux-2.6/drivers/misc/xp/xpc_channel.c	2008-03-26 10:41:46.712957569 -0500
@@ -3,7 +3,7 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  *
- * Copyright (c) 2004-2006 Silicon Graphics, Inc.  All Rights Reserved.
+ * Copyright (c) 2004-2008 Silicon Graphics, Inc.  All Rights Reserved.
  */
 
 
@@ -23,9 +23,11 @@
 #include <linux/interrupt.h>
 #include <linux/mutex.h>
 #include <linux/completion.h>
-#include <asm/sn/bte.h>
-#include <asm/sn/sn_sal.h>
-#include <asm/sn/xpc.h>
+#include "xpc.h"
+
+#ifdef CONFIG_X86_64
+#define cmpxchg_rel(ptr,o,n)	cmpxchg(ptr,o,n)
+#endif
 
 
 /*
@@ -57,7 +59,7 @@ xpc_kzalloc_cacheline_aligned(size_t siz
  * Set up the initial values for the XPartition Communication channels.
  */
 static void
-xpc_initialize_channels(struct xpc_partition *part, partid_t partid)
+xpc_initialize_channels(struct xpc_partition *part, short partid)
 {
 	int ch_number;
 	struct xpc_channel *ch;
@@ -96,12 +98,12 @@ xpc_initialize_channels(struct xpc_parti
  * Setup the infrastructure necessary to support XPartition Communication
  * between the specified remote partition and the local one.
  */
-enum xpc_retval
+enum xp_retval
 xpc_setup_infrastructure(struct xpc_partition *part)
 {
 	int ret, cpuid;
 	struct timer_list *timer;
-	partid_t partid = XPC_PARTID(part);
+	short partid = XPC_PARTID(part);
 
 
 	/*
@@ -121,7 +123,7 @@ xpc_setup_infrastructure(struct xpc_part
 								GFP_KERNEL);
 	if (part->channels == NULL) {
 		dev_err(xpc_chan, "can't get memory for channels\n");
-		return xpcNoMemory;
+		return xpNoMemory;
 	}
 
 	part->nchannels = XPC_NCHANNELS;
@@ -136,7 +138,7 @@ xpc_setup_infrastructure(struct xpc_part
 		part->channels = NULL;
 		dev_err(xpc_chan, "can't get memory for local get/put "
 			"values\n");
-		return xpcNoMemory;
+		return xpNoMemory;
 	}
 
 	part->remote_GPs = xpc_kzalloc_cacheline_aligned(XPC_GP_SIZE,
@@ -148,7 +150,7 @@ xpc_setup_infrastructure(struct xpc_part
 		part->local_GPs = NULL;
 		kfree(part->channels);
 		part->channels = NULL;
-		return xpcNoMemory;
+		return xpNoMemory;
 	}
 
 
@@ -165,7 +167,7 @@ xpc_setup_infrastructure(struct xpc_part
 		part->local_GPs = NULL;
 		kfree(part->channels);
 		part->channels = NULL;
-		return xpcNoMemory;
+		return xpNoMemory;
 	}
 
 	part->remote_openclose_args = xpc_kzalloc_cacheline_aligned(
@@ -181,7 +183,7 @@ xpc_setup_infrastructure(struct xpc_part
 		part->local_GPs = NULL;
 		kfree(part->channels);
 		part->channels = NULL;
-		return xpcNoMemory;
+		return xpNoMemory;
 	}
 
 
@@ -193,8 +195,8 @@ xpc_setup_infrastructure(struct xpc_part
 
 	/* local_IPI_amo were set to 0 by an earlier memset() */
 
-	/* Initialize this partitions AMO_t structure */
-	part->local_IPI_amo_va = xpc_IPI_init(partid);
+	/* Initialize this partitions AMO structure */
+	part->local_IPI_amo_va = xpc_IPI_init(xpc_notify_irq_amos() + partid);
 
 	spin_lock_init(&part->IPI_lock);
 
@@ -217,7 +219,7 @@ xpc_setup_infrastructure(struct xpc_part
 		part->local_GPs = NULL;
 		kfree(part->channels);
 		part->channels = NULL;
-		return xpcLackOfResources;
+		return xpLackOfResources;
 	}
 
 	/* Setup a timer to check for dropped IPIs */
@@ -225,14 +227,14 @@ xpc_setup_infrastructure(struct xpc_part
 	init_timer(timer);
 	timer->function = (void (*)(unsigned long)) xpc_dropped_IPI_check;
 	timer->data = (unsigned long) part;
-	timer->expires = jiffies + XPC_P_DROPPED_IPI_WAIT;
+	timer->expires = jiffies + XPC_DROPPED_IPI_WAIT_INTERVAL;
 	add_timer(timer);
 
 	/*
-	 * With the setting of the partition setup_state to XPC_P_SETUP, we're
-	 * declaring that this partition is ready to go.
+	 * With the setting of the partition setup_state to XPC_P_SS_SETUP,
+	 * we're declaring that this partition is ready to go.
 	 */
-	part->setup_state = XPC_P_SETUP;
+	part->setup_state = XPC_P_SS_SETUP;
 
 
 	/*
@@ -247,12 +249,12 @@ xpc_setup_infrastructure(struct xpc_part
 					__pa(part->local_openclose_args);
 	xpc_vars_part[partid].IPI_amo_pa = __pa(part->local_IPI_amo_va);
 	cpuid = raw_smp_processor_id();	/* any CPU in this partition will do */
-	xpc_vars_part[partid].IPI_nasid = cpuid_to_nasid(cpuid);
+	xpc_vars_part[partid].IPI_nasid = xp_cpu_to_nasid(cpuid);
 	xpc_vars_part[partid].IPI_phys_cpuid = cpu_physical_id(cpuid);
 	xpc_vars_part[partid].nchannels = part->nchannels;
 	xpc_vars_part[partid].magic = XPC_VP_MAGIC1;
 
-	return xpcSuccess;
+	return xpSuccess;
 }
 
 
@@ -260,35 +262,32 @@ xpc_setup_infrastructure(struct xpc_part
  * Create a wrapper that hides the underlying mechanism for pulling a cacheline
  * (or multiple cachelines) from a remote partition.
  *
- * src must be a cacheline aligned physical address on the remote partition.
- * dst must be a cacheline aligned virtual address on this partition.
- * cnt must be an cacheline sized
+ * src must be a cacheline-aligned physical address on the remote partition.
+ * dst must be a cacheline-aligned virtual address on this partition.
+ * cnt must be cacheline sized
  */
-static enum xpc_retval
+static enum xp_retval
 xpc_pull_remote_cachelines(struct xpc_partition *part, void *dst,
 				const void *src, size_t cnt)
 {
-	bte_result_t bte_ret;
+	enum xp_retval ret;
 
 
 	DBUG_ON((u64) src != L1_CACHE_ALIGN((u64) src));
 	DBUG_ON((u64) dst != L1_CACHE_ALIGN((u64) dst));
 	DBUG_ON(cnt != L1_CACHE_ALIGN(cnt));
 
-	if (part->act_state == XPC_P_DEACTIVATING) {
+	if (part->act_state == XPC_P_AS_DEACTIVATING) {
 		return part->reason;
 	}
 
-	bte_ret = xp_bte_copy((u64) src, (u64) dst, (u64) cnt,
-					(BTE_NORMAL | BTE_WACQUIRE), NULL);
-	if (bte_ret == BTE_SUCCESS) {
-		return xpcSuccess;
+	ret = xp_remote_memcpy(dst, src, cnt);
+	if (ret != xpSuccess) {
+		dev_dbg(xpc_chan, "xp_remote_memcpy() from partition %d failed,"
+			" ret=%d\n", XPC_PARTID(part), ret);
 	}
 
-	dev_dbg(xpc_chan, "xp_bte_copy() from partition %d failed, ret=%d\n",
-		XPC_PARTID(part), bte_ret);
-
-	return xpc_map_bte_errors(bte_ret);
+	return ret;
 }
 
 
@@ -296,7 +295,7 @@ xpc_pull_remote_cachelines(struct xpc_pa
  * Pull the remote per partition specific variables from the specified
  * partition.
  */
-enum xpc_retval
+enum xp_retval
 xpc_pull_remote_vars_part(struct xpc_partition *part)
 {
 	u8 buffer[L1_CACHE_BYTES * 2];
@@ -304,8 +303,8 @@ xpc_pull_remote_vars_part(struct xpc_par
 			(struct xpc_vars_part *) L1_CACHE_ALIGN((u64) buffer);
 	struct xpc_vars_part *pulled_entry;
 	u64 remote_entry_cacheline_pa, remote_entry_pa;
-	partid_t partid = XPC_PARTID(part);
-	enum xpc_retval ret;
+	short partid = XPC_PARTID(part);
+	enum xp_retval ret;
 
 
 	/* pull the cacheline that contains the variables we're interested in */
@@ -315,7 +314,7 @@ xpc_pull_remote_vars_part(struct xpc_par
 	DBUG_ON(sizeof(struct xpc_vars_part) != L1_CACHE_BYTES / 2);
 
 	remote_entry_pa = part->remote_vars_part_pa +
-			sn_partition_id * sizeof(struct xpc_vars_part);
+			xp_partition_id * sizeof(struct xpc_vars_part);
 
 	remote_entry_cacheline_pa = (remote_entry_pa & ~(L1_CACHE_BYTES - 1));
 
@@ -325,7 +324,7 @@ xpc_pull_remote_vars_part(struct xpc_par
 	ret = xpc_pull_remote_cachelines(part, pulled_entry_cacheline,
 					(void *) remote_entry_cacheline_pa,
 					L1_CACHE_BYTES);
-	if (ret != xpcSuccess) {
+	if (ret != xpSuccess) {
 		dev_dbg(xpc_chan, "failed to pull XPC vars_part from "
 			"partition %d, ret=%d\n", partid, ret);
 		return ret;
@@ -339,13 +338,14 @@ xpc_pull_remote_vars_part(struct xpc_par
 
 		if (pulled_entry->magic != 0) {
 			dev_dbg(xpc_chan, "partition %d's XPC vars_part for "
-				"partition %d has bad magic value (=0x%lx)\n",
-				partid, sn_partition_id, pulled_entry->magic);
-			return xpcBadMagic;
+				"partition %d has bad magic value (=0x%"
+				U64_ELL "x)\n", partid, xp_partition_id,
+				pulled_entry->magic);
+			return xpBadMagic;
 		}
 
 		/* they've not been initialized yet */
-		return xpcRetry;
+		return xpRetry;
 	}
 
 	if (xpc_vars_part[partid].magic == XPC_VP_MAGIC1) {
@@ -358,8 +358,8 @@ xpc_pull_remote_vars_part(struct xpc_par
 
 			dev_err(xpc_chan, "partition %d's XPC vars_part for "
 				"partition %d are not valid\n", partid,
-				sn_partition_id);
-			return xpcInvalidAddress;
+				xp_partition_id);
+			return xpInvalidAddress;
 		}
 
 		/* the variables we imported look to be valid */
@@ -367,8 +367,7 @@ xpc_pull_remote_vars_part(struct xpc_par
 		part->remote_GPs_pa = pulled_entry->GPs_pa;
 		part->remote_openclose_args_pa =
 					pulled_entry->openclose_args_pa;
-		part->remote_IPI_amo_va =
-				      (AMO_t *) __va(pulled_entry->IPI_amo_pa);
+		part->remote_IPI_amo_va = __va(pulled_entry->IPI_amo_pa);
 		part->remote_IPI_nasid = pulled_entry->IPI_nasid;
 		part->remote_IPI_phys_cpuid = pulled_entry->IPI_phys_cpuid;
 
@@ -382,10 +381,10 @@ xpc_pull_remote_vars_part(struct xpc_par
 	}
 
 	if (pulled_entry->magic == XPC_VP_MAGIC1) {
-		return xpcRetry;
+		return xpRetry;
 	}
 
-	return xpcSuccess;
+	return xpSuccess;
 }
 
 
@@ -397,7 +396,7 @@ xpc_get_IPI_flags(struct xpc_partition *
 {
 	unsigned long irq_flags;
 	u64 IPI_amo;
-	enum xpc_retval ret;
+	enum xp_retval ret;
 
 
 	/*
@@ -416,7 +415,7 @@ xpc_get_IPI_flags(struct xpc_partition *
 					part->remote_openclose_args,
 					(void *) part->remote_openclose_args_pa,
 					XPC_OPENCLOSE_ARGS_SIZE);
-		if (ret != xpcSuccess) {
+		if (ret != xpSuccess) {
 			XPC_DEACTIVATE_PARTITION(part, ret);
 
 			dev_dbg(xpc_chan, "failed to pull openclose args from "
@@ -432,7 +431,7 @@ xpc_get_IPI_flags(struct xpc_partition *
 		ret = xpc_pull_remote_cachelines(part, part->remote_GPs,
 						(void *) part->remote_GPs_pa,
 						XPC_GP_SIZE);
-		if (ret != xpcSuccess) {
+		if (ret != xpSuccess) {
 			XPC_DEACTIVATE_PARTITION(part, ret);
 
 			dev_dbg(xpc_chan, "failed to pull GPs from partition "
@@ -450,18 +449,13 @@ xpc_get_IPI_flags(struct xpc_partition *
 /*
  * Allocate the local message queue and the notify queue.
  */
-static enum xpc_retval
+static enum xp_retval
 xpc_allocate_local_msgqueue(struct xpc_channel *ch)
 {
 	unsigned long irq_flags;
 	int nentries;
 	size_t nbytes;
 
-
-	// >>> may want to check for ch->flags & XPC_C_DISCONNECTING between
-	// >>> iterations of the for-loop, bail if set?
-
-	// >>> should we impose a minimum #of entries? like 4 or 8?
 	for (nentries = ch->local_nentries; nentries > 0; nentries--) {
 
 		nbytes = nentries * ch->msg_size;
@@ -489,19 +483,19 @@ xpc_allocate_local_msgqueue(struct xpc_c
 			ch->local_nentries = nentries;
 		}
 		spin_unlock_irqrestore(&ch->lock, irq_flags);
-		return xpcSuccess;
+		return xpSuccess;
 	}
 
 	dev_dbg(xpc_chan, "can't get memory for local message queue and notify "
 		"queue, partid=%d, channel=%d\n", ch->partid, ch->number);
-	return xpcNoMemory;
+	return xpNoMemory;
 }
 
 
 /*
  * Allocate the cached remote message queue.
  */
-static enum xpc_retval
+static enum xp_retval
 xpc_allocate_remote_msgqueue(struct xpc_channel *ch)
 {
 	unsigned long irq_flags;
@@ -511,10 +505,6 @@ xpc_allocate_remote_msgqueue(struct xpc_
 
 	DBUG_ON(ch->remote_nentries <= 0);
 
-	// >>> may want to check for ch->flags & XPC_C_DISCONNECTING between
-	// >>> iterations of the for-loop, bail if set?
-
-	// >>> should we impose a minimum #of entries? like 4 or 8?
 	for (nentries = ch->remote_nentries; nentries > 0; nentries--) {
 
 		nbytes = nentries * ch->msg_size;
@@ -534,12 +524,12 @@ xpc_allocate_remote_msgqueue(struct xpc_
 			ch->remote_nentries = nentries;
 		}
 		spin_unlock_irqrestore(&ch->lock, irq_flags);
-		return xpcSuccess;
+		return xpSuccess;
 	}
 
 	dev_dbg(xpc_chan, "can't get memory for cached remote message queue, "
 		"partid=%d, channel=%d\n", ch->partid, ch->number);
-	return xpcNoMemory;
+	return xpNoMemory;
 }
 
 
@@ -548,20 +538,20 @@ xpc_allocate_remote_msgqueue(struct xpc_
  *
  * Note: Assumes all of the channel sizes are filled in.
  */
-static enum xpc_retval
+static enum xp_retval
 xpc_allocate_msgqueues(struct xpc_channel *ch)
 {
 	unsigned long irq_flags;
-	enum xpc_retval ret;
+	enum xp_retval ret;
 
 
 	DBUG_ON(ch->flags & XPC_C_SETUP);
 
-	if ((ret = xpc_allocate_local_msgqueue(ch)) != xpcSuccess) {
+	if ((ret = xpc_allocate_local_msgqueue(ch)) != xpSuccess) {
 		return ret;
 	}
 
-	if ((ret = xpc_allocate_remote_msgqueue(ch)) != xpcSuccess) {
+	if ((ret = xpc_allocate_remote_msgqueue(ch)) != xpSuccess) {
 		kfree(ch->local_msgqueue_base);
 		ch->local_msgqueue = NULL;
 		kfree(ch->notify_queue);
@@ -573,7 +563,7 @@ xpc_allocate_msgqueues(struct xpc_channe
 	ch->flags |= XPC_C_SETUP;
 	spin_unlock_irqrestore(&ch->lock, irq_flags);
 
-	return xpcSuccess;
+	return xpSuccess;
 }
 
 
@@ -586,7 +576,7 @@ xpc_allocate_msgqueues(struct xpc_channe
 static void
 xpc_process_connect(struct xpc_channel *ch, unsigned long *irq_flags)
 {
-	enum xpc_retval ret;
+	enum xp_retval ret;
 
 
 	DBUG_ON(!spin_is_locked(&ch->lock));
@@ -603,7 +593,7 @@ xpc_process_connect(struct xpc_channel *
 		ret = xpc_allocate_msgqueues(ch);
 		spin_lock_irqsave(&ch->lock, *irq_flags);
 
-		if (ret != xpcSuccess) {
+		if (ret != xpSuccess) {
 			XPC_DISCONNECT_CHANNEL(ch, ret, irq_flags);
 		}
 		if (ch->flags & (XPC_C_CONNECTED | XPC_C_DISCONNECTING)) {
@@ -641,7 +631,7 @@ xpc_process_connect(struct xpc_channel *
  * Notify those who wanted to be notified upon delivery of their message.
  */
 static void
-xpc_notify_senders(struct xpc_channel *ch, enum xpc_retval reason, s64 put)
+xpc_notify_senders(struct xpc_channel *ch, enum xp_retval reason, s64 put)
 {
 	struct xpc_notify *notify;
 	u8 notify_type;
@@ -671,16 +661,17 @@ xpc_notify_senders(struct xpc_channel *c
 
 		if (notify->func != NULL) {
 			dev_dbg(xpc_chan, "notify->func() called, notify=0x%p, "
-				"msg_number=%ld, partid=%d, channel=%d\n",
-				(void *) notify, get, ch->partid, ch->number);
+				"msg_number=%" U64_ELL "d, partid=%d, "
+				"channel=%d\n", (void *) notify, get,
+				ch->partid, ch->number);
 
 			notify->func(reason, ch->partid, ch->number,
 								notify->key);
 
 			dev_dbg(xpc_chan, "notify->func() returned, "
-				"notify=0x%p, msg_number=%ld, partid=%d, "
-				"channel=%d\n", (void *) notify, get,
-				ch->partid, ch->number);
+				"notify=0x%p, msg_number=%" U64_ELL "d, "
+				"partid=%d, channel=%d\n", (void *) notify,
+				get, ch->partid, ch->number);
 		}
 	}
 }
@@ -761,9 +752,9 @@ xpc_process_disconnect(struct xpc_channe
 	DBUG_ON((ch->flags & XPC_C_CONNECTEDCALLOUT_MADE) &&
 			!(ch->flags & XPC_C_DISCONNECTINGCALLOUT_MADE));
 
-	if (part->act_state == XPC_P_DEACTIVATING) {
+	if (part->act_state == XPC_P_AS_DEACTIVATING) {
 		/* can't proceed until the other side disengages from us */
-		if (xpc_partition_engaged(1UL << ch->partid)) {
+		if (xpc_partition_engaged(ch->partid)) {
 			return;
 		}
 
@@ -795,7 +786,7 @@ xpc_process_disconnect(struct xpc_channe
 
 	if (ch->flags & XPC_C_DISCONNECTINGCALLOUT_MADE) {
 		spin_unlock_irqrestore(&ch->lock, *irq_flags);
-		xpc_disconnect_callout(ch, xpcDisconnected);
+		xpc_disconnect_callout(ch, xpDisconnected);
 		spin_lock_irqsave(&ch->lock, *irq_flags);
 	}
 
@@ -816,7 +807,7 @@ xpc_process_disconnect(struct xpc_channe
 		/* we won't lose the CPU since we're holding ch->lock */
 		complete(&ch->wdisconnect_wait);
 	} else if (ch->delayed_IPI_flags) {
-		if (part->act_state != XPC_P_DEACTIVATING) {
+		if (part->act_state != XPC_P_AS_DEACTIVATING) {
 			/* time to take action on any delayed IPI flags */
 			spin_lock(&part->IPI_lock);
 			XPC_SET_IPI_FLAGS(part->local_IPI_amo, ch->number,
@@ -839,7 +830,7 @@ xpc_process_openclose_IPI(struct xpc_par
 	struct xpc_openclose_args *args =
 				&part->remote_openclose_args[ch_number];
 	struct xpc_channel *ch = &part->channels[ch_number];
-	enum xpc_retval reason;
+	enum xp_retval reason;
 
 
 
@@ -921,10 +912,10 @@ again:
 
 		if (!(ch->flags & XPC_C_DISCONNECTING)) {
 			reason = args->reason;
-			if (reason <= xpcSuccess || reason > xpcUnknownReason) {
-				reason = xpcUnknownReason;
-			} else if (reason == xpcUnregistering) {
-				reason = xpcOtherUnregistering;
+			if (reason <= xpSuccess || reason > xpUnknownReason) {
+				reason = xpUnknownReason;
+			} else if (reason == xpUnregistering) {
+				reason = xpOtherUnregistering;
 			}
 
 			XPC_DISCONNECT_CHANNEL(ch, reason, &irq_flags);
@@ -944,7 +935,7 @@ again:
 			" channel=%d\n", ch->partid, ch->number);
 
 		if (ch->flags & XPC_C_DISCONNECTED) {
-			DBUG_ON(part->act_state != XPC_P_DEACTIVATING);
+			DBUG_ON(part->act_state != XPC_P_AS_DEACTIVATING);
 			spin_unlock_irqrestore(&ch->lock, irq_flags);
 			return;
 		}
@@ -981,7 +972,7 @@ again:
 			"channel=%d\n", args->msg_size, args->local_nentries,
 			ch->partid, ch->number);
 
-		if (part->act_state == XPC_P_DEACTIVATING ||
+		if (part->act_state == XPC_P_AS_DEACTIVATING ||
 					(ch->flags & XPC_C_ROPENREQUEST)) {
 			spin_unlock_irqrestore(&ch->lock, irq_flags);
 			return;
@@ -1014,7 +1005,7 @@ again:
 
 		if (ch->flags & XPC_C_OPENREQUEST) {
 			if (args->msg_size != ch->msg_size) {
-				XPC_DISCONNECT_CHANNEL(ch, xpcUnequalMsgSizes,
+				XPC_DISCONNECT_CHANNEL(ch, xpUnequalMsgSizes,
 								&irq_flags);
 				spin_unlock_irqrestore(&ch->lock, irq_flags);
 				return;
@@ -1034,18 +1025,18 @@ again:
 
 	if (IPI_flags & XPC_IPI_OPENREPLY) {
 
-		dev_dbg(xpc_chan, "XPC_IPI_OPENREPLY (local_msgqueue_pa=0x%lx, "
-			"local_nentries=%d, remote_nentries=%d) received from "
-			"partid=%d, channel=%d\n", args->local_msgqueue_pa,
-			args->local_nentries, args->remote_nentries,
-			ch->partid, ch->number);
+		dev_dbg(xpc_chan, "XPC_IPI_OPENREPLY (local_msgqueue_pa=0x%"
+			U64_ELL "x, local_nentries=%d, remote_nentries=%d) "
+			"received from partid=%d, channel=%d\n",
+			args->local_msgqueue_pa, args->local_nentries,
+			args->remote_nentries, ch->partid, ch->number);
 
 		if (ch->flags & (XPC_C_DISCONNECTING | XPC_C_DISCONNECTED)) {
 			spin_unlock_irqrestore(&ch->lock, irq_flags);
 			return;
 		}
 		if (!(ch->flags & XPC_C_OPENREQUEST)) {
-			XPC_DISCONNECT_CHANNEL(ch, xpcOpenCloseError,
+			XPC_DISCONNECT_CHANNEL(ch, xpOpenCloseError,
 								&irq_flags);
 			spin_unlock_irqrestore(&ch->lock, irq_flags);
 			return;
@@ -1097,7 +1088,7 @@ again:
 /*
  * Attempt to establish a channel connection to a remote partition.
  */
-static enum xpc_retval
+static enum xp_retval
 xpc_connect_channel(struct xpc_channel *ch)
 {
 	unsigned long irq_flags;
@@ -1105,12 +1096,12 @@ xpc_connect_channel(struct xpc_channel *
 
 
 	if (mutex_trylock(&registration->mutex) == 0) {
-		return xpcRetry;
+		return xpRetry;
 	}
 
 	if (!XPC_CHANNEL_REGISTERED(ch->number)) {
 		mutex_unlock(&registration->mutex);
-		return xpcUnregistered;
+		return xpUnregistered;
 	}
 
 	spin_lock_irqsave(&ch->lock, irq_flags);
@@ -1153,10 +1144,10 @@ xpc_connect_channel(struct xpc_channel *
 			 * the channel lock as needed.
 			 */
 			mutex_unlock(&registration->mutex);
-			XPC_DISCONNECT_CHANNEL(ch, xpcUnequalMsgSizes,
+			XPC_DISCONNECT_CHANNEL(ch, xpUnequalMsgSizes,
 								&irq_flags);
 			spin_unlock_irqrestore(&ch->lock, irq_flags);
-			return xpcUnequalMsgSizes;
+			return xpUnequalMsgSizes;
 		}
 	} else {
 		ch->msg_size = registration->msg_size;
@@ -1179,7 +1170,7 @@ xpc_connect_channel(struct xpc_channel *
 
 	spin_unlock_irqrestore(&ch->lock, irq_flags);
 
-	return xpcSuccess;
+	return xpSuccess;
 }
 
 
@@ -1268,7 +1259,7 @@ xpc_process_msg_IPI(struct xpc_partition
 			 * Notify senders that messages sent have been
 			 * received and delivered by the other side.
 			 */
-			xpc_notify_senders(ch, xpcMsgDelivered,
+			xpc_notify_senders(ch, xpMsgDelivered,
 							ch->remote_GP.get);
 		}
 
@@ -1280,9 +1271,9 @@ xpc_process_msg_IPI(struct xpc_partition
 
 		ch->w_remote_GP.get = ch->remote_GP.get;
 
-		dev_dbg(xpc_chan, "w_remote_GP.get changed to %ld, partid=%d, "
-			"channel=%d\n", ch->w_remote_GP.get, ch->partid,
-			ch->number);
+		dev_dbg(xpc_chan, "w_remote_GP.get changed to %" U64_ELL "d, "
+			"partid=%d, channel=%d\n", ch->w_remote_GP.get,
+			ch->partid, ch->number);
 
 		/*
 		 * If anyone was waiting for message queue entries to become
@@ -1308,9 +1299,9 @@ xpc_process_msg_IPI(struct xpc_partition
 
 		ch->w_remote_GP.put = ch->remote_GP.put;
 
-		dev_dbg(xpc_chan, "w_remote_GP.put changed to %ld, partid=%d, "
-			"channel=%d\n", ch->w_remote_GP.put, ch->partid,
-			ch->number);
+		dev_dbg(xpc_chan, "w_remote_GP.put changed to %" U64_ELL "d, "
+			"partid=%d, channel=%d\n", ch->w_remote_GP.put,
+			ch->partid, ch->number);
 
 		nmsgs_sent = ch->w_remote_GP.put - ch->w_local_GP.get;
 		if (nmsgs_sent > 0) {
@@ -1371,7 +1362,7 @@ xpc_process_channel_activity(struct xpc_
 			continue;
 		}
 
-		if (part->act_state == XPC_P_DEACTIVATING) {
+		if (part->act_state == XPC_P_AS_DEACTIVATING) {
 			continue;
 		}
 
@@ -1411,7 +1402,7 @@ xpc_process_channel_activity(struct xpc_
  * at the same time.
  */
 void
-xpc_partition_going_down(struct xpc_partition *part, enum xpc_retval reason)
+xpc_partition_going_down(struct xpc_partition *part, enum xp_retval reason)
 {
 	unsigned long irq_flags;
 	int ch_number;
@@ -1454,7 +1445,7 @@ xpc_partition_going_down(struct xpc_part
 void
 xpc_teardown_infrastructure(struct xpc_partition *part)
 {
-	partid_t partid = XPC_PARTID(part);
+	short partid = XPC_PARTID(part);
 
 
 	/*
@@ -1468,8 +1459,8 @@ xpc_teardown_infrastructure(struct xpc_p
 
 	DBUG_ON(atomic_read(&part->nchannels_engaged) != 0);
 	DBUG_ON(atomic_read(&part->nchannels_active) != 0);
-	DBUG_ON(part->setup_state != XPC_P_SETUP);
-	part->setup_state = XPC_P_WTEARDOWN;
+	DBUG_ON(part->setup_state != XPC_P_SS_SETUP);
+	part->setup_state = XPC_P_SS_WTEARDOWN;
 
 	xpc_vars_part[partid].magic = 0;
 
@@ -1486,7 +1477,7 @@ xpc_teardown_infrastructure(struct xpc_p
 
 	/* now we can begin tearing down the infrastructure */
 
-	part->setup_state = XPC_P_TORNDOWN;
+	part->setup_state = XPC_P_SS_TORNDOWN;
 
 	/* in case we've still got outstanding timers registered... */
 	del_timer_sync(&part->dropped_IPI_timer);
@@ -1512,14 +1503,14 @@ xpc_teardown_infrastructure(struct xpc_p
 void
 xpc_initiate_connect(int ch_number)
 {
-	partid_t partid;
+	short partid;
 	struct xpc_partition *part;
 	struct xpc_channel *ch;
 
 
 	DBUG_ON(ch_number < 0 || ch_number >= XPC_NCHANNELS);
 
-	for (partid = 1; partid < XP_MAX_PARTITIONS; partid++) {
+	for (partid = XP_MIN_PARTID; partid <= XP_MAX_PARTID; partid++) {
 		part = &xpc_partitions[partid];
 
 		if (xpc_part_ref(part)) {
@@ -1542,13 +1533,13 @@ xpc_connected_callout(struct xpc_channel
 	/* let the registerer know that a connection has been established */
 
 	if (ch->func != NULL) {
-		dev_dbg(xpc_chan, "ch->func() called, reason=xpcConnected, "
+		dev_dbg(xpc_chan, "ch->func() called, reason=xpConnected, "
 			"partid=%d, channel=%d\n", ch->partid, ch->number);
 
-		ch->func(xpcConnected, ch->partid, ch->number,
+		ch->func(xpConnected, ch->partid, ch->number,
 				(void *) (u64) ch->local_nentries, ch->key);
 
-		dev_dbg(xpc_chan, "ch->func() returned, reason=xpcConnected, "
+		dev_dbg(xpc_chan, "ch->func() returned, reason=xpConnected, "
 			"partid=%d, channel=%d\n", ch->partid, ch->number);
 	}
 }
@@ -1571,7 +1562,7 @@ void
 xpc_initiate_disconnect(int ch_number)
 {
 	unsigned long irq_flags;
-	partid_t partid;
+	short partid;
 	struct xpc_partition *part;
 	struct xpc_channel *ch;
 
@@ -1579,7 +1570,7 @@ xpc_initiate_disconnect(int ch_number)
 	DBUG_ON(ch_number < 0 || ch_number >= XPC_NCHANNELS);
 
 	/* initiate the channel disconnect for every active partition */
-	for (partid = 1; partid < XP_MAX_PARTITIONS; partid++) {
+	for (partid = XP_MIN_PARTID; partid <= XP_MAX_PARTID; partid++) {
 		part = &xpc_partitions[partid];
 
 		if (xpc_part_ref(part)) {
@@ -1591,7 +1582,7 @@ xpc_initiate_disconnect(int ch_number)
 			if (!(ch->flags & XPC_C_DISCONNECTED)) {
 				ch->flags |= XPC_C_WDISCONNECT;
 
-				XPC_DISCONNECT_CHANNEL(ch, xpcUnregistering,
+				XPC_DISCONNECT_CHANNEL(ch, xpUnregistering,
 								&irq_flags);
 			}
 
@@ -1617,7 +1608,7 @@ xpc_initiate_disconnect(int ch_number)
  */
 void
 xpc_disconnect_channel(const int line, struct xpc_channel *ch,
-			enum xpc_retval reason, unsigned long *irq_flags)
+			enum xp_retval reason, unsigned long *irq_flags)
 {
 	u32 channel_was_connected = (ch->flags & XPC_C_CONNECTED);
 
@@ -1654,7 +1645,7 @@ xpc_disconnect_channel(const int line, s
 
 	} else if ((ch->flags & XPC_C_CONNECTEDCALLOUT_MADE) &&
 			!(ch->flags & XPC_C_DISCONNECTINGCALLOUT)) {
-		/* start a kthread that will do the xpcDisconnecting callout */
+		/* start a kthread that will do the xpDisconnecting callout */
 		xpc_create_kthreads(ch, 1, 1);
 	}
 
@@ -1668,7 +1659,7 @@ xpc_disconnect_channel(const int line, s
 
 
 void
-xpc_disconnect_callout(struct xpc_channel *ch, enum xpc_retval reason)
+xpc_disconnect_callout(struct xpc_channel *ch, enum xp_retval reason)
 {
 	/*
 	 * Let the channel's registerer know that the channel is being
@@ -1692,14 +1683,14 @@ xpc_disconnect_callout(struct xpc_channe
  * Wait for a message entry to become available for the specified channel,
  * but don't wait any longer than 1 jiffy.
  */
-static enum xpc_retval
+static enum xp_retval
 xpc_allocate_msg_wait(struct xpc_channel *ch)
 {
-	enum xpc_retval ret;
+	enum xp_retval ret;
 
 
 	if (ch->flags & XPC_C_DISCONNECTING) {
-		DBUG_ON(ch->reason == xpcInterrupted);  // >>> Is this true?
+		DBUG_ON(ch->reason == xpInterrupted);
 		return ch->reason;
 	}
 
@@ -1709,11 +1700,11 @@ xpc_allocate_msg_wait(struct xpc_channel
 
 	if (ch->flags & XPC_C_DISCONNECTING) {
 		ret = ch->reason;
-		DBUG_ON(ch->reason == xpcInterrupted);  // >>> Is this true?
+		DBUG_ON(ch->reason == xpInterrupted);
 	} else if (ret == 0) {
-		ret = xpcTimeout;
+		ret = xpTimeout;
 	} else {
-		ret = xpcInterrupted;
+		ret = xpInterrupted;
 	}
 
 	return ret;
@@ -1724,12 +1715,12 @@ xpc_allocate_msg_wait(struct xpc_channel
  * Allocate an entry for a message from the message queue associated with the
  * specified channel.
  */
-static enum xpc_retval
+static enum xp_retval
 xpc_allocate_msg(struct xpc_channel *ch, u32 flags,
 			struct xpc_msg **address_of_msg)
 {
 	struct xpc_msg *msg;
-	enum xpc_retval ret;
+	enum xp_retval ret;
 	s64 put;
 
 
@@ -1742,7 +1733,7 @@ xpc_allocate_msg(struct xpc_channel *ch,
 	}
 	if (!(ch->flags & XPC_C_CONNECTED)) {
 		xpc_msgqueue_deref(ch);
-		return xpcNotConnected;
+		return xpNotConnected;
 	}
 
 
@@ -1751,7 +1742,7 @@ xpc_allocate_msg(struct xpc_channel *ch,
 	 * If none are available, we'll make sure that we grab the latest
 	 * GP values.
 	 */
-	ret = xpcTimeout;
+	ret = xpTimeout;
 
 	while (1) {
 
@@ -1764,7 +1755,7 @@ xpc_allocate_msg(struct xpc_channel *ch,
 			 * to increment w_local_GP.put as long as someone else
 			 * doesn't beat us to it. If they do, we'll have to
 			 * try again.
-		 	 */
+			 */
 			if (cmpxchg(&ch->w_local_GP.put, put, put + 1) ==
 									put) {
 				/* we got the entry referenced by put */
@@ -1783,17 +1774,17 @@ xpc_allocate_msg(struct xpc_channel *ch,
 		 * that will cause the IPI handler to fetch the latest
 		 * GP values as if an IPI was sent by the other side.
 		 */
-		if (ret == xpcTimeout) {
+		if (ret == xpTimeout) {
 			xpc_IPI_send_local_msgrequest(ch);
 		}
 
 		if (flags & XPC_NOWAIT) {
 			xpc_msgqueue_deref(ch);
-			return xpcNoWait;
+			return xpNoWait;
 		}
 
 		ret = xpc_allocate_msg_wait(ch);
-		if (ret != xpcInterrupted && ret != xpcTimeout) {
+		if (ret != xpInterrupted && ret != xpTimeout) {
 			xpc_msgqueue_deref(ch);
 			return ret;
 		}
@@ -1808,13 +1799,13 @@ xpc_allocate_msg(struct xpc_channel *ch,
 	DBUG_ON(msg->flags != 0);
 	msg->number = put;
 
-	dev_dbg(xpc_chan, "w_local_GP.put changed to %ld; msg=0x%p, "
-		"msg_number=%ld, partid=%d, channel=%d\n", put + 1,
+	dev_dbg(xpc_chan, "w_local_GP.put changed to %" U64_ELL "d; msg=0x%p, "
+		"msg_number=%" U64_ELL "d, partid=%d, channel=%d\n", put + 1,
 		(void *) msg, msg->number, ch->partid, ch->number);
 
 	*address_of_msg = msg;
 
-	return xpcSuccess;
+	return xpSuccess;
 }
 
 
@@ -1829,17 +1820,17 @@ xpc_allocate_msg(struct xpc_channel *ch,
  *	ch_number - channel #.
  *	flags - see xpc.h for valid flags.
  *	payload - address of the allocated payload area pointer (filled in on
- * 	          return) in which the user-defined message is constructed.
+ *	          return) in which the user-defined message is constructed.
  */
-enum xpc_retval
-xpc_initiate_allocate(partid_t partid, int ch_number, u32 flags, void **payload)
+enum xp_retval
+xpc_initiate_allocate(short partid, int ch_number, u32 flags, void **payload)
 {
 	struct xpc_partition *part = &xpc_partitions[partid];
-	enum xpc_retval ret = xpcUnknownReason;
+	enum xp_retval ret = xpUnknownReason;
 	struct xpc_msg *msg = NULL;
 
 
-	DBUG_ON(partid <= 0 || partid >= XP_MAX_PARTITIONS);
+	DBUG_ON(partid < XP_MIN_PARTID || partid > XP_MAX_PARTID);
 	DBUG_ON(ch_number < 0 || ch_number >= part->nchannels);
 
 	*payload = NULL;
@@ -1901,8 +1892,8 @@ xpc_send_msgs(struct xpc_channel *ch, s6
 
 		/* we just set the new value of local_GP->put */
 
-		dev_dbg(xpc_chan, "local_GP->put changed to %ld, partid=%d, "
-			"channel=%d\n", put, ch->partid, ch->number);
+		dev_dbg(xpc_chan, "local_GP->put changed to %" U64_ELL "d, "
+			"partid=%d, channel=%d\n", put, ch->partid, ch->number);
 
 		send_IPI = 1;
 
@@ -1925,11 +1916,11 @@ xpc_send_msgs(struct xpc_channel *ch, s6
  * local message queue's Put value and sends an IPI to the partition the
  * message is being sent to.
  */
-static enum xpc_retval
+static enum xp_retval
 xpc_send_msg(struct xpc_channel *ch, struct xpc_msg *msg, u8 notify_type,
 			xpc_notify_func func, void *key)
 {
-	enum xpc_retval ret = xpcSuccess;
+	enum xp_retval ret = xpSuccess;
 	struct xpc_notify *notify = notify;
 	s64 put, msg_number = msg->number;
 
@@ -1959,7 +1950,7 @@ xpc_send_msg(struct xpc_channel *ch, str
 		notify->key = key;
 		notify->type = notify_type;
 
-		// >>> is a mb() needed here?
+		/* >>> is a mb() needed here? */
 
 		if (ch->flags & XPC_C_DISCONNECTING) {
 			/*
@@ -2022,18 +2013,18 @@ xpc_send_msg(struct xpc_channel *ch, str
  *	payload - pointer to the payload area allocated via
  *			xpc_initiate_allocate().
  */
-enum xpc_retval
-xpc_initiate_send(partid_t partid, int ch_number, void *payload)
+enum xp_retval
+xpc_initiate_send(short partid, int ch_number, void *payload)
 {
 	struct xpc_partition *part = &xpc_partitions[partid];
 	struct xpc_msg *msg = XPC_MSG_ADDRESS(payload);
-	enum xpc_retval ret;
+	enum xp_retval ret;
 
 
 	dev_dbg(xpc_chan, "msg=0x%p, partid=%d, channel=%d\n", (void *) msg,
 		partid, ch_number);
 
-	DBUG_ON(partid <= 0 || partid >= XP_MAX_PARTITIONS);
+	DBUG_ON(partid < XP_MIN_PARTID || partid > XP_MAX_PARTID);
 	DBUG_ON(ch_number < 0 || ch_number >= part->nchannels);
 	DBUG_ON(msg == NULL);
 
@@ -2073,19 +2064,19 @@ xpc_initiate_send(partid_t partid, int c
  *		  receipt. THIS FUNCTION MUST BE NON-BLOCKING.
  *	key - user-defined key to be passed to the function when it's called.
  */
-enum xpc_retval
-xpc_initiate_send_notify(partid_t partid, int ch_number, void *payload,
+enum xp_retval
+xpc_initiate_send_notify(short partid, int ch_number, void *payload,
 				xpc_notify_func func, void *key)
 {
 	struct xpc_partition *part = &xpc_partitions[partid];
 	struct xpc_msg *msg = XPC_MSG_ADDRESS(payload);
-	enum xpc_retval ret;
+	enum xp_retval ret;
 
 
 	dev_dbg(xpc_chan, "msg=0x%p, partid=%d, channel=%d\n", (void *) msg,
 		partid, ch_number);
 
-	DBUG_ON(partid <= 0 || partid >= XP_MAX_PARTITIONS);
+	DBUG_ON(partid < XP_MIN_PARTID || partid > XP_MAX_PARTID);
 	DBUG_ON(ch_number < 0 || ch_number >= part->nchannels);
 	DBUG_ON(msg == NULL);
 	DBUG_ON(func == NULL);
@@ -2103,7 +2094,7 @@ xpc_pull_remote_msg(struct xpc_channel *
 	struct xpc_msg *remote_msg, *msg;
 	u32 msg_index, nmsgs;
 	u64 msg_offset;
-	enum xpc_retval ret;
+	enum xp_retval ret;
 
 
 	if (mutex_lock_interruptible(&ch->msg_to_pull_mutex) != 0) {
@@ -2133,12 +2124,13 @@ xpc_pull_remote_msg(struct xpc_channel *
 								msg_offset);
 
 		if ((ret = xpc_pull_remote_cachelines(part, msg, remote_msg,
-				nmsgs * ch->msg_size)) != xpcSuccess) {
+				nmsgs * ch->msg_size)) != xpSuccess) {
 
 			dev_dbg(xpc_chan, "failed to pull %d msgs starting with"
-				" msg %ld from partition %d, channel=%d, "
-				"ret=%d\n", nmsgs, ch->next_msg_to_pull,
-				ch->partid, ch->number, ret);
+				" msg %" U64_ELL "d from partition %d, "
+				"channel=%d, ret=%d\n", nmsgs,
+				ch->next_msg_to_pull, ch->partid, ch->number,
+				ret);
 
 			XPC_DEACTIVATE_PARTITION(part, ret);
 
@@ -2186,13 +2178,13 @@ xpc_get_deliverable_msg(struct xpc_chann
 		 * by trying to increment w_local_GP.get and hope that no one
 		 * else beats us to it. If they do, we'll we'll simply have
 		 * to try again for the next one.
-	 	 */
+		 */
 
 		if (cmpxchg(&ch->w_local_GP.get, get, get + 1) == get) {
 			/* we got the entry referenced by get */
 
-			dev_dbg(xpc_chan, "w_local_GP.get changed to %ld, "
-				"partid=%d, channel=%d\n", get + 1,
+			dev_dbg(xpc_chan, "w_local_GP.get changed to %" U64_ELL
+				"d, partid=%d, channel=%d\n", get + 1,
 				ch->partid, ch->number);
 
 			/* pull the message from the remote partition */
@@ -2234,18 +2226,18 @@ xpc_deliver_msg(struct xpc_channel *ch)
 
 		if (ch->func != NULL) {
 			dev_dbg(xpc_chan, "ch->func() called, msg=0x%p, "
-				"msg_number=%ld, partid=%d, channel=%d\n",
-				(void *) msg, msg->number, ch->partid,
-				ch->number);
+				"msg_number=%" U64_ELL "d, partid=%d, "
+				"channel=%d\n", (void *) msg, msg->number,
+				ch->partid, ch->number);
 
 			/* deliver the message to its intended recipient */
-			ch->func(xpcMsgReceived, ch->partid, ch->number,
+			ch->func(xpMsgReceived, ch->partid, ch->number,
 					&msg->payload, ch->key);
 
 			dev_dbg(xpc_chan, "ch->func() returned, msg=0x%p, "
-				"msg_number=%ld, partid=%d, channel=%d\n",
-				(void *) msg, msg->number, ch->partid,
-				ch->number);
+				"msg_number=%" U64_ELL "d, partid=%d, "
+				"channel=%d\n", (void *) msg, msg->number,
+				ch->partid, ch->number);
 		}
 
 		atomic_dec(&ch->kthreads_active);
@@ -2299,8 +2291,8 @@ xpc_acknowledge_msgs(struct xpc_channel 
 
 		/* we just set the new value of local_GP->get */
 
-		dev_dbg(xpc_chan, "local_GP->get changed to %ld, partid=%d, "
-			"channel=%d\n", get, ch->partid, ch->number);
+		dev_dbg(xpc_chan, "local_GP->get changed to %" U64_ELL "d, "
+			"partid=%d, channel=%d\n", get, ch->partid, ch->number);
 
 		send_IPI = (msg_flags & XPC_M_INTERRUPT);
 
@@ -2336,7 +2328,7 @@ xpc_acknowledge_msgs(struct xpc_channel 
  *			xpc_initiate_allocate().
  */
 void
-xpc_initiate_received(partid_t partid, int ch_number, void *payload)
+xpc_initiate_received(short partid, int ch_number, void *payload)
 {
 	struct xpc_partition *part = &xpc_partitions[partid];
 	struct xpc_channel *ch;
@@ -2344,13 +2336,14 @@ xpc_initiate_received(partid_t partid, i
 	s64 get, msg_number = msg->number;
 
 
-	DBUG_ON(partid <= 0 || partid >= XP_MAX_PARTITIONS);
+	DBUG_ON(partid < XP_MIN_PARTID || partid > XP_MAX_PARTID);
 	DBUG_ON(ch_number < 0 || ch_number >= part->nchannels);
 
 	ch = &part->channels[ch_number];
 
-	dev_dbg(xpc_chan, "msg=0x%p, msg_number=%ld, partid=%d, channel=%d\n",
-		(void *) msg, msg_number, ch->partid, ch->number);
+	dev_dbg(xpc_chan, "msg=0x%p, msg_number=%" U64_ELL "d, partid=%d, "
+		"channel=%d\n", (void *) msg, msg_number, ch->partid,
+		ch->number);
 
 	DBUG_ON((((u64) msg - (u64) ch->remote_msgqueue) / ch->msg_size) !=
 					msg_number % ch->remote_nentries);
Index: linux-2.6/drivers/misc/xp/xpc_main.c
===================================================================
--- linux-2.6.orig/drivers/misc/xp/xpc_main.c	2008-03-26 10:40:03.160341945 -0500
+++ linux-2.6/drivers/misc/xp/xpc_main.c	2008-03-26 10:41:52.361645910 -0500
@@ -3,7 +3,7 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  *
- * Copyright (c) 2004-2007 Silicon Graphics, Inc.  All Rights Reserved.
+ * Copyright (c) 2004-2008 Silicon Graphics, Inc.  All Rights Reserved.
  */
 
 
@@ -56,10 +56,16 @@
 #include <linux/reboot.h>
 #include <linux/completion.h>
 #include <linux/kdebug.h>
-#include <asm/sn/intr.h>
-#include <asm/sn/sn_sal.h>
+#if defined(CONFIG_IA64)
+#include <asm/sn/clksupport.h>
+#include <asm/sn/shub_mmr.h>
+#elif defined(CONFIG_X86_64)
+#define rtc_time()	1	/* will deal with this on X86_64 shortly */
+#else
+#error architecture is NOT supported
+#endif
 #include <asm/uaccess.h>
-#include <asm/sn/xpc.h>
+#include "xpc.h"
 
 
 /* define two XPC debug device structures to be used with dev_dbg() et al */
@@ -101,7 +107,7 @@ static int xpc_disengage_request_max_tim
 
 static ctl_table xpc_sys_xpc_hb_dir[] = {
 	{
-		.ctl_name 	= CTL_UNNUMBERED,
+		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "hb_interval",
 		.data		= &xpc_hb_interval,
 		.maxlen		= sizeof(int),
@@ -204,7 +210,7 @@ xpc_timeout_partition_disengage_request(
 	(void) xpc_partition_disengaged(part);
 
 	DBUG_ON(part->disengage_request_timeout != 0);
-	DBUG_ON(xpc_partition_engaged(1UL << XPC_PARTID(part)) != 0);
+	DBUG_ON(xpc_partition_engaged(XPC_PARTID(part)) != 0);
 }
 
 
@@ -343,14 +349,14 @@ xpc_initiate_discovery(void *ignore)
  * the XPC per partition variables from the remote partition and waiting for
  * the remote partition to pull ours.
  */
-static enum xpc_retval
+static enum xp_retval
 xpc_make_first_contact(struct xpc_partition *part)
 {
-	enum xpc_retval ret;
+	enum xp_retval ret;
 
 
-	while ((ret = xpc_pull_remote_vars_part(part)) != xpcSuccess) {
-		if (ret != xpcRetry) {
+	while ((ret = xpc_pull_remote_vars_part(part)) != xpSuccess) {
+		if (ret != xpRetry) {
 			XPC_DEACTIVATE_PARTITION(part, ret);
 			return ret;
 		}
@@ -361,7 +367,7 @@ xpc_make_first_contact(struct xpc_partit
 		/* wait a 1/4 of a second or so */
 		(void) msleep_interruptible(250);
 
-		if (part->act_state == XPC_P_DEACTIVATING) {
+		if (part->act_state == XPC_P_AS_DEACTIVATING) {
 			return part->reason;
 		}
 	}
@@ -385,7 +391,7 @@ xpc_make_first_contact(struct xpc_partit
 static void
 xpc_channel_mgr(struct xpc_partition *part)
 {
-	while (part->act_state != XPC_P_DEACTIVATING ||
+	while (part->act_state != XPC_P_AS_DEACTIVATING ||
 			atomic_read(&part->nchannels_active) > 0 ||
 					!xpc_partition_disengaged(part)) {
 
@@ -410,13 +416,10 @@ xpc_channel_mgr(struct xpc_partition *pa
 				(atomic_read(&part->channel_mgr_requests) > 0 ||
 				(volatile u64) part->local_IPI_amo != 0 ||
 				((volatile u8) part->act_state ==
-							XPC_P_DEACTIVATING &&
+							XPC_P_AS_DEACTIVATING &&
 				atomic_read(&part->nchannels_active) == 0 &&
 				xpc_partition_disengaged(part))));
 		atomic_set(&part->channel_mgr_requests, 1);
-
-		// >>> Does it need to wakeup periodically as well? In case we
-		// >>> miscalculated the #of kthreads to wakeup or create?
 	}
 }
 
@@ -443,7 +446,7 @@ xpc_partition_up(struct xpc_partition *p
 
 	dev_dbg(xpc_chan, "activating partition %d\n", XPC_PARTID(part));
 
-	if (xpc_setup_infrastructure(part) != xpcSuccess) {
+	if (xpc_setup_infrastructure(part) != xpSuccess) {
 		return;
 	}
 
@@ -456,7 +459,7 @@ xpc_partition_up(struct xpc_partition *p
 
 	(void) xpc_part_ref(part);	/* this will always succeed */
 
-	if (xpc_make_first_contact(part) == xpcSuccess) {
+	if (xpc_make_first_contact(part) == xpSuccess) {
 		xpc_channel_mgr(part);
 	}
 
@@ -469,30 +472,30 @@ xpc_partition_up(struct xpc_partition *p
 static int
 xpc_activating(void *__partid)
 {
-	partid_t partid = (u64) __partid;
+	short partid = (u64) __partid;
 	struct xpc_partition *part = &xpc_partitions[partid];
 	unsigned long irq_flags;
 	struct sched_param param = { .sched_priority = MAX_RT_PRIO - 1 };
 	int ret;
 
 
-	DBUG_ON(partid <= 0 || partid >= XP_MAX_PARTITIONS);
+	DBUG_ON(partid < XP_MIN_PARTID || partid > XP_MAX_PARTID);
 
-	spin_lock_irqsave(&part->act_lock, irq_flags);
+	spin_lock_irqsave(&part->lock, irq_flags);
 
-	if (part->act_state == XPC_P_DEACTIVATING) {
-		part->act_state = XPC_P_INACTIVE;
-		spin_unlock_irqrestore(&part->act_lock, irq_flags);
+	if (part->act_state == XPC_P_AS_DEACTIVATING) {
+		part->act_state = XPC_P_AS_INACTIVE;
+		spin_unlock_irqrestore(&part->lock, irq_flags);
 		part->remote_rp_pa = 0;
 		return 0;
 	}
 
 	/* indicate the thread is activating */
-	DBUG_ON(part->act_state != XPC_P_ACTIVATION_REQ);
-	part->act_state = XPC_P_ACTIVATING;
+	DBUG_ON(part->act_state != XPC_P_AS_ACTIVATION_REQ);
+	part->act_state = XPC_P_AS_ACTIVATING;
 
 	XPC_SET_REASON(part, 0, 0);
-	spin_unlock_irqrestore(&part->act_lock, irq_flags);
+	spin_unlock_irqrestore(&part->lock, irq_flags);
 
 	dev_dbg(xpc_part, "bringing partition %d up\n", partid);
 
@@ -512,24 +515,20 @@ xpc_activating(void *__partid)
 	set_cpus_allowed(current, CPU_MASK_ALL);
 
 	/*
-	 * Register the remote partition's AMOs with SAL so it can handle
-	 * and cleanup errors within that address range should the remote
-	 * partition go down. We don't unregister this range because it is
-	 * difficult to tell when outstanding writes to the remote partition
-	 * are finished and thus when it is safe to unregister. This should
-	 * not result in wasted space in the SAL xp_addr_region table because
-	 * we should get the same page for remote_amos_page_pa after module
-	 * reloads and system reboots.
+	 * Register the remote partition's AMOs so any errors within that
+	 * address range can be handled and cleaned up should the remote
+	 * partition go down.
 	 */
-	if (sn_register_xp_addr_region(part->remote_amos_page_pa,
-							PAGE_SIZE, 1) < 0) {
-		dev_warn(xpc_part, "xpc_partition_up(%d) failed to register "
-			"xp_addr region\n", partid);
-
-		spin_lock_irqsave(&part->act_lock, irq_flags);
-		part->act_state = XPC_P_INACTIVE;
-		XPC_SET_REASON(part, xpcPhysAddrRegFailed, __LINE__);
-		spin_unlock_irqrestore(&part->act_lock, irq_flags);
+	ret = xpc_register_remote_amos(part);
+	if (ret != xpSuccess) {
+		dev_warn(xpc_part, "xpc_activating() failed to register remote "
+				 "AMOs for partition %d, ret=%d\n", partid,
+				 ret);
+
+		spin_lock_irqsave(&part->lock, irq_flags);
+		part->act_state = XPC_P_AS_INACTIVE;
+		XPC_SET_REASON(part, xpPhysAddrRegFailed, __LINE__);
+		spin_unlock_irqrestore(&part->lock, irq_flags);
 		part->remote_rp_pa = 0;
 		return 0;
 	}
@@ -540,14 +539,16 @@ xpc_activating(void *__partid)
 
 	/*
 	 * xpc_partition_up() holds this thread and marks this partition as
-	 * XPC_P_ACTIVE by calling xpc_hb_mark_active().
+	 * XPC_P_AS_ACTIVE by calling xpc_hb_mark_active().
 	 */
-	(void) xpc_partition_up(part);
+	(void)xpc_partition_up(part);
 
 	xpc_disallow_hb(partid, xpc_vars);
 	xpc_mark_partition_inactive(part);
 
-	if (part->reason == xpcReactivating) {
+	xpc_unregister_remote_amos(part);
+
+	if (part->reason == xpReactivating) {
 		/* interrupting ourselves results in activating partition */
 		xpc_IPI_send_reactivate(part);
 	}
@@ -559,27 +560,27 @@ xpc_activating(void *__partid)
 void
 xpc_activate_partition(struct xpc_partition *part)
 {
-	partid_t partid = XPC_PARTID(part);
+	short partid = XPC_PARTID(part);
 	unsigned long irq_flags;
 	pid_t pid;
 
 
-	spin_lock_irqsave(&part->act_lock, irq_flags);
+	spin_lock_irqsave(&part->lock, irq_flags);
 
-	DBUG_ON(part->act_state != XPC_P_INACTIVE);
+	DBUG_ON(part->act_state != XPC_P_AS_INACTIVE);
 
-	part->act_state = XPC_P_ACTIVATION_REQ;
-	XPC_SET_REASON(part, xpcCloneKThread, __LINE__);
+	part->act_state = XPC_P_AS_ACTIVATION_REQ;
+	XPC_SET_REASON(part, xpCloneKThread, __LINE__);
 
-	spin_unlock_irqrestore(&part->act_lock, irq_flags);
+	spin_unlock_irqrestore(&part->lock, irq_flags);
 
 	pid = kernel_thread(xpc_activating, (void *) ((u64) partid), 0);
 
 	if (unlikely(pid <= 0)) {
-		spin_lock_irqsave(&part->act_lock, irq_flags);
-		part->act_state = XPC_P_INACTIVE;
-		XPC_SET_REASON(part, xpcCloneKThreadFailed, __LINE__);
-		spin_unlock_irqrestore(&part->act_lock, irq_flags);
+		spin_lock_irqsave(&part->lock, irq_flags);
+		part->act_state = XPC_P_AS_INACTIVE;
+		XPC_SET_REASON(part, xpCloneKThreadFailed, __LINE__);
+		spin_unlock_irqrestore(&part->lock, irq_flags);
 	}
 }
 
@@ -588,7 +589,7 @@ xpc_activate_partition(struct xpc_partit
  * Handle the receipt of a SGI_XPC_NOTIFY IRQ by seeing whether the specified
  * partition actually sent it. Since SGI_XPC_NOTIFY IRQs may be shared by more
  * than one partition, we use an AMO_t structure per partition to indicate
- * whether a partition has sent an IPI or not.  >>> If it has, then wake up the
+ * whether a partition has sent an IPI or not.  If it has, then wake up the
  * associated kthread to handle it.
  *
  * All SGI_XPC_NOTIFY IRQs received by XPC are the result of IPIs sent by XPC
@@ -603,11 +604,11 @@ xpc_activate_partition(struct xpc_partit
 irqreturn_t
 xpc_notify_IRQ_handler(int irq, void *dev_id)
 {
-	partid_t partid = (partid_t) (u64) dev_id;
+	short partid = (short) (u64) dev_id;
 	struct xpc_partition *part = &xpc_partitions[partid];
 
 
-	DBUG_ON(partid <= 0 || partid >= XP_MAX_PARTITIONS);
+	DBUG_ON(partid < XP_MIN_PARTID || partid > XP_MAX_PARTID);
 
 	if (xpc_part_ref(part)) {
 		xpc_check_for_channel_activity(part);
@@ -630,7 +631,7 @@ xpc_dropped_IPI_check(struct xpc_partiti
 		xpc_check_for_channel_activity(part);
 
 		part->dropped_IPI_timer.expires = jiffies +
-							XPC_P_DROPPED_IPI_WAIT;
+						XPC_DROPPED_IPI_WAIT_INTERVAL;
 		add_timer(&part->dropped_IPI_timer);
 		xpc_part_deref(part);
 	}
@@ -664,7 +665,6 @@ xpc_activate_kthreads(struct xpc_channel
 
 	if (needed + assigned > ch->kthreads_assigned_limit) {
 		needed = ch->kthreads_assigned_limit - assigned;
-		// >>>should never be less than 0
 		if (needed <= 0) {
 			return;
 		}
@@ -718,7 +718,7 @@ xpc_kthread_waitmsgs(struct xpc_partitio
 static int
 xpc_daemonize_kthread(void *args)
 {
-	partid_t partid = XPC_UNPACK_ARG1(args);
+	short partid = XPC_UNPACK_ARG1(args);
 	u16 ch_number = XPC_UNPACK_ARG2(args);
 	struct xpc_partition *part = &xpc_partitions[partid];
 	struct xpc_channel *ch;
@@ -775,7 +775,7 @@ xpc_daemonize_kthread(void *args)
 		ch->flags |= XPC_C_DISCONNECTINGCALLOUT;
 		spin_unlock_irqrestore(&ch->lock, irq_flags);
 
-		xpc_disconnect_callout(ch, xpcDisconnecting);
+		xpc_disconnect_callout(ch, xpDisconnecting);
 
 		spin_lock_irqsave(&ch->lock, irq_flags);
 		ch->flags |= XPC_C_DISCONNECTINGCALLOUT_MADE;
@@ -856,8 +856,8 @@ xpc_create_kthreads(struct xpc_channel *
 			 * then we'll deadlock if all other kthreads assigned
 			 * to this channel are blocked in the channel's
 			 * registerer, because the only thing that will unblock
-			 * them is the xpcDisconnecting callout that this
-			 * failed kernel_thread would have made.
+			 * them is the xpDisconnecting callout that this failed
+			 * kernel_thread would have made.
 			 */
 
 			if (atomic_dec_return(&ch->kthreads_assigned) == 0 &&
@@ -876,14 +876,12 @@ xpc_create_kthreads(struct xpc_channel *
 				 * to function.
 				 */
 				spin_lock_irqsave(&ch->lock, irq_flags);
-				XPC_DISCONNECT_CHANNEL(ch, xpcLackOfResources,
+				XPC_DISCONNECT_CHANNEL(ch, xpLackOfResources,
 								&irq_flags);
 				spin_unlock_irqrestore(&ch->lock, irq_flags);
 			}
 			break;
 		}
-
-		ch->kthreads_created++;	// >>> temporary debug only!!!
 	}
 }
 
@@ -892,14 +890,14 @@ void
 xpc_disconnect_wait(int ch_number)
 {
 	unsigned long irq_flags;
-	partid_t partid;
+	short partid;
 	struct xpc_partition *part;
 	struct xpc_channel *ch;
 	int wakeup_channel_mgr;
 
 
 	/* now wait for all callouts to the caller's function to cease */
-	for (partid = 1; partid < XP_MAX_PARTITIONS; partid++) {
+	for (partid = XP_MIN_PARTID; partid <= XP_MAX_PARTID; partid++) {
 		part = &xpc_partitions[partid];
 
 		if (!xpc_part_ref(part)) {
@@ -920,7 +918,7 @@ xpc_disconnect_wait(int ch_number)
 		wakeup_channel_mgr = 0;
 
 		if (ch->delayed_IPI_flags) {
-			if (part->act_state != XPC_P_DEACTIVATING) {
+			if (part->act_state != XPC_P_AS_DEACTIVATING) {
 				spin_lock(&part->IPI_lock);
 				XPC_SET_IPI_FLAGS(part->local_IPI_amo,
 					ch->number, ch->delayed_IPI_flags);
@@ -943,9 +941,9 @@ xpc_disconnect_wait(int ch_number)
 
 
 static void
-xpc_do_exit(enum xpc_retval reason)
+xpc_do_exit(enum xp_retval reason)
 {
-	partid_t partid;
+	short partid;
 	int active_part_count, printed_waiting_msg = 0;
 	struct xpc_partition *part;
 	unsigned long printmsg_time, disengage_request_timeout = 0;
@@ -984,11 +982,13 @@ xpc_do_exit(enum xpc_retval reason)
 	do {
 		active_part_count = 0;
 
-		for (partid = 1; partid < XP_MAX_PARTITIONS; partid++) {
+		for (partid = XP_MIN_PARTID; partid <= XP_MAX_PARTID;
+		     partid++) {
 			part = &xpc_partitions[partid];
 
 			if (xpc_partition_disengaged(part) &&
-					part->act_state == XPC_P_INACTIVE) {
+					part->act_state == XPC_P_AS_INACTIVE) {
+				xpc_unregister_remote_amos(part);
 				continue;
 			}
 
@@ -1003,7 +1003,7 @@ xpc_do_exit(enum xpc_retval reason)
 			}
 		}
 
-		if (xpc_partition_engaged(-1UL)) {
+		if (xpc_any_partition_engaged()) {
 			if (time_after(jiffies, printmsg_time)) {
 				dev_info(xpc_part, "waiting for remote "
 					"partitions to disengage, timeout in "
@@ -1035,7 +1035,7 @@ xpc_do_exit(enum xpc_retval reason)
 
 	} while (1);
 
-	DBUG_ON(xpc_partition_engaged(-1UL));
+	DBUG_ON(xpc_any_partition_engaged());
 
 
 	/* indicate to others that our reserved page is uninitialized */
@@ -1043,9 +1043,9 @@ xpc_do_exit(enum xpc_retval reason)
 
 	/* now it's time to eliminate our heartbeat */
 	del_timer_sync(&xpc_hb_timer);
-	DBUG_ON(xpc_vars->heartbeating_to_mask != 0);
+	DBUG_ON(xpc_any_hbs_allowed(xpc_vars) != 0);
 
-	if (reason == xpcUnloading) {
+	if (reason == xpUnloading) {
 		/* take ourselves off of the reboot_notifier_list */
 		(void) unregister_reboot_notifier(&xpc_reboot_notifier);
 
@@ -1054,7 +1054,8 @@ xpc_do_exit(enum xpc_retval reason)
 	}
 
 	/* close down protections for IPI operations */
-	xpc_restrict_IPI_ops();
+	xp_disallow_IPI_ops();
+	xp_change_memprotect_shub_wars_1_1(XP_MEMPROT_DISALLOW_ALL);
 
 
 	/* clear the interface to XPC's functions */
@@ -1074,21 +1075,21 @@ xpc_do_exit(enum xpc_retval reason)
 static int
 xpc_system_reboot(struct notifier_block *nb, unsigned long event, void *unused)
 {
-	enum xpc_retval reason;
+	enum xp_retval reason;
 
 
 	switch (event) {
 	case SYS_RESTART:
-		reason = xpcSystemReboot;
+		reason = xpSystemReboot;
 		break;
 	case SYS_HALT:
-		reason = xpcSystemHalt;
+		reason = xpSystemHalt;
 		break;
 	case SYS_POWER_OFF:
-		reason = xpcSystemPoweroff;
+		reason = xpSystemPoweroff;
 		break;
 	default:
-		reason = xpcSystemGoingDown;
+		reason = xpSystemGoingDown;
 	}
 
 	xpc_do_exit(reason);
@@ -1096,6 +1097,7 @@ xpc_system_reboot(struct notifier_block 
 }
 
 
+#ifdef CONFIG_IA64
 /*
  * Notify other partitions to disengage from all references to our memory.
  */
@@ -1103,29 +1105,28 @@ static void
 xpc_die_disengage(void)
 {
 	struct xpc_partition *part;
-	partid_t partid;
-	unsigned long engaged;
+	short partid;
 	long time, printmsg_time, disengage_request_timeout;
 
 
 	/* keep xpc_hb_checker thread from doing anything (just in case) */
 	xpc_exiting = 1;
 
-	xpc_vars->heartbeating_to_mask = 0;  /* indicate we're deactivated */
+	xpc_disallow_all_hbs(xpc_vars); /* indicate we're deactivated */
 
-	for (partid = 1; partid < XP_MAX_PARTITIONS; partid++) {
+	for (partid = XP_MIN_PARTID; partid <= XP_MAX_PARTID; partid++) {
 		part = &xpc_partitions[partid];
 
 		if (!XPC_SUPPORTS_DISENGAGE_REQUEST(part->
 							remote_vars_version)) {
 
 			/* just in case it was left set by an earlier XPC */
-			xpc_clear_partition_engaged(1UL << partid);
+			xpc_clear_partition_engaged(partid);
 			continue;
 		}
 
-		if (xpc_partition_engaged(1UL << partid) ||
-					part->act_state != XPC_P_INACTIVE) {
+		if (xpc_partition_engaged(partid) ||
+					part->act_state != XPC_P_AS_INACTIVE) {
 			xpc_request_partition_disengage(part);
 			xpc_mark_partition_disengaged(part);
 			xpc_IPI_send_disengage(part);
@@ -1134,23 +1135,23 @@ xpc_die_disengage(void)
 
 	time = rtc_time();
 	printmsg_time = time +
-		(XPC_DISENGAGE_PRINTMSG_INTERVAL * sn_rtc_cycles_per_second);
+		(XPC_DISENGAGE_PRINTMSG_INTERVAL * xp_rtc_cycles_per_second);
 	disengage_request_timeout = time +
-		(xpc_disengage_request_timelimit * sn_rtc_cycles_per_second);
+		(xpc_disengage_request_timelimit * xp_rtc_cycles_per_second);
 
 	/* wait for all other partitions to disengage from us */
 
 	while (1) {
-		engaged = xpc_partition_engaged(-1UL);
-		if (!engaged) {
+		if (!xpc_any_partition_engaged()) {
 			dev_info(xpc_part, "all partitions have disengaged\n");
 			break;
 		}
 
 		time = rtc_time();
 		if (time >= disengage_request_timeout) {
-			for (partid = 1; partid < XP_MAX_PARTITIONS; partid++) {
-				if (engaged & (1UL << partid)) {
+			for (partid = XP_MIN_PARTID; partid <= XP_MAX_PARTID;
+			     partid++) {
+				if (xpc_partition_engaged(partid)) {
 					dev_info(xpc_part, "disengage from "
 						"remote partition %d timed "
 						"out\n", partid);
@@ -1163,13 +1164,14 @@ xpc_die_disengage(void)
 			dev_info(xpc_part, "waiting for remote partitions to "
 				"disengage, timeout in %ld seconds\n",
 				(disengage_request_timeout - time) /
-						sn_rtc_cycles_per_second);
+						xp_rtc_cycles_per_second);
 			printmsg_time = time +
 					(XPC_DISENGAGE_PRINTMSG_INTERVAL *
-						sn_rtc_cycles_per_second);
+						xp_rtc_cycles_per_second);
 		}
 	}
 }
+#endif /* CONFIG_IA64 */
 
 
 /*
@@ -1183,6 +1185,7 @@ xpc_die_disengage(void)
 static int
 xpc_system_die(struct notifier_block *nb, unsigned long event, void *unused)
 {
+#ifdef CONFIG_IA64 /* >>> will deal with notify_die events on X86_64 shortly */
 	switch (event) {
 	case DIE_MACHINE_RESTART:
 	case DIE_MACHINE_HALT:
@@ -1213,7 +1216,7 @@ xpc_system_die(struct notifier_block *nb
 		xpc_vars->heartbeat_offline = 0;
 		break;
 	}
-
+#endif /* CONFIG_IA64 */
 	return NOTIFY_DONE;
 }
 
@@ -1222,23 +1225,21 @@ int __init
 xpc_init(void)
 {
 	int ret;
-	partid_t partid;
+	short partid;
 	struct xpc_partition *part;
 	pid_t pid;
 	size_t buf_size;
 
-
-	if (!ia64_platform_is("sn2")) {
+	if (is_shub()) {
+		/*
+		 * The ia64-sn architecture supports at most 64 partitions. And
+		 * the inability to unregister remote AMOs restricts us further
+		 * to only support 64 partitions on this architecture.
+		 */
+		if (XP_NPARTITIONS != 64)
+			return -EINVAL;
+	} else if (!is_uv())
 		return -ENODEV;
-	}
-
-
-	buf_size = max(XPC_RP_VARS_SIZE,
-				XPC_RP_HEADER_SIZE + XP_NASID_MASK_BYTES);
-	xpc_remote_copy_buffer = xpc_kmalloc_cacheline_aligned(buf_size,
-				     GFP_KERNEL, &xpc_remote_copy_buffer_base);
-	if (xpc_remote_copy_buffer == NULL)
-		return -ENOMEM;
 
 	snprintf(xpc_part->bus_id, BUS_ID_SIZE, "part");
 	snprintf(xpc_chan->bus_id, BUS_ID_SIZE, "chan");
@@ -1253,14 +1254,14 @@ xpc_init(void)
 	 * ENTRIES ARE MEANINGFUL UNTIL AFTER AN ENTRY'S CORRESPONDING
 	 * PARTITION HAS BEEN ACTIVATED.
 	 */
-	for (partid = 1; partid < XP_MAX_PARTITIONS; partid++) {
+	for (partid = XP_MIN_PARTID; partid <= XP_MAX_PARTID; partid++) {
 		part = &xpc_partitions[partid];
 
 		DBUG_ON((u64) part != L1_CACHE_ALIGN((u64) part));
 
 		part->act_IRQ_rcvd = 0;
-		spin_lock_init(&part->act_lock);
-		part->act_state = XPC_P_INACTIVE;
+		spin_lock_init(&part->lock);
+		part->act_state = XPC_P_AS_INACTIVE;
 		XPC_SET_REASON(part, 0, 0);
 
 		init_timer(&part->disengage_request_timer);
@@ -1268,7 +1269,7 @@ xpc_init(void)
 				xpc_timeout_partition_disengage_request;
 		part->disengage_request_timer.data = (unsigned long) part;
 
-		part->setup_state = XPC_P_UNSET;
+		part->setup_state = XPC_P_SS_UNSET;
 		init_waitqueue_head(&part->teardown_wq);
 		atomic_set(&part->references, 0);
 	}
@@ -1277,7 +1278,8 @@ xpc_init(void)
 	 * Open up protections for IPI operations (and AMO operations on
 	 * Shub 1.1 systems).
 	 */
-	xpc_allow_IPI_ops();
+	xp_allow_IPI_ops();
+	xp_change_memprotect_shub_wars_1_1(XP_MEMPROT_ALLOW_ALL);
 
 	/*
 	 * Interrupts being processed will increment this atomic variable and
@@ -1297,13 +1299,13 @@ xpc_init(void)
 		dev_err(xpc_part, "can't register ACTIVATE IRQ handler, "
 			"errno=%d\n", -ret);
 
-		xpc_restrict_IPI_ops();
+		xp_disallow_IPI_ops();
+		xp_change_memprotect_shub_wars_1_1(XP_MEMPROT_DISALLOW_ALL);
 
 		if (xpc_sysctl) {
 			unregister_sysctl_table(xpc_sysctl);
 		}
 
-		kfree(xpc_remote_copy_buffer_base);
 		return -EBUSY;
 	}
 
@@ -1317,16 +1319,36 @@ xpc_init(void)
 		dev_err(xpc_part, "could not setup our reserved page\n");
 
 		free_irq(SGI_XPC_ACTIVATE, NULL);
-		xpc_restrict_IPI_ops();
+		xp_disallow_IPI_ops();
+		xp_change_memprotect_shub_wars_1_1(XP_MEMPROT_DISALLOW_ALL);
 
 		if (xpc_sysctl) {
 			unregister_sysctl_table(xpc_sysctl);
 		}
 
-		kfree(xpc_remote_copy_buffer_base);
 		return -EBUSY;
 	}
 
+	buf_size = max(XPC_RP_VARS_SIZE,
+		       XPC_RP_HEADER_SIZE + xp_sizeof_nasid_mask);
+	xpc_remote_copy_buffer = xpc_kmalloc_cacheline_aligned(buf_size,
+				     GFP_KERNEL, &xpc_remote_copy_buffer_base);
+	if (xpc_remote_copy_buffer == NULL) {
+		dev_err(xpc_part, "could not allocate remote copy buffer\n");
+
+		/* indicate to others that our reserved page is uninitialized */
+		xpc_rsvd_page->vars_pa = 0;
+
+		free_irq(SGI_XPC_ACTIVATE, NULL);
+		xp_disallow_IPI_ops();
+		xp_change_memprotect_shub_wars_1_1(XP_MEMPROT_DISALLOW_ALL);
+
+		if (xpc_sysctl) {
+			unregister_sysctl_table(xpc_sysctl);
+		}
+		return -ENOMEM;
+	}
+
 
 	/* add ourselves to the reboot_notifier_list */
 	ret = register_reboot_notifier(&xpc_reboot_notifier);
@@ -1362,7 +1384,8 @@ xpc_init(void)
 
 		del_timer_sync(&xpc_hb_timer);
 		free_irq(SGI_XPC_ACTIVATE, NULL);
-		xpc_restrict_IPI_ops();
+		xp_disallow_IPI_ops();
+		xp_change_memprotect_shub_wars_1_1(XP_MEMPROT_DISALLOW_ALL);
 
 		if (xpc_sysctl) {
 			unregister_sysctl_table(xpc_sysctl);
@@ -1385,7 +1408,7 @@ xpc_init(void)
 		/* mark this new thread as a non-starter */
 		complete(&xpc_discovery_exited);
 
-		xpc_do_exit(xpcUnloading);
+		xpc_do_exit(xpUnloading);
 		return -EBUSY;
 	}
 
@@ -1404,7 +1427,7 @@ module_init(xpc_init);
 void __exit
 xpc_exit(void)
 {
-	xpc_do_exit(xpcUnloading);
+	xpc_do_exit(xpUnloading);
 }
 module_exit(xpc_exit);
 
Index: linux-2.6/drivers/misc/xp/xpc_partition.c
===================================================================
--- linux-2.6.orig/drivers/misc/xp/xpc_partition.c	2008-03-26 10:40:03.160341945 -0500
+++ linux-2.6/drivers/misc/xp/xpc_partition.c	2008-03-26 10:40:10.689258977 -0500
@@ -3,7 +3,7 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  *
- * Copyright (c) 2004-2006 Silicon Graphics, Inc.  All Rights Reserved.
+ * Copyright (c) 2004-2008 Silicon Graphics, Inc.  All Rights Reserved.
  */
 
 
@@ -22,31 +22,21 @@
 #include <linux/cache.h>
 #include <linux/mmzone.h>
 #include <linux/nodemask.h>
-#include <asm/uncached.h>
-#include <asm/sn/bte.h>
-#include <asm/sn/intr.h>
-#include <asm/sn/sn_sal.h>
-#include <asm/sn/nodepda.h>
-#include <asm/sn/addrs.h>
-#include <asm/sn/xpc.h>
+#include "xpc.h"
+
+#if defined(CONFIG_IA64)
+#define xp_pa(_a)	ia64_tpa(_a)
+#elif defined(CONFIG_X86_64)
+#define xp_pa(_a)	__pa(_a)
+#else
+#error architecture is NOT supported
+#endif
 
 
 /* XPC is exiting flag */
 int xpc_exiting;
 
 
-/* SH_IPI_ACCESS shub register value on startup */
-static u64 xpc_sh1_IPI_access;
-static u64 xpc_sh2_IPI_access0;
-static u64 xpc_sh2_IPI_access1;
-static u64 xpc_sh2_IPI_access2;
-static u64 xpc_sh2_IPI_access3;
-
-
-/* original protection values for each node */
-u64 xpc_prot_vec[MAX_NUMNODES];
-
-
 /* this partition's reserved page pointers */
 struct xpc_rsvd_page *xpc_rsvd_page;
 static u64 *xpc_part_nasids;
@@ -54,9 +44,6 @@ static u64 *xpc_mach_nasids;
 struct xpc_vars *xpc_vars;
 struct xpc_vars_part *xpc_vars_part;
 
-static int xp_nasid_mask_bytes;	/* actual size in bytes of nasid mask */
-static int xp_nasid_mask_words;	/* actual size in words of nasid mask */
-
 
 /*
  * For performance reasons, each entry of xpc_partitions[] is cacheline
@@ -64,7 +51,7 @@ static int xp_nasid_mask_words;	/* actua
  * end so that the last legitimate entry doesn't share its cacheline with
  * another variable.
  */
-struct xpc_partition xpc_partitions[XP_MAX_PARTITIONS + 1];
+struct xpc_partition xpc_partitions[XP_NPARTITIONS + 1];
 
 
 /*
@@ -108,57 +95,54 @@ xpc_kmalloc_cacheline_aligned(size_t siz
 static u64
 xpc_get_rsvd_page_pa(int nasid)
 {
-	bte_result_t bte_res;
-	s64 status;
-	u64 cookie = 0;
 	u64 rp_pa = nasid;	/* seed with nasid */
-	u64 len = 0;
+	enum xp_retval ret;
+	u64 cookie = 0;
+	size_t len = 0;
 	u64 buf = buf;
-	u64 buf_len = 0;
+	size_t buf_len = 0;
 	void *buf_base = NULL;
 
 
 	while (1) {
 
-		status = sn_partition_reserved_page_pa(buf, &cookie, &rp_pa,
-								&len);
+		ret = xp_get_partition_rsvd_page_pa(buf, &cookie, &rp_pa, &len);
 
-		dev_dbg(xpc_part, "SAL returned with status=%li, cookie="
-			"0x%016lx, address=0x%016lx, len=0x%016lx\n",
-			status, cookie, rp_pa, len);
+		dev_dbg(xpc_part, "SAL returned ret=%d cookie=0x%016" U64_ELL
+			"x, address=0x%016" U64_ELL "x len=0x%016lx\n", ret,
+			cookie, rp_pa, len);
 
-		if (status != SALRET_MORE_PASSES) {
+		if (ret != xpNeedMoreInfo) {
 			break;
 		}
 
 		if (L1_CACHE_ALIGN(len) > buf_len) {
 			kfree(buf_base);
 			buf_len = L1_CACHE_ALIGN(len);
-			buf = (u64) xpc_kmalloc_cacheline_aligned(buf_len,
+			buf = (u64)xpc_kmalloc_cacheline_aligned(buf_len,
 							GFP_KERNEL, &buf_base);
 			if (buf_base == NULL) {
 				dev_err(xpc_part, "unable to kmalloc "
 					"len=0x%016lx\n", buf_len);
-				status = SALRET_ERROR;
+				ret = xpNoMemory;
 				break;
 			}
 		}
 
-		bte_res = xp_bte_copy(rp_pa, buf, buf_len,
-					(BTE_NOTIFY | BTE_WACQUIRE), NULL);
-		if (bte_res != BTE_SUCCESS) {
-			dev_dbg(xpc_part, "xp_bte_copy failed %i\n", bte_res);
-			status = SALRET_ERROR;
+		ret = xp_remote_memcpy((void *)buf, (void *)rp_pa, buf_len);
+		if (ret != xpSuccess) {
+			dev_dbg(xpc_part, "xp_remote_memcpy failed %d\n", ret);
 			break;
 		}
 	}
 
 	kfree(buf_base);
 
-	if (status != SALRET_OK) {
+	if (ret != xpSuccess) {
 		rp_pa = 0;
 	}
-	dev_dbg(xpc_part, "reserved page at phys address 0x%016lx\n", rp_pa);
+	dev_dbg(xpc_part, "reserved page at phys address 0x%016" U64_ELL "x\n",
+		rp_pa);
 	return rp_pa;
 }
 
@@ -172,15 +156,21 @@ struct xpc_rsvd_page *
 xpc_rsvd_page_init(void)
 {
 	struct xpc_rsvd_page *rp;
-	AMO_t *amos_page;
-	u64 rp_pa, nasid_array = 0;
-	int i, ret;
+	int n_amos;
+	u64 *amos_page;
+	u64 rp_pa;
+	int i;
+	u64 nasid_array = 0;
+	int activate_irq_amos;
+	int engaged_partitions_amos;
+	int disengage_request_amos;
+	int ret;
 
 
 	/* get the local reserved page's address */
 
 	preempt_disable();
-	rp_pa = xpc_get_rsvd_page_pa(cpuid_to_nasid(smp_processor_id()));
+	rp_pa = xpc_get_rsvd_page_pa(xp_cpu_to_nasid(smp_processor_id()));
 	preempt_enable();
 	if (rp_pa == 0) {
 		dev_err(xpc_part, "SAL failed to locate the reserved page\n");
@@ -188,21 +178,14 @@ xpc_rsvd_page_init(void)
 	}
 	rp = (struct xpc_rsvd_page *) __va(rp_pa);
 
-	if (rp->partid != sn_partition_id) {
-		dev_err(xpc_part, "the reserved page's partid of %d should be "
-			"%d\n", rp->partid, sn_partition_id);
-		return NULL;
-	}
-
 	rp->version = XPC_RP_VERSION;
 
 	/* establish the actual sizes of the nasid masks */
 	if (rp->SAL_version == 1) {
-		/* SAL_version 1 didn't set the nasids_size field */
-		rp->nasids_size = 128;
+		/* SAL_version 1 didn't set the SAL_nasids_size field */
+		rp->SAL_nasids_size = 128;
 	}
-	xp_nasid_mask_bytes = rp->nasids_size;
-	xp_nasid_mask_words = xp_nasid_mask_bytes / 8;
+	xp_sizeof_nasid_mask = rp->SAL_nasids_size;
 
 	/* setup the pointers to the various items in the reserved page */
 	xpc_part_nasids = XPC_RP_PART_NASIDS(rp);
@@ -211,78 +194,70 @@ xpc_rsvd_page_init(void)
 	xpc_vars_part = XPC_RP_VARS_PART(rp);
 
 	/*
-	 * Before clearing xpc_vars, see if a page of AMOs had been previously
-	 * allocated. If not we'll need to allocate one and set permissions
-	 * so that cross-partition AMOs are allowed.
+	 * Before clearing xpc_vars, see if a page (or pages) of AMOs had been
+	 * previously allocated. If not we'll need to allocate one (or more)
+	 * and set permissions so that cross-partition AMOs are allowed.
 	 *
-	 * The allocated AMO page needs MCA reporting to remain disabled after
+	 * The allocated AMO page(s) need MCA reporting to remain disabled after
 	 * XPC has unloaded.  To make this work, we keep a copy of the pointer
-	 * to this page (i.e., amos_page) in the struct xpc_vars structure,
-	 * which is pointed to by the reserved page, and re-use that saved copy
-	 * on subsequent loads of XPC. This AMO page is never freed, and its
-	 * memory protections are never restricted.
+	 * to this page (or pages) in the struct xpc_vars structure (i.e.,
+	 * amos_page), which is pointed to by the reserved page, and re-use
+	 * that saved copy on subsequent loads of XPC. This AMO page is never
+	 * freed, and its memory protections are never restricted.
 	 */
 	if ((amos_page = xpc_vars->amos_page) == NULL) {
-		amos_page = (AMO_t *) TO_AMO(uncached_alloc_page(0));
+		n_amos = xpc_number_of_amos(XP_NPARTITIONS);
+		amos_page = xp_alloc_amos(n_amos);
 		if (amos_page == NULL) {
 			dev_err(xpc_part, "can't allocate page of AMOs\n");
 			return NULL;
 		}
 
 		/*
-		 * Open up AMO-R/W to cpu.  This is done for Shub 1.1 systems
-		 * when xpc_allow_IPI_ops() is called via xpc_hb_init().
-		 */
-		if (!enable_shub_wars_1_1()) {
-			ret = sn_change_memprotect(ia64_tpa((u64) amos_page),
-					PAGE_SIZE, SN_MEMPROT_ACCESS_CLASS_1,
-					&nasid_array);
-			if (ret != 0) {
-				dev_err(xpc_part, "can't change memory "
-					"protections\n");
-				uncached_free_page(__IA64_UNCACHED_OFFSET |
-						   TO_PHYS((u64) amos_page));
-				return NULL;
-			}
-		}
-	} else if (!IS_AMO_ADDRESS((u64) amos_page)) {
-		/*
-		 * EFI's XPBOOT can also set amos_page in the reserved page,
-		 * but it happens to leave it as an uncached physical address
-		 * and we need it to be an uncached virtual, so we'll have to
-		 * convert it.
+		 * Open up AMO-R/W to cpu. This is done for Shub 1.1 systems
+		 * when xp_allow_IPI_ops() is called via xpc_init().
 		 */
-		if (!IS_AMO_PHYS_ADDRESS((u64) amos_page)) {
-			dev_err(xpc_part, "previously used amos_page address "
-				"is bad = 0x%p\n", (void *) amos_page);
+		ret = xp_change_memprotect(xp_pa((u64)amos_page),
+					   n_amos * xp_sizeof_amo,
+					   XP_MEMPROT_ALLOW_CPU_AMO,
+					   &nasid_array);
+		if (ret != xpSuccess) {
+			dev_err(xpc_part, "can't change memory protections\n");
+			xp_free_amos(amos_page, n_amos);
 			return NULL;
 		}
-		amos_page = (AMO_t *) TO_AMO((u64) amos_page);
 	}
 
 	/* clear xpc_vars */
 	memset(xpc_vars, 0, sizeof(struct xpc_vars));
 
 	xpc_vars->version = XPC_V_VERSION;
-	xpc_vars->act_nasid = cpuid_to_nasid(0);
+	xpc_vars->partid = xp_partition_id;
+	xpc_vars->npartitions = XP_NPARTITIONS;
+	xpc_vars->act_nasid = xp_cpu_to_nasid(0);
 	xpc_vars->act_phys_cpuid = cpu_physical_id(0);
 	xpc_vars->vars_part_pa = __pa(xpc_vars_part);
-	xpc_vars->amos_page_pa = ia64_tpa((u64) amos_page);
+	xpc_vars->amos_page_pa = xp_pa((u64)amos_page);
 	xpc_vars->amos_page = amos_page;  /* save for next load of XPC */
 
 
 	/* clear xpc_vars_part */
-	memset((u64 *) xpc_vars_part, 0, sizeof(struct xpc_vars_part) *
-							XP_MAX_PARTITIONS);
+	memset((u64 *)xpc_vars_part, 0, sizeof(struct xpc_vars_part) *
+							XP_NPARTITIONS);
 
 	/* initialize the activate IRQ related AMO variables */
-	for (i = 0; i < xp_nasid_mask_words; i++) {
-		(void) xpc_IPI_init(XPC_ACTIVATE_IRQ_AMOS + i);
+	activate_irq_amos = xpc_activate_irq_amos(XP_NPARTITIONS);
+	for (i = 0; i < xp_nasid_mask_words(); i++) {
+		(void)xpc_IPI_init(activate_irq_amos + i);
 	}
 
 	/* initialize the engaged remote partitions related AMO variables */
-	(void) xpc_IPI_init(XPC_ENGAGED_PARTITIONS_AMO);
-	(void) xpc_IPI_init(XPC_DISENGAGE_REQUEST_AMO);
+	engaged_partitions_amos = xpc_engaged_partitions_amos(XP_NPARTITIONS);
+	disengage_request_amos = xpc_disengage_request_amos(XP_NPARTITIONS);
+	for (i = 0; i < xp_partid_mask_words(XP_NPARTITIONS); i++) {
+		(void)xpc_IPI_init(engaged_partitions_amos + i);
+		(void)xpc_IPI_init(disengage_request_amos + i);
+	}
 
 	/* timestamp of when reserved page was setup by XPC */
 	rp->stamp = CURRENT_TIME;
@@ -298,118 +273,6 @@ xpc_rsvd_page_init(void)
 
 
 /*
- * Change protections to allow IPI operations (and AMO operations on
- * Shub 1.1 systems).
- */
-void
-xpc_allow_IPI_ops(void)
-{
-	int node;
-	int nasid;
-
-
-	// >>> Change SH_IPI_ACCESS code to use SAL call once it is available.
-
-	if (is_shub2()) {
-		xpc_sh2_IPI_access0 =
-			(u64) HUB_L((u64 *) LOCAL_MMR_ADDR(SH2_IPI_ACCESS0));
-		xpc_sh2_IPI_access1 =
-			(u64) HUB_L((u64 *) LOCAL_MMR_ADDR(SH2_IPI_ACCESS1));
-		xpc_sh2_IPI_access2 =
-			(u64) HUB_L((u64 *) LOCAL_MMR_ADDR(SH2_IPI_ACCESS2));
-		xpc_sh2_IPI_access3 =
-			(u64) HUB_L((u64 *) LOCAL_MMR_ADDR(SH2_IPI_ACCESS3));
-
-		for_each_online_node(node) {
-			nasid = cnodeid_to_nasid(node);
-			HUB_S((u64 *) GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS0),
-								-1UL);
-			HUB_S((u64 *) GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS1),
-								-1UL);
-			HUB_S((u64 *) GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS2),
-								-1UL);
-			HUB_S((u64 *) GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS3),
-								-1UL);
-		}
-
-	} else {
-		xpc_sh1_IPI_access =
-			(u64) HUB_L((u64 *) LOCAL_MMR_ADDR(SH1_IPI_ACCESS));
-
-		for_each_online_node(node) {
-			nasid = cnodeid_to_nasid(node);
-			HUB_S((u64 *) GLOBAL_MMR_ADDR(nasid, SH1_IPI_ACCESS),
-								-1UL);
-
-			/*
-			 * Since the BIST collides with memory operations on
-			 * SHUB 1.1 sn_change_memprotect() cannot be used.
-			 */
-			if (enable_shub_wars_1_1()) {
-				/* open up everything */
-				xpc_prot_vec[node] = (u64) HUB_L((u64 *)
-						GLOBAL_MMR_ADDR(nasid,
-						SH1_MD_DQLP_MMR_DIR_PRIVEC0));
-				HUB_S((u64 *) GLOBAL_MMR_ADDR(nasid,
-						SH1_MD_DQLP_MMR_DIR_PRIVEC0),
-								-1UL);
-				HUB_S((u64 *) GLOBAL_MMR_ADDR(nasid,
-						SH1_MD_DQRP_MMR_DIR_PRIVEC0),
-								-1UL);
-			}
-		}
-	}
-}
-
-
-/*
- * Restrict protections to disallow IPI operations (and AMO operations on
- * Shub 1.1 systems).
- */
-void
-xpc_restrict_IPI_ops(void)
-{
-	int node;
-	int nasid;
-
-
-	// >>> Change SH_IPI_ACCESS code to use SAL call once it is available.
-
-	if (is_shub2()) {
-
-		for_each_online_node(node) {
-			nasid = cnodeid_to_nasid(node);
-			HUB_S((u64 *) GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS0),
-							xpc_sh2_IPI_access0);
-			HUB_S((u64 *) GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS1),
-							xpc_sh2_IPI_access1);
-			HUB_S((u64 *) GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS2),
-							xpc_sh2_IPI_access2);
-			HUB_S((u64 *) GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS3),
-							xpc_sh2_IPI_access3);
-		}
-
-	} else {
-
-		for_each_online_node(node) {
-			nasid = cnodeid_to_nasid(node);
-			HUB_S((u64 *) GLOBAL_MMR_ADDR(nasid, SH1_IPI_ACCESS),
-							xpc_sh1_IPI_access);
-
-			if (enable_shub_wars_1_1()) {
-				HUB_S((u64 *) GLOBAL_MMR_ADDR(nasid,
-						SH1_MD_DQLP_MMR_DIR_PRIVEC0),
-							xpc_prot_vec[node]);
-				HUB_S((u64 *) GLOBAL_MMR_ADDR(nasid,
-						SH1_MD_DQRP_MMR_DIR_PRIVEC0),
-							xpc_prot_vec[node]);
-			}
-		}
-	}
-}
-
-
-/*
  * At periodic intervals, scan through all active partitions and ensure
  * their heartbeat is still active.  If not, the partition is deactivated.
  */
@@ -418,51 +281,49 @@ xpc_check_remote_hb(void)
 {
 	struct xpc_vars *remote_vars;
 	struct xpc_partition *part;
-	partid_t partid;
-	bte_result_t bres;
+	short partid;
+	enum xp_retval ret;
 
 
 	remote_vars = (struct xpc_vars *) xpc_remote_copy_buffer;
 
-	for (partid = 1; partid < XP_MAX_PARTITIONS; partid++) {
+	for (partid = XP_MIN_PARTID; partid <= XP_MAX_PARTID; partid++) {
 
 		if (xpc_exiting) {
 			break;
 		}
 
-		if (partid == sn_partition_id) {
+		if (partid == xp_partition_id) {
 			continue;
 		}
 
 		part = &xpc_partitions[partid];
 
-		if (part->act_state == XPC_P_INACTIVE ||
-				part->act_state == XPC_P_DEACTIVATING) {
+		if (part->act_state == XPC_P_AS_INACTIVE ||
+				part->act_state == XPC_P_AS_DEACTIVATING) {
 			continue;
 		}
 
 		/* pull the remote_hb cache line */
-		bres = xp_bte_copy(part->remote_vars_pa,
-					(u64) remote_vars,
-					XPC_RP_VARS_SIZE,
-					(BTE_NOTIFY | BTE_WACQUIRE), NULL);
-		if (bres != BTE_SUCCESS) {
-			XPC_DEACTIVATE_PARTITION(part,
-						xpc_map_bte_errors(bres));
+		ret = xp_remote_memcpy(remote_vars,
+				       (void *)part->remote_vars_pa,
+				       XPC_RP_VARS_SIZE);
+		if (ret != xpSuccess) {
+			XPC_DEACTIVATE_PARTITION(part, ret);
 			continue;
 		}
 
-		dev_dbg(xpc_part, "partid = %d, heartbeat = %ld, last_heartbeat"
-			" = %ld, heartbeat_offline = %ld, HB_mask = 0x%lx\n",
-			partid, remote_vars->heartbeat, part->last_heartbeat,
-			remote_vars->heartbeat_offline,
-			remote_vars->heartbeating_to_mask);
+		dev_dbg(xpc_part, "partid = %d, heartbeat = %" U64_ELL "d, "
+			"last_heartbeat = %" U64_ELL "d, heartbeat_offline = %"
+			U64_ELL "d\n", partid,
+			remote_vars->heartbeat, part->last_heartbeat,
+			remote_vars->heartbeat_offline);
 
 		if (((remote_vars->heartbeat == part->last_heartbeat) &&
 			(remote_vars->heartbeat_offline == 0)) ||
-			     !xpc_hb_allowed(sn_partition_id, remote_vars)) {
+			     !xpc_hb_allowed(xp_partition_id, remote_vars)) {
 
-			XPC_DEACTIVATE_PARTITION(part, xpcNoHeartbeat);
+			XPC_DEACTIVATE_PARTITION(part, xpNoHeartbeat);
 			continue;
 		}
 
@@ -478,27 +339,27 @@ xpc_check_remote_hb(void)
  * is large enough to contain a copy of their reserved page header and
  * part_nasids mask.
  */
-static enum xpc_retval
+static enum xp_retval
 xpc_get_remote_rp(int nasid, u64 *discovered_nasids,
 		struct xpc_rsvd_page *remote_rp, u64 *remote_rp_pa)
 {
-	int bres, i;
+	int i;
+	enum xp_retval ret;
 
 
 	/* get the reserved page's physical address */
 
 	*remote_rp_pa = xpc_get_rsvd_page_pa(nasid);
 	if (*remote_rp_pa == 0) {
-		return xpcNoRsvdPageAddr;
+		return xpNoRsvdPageAddr;
 	}
 
 
 	/* pull over the reserved page header and part_nasids mask */
-	bres = xp_bte_copy(*remote_rp_pa, (u64) remote_rp,
-				XPC_RP_HEADER_SIZE + xp_nasid_mask_bytes,
-				(BTE_NOTIFY | BTE_WACQUIRE), NULL);
-	if (bres != BTE_SUCCESS) {
-		return xpc_map_bte_errors(bres);
+	ret = xp_remote_memcpy(remote_rp, (void *)*remote_rp_pa,
+			       XPC_RP_HEADER_SIZE + xp_sizeof_nasid_mask);
+	if (ret != xpSuccess) {
+		return ret;
 	}
 
 
@@ -506,30 +367,17 @@ xpc_get_remote_rp(int nasid, u64 *discov
 		u64 *remote_part_nasids = XPC_RP_PART_NASIDS(remote_rp);
 
 
-		for (i = 0; i < xp_nasid_mask_words; i++) {
+		for (i = 0; i < xp_nasid_mask_words(); i++) {
 			discovered_nasids[i] |= remote_part_nasids[i];
 		}
 	}
 
-
-	/* check that the partid is for another partition */
-
-	if (remote_rp->partid < 1 ||
-				remote_rp->partid > (XP_MAX_PARTITIONS - 1)) {
-		return xpcInvalidPartid;
-	}
-
-	if (remote_rp->partid == sn_partition_id) {
-		return xpcLocalPartid;
-	}
-
-
 	if (XPC_VERSION_MAJOR(remote_rp->version) !=
 					XPC_VERSION_MAJOR(XPC_RP_VERSION)) {
-		return xpcBadVersion;
+		return xpBadVersion;
 	}
 
-	return xpcSuccess;
+	return xpSuccess;
 }
 
 
@@ -539,29 +387,35 @@ xpc_get_remote_rp(int nasid, u64 *discov
  * remote_vars points to a buffer that is cacheline aligned for BTE copies and
  * assumed to be of size XPC_RP_VARS_SIZE.
  */
-static enum xpc_retval
+static enum xp_retval
 xpc_get_remote_vars(u64 remote_vars_pa, struct xpc_vars *remote_vars)
 {
-	int bres;
-
+	enum xp_retval ret;
 
 	if (remote_vars_pa == 0) {
-		return xpcVarsNotSet;
+		return xpVarsNotSet;
 	}
 
 	/* pull over the cross partition variables */
-	bres = xp_bte_copy(remote_vars_pa, (u64) remote_vars, XPC_RP_VARS_SIZE,
-				(BTE_NOTIFY | BTE_WACQUIRE), NULL);
-	if (bres != BTE_SUCCESS) {
-		return xpc_map_bte_errors(bres);
+	ret = xp_remote_memcpy(remote_vars, (void *)remote_vars_pa,
+			       XPC_RP_VARS_SIZE);
+	if (ret != xpSuccess) {
+		return ret;
 	}
 
 	if (XPC_VERSION_MAJOR(remote_vars->version) !=
 					XPC_VERSION_MAJOR(XPC_V_VERSION)) {
-		return xpcBadVersion;
+		return xpBadVersion;
 	}
 
-	return xpcSuccess;
+	/* check that the partid is for another partition */
+	if (remote_vars->partid < XP_MIN_PARTID ||
+	    remote_vars->partid > XP_MAX_PARTID)
+		return xpInvalidPartid;
+	if (remote_vars->partid == xp_partition_id)
+		return xpLocalPartid;
+
+	return xpSuccess;
 }
 
 
@@ -582,18 +436,23 @@ xpc_update_partition_info(struct xpc_par
 		part->remote_rp_stamp.tv_sec, part->remote_rp_stamp.tv_nsec);
 
 	part->remote_rp_pa = remote_rp_pa;
-	dev_dbg(xpc_part, "  remote_rp_pa = 0x%016lx\n", part->remote_rp_pa);
+	dev_dbg(xpc_part, "  remote_rp_pa = 0x%016" U64_ELL "x\n",
+		part->remote_rp_pa);
+
+	part->remote_npartitions = remote_vars->npartitions;
+	dev_dbg(xpc_part, "  remote_npartitions = %d\n",
+		part->remote_npartitions);
 
 	part->remote_vars_pa = remote_vars_pa;
-	dev_dbg(xpc_part, "  remote_vars_pa = 0x%016lx\n",
+	dev_dbg(xpc_part, "  remote_vars_pa = 0x%016" U64_ELL "x\n",
 		part->remote_vars_pa);
 
 	part->last_heartbeat = remote_vars->heartbeat;
-	dev_dbg(xpc_part, "  last_heartbeat = 0x%016lx\n",
+	dev_dbg(xpc_part, "  last_heartbeat = 0x%016" U64_ELL "x\n",
 		part->last_heartbeat);
 
 	part->remote_vars_part_pa = remote_vars->vars_part_pa;
-	dev_dbg(xpc_part, "  remote_vars_part_pa = 0x%016lx\n",
+	dev_dbg(xpc_part, "  remote_vars_part_pa = 0x%016" U64_ELL "x\n",
 		part->remote_vars_part_pa);
 
 	part->remote_act_nasid = remote_vars->act_nasid;
@@ -605,7 +464,7 @@ xpc_update_partition_info(struct xpc_par
 		part->remote_act_phys_cpuid);
 
 	part->remote_amos_page_pa = remote_vars->amos_page_pa;
-	dev_dbg(xpc_part, "  remote_amos_page_pa = 0x%lx\n",
+	dev_dbg(xpc_part, "  remote_amos_page_pa = 0x%" U64_ELL "x\n",
 		part->remote_amos_page_pa);
 
 	part->remote_vars_version = remote_vars->version;
@@ -639,9 +498,9 @@ xpc_identify_act_IRQ_req(int nasid)
 	int reactivate = 0;
 	int stamp_diff;
 	struct timespec remote_rp_stamp = { 0, 0 };
-	partid_t partid;
+	short partid;
 	struct xpc_partition *part;
-	enum xpc_retval ret;
+	enum xp_retval ret;
 
 
 	/* pull over the reserved page structure */
@@ -649,7 +508,7 @@ xpc_identify_act_IRQ_req(int nasid)
 	remote_rp = (struct xpc_rsvd_page *) xpc_remote_copy_buffer;
 
 	ret = xpc_get_remote_rp(nasid, NULL, remote_rp, &remote_rp_pa);
-	if (ret != xpcSuccess) {
+	if (ret != xpSuccess) {
 		dev_warn(xpc_part, "unable to get reserved page from nasid %d, "
 			"which sent interrupt, reason=%d\n", nasid, ret);
 		return;
@@ -660,40 +519,36 @@ xpc_identify_act_IRQ_req(int nasid)
 	if (XPC_SUPPORTS_RP_STAMP(remote_rp_version)) {
 		remote_rp_stamp = remote_rp->stamp;
 	}
-	partid = remote_rp->partid;
-	part = &xpc_partitions[partid];
-
 
 	/* pull over the cross partition variables */
 
 	remote_vars = (struct xpc_vars *) xpc_remote_copy_buffer;
 
 	ret = xpc_get_remote_vars(remote_vars_pa, remote_vars);
-	if (ret != xpcSuccess) {
-
+	if (ret != xpSuccess) {
 		dev_warn(xpc_part, "unable to get XPC variables from nasid %d, "
 			"which sent interrupt, reason=%d\n", nasid, ret);
-
-		XPC_DEACTIVATE_PARTITION(part, ret);
 		return;
 	}
 
+	partid = remote_vars->partid;
+	part = &xpc_partitions[partid];
 
 	part->act_IRQ_rcvd++;
 
 	dev_dbg(xpc_part, "partid for nasid %d is %d; IRQs = %d; HB = "
-		"%ld:0x%lx\n", (int) nasid, (int) partid, part->act_IRQ_rcvd,
-		remote_vars->heartbeat, remote_vars->heartbeating_to_mask);
+		"%" U64_ELL "d\n", (int) nasid, (int) partid,
+		part->act_IRQ_rcvd, remote_vars->heartbeat);
 
 	if (xpc_partition_disengaged(part) &&
-					part->act_state == XPC_P_INACTIVE) {
+					part->act_state == XPC_P_AS_INACTIVE) {
 
 		xpc_update_partition_info(part, remote_rp_version,
 					&remote_rp_stamp, remote_rp_pa,
 					remote_vars_pa, remote_vars);
 
 		if (XPC_SUPPORTS_DISENGAGE_REQUEST(part->remote_vars_version)) {
-			if (xpc_partition_disengage_requested(1UL << partid)) {
+			if (xpc_partition_disengage_requested(partid)) {
 				/*
 				 * Other side is waiting on us to disengage,
 				 * even though we already have.
@@ -702,7 +557,7 @@ xpc_identify_act_IRQ_req(int nasid)
 			}
 		} else {
 			/* other side doesn't support disengage requests */
-			xpc_clear_partition_disengage_request(1UL << partid);
+			xpc_clear_partition_disengage_request(partid);
 		}
 
 		xpc_activate_partition(part);
@@ -722,7 +577,7 @@ xpc_identify_act_IRQ_req(int nasid)
 			/* see if the other side rebooted */
 			if (part->remote_amos_page_pa ==
 				remote_vars->amos_page_pa &&
-					xpc_hb_allowed(sn_partition_id,
+					xpc_hb_allowed(xp_partition_id,
 								remote_vars)) {
 				/* doesn't look that way, so ignore the IPI */
 				return;
@@ -738,7 +593,7 @@ xpc_identify_act_IRQ_req(int nasid)
 						&remote_rp_stamp, remote_rp_pa,
 						remote_vars_pa, remote_vars);
 		part->reactivate_nasid = nasid;
-		XPC_DEACTIVATE_PARTITION(part, xpcReactivating);
+		XPC_DEACTIVATE_PARTITION(part, xpReactivating);
 		return;
 	}
 
@@ -752,8 +607,8 @@ xpc_identify_act_IRQ_req(int nasid)
 		 * disengage request, but the new one doesn't.
 		 */
 
-		xpc_clear_partition_engaged(1UL << partid);
-		xpc_clear_partition_disengage_request(1UL << partid);
+		xpc_clear_partition_engaged(partid);
+		xpc_clear_partition_disengage_request(partid);
 
 		xpc_update_partition_info(part, remote_rp_version,
 						&remote_rp_stamp, remote_rp_pa,
@@ -773,9 +628,8 @@ xpc_identify_act_IRQ_req(int nasid)
 			 * the disengage request, as does the new one.
 			 */
 
-			DBUG_ON(xpc_partition_engaged(1UL << partid));
-			DBUG_ON(xpc_partition_disengage_requested(1UL <<
-								partid));
+			DBUG_ON(xpc_partition_engaged(partid));
+			DBUG_ON(xpc_partition_disengage_requested(partid));
 
 			xpc_update_partition_info(part, remote_rp_version,
 						&remote_rp_stamp, remote_rp_pa,
@@ -792,11 +646,11 @@ xpc_identify_act_IRQ_req(int nasid)
 
 	if (reactivate) {
 		part->reactivate_nasid = nasid;
-		XPC_DEACTIVATE_PARTITION(part, xpcReactivating);
+		XPC_DEACTIVATE_PARTITION(part, xpReactivating);
 
 	} else if (XPC_SUPPORTS_DISENGAGE_REQUEST(part->remote_vars_version) &&
-			xpc_partition_disengage_requested(1UL << partid)) {
-		XPC_DEACTIVATE_PARTITION(part, xpcOtherGoingDown);
+			xpc_partition_disengage_requested(partid)) {
+		XPC_DEACTIVATE_PARTITION(part, xpOtherGoingDown);
 	}
 }
 
@@ -811,50 +665,54 @@ xpc_identify_act_IRQ_req(int nasid)
 int
 xpc_identify_act_IRQ_sender(void)
 {
-	int word, bit;
+	enum xp_retval ret;
+	int w_index, b_index;
+	u64 *amo_va;
 	u64 nasid_mask;
 	u64 nasid;			/* remote nasid */
 	int n_IRQs_detected = 0;
-	AMO_t *act_amos;
-
 
-	act_amos = xpc_vars->amos_page + XPC_ACTIVATE_IRQ_AMOS;
+	amo_va = (u64 *)((u64)xpc_vars->amos_page +
+				xpc_activate_irq_amos(xpc_vars->npartitions) *
+				xp_sizeof_amo);
 
 
-	/* scan through act AMO variable looking for non-zero entries */
-	for (word = 0; word < xp_nasid_mask_words; word++) {
+	/* scan through activation AMO variables looking for non-zero entries */
+	for (w_index = 0; w_index < xp_nasid_mask_words(); w_index++) {
 
 		if (xpc_exiting) {
 			break;
 		}
 
-		nasid_mask = xpc_IPI_receive(&act_amos[word]);
+		ret = xp_get_amo(amo_va, XP_AMO_CLEAR, &nasid_mask);
+		BUG_ON(ret != xpSuccess);  /* should never happen */
+		amo_va = (u64 *)((u64)amo_va + xp_sizeof_amo);  /* next amo */
 		if (nasid_mask == 0) {
 			/* no IRQs from nasids in this variable */
 			continue;
 		}
 
-		dev_dbg(xpc_part, "AMO[%d] gave back 0x%lx\n", word,
-			nasid_mask);
+		dev_dbg(xpc_part, "AMO[%d] gave back 0x%" U64_ELL "x\n",
+			w_index, nasid_mask);
 
 
 		/*
-		 * If this nasid has been added to the machine since
-		 * our partition was reset, this will retain the
-		 * remote nasid in our reserved pages machine mask.
+		 * If any nasid(s) in mask have been added to the machine
+		 * since our partition was reset, this will retain the
+		 * remote nasid(s) in our reserved pages machine mask.
 		 * This is used in the event of module reload.
 		 */
-		xpc_mach_nasids[word] |= nasid_mask;
+		xpc_mach_nasids[w_index] |= nasid_mask;
 
 
 		/* locate the nasid(s) which sent interrupts */
 
-		for (bit = 0; bit < (8 * sizeof(u64)); bit++) {
-			if (nasid_mask & (1UL << bit)) {
+		for (b_index = 0; b_index < BITS_PER_LONG; b_index++) {
+			if (nasid_mask & (1UL << b_index)) {
 				n_IRQs_detected++;
-				nasid = XPC_NASID_FROM_W_B(word, bit);
-				dev_dbg(xpc_part, "interrupt from nasid %ld\n",
-					nasid);
+				nasid = (w_index * BITS_PER_LONG + b_index) * 2;
+				dev_dbg(xpc_part, "interrupt from nasid %"
+					U64_ELL "d\n", nasid);
 				xpc_identify_act_IRQ_req(nasid);
 			}
 		}
@@ -870,11 +728,11 @@ xpc_identify_act_IRQ_sender(void)
 int
 xpc_partition_disengaged(struct xpc_partition *part)
 {
-	partid_t partid = XPC_PARTID(part);
+	short partid = XPC_PARTID(part);
 	int disengaged;
 
 
-	disengaged = (xpc_partition_engaged(1UL << partid) == 0);
+	disengaged = (xpc_partition_engaged(partid) == 0);
 	if (part->disengage_request_timeout) {
 		if (!disengaged) {
 			if (jiffies < part->disengage_request_timeout) {
@@ -890,7 +748,7 @@ xpc_partition_disengaged(struct xpc_part
 			dev_info(xpc_part, "disengage from remote partition %d "
 				"timed out\n", partid);
 			xpc_disengage_request_timedout = 1;
-			xpc_clear_partition_engaged(1UL << partid);
+			xpc_clear_partition_engaged(partid);
 			disengaged = 1;
 		}
 		part->disengage_request_timeout = 0;
@@ -901,9 +759,9 @@ xpc_partition_disengaged(struct xpc_part
 						      disengage_request_timer);
 		}
 
-		DBUG_ON(part->act_state != XPC_P_DEACTIVATING &&
-					part->act_state != XPC_P_INACTIVE);
-		if (part->act_state != XPC_P_INACTIVE) {
+		DBUG_ON(part->act_state != XPC_P_AS_DEACTIVATING &&
+					part->act_state != XPC_P_AS_INACTIVE);
+		if (part->act_state != XPC_P_AS_INACTIVE) {
 			xpc_wakeup_channel_mgr(part);
 		}
 
@@ -918,24 +776,24 @@ xpc_partition_disengaged(struct xpc_part
 /*
  * Mark specified partition as active.
  */
-enum xpc_retval
+enum xp_retval
 xpc_mark_partition_active(struct xpc_partition *part)
 {
 	unsigned long irq_flags;
-	enum xpc_retval ret;
+	enum xp_retval ret;
 
 
 	dev_dbg(xpc_part, "setting partition %d to ACTIVE\n", XPC_PARTID(part));
 
-	spin_lock_irqsave(&part->act_lock, irq_flags);
-	if (part->act_state == XPC_P_ACTIVATING) {
-		part->act_state = XPC_P_ACTIVE;
-		ret = xpcSuccess;
+	spin_lock_irqsave(&part->lock, irq_flags);
+	if (part->act_state == XPC_P_AS_ACTIVATING) {
+		part->act_state = XPC_P_AS_ACTIVE;
+		ret = xpSuccess;
 	} else {
-		DBUG_ON(part->reason == xpcSuccess);
+		DBUG_ON(part->reason == xpSuccess);
 		ret = part->reason;
 	}
-	spin_unlock_irqrestore(&part->act_lock, irq_flags);
+	spin_unlock_irqrestore(&part->lock, irq_flags);
 
 	return ret;
 }
@@ -946,35 +804,35 @@ xpc_mark_partition_active(struct xpc_par
  */
 void
 xpc_deactivate_partition(const int line, struct xpc_partition *part,
-				enum xpc_retval reason)
+				enum xp_retval reason)
 {
 	unsigned long irq_flags;
 
 
-	spin_lock_irqsave(&part->act_lock, irq_flags);
+	spin_lock_irqsave(&part->lock, irq_flags);
 
-	if (part->act_state == XPC_P_INACTIVE) {
+	if (part->act_state == XPC_P_AS_INACTIVE) {
 		XPC_SET_REASON(part, reason, line);
-		spin_unlock_irqrestore(&part->act_lock, irq_flags);
-		if (reason == xpcReactivating) {
+		spin_unlock_irqrestore(&part->lock, irq_flags);
+		if (reason == xpReactivating) {
 			/* we interrupt ourselves to reactivate partition */
 			xpc_IPI_send_reactivate(part);
 		}
 		return;
 	}
-	if (part->act_state == XPC_P_DEACTIVATING) {
-		if ((part->reason == xpcUnloading && reason != xpcUnloading) ||
-					reason == xpcReactivating) {
+	if (part->act_state == XPC_P_AS_DEACTIVATING) {
+		if ((part->reason == xpUnloading && reason != xpUnloading) ||
+					reason == xpReactivating) {
 			XPC_SET_REASON(part, reason, line);
 		}
-		spin_unlock_irqrestore(&part->act_lock, irq_flags);
+		spin_unlock_irqrestore(&part->lock, irq_flags);
 		return;
 	}
 
-	part->act_state = XPC_P_DEACTIVATING;
+	part->act_state = XPC_P_AS_DEACTIVATING;
 	XPC_SET_REASON(part, reason, line);
 
-	spin_unlock_irqrestore(&part->act_lock, irq_flags);
+	spin_unlock_irqrestore(&part->lock, irq_flags);
 
 	if (XPC_SUPPORTS_DISENGAGE_REQUEST(part->remote_vars_version)) {
 		xpc_request_partition_disengage(part);
@@ -1007,14 +865,60 @@ xpc_mark_partition_inactive(struct xpc_p
 	dev_dbg(xpc_part, "setting partition %d to INACTIVE\n",
 		XPC_PARTID(part));
 
-	spin_lock_irqsave(&part->act_lock, irq_flags);
-	part->act_state = XPC_P_INACTIVE;
-	spin_unlock_irqrestore(&part->act_lock, irq_flags);
+	spin_lock_irqsave(&part->lock, irq_flags);
+	part->act_state = XPC_P_AS_INACTIVE;
+	spin_unlock_irqrestore(&part->lock, irq_flags);
 	part->remote_rp_pa = 0;
 }
 
 
 /*
+ * Register the remote partition's AMOs so any errors within that address
+ * range can be handled and cleaned up should the remote partition go down.
+ */
+enum xp_retval
+xpc_register_remote_amos(struct xpc_partition *part)
+{
+	unsigned long irq_flags;
+	size_t len;
+	enum xp_retval ret;
+
+	if (part->flags & XPC_P_RAMOSREGISTERED)
+		return xpSuccess;
+
+	len = xpc_number_of_amos(part->remote_npartitions) * xp_sizeof_amo;
+	ret = xp_register_remote_amos(part->remote_amos_page_pa, len);
+	if (ret == xpSuccess) {
+		spin_lock_irqsave(&part->lock, irq_flags);
+		part->flags |= XPC_P_RAMOSREGISTERED;
+		spin_unlock_irqrestore(&part->lock, irq_flags);
+	}
+	return ret;
+}
+
+void
+xpc_unregister_remote_amos(struct xpc_partition *part)
+{
+	unsigned long irq_flags;
+	size_t len;
+	enum xp_retval ret;
+
+	if (!(part->flags & XPC_P_RAMOSREGISTERED))
+		return;
+
+	len = xpc_number_of_amos(part->remote_npartitions) * xp_sizeof_amo;
+	ret = xp_unregister_remote_amos(part->remote_amos_page_pa, len);
+	if (ret != xpSuccess)
+		dev_warn(xpc_part, "failed to unregister remote AMOs for "
+			 "partition %d, ret=%d\n", XPC_PARTID(part), ret);
+
+	spin_lock_irqsave(&part->lock, irq_flags);
+	part->flags &= ~XPC_P_RAMOSREGISTERED;
+	spin_unlock_irqrestore(&part->lock, irq_flags);
+}
+
+
+/*
  * SAL has provided a partition and machine mask.  The partition mask
  * contains a bit for each even nasid in our partition.  The machine
  * mask contains a bit for each even nasid in the entire machine.
@@ -1036,23 +940,23 @@ xpc_discovery(void)
 	int max_regions;
 	int nasid;
 	struct xpc_rsvd_page *rp;
-	partid_t partid;
+	short partid;
 	struct xpc_partition *part;
 	u64 *discovered_nasids;
-	enum xpc_retval ret;
+	enum xp_retval ret;
 
 
 	remote_rp = xpc_kmalloc_cacheline_aligned(XPC_RP_HEADER_SIZE +
-						xp_nasid_mask_bytes,
-						GFP_KERNEL, &remote_rp_base);
+						  xp_sizeof_nasid_mask,
+						  GFP_KERNEL, &remote_rp_base);
 	if (remote_rp == NULL) {
 		return;
 	}
 	remote_vars = (struct xpc_vars *) remote_rp;
 
 
-	discovered_nasids = kzalloc(sizeof(u64) * xp_nasid_mask_words,
-							GFP_KERNEL);
+	discovered_nasids = kzalloc(sizeof(u64) * xp_nasid_mask_words(),
+				    GFP_KERNEL);
 	if (discovered_nasids == NULL) {
 		kfree(remote_rp_base);
 		return;
@@ -1066,7 +970,7 @@ xpc_discovery(void)
 	 * protection is in regards to memory, IOI and IPI.
 	 */
 	max_regions = 64;
-	region_size = sn_region_size;
+	region_size = xp_region_size;
 
 	switch (region_size) {
 	case 128:
@@ -1124,61 +1028,50 @@ xpc_discovery(void)
 
 			ret = xpc_get_remote_rp(nasid, discovered_nasids,
 					      remote_rp, &remote_rp_pa);
-			if (ret != xpcSuccess) {
+			if (ret != xpSuccess) {
 				dev_dbg(xpc_part, "unable to get reserved page "
 					"from nasid %d, reason=%d\n", nasid,
 					ret);
-
-				if (ret == xpcLocalPartid) {
-					break;
-				}
 				continue;
 			}
 
 			remote_vars_pa = remote_rp->vars_pa;
 
-			partid = remote_rp->partid;
-			part = &xpc_partitions[partid];
-
-
 			/* pull over the cross partition variables */
 
 			ret = xpc_get_remote_vars(remote_vars_pa, remote_vars);
-			if (ret != xpcSuccess) {
+			if (ret != xpSuccess) {
 				dev_dbg(xpc_part, "unable to get XPC variables "
 					"from nasid %d, reason=%d\n", nasid,
 					ret);
-
-				XPC_DEACTIVATE_PARTITION(part, ret);
+				if (ret == xpLocalPartid)
+					break;
 				continue;
 			}
 
-			if (part->act_state != XPC_P_INACTIVE) {
+			partid = remote_vars->partid;
+			part = &xpc_partitions[partid];
+
+			if (part->act_state != XPC_P_AS_INACTIVE) {
 				dev_dbg(xpc_part, "partition %d on nasid %d is "
 					"already activating\n", partid, nasid);
 				break;
 			}
 
 			/*
-			 * Register the remote partition's AMOs with SAL so it
-			 * can handle and cleanup errors within that address
-			 * range should the remote partition go down. We don't
-			 * unregister this range because it is difficult to
-			 * tell when outstanding writes to the remote partition
-			 * are finished and thus when it is thus safe to
-			 * unregister. This should not result in wasted space
-			 * in the SAL xp_addr_region table because we should
-			 * get the same page for remote_act_amos_pa after
-			 * module reloads and system reboots.
+			 * Register the remote partition's AMOs so any errors
+			 * within that address range can be handled and
+			 * cleaned up should the remote partition go down.
 			 */
-			if (sn_register_xp_addr_region(
-					    remote_vars->amos_page_pa,
-							PAGE_SIZE, 1) < 0) {
-				dev_dbg(xpc_part, "partition %d failed to "
-					"register xp_addr region 0x%016lx\n",
-					partid, remote_vars->amos_page_pa);
+			part->remote_npartitions = remote_vars->npartitions;
+			part->remote_amos_page_pa = remote_vars->amos_page_pa;
+			ret = xpc_register_remote_amos(part);
+			if (ret != xpSuccess) {
+				dev_warn(xpc_part, "xpc_discovery() failed to "
+					"register remote AMOs for partition %d,"
+					"ret=%d\n", partid, ret);
 
-				XPC_SET_REASON(part, xpcPhysAddrRegFailed,
+				XPC_SET_REASON(part, xpPhysAddrRegFailed,
 						__LINE__);
 				break;
 			}
@@ -1188,8 +1081,8 @@ xpc_discovery(void)
 			 * Send an interrupt to that nasid to notify
 			 * it that we are ready to begin activation.
 			 */
-			dev_dbg(xpc_part, "sending an interrupt to AMO 0x%lx, "
-				"nasid %d, phys_cpuid 0x%x\n",
+			dev_dbg(xpc_part, "sending an interrupt to AMO 0x%"
+				U64_ELL "x, nasid %d, phys_cpuid 0x%x\n",
 				remote_vars->amos_page_pa,
 				remote_vars->act_nasid,
 				remote_vars->act_phys_cpuid);
@@ -1214,26 +1107,23 @@ xpc_discovery(void)
  * Given a partid, get the nasids owned by that partition from the
  * remote partition's reserved page.
  */
-enum xpc_retval
-xpc_initiate_partid_to_nasids(partid_t partid, void *nasid_mask)
+enum xp_retval
+xpc_initiate_partid_to_nasids(short partid, void *nasid_mask)
 {
 	struct xpc_partition *part;
 	u64 part_nasid_pa;
-	int bte_res;
 
 
 	part = &xpc_partitions[partid];
 	if (part->remote_rp_pa == 0) {
-		return xpcPartitionDown;
+		return xpPartitionDown;
 	}
 
-	memset(nasid_mask, 0, XP_NASID_MASK_BYTES);
+	memset(nasid_mask, 0, xp_sizeof_nasid_mask);
 
 	part_nasid_pa = (u64) XPC_RP_PART_NASIDS(part->remote_rp_pa);
 
-	bte_res = xp_bte_copy(part_nasid_pa, (u64) nasid_mask,
-			xp_nasid_mask_bytes, (BTE_NOTIFY | BTE_WACQUIRE), NULL);
-
-	return xpc_map_bte_errors(bte_res);
+	return xp_remote_memcpy(nasid_mask, (void *)part_nasid_pa,
+				xp_sizeof_nasid_mask);
 }
 
Index: linux-2.6/drivers/misc/xp/xpnet.c
===================================================================
--- linux-2.6.orig/drivers/misc/xp/xpnet.c	2008-03-26 10:40:03.160341945 -0500
+++ linux-2.6/drivers/misc/xp/xpnet.c	2008-03-26 10:40:10.713261900 -0500
@@ -3,7 +3,7 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  *
- * Copyright (C) 1999,2001-2005 Silicon Graphics, Inc. All rights reserved.
+ * Copyright (C) 1999,2001-2008 Silicon Graphics, Inc. All rights reserved.
  */
 
 
@@ -33,12 +33,9 @@
 #include <linux/mii.h>
 #include <linux/smp.h>
 #include <linux/string.h>
-#include <asm/sn/bte.h>
-#include <asm/sn/io.h>
-#include <asm/sn/sn_sal.h>
 #include <asm/types.h>
 #include <asm/atomic.h>
-#include <asm/sn/xp.h>
+#include "xp.h"
 
 
 /*
@@ -110,7 +107,6 @@ struct xpnet_message {
  * then be released.
  */
 struct xpnet_pending_msg {
-	struct list_head free_list;
 	struct sk_buff *skb;
 	atomic_t use_count;
 };
@@ -126,7 +122,7 @@ struct net_device *xpnet_device;
  * When we are notified of other partitions activating, we add them to
  * our bitmask of partitions to which we broadcast.
  */
-static u64 xpnet_broadcast_partitions;
+static u64 xpnet_broadcast_partitions[BITS_TO_LONGS(XP_NPARTITIONS)];
 /* protect above */
 static DEFINE_SPINLOCK(xpnet_broadcast_lock);
 
@@ -147,17 +143,14 @@ static DEFINE_SPINLOCK(xpnet_broadcast_l
 
 
 /*
- * The partition id is encapsulated in the MAC address.  The following
- * define locates the octet the partid is in.
+ * The partid is encapsulated in the MAC address beginning in the following
+ * octet.
  */
-#define XPNET_PARTID_OCTET	1
-#define XPNET_LICENSE_OCTET	2
+#define XPNET_PARTID_OCTET	2	/* consists of 2 octets total */
 
 
-/*
- * Define the XPNET debug device structure that is to be used with dev_dbg(),
- * dev_err(), dev_warn(), and dev_info().
- */
+/* Define the XPNET debug device structures to be used with dev_dbg() et al */
+
 struct device_driver xpnet_dbg_name = {
 	.name = "xpnet"
 };
@@ -173,10 +166,10 @@ struct device *xpnet = &xpnet_dbg_subnam
  * Packet was recevied by XPC and forwarded to us.
  */
 static void
-xpnet_receive(partid_t partid, int channel, struct xpnet_message *msg)
+xpnet_receive(short partid, int channel, struct xpnet_message *msg)
 {
 	struct sk_buff *skb;
-	bte_result_t bret;
+	enum xp_retval ret;
 	struct xpnet_dev_private *priv =
 		(struct xpnet_dev_private *) xpnet_device->priv;
 
@@ -191,8 +184,8 @@ xpnet_receive(partid_t partid, int chann
 
 		return;
 	}
-	dev_dbg(xpnet, "received 0x%lx, %d, %d, %d\n", msg->buf_pa, msg->size,
-		msg->leadin_ignore, msg->tailout_ignore);
+	dev_dbg(xpnet, "received 0x%" U64_ELL "x, %d, %d, %d\n", msg->buf_pa,
+		msg->size, msg->leadin_ignore, msg->tailout_ignore);
 
 
 	/* reserve an extra cache line */
@@ -239,19 +232,21 @@ xpnet_receive(partid_t partid, int chann
 			(void *)__pa((u64)skb->data & ~(L1_CACHE_BYTES - 1)),
 			msg->size);
 
-		bret = bte_copy(msg->buf_pa,
-				__pa((u64)skb->data & ~(L1_CACHE_BYTES - 1)),
-				msg->size, (BTE_NOTIFY | BTE_WACQUIRE), NULL);
-
-		if (bret != BTE_SUCCESS) {
-			// >>> Need better way of cleaning skb.  Currently skb
-			// >>> appears in_use and we can't just call
-			// >>> dev_kfree_skb.
-			dev_err(xpnet, "bte_copy(0x%p, 0x%p, 0x%hx) returned "
-				"error=0x%x\n", (void *)msg->buf_pa,
+		ret = xp_remote_memcpy((void *)((u64)skb->data &
+				       ~(L1_CACHE_BYTES - 1)),
+					(void *)msg->buf_pa, msg->size);
+
+		if (ret != xpSuccess) {
+			/*
+			 * >>> Need better way of cleaning skb.  Currently skb
+			 * >>> appears in_use and we can't just call
+			 * >>> dev_kfree_skb.
+			 */
+			dev_err(xpnet, "xp_remote_memcpy(0x%p, 0x%p, 0x%hx) "
+				"returned error=0x%x\n",
 				(void *)__pa((u64)skb->data &
-							~(L1_CACHE_BYTES - 1)),
-				msg->size, bret);
+				~(L1_CACHE_BYTES - 1)),
+				(void *)msg->buf_pa, msg->size, ret);
 
 			xpc_received(partid, channel, (void *) msg);
 
@@ -290,50 +285,43 @@ xpnet_receive(partid_t partid, int chann
  * state or message reception on a connection.
  */
 static void
-xpnet_connection_activity(enum xpc_retval reason, partid_t partid, int channel,
+xpnet_connection_activity(enum xp_retval reason, short partid, int channel,
 			  void *data, void *key)
 {
-	long bp;
-
-
-	DBUG_ON(partid <= 0 || partid >= XP_MAX_PARTITIONS);
+	DBUG_ON(partid < XP_MIN_PARTID || partid > XP_MAX_PARTID);
 	DBUG_ON(channel != XPC_NET_CHANNEL);
 
 	switch(reason) {
-	case xpcMsgReceived:	/* message received */
+	case xpMsgReceived:	/* message received */
 		DBUG_ON(data == NULL);
 
 		xpnet_receive(partid, channel, (struct xpnet_message *) data);
 		break;
 
-	case xpcConnected:	/* connection completed to a partition */
+	case xpConnected:	/* connection completed to a partition */
 		spin_lock_bh(&xpnet_broadcast_lock);
-		xpnet_broadcast_partitions |= 1UL << (partid -1 );
-		bp = xpnet_broadcast_partitions;
+		__set_bit(partid, xpnet_broadcast_partitions);
 		spin_unlock_bh(&xpnet_broadcast_lock);
 
 		netif_carrier_on(xpnet_device);
 
-		dev_dbg(xpnet, "%s connection created to partition %d; "
-			"xpnet_broadcast_partitions=0x%lx\n",
-			xpnet_device->name, partid, bp);
+		dev_dbg(xpnet, "%s connected to partition %d\n",
+			xpnet_device->name, partid);
 		break;
 
 	default:
 		spin_lock_bh(&xpnet_broadcast_lock);
-		xpnet_broadcast_partitions &= ~(1UL << (partid -1 ));
-		bp = xpnet_broadcast_partitions;
+		__clear_bit(partid, xpnet_broadcast_partitions);
 		spin_unlock_bh(&xpnet_broadcast_lock);
 
-		if (bp == 0) {
+		if (bitmap_empty((unsigned long *)xpnet_broadcast_partitions,
+				 XP_NPARTITIONS)) {
 			netif_carrier_off(xpnet_device);
 		}
 
-		dev_dbg(xpnet, "%s disconnected from partition %d; "
-			"xpnet_broadcast_partitions=0x%lx\n",
-			xpnet_device->name, partid, bp);
+		dev_dbg(xpnet, "%s disconnected from partition %d\n",
+			xpnet_device->name, partid);
 		break;
-
 	}
 }
 
@@ -341,18 +329,18 @@ xpnet_connection_activity(enum xpc_retva
 static int
 xpnet_dev_open(struct net_device *dev)
 {
-	enum xpc_retval ret;
+	enum xp_retval ret;
 
 
-	dev_dbg(xpnet, "calling xpc_connect(%d, 0x%p, NULL, %ld, %ld, %ld, "
-		"%ld)\n", XPC_NET_CHANNEL, xpnet_connection_activity,
-		XPNET_MSG_SIZE, XPNET_MSG_NENTRIES, XPNET_MAX_KTHREADS,
-		XPNET_MAX_IDLE_KTHREADS);
+	dev_dbg(xpnet, "calling xpc_connect(%d, 0x%p, NULL, %" U64_ELL "d, %"
+		U64_ELL "d, %" U64_ELL "d, %" U64_ELL "d)\n", XPC_NET_CHANNEL,
+		xpnet_connection_activity, XPNET_MSG_SIZE, XPNET_MSG_NENTRIES,
+		XPNET_MAX_KTHREADS, XPNET_MAX_IDLE_KTHREADS);
 
 	ret = xpc_connect(XPC_NET_CHANNEL, xpnet_connection_activity, NULL,
 			  XPNET_MSG_SIZE, XPNET_MSG_NENTRIES,
 			  XPNET_MAX_KTHREADS, XPNET_MAX_IDLE_KTHREADS);
-	if (ret != xpcSuccess) {
+	if (ret != xpSuccess) {
 		dev_err(xpnet, "ifconfig up of %s failed on XPC connect, "
 			"ret=%d\n", dev->name, ret);
 
@@ -425,7 +413,7 @@ xpnet_dev_get_stats(struct net_device *d
  * release the skb and then release our pending message structure.
  */
 static void
-xpnet_send_completed(enum xpc_retval reason, partid_t partid, int channel,
+xpnet_send_completed(enum xp_retval reason, short partid, int channel,
 			void *__qm)
 {
 	struct xpnet_pending_msg *queued_msg =
@@ -447,30 +435,67 @@ xpnet_send_completed(enum xpc_retval rea
 }
 
 
+static void
+xpnet_send(struct sk_buff *skb, struct xpnet_pending_msg *queued_msg,
+	   u64 start_addr, u64 end_addr, u16 embedded_bytes, int dest_partid)
+{
+	struct xpnet_message *msg;
+	enum xp_retval ret;
+
+
+	ret = xpc_allocate(dest_partid, XPC_NET_CHANNEL, XPC_NOWAIT,
+			   (void **)&msg);
+	if (unlikely(ret != xpSuccess))
+		return;
+
+	msg->embedded_bytes = embedded_bytes;
+	if (unlikely(embedded_bytes != 0)) {
+		msg->version = XPNET_VERSION_EMBED;
+		dev_dbg(xpnet, "calling memcpy(0x%p, 0x%p, 0x%lx)\n",
+			&msg->data, skb->data, (size_t)embedded_bytes);
+		skb_copy_from_linear_data(skb, &msg->data,
+					  (size_t)embedded_bytes);
+	} else {
+		msg->version = XPNET_VERSION;
+	}
+	msg->magic = XPNET_MAGIC;
+	msg->size = end_addr - start_addr;
+	msg->leadin_ignore = (u64)skb->data - start_addr;
+	msg->tailout_ignore = end_addr - (u64)skb_tail_pointer(skb);
+	msg->buf_pa = __pa(start_addr);
+
+	dev_dbg(xpnet, "sending XPC message to %d:%d\n"
+		KERN_DEBUG "msg->buf_pa=0x%" U64_ELL "x, msg->size=%u, "
+		"msg->leadin_ignore=%u, msg->tailout_ignore=%u\n",
+		dest_partid, XPC_NET_CHANNEL, msg->buf_pa, msg->size,
+		msg->leadin_ignore, msg->tailout_ignore);
+
+	atomic_inc(&queued_msg->use_count);
+
+	ret = xpc_send_notify(dest_partid, XPC_NET_CHANNEL, msg,
+			      xpnet_send_completed, queued_msg);
+	if (unlikely(ret != xpSuccess))
+		atomic_dec(&queued_msg->use_count);
+}
+
+
 /*
  * Network layer has formatted a packet (skb) and is ready to place it
  * "on the wire".  Prepare and send an xpnet_message to all partitions
  * which have connected with us and are targets of this packet.
  *
  * MAC-NOTE:  For the XPNET driver, the MAC address contains the
- * destination partition_id.  If the destination partition id word
- * is 0xff, this packet is to broadcast to all partitions.
+ * destination partid.  If the destination partid octets are 0xffff,
+ * this packet is to broadcast to all connected partitions.
  */
 static int
 xpnet_dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct xpnet_pending_msg *queued_msg;
-	enum xpc_retval ret;
-	struct xpnet_message *msg;
 	u64 start_addr, end_addr;
-	long dp;
-	u8 second_mac_octet;
-	partid_t dest_partid;
-	struct xpnet_dev_private *priv;
-	u16 embedded_bytes;
-
-
-	priv = (struct xpnet_dev_private *) dev->priv;
+	short dest_partid;
+	struct xpnet_dev_private *priv = (struct xpnet_dev_private *)dev->priv;
+	u16 embedded_bytes = 0;
 
 
 	dev_dbg(xpnet, ">skb->head=0x%p skb->data=0x%p skb->tail=0x%p "
@@ -478,6 +503,11 @@ xpnet_dev_hard_start_xmit(struct sk_buff
 		(void *)skb->data, skb_tail_pointer(skb), skb_end_pointer(skb),
 		skb->len);
 
+	/* >>> What does 0x33 represent? ifconfig makes it happen */
+	if (skb->data[0] == 0x33) {
+		dev_kfree_skb(skb);
+		return 0;	/* nothing needed to be done */
+	}
 
 	/*
 	 * The xpnet_pending_msg tracks how many outstanding
@@ -500,7 +530,6 @@ xpnet_dev_hard_start_xmit(struct sk_buff
 	end_addr = L1_CACHE_ALIGN((u64)skb_tail_pointer(skb));
 
 	/* calculate how many bytes to embed in the XPC message */
-	embedded_bytes = 0;
 	if (unlikely(skb->len <= XPNET_MSG_DATA_MAX)) {
 		/* skb->data does fit so embed */
 		embedded_bytes = skb->len;
@@ -517,89 +546,27 @@ xpnet_dev_hard_start_xmit(struct sk_buff
 	atomic_set(&queued_msg->use_count, 1);
 	queued_msg->skb = skb;
 
-
-	second_mac_octet = skb->data[XPNET_PARTID_OCTET];
-	if (second_mac_octet == 0xff) {
+	if (skb->data[0] == 0xff) {
 		/* we are being asked to broadcast to all partitions */
-		dp = xpnet_broadcast_partitions;
-	} else if (second_mac_octet != 0) {
-		dp = xpnet_broadcast_partitions &
-					(1UL << (second_mac_octet - 1));
-	} else {
-		/* 0 is an invalid partid.  Ignore */
-		dp = 0;
-	}
-	dev_dbg(xpnet, "destination Partitions mask (dp) = 0x%lx\n", dp);
-
-	/*
-	 * If we wanted to allow promiscuous mode to work like an
-	 * unswitched network, this would be a good point to OR in a
-	 * mask of partitions which should be receiving all packets.
-	 */
-
-	/*
-	 * Main send loop.
-	 */
-	for (dest_partid = 1; dp && dest_partid < XP_MAX_PARTITIONS;
-	     dest_partid++) {
-
-
-		if (!(dp & (1UL << (dest_partid - 1)))) {
-			/* not destined for this partition */
-			continue;
-		}
-
-		/* remove this partition from the destinations mask */
-		dp &= ~(1UL << (dest_partid - 1));
-
-
-		/* found a partition to send to */
-
-		ret = xpc_allocate(dest_partid, XPC_NET_CHANNEL,
-				   XPC_NOWAIT, (void **)&msg);
-		if (unlikely(ret != xpcSuccess)) {
-			continue;
+		for_each_bit(dest_partid,
+			     (unsigned long *)xpnet_broadcast_partitions,
+							XP_NPARTITIONS) {
+			xpnet_send(skb, queued_msg, start_addr, end_addr,
+				   embedded_bytes, dest_partid);
 		}
+	} else {
+		dest_partid = (short)skb->data[XPNET_PARTID_OCTET + 1];
+		dest_partid |= (short)skb->data[XPNET_PARTID_OCTET + 0] << 8;
 
-		msg->embedded_bytes = embedded_bytes;
-		if (unlikely(embedded_bytes != 0)) {
-			msg->version = XPNET_VERSION_EMBED;
-			dev_dbg(xpnet, "calling memcpy(0x%p, 0x%p, 0x%lx)\n",
-				&msg->data, skb->data, (size_t) embedded_bytes);
-			skb_copy_from_linear_data(skb, &msg->data,
-						  (size_t)embedded_bytes);
-		} else {
-			msg->version = XPNET_VERSION;
-		}
-		msg->magic = XPNET_MAGIC;
-		msg->size = end_addr - start_addr;
-		msg->leadin_ignore = (u64) skb->data - start_addr;
-		msg->tailout_ignore = end_addr - (u64)skb_tail_pointer(skb);
-		msg->buf_pa = __pa(start_addr);
-
-		dev_dbg(xpnet, "sending XPC message to %d:%d\n"
-			KERN_DEBUG "msg->buf_pa=0x%lx, msg->size=%u, "
-			"msg->leadin_ignore=%u, msg->tailout_ignore=%u\n",
-			dest_partid, XPC_NET_CHANNEL, msg->buf_pa, msg->size,
-			msg->leadin_ignore, msg->tailout_ignore);
-
-
-		atomic_inc(&queued_msg->use_count);
-
-		ret = xpc_send_notify(dest_partid, XPC_NET_CHANNEL, msg,
-				      xpnet_send_completed, queued_msg);
-		if (unlikely(ret != xpcSuccess)) {
-			atomic_dec(&queued_msg->use_count);
-			continue;
+		if (dest_partid >= XP_MIN_PARTID &&
+		    dest_partid <= XP_MAX_PARTID &&
+		    test_bit(dest_partid, xpnet_broadcast_partitions) != 0) {
+			xpnet_send(skb, queued_msg, start_addr, end_addr,
+				   embedded_bytes, dest_partid);
 		}
-
 	}
 
 	if (atomic_dec_return(&queued_msg->use_count) == 0) {
-		dev_dbg(xpnet, "no partitions to receive packet destined for "
-			"%d\n", dest_partid);
-
-
 		dev_kfree_skb(skb);
 		kfree(queued_msg);
 	}
@@ -615,7 +582,7 @@ xpnet_dev_hard_start_xmit(struct sk_buff
  * Deal with transmit timeouts coming from the network layer.
  */
 static void
-xpnet_dev_tx_timeout (struct net_device *dev)
+xpnet_dev_tx_timeout(struct net_device *dev)
 {
 	struct xpnet_dev_private *priv;
 
@@ -630,12 +597,11 @@ xpnet_dev_tx_timeout (struct net_device 
 static int __init
 xpnet_init(void)
 {
-	int i;
-	u32 license_num;
+	short partid;
 	int result = -ENOMEM;
 
 
-	if (!ia64_platform_is("sn2")) {
+	if (!is_shub() && !is_uv()) {
 		return -ENODEV;
 	}
 
@@ -667,14 +633,12 @@ xpnet_init(void)
 	 * MAC addresses.  We chose the first octet of the MAC to be unlikely
 	 * to collide with any vendor's officially issued MAC.
 	 */
-	xpnet_device->dev_addr[0] = 0xfe;
-	xpnet_device->dev_addr[XPNET_PARTID_OCTET] = sn_partition_id;
-	license_num = sn_partition_serial_number_val();
-	for (i = 3; i >= 0; i--) {
-		xpnet_device->dev_addr[XPNET_LICENSE_OCTET + i] =
-							license_num & 0xff;
-		license_num = license_num >> 8;
-	}
+	xpnet_device->dev_addr[0] = 0x02;  /* locally administered, no OUI */
+
+	partid = xp_partition_id;
+
+	xpnet_device->dev_addr[XPNET_PARTID_OCTET + 1] = partid & 0xff;
+	xpnet_device->dev_addr[XPNET_PARTID_OCTET + 0] |= (partid >> 8) & 0xff;
 
 	/*
 	 * ether_setup() sets this to a multicast device.  We are
Index: linux-2.6/drivers/misc/xp/Makefile
===================================================================
--- linux-2.6.orig/drivers/misc/xp/Makefile	2008-03-26 10:40:03.160341945 -0500
+++ linux-2.6/drivers/misc/xp/Makefile	2008-03-26 10:40:10.737264824 -0500
@@ -3,7 +3,10 @@
 #
 
 obj-$(CONFIG_SGI_XP)		+= xp.o
-xp-y				:= xp_main.o xp_nofault.o
+xp-y				:= xp_main.o xp_uv.o
+xp-$(CONFIG_IA64)		+= xp_sn2.o xp_nofault.o
+
 obj-$(CONFIG_SGI_XP)		+= xpc.o
 xpc-y				:= xpc_main.o xpc_channel.o xpc_partition.o
+
 obj-$(CONFIG_SGI_XP)		+= xpnet.o
Index: linux-2.6/drivers/misc/xp/xp_nofault.S
===================================================================
--- linux-2.6.orig/drivers/misc/xp/xp_nofault.S	2008-03-26 10:40:03.160341945 -0500
+++ linux-2.6/drivers/misc/xp/xp_nofault.S	2008-03-26 10:40:10.761267747 -0500
@@ -3,7 +3,7 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  *
- * Copyright (c) 2004-2007 Silicon Graphics, Inc.  All Rights Reserved.
+ * Copyright (c) 2004-2008 Silicon Graphics, Inc.  All Rights Reserved.
  */
 
 
Index: linux-2.6/include/asm-ia64/sn/bte.h
===================================================================
--- linux-2.6.orig/include/asm-ia64/sn/bte.h	2008-03-26 10:40:03.160341945 -0500
+++ linux-2.6/include/asm-ia64/sn/bte.h	2008-03-26 10:40:10.789271158 -0500
@@ -3,7 +3,7 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  *
- * Copyright (c) 2000-2007 Silicon Graphics, Inc.  All Rights Reserved.
+ * Copyright (c) 2000-2008 Silicon Graphics, Inc.  All Rights Reserved.
  */
 
 
@@ -177,9 +177,6 @@ typedef enum {
 #define BTE_GET_ERROR_STATUS(_status)					\
 	(BTE_SHUB2_ERROR(_status) & ~IBLS_ERROR)
 
-#define BTE_VALID_SH2_ERROR(value)					\
-	((value >= BTEFAIL_SH2_RESP_SHORT) && (value <= BTEFAIL_SH2_ALL))
-
 /*
  * Structure defining a bte.  An instance of this
  * structure is created in the nodepda for each
Index: linux-2.6/drivers/misc/xp/xp_uv.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/drivers/misc/xp/xp_uv.c	2008-03-26 10:40:10.809273595 -0500
@@ -0,0 +1,194 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ */
+
+/*
+ * Cross Partition (XP) uv-based functions.
+ *
+ *	Architecture specific implementation of common functions.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/device.h>
+#include "xp.h"
+
+extern struct device *xp;
+
+static enum xp_retval
+xp_register_nofault_code_uv(void)
+{
+	return xpSuccess;
+}
+
+static void
+xp_unregister_nofault_code_uv(void)
+{
+}
+
+static enum xp_retval
+xp_remote_memcpy_uv(void *vdst, const void *psrc, size_t len)
+{
+	/* >>> this function needs fleshing out */
+	return xpUnsupported;
+}
+
+static enum xp_retval
+xp_register_remote_amos_uv(u64 paddr, size_t len)
+{
+	/* >>> this function needs fleshing out */
+	return xpUnsupported;
+}
+
+static enum xp_retval
+xp_unregister_remote_amos_uv(u64 paddr, size_t len)
+{
+	/* >>> this function needs fleshing out */
+	return xpUnsupported;
+}
+
+/*
+ * Allocate the required number of contiguous physical pages to hold the
+ * specified number of AMOs.
+ */
+static u64 *
+xp_alloc_amos_uv(int n_amos)
+{
+	size_t n_bytes = roundup(n_amos * xp_sizeof_amo, PAGE_SIZE);
+	struct page *page;
+	u64 *amos_page = NULL;
+
+	page = alloc_pages_node(0, GFP_KERNEL | __GFP_ZERO | GFP_THISNODE,
+				get_order(n_bytes));
+	if (page)
+		amos_page = (u64 *)page_address(page);
+
+	return amos_page;
+}
+
+static void
+xp_free_amos_uv(u64 *amos_page, int n_amos)
+{
+	size_t n_bytes = roundup(n_amos * xp_sizeof_amo, PAGE_SIZE);
+
+	free_pages((u64)amos_page, get_order(n_bytes));
+}
+
+static enum xp_retval
+xp_set_amo_uv(u64 *amo_va, int op, u64 operand, int remote)
+{
+	/* >>> this function needs fleshing out */
+	return xpUnsupported;
+}
+
+static enum xp_retval
+xp_set_amo_with_interrupt_uv(u64 *amo_va, int op, u64 operand, int remote,
+			     int nasid, int phys_cpuid, int vector)
+{
+	/* >>> this function needs fleshing out */
+	return xpUnsupported;
+}
+
+static enum xp_retval
+xp_get_amo_uv(u64 *amo_va, int op, u64 *amo_value_addr)
+{
+	/* >>> this function needs fleshing out */
+	return xpUnsupported;
+}
+
+static enum xp_retval
+xp_get_partition_rsvd_page_pa_uv(u64 buf, u64 *cookie, u64 *paddr, size_t *len)
+{
+	/* >>> this function needs fleshing out */
+	return xpUnsupported;
+}
+
+static enum xp_retval
+xp_change_memprotect_uv(u64 paddr, size_t len, int request, u64 *nasid_array)
+{
+	/* >>> this function needs fleshing out */
+	return xpUnsupported;
+}
+
+static void
+xp_change_memprotect_shub_wars_1_1_uv(int request)
+{
+	return;
+}
+
+static void
+xp_allow_IPI_ops_uv(void)
+{
+	/* >>> this function needs fleshing out */
+	return;
+}
+
+static void
+xp_disallow_IPI_ops_uv(void)
+{
+	/* >>> this function needs fleshing out */
+	return;
+}
+
+static int
+xp_cpu_to_nasid_uv(int cpuid)
+{
+	/* >>> this function needs fleshing out */
+	return -1;
+}
+
+static int
+xp_node_to_nasid_uv(int nid)
+{
+	/* >>> this function needs fleshing out */
+	return -1;
+}
+
+enum xp_retval
+xp_init_uv(void)
+{
+	BUG_ON(!is_uv());
+
+	xp_partition_id = 0;		/* >>> not correct value */
+	xp_region_size = 0;		/* >>> not correct value */
+	xp_rtc_cycles_per_second = 0;	/* >>> not correct value */
+
+	xp_remote_memcpy = xp_remote_memcpy_uv;
+
+	xp_register_remote_amos = xp_register_remote_amos_uv;
+	xp_unregister_remote_amos = xp_unregister_remote_amos_uv;
+
+	xp_sizeof_amo = sizeof(u64);
+	xp_alloc_amos = xp_alloc_amos_uv;
+	xp_free_amos = xp_free_amos_uv;
+	xp_set_amo = xp_set_amo_uv;
+	xp_set_amo_with_interrupt = xp_set_amo_with_interrupt_uv;
+	xp_get_amo = xp_get_amo_uv;
+
+	xp_get_partition_rsvd_page_pa = xp_get_partition_rsvd_page_pa_uv;
+
+	xp_change_memprotect = xp_change_memprotect_uv;
+	xp_change_memprotect_shub_wars_1_1 =
+				xp_change_memprotect_shub_wars_1_1_uv;
+	xp_allow_IPI_ops = xp_allow_IPI_ops_uv;
+	xp_disallow_IPI_ops = xp_disallow_IPI_ops_uv;
+
+	xp_cpu_to_nasid = xp_cpu_to_nasid_uv;
+	xp_node_to_nasid = xp_node_to_nasid_uv;
+
+	return xp_register_nofault_code_uv();
+}
+
+void
+xp_exit_uv(void)
+{
+	BUG_ON(!is_uv());
+
+	xp_unregister_nofault_code_uv();
+}
+
Index: linux-2.6/arch/ia64/sn/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/ia64/sn/kernel/setup.c	2008-03-26 10:40:03.164342433 -0500
+++ linux-2.6/arch/ia64/sn/kernel/setup.c	2008-03-26 10:40:10.833276518 -0500
@@ -3,7 +3,7 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  *
- * Copyright (C) 1999,2001-2006 Silicon Graphics, Inc. All rights reserved.
+ * Copyright (C) 1999,2001-2008 Silicon Graphics, Inc. All rights reserved.
  */
 
 #include <linux/module.h>
@@ -93,7 +93,7 @@ u8 sn_region_size;
 EXPORT_SYMBOL(sn_region_size);
 int sn_prom_type;	/* 0=hardware, 1=medusa/realprom, 2=medusa/fakeprom */
 
-short physical_node_map[MAX_NUMALINK_NODES];
+short physical_node_map[SN_MAX_NUMALINK_NODES];
 static unsigned long sn_prom_features[MAX_PROM_FEATURE_SETS];
 
 EXPORT_SYMBOL(physical_node_map);
Index: linux-2.6/include/asm-ia64/sn/arch.h
===================================================================
--- linux-2.6.orig/include/asm-ia64/sn/arch.h	2008-03-26 10:40:03.164342433 -0500
+++ linux-2.6/include/asm-ia64/sn/arch.h	2008-03-26 10:40:10.857279442 -0500
@@ -5,7 +5,7 @@
  *
  * SGI specific setup.
  *
- * Copyright (C) 1995-1997,1999,2001-2005 Silicon Graphics, Inc.  All rights reserved.
+ * Copyright (C) 1995-1997,1999,2001-2005,2008 Silicon Graphics, Inc.  All rights reserved.
  * Copyright (C) 1999 Ralf Baechle (ralf@gnu.org)
  */
 #ifndef _ASM_IA64_SN_ARCH_H
@@ -42,7 +42,7 @@
  * This value is also the value of the maximum number of NASIDs in the numalink
  * fabric.
  */
-#define MAX_NUMALINK_NODES	16384
+#define SN_MAX_NUMALINK_NODES	16384
 
 /*
  * The following defines attributes of the HUB chip. These attributes are
@@ -60,6 +60,7 @@ DECLARE_PER_CPU(struct sn_hub_info_s, __
 #define sn_hub_info 	(&__get_cpu_var(__sn_hub_info))
 #define is_shub2()	(sn_hub_info->shub2)
 #define is_shub1()	(sn_hub_info->shub2 == 0)
+#define is_shub()	(is_shub1() || is_shub2())
 
 /*
  * Use this macro to test if shub 1.1 wars should be enabled
Index: linux-2.6/drivers/misc/xp/xp_sn2.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/drivers/misc/xp/xp_sn2.c	2008-03-26 10:42:14.804380923 -0500
@@ -0,0 +1,487 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ */
+
+/*
+ * Cross Partition (XP) sn2-based functions.
+ *
+ *	Architecture specific implementation of common functions.
+ */
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <asm/uncached.h>
+#include <asm/sn/intr.h>
+#include <asm/sn/bte.h>
+#include <asm/sn/clksupport.h>
+#include <asm/sn/mspec.h>
+#include <asm/sn/sn_sal.h>
+#include "xp.h"
+
+extern struct device *xp;
+
+/*
+ * Register a nofault code region which performs a cross-partition PIO read.
+ * If the PIO read times out, the MCA handler will consume the error and
+ * return to a kernel-provided instruction to indicate an error. This PIO read
+ * exists because it is guaranteed to timeout if the destination is down
+ * (AMO operations do not timeout on at least some CPUs on Shubs <= v1.2,
+ * which unfortunately we have to work around).
+ */
+static enum xp_retval
+xp_register_nofault_code_sn2(void)
+{
+	int ret;
+	u64 func_addr;
+	u64 err_func_addr;
+
+	func_addr = *(u64 *)xp_nofault_PIOR;
+	err_func_addr = *(u64 *)xp_error_PIOR;
+	ret = sn_register_nofault_code(func_addr, err_func_addr, err_func_addr,
+				       1, 1);
+	if (ret != 0) {
+		dev_err(xp, "can't register nofault code, error=%d\n", ret);
+		return xpSalError;
+	}
+	/*
+	 * Setup the nofault PIO read target. (There is no special reason why
+	 * SH_IPI_ACCESS was selected.)
+	 */
+	if (is_shub1())
+		xp_nofault_PIOR_target = SH1_IPI_ACCESS;
+	else if (is_shub2())
+		xp_nofault_PIOR_target = SH2_IPI_ACCESS0;
+
+	return xpSuccess;
+}
+
+void
+xp_unregister_nofault_code_sn2(void)
+{
+	u64 func_addr = *(u64 *)xp_nofault_PIOR;
+	u64 err_func_addr = *(u64 *)xp_error_PIOR;
+
+	/* unregister the PIO read nofault code region */
+	(void)sn_register_nofault_code(func_addr, err_func_addr,
+					err_func_addr, 1, 0);
+}
+
+/*
+ * Wrapper for bte_copy().
+ *
+ *	vdst - virtual address of the destination of the transfer.
+ *	psrc - physical address of the source of the transfer.
+ *	len - number of bytes to transfer from source to destination.
+ *
+ * Note: xp_remote_memcpy_sn2() should never be called while holding a spinlock.
+ */
+static enum xp_retval
+xp_remote_memcpy_sn2(void *vdst, const void *psrc, size_t len)
+{
+	bte_result_t ret;
+	u64 pdst = ia64_tpa(vdst);
+	/* >>> What are the rules governing the src and dst addresses passed in?
+	 * >>> Currently we're assuming that dst is a virtual address and src
+	 * >>> is a physical address, is this appropriate? Can we allow them to
+	 * >>> be whatever and we make the change here without damaging the
+	 * >>> addresses?
+	 */
+
+	/*
+	 * Ensure that the physically mapped memory is contiguous.
+	 *
+	 * We do this by ensuring that the memory is from region 7 only.
+	 * If the need should arise to use memory from one of the other
+	 * regions, then modify the BUG_ON() statement to ensure that the
+	 * memory from that region is always physically contiguous.
+	 */
+	BUG_ON(REGION_NUMBER(vdst) != RGN_KERNEL);
+
+	ret = bte_copy((u64)psrc, pdst, len, (BTE_NOTIFY | BTE_WACQUIRE), NULL);
+	if (ret == BTE_SUCCESS)
+		return xpSuccess;
+
+	if (is_shub2())
+		dev_err(xp, "bte_copy() on shub2 failed, error=0x%x\n", ret);
+	else
+		dev_err(xp, "bte_copy() failed, error=%d\n", ret);
+
+	return xpBteCopyError;
+}
+
+/*
+ * Register the remote partition's AMOs with SAL so it can handle and cleanup
+ * errors within that address range should the remote partition go down. We
+ * don't unregister this range because it is difficult to tell when outstanding
+ * writes to the remote partition are finished and thus when it is safe to
+ * unregister. This should not result in wasted space in the SAL xp_addr_region
+ * table because we should get the same page for remote_amos_page_pa after
+ * module reloads and system reboots.
+ */
+static enum xp_retval
+xp_register_remote_amos_sn2(u64 paddr, size_t len)
+{
+	enum xp_retval ret = xpSuccess;
+
+	if (sn_register_xp_addr_region(paddr, len, 1) < 0)
+		ret = xpSalError;
+	return ret;
+}
+
+static enum xp_retval
+xp_unregister_remote_amos_sn2(u64 paddr, size_t len)
+{
+	return xpSuccess;	/* we don't unregister AMOs on sn2 */
+}
+
+/*
+ * Allocate the required number of contiguous physical pages to hold the
+ * specified number of AMOs.
+ */
+static u64 *
+xp_alloc_amos_sn2(int n_amos)
+{
+	int n_pages = DIV_ROUND_UP(n_amos * xp_sizeof_amo, PAGE_SIZE);
+
+	return (u64 *)TO_AMO(uncached_alloc_page(0, n_pages));
+}
+
+static void
+xp_free_amos_sn2(u64 *amos_page, int n_amos)
+{
+	int n_pages = DIV_ROUND_UP(n_amos * xp_sizeof_amo, PAGE_SIZE);
+
+	uncached_free_page(__IA64_UNCACHED_OFFSET | TO_PHYS((u64) amos_page),
+			   n_pages);
+}
+
+
+static enum xp_retval
+xp_set_amo_sn2(u64 *amo_va, int op, u64 operand, int remote)
+{
+	unsigned long irq_flags = irq_flags; /* eliminate compiler warning */
+	int ret = xpSuccess;
+	/* >>> eliminate remote arg and xp_nofault_PIOR() call */
+
+	if (op == XP_AMO_AND)
+		op = FETCHOP_AND;
+	else if (op == XP_AMO_OR)
+		op = FETCHOP_OR;
+	else
+		BUG();
+
+	if (remote)
+		local_irq_save(irq_flags);
+
+	FETCHOP_STORE_OP(TO_AMO((u64)amo_va), op, operand);
+
+	if (remote) {
+		/*
+		 * We must always use the nofault function regardless of
+		 * whether we are on a Shub 1.1 system or a Shub 1.2 slice
+		 * 0xc processor. If we didn't, we'd never know that the other
+		 * partition is down and would keep sending IPIs and AMOs to
+		 * it until the heartbeat times out.
+		 */
+		if (xp_nofault_PIOR((u64 *)GLOBAL_MMR_ADDR(NASID_GET(amo_va),
+				    xp_nofault_PIOR_target)) != 0)
+			ret = xpPioReadError;
+
+		local_irq_restore(irq_flags);
+	}
+
+	return ret;
+}
+
+static enum xp_retval
+xp_set_amo_with_interrupt_sn2(u64 *amo_va, int op, u64 operand, int remote,
+			      int nasid, int phys_cpuid, int vector)
+{
+	unsigned long irq_flags = irq_flags; /* eliminate compiler warning */
+	int ret = xpSuccess;
+
+	if (op == XP_AMO_AND)
+		op = FETCHOP_AND;
+	else if (op == XP_AMO_OR)
+		op = FETCHOP_OR;
+	else
+		BUG();
+
+	if (remote)
+		local_irq_save(irq_flags);
+
+	FETCHOP_STORE_OP(TO_AMO((u64)amo_va), op, operand);
+	sn_send_IPI_phys(nasid, phys_cpuid, vector, 0);
+
+	if (remote) {
+		/*
+		 * We must always use the nofault function regardless of
+		 * whether we are on a Shub 1.1 system or a Shub 1.2 slice
+		 * 0xc processor. If we didn't, we'd never know that the other
+		 * partition is down and would keep sending IPIs and AMOs to
+		 * it until the heartbeat times out.
+		 */
+		if (xp_nofault_PIOR((u64 *)GLOBAL_MMR_ADDR(NASID_GET(amo_va),
+				    xp_nofault_PIOR_target)) != 0)
+			ret = xpPioReadError;
+
+		local_irq_restore(irq_flags);
+	}
+
+	return ret;
+}
+
+static enum xp_retval
+xp_get_amo_sn2(u64 *amo_va, int op, u64 *amo_value_addr)
+{
+	u64 amo_value;
+
+	if (op == XP_AMO_LOAD)
+		op = FETCHOP_LOAD;
+	else if (op == XP_AMO_CLEAR)
+		op = FETCHOP_CLEAR;
+	else
+		BUG();
+
+	amo_value = FETCHOP_LOAD_OP(TO_AMO((u64)amo_va), op);
+	if (amo_value_addr != NULL)
+		*amo_value_addr = amo_value;
+	return xpSuccess;
+}
+
+static enum xp_retval
+xp_get_partition_rsvd_page_pa_sn2(u64 buf, u64 *cookie, u64 *paddr, size_t *len)
+{
+	s64 status;
+	enum xp_retval ret;
+
+	status = sn_partition_reserved_page_pa(buf, cookie, paddr, len);
+	if (status == SALRET_OK)
+		ret = xpSuccess;
+	else if (status == SALRET_MORE_PASSES)
+		ret = xpNeedMoreInfo;
+	else
+		ret = xpSalError;
+
+	return ret;
+}
+
+static enum xp_retval
+xp_change_memprotect_sn2(u64 paddr, size_t len, int request, u64 *nasid_array)
+{
+	u64 perms;
+	int status;
+
+	/*
+	 * Since the BIST collides with memory operations on
+	 * SHUB 1.1, sn_change_memprotect() cannot be used. See
+	 * xp_change_memprotect_shub_wars_1_1() for WAR.
+	 */
+	if (enable_shub_wars_1_1())
+		return xpSuccess;
+
+	if (request == XP_MEMPROT_DISALLOW_ALL)
+		perms = SN_MEMPROT_ACCESS_CLASS_0;
+	else if (request == XP_MEMPROT_ALLOW_CPU_AMO)
+		perms = SN_MEMPROT_ACCESS_CLASS_1;
+	else if (request == XP_MEMPROT_ALLOW_CPU_MEM)
+		perms = SN_MEMPROT_ACCESS_CLASS_2;
+	else
+		BUG();
+
+	status = sn_change_memprotect(paddr, len, perms, nasid_array);
+	return (status == 0) ? xpSuccess : xpSalError;
+}
+
+/* original protection values for each node */
+static u64 xpc_prot_vec[MAX_NUMNODES];
+
+/*
+ * Change protections to allow/disallow all operations on Shub 1.1 systems.
+ */
+static void
+xp_change_memprotect_shub_wars_1_1_sn2(int request)
+{
+	int node;
+	int nasid;
+
+	/*
+	 * Since the BIST collides with memory operations on SHUB 1.1
+	 * sn_change_memprotect() cannot be used.
+	 */
+	if (!enable_shub_wars_1_1())
+		return;
+
+	if (request == XP_MEMPROT_ALLOW_ALL) {
+		for_each_online_node(node) {
+			nasid = cnodeid_to_nasid(node);
+			/* save current protection values */
+			xpc_prot_vec[node] =
+				(u64)HUB_L((u64 *)GLOBAL_MMR_ADDR(nasid,
+					   SH1_MD_DQLP_MMR_DIR_PRIVEC0));
+			/* open up everything */
+			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid,
+			      SH1_MD_DQLP_MMR_DIR_PRIVEC0), -1UL);
+			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid,
+			      SH1_MD_DQRP_MMR_DIR_PRIVEC0), -1UL);
+		}
+	} else if (request == XP_MEMPROT_DISALLOW_ALL) {
+		for_each_online_node(node) {
+			nasid = cnodeid_to_nasid(node);
+			/* restore original protection values */
+			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid,
+			      SH1_MD_DQLP_MMR_DIR_PRIVEC0), xpc_prot_vec[node]);
+			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid,
+			      SH1_MD_DQRP_MMR_DIR_PRIVEC0), xpc_prot_vec[node]);
+		}
+	} else
+		BUG();
+}
+
+/* SH_IPI_ACCESS shub register value on startup */
+static u64 xpc_sh1_IPI_access;
+static u64 xpc_sh2_IPI_access0;
+static u64 xpc_sh2_IPI_access1;
+static u64 xpc_sh2_IPI_access2;
+static u64 xpc_sh2_IPI_access3;
+
+/*
+ * Change protections to allow IPI operations.
+ */
+static void
+xp_allow_IPI_ops_sn2(void)
+{
+	int node;
+	int nasid;
+
+	/*  >>> The following should get moved into SAL. */
+	if (is_shub2()) {
+		xpc_sh2_IPI_access0 =
+			(u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH2_IPI_ACCESS0));
+		xpc_sh2_IPI_access1 =
+			(u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH2_IPI_ACCESS1));
+		xpc_sh2_IPI_access2 =
+			(u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH2_IPI_ACCESS2));
+		xpc_sh2_IPI_access3 =
+			(u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH2_IPI_ACCESS3));
+
+		for_each_online_node(node) {
+			nasid = cnodeid_to_nasid(node);
+			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS0),
+			      -1UL);
+			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS1),
+			      -1UL);
+			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS2),
+			      -1UL);
+			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS3),
+			      -1UL);
+		}
+	} else {
+		xpc_sh1_IPI_access =
+			(u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH1_IPI_ACCESS));
+
+		for_each_online_node(node) {
+			nasid = cnodeid_to_nasid(node);
+			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH1_IPI_ACCESS),
+			      -1UL);
+		}
+	}
+}
+
+/*
+ * Restrict protections to disallow IPI operations.
+ */
+static void
+xp_disallow_IPI_ops_sn2(void)
+{
+	int node;
+	int nasid;
+
+	/*  >>> The following should get moved into SAL. */
+	if (is_shub2()) {
+		for_each_online_node(node) {
+			nasid = cnodeid_to_nasid(node);
+			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS0),
+			      xpc_sh2_IPI_access0);
+			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS1),
+			      xpc_sh2_IPI_access1);
+			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS2),
+			      xpc_sh2_IPI_access2);
+			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS3),
+			      xpc_sh2_IPI_access3);
+		}
+	} else {
+		for_each_online_node(node) {
+			nasid = cnodeid_to_nasid(node);
+			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH1_IPI_ACCESS),
+			      xpc_sh1_IPI_access);
+		}
+	}
+}
+
+static int
+xp_cpu_to_nasid_sn2(int cpuid)
+{
+	return cpuid_to_nasid(cpuid);
+}
+
+static int
+xp_node_to_nasid_sn2(int nid)
+{
+	return cnodeid_to_nasid(nid);
+}
+
+enum xp_retval
+xp_init_sn2(void)
+{
+	BUG_ON(!is_shub());
+
+	xp_partition_id = sn_partition_id;
+	xp_region_size = sn_region_size;
+	xp_rtc_cycles_per_second = sn_rtc_cycles_per_second;
+
+	xp_remote_memcpy = xp_remote_memcpy_sn2;
+
+	xp_register_remote_amos = xp_register_remote_amos_sn2;
+	xp_unregister_remote_amos = xp_unregister_remote_amos_sn2;
+
+	/*
+	 * MSPEC based AMOs are assumed to have the important bits in only the
+	 * first 64. The remainder is ignored other than xp_sizeof_amo must
+	 * reflect its existence.
+	 */
+	BUG_ON(offsetof(AMO_t, variable) != 0);
+	BUG_ON(sizeof(((AMO_t *)NULL)->variable) != sizeof(u64));
+	xp_sizeof_amo = sizeof(AMO_t);
+	xp_alloc_amos = xp_alloc_amos_sn2;
+	xp_free_amos = xp_free_amos_sn2;
+	xp_set_amo = xp_set_amo_sn2;
+	xp_set_amo_with_interrupt = xp_set_amo_with_interrupt_sn2;
+	xp_get_amo = xp_get_amo_sn2;
+
+	xp_get_partition_rsvd_page_pa = xp_get_partition_rsvd_page_pa_sn2;
+
+	xp_change_memprotect = xp_change_memprotect_sn2;
+	xp_change_memprotect_shub_wars_1_1 =
+				xp_change_memprotect_shub_wars_1_1_sn2;
+	xp_allow_IPI_ops = xp_allow_IPI_ops_sn2;
+	xp_disallow_IPI_ops = xp_disallow_IPI_ops_sn2;
+
+	xp_cpu_to_nasid = xp_cpu_to_nasid_sn2;
+	xp_node_to_nasid = xp_node_to_nasid_sn2;
+
+	return xp_register_nofault_code_sn2();
+}
+
+void
+xp_exit_sn2(void)
+{
+	BUG_ON(!is_shub());
+
+	xp_unregister_nofault_code_sn2();
+}
+
Index: linux-2.6/drivers/misc/Kconfig
===================================================================
--- linux-2.6.orig/drivers/misc/Kconfig	2008-03-26 10:40:03.160341945 -0500
+++ linux-2.6/drivers/misc/Kconfig	2008-03-26 10:40:10.905285289 -0500
@@ -329,7 +329,7 @@ config ENCLOSURE_SERVICES
 
 config SGI_XP
 	tristate "Support communication between SGI SSIs"
-	depends on IA64_GENERIC || IA64_SGI_SN2
+	depends on IA64_GENERIC || IA64_SGI_SN2 || X86_64
 	select IA64_UNCACHED_ALLOCATOR if IA64_GENERIC || IA64_SGI_SN2
 	select GENERIC_ALLOCATOR if IA64_GENERIC || IA64_SGI_SN2
 	---help---
