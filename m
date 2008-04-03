Return-Path: <linux-kernel-owner+w=401wt.eu-S1760303AbYDCSDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760303AbYDCSDl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 14:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbYDCSDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 14:03:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753466AbYDCSDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 14:03:33 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] AFS: The AFS RPC op CBGetCapabilities is actually
	CBTellMeAboutYourself [try #2]
To: torvalds@osdl.org, akpm@linux-foundation.org, me@bobcopeland.com
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Thu, 03 Apr 2008 19:03:00 +0100
Message-ID: <20080403180300.13644.68956.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AFS RxRPC op CBGetCapabilities is actually CBTellMeAboutYourself.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/afs_cm.h    |    2 +-
 fs/afs/cmservice.c |   26 +++++++++++++-------------
 2 files changed, 14 insertions(+), 14 deletions(-)


diff --git a/fs/afs/afs_cm.h b/fs/afs/afs_cm.h
index 7b4d4fa..5f62f3e 100644
--- a/fs/afs/afs_cm.h
+++ b/fs/afs/afs_cm.h
@@ -24,7 +24,7 @@ enum AFS_CM_Operations {
 	CBGetXStatsVersion	= 209,	/* get version of extended statistics */
 	CBGetXStats		= 210,	/* get contents of extended statistics data */
 	CBInitCallBackState3	= 213,	/* initialise callback state, version 3 */
-	CBGetCapabilities	= 65538, /* get client capabilities */
+	CBTellMeAboutYourself	= 65538, /* get client capabilities */
 };
 
 #define AFS_CAP_ERROR_TRANSLATION	0x1
diff --git a/fs/afs/cmservice.c b/fs/afs/cmservice.c
index 47b71c8..9b19c02 100644
--- a/fs/afs/cmservice.c
+++ b/fs/afs/cmservice.c
@@ -26,8 +26,8 @@ static int afs_deliver_cb_init_call_back_state3(struct afs_call *,
 						struct sk_buff *, bool);
 static int afs_deliver_cb_probe(struct afs_call *, struct sk_buff *, bool);
 static int afs_deliver_cb_callback(struct afs_call *, struct sk_buff *, bool);
-static int afs_deliver_cb_get_capabilities(struct afs_call *, struct sk_buff *,
-					   bool);
+static int afs_deliver_cb_tell_me_about_yourself(struct afs_call *,
+						 struct sk_buff *, bool);
 static void afs_cm_destructor(struct afs_call *);
 
 /*
@@ -71,11 +71,11 @@ static const struct afs_call_type afs_SRXCBProbe = {
 };
 
 /*
- * CB.GetCapabilities operation type
+ * CB.TellMeAboutYourself operation type
  */
-static const struct afs_call_type afs_SRXCBGetCapabilites = {
-	.name		= "CB.GetCapabilities",
-	.deliver	= afs_deliver_cb_get_capabilities,
+static const struct afs_call_type afs_SRXCBTellMeAboutYourself = {
+	.name		= "CB.",
+	.deliver	= afs_deliver_cb_tell_me_about_yourself,
 	.abort_to_error	= afs_abort_to_error,
 	.destructor	= afs_cm_destructor,
 };
@@ -103,8 +103,8 @@ bool afs_cm_incoming_call(struct afs_call *call)
 	case CBProbe:
 		call->type = &afs_SRXCBProbe;
 		return true;
-	case CBGetCapabilities:
-		call->type = &afs_SRXCBGetCapabilites;
+	case CBTellMeAboutYourself:
+		call->type = &afs_SRXCBTellMeAboutYourself;
 		return true;
 	default:
 		return false;
@@ -395,7 +395,7 @@ static int afs_deliver_cb_probe(struct afs_call *call, struct sk_buff *skb,
 /*
  * allow the fileserver to ask about the cache manager's capabilities
  */
-static void SRXAFSCB_GetCapabilities(struct work_struct *work)
+static void SRXAFSCB_TellMeAboutYourself(struct work_struct *work)
 {
 	struct afs_interface *ifs;
 	struct afs_call *call = container_of(work, struct afs_call, work);
@@ -456,10 +456,10 @@ static void SRXAFSCB_GetCapabilities(struct work_struct *work)
 }
 
 /*
- * deliver request data to a CB.GetCapabilities call
+ * deliver request data to a CB.TellMeAboutYourself call
  */
-static int afs_deliver_cb_get_capabilities(struct afs_call *call,
-					   struct sk_buff *skb, bool last)
+static int afs_deliver_cb_tell_me_about_yourself(struct afs_call *call,
+						 struct sk_buff *skb, bool last)
 {
 	_enter(",{%u},%d", skb->len, last);
 
@@ -471,7 +471,7 @@ static int afs_deliver_cb_get_capabilities(struct afs_call *call,
 	/* no unmarshalling required */
 	call->state = AFS_CALL_REPLYING;
 
-	INIT_WORK(&call->work, SRXAFSCB_GetCapabilities);
+	INIT_WORK(&call->work, SRXAFSCB_TellMeAboutYourself);
 	schedule_work(&call->work);
 	return 0;
 }

