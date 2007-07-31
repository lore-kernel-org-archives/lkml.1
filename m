Return-Path: <linux-kernel-owner+w=401wt.eu-S1761646AbXGaRFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761646AbXGaRFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 13:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756016AbXGaRFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 13:05:43 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4320 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754105AbXGaRFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 13:05:41 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 08] fs/cifs/connect.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 19:05:40 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       sfrench@samba.org, linux-cifs-client@lists.samba.org,
       samba-technical@lists.samba.org
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311905.40378.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does kmalloc + memset conversion to kzalloc and removes some redundant
argument checks.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 fs/cifs/connect.c | 109282 -> 109078 (-204 bytes)
 fs/cifs/connect.o | 211804 -> 211576 (-228 bytes)

 fs/cifs/connect.c |   30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

--- linux-2.6.23-rc1-mm1-a/fs/cifs/connect.c	2007-07-26 13:07:46.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/fs/cifs/connect.c	2007-07-31 14:51:20.000000000 +0200
@@ -676,10 +676,8 @@ multi_t2_fnd:
 		server->ssocket = NULL;
 	}
 	/* buffer usuallly freed in free_mid - need to free it here on exit */
-	if (bigbuf != NULL)
-		cifs_buf_release(bigbuf);
-	if (smallbuf != NULL)
-		cifs_small_buf_release(smallbuf);
+	cifs_buf_release(bigbuf);
+	cifs_small_buf_release(smallbuf);

 	read_lock(&GlobalSMBSeslock);
 	if (list_empty(&server->pending_mid_q)) {
@@ -1909,8 +1907,8 @@ cifs_mount(struct super_block *sb, struc
 			return rc;
 		}

-		srvTcp = kmalloc(sizeof (struct TCP_Server_Info), GFP_KERNEL);
-		if (srvTcp == NULL) {
+		srvTcp = kzalloc(sizeof(struct TCP_Server_Info), GFP_KERNEL);
+		if (!srvTcp) {
 			rc = -ENOMEM;
 			sock_release(csocket);
 			kfree(volume_info.UNC);
@@ -1919,7 +1917,6 @@ cifs_mount(struct super_block *sb, struc
 			FreeXid(xid);
 			return rc;
 		} else {
-			memset(srvTcp, 0, sizeof (struct TCP_Server_Info));
 			memcpy(&srvTcp->addr.sockAddr, &sin_server,
 				sizeof (struct sockaddr_in));
 			atomic_set(&srvTcp->inFlight, 0);
@@ -2154,8 +2151,8 @@ cifs_mount(struct super_block *sb, struc
 			}
 		}
 		 /* If find_unc succeeded then rc == 0 so we can not end */
-		if (tcon)  /* up accidently freeing someone elses tcon struct */
-			tconInfoFree(tcon);
+		/* up accidently freeing someone elses tcon struct */
+		tconInfoFree(tcon);
 		if (existingCifsSes == NULL) {
 			if (pSesInfo) {
 				if ((pSesInfo->server) &&
@@ -2526,8 +2523,7 @@ CIFSSessSetup(unsigned int xid, struct c
 sesssetup_nomem:	/* do not return an error on nomem for the info strings,
 			   since that could make reconnection harder, and
 			   reconnection might be needed to free memory */
-	if (smb_buffer)
-		cifs_buf_release(smb_buffer);
+	cifs_buf_release(smb_buffer);

 	return rc;
 }
@@ -2865,8 +2861,7 @@ CIFSNTLMSSPNegotiateSessSetup(unsigned i
 		rc = -EIO;
 	}

-	if (smb_buffer)
-		cifs_buf_release(smb_buffer);
+	cifs_buf_release(smb_buffer);

 	return rc;
 }
@@ -3279,8 +3274,7 @@ CIFSNTLMSSPAuthSessSetup(unsigned int xi
 		rc = -EIO;
 	}

-	if (smb_buffer)
-		cifs_buf_release(smb_buffer);
+	cifs_buf_release(smb_buffer);

 	return rc;
 }
@@ -3433,8 +3427,7 @@ CIFSTCon(unsigned int xid, struct cifsSe
 		ses->ipc_tid = smb_buffer_response->Tid;
 	}

-	if (smb_buffer)
-		cifs_buf_release(smb_buffer);
+	cifs_buf_release(smb_buffer);
 	return rc;
 }

@@ -3485,8 +3478,7 @@ cifs_umount(struct super_block *sb, stru
 	kfree(tmp);
 	if (ses)
 		schedule_timeout_interruptible(msecs_to_jiffies(500));
-	if (ses)
-		sesInfoFree(ses);
+	sesInfoFree(ses);

 	FreeXid(xid);
 	return rc;	/* BB check if we should always return zero here */
