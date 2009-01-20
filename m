Return-Path: <linux-kernel-owner+w=401wt.eu-S1758448AbZATSK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758448AbZATSK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 13:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbZATSKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 13:10:15 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:43315 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbZATSKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 13:10:14 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 20 Jan 2009 19:09:58 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: ohci1394: increase AT req. retries, fix ack_busy_X
 from Panasonic camcorders and others
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.abc8aae12462064c@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Camcorders have a tendency to fail read requests to their config ROM and
write request to their FCP command register with ack_busy_X.  This has
become a problem with newer kernels and especially Panasonic camcorders,
causing AV/C in dvgrab and kino to fail.  Dvgrab for example frequently
logs "send oops"; kino reports loss of AV/C control.  I suspect that
lower CPU scheduling latencies in newer kernels made this issue more
prominent in current kernels.

According to
https://sourceforge.net/tracker/?func=detail&atid=114103&aid=2492640&group_id=14103
this can be fixed by configuring the FireWire controller for more
hardware retries for request transmission; these retries are evidently
more successful than libavc1394's own retry loop (typically 3 tries on
top of hardware retries).

Presumably the same issue has been reported at
https://bugzilla.redhat.com/show_bug.cgi?id=449252 and
https://bugzilla.redhat.com/show_bug.cgi?id=477279 .

Tested-by: Mathias Beilstein
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/ohci1394.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/ieee1394/ohci1394.h
===================================================================
--- linux.orig/drivers/ieee1394/ohci1394.h
+++ linux/drivers/ieee1394/ohci1394.h
@@ -26,7 +26,7 @@
 
 #define OHCI1394_DRIVER_NAME      "ohci1394"
 
-#define OHCI1394_MAX_AT_REQ_RETRIES	0x2
+#define OHCI1394_MAX_AT_REQ_RETRIES	0xf
 #define OHCI1394_MAX_AT_RESP_RETRIES	0x2
 #define OHCI1394_MAX_PHYS_RESP_RETRIES	0x8
 #define OHCI1394_MAX_SELF_ID_ERRORS	16

-- 
Stefan Richter
-=====-==--= ---= =-=--
http://arcgraph.de/sr/

