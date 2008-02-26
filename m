Return-Path: <linux-kernel-owner+w=401wt.eu-S1760295AbYBZDY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760295AbYBZDY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 22:24:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759109AbYBZDYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 22:24:44 -0500
Received: from el-out-1112.google.com ([209.85.162.177]:41600 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757654AbYBZDYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 22:24:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=EwAwsfkClFtUVyq8hKuVLOcKyqLATdcPPVOlT9YfFOZZp1afIW96VGPM/uebYQ+XluT5UjW6lipM9NMFzBGnRY5IS6payOPUzUmL3ntxwFOh0VetC4nzGElTS0dUWSXUcopoRZVBItZldzjiRzKT0dev1+dGqHZFl5XxM7wLMX4=
Subject: [PATCH] cifs: remove GLOBAL_EXTERN macro
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Steven French <sfrench@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 19:24:19 -0800
Message-Id: <1203996259.5582.21.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Global variables should be defined in C files, not in headers.

1) Comment out unused vars
GlobalDnotifyRsp_Q
GlobalUidList

2) Declare vars in cifsfs.c that need it and change to extern in
cifsglob.h

3) Change to extern in cifsglob.h for vars that were already being
declared in cifsfs.c

4) Remove GLOBAL_EXTERN

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Steven, here is a revised patch that has a bit more thought behind it.


 fs/cifs/cifsfs.c   |   31 ++++++++++++++++++++-
 fs/cifs/cifsglob.h |   76 ++++++++++++++++++++++++----------------------------
 2 files changed, 64 insertions(+), 43 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index fcc4342..aae6752 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -37,7 +37,6 @@
 #include <linux/freezer.h>
 #include "cifsfs.h"
 #include "cifspdu.h"
-#define DECLARE_GLOBALS_HERE
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "cifs_debug.h"
@@ -85,6 +84,34 @@ module_param(cifs_max_pending, int, 0);
 MODULE_PARM_DESC(cifs_max_pending, "Simultaneous requests to server. "
 				   "Default: 50 Range: 2 to 256");
 
+struct list_head GlobalSMBSessionList;
+struct list_head GlobalTreeConnectionList;
+rwlock_t GlobalSMBSeslock;
+
+struct list_head GlobalOplock_Q;
+
+struct list_head GlobalDnotifyReqList;
+
+unsigned int GlobalCurrentXid;
+unsigned int GlobalTotalActiveXid;
+unsigned int GlobalMaxActiveXid;
+spinlock_t GlobalMid_Lock;
+char Local_System_Name[15];
+
+atomic_t sesInfoAllocCount;
+atomic_t tconInfoAllocCount;
+atomic_t tcpSesAllocCount;
+atomic_t tcpSesReconnectCount;
+atomic_t tconInfoReconnectCount;
+
+atomic_t bufAllocCount;    /* current number allocated  */
+#ifdef CONFIG_CIFS_STATS2
+atomic_t totBufAllocCount; /* total allocated over all time */
+atomic_t totSmBufAllocCount;
+#endif
+atomic_t smBufAllocCount;
+atomic_t midCount;
+
 extern mempool_t *cifs_sm_req_poolp;
 extern mempool_t *cifs_req_poolp;
 extern mempool_t *cifs_mid_poolp;
@@ -1001,7 +1028,7 @@ init_cifs(void)
 	INIT_LIST_HEAD(&GlobalOplock_Q);
 #ifdef CONFIG_CIFS_EXPERIMENTAL
 	INIT_LIST_HEAD(&GlobalDnotifyReqList);
-	INIT_LIST_HEAD(&GlobalDnotifyRsp_Q);
+/*	INIT_LIST_HEAD(&GlobalDnotifyRsp_Q); */
 #endif
 /*
  *  Initialize Global counters
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 5d32d8d..c45acfd 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -583,79 +583,73 @@ require use of the stronger protocol */
  *
  ****************************************************************************/
 
-#ifdef DECLARE_GLOBALS_HERE
-#define GLOBAL_EXTERN
-#else
-#define GLOBAL_EXTERN extern
-#endif
-
 /*
  * The list of servers that did not respond with NT LM 0.12.
  * This list helps improve performance and eliminate the messages indicating
  * that we had a communications error talking to the server in this list.
  */
 /* Feature not supported */
-/* GLOBAL_EXTERN struct servers_not_supported *NotSuppList; */
+/* extern struct servers_not_supported *NotSuppList; */
 
 /*
  * The following is a hash table of all the users we know about.
  */
-GLOBAL_EXTERN struct smbUidInfo *GlobalUidList[UID_HASH];
+/* extern struct smbUidInfo *GlobalUidList[UID_HASH]; */
 
-/* GLOBAL_EXTERN struct list_head GlobalServerList; BB not implemented yet */
-GLOBAL_EXTERN struct list_head GlobalSMBSessionList;
-GLOBAL_EXTERN struct list_head GlobalTreeConnectionList;
-GLOBAL_EXTERN rwlock_t GlobalSMBSeslock;  /* protects list inserts on 3 above */
+/* extern struct list_head GlobalServerList; BB not implemented yet */
+extern struct list_head GlobalSMBSessionList;
+extern struct list_head GlobalTreeConnectionList;
+extern rwlock_t GlobalSMBSeslock;  /* protects list inserts on 3 above */
 
-GLOBAL_EXTERN struct list_head GlobalOplock_Q;
+extern struct list_head GlobalOplock_Q;
 
 /* Outstanding dir notify requests */
-GLOBAL_EXTERN struct list_head GlobalDnotifyReqList;
+extern struct list_head GlobalDnotifyReqList;
 /* DirNotify response queue */
-GLOBAL_EXTERN struct list_head GlobalDnotifyRsp_Q;
+/* extern struct list_head GlobalDnotifyRsp_Q; */
 
 /*
  * Global transaction id (XID) information
  */
-GLOBAL_EXTERN unsigned int GlobalCurrentXid;	/* protected by GlobalMid_Sem */
-GLOBAL_EXTERN unsigned int GlobalTotalActiveXid; /* prot by GlobalMid_Sem */
-GLOBAL_EXTERN unsigned int GlobalMaxActiveXid;	/* prot by GlobalMid_Sem */
-GLOBAL_EXTERN spinlock_t GlobalMid_Lock;  /* protects above & list operations */
+extern unsigned int GlobalCurrentXid;	/* protected by GlobalMid_Sem */
+extern unsigned int GlobalTotalActiveXid; /* prot by GlobalMid_Sem */
+extern unsigned int GlobalMaxActiveXid;	/* prot by GlobalMid_Sem */
+extern spinlock_t GlobalMid_Lock;  /* protects above & list operations */
 					  /* on midQ entries */
-GLOBAL_EXTERN char Local_System_Name[15];
+extern char Local_System_Name[15];
 
 /*
  *  Global counters, updated atomically
  */
-GLOBAL_EXTERN atomic_t sesInfoAllocCount;
-GLOBAL_EXTERN atomic_t tconInfoAllocCount;
-GLOBAL_EXTERN atomic_t tcpSesAllocCount;
-GLOBAL_EXTERN atomic_t tcpSesReconnectCount;
-GLOBAL_EXTERN atomic_t tconInfoReconnectCount;
+extern atomic_t sesInfoAllocCount;
+extern atomic_t tconInfoAllocCount;
+extern atomic_t tcpSesAllocCount;
+extern atomic_t tcpSesReconnectCount;
+extern atomic_t tconInfoReconnectCount;
 
 /* Various Debug counters to remove someday (BB) */
-GLOBAL_EXTERN atomic_t bufAllocCount;    /* current number allocated  */
+extern atomic_t bufAllocCount;    /* current number allocated  */
 #ifdef CONFIG_CIFS_STATS2
-GLOBAL_EXTERN atomic_t totBufAllocCount; /* total allocated over all time */
-GLOBAL_EXTERN atomic_t totSmBufAllocCount;
+extern atomic_t totBufAllocCount; /* total allocated over all time */
+extern atomic_t totSmBufAllocCount;
 #endif
-GLOBAL_EXTERN atomic_t smBufAllocCount;
-GLOBAL_EXTERN atomic_t midCount;
+extern atomic_t smBufAllocCount;
+extern atomic_t midCount;
 
 /* Misc globals */
-GLOBAL_EXTERN unsigned int multiuser_mount; /* if enabled allows new sessions
+extern unsigned int multiuser_mount; /* if enabled allows new sessions
 				to be established on existing mount if we
 				have the uid/password or Kerberos credential
 				or equivalent for current user */
-GLOBAL_EXTERN unsigned int oplockEnabled;
-GLOBAL_EXTERN unsigned int experimEnabled;
-GLOBAL_EXTERN unsigned int lookupCacheEnabled;
-GLOBAL_EXTERN unsigned int extended_security;	/* if on, session setup sent
+extern unsigned int oplockEnabled;
+extern unsigned int experimEnabled;
+extern unsigned int lookupCacheEnabled;
+extern unsigned int extended_security;	/* if on, session setup sent
 				with more secure ntlmssp2 challenge/resp */
-GLOBAL_EXTERN unsigned int sign_CIFS_PDUs;  /* enable smb packet signing */
-GLOBAL_EXTERN unsigned int linuxExtEnabled;/*enable Linux/Unix CIFS extensions*/
-GLOBAL_EXTERN unsigned int CIFSMaxBufSize;  /* max size not including hdr */
-GLOBAL_EXTERN unsigned int cifs_min_rcv;    /* min size of big ntwrk buf pool */
-GLOBAL_EXTERN unsigned int cifs_min_small;  /* min size of small buf pool */
-GLOBAL_EXTERN unsigned int cifs_max_pending; /* MAX requests at once to server*/
+extern unsigned int sign_CIFS_PDUs;  /* enable smb packet signing */
+extern unsigned int linuxExtEnabled;/*enable Linux/Unix CIFS extensions*/
+extern unsigned int CIFSMaxBufSize;  /* max size not including hdr */
+extern unsigned int cifs_min_rcv;    /* min size of big ntwrk buf pool */
+extern unsigned int cifs_min_small;  /* min size of small buf pool */
+extern unsigned int cifs_max_pending; /* MAX requests at once to server*/
 
-- 
1.5.4.1.1278.gc75be



