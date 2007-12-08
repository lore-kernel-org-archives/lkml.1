Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbXLHQXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbXLHQXZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 11:23:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbXLHQXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 11:23:18 -0500
Received: from mx1.riseup.net ([204.13.164.18]:57267 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbXLHQXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 11:23:18 -0500
Date: Sat, 8 Dec 2007 17:23:13 +0100
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: jgarzik@pobox.com, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] PLIP driver: convert killed_timer_sem to completion
Message-ID: <20071208162313.GA15658@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	jgarzik@pobox.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PLIP driver: convert the semaphore killed_timer_sem to
a completion

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/net/plip.c b/drivers/net/plip.c
index 57c9866..fee3d7b 100644
--- a/drivers/net/plip.c
+++ b/drivers/net/plip.c
@@ -106,6 +106,7 @@ static const char version[] = "NET3 PLIP version 2.4-parport gniibe@mri.co.jp\n"
 #include <linux/if_plip.h>
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
+#include <linux/completion.h>
 #include <linux/parport.h>
 #include <linux/bitops.h>
 
@@ -114,7 +115,6 @@ static const char version[] = "NET3 PLIP version 2.4-parport gniibe@mri.co.jp\n"
 #include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/byteorder.h>
-#include <asm/semaphore.h>
 
 /* Maximum number of devices to support. */
 #define PLIP_MAX  8
@@ -221,7 +221,7 @@ struct net_local {
 	int should_relinquish;
 	spinlock_t lock;
 	atomic_t kill_timer;
-	struct semaphore killed_timer_sem;
+	struct completion killed_timer_cmp;
 };
 
 static inline void enable_parport_interrupts (struct net_device *dev)
@@ -385,7 +385,7 @@ plip_timer_bh(struct work_struct *work)
 		schedule_delayed_work(&nl->timer, 1);
 	}
 	else {
-		up (&nl->killed_timer_sem);
+		complete(&nl->killed_timer_cmp);
 	}
 }
 
@@ -1112,9 +1112,9 @@ plip_close(struct net_device *dev)
 
 	if (dev->irq == -1)
 	{
-		init_MUTEX_LOCKED (&nl->killed_timer_sem);
+		init_completion(&nl->killed_timer_cmp);
 		atomic_set (&nl->kill_timer, 1);
-		down (&nl->killed_timer_sem);
+		wait_for_completion(&nl->killed_timer_cmp);
 	}
 
 #ifdef NOTDEF

-- 
Matthias Kaehlcke
Linux System Developer
Barcelona

     La libertad es como la mañana. Hay quienes esperan dormidos a que
   llegue, pero hay quienes desvelan y caminan la noche para alcanzarla
                        (Subcomandante Marcos)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
