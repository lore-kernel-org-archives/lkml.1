Return-Path: <linux-kernel-owner+w=401wt.eu-S1762247AbZAaDKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762247AbZAaDKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:10:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757369AbZAaCrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:47 -0500
Received: from kroah.org ([198.145.64.141]:55542 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757193AbZAaCri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:47:38 -0500
Date: Fri, 30 Jan 2009 18:44:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Robin Holt <holt@sgi.com>,
       Dean Nelson <dcn@sgi.com>
Subject: [patch 31/43] sgi-xpc: ensure flags are updated before bte_copy
Message-ID: <20090131024427.GF12368@kroah.com>
References: <20090131022548.656772939@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sgi-xpc-ensure-flags-are-updated-before-bte_copy.patch"
In-Reply-To: <20090131024158.GA12368@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Robin Holt <holt@sgi.com>

commit 69b3bb65fa97a1e8563518dbbc35cd57beefb2d4 upstream.

The clearing of the msg->flags needs a barrier between it and the notify
of the channel threads that the messages are cleaned and ready for use.

Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Dean Nelson <dcn@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/sgi-xp/xpc_sn2.c |    9 +++++----
 drivers/misc/sgi-xp/xpc_uv.c  |    2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/misc/sgi-xp/xpc_sn2.c
+++ b/drivers/misc/sgi-xp/xpc_sn2.c
@@ -1841,6 +1841,7 @@ xpc_process_msg_chctl_flags_sn2(struct x
 		 */
 		xpc_clear_remote_msgqueue_flags_sn2(ch);
 
+		smp_wmb(); /* ensure flags have been cleared before bte_copy */
 		ch_sn2->w_remote_GP.put = ch_sn2->remote_GP.put;
 
 		dev_dbg(xpc_chan, "w_remote_GP.put changed to %ld, partid=%d, "
@@ -1939,7 +1940,7 @@ xpc_get_deliverable_payload_sn2(struct x
 			break;
 
 		get = ch_sn2->w_local_GP.get;
-		rmb();	/* guarantee that .get loads before .put */
+		smp_rmb();	/* guarantee that .get loads before .put */
 		if (get == ch_sn2->w_remote_GP.put)
 			break;
 
@@ -2060,7 +2061,7 @@ xpc_allocate_msg_sn2(struct xpc_channel 
 	while (1) {
 
 		put = ch_sn2->w_local_GP.put;
-		rmb();	/* guarantee that .put loads before .get */
+		smp_rmb();	/* guarantee that .put loads before .get */
 		if (put - ch_sn2->w_remote_GP.get < ch->local_nentries) {
 
 			/* There are available message entries. We need to try
@@ -2193,7 +2194,7 @@ xpc_send_payload_sn2(struct xpc_channel 
 	 * The preceding store of msg->flags must occur before the following
 	 * load of local_GP->put.
 	 */
-	mb();
+	smp_mb();
 
 	/* see if the message is next in line to be sent, if so send it */
 
@@ -2294,7 +2295,7 @@ xpc_received_payload_sn2(struct xpc_chan
 	 * The preceding store of msg->flags must occur before the following
 	 * load of local_GP->get.
 	 */
-	mb();
+	smp_mb();
 
 	/*
 	 * See if this message is next in line to be acknowledged as having
--- a/drivers/misc/sgi-xp/xpc_uv.c
+++ b/drivers/misc/sgi-xp/xpc_uv.c
@@ -1238,7 +1238,7 @@ xpc_send_payload_uv(struct xpc_channel *
 		atomic_inc(&ch->n_to_notify);
 
 		msg_slot->key = key;
-		wmb(); /* a non-NULL func must hit memory after the key */
+		smp_wmb(); /* a non-NULL func must hit memory after the key */
 		msg_slot->func = func;
 
 		if (ch->flags & XPC_C_DISCONNECTING) {

