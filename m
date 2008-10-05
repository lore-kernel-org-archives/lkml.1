Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbYJEQ12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbYJEQ12 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758909AbYJEQWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:22:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57971 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758908AbYJEQWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:22:22 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 62/76] pty: simplify unix98 allocation
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:22:22 +0100
Message-ID: <20081005162215.1997.71087.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need both termios and termios_locked so allocate them as one

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/pty.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index 3c6b791..6d45827 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -488,7 +488,6 @@ static void pty_unix98_shutdown(struct tty_struct *tty)
 {
 	/* We have our own method as we don't use the tty index */
 	kfree(tty->termios);
-	kfree(tty->termios_locked);
 }
 
 /* We have no need to install and remove our tty objects as devpts does all
@@ -509,20 +508,17 @@ static int pty_unix98_install(struct tty_driver *driver, struct tty_struct *tty)
 	}
 	initialize_tty_struct(o_tty, driver->other, idx);
 
-	tty->termios = kmalloc(sizeof(struct ktermios), GFP_KERNEL);
+	tty->termios = kzalloc(sizeof(struct ktermios[2]), GFP_KERNEL);
 	if (tty->termios == NULL)
 		goto free_mem_out;
 	*tty->termios = driver->init_termios;
-	tty->termios_locked = kzalloc(sizeof(struct ktermios), GFP_KERNEL);
-	if (tty->termios_locked == NULL)
-		goto free_mem_out;
-	o_tty->termios = kmalloc(sizeof(struct ktermios), GFP_KERNEL);
+	tty->termios_locked = tty->termios + 1;
+
+	o_tty->termios = kzalloc(sizeof(struct ktermios[2]), GFP_KERNEL);
 	if (o_tty->termios == NULL)
 		goto free_mem_out;
 	*o_tty->termios = driver->other->init_termios;
-	o_tty->termios_locked = kzalloc(sizeof(struct ktermios), GFP_KERNEL);
-	if (o_tty->termios_locked == NULL)
-		goto free_mem_out;
+	o_tty->termios_locked = o_tty->termios + 1;
 
 	tty_driver_kref_get(driver->other);
 	if (driver->subtype == PTY_TYPE_MASTER)
@@ -540,10 +536,10 @@ static int pty_unix98_install(struct tty_driver *driver, struct tty_struct *tty)
 	pty_count++;
 	return 0;
 free_mem_out:
-	pty_unix98_shutdown(o_tty);
+	kfree(o_tty->termios);
 	module_put(o_tty->driver->owner);
 	free_tty_struct(o_tty);
-	pty_unix98_shutdown(tty);
+	kfree(tty->termios);
 	return -ENOMEM;
 }
 

