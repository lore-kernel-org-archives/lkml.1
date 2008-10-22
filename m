Return-Path: <linux-kernel-owner+w=401wt.eu-S1758649AbYJVRjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649AbYJVRjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757575AbYJVRdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:33:37 -0400
Received: from kroah.org ([198.145.64.141]:53052 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754674AbYJVRdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:33:35 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tzafrir Cohen <tzafrir@cohens.org.il>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 17/42] Staging: echo: A separate oslec.h for external interface
Date: Wed, 22 Oct 2008 10:28:58 -0700
Message-Id: <1224696563-5170-17-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081022172203.GA4000@kroah.com>
References: <20081022172203.GA4000@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tzafrir Cohen <tzafrir@cohens.org.il>

Split out the external interface to a separate file called oslec.h .

Give the struct a name while we're at it.

Signed-off-by: Tzafrir Cohen <tzafrir@cohens.org.il>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/echo/echo.h  |   53 +------------------------
 drivers/staging/echo/oslec.h |   86 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 89 insertions(+), 50 deletions(-)
 create mode 100644 drivers/staging/echo/oslec.h

diff --git a/drivers/staging/echo/echo.h b/drivers/staging/echo/echo.h
index 7a91b43..5c8b515 100644
--- a/drivers/staging/echo/echo.h
+++ b/drivers/staging/echo/echo.h
@@ -118,21 +118,13 @@ a minor burden.
 */
 
 #include "fir.h"
-
-/* Mask bits for the adaption mode */
-#define ECHO_CAN_USE_ADAPTION	0x01
-#define ECHO_CAN_USE_NLP	0x02
-#define ECHO_CAN_USE_CNG	0x04
-#define ECHO_CAN_USE_CLIP	0x08
-#define ECHO_CAN_USE_TX_HPF	0x10
-#define ECHO_CAN_USE_RX_HPF	0x20
-#define ECHO_CAN_DISABLE	0x40
+#include "oslec.h"
 
 /*!
     G.168 echo canceller descriptor. This defines the working state for a line
     echo canceller.
 */
-typedef struct
+struct echo_can_state
 {
 	int16_t tx,rx;
 	int16_t clean;
@@ -176,45 +168,6 @@ typedef struct
 
 	/* snapshot sample of coeffs used for development */
 	int16_t *snapshot;
-} echo_can_state_t;
-
-/*! Create a voice echo canceller context.
-    \param len The length of the canceller, in samples.
-    \return The new canceller context, or NULL if the canceller could not be created.
-*/
-echo_can_state_t *echo_can_create(int len, int adaption_mode);
-
-/*! Free a voice echo canceller context.
-    \param ec The echo canceller context.
-*/
-void echo_can_free(echo_can_state_t *ec);
-
-/*! Flush (reinitialise) a voice echo canceller context.
-    \param ec The echo canceller context.
-*/
-void echo_can_flush(echo_can_state_t *ec);
-
-/*! Set the adaption mode of a voice echo canceller context.
-    \param ec The echo canceller context.
-    \param adapt The mode.
-*/
-void echo_can_adaption_mode(echo_can_state_t *ec, int adaption_mode);
-
-void echo_can_snapshot(echo_can_state_t *ec);
-
-/*! Process a sample through a voice echo canceller.
-    \param ec The echo canceller context.
-    \param tx The transmitted audio sample.
-    \param rx The received audio sample.
-    \return The clean (echo cancelled) received sample.
-*/
-int16_t echo_can_update(echo_can_state_t *ec, int16_t tx, int16_t rx);
-
-/*! Process to high pass filter the tx signal.
-    \param ec The echo canceller context.
-    \param tx The transmitted auio sample.
-    \return The HP filtered transmit sample, send this to your D/A.
-*/
-int16_t echo_can_hpf_tx(echo_can_state_t *ec, int16_t tx);
+};
 
 #endif	/* __ECHO_H */
diff --git a/drivers/staging/echo/oslec.h b/drivers/staging/echo/oslec.h
new file mode 100644
index 0000000..913fc51
--- /dev/null
+++ b/drivers/staging/echo/oslec.h
@@ -0,0 +1,86 @@
+/*
+ *  OSLEC - A line echo canceller.  This code is being developed
+ *          against and partially complies with G168. Using code from SpanDSP
+ *
+ * Written by Steve Underwood <steveu@coppice.org>
+ *         and David Rowe <david_at_rowetel_dot_com>
+ *
+ * Copyright (C) 2001 Steve Underwood and 2007-2008 David Rowe
+ *
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#ifndef __OSLEC_H
+#define __OSLEC_H
+
+/* TODO: document interface */
+
+/* Mask bits for the adaption mode */
+#define ECHO_CAN_USE_ADAPTION	0x01
+#define ECHO_CAN_USE_NLP	0x02
+#define ECHO_CAN_USE_CNG	0x04
+#define ECHO_CAN_USE_CLIP	0x08
+#define ECHO_CAN_USE_TX_HPF	0x10
+#define ECHO_CAN_USE_RX_HPF	0x20
+#define ECHO_CAN_DISABLE	0x40
+
+/*!
+    G.168 echo canceller descriptor. This defines the working state for a line
+    echo canceller.
+*/
+typedef struct echo_can_state echo_can_state_t;
+
+/*! Create a voice echo canceller context.
+    \param len The length of the canceller, in samples.
+    \return The new canceller context, or NULL if the canceller could not be created.
+*/
+echo_can_state_t *echo_can_create(int len, int adaption_mode);
+
+/*! Free a voice echo canceller context.
+    \param ec The echo canceller context.
+*/
+void echo_can_free(echo_can_state_t *ec);
+
+/*! Flush (reinitialise) a voice echo canceller context.
+    \param ec The echo canceller context.
+*/
+void echo_can_flush(echo_can_state_t *ec);
+
+/*! Set the adaption mode of a voice echo canceller context.
+    \param ec The echo canceller context.
+    \param adapt The mode.
+*/
+void echo_can_adaption_mode(echo_can_state_t *ec, int adaption_mode);
+
+void echo_can_snapshot(echo_can_state_t *ec);
+
+/*! Process a sample through a voice echo canceller.
+    \param ec The echo canceller context.
+    \param tx The transmitted audio sample.
+    \param rx The received audio sample.
+    \return The clean (echo cancelled) received sample.
+*/
+int16_t echo_can_update(echo_can_state_t *ec, int16_t tx, int16_t rx);
+
+/*! Process to high pass filter the tx signal.
+    \param ec The echo canceller context.
+    \param tx The transmitted auio sample.
+    \return The HP filtered transmit sample, send this to your D/A.
+*/
+int16_t echo_can_hpf_tx(echo_can_state_t *ec, int16_t tx);
+
+#endif	/* __OSLEC_H */
-- 
1.6.0.2

