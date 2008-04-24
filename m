Return-Path: <linux-kernel-owner+w=401wt.eu-S1753845AbYDXW5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbYDXW5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 18:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbYDXW50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 18:57:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbYDXW5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 18:57:25 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] AFS: Support the CB.ProbeUuid RPC op
To: akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Thu, 24 Apr 2008 23:57:19 +0100
Message-ID: <20080424225719.2776.58179.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the CB.ProbeUuid cache manager RPC op.  This allows a modern
OpenAFS server to quickly ask if the client has been rebooted.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/afs_cm.h    |    1 
 fs/afs/cmservice.c |  107 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 108 insertions(+), 0 deletions(-)


diff --git a/fs/afs/afs_cm.h b/fs/afs/afs_cm.h
index 5f62f3e..255f5dd 100644
--- a/fs/afs/afs_cm.h
+++ b/fs/afs/afs_cm.h
@@ -24,6 +24,7 @@ enum AFS_CM_Operations {
 	CBGetXStatsVersion	= 209,	/* get version of extended statistics */
 	CBGetXStats		= 210,	/* get contents of extended statistics data */
 	CBInitCallBackState3	= 213,	/* initialise callback state, version 3 */
+	CBProbeUuid		= 214,	/* check the client hasn't rebooted */
 	CBTellMeAboutYourself	= 65538, /* get client capabilities */
 };
 
diff --git a/fs/afs/cmservice.c b/fs/afs/cmservice.c
index 75da3d0..eb76548 100644
--- a/fs/afs/cmservice.c
+++ b/fs/afs/cmservice.c
@@ -26,6 +26,7 @@ static int afs_deliver_cb_init_call_back_state3(struct afs_call *,
 						struct sk_buff *, bool);
 static int afs_deliver_cb_probe(struct afs_call *, struct sk_buff *, bool);
 static int afs_deliver_cb_callback(struct afs_call *, struct sk_buff *, bool);
+static int afs_deliver_cb_probe_uuid(struct afs_call *, struct sk_buff *, bool);
 static int afs_deliver_cb_tell_me_about_yourself(struct afs_call *,
 						 struct sk_buff *, bool);
 static void afs_cm_destructor(struct afs_call *);
@@ -71,6 +72,16 @@ static const struct afs_call_type afs_SRXCBProbe = {
 };
 
 /*
+ * CB.ProbeUuid operation type
+ */
+static const struct afs_call_type afs_SRXCBProbeUuid = {
+	.name		= "CB.ProbeUuid",
+	.deliver	= afs_deliver_cb_probe_uuid,
+	.abort_to_error	= afs_abort_to_error,
+	.destructor	= afs_cm_destructor,
+};
+
+/*
  * CB.TellMeAboutYourself operation type
  */
 static const struct afs_call_type afs_SRXCBTellMeAboutYourself = {
@@ -393,6 +404,102 @@ static int afs_deliver_cb_probe(struct afs_call *call, struct sk_buff *skb,
 }
 
 /*
+ * allow the fileserver to quickly find out if the fileserver has been rebooted
+ */
+static void SRXAFSCB_ProbeUuid(struct work_struct *work)
+{
+	struct afs_call *call = container_of(work, struct afs_call, work);
+	struct afs_uuid *r = call->request;
+
+	struct {
+		__be32	match;
+	} reply;
+
+	_enter("");
+
+
+	if (memcmp(r, &afs_uuid, sizeof(afs_uuid)) == 0)
+		reply.match = htonl(0);
+	else
+		reply.match = htonl(1);
+
+	afs_send_simple_reply(call, &reply, sizeof(reply));
+	_leave("");
+}
+
+/*
+ * deliver request data to a CB.ProbeUuid call
+ */
+static int afs_deliver_cb_probe_uuid(struct afs_call *call, struct sk_buff *skb,
+				     bool last)
+{
+	struct afs_uuid *r;
+	unsigned loop;
+	__be32 *b;
+	int ret;
+
+	_enter("{%u},{%u},%d", call->unmarshall, skb->len, last);
+
+	if (skb->len > 0)
+		return -EBADMSG;
+	if (!last)
+		return 0;
+
+	switch (call->unmarshall) {
+	case 0:
+		call->offset = 0;
+		call->buffer = kmalloc(11 * sizeof(__be32), GFP_KERNEL);
+		if (!call->buffer)
+			return -ENOMEM;
+		call->unmarshall++;
+
+	case 1:
+		_debug("extract UUID");
+		ret = afs_extract_data(call, skb, last, call->buffer,
+				       11 * sizeof(__be32));
+		switch (ret) {
+		case 0:		break;
+		case -EAGAIN:	return 0;
+		default:	return ret;
+		}
+
+		_debug("unmarshall UUID");
+		call->request = kmalloc(sizeof(struct afs_uuid), GFP_KERNEL);
+		if (!call->request)
+			return -ENOMEM;
+
+		b = call->buffer;
+		r = call->request;
+		r->time_low			= ntohl(b[0]);
+		r->time_mid			= ntohl(b[1]);
+		r->time_hi_and_version		= ntohl(b[2]);
+		r->clock_seq_hi_and_reserved 	= ntohl(b[3]);
+		r->clock_seq_low		= ntohl(b[4]);
+
+		for (loop = 0; loop < 6; loop++)
+			r->node[loop] = ntohl(b[loop + 5]);
+
+		call->offset = 0;
+		call->unmarshall++;
+
+	case 2:
+		_debug("trailer");
+		if (skb->len != 0)
+			return -EBADMSG;
+		break;
+	}
+
+	if (!last)
+		return 0;
+
+	call->state = AFS_CALL_REPLYING;
+
+	INIT_WORK(&call->work, SRXAFSCB_ProbeUuid);
+	schedule_work(&call->work);
+	return 0;
+}
+
+/*
  * allow the fileserver to ask about the cache manager's capabilities
  */
 static void SRXAFSCB_TellMeAboutYourself(struct work_struct *work)

