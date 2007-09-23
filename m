Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbXIWDFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbXIWDFb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 23:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbXIWDFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 23:05:24 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:48916 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbXIWDFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 23:05:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Lhd+lgd9kxAicZbz9cTkcsO7/7/o3sp/ZepGP1tHrJ9XwiVxNVMDbeAdP23x20L2akG+otMRi+rPGZ20EETvutuavFXjIZ3NaRQ0F8bwv2e7mXR0iwhtkpZ8XMawnAJSvLoRArofCjyvlaUnhtp8xia1SpqUbx4rgwB3HqpubsQ=
Date: Sun, 23 Sep 2007 11:01:05 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, marcel@holtmann.org,
       bluez-devel@lists.sourceforge.net, maxk@qualcomm.com
Subject: [-mm Patch] net/bluetooth/hidp/core.c: Make hidp_setup_input()
	return int
Message-ID: <20070923030105.GH2475@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070918011841.2381bd93.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch does the following things:

- Make hidp_setup_input() return int to indicate errors.
- Check its return value to handle errors.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
 net/bluetooth/hidp/core.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6.23-rc6-mm1/net/bluetooth/hidp/core.c
===================================================================
--- linux-2.6.23-rc6-mm1.orig/net/bluetooth/hidp/core.c
+++ linux-2.6.23-rc6-mm1/net/bluetooth/hidp/core.c
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
@@ -823,7 +823,8 @@ int hidp_add_connection(struct hidp_conn
 	session->idle_to = req->idle_to;
 
 	if (session->input)
-		hidp_setup_input(session, req);
+		if ((err = (hidp_setup_input(session, req))))
+			goto failed;
 
 	if (session->hid)
 		hidp_setup_hid(session, req);
