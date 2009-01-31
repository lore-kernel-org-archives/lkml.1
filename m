Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbZAaJhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbZAaJhd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 04:37:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbZAaJhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 04:37:22 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:18311 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbZAaJhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 04:37:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=NUQVrHDv77Ys4JIqcY3A9FES9duEhyYvLFWVTv5D3AU4tIcI8D3o8XtTGyu12MGj19
         vulPJ+Xgc5/chVmrHAQDLnNCArI+CtIsM+eFyjdkS37wXz+ejx1G2+amFH2JCD+a+dFW
         iezi2nTdQoG2P821boHZTEFQg+iL9uWuUoEdI=
MIME-Version: 1.0
Date: Sat, 31 Jan 2009 10:37:17 +0100
Message-ID: <1cd3d67c0901310137m3b15af09rf1db91ad28c8fdb6@mail.gmail.com>
Subject: Subject: [PATCH 2.6.28-git] net: packet socket packet_lookup_frame 
	fix
From: Sebastiano Di Paola <sebastiano.dipaola@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       "Fred N. van Kempen" <waltje@uWalt.NL.Mugnet.ORG>,
       Alan Cox <gw4pts@gw4pts.ampr.org>, paolo.abeni@gmail.com,
       sebastiano.dipaola@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastiano Di Paola and Paolo Abeni

packet_lookup_frames() fails to get user frame if current frame header
status contains extra flags.
This is due to the wrong assumption on the operators precedence during
frame status tests.
Fixed by forcing the right operators precedence order with explicit brackets.

Signed-off-by: Paolo Abeni <paolo.abeni@gmail.com>
Signed-off-by: Sebastiano Di Paola <sebastiano.dipaola@gmail.com>
---

The issue arises when packet_lookup_frame() is called with status ==
TP_STATUS_USER, that is when the packet socket is memory mapped and a
select() or a poll() syscall is performed on the socket.
If h.h1->tp_status is set to TP_STATUS_USER | TP_STATUS_LOSING (or any
other value with multiple bits set), the tested expression evaluate to
TP_STATUS_USER (!= 0) and a null pointer is returned, even if the
current frame is ready to be read by the user. In such scenario the
poll() and the select() system call stop working.
N.B. This problem is present from version >= 2.6.27

--- linux-2.6.28/net/packet/af_packet.c.orig	2009-01-30 16:29:56.000000000 +0100
+++ linux-2.6.28/net/packet/af_packet.c	2009-01-30 16:27:58.000000000 +0100
@@ -220,13 +220,13 @@ static void *packet_lookup_frame(struct
 	h.raw = po->pg_vec[pg_vec_pos] + (frame_offset * po->frame_size);
 	switch (po->tp_version) {
 	case TPACKET_V1:
-		if (status != h.h1->tp_status ? TP_STATUS_USER :
-						TP_STATUS_KERNEL)
+		if (status != (h.h1->tp_status ? TP_STATUS_USER :
+						TP_STATUS_KERNEL))
 			return NULL;
 		break;
 	case TPACKET_V2:
-		if (status != h.h2->tp_status ? TP_STATUS_USER :
-						TP_STATUS_KERNEL)
+		if (status != (h.h2->tp_status ? TP_STATUS_USER :
+						TP_STATUS_KERNEL))
 			return NULL;
 		break;
 	}
