Return-Path: <linux-kernel-owner+w=401wt.eu-S932890AbXCNTc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890AbXCNTc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 15:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932926AbXCNTc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 15:32:26 -0400
Received: from 30.mail-out.ovh.net ([213.186.62.213]:53006 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932890AbXCNTcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 15:32:25 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Mar 2007 15:32:24 EDT
Date: Wed, 14 Mar 2007 21:25:19 +0200
From: Samuel Ortiz <samuel@sortiz.org>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, irda-users@lists.sourceforge.net, davej@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] IrDA: Lockdep annotation for hashbin locks
Message-ID: <20070314192519.GH3397@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Ovh-Remote: 90.28.106.156 (aannecy-257-1-27-156.w90-28.abo.wanadoo.fr)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rmmoding irda triggers a lockdep false positive. We can fix that by assigning
each hashbin lock to a separate class.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Samuel Ortiz <samuel@sortiz.org>
---
 include/net/irda/irqueue.h |    1 +
 net/irda/irqueue.c         |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/net/irda/irqueue.h b/include/net/irda/irqueue.h
index 335b0ac..67cb434 100644
--- a/include/net/irda/irqueue.h
+++ b/include/net/irda/irqueue.h
@@ -71,6 +71,7 @@ typedef struct hashbin_t {
 	int        hb_size;
 	spinlock_t hb_spinlock;		/* HB_LOCK - Can be used by the user */
 
+	struct lock_class_key hb_lock_key;
 	irda_queue_t* hb_queue[HASHBIN_SIZE] IRDA_ALIGN;
 
 	irda_queue_t* hb_current;
diff --git a/net/irda/irqueue.c b/net/irda/irqueue.c
index 9266233..2871a8a 100644
--- a/net/irda/irqueue.c
+++ b/net/irda/irqueue.c
@@ -370,6 +370,7 @@ hashbin_t *hashbin_new(int type)
 	/* Make sure all spinlock's are unlocked */
 	if ( hashbin->hb_type & HB_LOCK ) {
 		spin_lock_init(&hashbin->hb_spinlock);
+		lockdep_set_class(&hashbin->hb_spinlock, &hashbin->hb_lock_key);
 	}
 
 	return hashbin;
-- 
1.5.0.2

