Return-Path: <linux-kernel-owner+w=401wt.eu-S1756138AbXIXLfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbXIXLfY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 07:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbXIXLfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 07:35:10 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:8259 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbXIXLfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 07:35:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=e2iob5tzJvEXpymL65CTZLlGNe8FikqmrWB0F+PHtEx8/Wk/FgbgUI6Q19OE2JxTLTgRKnPFeNNOeLEMdTNx4DZlSnwSYjIT6iz4cxwqb8p9IHifCbv6PEEPYLcV1RozBVq7Rs3ABwJcMBjI6KzIMj7CwszxlrLDflUNZrmNt7s=
Date: Mon, 24 Sep 2007 19:30:35 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: roel <12o3l@tiscali.nl>, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net, maxk@qualcomm.com,
       Marcel Holtmann <marcel@holtmann.org>
Subject: [-mm Patch] net/bluetooth/hidp/core.c: Make hidp_setup_input()
	return int
Message-ID: <20070924113035.GE2442@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch:
- makes hidp_setup_input() return int to indicate errors;
- checks its return value to handle errors.

And this time it is against -rc7-mm1 tree.

Thanks to roel and Marcel Holtmann for comments.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
 net/bluetooth/hidp/core.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

Index: linux-2.6.23-rc7-mm1/net/bluetooth/hidp/core.c
===================================================================
--- linux-2.6.23-rc7-mm1.orig/net/bluetooth/hidp/core.c
+++ linux-2.6.23-rc7-mm1/net/bluetooth/hidp/core.c
@@ -625,7 +625,7 @@ static struct device *hidp_get_device(st
 	return conn ? &conn->dev : NULL;
 }
 
-static inline void hidp_setup_input(struct hidp_session *session, struct hidp_connadd_req *req)
+static inline int hidp_setup_input(struct hidp_session *session, struct hidp_connadd_req *req)
 {
 	struct input_dev *input = session->input;
 	int i;
@@ -669,7 +669,7 @@ static inline void hidp_setup_input(stru
 
 	input->event = hidp_input_event;
 
-	input_register_device(input);
+	return input_register_device(input);
 }
 
 static int hidp_open(struct hid_device *hid)
@@ -822,8 +822,11 @@ int hidp_add_connection(struct hidp_conn
 	session->flags   = req->flags & (1 << HIDP_BLUETOOTH_VENDOR_ID);
 	session->idle_to = req->idle_to;
 
-	if (session->input)
-		hidp_setup_input(session, req);
+	if (session->input) {
+		err = hidp_setup_input(session, req);
+		if (err < 0)
+			goto failed;
+	}
 
 	if (session->hid)
 		hidp_setup_hid(session, req);
