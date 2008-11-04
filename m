Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbYKDXqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbYKDXqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:46:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757203AbYKDXjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:39:07 -0500
Received: from ns1.suse.de ([195.135.220.2]:47465 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756708AbYKDXjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:39:05 -0500
Date: Tue, 4 Nov 2008 15:31:53 -0800
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
       alan@lxorguk.ukuu.org.uk, linux1394-devel@lists.sourceforge.net,
       Jay Fenlason <fenlason@redhat.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 25/57] firewire: fw-sbp2: fix races
Message-ID: <20081104233153.GZ659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="firewire-fw-sbp2-fix-races.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jay Fenlason <fenlason@redhat.com>

Same as commit cd1f70fdb4823c97328a1f151f328eb36fafd579 upstream

1: There is a small race between queue_delayed_work() and its
   corresponding kref_get().  Do the kref_get first, and _put it again
   if the queue_delayed_work() failed, so there is no chance of the
   kref going to zero while the work is scheduled.
2: An SBP2_LOGOUT_REQUEST could be sent out with a login_id full of
   garbage.  Initialize it to an invalid value so we can tell if we
   ever got a valid login_id.
3: The node ID and generation may have changed but the new values may
   not yet have been recorded in lu and tgt when the final logout is
   attempted.  Use the latest values from the device in
   sbp2_release_target().

Signed-off-by: Jay Fenlason <fenlason@redhat.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firewire/fw-sbp2.c |   36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -172,6 +172,9 @@ struct sbp2_target {
 	int blocked;	/* ditto */
 };
 
+/* Impossible login_id, to detect logout attempt before successful login */
+#define INVALID_LOGIN_ID 0x10000
+
 /*
  * Per section 7.4.8 of the SBP-2 spec, a mgt_ORB_timeout value can be
  * provided in the config rom. Most devices do provide a value, which
@@ -791,9 +794,20 @@ static void sbp2_release_target(struct k
 			scsi_remove_device(sdev);
 			scsi_device_put(sdev);
 		}
-		sbp2_send_management_orb(lu, tgt->node_id, lu->generation,
-				SBP2_LOGOUT_REQUEST, lu->login_id, NULL);
-
+		if (lu->login_id != INVALID_LOGIN_ID) {
+			int generation, node_id;
+			/*
+			 * tgt->node_id may be obsolete here if we failed
+			 * during initial login or after a bus reset where
+			 * the topology changed.
+			 */
+			generation = device->generation;
+			smp_rmb(); /* node_id vs. generation */
+			node_id    = device->node_id;
+			sbp2_send_management_orb(lu, node_id, generation,
+						 SBP2_LOGOUT_REQUEST,
+						 lu->login_id, NULL);
+		}
 		fw_core_remove_address_handler(&lu->address_handler);
 		list_del(&lu->link);
 		kfree(lu);
@@ -808,19 +822,20 @@ static void sbp2_release_target(struct k
 
 static struct workqueue_struct *sbp2_wq;
 
+static void sbp2_target_put(struct sbp2_target *tgt)
+{
+	kref_put(&tgt->kref, sbp2_release_target);
+}
+
 /*
  * Always get the target's kref when scheduling work on one its units.
  * Each workqueue job is responsible to call sbp2_target_put() upon return.
  */
 static void sbp2_queue_work(struct sbp2_logical_unit *lu, unsigned long delay)
 {
-	if (queue_delayed_work(sbp2_wq, &lu->work, delay))
-		kref_get(&lu->tgt->kref);
-}
-
-static void sbp2_target_put(struct sbp2_target *tgt)
-{
-	kref_put(&tgt->kref, sbp2_release_target);
+	kref_get(&lu->tgt->kref);
+	if (!queue_delayed_work(sbp2_wq, &lu->work, delay))
+		sbp2_target_put(lu->tgt);
 }
 
 static void
@@ -993,6 +1008,7 @@ static int sbp2_add_logical_unit(struct 
 
 	lu->tgt      = tgt;
 	lu->lun      = lun_entry & 0xffff;
+	lu->login_id = INVALID_LOGIN_ID;
 	lu->retries  = 0;
 	lu->has_sdev = false;
 	lu->blocked  = false;

-- 
