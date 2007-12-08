Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbXLHPKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbXLHPKM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 10:10:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbXLHPJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 10:09:59 -0500
Received: from mx1.riseup.net ([204.13.164.18]:45265 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbXLHPJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 10:09:58 -0500
Date: Sat, 8 Dec 2007 16:09:54 +0100
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: paulus@samba.org, linux-ppp@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] PPP synchronous tty: convert dead_sem to completion
Message-ID: <20071208150954.GA8467@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	paulus@samba.org, linux-ppp@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PPP synchronous tty channel driver: convert the semaphore dead_sem to
a completion

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/net/ppp_synctty.c b/drivers/net/ppp_synctty.c
index f0c6a19..f7472c8 100644
--- a/drivers/net/ppp_synctty.c
+++ b/drivers/net/ppp_synctty.c
@@ -42,9 +42,9 @@
 #include <linux/if_ppp.h>
 #include <linux/ppp_channel.h>
 #include <linux/spinlock.h>
+#include <linux/completion.h>
 #include <linux/init.h>
 #include <asm/uaccess.h>
-#include <asm/semaphore.h>
 
 #define PPP_VERSION	"2.4.2"
 
@@ -70,7 +70,7 @@ struct syncppp {
 	struct tasklet_struct tsk;
 
 	atomic_t	refcnt;
-	struct semaphore dead_sem;
+	struct completion dead_cmp;
 	struct ppp_channel chan;	/* interface to generic ppp layer */
 };
 
@@ -195,7 +195,7 @@ static struct syncppp *sp_get(struct tty_struct *tty)
 static void sp_put(struct syncppp *ap)
 {
 	if (atomic_dec_and_test(&ap->refcnt))
-		up(&ap->dead_sem);
+		complete(&ap->dead_cmp);
 }
 
 /*
@@ -225,7 +225,7 @@ ppp_sync_open(struct tty_struct *tty)
 	tasklet_init(&ap->tsk, ppp_sync_process, (unsigned long) ap);
 
 	atomic_set(&ap->refcnt, 1);
-	init_MUTEX_LOCKED(&ap->dead_sem);
+	init_completion(&ap->dead_cmp);
 
 	ap->chan.private = ap;
 	ap->chan.ops = &sync_ops;
@@ -273,7 +273,7 @@ ppp_sync_close(struct tty_struct *tty)
 	 * by the time it returns.
 	 */
 	if (!atomic_dec_and_test(&ap->refcnt))
-		down(&ap->dead_sem);
+		wait_for_completion(&ap->dead_cmp);
 	tasklet_kill(&ap->tsk);
 
 	ppp_unregister_channel(&ap->chan);

-- 
Matthias Kaehlcke
Linux System Developer
Barcelona

      In itself, homosexuality is as limiting as heterosexuality: the
     ideal should be to be capable of loving a woman or a man; either,
      a human being, without  feeling fear, restraint, or obligation
                          (Simone de Beauvoir)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
