Return-Path: <linux-kernel-owner+w=401wt.eu-S1763678AbXKOHH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763678AbXKOHH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932525AbXKOGsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:48:11 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43684 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932609AbXKOGsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:48:07 -0500
Date: Wed, 14 Nov 2007 22:45:42 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jiri Slaby <jirislaby@gmail.com>, Ferenc Wagner <wferi@niif.hu>
Subject: [patch 33/40] Char: rocket, fix dynamic_dev tty
Message-ID: <20071115064542.GH19218@kroah.com>
References: <20071115062710.885284510@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="char-rocket-fix-dynamic_dev-tty.patch"
In-Reply-To: <20071115064302.GA19218@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jiri Slaby <jirislaby@gmail.com>

patch ac6aec2f5683588361ab408cb3346b08c66bdfbe in mainline.

- register_device unconditionally (non-pci dependent) to have also isa
  devices in /dev
- unregister devices on module removal
- don't set TTY_DRIVER_DYNAMIC_DEV twice (removed the one dependent on some
  macro)

This is the substantial part of the patch and the previous point is for
not checking which devices to unregister and which not (simply register
and unregister all found no matter on which bus they are plugged).


Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Ferenc Wagner <wferi@niif.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/rocket.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/char/rocket.c
+++ b/drivers/char/rocket.c
@@ -699,8 +699,8 @@ static void init_r_port(int board, int a
 	spin_lock_init(&info->slock);
 	mutex_init(&info->write_mtx);
 	rp_table[line] = info;
-	if (pci_dev)
-		tty_register_device(rocket_driver, line, &pci_dev->dev);
+	tty_register_device(rocket_driver, line, pci_dev ? &pci_dev->dev :
+			NULL);
 }
 
 /*
@@ -2434,7 +2434,7 @@ static int __init rp_init(void)
 	rocket_driver->init_termios.c_ispeed = 9600;
 	rocket_driver->init_termios.c_ospeed = 9600;
 #ifdef ROCKET_SOFT_FLOW
-	rocket_driver->flags |= TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
+	rocket_driver->flags |= TTY_DRIVER_REAL_RAW;
 #endif
 	tty_set_operations(rocket_driver, &rocket_ops);
 
@@ -2491,10 +2491,14 @@ static void rp_cleanup_module(void)
 	if (retval)
 		printk(KERN_INFO "Error %d while trying to unregister "
 		       "rocketport driver\n", -retval);
-	put_tty_driver(rocket_driver);
 
 	for (i = 0; i < MAX_RP_PORTS; i++)
-		kfree(rp_table[i]);
+		if (rp_table[i]) {
+			tty_unregister_device(rocket_driver, i);
+			kfree(rp_table[i]);
+		}
+
+	put_tty_driver(rocket_driver);
 
 	for (i = 0; i < NUM_BOARDS; i++) {
 		if (rcktpt_io_addr[i] <= 0 || is_PCI[i])

-- 
