Return-Path: <linux-kernel-owner+w=401wt.eu-S1423190AbXBBOXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423190AbXBBOXD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 09:23:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423199AbXBBOXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 09:23:01 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:58425 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423188AbXBBOW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 09:22:58 -0500
Date: Fri, 2 Feb 2007 15:22:56 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: peter.oberparleiter@de.ibm.com
Subject: [S390] Cleanup of CHSC event handling.
Message-ID: <20070202142256.GE30839@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

[S390] Cleanup of CHSC event handling.

Change CHSC event handling to be more easily extensible.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/chsc.c |  232 +++++++++++++++++++++++-------------------------
 1 files changed, 112 insertions(+), 120 deletions(-)

diff -urpN linux-2.6/drivers/s390/cio/chsc.c linux-2.6-patched/drivers/s390/cio/chsc.c
--- linux-2.6/drivers/s390/cio/chsc.c	2007-02-02 14:04:44.000000000 +0100
+++ linux-2.6-patched/drivers/s390/cio/chsc.c	2007-02-02 14:04:44.000000000 +0100
@@ -461,144 +461,136 @@ __get_chpid_from_lir(void *data)
 	return (u16) (lir->indesc[0]&0x000000ff);
 }
 
-int
-chsc_process_crw(void)
+struct chsc_sei_area {
+	struct chsc_header request;
+	u32 reserved1;
+	u32 reserved2;
+	u32 reserved3;
+	struct chsc_header response;
+	u32 reserved4;
+	u8  flags;
+	u8  vf;		/* validity flags */
+	u8  rs;		/* reporting source */
+	u8  cc;		/* content code */
+	u16 fla;	/* full link address */
+	u16 rsid;	/* reporting source id */
+	u32 reserved5;
+	u32 reserved6;
+	u8 ccdf[4096 - 16 - 24];	/* content-code dependent field */
+	/* ccdf has to be big enough for a link-incident record */
+} __attribute__ ((packed));
+
+static int chsc_process_sei_link_incident(struct chsc_sei_area *sei_area)
+{
+	int chpid;
+
+	CIO_CRW_EVENT(4, "chsc: link incident (rs=%02x, rs_id=%04x)\n",
+		      sei_area->rs, sei_area->rsid);
+	if (sei_area->rs != 4)
+		return 0;
+	chpid = __get_chpid_from_lir(sei_area->ccdf);
+	if (chpid < 0)
+		CIO_CRW_EVENT(4, "chsc: link incident - invalid LIR\n");
+	else
+		s390_set_chpid_offline(chpid);
+
+	return 0;
+}
+
+static int chsc_process_sei_res_acc(struct chsc_sei_area *sei_area)
 {
-	int chpid, ret;
 	struct res_acc_data res_data;
-	struct {
-		struct chsc_header request;
-		u32 reserved1;
-		u32 reserved2;
-		u32 reserved3;
-		struct chsc_header response;
-		u32 reserved4;
-		u8  flags;
-		u8  vf;		/* validity flags */
-		u8  rs;		/* reporting source */
-		u8  cc;		/* content code */
-		u16 fla;	/* full link address */
-		u16 rsid;	/* reporting source id */
-		u32 reserved5;
-		u32 reserved6;
-		u32 ccdf[96];	/* content-code dependent field */
-		/* ccdf has to be big enough for a link-incident record */
-	} __attribute__ ((packed)) *sei_area;
+	struct device *dev;
+	int status;
+	int rc;
+
+	CIO_CRW_EVENT(4, "chsc: resource accessibility event (rs=%02x, "
+		      "rs_id=%04x)\n", sei_area->rs, sei_area->rsid);
+	if (sei_area->rs != 4)
+		return 0;
+	/* allocate a new channel path structure, if needed */
+	status = get_chp_status(sei_area->rsid);
+	if (status < 0)
+		new_channel_path(sei_area->rsid);
+	else if (!status)
+		return 0;
+	dev = get_device(&css[0]->chps[sei_area->rsid]->dev);
+	memset(&res_data, 0, sizeof(struct res_acc_data));
+	res_data.chp = to_channelpath(dev);
+	if ((sei_area->vf & 0xc0) != 0) {
+		res_data.fla = sei_area->fla;
+		if ((sei_area->vf & 0xc0) == 0xc0)
+			/* full link address */
+			res_data.fla_mask = 0xffff;
+		else
+			/* link address */
+			res_data.fla_mask = 0xff00;
+	}
+	rc = s390_process_res_acc(&res_data);
+	put_device(dev);
+
+	return rc;
+}
+
+static int chsc_process_sei(struct chsc_sei_area *sei_area)
+{
+	int rc;
+
+	/* Check if we might have lost some information. */
+	if (sei_area->flags & 0x40)
+		CIO_CRW_EVENT(2, "chsc: event overflow\n");
+	/* which kind of information was stored? */
+	rc = 0;
+	switch (sei_area->cc) {
+	case 1: /* link incident*/
+		rc = chsc_process_sei_link_incident(sei_area);
+		break;
+	case 2: /* i/o resource accessibiliy */
+		rc = chsc_process_sei_res_acc(sei_area);
+		break;
+	default: /* other stuff */
+		CIO_CRW_EVENT(4, "chsc: unhandled sei content code %d\n",
+			      sei_area->cc);
+		break;
+	}
+
+	return rc;
+}
+
+int chsc_process_crw(void)
+{
+	struct chsc_sei_area *sei_area;
+	int ret;
+	int rc;
 
 	if (!sei_page)
 		return 0;
-	/*
-	 * build the chsc request block for store event information
-	 * and do the call
-	 * This function is only called by the machine check handler thread,
-	 * so we don't need locking for the sei_page.
-	 */
+	/* Access to sei_page is serialized through machine check handler
+	 * thread, so no need for locking. */
 	sei_area = sei_page;
 
 	CIO_TRACE_EVENT( 2, "prcss");
 	ret = 0;
 	do {
-		int ccode, status;
-		struct device *dev;
 		memset(sei_area, 0, sizeof(*sei_area));
-		memset(&res_data, 0, sizeof(struct res_acc_data));
 		sei_area->request.length = 0x0010;
 		sei_area->request.code = 0x000e;
+		if (chsc(sei_area))
+			break;
 
-		ccode = chsc(sei_area);
-		if (ccode > 0)
-			return 0;
-
-		switch (sei_area->response.code) {
-			/* for debug purposes, check for problems */
-		case 0x0001:
-			CIO_CRW_EVENT(4, "chsc_process_crw: event information "
-					"successfully stored\n");
-			break; /* everything ok */
-		case 0x0002:
-			CIO_CRW_EVENT(2,
-				      "chsc_process_crw: invalid command!\n");
-			return 0;
-		case 0x0003:
-			CIO_CRW_EVENT(2, "chsc_process_crw: error in chsc "
-				      "request block!\n");
-			return 0;
-		case 0x0005:
-			CIO_CRW_EVENT(2, "chsc_process_crw: no event "
-				      "information stored\n");
-			return 0;
-		default:
-			CIO_CRW_EVENT(2, "chsc_process_crw: chsc response %d\n",
+		if (sei_area->response.code == 0x0001) {
+			CIO_CRW_EVENT(4, "chsc: sei successful\n");
+			rc = chsc_process_sei(sei_area);
+			if (rc)
+				ret = rc;
+		} else {
+			CIO_CRW_EVENT(2, "chsc: sei failed (rc=%04x)\n",
 				      sei_area->response.code);
-			return 0;
-		}
-
-		/* Check if we might have lost some information. */
-		if (sei_area->flags & 0x40)
-			CIO_CRW_EVENT(2, "chsc_process_crw: Event information "
-				       "has been lost due to overflow!\n");
-
-		if (sei_area->rs != 4) {
-			CIO_CRW_EVENT(2, "chsc_process_crw: reporting source "
-				      "(%04X) isn't a chpid!\n",
-				      sei_area->rsid);
-			continue;
-		}
-
-		/* which kind of information was stored? */
-		switch (sei_area->cc) {
-		case 1: /* link incident*/
-			CIO_CRW_EVENT(4, "chsc_process_crw: "
-				      "channel subsystem reports link incident,"
-				      " reporting source is chpid %x\n",
-				      sei_area->rsid);
-			chpid = __get_chpid_from_lir(sei_area->ccdf);
-			if (chpid < 0)
-				CIO_CRW_EVENT(4, "%s: Invalid LIR, skipping\n",
-					      __FUNCTION__);
-			else
-				s390_set_chpid_offline(chpid);
-			break;
-			
-		case 2: /* i/o resource accessibiliy */
-			CIO_CRW_EVENT(4, "chsc_process_crw: "
-				      "channel subsystem reports some I/O "
-				      "devices may have become accessible\n");
-			pr_debug("Data received after sei: \n");
-			pr_debug("Validity flags: %x\n", sei_area->vf);
-			
-			/* allocate a new channel path structure, if needed */
-			status = get_chp_status(sei_area->rsid);
-			if (status < 0)
-				new_channel_path(sei_area->rsid);
-			else if (!status)
-				break;
-			dev = get_device(&css[0]->chps[sei_area->rsid]->dev);
-			res_data.chp = to_channelpath(dev);
-			pr_debug("chpid: %x", sei_area->rsid);
-			if ((sei_area->vf & 0xc0) != 0) {
-				res_data.fla = sei_area->fla;
-				if ((sei_area->vf & 0xc0) == 0xc0) {
-					pr_debug(" full link addr: %x",
-						 sei_area->fla);
-					res_data.fla_mask = 0xffff;
-				} else {
-					pr_debug(" link addr: %x",
-						 sei_area->fla);
-					res_data.fla_mask = 0xff00;
-				}
-			}
-			ret = s390_process_res_acc(&res_data);
-			pr_debug("\n\n");
-			put_device(dev);
-			break;
-			
-		default: /* other stuff */
-			CIO_CRW_EVENT(4, "chsc_process_crw: event %d\n",
-				      sei_area->cc);
+			ret = 0;
 			break;
 		}
 	} while (sei_area->flags & 0x80);
+
 	return ret;
 }
 
