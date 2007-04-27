Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbXD0SyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbXD0SyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 14:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754344AbXD0SyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:54:14 -0400
Received: from webmail.frequentis.com ([213.47.210.151]:14292 "EHLO
	webmail.frequentis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377AbXD0SyF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:54:05 -0400
X-Greylist: delayed 851 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Apr 2007 14:54:04 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH 2.6.19.2] net/lapb: ITU-T Q.921 mode implemented
Date: Fri, 27 Apr 2007 20:39:50 +0200
Message-ID: <CC5E65565EFADD4CAD01F1ADF57AA17AA97B72@VIECLEX01.frequentis.frq>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.19.2] net/lapb: ITU-T Q.921 mode implemented
thread-index: AceI+3BA6oviTp4UR7ikbMMjk37nWw==
From: "JESSICH Jasmin" <Jasmin.JESSICH@frequentis.com>
To: <linux-x25@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 27 Apr 2007 18:39:51.0536 (UTC) FILETIME=[70E1BF00:01C788FB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jasmin Jessich <jasmin.jessich@frequentis.com>

Added ITU-T Q.921 mode to LAPB protocol driver (net/lapb/).
Added dynamic switching of the debugging outputs using
parameter setting.
I have checked the Q.921 implementation against a Q.921
protocol tester.
I couldn't check, if the x25 implementation is still
working, because I have no protocol tester for x25 LAPB.
I think I didn't touch the old functionality, but I would be
happy if someone would test it.

Signed-off-by: Jasmin Jessich <jasmin.jessich@frequentis.com>
---
_________________________________________________________
Ing. Jasmin Jessich
Software Engineer
FREQUENTIS GmbH

Innovationsstrasse 1, 1100 Vienna, Austria
Phone   +43-1-811 50 - 2395
Mobile  -
Fax     +43-1-811 50 - 77 2395
Web     www.frequentis.com
E-Mail  jasmin.jessich@frequentis.com

Handelsgericht Wien (Vienna Commercial Court): FN 72115 b 
DVR 0364797, ATU 14715600 
_________________________________________________________


Index: include/net/lapb.h
===================================================================
--- include/net/lapb.h	(revision 3155)
+++ include/net/lapb.h	(working copy)
@@ -46,6 +46,12 @@
 #define	LAPB_ADDR_C	0x0F
 #define	LAPB_ADDR_D	0x07
 
+/* LAPD ITU_T Q.921 mode command responses
+ * master: command = 1, response = 0
+ * slave: command = 0, response = 1
+ */
+#define	LAPB_CMD_RESP 0x02
+
 /* Define Link State constants. */
 enum {
 	LAPB_STATE_0,	/* Disconnected State		*/
@@ -60,10 +66,22 @@
 #define	LAPB_DEFAULT_T1			(5 * HZ)	/* T1=5s
*/
 #define	LAPB_DEFAULT_T2			(1 * HZ)	/* T2=1s
*/
 #define	LAPB_DEFAULT_N2			20		/* N2=20
*/
+#define	LAPB_DEFAULT_SAPI		0
+#define	LAPB_DEFAULT_TEI		0
+#define	LAPB_DEFAULT_T203		(10 * HZ)	/* T203=10s
*/
 
 #define	LAPB_SMODULUS	8
 #define	LAPB_EMODULUS	128
 
+#define LAPB_Q921_FLG_ESTABLISH_ALLOWED	0x01
+#define LAPB_Q921_FLG_DO_DISCONNECT	0x02
+#define LAPB_Q921_FLG_L3_INITIATED	0x04
+#define LAPB_Q921_FLG_TIMER_RECOVERY	0x08
+#define LAPB_Q921_FLG_T203		0x10
+
+/* Dynamical debugging en/disabled (1/0) */
+#define	LAPB_DEBUG_DYN	0
+
 /*
  *	Information about the current frame.
  */
@@ -88,7 +106,9 @@
 	unsigned short		vs, vr, va;
 	unsigned char		condition;
 	unsigned short		n2, n2count;
-	unsigned short		t1, t2;
+	unsigned short		t1, t2, t203;
+	unsigned char		sapi, tei;
+	unsigned char		q921_flags;
 	struct timer_list	t1timer, t2timer;
 
 	/* Internal control information */
@@ -97,6 +117,10 @@
 	unsigned char		window;
 	struct lapb_register_struct callbacks;
 
+#if LAPB_DEBUG_DYN == 1
+	unsigned int		dbg_level;
+#endif
+
 	/* FRMR control information */
 	struct lapb_frame	frmr_data;
 	unsigned char		frmr_type;
@@ -119,10 +143,12 @@
 extern void lapb_kick(struct lapb_cb *lapb);
 extern void lapb_transmit_buffer(struct lapb_cb *lapb, struct sk_buff *,
int);
 extern void lapb_establish_data_link(struct lapb_cb *lapb);
-extern void lapb_enquiry_response(struct lapb_cb *lapb);
+extern void lapb_reestablish(struct lapb_cb *lapb);
+extern void lapb_enquiry_response(struct lapb_cb *lapb, int);
 extern void lapb_timeout_response(struct lapb_cb *lapb);
 extern void lapb_check_iframes_acked(struct lapb_cb *lapb, unsigned short);
 extern void lapb_check_need_response(struct lapb_cb *lapb, int, int);
+extern void lapb_initialize_retransmission(struct lapb_cb *lapb);
 
 /* lapb_subr.c */
 extern void lapb_clear_queues(struct lapb_cb *lapb);
@@ -136,6 +162,7 @@
 /* lapb_timer.c */
 extern void lapb_start_t1timer(struct lapb_cb *lapb);
 extern void lapb_start_t2timer(struct lapb_cb *lapb);
+extern void lapb_start_t203(struct lapb_cb *lapb);
 extern void lapb_stop_t1timer(struct lapb_cb *lapb);
 extern void lapb_stop_t2timer(struct lapb_cb *lapb);
 extern int  lapb_t1timer_running(struct lapb_cb *lapb);
@@ -149,4 +176,19 @@
  */
 #define	LAPB_DEBUG	0
 
+#if LAPB_DEBUG_DYN == 1
+
+/* Dynamical debugging needs all debug printouts enabled */
+# undef LAPB_DEBUG
+# define LAPB_DEBUG 3
+
+# define LAPB_DEBUG_DYN_LEVEL_DEFAULT 2
+
+# define LAPB_DEBUG_DYN_CHK( _p_lapb, _level ) \
+   if (_p_lapb->dbg_level > _level )
+#else
+#  define LAPB_DEBUG_DYN_CHK( _p_lapb, _level )
+
 #endif
+
+#endif
Index: include/linux/lapb.h
===================================================================
--- include/linux/lapb.h	(revision 3155)
+++ include/linux/lapb.h	(working copy)
@@ -23,6 +23,12 @@
 #define	LAPB_DTE		0x00
 #define	LAPB_DCE		0x04
 
+/* LAPD according to ITU-T Q.921 specification
+ * slave side configured with LAPB_SLP
+ * master side configured with LAPB_MLP
+ */
+#define	LAPB_Q921		0x08
+
 struct lapb_register_struct {
 	void (*connect_confirmation)(struct net_device *dev, int reason);
 	void (*connect_indication)(struct net_device *dev, int reason);
@@ -42,6 +48,11 @@
 	unsigned int window;
 	unsigned int state;
 	unsigned int mode;
+	unsigned int sapi;
+	unsigned int tei;
+	unsigned int t203;
+	unsigned int t203timer;
+	unsigned int dbg_level;
 };
 
 extern int lapb_register(struct net_device *dev, struct lapb_register_struct
*callbacks);
Index: net/lapb/lapb_timer.c
===================================================================
--- net/lapb/lapb_timer.c	(revision 3155)
+++ net/lapb/lapb_timer.c	(working copy)
@@ -54,11 +54,20 @@
 
 	lapb->t2timer.data     = (unsigned long)lapb;
 	lapb->t2timer.function = &lapb_t2timer_expiry;
-	lapb->t2timer.expires  = jiffies + lapb->t2;
+	lapb->t2timer.expires  = jiffies +
+	    (lapb->q921_flags & LAPB_Q921_FLG_T203 ? lapb->t203 : lapb->t2);
 
 	add_timer(&lapb->t2timer);
 }
 
+void lapb_start_t203(struct lapb_cb *lapb)
+{
+	if (lapb->mode & LAPB_Q921) {
+		lapb->q921_flags |= LAPB_Q921_FLG_T203;
+		lapb_start_t2timer(lapb);
+	}
+}
+
 void lapb_stop_t1timer(struct lapb_cb *lapb)
 {
 	del_timer(&lapb->t1timer);
@@ -67,6 +76,7 @@
 void lapb_stop_t2timer(struct lapb_cb *lapb)
 {
 	del_timer(&lapb->t2timer);
+	lapb->q921_flags &= ~LAPB_Q921_FLG_T203;
 }
 
 int lapb_t1timer_running(struct lapb_cb *lapb)
@@ -78,7 +88,15 @@
 {
 	struct lapb_cb *lapb = (struct lapb_cb *)param;
 
-	if (lapb->condition & LAPB_ACK_PENDING_CONDITION) {
+	if (lapb->mode & LAPB_Q921 &&
+	    lapb->q921_flags & LAPB_Q921_FLG_T203) {
+		lapb->q921_flags &= ~LAPB_Q921_FLG_T203;
+		if (lapb->state == LAPB_STATE_3) {
+			lapb->q921_flags |= LAPB_Q921_FLG_TIMER_RECOVERY;
+			lapb_enquiry_response(lapb, LAPB_COMMAND);
+			lapb_start_t1timer(lapb);
+		}
+	} else if (lapb->condition & LAPB_ACK_PENDING_CONDITION) {
 		lapb->condition &= ~LAPB_ACK_PENDING_CONDITION;
 		lapb_timeout_response(lapb);
 	}
@@ -94,9 +112,14 @@
 		 *	If we are a DCE, keep going DM .. DM .. DM
 		 */
 		case LAPB_STATE_0:
+		if (!(lapb->mode & LAPB_Q921)) {
 			if (lapb->mode & LAPB_DCE)
 				lapb_send_control(lapb, LAPB_DM,
LAPB_POLLOFF, LAPB_RESPONSE);
-			break;
+		} else {
+			/* do not restart timer */
+			return;
+		}
+		break;
 
 		/*
 		 *	Awaiting connection state, send SABM(E), up to N2
times.
@@ -104,9 +127,11 @@
 		case LAPB_STATE_1: 
 			if (lapb->n2count == lapb->n2) {
 				lapb_clear_queues(lapb);
+				lapb->q921_flags &=
~LAPB_Q921_FLG_DO_DISCONNECT;
 				lapb->state = LAPB_STATE_0;
 				lapb_disconnect_indication(lapb,
LAPB_TIMEDOUT);
 #if LAPB_DEBUG > 0
+				LAPB_DEBUG_DYN_CHK(lapb, 0)
 				printk(KERN_DEBUG "lapb: (%p) S1 -> S0\n",
lapb->dev);
 #endif
 				return;
@@ -114,11 +139,13 @@
 				lapb->n2count++;
 				if (lapb->mode & LAPB_EXTENDED) {
 #if LAPB_DEBUG > 1
+					LAPB_DEBUG_DYN_CHK(lapb, 1)
 					printk(KERN_DEBUG "lapb: (%p) S1 TX
SABME(1)\n", lapb->dev);
 #endif
 					lapb_send_control(lapb, LAPB_SABME,
LAPB_POLLON, LAPB_COMMAND);
 				} else {
 #if LAPB_DEBUG > 1
+					LAPB_DEBUG_DYN_CHK(lapb, 1)
 					printk(KERN_DEBUG "lapb: (%p) S1 TX
SABM(1)\n", lapb->dev);
 #endif
 					lapb_send_control(lapb, LAPB_SABM,
LAPB_POLLON, LAPB_COMMAND);
@@ -135,12 +162,14 @@
 				lapb->state = LAPB_STATE_0;
 				lapb_disconnect_confirmation(lapb,
LAPB_TIMEDOUT);
 #if LAPB_DEBUG > 0
+				LAPB_DEBUG_DYN_CHK(lapb, 0)
 				printk(KERN_DEBUG "lapb: (%p) S2 -> S0\n",
lapb->dev);
 #endif
 				return;
 			} else {
 				lapb->n2count++;
 #if LAPB_DEBUG > 1
+				LAPB_DEBUG_DYN_CHK(lapb, 1)
 				printk(KERN_DEBUG "lapb: (%p) S2 TX
DISC(1)\n", lapb->dev);
 #endif
 				lapb_send_control(lapb, LAPB_DISC,
LAPB_POLLON, LAPB_COMMAND);
@@ -152,17 +181,35 @@
 		 */
 		case LAPB_STATE_3:
 			if (lapb->n2count == lapb->n2) {
+				if (lapb->mode & LAPB_Q921) {
+					lapb_reestablish(lapb);
+				return;
+				}
 				lapb_clear_queues(lapb);
 				lapb->state = LAPB_STATE_0;
 				lapb_stop_t2timer(lapb);
 				lapb_disconnect_indication(lapb,
LAPB_TIMEDOUT);
 #if LAPB_DEBUG > 0
+				LAPB_DEBUG_DYN_CHK(lapb, 0)
 				printk(KERN_DEBUG "lapb: (%p) S3 -> S0\n",
lapb->dev);
 #endif
 				return;
 			} else {
 				lapb->n2count++;
-				lapb_requeue_frames(lapb);
+				if (lapb->mode & LAPB_Q921) {
+					lapb->q921_flags |=
+					   LAPB_Q921_FLG_TIMER_RECOVERY;
+					/* lapb_requeue_frames would requeue
+					 * all frames, but Q.921 needs to
send
+					 * only the last transmitted I frame.
+					 * There is an implementation option
to
+					 * send an enquery. Not requeuing and
+					 * immediately sending the the RR
will
+					 * choose this option.
+					 */
+					lapb_enquiry_response(lapb,
LAPB_COMMAND);
+				} else
+					lapb_requeue_frames(lapb);
 			}
 			break;
 
@@ -175,6 +222,7 @@
 				lapb->state = LAPB_STATE_0;
 				lapb_disconnect_indication(lapb,
LAPB_TIMEDOUT);
 #if LAPB_DEBUG > 0
+				LAPB_DEBUG_DYN_CHK(lapb, 0)
 				printk(KERN_DEBUG "lapb: (%p) S4 -> S0\n",
lapb->dev);
 #endif
 				return;
Index: net/lapb/lapb_in.c
===================================================================
--- net/lapb/lapb_in.c	(revision 3155)
+++ net/lapb/lapb_in.c	(working copy)
@@ -46,11 +46,13 @@
 	switch (frame->type) {
 		case LAPB_SABM:
 #if LAPB_DEBUG > 1
+			LAPB_DEBUG_DYN_CHK(lapb, 1)
 			printk(KERN_DEBUG "lapb: (%p) S0 RX SABM(%d)\n",
 			       lapb->dev, frame->pf);
 #endif
 			if (lapb->mode & LAPB_EXTENDED) {
 #if LAPB_DEBUG > 1
+				LAPB_DEBUG_DYN_CHK(lapb, 1)
 				printk(KERN_DEBUG "lapb: (%p) S0 TX
DM(%d)\n",
 				       lapb->dev, frame->pf);
 #endif
@@ -58,10 +60,12 @@
 						  LAPB_RESPONSE);
 			} else {
 #if LAPB_DEBUG > 1
+				LAPB_DEBUG_DYN_CHK(lapb, 1)
 				printk(KERN_DEBUG "lapb: (%p) S0 TX
UA(%d)\n",
 				       lapb->dev, frame->pf);
 #endif
 #if LAPB_DEBUG > 0
+				LAPB_DEBUG_DYN_CHK(lapb, 0)
 				printk(KERN_DEBUG "lapb: (%p) S0 -> S3\n",
 				       lapb->dev);
 #endif
@@ -72,6 +76,8 @@
 				lapb->state     = LAPB_STATE_3;
 				lapb->condition = 0x00;
 				lapb->n2count   = 0;
+				lapb->q921_flags &=
+					~LAPB_Q921_FLG_TIMER_RECOVERY;
 				lapb->vs        = 0;
 				lapb->vr        = 0;
 				lapb->va        = 0;
@@ -81,15 +87,32 @@
 
 		case LAPB_SABME:
 #if LAPB_DEBUG > 1
+			LAPB_DEBUG_DYN_CHK(lapb, 1)
 			printk(KERN_DEBUG "lapb: (%p) S0 RX SABME(%d)\n",
 			       lapb->dev, frame->pf);
 #endif
 			if (lapb->mode & LAPB_EXTENDED) {
+				if (lapb->mode & LAPB_Q921 &&
+				    !(lapb->q921_flags &
+				      LAPB_Q921_FLG_ESTABLISH_ALLOWED)) {
 #if LAPB_DEBUG > 1
+					LAPB_DEBUG_DYN_CHK(lapb, 1)
+					printk(KERN_DEBUG
+					       "lapb: (%p) S0 TX DM(%d)\n",
+					       lapb->dev, frame->pf);
+#endif
+					lapb_send_control(lapb, LAPB_DM,
+							  frame->pf,
+							  LAPB_RESPONSE);
+					break;
+				}
+#if LAPB_DEBUG > 1
+				LAPB_DEBUG_DYN_CHK(lapb, 1)
 				printk(KERN_DEBUG "lapb: (%p) S0 TX
UA(%d)\n",
 				       lapb->dev, frame->pf);
 #endif
 #if LAPB_DEBUG > 0
+				LAPB_DEBUG_DYN_CHK(lapb, 0)
 				printk(KERN_DEBUG "lapb: (%p) S0 -> S3\n",
 				       lapb->dev);
 #endif
@@ -100,12 +123,16 @@
 				lapb->state     = LAPB_STATE_3;
 				lapb->condition = 0x00;
 				lapb->n2count   = 0;
+				lapb->q921_flags &=
+					~LAPB_Q921_FLG_TIMER_RECOVERY;
 				lapb->vs        = 0;
 				lapb->vr        = 0;
 				lapb->va        = 0;
+				lapb_start_t203(lapb);
 				lapb_connect_indication(lapb, LAPB_OK);
 			} else {
 #if LAPB_DEBUG > 1
+				LAPB_DEBUG_DYN_CHK(lapb, 1)
 				printk(KERN_DEBUG "lapb: (%p) S0 TX
DM(%d)\n",
 				       lapb->dev, frame->pf);
 #endif
@@ -116,8 +143,22 @@
 
 		case LAPB_DISC:
 #if LAPB_DEBUG > 1
+			LAPB_DEBUG_DYN_CHK(lapb, 1)
 			printk(KERN_DEBUG "lapb: (%p) S0 RX DISC(%d)\n",
 			       lapb->dev, frame->pf);
+#endif
+			if (lapb->mode & LAPB_Q921) {
+#if LAPB_DEBUG > 1
+				LAPB_DEBUG_DYN_CHK(lapb, 1)
+				printk(KERN_DEBUG "lapb: (%p) S0 TX
DM(%d)\n",
+				       lapb->dev, frame->pf);
+#endif
+				lapb_send_control(lapb, LAPB_DM, frame->pf,
+						  LAPB_RESPONSE);
+				break;
+			}
+#if LAPB_DEBUG > 1
+			LAPB_DEBUG_DYN_CHK(lapb, 1)
 			printk(KERN_DEBUG "lapb: (%p) S0 TX UA(%d)\n",
 			       lapb->dev, frame->pf);
 #endif
@@ -125,6 +166,31 @@
 					  LAPB_RESPONSE);
 			break;
 
+		case LAPB_DM:
+			if (lapb->mode & LAPB_Q921) {
+#if LAPB_DEBUG > 1
+				LAPB_DEBUG_DYN_CHK(lapb, 1)
+				printk(KERN_DEBUG "lapb: (%p) S0 RX
DM(%d)\n",
+				       lapb->dev, frame->pf);
+#endif
+				if (!frame->pf &&
+				    lapb->q921_flags &
+				    LAPB_Q921_FLG_ESTABLISH_ALLOWED) {
+					lapb_establish_data_link(lapb);
+					lapb->q921_flags |=
+						LAPB_Q921_FLG_L3_INITIATED;
+
+#if LAPB_DEBUG > 0
+					LAPB_DEBUG_DYN_CHK(lapb, 0)
+					printk(KERN_DEBUG
+					       "lapb: (%p) S0 -> S1\n",
+					       lapb->dev);
+#endif
+					lapb->state = LAPB_STATE_1;
+				}
+			}
+			break;
+
 		default:
 			break;
 	}
@@ -142,11 +208,13 @@
 	switch (frame->type) {
 		case LAPB_SABM:
 #if LAPB_DEBUG > 1
+			LAPB_DEBUG_DYN_CHK(lapb, 1)
 			printk(KERN_DEBUG "lapb: (%p) S1 RX SABM(%d)\n",
 			       lapb->dev, frame->pf);
 #endif
 			if (lapb->mode & LAPB_EXTENDED) {
 #if LAPB_DEBUG > 1
+				LAPB_DEBUG_DYN_CHK(lapb, 1)
 				printk(KERN_DEBUG "lapb: (%p) S1 TX
DM(%d)\n",
 				       lapb->dev, frame->pf);
 #endif
@@ -154,6 +222,7 @@
 						  LAPB_RESPONSE);
 			} else {
 #if LAPB_DEBUG > 1
+				LAPB_DEBUG_DYN_CHK(lapb, 1)
 				printk(KERN_DEBUG "lapb: (%p) S1 TX
UA(%d)\n",
 				       lapb->dev, frame->pf);
 #endif
@@ -164,11 +233,13 @@
 
 		case LAPB_SABME:
 #if LAPB_DEBUG > 1
+			LAPB_DEBUG_DYN_CHK(lapb, 1)
 			printk(KERN_DEBUG "lapb: (%p) S1 RX SABME(%d)\n",
 			       lapb->dev, frame->pf);
 #endif
 			if (lapb->mode & LAPB_EXTENDED) {
 #if LAPB_DEBUG > 1
+				LAPB_DEBUG_DYN_CHK(lapb, 1)
 				printk(KERN_DEBUG "lapb: (%p) S1 TX
UA(%d)\n",
 				       lapb->dev, frame->pf);
 #endif
@@ -176,6 +247,7 @@
 						  LAPB_RESPONSE);
 			} else {
 #if LAPB_DEBUG > 1
+				LAPB_DEBUG_DYN_CHK(lapb, 1)
 				printk(KERN_DEBUG "lapb: (%p) S1 TX
DM(%d)\n",
 				       lapb->dev, frame->pf);
 #endif
@@ -186,8 +258,10 @@
 
 		case LAPB_DISC:
 #if LAPB_DEBUG > 1
+			LAPB_DEBUG_DYN_CHK(lapb, 1)
 			printk(KERN_DEBUG "lapb: (%p) S1 RX DISC(%d)\n",
 			       lapb->dev, frame->pf);
+			LAPB_DEBUG_DYN_CHK(lapb, 1)
 			printk(KERN_DEBUG "lapb: (%p) S1 TX DM(%d)\n",
 			       lapb->dev, frame->pf);
 #endif
@@ -197,11 +271,71 @@
 
 		case LAPB_UA:
 #if LAPB_DEBUG > 1
+			LAPB_DEBUG_DYN_CHK(lapb, 1)
 			printk(KERN_DEBUG "lapb: (%p) S1 RX UA(%d)\n",
 			       lapb->dev, frame->pf);
 #endif
 			if (frame->pf) {
+				if (lapb->mode & LAPB_Q921) {
+					if (lapb-> q921_flags &
+					    LAPB_Q921_FLG_L3_INITIATED) {
+						lapb->q921_flags &=
+
~LAPB_Q921_FLG_L3_INITIATED;
+						lapb->vr = 0;
+					} else if (lapb->vs != lapb->va) {
+						lapb_clear_queues(lapb);
+					}
+					lapb_connect_confirmation(lapb,
+								  LAPB_OK);
+					if (lapb->q921_flags &
+					    LAPB_Q921_FLG_DO_DISCONNECT) {
+						lapb->q921_flags &=
+
~LAPB_Q921_FLG_DO_DISCONNECT;
+						lapb->condition = 0x00;
+						lapb->n2count   = 0;
+						lapb->q921_flags &=
+
~LAPB_Q921_FLG_TIMER_RECOVERY;
+						lapb->vs        = 0;
+						lapb->va        = 0;
+						lapb_clear_queues(lapb);
+						lapb_send_control(lapb,
+								  LAPB_DISC,
+
LAPB_POLLON,
+
LAPB_COMMAND);
+						lapb_start_t1timer(lapb);
+						lapb_stop_t2timer(lapb);
+						lapb->state = LAPB_STATE_2;
+#if LAPB_DEBUG > 1
+						LAPB_DEBUG_DYN_CHK(lapb, 1)
+						printk(KERN_DEBUG
+						   "lapb: (%p) S1 TX
DISC(1)\n",
+						   lapb->dev);
+#endif
 #if LAPB_DEBUG > 0
+						LAPB_DEBUG_DYN_CHK(lapb, 0)
+						printk(KERN_DEBUG
+						       "lapb: (%p) S1 ->
S2\n",
+						       lapb->dev);
+#endif
+					} else {
+#if LAPB_DEBUG > 0
+						LAPB_DEBUG_DYN_CHK(lapb, 0)
+						printk(KERN_DEBUG
+						       "lapb: (%p) S1 ->
S3\n",
+						       lapb->dev);
+#endif
+						lapb_stop_t1timer(lapb);
+						lapb_start_t203(lapb);
+						lapb->state = LAPB_STATE_3;
+						lapb->q921_flags &=
+
~LAPB_Q921_FLG_TIMER_RECOVERY;
+						lapb->vs    = 0;
+						lapb->va    = 0;
+					}
+					break;
+				}
+#if LAPB_DEBUG > 0
+				LAPB_DEBUG_DYN_CHK(lapb, 0)
 				printk(KERN_DEBUG "lapb: (%p) S1 -> S3\n",
 				       lapb->dev);
 #endif
@@ -219,15 +353,19 @@
 
 		case LAPB_DM:
 #if LAPB_DEBUG > 1
+			LAPB_DEBUG_DYN_CHK(lapb, 1)
 			printk(KERN_DEBUG "lapb: (%p) S1 RX DM(%d)\n",
 			       lapb->dev, frame->pf);
 #endif
 			if (frame->pf) {
 #if LAPB_DEBUG > 0
+				LAPB_DEBUG_DYN_CHK(lapb, 0)
 				printk(KERN_DEBUG "lapb: (%p) S1 -> S0\n",
 				       lapb->dev);
 #endif
 				lapb_clear_queues(lapb);
+				lapb->q921_flags &=
+					~LAPB_Q921_FLG_DO_DISCONNECT;
 				lapb->state = LAPB_STATE_0;
 				lapb_start_t1timer(lapb);
 				lapb_stop_t2timer(lapb);
@@ -250,8 +388,10 @@
 		case LAPB_SABM:
 		case LAPB_SABME:
 #if LAPB_DEBUG > 1
+			LAPB_DEBUG_DYN_CHK(lapb, 1)
 			printk(KERN_DEBUG "lapb: (%p) S2 RX
{SABM,SABME}(%d)\n",
 			       lapb->dev, frame->pf);
+			LAPB_DEBUG_DYN_CHK(lapb, 1)
 			printk(KERN_DEBUG "lapb: (%p) S2 TX DM(%d)\n",
 			       lapb->dev, frame->pf);
 #endif
@@ -261,8 +401,10 @@
 
 		case LAPB_DISC:
 #if LAPB_DEBUG > 1
+			LAPB_DEBUG_DYN_CHK(lapb, 1)
 			printk(KERN_DEBUG "lapb: (%p) S2 RX DISC(%d)\n",
 			       lapb->dev, frame->pf);
+			LAPB_DEBUG_DYN_CHK(lapb, 1)
 			printk(KERN_DEBUG "lapb: (%p) S2 TX UA(%d)\n",
 			       lapb->dev, frame->pf);
 #endif
@@ -272,11 +414,13 @@
 
 		case LAPB_UA:
 #if LAPB_DEBUG > 1
+			LAPB_DEBUG_DYN_CHK(lapb, 1)
 			printk(KERN_DEBUG "lapb: (%p) S2 RX UA(%d)\n",
 			       lapb->dev, frame->pf);
 #endif
 			if (frame->pf) {
 #if LAPB_DEBUG > 0
+				LAPB_DEBUG_DYN_CHK(lapb, 0)
 				printk(KERN_DEBUG "lapb: (%p) S2 -> S0\n",
 				       lapb->dev);
 #endif
@@ -289,11 +433,13 @@
 
 		case LAPB_DM:
 #if LAPB_DEBUG > 1
+			LAPB_DEBUG_DYN_CHK(lapb, 1)
 			printk(KERN_DEBUG "lapb: (%p) S2 RX DM(%d)\n",
 			       lapb->dev, frame->pf);
 #endif
 			if (frame->pf) {
 #if LAPB_DEBUG > 0
+				LAPB_DEBUG_DYN_CHK(lapb, 0)
 				printk(KERN_DEBUG "lapb: (%p) S2 -> S0\n",
 				       lapb->dev);
 #endif
@@ -309,15 +455,23 @@
 		case LAPB_REJ:
 		case LAPB_RNR:
 		case LAPB_RR:
+			if (lapb->mode & LAPB_Q921) {
+				break;
+			}
 #if LAPB_DEBUG > 1
+			LAPB_DEBUG_DYN_CHK(lapb, 1)
 			printk(KERN_DEBUG "lapb: (%p) S2 RX {I,REJ,RNR,RR}"
 			       "(%d)\n", lapb->dev, frame->pf);
-			printk(KERN_DEBUG "lapb: (%p) S2 RX DM(%d)\n",
-			       lapb->dev, frame->pf);
 #endif
-			if (frame->pf)
+			if (frame->pf) {
+#if LAPB_DEBUG > 1
+				LAPB_DEBUG_DYN_CHK(lapb, 1)
+				printk(KERN_DEBUG "lapb: (%p) S2 TX
DM(%d)\n",
+				       lapb->dev, frame->pf);
+#endif
 				lapb_send_control(lapb, LAPB_DM, frame->pf,
 						  LAPB_RESPONSE);
+			}
 			break;
 	}
 
@@ -334,15 +488,18 @@
 	int queued = 0;
 	int modulus = (lapb->mode & LAPB_EXTENDED) ? LAPB_EMODULUS :
 						     LAPB_SMODULUS;
+	int checknr = 1;
 
 	switch (frame->type) {
 		case LAPB_SABM:
 #if LAPB_DEBUG > 1
+			LAPB_DEBUG_DYN_CHK(lapb, 1)
 			printk(KERN_DEBUG "lapb: (%p) S3 RX SABM(%d)\n",
 			       lapb->dev, frame->pf);
 #endif
 			if (lapb->mode & LAPB_EXTENDED) {
 #if LAPB_DEBUG > 1
+				LAPB_DEBUG_DYN_CHK(lapb, 1)
 				printk(KERN_DEBUG "lapb: (%p) S3 TX
DM(%d)\n",
 				       lapb->dev, frame->pf);
 #endif
@@ -350,6 +507,7 @@
 						  LAPB_RESPONSE);
 			} else {
 #if LAPB_DEBUG > 1
+				LAPB_DEBUG_DYN_CHK(lapb, 1)
 				printk(KERN_DEBUG "lapb: (%p) S3 TX
UA(%d)\n",
 				       lapb->dev, frame->pf);
 #endif
@@ -359,6 +517,8 @@
 				lapb_stop_t2timer(lapb);
 				lapb->condition = 0x00;
 				lapb->n2count   = 0;
+				lapb->q921_flags &=
+					~LAPB_Q921_FLG_TIMER_RECOVERY;
 				lapb->vs        = 0;
 				lapb->vr        = 0;
 				lapb->va        = 0;
@@ -368,11 +528,13 @@
 
 		case LAPB_SABME:
 #if LAPB_DEBUG > 1
+			LAPB_DEBUG_DYN_CHK(lapb, 1)
 			printk(KERN_DEBUG "lapb: (%p) S3 RX SABME(%d)\n",
 			       lapb->dev, frame->pf);
 #endif
 			if (lapb->mode & LAPB_EXTENDED) {
 #if LAPB_DEBUG > 1
+				LAPB_DEBUG_DYN_CHK(lapb, 1)
 				printk(KERN_DEBUG "lapb: (%p) S3 TX
UA(%d)\n",
 				       lapb->dev, frame->pf);
 #endif
@@ -382,12 +544,23 @@
 				lapb_stop_t2timer(lapb);
 				lapb->condition = 0x00;
 				lapb->n2count   = 0;
+				lapb->q921_flags &=
+					~LAPB_Q921_FLG_TIMER_RECOVERY;
+				if (lapb->mode & LAPB_Q921) {
+					if (lapb->vs != lapb->va) {
+						lapb_clear_queues(lapb);
+						lapb_connect_confirmation
+							(lapb, LAPB_OK);
+					}
+				}
 				lapb->vs        = 0;
 				lapb->vr        = 0;
 				lapb->va        = 0;
+				lapb_start_t203(lapb);
 				lapb_requeue_frames(lapb);
 			} else {
 #if LAPB_DEBUG > 1
+				LAPB_DEBUG_DYN_CHK(lapb, 1)
 				printk(KERN_DEBUG "lapb: (%p) S3 TX
DM(%d)\n",
 				       lapb->dev, frame->pf);
 #endif
@@ -398,10 +571,17 @@
 
 		case LAPB_DISC:
 #if LAPB_DEBUG > 1
+			LAPB_DEBUG_DYN_CHK(lapb, 1)
 			printk(KERN_DEBUG "lapb: (%p) S3 RX DISC(%d)\n",
 			       lapb->dev, frame->pf);
 #endif
+#if LAPB_DEBUG > 1
+			LAPB_DEBUG_DYN_CHK(lapb, 1)
+		 	printk(KERN_DEBUG "lapb: (%p) S3 TX UA(%d)\n",
+			       lapb->dev, frame->pf);
+#endif
 #if LAPB_DEBUG > 0
+			LAPB_DEBUG_DYN_CHK(lapb, 0)
 			printk(KERN_DEBUG "lapb: (%p) S3 -> S0\n",
 			       lapb->dev);
 #endif
@@ -411,15 +591,36 @@
 			lapb_start_t1timer(lapb);
 			lapb_stop_t2timer(lapb);
 			lapb->state = LAPB_STATE_0;
+			lapb->q921_flags &= ~LAPB_Q921_FLG_TIMER_RECOVERY;
 			lapb_disconnect_indication(lapb, LAPB_OK);
 			break;
 
+		case LAPB_UA:
+			if (lapb->mode & LAPB_Q921) {
+#if LAPB_DEBUG > 1
+				LAPB_DEBUG_DYN_CHK(lapb, 1)
+				printk(KERN_DEBUG "lapb: (%p) S3 RX
UA(%d)\n",
+				       lapb->dev, frame->pf);
+#endif
+			}
+			break;
+
 		case LAPB_DM:
 #if LAPB_DEBUG > 1
+			LAPB_DEBUG_DYN_CHK(lapb, 1)
 			printk(KERN_DEBUG "lapb: (%p) S3 RX DM(%d)\n",
 			       lapb->dev, frame->pf);
 #endif
+			if (lapb->mode & LAPB_Q921) {
+				if (!frame->pf ||
+				    lapb->q921_flags &
+				    LAPB_Q921_FLG_TIMER_RECOVERY) {
+					lapb_reestablish(lapb);
+				}
+			break;
+			}
 #if LAPB_DEBUG > 0
+			LAPB_DEBUG_DYN_CHK(lapb, 0)
 			printk(KERN_DEBUG "lapb: (%p) S3 -> S0\n",
 			       lapb->dev);
 #endif
@@ -432,54 +633,105 @@
 
 		case LAPB_RNR:
 #if LAPB_DEBUG > 1
+			LAPB_DEBUG_DYN_CHK(lapb, 1)
 			printk(KERN_DEBUG "lapb: (%p) S3 RX RNR(%d) R%d\n",
 			       lapb->dev, frame->pf, frame->nr);
 #endif
 			lapb->condition |= LAPB_PEER_RX_BUSY_CONDITION;
 			lapb_check_need_response(lapb, frame->cr, frame->pf);
 			if (lapb_validate_nr(lapb, frame->nr)) {
-				lapb_check_iframes_acked(lapb, frame->nr);
+				if (!(lapb->q921_flags &
+				      LAPB_Q921_FLG_TIMER_RECOVERY)) {
+					if (!lapb->mode & LAPB_Q921) {
+						lapb_check_iframes_acked
+							(lapb, frame->nr);
+					} else {
+						lapb_frames_acked(lapb,
+								  frame->nr);
+						lapb_stop_t2timer(lapb);
+						lapb_start_t1timer(lapb);
+					}
+				} else {
+					lapb_frames_acked(lapb, frame->nr);
+					if (frame->cr == LAPB_RESPONSE &&
+					    frame->pf) {
+						lapb_start_t1timer(lapb);
+						lapb->n2count = 0;
+						lapb->q921_flags &=
+
~LAPB_Q921_FLG_TIMER_RECOVERY;
+						lapb_requeue_frames(lapb);
+					}
+				}
 			} else {
-				lapb->frmr_data = *frame;
-				lapb->frmr_type = LAPB_FRMR_Z;
-				lapb_transmit_frmr(lapb);
+				if (lapb->mode & LAPB_Q921) {
+					lapb_reestablish(lapb);
+				} else {
+					lapb->frmr_data = *frame;
+					lapb->frmr_type = LAPB_FRMR_Z;
+					lapb_transmit_frmr(lapb);
 #if LAPB_DEBUG > 0
-				printk(KERN_DEBUG "lapb: (%p) S3 -> S4\n",
-				       lapb->dev);
+					LAPB_DEBUG_DYN_CHK(lapb, 0)
+					printk(KERN_DEBUG
+					       "lapb: (%p) S3 -> S4\n",
+					       lapb->dev);
 #endif
-				lapb_start_t1timer(lapb);
-				lapb_stop_t2timer(lapb);
-				lapb->state   = LAPB_STATE_4;
-				lapb->n2count = 0;
+					lapb_start_t1timer(lapb);
+					lapb_stop_t2timer(lapb);
+					lapb->state = LAPB_STATE_4;
+					lapb->n2count = 0;
+					lapb->q921_flags &=
+					    ~LAPB_Q921_FLG_TIMER_RECOVERY;
+				}
 			}
 			break;
 
 		case LAPB_RR:
 #if LAPB_DEBUG > 1
+			LAPB_DEBUG_DYN_CHK(lapb, 1)
 			printk(KERN_DEBUG "lapb: (%p) S3 RX RR(%d) R%d\n",
 			       lapb->dev, frame->pf, frame->nr);
 #endif
 			lapb->condition &= ~LAPB_PEER_RX_BUSY_CONDITION;
 			lapb_check_need_response(lapb, frame->cr, frame->pf);
 			if (lapb_validate_nr(lapb, frame->nr)) {
-				lapb_check_iframes_acked(lapb, frame->nr);
+				if (!(lapb->q921_flags &
+				      LAPB_Q921_FLG_TIMER_RECOVERY)) {
+					lapb_check_iframes_acked(lapb,
+								 frame->nr);
+				} else {
+					lapb_frames_acked(lapb, frame->nr);
+					if (frame->cr == LAPB_RESPONSE &&
+					    frame->pf) {
+
lapb_initialize_retransmission
+							(lapb);
+					}
+				}
 			} else {
-				lapb->frmr_data = *frame;
-				lapb->frmr_type = LAPB_FRMR_Z;
-				lapb_transmit_frmr(lapb);
+				if (lapb->mode & LAPB_Q921) {
+					lapb_reestablish(lapb);
+				} else {
+					lapb->frmr_data = *frame;
+					lapb->frmr_type = LAPB_FRMR_Z;
+					lapb_transmit_frmr(lapb);
 #if LAPB_DEBUG > 0
-				printk(KERN_DEBUG "lapb: (%p) S3 -> S4\n",
-				       lapb->dev);
+					LAPB_DEBUG_DYN_CHK(lapb, 0)
+					printk(KERN_DEBUG
+					       "lapb: (%p) S3 -> S4\n",
+					       lapb->dev);
 #endif
-				lapb_start_t1timer(lapb);
-				lapb_stop_t2timer(lapb);
-				lapb->state   = LAPB_STATE_4;
-				lapb->n2count = 0;
+					lapb_start_t1timer(lapb);
+					lapb_stop_t2timer(lapb);
+					lapb->state = LAPB_STATE_4;
+					lapb->n2count = 0;
+					lapb->q921_flags &=
+					    ~LAPB_Q921_FLG_TIMER_RECOVERY;
+				}
 			}
 			break;
 
 		case LAPB_REJ:
 #if LAPB_DEBUG > 1
+			LAPB_DEBUG_DYN_CHK(lapb, 1)
 			printk(KERN_DEBUG "lapb: (%p) S3 RX REJ(%d) R%d\n",
 			       lapb->dev, frame->pf, frame->nr);
 #endif
@@ -487,47 +739,78 @@
 			lapb_check_need_response(lapb, frame->cr, frame->pf);
 			if (lapb_validate_nr(lapb, frame->nr)) {
 				lapb_frames_acked(lapb, frame->nr);
-				lapb_stop_t1timer(lapb);
-				lapb->n2count = 0;
-				lapb_requeue_frames(lapb);
+				if (!(lapb->q921_flags &
+				      LAPB_Q921_FLG_TIMER_RECOVERY)) {
+					lapb_initialize_retransmission(lapb);
+				} else {
+					if (frame->cr == LAPB_RESPONSE &&
+					    frame->pf) {
+
lapb_initialize_retransmission
+							(lapb);
+					}
+				}
 			} else {
-				lapb->frmr_data = *frame;
-				lapb->frmr_type = LAPB_FRMR_Z;
-				lapb_transmit_frmr(lapb);
+				if (lapb->mode & LAPB_Q921) {
+					lapb_reestablish(lapb);
+				} else {
+					lapb->frmr_data = *frame;
+					lapb->frmr_type = LAPB_FRMR_Z;
+					lapb_transmit_frmr(lapb);
 #if LAPB_DEBUG > 0
-				printk(KERN_DEBUG "lapb: (%p) S3 -> S4\n",
-				       lapb->dev);
+					LAPB_DEBUG_DYN_CHK(lapb, 0)
+					printk(KERN_DEBUG
+					       "lapb: (%p) S3 -> S4\n",
+					       lapb->dev);
 #endif
-				lapb_start_t1timer(lapb);
-				lapb_stop_t2timer(lapb);
-				lapb->state   = LAPB_STATE_4;
-				lapb->n2count = 0;
+					lapb_start_t1timer(lapb);
+					lapb_stop_t2timer(lapb);
+					lapb->state = LAPB_STATE_4;
+					lapb->n2count = 0;
+					lapb->q921_flags &=
+					    ~LAPB_Q921_FLG_TIMER_RECOVERY;
+				}
 			}
 			break;
 
 		case LAPB_I:
 #if LAPB_DEBUG > 1
+			LAPB_DEBUG_DYN_CHK(lapb, 1)
 			printk(KERN_DEBUG "lapb: (%p) S3 RX I(%d) S%d R%d\n",
 			       lapb->dev, frame->pf, frame->ns, frame->nr);
 #endif
 			if (!lapb_validate_nr(lapb, frame->nr)) {
-				lapb->frmr_data = *frame;
-				lapb->frmr_type = LAPB_FRMR_Z;
-				lapb_transmit_frmr(lapb);
+				if (lapb->mode & LAPB_Q921) {
+					lapb_reestablish(lapb);
+					checknr = 0;
+				} else {
+					lapb->frmr_data = *frame;
+					lapb->frmr_type = LAPB_FRMR_Z;
+					lapb_transmit_frmr(lapb);
 #if LAPB_DEBUG > 0
-				printk(KERN_DEBUG "lapb: (%p) S3 -> S4\n",
-				       lapb->dev);
+					LAPB_DEBUG_DYN_CHK(lapb, 0)
+					printk(KERN_DEBUG
+					       "lapb: (%p) S3 -> S4\n",
+					       lapb->dev);
 #endif
-				lapb_start_t1timer(lapb);
-				lapb_stop_t2timer(lapb);
-				lapb->state   = LAPB_STATE_4;
-				lapb->n2count = 0;
-				break;
+					lapb_start_t1timer(lapb);
+					lapb_stop_t2timer(lapb);
+					lapb->state = LAPB_STATE_4;
+					lapb->n2count = 0;
+					lapb->q921_flags &=
+					    ~LAPB_Q921_FLG_TIMER_RECOVERY;
+					break;
+				}
 			}
-			if (lapb->condition & LAPB_PEER_RX_BUSY_CONDITION)
-				lapb_frames_acked(lapb, frame->nr);
-			else
-				lapb_check_iframes_acked(lapb, frame->nr);
+			if (checknr) {
+				if ((lapb->condition &
+				     LAPB_PEER_RX_BUSY_CONDITION) ||
+				    (lapb->q921_flags &
+				     LAPB_Q921_FLG_TIMER_RECOVERY))
+					lapb_frames_acked(lapb, frame->nr);
+				else
+					lapb_check_iframes_acked(lapb,
+								 frame->nr);
+			}
 
 			if (frame->ns == lapb->vr) {
 				int cn;
@@ -548,20 +831,25 @@
 				lapb->vr = (lapb->vr + 1) % modulus;
 				lapb->condition &= ~LAPB_REJECT_CONDITION;
 				if (frame->pf)
-					lapb_enquiry_response(lapb);
+					lapb_enquiry_response(lapb,
+							      LAPB_RESPONSE);
 				else {
 					if (!(lapb->condition &
 					      LAPB_ACK_PENDING_CONDITION)) {
 						lapb->condition |=
LAPB_ACK_PENDING_CONDITION;
-						lapb_start_t2timer(lapb);
+						if (!lapb->mode & LAPB_Q921)
{
+
lapb_start_t2timer(lapb);
+						}
 					}
 				}
 			} else {
 				if (lapb->condition & LAPB_REJECT_CONDITION)
{
 					if (frame->pf)
-						lapb_enquiry_response(lapb);
+						lapb_enquiry_response
+							(lapb,
LAPB_RESPONSE);
 				} else {
 #if LAPB_DEBUG > 1
+					LAPB_DEBUG_DYN_CHK(lapb, 1)
 					printk(KERN_DEBUG
 					       "lapb: (%p) S3 TX REJ(%d)
R%d\n",
 					       lapb->dev, frame->pf,
lapb->vr);
@@ -577,6 +865,7 @@
 
 		case LAPB_FRMR:
 #if LAPB_DEBUG > 1
+			LAPB_DEBUG_DYN_CHK(lapb, 1)
 			printk(KERN_DEBUG "lapb: (%p) S3 RX FRMR(%d) %02X "
 			       "%02X %02X %02X %02X\n", lapb->dev, frame->pf,
 			       skb->data[0], skb->data[1], skb->data[2],
@@ -584,28 +873,41 @@
 #endif
 			lapb_establish_data_link(lapb);
 #if LAPB_DEBUG > 0
+			LAPB_DEBUG_DYN_CHK(lapb, 0)
 			printk(KERN_DEBUG "lapb: (%p) S3 -> S1\n",
 			       lapb->dev);
 #endif
-			lapb_requeue_frames(lapb);
+			if (lapb->mode & LAPB_Q921) {
+				lapb->q921_flags &=
~LAPB_Q921_FLG_L3_INITIATED;
+			} else {
+				lapb_requeue_frames(lapb);
+			}
 			lapb->state = LAPB_STATE_1;
 			break;
 
 		case LAPB_ILLEGAL:
+			if (lapb->mode & LAPB_Q921) {
+				lapb_reestablish(lapb);
+			} else {
 #if LAPB_DEBUG > 1
-			printk(KERN_DEBUG "lapb: (%p) S3 RX ILLEGAL(%d)\n",
-			       lapb->dev, frame->pf);
+				LAPB_DEBUG_DYN_CHK(lapb, 1)
+				printk(KERN_DEBUG "lapb: (%p) S3 RX
ILLEGAL(%d)\n",
+				       lapb->dev, frame->pf);
 #endif
-			lapb->frmr_data = *frame;
-			lapb->frmr_type = LAPB_FRMR_W;
-			lapb_transmit_frmr(lapb);
+				lapb->frmr_data = *frame;
+				lapb->frmr_type = LAPB_FRMR_W;
+				lapb_transmit_frmr(lapb);
 #if LAPB_DEBUG > 0
-			printk(KERN_DEBUG "lapb: (%p) S3 -> S4\n",
lapb->dev);
+				LAPB_DEBUG_DYN_CHK(lapb, 0)
+				printk(KERN_DEBUG "lapb: (%p) S3 -> S4\n",
+				       lapb->dev);
 #endif
-			lapb_start_t1timer(lapb);
-			lapb_stop_t2timer(lapb);
-			lapb->state   = LAPB_STATE_4;
-			lapb->n2count = 0;
+				lapb_start_t1timer(lapb);
+				lapb_stop_t2timer(lapb);
+				lapb->state = LAPB_STATE_4;
+				lapb->n2count = 0;
+				lapb->q921_flags &=
~LAPB_Q921_FLG_TIMER_RECOVERY;
+			}
 			break;
 	}
 
@@ -623,11 +925,13 @@
 	switch (frame->type) {
 		case LAPB_SABM:
 #if LAPB_DEBUG > 1
+			LAPB_DEBUG_DYN_CHK(lapb, 1)
 			printk(KERN_DEBUG "lapb: (%p) S4 RX SABM(%d)\n",
 			       lapb->dev, frame->pf);
 #endif
 			if (lapb->mode & LAPB_EXTENDED) {
 #if LAPB_DEBUG > 1
+				LAPB_DEBUG_DYN_CHK(lapb, 1)
 				printk(KERN_DEBUG "lapb: (%p) S4 TX
DM(%d)\n",
 				       lapb->dev, frame->pf);
 #endif
@@ -635,10 +939,12 @@
 						  LAPB_RESPONSE);
 			} else {
 #if LAPB_DEBUG > 1
+				LAPB_DEBUG_DYN_CHK(lapb, 1)
 				printk(KERN_DEBUG "lapb: (%p) S4 TX
UA(%d)\n",
 				       lapb->dev, frame->pf);
 #endif
 #if LAPB_DEBUG > 0
+				LAPB_DEBUG_DYN_CHK(lapb, 0)
 				printk(KERN_DEBUG "lapb: (%p) S4 -> S3\n",
 				       lapb->dev);
 #endif
@@ -658,15 +964,18 @@
 
 		case LAPB_SABME:
 #if LAPB_DEBUG > 1
+			LAPB_DEBUG_DYN_CHK(lapb, 1)
 			printk(KERN_DEBUG "lapb: (%p) S4 RX SABME(%d)\n",
 			       lapb->dev, frame->pf);
 #endif
 			if (lapb->mode & LAPB_EXTENDED) {
 #if LAPB_DEBUG > 1
+				LAPB_DEBUG_DYN_CHK(lapb, 1)
 				printk(KERN_DEBUG "lapb: (%p) S4 TX
UA(%d)\n",
 				       lapb->dev, frame->pf);
 #endif
 #if LAPB_DEBUG > 0
+				LAPB_DEBUG_DYN_CHK(lapb, 0)
 				printk(KERN_DEBUG "lapb: (%p) S4 -> S3\n",
 				       lapb->dev);
 #endif
@@ -677,12 +986,15 @@
 				lapb->state     = LAPB_STATE_3;
 				lapb->condition = 0x00;
 				lapb->n2count   = 0;
+				lapb->q921_flags &=
+					~LAPB_Q921_FLG_TIMER_RECOVERY;
 				lapb->vs        = 0;
 				lapb->vr        = 0;
 				lapb->va        = 0;
 				lapb_connect_indication(lapb, LAPB_OK);
 			} else {
 #if LAPB_DEBUG > 1
+				LAPB_DEBUG_DYN_CHK(lapb, 1)
 				printk(KERN_DEBUG "lapb: (%p) S4 TX
DM(%d)\n",
 				       lapb->dev, frame->pf);
 #endif
Index: net/lapb/lapb_iface.c
===================================================================
--- net/lapb/lapb_iface.c	(revision 3155)
+++ net/lapb/lapb_iface.c	(working copy)
@@ -132,7 +132,14 @@
 	lapb->n2      = LAPB_DEFAULT_N2;
 	lapb->mode    = LAPB_DEFAULT_MODE;
 	lapb->window  = LAPB_DEFAULT_WINDOW;
+	lapb->sapi    = LAPB_DEFAULT_SAPI;
+	lapb->tei     = LAPB_DEFAULT_TEI;
 	lapb->state   = LAPB_STATE_0;
+	lapb->t203    = LAPB_DEFAULT_T203;
+	lapb->q921_flags = 0x00;
+#if LAPB_DEBUG_DYN == 1
+	lapb->dbg_level = LAPB_DEBUG_DYN_LEVEL_DEFAULT;
+#endif
 	atomic_set(&lapb->refcnt, 1);
 out:
 	return lapb;
@@ -208,16 +215,28 @@
 	parms->state   = lapb->state;
 	parms->window  = lapb->window;
 	parms->mode    = lapb->mode;
+	parms->sapi    = lapb->sapi;
+	parms->tei     = lapb->tei;
+	parms->t203    = lapb->t203 / HZ;
+#if LAPB_DEBUG_DYN == 1
+	parms->dbg_level = lapb->dbg_level;
+#endif
 
 	if (!timer_pending(&lapb->t1timer))
 		parms->t1timer = 0;
 	else
 		parms->t1timer = (lapb->t1timer.expires - jiffies) / HZ;
 
-	if (!timer_pending(&lapb->t2timer))
+	if (!timer_pending(&lapb->t2timer)) {
 		parms->t2timer = 0;
-	else
+		parms->t203timer = 0;
+	} else {
 		parms->t2timer = (lapb->t2timer.expires - jiffies) / HZ;
+		if (lapb->q921_flags & LAPB_Q921_FLG_T203) {
+			parms->t203timer = parms->t2timer;
+			parms->t2timer = 0;
+		}
+	}
 
 	lapb_put(lapb);
 	rc = LAPB_OK;
@@ -233,8 +252,16 @@
 	if (!lapb)
 		goto out;
 
+#if LAPB_DEBUG_DYN == 1
+	if (lapb->dbg_level != parms->dbg_level) {
+		lapb->dbg_level = parms->dbg_level;
+		rc = LAPB_OK;
+		goto out_put;
+	}
+#endif
+
 	rc = LAPB_INVALUE;
-	if (parms->t1 < 1 || parms->t2 < 1 || parms->n2 < 1)
+	if (parms->t1 < 1 || parms->t2 < 1 || parms->n2 < 1 || parms->t203 <
1)
 		goto out_put;
 
 	if (lapb->state == LAPB_STATE_0) {
@@ -247,10 +274,18 @@
 		}
 		lapb->mode    = parms->mode;
 		lapb->window  = parms->window;
+		lapb->sapi    = parms->sapi;
+		lapb->tei     = parms->tei;
+		if (lapb->mode & LAPB_Q921) {
+			lapb->mode |= LAPB_EXTENDED;
+		} else if (!lapb_t1timer_running(lapb)) {
+			lapb_start_t1timer(lapb);
+		}
 	}
 
 	lapb->t1    = parms->t1 * HZ;
 	lapb->t2    = parms->t2 * HZ;
+	lapb->t203  = parms->t203 * HZ;
 	lapb->n2    = parms->n2;
 
 	rc = LAPB_OK;
@@ -268,17 +303,31 @@
 	if (!lapb)
 		goto out;
 
+	lapb->q921_flags |= LAPB_Q921_FLG_ESTABLISH_ALLOWED |
+			    LAPB_Q921_FLG_L3_INITIATED;
+	lapb->q921_flags &= ~LAPB_Q921_FLG_DO_DISCONNECT;
+
 	rc = LAPB_OK;
-	if (lapb->state == LAPB_STATE_1)
+	if (lapb->state == LAPB_STATE_1) {
+		if (lapb->mode & LAPB_Q921) {
+			lapb_clear_queues(lapb);
+		}
 		goto out_put;
+	}
 
 	rc = LAPB_CONNECTED;
 	if (lapb->state == LAPB_STATE_3 || lapb->state == LAPB_STATE_4)
 		goto out_put;
 
+	if (lapb->mode & LAPB_Q921 &&
+	    lapb->q921_flags & LAPB_Q921_FLG_TIMER_RECOVERY) {
+		lapb_clear_queues(lapb);
+	}
+
 	lapb_establish_data_link(lapb);
 
 #if LAPB_DEBUG > 0
+	LAPB_DEBUG_DYN_CHK(lapb, 0)
 	printk(KERN_DEBUG "lapb: (%p) S0 -> S1\n", lapb->dev);
 #endif
 	lapb->state = LAPB_STATE_1;
@@ -298,16 +347,25 @@
 	if (!lapb)
 		goto out;
 
+	lapb->q921_flags &= ~LAPB_Q921_FLG_ESTABLISH_ALLOWED;
+
 	switch (lapb->state) {
 		case LAPB_STATE_0:
 			rc = LAPB_NOTCONNECTED;
 			goto out_put;
 
 		case LAPB_STATE_1:
+			if (lapb->mode & LAPB_Q921) {
+				lapb->q921_flags |=
LAPB_Q921_FLG_DO_DISCONNECT;
+				rc = LAPB_NOTCONNECTED;
+				goto out_put;
+			}
 #if LAPB_DEBUG > 1
+			LAPB_DEBUG_DYN_CHK(lapb, 1)
 			printk(KERN_DEBUG "lapb: (%p) S1 TX DISC(1)\n",
lapb->dev);
 #endif
 #if LAPB_DEBUG > 0
+			LAPB_DEBUG_DYN_CHK(lapb, 0)
 			printk(KERN_DEBUG "lapb: (%p) S1 -> S0\n",
lapb->dev);
 #endif
 			lapb_send_control(lapb, LAPB_DISC, LAPB_POLLON,
LAPB_COMMAND);
@@ -323,15 +381,18 @@
 
 	lapb_clear_queues(lapb);
 	lapb->n2count = 0;
+	lapb->q921_flags &= ~LAPB_Q921_FLG_TIMER_RECOVERY;
 	lapb_send_control(lapb, LAPB_DISC, LAPB_POLLON, LAPB_COMMAND);
 	lapb_start_t1timer(lapb);
 	lapb_stop_t2timer(lapb);
 	lapb->state = LAPB_STATE_2;
 
 #if LAPB_DEBUG > 1
-	printk(KERN_DEBUG "lapb: (%p) S3 DISC(1)\n", lapb->dev);
+	LAPB_DEBUG_DYN_CHK(lapb, 1)
+	printk(KERN_DEBUG "lapb: (%p) S3 TX DISC(1)\n", lapb->dev);
 #endif
 #if LAPB_DEBUG > 0
+	LAPB_DEBUG_DYN_CHK(lapb, 0)
 	printk(KERN_DEBUG "lapb: (%p) S3 -> S2\n", lapb->dev);
 #endif
 
@@ -351,8 +412,16 @@
 		goto out;
 
 	rc = LAPB_NOTCONNECTED;
-	if (lapb->state != LAPB_STATE_3 && lapb->state != LAPB_STATE_4)
+	if (lapb->mode & LAPB_Q921 && lapb->state == LAPB_STATE_1) {
+		if (!(lapb->q921_flags & LAPB_Q921_FLG_L3_INITIATED)) {
+			skb_queue_tail(&lapb->write_queue, skb);
+			rc = LAPB_OK;
+		}
 		goto out_put;
+	} else {
+		if (lapb->state != LAPB_STATE_3 && lapb->state !=
LAPB_STATE_4)
+			goto out_put;
+	}
 
 	skb_queue_tail(&lapb->write_queue, skb);
 	lapb_kick(lapb);
Index: net/lapb/lapb_out.c
===================================================================
--- net/lapb/lapb_out.c	(revision 3155)
+++ net/lapb/lapb_out.c	(working copy)
@@ -62,6 +62,7 @@
 	}
 
 #if LAPB_DEBUG > 1
+	LAPB_DEBUG_DYN_CHK(lapb, 1)
 	printk(KERN_DEBUG "lapb: (%p) S%d TX I(%d) S%d R%d\n",
 	       lapb->dev, lapb->state, poll_bit, lapb->vs, lapb->vr);
 #endif
@@ -79,6 +80,7 @@
 	end   = (lapb->va + lapb->window) % modulus;
 
 	if (!(lapb->condition & LAPB_PEER_RX_BUSY_CONDITION) &&
+	    !(lapb->q921_flags & LAPB_Q921_FLG_TIMER_RECOVERY) &&
 	    start != end && skb_peek(&lapb->write_queue)) {
 		lapb->vs = start;
 
@@ -112,8 +114,15 @@
 
 		lapb->condition &= ~LAPB_ACK_PENDING_CONDITION;
 
-		if (!lapb_t1timer_running(lapb))
+		if (!lapb_t1timer_running(lapb)) {
 			lapb_start_t1timer(lapb);
+			if (lapb->mode & LAPB_Q921) {
+				lapb_stop_t2timer(lapb);
+			}
+		}
+	} else if (lapb->mode & LAPB_Q921 &&
+		   lapb->condition & LAPB_ACK_PENDING_CONDITION) {
+		lapb_timeout_response(lapb);
 	}
 }
 
@@ -121,38 +130,67 @@
 {
 	unsigned char *ptr;
 
-	ptr = skb_push(skb, 1);
+	if (lapb->mode & LAPB_Q921) {
+		ptr = skb_push(skb, 2);
 
-	if (lapb->mode & LAPB_MLP) {
-		if (lapb->mode & LAPB_DCE) {
+		ptr[0] = lapb->sapi << 2;
+		ptr[1] = lapb->tei << 1 | 0x01;
+
+		if (lapb->mode & LAPB_MLP) {
 			if (type == LAPB_COMMAND)
-				*ptr = LAPB_ADDR_C;
-			if (type == LAPB_RESPONSE)
-				*ptr = LAPB_ADDR_D;
+				ptr[0] |= LAPB_CMD_RESP;
 		} else {
-			if (type == LAPB_COMMAND)
-				*ptr = LAPB_ADDR_D;
 			if (type == LAPB_RESPONSE)
-				*ptr = LAPB_ADDR_C;
+				ptr[0] |= LAPB_CMD_RESP;
 		}
 	} else {
-		if (lapb->mode & LAPB_DCE) {
-			if (type == LAPB_COMMAND)
-				*ptr = LAPB_ADDR_A;
-			if (type == LAPB_RESPONSE)
-				*ptr = LAPB_ADDR_B;
+		ptr = skb_push(skb, 1);
+
+		if (lapb->mode & LAPB_MLP) {
+			if (lapb->mode & LAPB_DCE) {
+				if (type == LAPB_COMMAND)
+					*ptr = LAPB_ADDR_C;
+				if (type == LAPB_RESPONSE)
+					*ptr = LAPB_ADDR_D;
+			} else {
+				if (type == LAPB_COMMAND)
+					*ptr = LAPB_ADDR_D;
+				if (type == LAPB_RESPONSE)
+					*ptr = LAPB_ADDR_C;
+			}
 		} else {
-			if (type == LAPB_COMMAND)
-				*ptr = LAPB_ADDR_B;
-			if (type == LAPB_RESPONSE)
-				*ptr = LAPB_ADDR_A;
+			if (lapb->mode & LAPB_DCE) {
+				if (type == LAPB_COMMAND)
+					*ptr = LAPB_ADDR_A;
+				if (type == LAPB_RESPONSE)
+					*ptr = LAPB_ADDR_B;
+			} else {
+				if (type == LAPB_COMMAND)
+					*ptr = LAPB_ADDR_B;
+				if (type == LAPB_RESPONSE)
+					*ptr = LAPB_ADDR_A;
+			}
 		}
 	}
 
 #if LAPB_DEBUG > 2
-	printk(KERN_DEBUG "lapb: (%p) S%d TX %02X %02X %02X\n",
-	       lapb->dev, lapb->state,
-	       skb->data[0], skb->data[1], skb->data[2]);
+	if (lapb->mode & LAPB_Q921) {
+		/* struct timeval tim;
+		 * jiffies_to_timeval(jiffies, &tim);
+		 */
+		LAPB_DEBUG_DYN_CHK(lapb, 2)
+		printk(KERN_DEBUG
+		       /* "lapb: (%p) S%d Tim:%lu.%3.3lu TX %02X %02X %02X
%02X\n", */
+		       "lapb: (%p) S%d TX %02X %02X %02X %02X\n",
+		       lapb->dev, lapb->state, /* tim.tv_sec, tim.tv_usec /
1000, */
+		       skb->data[0], skb->data[1],
+		       skb->data[2], skb->data[3]);
+	} else {
+		LAPB_DEBUG_DYN_CHK(lapb, 2)
+		printk(KERN_DEBUG "lapb: (%p) S%d TX %02X %02X %02X\n",
+		       lapb->dev, lapb->state,
+		       skb->data[0], skb->data[1], skb->data[2]);
+	}
 #endif
 
 	if (!lapb_data_transmit(lapb, skb))
@@ -163,15 +201,18 @@
 {
 	lapb->condition = 0x00;
 	lapb->n2count   = 0;
+	lapb->q921_flags &= ~LAPB_Q921_FLG_TIMER_RECOVERY;
 
 	if (lapb->mode & LAPB_EXTENDED) {
 #if LAPB_DEBUG > 1
+		LAPB_DEBUG_DYN_CHK(lapb, 1)
 		printk(KERN_DEBUG "lapb: (%p) S%d TX SABME(1)\n",
 		       lapb->dev, lapb->state);
 #endif
 		lapb_send_control(lapb, LAPB_SABME, LAPB_POLLON,
LAPB_COMMAND);
 	} else {
 #if LAPB_DEBUG > 1
+		LAPB_DEBUG_DYN_CHK(lapb, 1)
 		printk(KERN_DEBUG "lapb: (%p) S%d TX SABM(1)\n",
 		       lapb->dev, lapb->state);
 #endif
@@ -182,14 +223,35 @@
 	lapb_stop_t2timer(lapb);
 }
 
-void lapb_enquiry_response(struct lapb_cb *lapb)
+void lapb_reestablish(struct lapb_cb *lapb)
 {
+	lapb_establish_data_link(lapb);
+
+	lapb->q921_flags &= ~LAPB_Q921_FLG_L3_INITIATED;
+
+#if LAPB_DEBUG > 0
+	{
+		static const char *txtState[] =
+			{ "S0", "S1", "S2", "S3", "S4" };
+		LAPB_DEBUG_DYN_CHK(lapb, 0)
+		printk(KERN_DEBUG "lapb: (%p) %s -> S1\n", lapb->dev,
+		       txtState[lapb->state] );
+	}
+#endif
+
+	lapb->q921_flags &= ~LAPB_Q921_FLG_TIMER_RECOVERY;
+	lapb->state = LAPB_STATE_1;
+}
+
+void lapb_enquiry_response(struct lapb_cb *lapb, int type)
+{
 #if LAPB_DEBUG > 1
+	LAPB_DEBUG_DYN_CHK(lapb, 1)
 	printk(KERN_DEBUG "lapb: (%p) S%d TX RR(1) R%d\n",
 	       lapb->dev, lapb->state, lapb->vr);
 #endif
 
-	lapb_send_control(lapb, LAPB_RR, LAPB_POLLON, LAPB_RESPONSE);
+	lapb_send_control(lapb, LAPB_RR, LAPB_POLLON, type);
 
 	lapb->condition &= ~LAPB_ACK_PENDING_CONDITION;
 }
@@ -197,6 +259,7 @@
 void lapb_timeout_response(struct lapb_cb *lapb)
 {
 #if LAPB_DEBUG > 1
+	LAPB_DEBUG_DYN_CHK(lapb, 1)
 	printk(KERN_DEBUG "lapb: (%p) S%d TX RR(0) R%d\n",
 	       lapb->dev, lapb->state, lapb->vr);
 #endif
@@ -211,6 +274,8 @@
 		lapb_frames_acked(lapb, nr);
 		lapb_stop_t1timer(lapb);
 		lapb->n2count = 0;
+		lapb->q921_flags &= ~LAPB_Q921_FLG_TIMER_RECOVERY;
+		lapb_start_t203(lapb);
 	} else if (lapb->va != nr) {
 		lapb_frames_acked(lapb, nr);
 		lapb_start_t1timer(lapb);
@@ -220,5 +285,14 @@
 void lapb_check_need_response(struct lapb_cb *lapb, int type, int pf)
 {
 	if (type == LAPB_COMMAND && pf)
-		lapb_enquiry_response(lapb);
+		lapb_enquiry_response(lapb, LAPB_RESPONSE);
 }
+
+void lapb_initialize_retransmission(struct lapb_cb *lapb)
+{
+	lapb_stop_t1timer(lapb);
+	lapb->n2count = 0;
+	lapb->q921_flags &= ~LAPB_Q921_FLG_TIMER_RECOVERY;
+	lapb_requeue_frames(lapb);
+	lapb_start_t203(lapb);
+}
Index: net/lapb/lapb_subr.c
===================================================================
--- net/lapb/lapb_subr.c	(revision 3155)
+++ net/lapb/lapb_subr.c	(working copy)
@@ -89,6 +89,26 @@
  */
 int lapb_validate_nr(struct lapb_cb *lapb, unsigned short nr)
 {
+	/* use some if's istead of trying in a loop, to speed up the check
+	 */
+#if 1
+	/* nr must be in the valid range */
+	if (nr >=
+	    ((lapb->mode & LAPB_EXTENDED) ? LAPB_EMODULUS : LAPB_SMODULUS)) {
+		return 0;
+	}
+
+	if (lapb->vs >= lapb->va) {
+		/* the simple case, no wrap arround of vs */
+		return ((nr >= lapb->va) && (nr <= lapb->vs));
+	} else {
+		/* wrap arround of vs, so the valid range is va .. max and 0
.. vs
+		 * 0 needn't to be checked, because it's unsigned and the
upper limit
+		 * is checked before
+		 */
+		return ((nr >= lapb->va) || (nr <= lapb->vs));
+	}
+#else
 	unsigned short vc = lapb->va;
 	int modulus;
 	
@@ -101,6 +121,7 @@
 	}
 	
 	return nr == lapb->vs;
+#endif // if 0
 }
 
 /*
@@ -113,44 +134,82 @@
 	frame->type = LAPB_ILLEGAL;
 
 #if LAPB_DEBUG > 2
-	printk(KERN_DEBUG "lapb: (%p) S%d RX %02X %02X %02X\n",
-	       lapb->dev, lapb->state,
-	       skb->data[0], skb->data[1], skb->data[2]);
+	if (lapb->mode & LAPB_Q921) {
+		/* struct timeval tim;
+		 * jiffies_to_timeval(jiffies, &tim);
+		 */
+		LAPB_DEBUG_DYN_CHK(lapb, 2)
+		printk(KERN_DEBUG
+		       /* "lapb: (%p) S%d Tim:%lu.%3.3lu RX %02X %02X %02X
%02X\n", */
+		       "lapb: (%p) S%d RX %02X %02X %02X %02X\n",
+		       lapb->dev, lapb->state, /* tim.tv_sec, tim.tv_usec /
1000, */
+		       skb->data[0], skb->data[1],
+		       skb->data[2], skb->data[3]);
+	} else {
+		LAPB_DEBUG_DYN_CHK(lapb, 2)
+		    printk(KERN_DEBUG "lapb: (%p) S%d RX %02X %02X %02X\n",
+			   lapb->dev, lapb->state,
+			   skb->data[0], skb->data[1], skb->data[2]);
+	}
 #endif
 
-	/* We always need to look at 2 bytes, sometimes we need
-	 * to look at 3 and those cases are handled below.
-	 */
-	if (!pskb_may_pull(skb, 2))
-		return -1;
+	if (lapb->mode & LAPB_Q921) {
+		/* We always need to look at 3 bytes, sometimes we need
+		 * to look at 4 and those cases are handled below.
+		 */
+		if (!pskb_may_pull(skb, 3))
+			return -1;
 
-	if (lapb->mode & LAPB_MLP) {
-		if (lapb->mode & LAPB_DCE) {
-			if (skb->data[0] == LAPB_ADDR_D)
+		if ((skb->data[0] >> 2) != lapb->sapi)
+			return -1;
+		if ((skb->data[1] & 0x01) != 0x01)
+			return -1;
+		if ((skb->data[1] >> 1) != lapb->tei)
+			return -1;
+
+		frame->cr = LAPB_RESPONSE;
+		if (lapb->mode & LAPB_MLP) {
+			if ((skb->data[0] & LAPB_CMD_RESP) == 0)
 				frame->cr = LAPB_COMMAND;
-			if (skb->data[0] == LAPB_ADDR_C)
-				frame->cr = LAPB_RESPONSE;
 		} else {
-			if (skb->data[0] == LAPB_ADDR_C)
+			if ((skb->data[0] & LAPB_CMD_RESP) == LAPB_CMD_RESP)
 				frame->cr = LAPB_COMMAND;
-			if (skb->data[0] == LAPB_ADDR_D)
-				frame->cr = LAPB_RESPONSE;
 		}
+		skb_pull(skb, 2);
 	} else {
-		if (lapb->mode & LAPB_DCE) {
-			if (skb->data[0] == LAPB_ADDR_B)
-				frame->cr = LAPB_COMMAND;
-			if (skb->data[0] == LAPB_ADDR_A)
-				frame->cr = LAPB_RESPONSE;
+		/* We always need to look at 2 bytes, sometimes we need
+		 * to look at 3 and those cases are handled below.
+		 */
+		if (!pskb_may_pull(skb, 2))
+			return -1;
+
+		if (lapb->mode & LAPB_MLP) {
+			if (lapb->mode & LAPB_DCE) {
+				if (skb->data[0] == LAPB_ADDR_D)
+					frame->cr = LAPB_COMMAND;
+				if (skb->data[0] == LAPB_ADDR_C)
+					frame->cr = LAPB_RESPONSE;
+			} else {
+				if (skb->data[0] == LAPB_ADDR_C)
+					frame->cr = LAPB_COMMAND;
+				if (skb->data[0] == LAPB_ADDR_D)
+					frame->cr = LAPB_RESPONSE;
+			}
 		} else {
-			if (skb->data[0] == LAPB_ADDR_A)
-				frame->cr = LAPB_COMMAND;
-			if (skb->data[0] == LAPB_ADDR_B)
-				frame->cr = LAPB_RESPONSE;
+			if (lapb->mode & LAPB_DCE) {
+				if (skb->data[0] == LAPB_ADDR_B)
+					frame->cr = LAPB_COMMAND;
+				if (skb->data[0] == LAPB_ADDR_A)
+					frame->cr = LAPB_RESPONSE;
+			} else {
+				if (skb->data[0] == LAPB_ADDR_A)
+					frame->cr = LAPB_COMMAND;
+				if (skb->data[0] == LAPB_ADDR_B)
+					frame->cr = LAPB_RESPONSE;
+			}
 		}
+		skb_pull(skb, 1);
 	}
-		
-	skb_pull(skb, 1);
 
 	if (lapb->mode & LAPB_EXTENDED) {
 		if (!(skb->data[0] & LAPB_S)) {
@@ -232,7 +291,7 @@
 	struct sk_buff *skb;
 	unsigned char  *dptr;
 
-	if ((skb = alloc_skb(LAPB_HEADER_LEN + 3, GFP_ATOMIC)) == NULL)
+	if ((skb = alloc_skb(LAPB_HEADER_LEN + 4, GFP_ATOMIC)) == NULL)
 		return;
 
 	skb_reserve(skb, LAPB_HEADER_LEN + 1);
@@ -268,7 +327,7 @@
 	struct sk_buff *skb;
 	unsigned char  *dptr;
 
-	if ((skb = alloc_skb(LAPB_HEADER_LEN + 7, GFP_ATOMIC)) == NULL)
+	if ((skb = alloc_skb(LAPB_HEADER_LEN + 8, GFP_ATOMIC)) == NULL)
 		return;
 
 	skb_reserve(skb, LAPB_HEADER_LEN + 1);
@@ -286,6 +345,7 @@
 		*dptr++ = lapb->frmr_type;
 
 #if LAPB_DEBUG > 1
+	LAPB_DEBUG_DYN_CHK(lapb, 1)
 	printk(KERN_DEBUG "lapb: (%p) S%d TX FRMR %02X %02X %02X %02X
%02X\n",
 	       lapb->dev, lapb->state,
 	       skb->data[1], skb->data[2], skb->data[3],
@@ -303,6 +363,7 @@
 		*dptr++ = lapb->frmr_type;
 
 #if LAPB_DEBUG > 1
+	LAPB_DEBUG_DYN_CHK(lapb, 1)
 	printk(KERN_DEBUG "lapb: (%p) S%d TX FRMR %02X %02X %02X\n",
 	       lapb->dev, lapb->state, skb->data[1],
 	       skb->data[2], skb->data[3]);
