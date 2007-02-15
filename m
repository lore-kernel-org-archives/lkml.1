Return-Path: <linux-kernel-owner+w=401wt.eu-S964893AbXBODvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964893AbXBODvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 22:51:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964896AbXBODvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 22:51:55 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:37252 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964893AbXBODvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 22:51:55 -0500
X-Sasl-enc: kZRBoi/EcnXoT8mJtpNmPvn+bTVy3k2F2Fcv55iHAHi7 1171511511
Date: Thu, 15 Feb 2007 12:52:35 +0900 (WST)
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@osdl.org>
cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>
Subject: [PATCH] autofs4 - header file update
Message-ID: <Pine.LNX.4.64.0702151245020.8001@raven.themaw.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andrew,

The current header file definitions for autofs version 5 have
caused a couple of problems for application builds downstream.

This fixes the problem by separating the definitions.

Signed-off-by: Ian Kent <raven@themaw.net>

Ian

---

--- linux-2.6.20/fs/autofs4/waitq.c.packet-union-redefine	2007-02-13 13:29:53.000000000 +0900
+++ linux-2.6.20/fs/autofs4/waitq.c	2007-02-13 13:29:59.000000000 +0900
@@ -84,7 +84,11 @@ static void autofs4_notify_daemon(struct
 				 struct autofs_wait_queue *wq,
 				 int type)
 {
-	union autofs_packet_union pkt;
+	union {
+		struct autofs_packet_hdr hdr;
+		union autofs_packet_union v4_pkt;
+		union autofs_v5_packet_union v5_pkt;
+	} pkt;
 	size_t pktsz;
 
 	DPRINTK("wait id = 0x%08lx, name = %.*s, type=%d",
@@ -98,7 +102,7 @@ static void autofs4_notify_daemon(struct
 	/* Kernel protocol v4 missing and expire packets */
 	case autofs_ptype_missing:
 	{
-		struct autofs_packet_missing *mp = &pkt.missing;
+		struct autofs_packet_missing *mp = &pkt.v4_pkt.missing;
 
 		pktsz = sizeof(*mp);
 
@@ -110,7 +114,7 @@ static void autofs4_notify_daemon(struct
 	}
 	case autofs_ptype_expire_multi:
 	{
-		struct autofs_packet_expire_multi *ep = &pkt.expire_multi;
+		struct autofs_packet_expire_multi *ep = &pkt.v4_pkt.expire_multi;
 
 		pktsz = sizeof(*ep);
 
@@ -129,7 +133,7 @@ static void autofs4_notify_daemon(struct
 	case autofs_ptype_missing_direct:
 	case autofs_ptype_expire_direct:
 	{
-		struct autofs_v5_packet *packet = &pkt.v5_packet;
+		struct autofs_v5_packet *packet = &pkt.v5_pkt.v5_packet;
 
 		pktsz = sizeof(*packet);
 
--- linux-2.6.20/include/linux/auto_fs4.h.packet-union-redefine	2007-02-13 13:23:20.000000000 +0900
+++ linux-2.6.20/include/linux/auto_fs4.h	2007-02-13 13:26:35.000000000 +0900
@@ -59,6 +59,13 @@ struct autofs_packet_expire_multi {
 	char name[NAME_MAX+1];
 };
 
+union autofs_packet_union {
+	struct autofs_packet_hdr hdr;
+	struct autofs_packet_missing missing;
+	struct autofs_packet_expire expire;
+	struct autofs_packet_expire_multi expire_multi;
+};
+
 /* autofs v5 common packet struct */
 struct autofs_v5_packet {
 	struct autofs_packet_hdr hdr;
@@ -78,12 +85,13 @@ typedef struct autofs_v5_packet autofs_p
 typedef struct autofs_v5_packet autofs_packet_missing_direct_t;
 typedef struct autofs_v5_packet autofs_packet_expire_direct_t;
 
-union autofs_packet_union {
+union autofs_v5_packet_union {
 	struct autofs_packet_hdr hdr;
-	struct autofs_packet_missing missing;
-	struct autofs_packet_expire expire;
-	struct autofs_packet_expire_multi expire_multi;
 	struct autofs_v5_packet v5_packet;
+	autofs_packet_missing_indirect_t missing_indirect;
+	autofs_packet_expire_indirect_t expire_indirect;
+	autofs_packet_missing_direct_t missing_direct;
+	autofs_packet_expire_direct_t expire_direct;
 };
 
 #define AUTOFS_IOC_EXPIRE_MULTI		_IOW(0x93,0x66,int)
