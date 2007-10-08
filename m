Return-Path: <linux-kernel-owner+w=401wt.eu-S1756107AbXJHMfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbXJHMfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 08:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754360AbXJHMfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 08:35:36 -0400
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:47093 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754541AbXJHMfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 08:35:34 -0400
Message-id: <25821446172402381@pripojeni.net>
Subject: [PATCH 1/1] V4L: rocket, switch sleep_on to completion
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <alan@lxorguk.ukuu.org.uk>
Date: Mon, 8 Oct 2007 08:35:34 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

rocket, switch sleep_on to completion

- sleep_on is deprecated and racy, use completion instead
- also check retval of interruptible function and return ERESTARTSYS
  eventually

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 6e42c2183befe136d85e6a8708ee4eabc543774b
tree 4a2b307dc66e1197b67afd6663e5dca7dee7f5e6
parent 9936225b4a065eec6eccd9700a680cc840280fdb
author Jiri Slaby <jirislaby@gmail.com> Mon, 08 Oct 2007 13:28:51 +0200
committer Jiri Slaby <jirislaby@gmail.com> Mon, 08 Oct 2007 13:28:51 +0200

 drivers/char/rocket.c     |   12 ++++++++----
 drivers/char/rocket_int.h |    7 +------
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/char/rocket.c b/drivers/char/rocket.c
index 56cbba7..d790b08 100644
--- a/drivers/char/rocket.c
+++ b/drivers/char/rocket.c
@@ -84,6 +84,7 @@
 #include <linux/mutex.h>
 #include <linux/ioport.h>
 #include <linux/delay.h>
+#include <linux/completion.h>
 #include <linux/wait.h>
 #include <linux/pci.h>
 #include <asm/uaccess.h>
@@ -650,7 +651,7 @@ static void init_r_port(int board, int aiop, int chan, struct pci_dev *pci_dev)
 	info->closing_wait = 3000;
 	info->close_delay = 50;
 	init_waitqueue_head(&info->open_wait);
-	init_waitqueue_head(&info->close_wait);
+	init_completion(&info->close_wait);
 	info->flags &= ~ROCKET_MODE_MASK;
 	switch (pc104[board][line]) {
 	case 422:
@@ -878,7 +879,8 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 	if (tty_hung_up_p(filp))
 		return ((info->flags & ROCKET_HUP_NOTIFY) ? -EAGAIN : -ERESTARTSYS);
 	if (info->flags & ROCKET_CLOSING) {
-		interruptible_sleep_on(&info->close_wait);
+		if (wait_for_completion_interruptible(&info->close_wait))
+			return -ERESTARTSYS;
 		return ((info->flags & ROCKET_HUP_NOTIFY) ? -EAGAIN : -ERESTARTSYS);
 	}
 
@@ -983,8 +985,10 @@ static int rp_open(struct tty_struct *tty, struct file *filp)
 		return -ENOMEM;
 
 	if (info->flags & ROCKET_CLOSING) {
-		interruptible_sleep_on(&info->close_wait);
+		retval = wait_for_completion_interruptible(&info->close_wait);
 		free_page(page);
+		if (retval)
+			return retval;
 		return ((info->flags & ROCKET_HUP_NOTIFY) ? -EAGAIN : -ERESTARTSYS);
 	}
 
@@ -1176,7 +1180,7 @@ static void rp_close(struct tty_struct *tty, struct file *filp)
 	}
 	info->flags &= ~(ROCKET_INITIALIZED | ROCKET_CLOSING | ROCKET_NORMAL_ACTIVE);
 	tty->closing = 0;
-	wake_up_interruptible(&info->close_wait);
+	complete_all(&info->close_wait);
 	atomic_dec(&rp_num_ports_open);
 
 #ifdef ROCKET_DEBUG_OPEN
diff --git a/drivers/char/rocket_int.h b/drivers/char/rocket_int.h
index b4c53df..148e81c 100644
--- a/drivers/char/rocket_int.h
+++ b/drivers/char/rocket_int.h
@@ -1163,13 +1163,8 @@ struct r_port {
 	int read_status_mask;
 	int cps;
 
-#ifdef DECLARE_WAITQUEUE
 	wait_queue_head_t open_wait;
-	wait_queue_head_t close_wait;
-#else
-	struct wait_queue *open_wait;
-	struct wait_queue *close_wait;
-#endif
+	struct completion *close_wait;
 	spinlock_t slock;
 	struct mutex write_mtx;
 };
