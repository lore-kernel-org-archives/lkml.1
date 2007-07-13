Return-Path: <linux-kernel-owner+w=401wt.eu-S1762959AbXGMTWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762959AbXGMTWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 15:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759097AbXGMTW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 15:22:26 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:55233
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757971AbXGMTWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 15:22:25 -0400
Date: Fri, 13 Jul 2007 21:23:47 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 1/5] use mutex instead of semaphore in SPI core/init code
Message-ID: <20070713192347.GE18159@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	dbrownell@users.sourceforge.net,
	spi-devel-general@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20070713192023.GD18159@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070713192023.GD18159@traven>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The SPI core/init code uses a semaphore as mutex. Use the mutex
API instead of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 4831edb..018884d 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -23,6 +23,7 @@
 #include <linux/device.h>
 #include <linux/init.h>
 #include <linux/cache.h>
+#include <linux/mutex.h>
 #include <linux/spi/spi.h>
 
 
@@ -185,7 +186,7 @@ struct boardinfo {
 };
 
 static LIST_HEAD(board_list);
-static DECLARE_MUTEX(board_lock);
+static DEFINE_MUTEX(board_lock);
 
 
 /**
@@ -292,9 +293,9 @@ spi_register_board_info(struct spi_board_info const *info, unsigned n)
 	bi->n_board_info = n;
 	memcpy(bi->board_info, info, n * sizeof *info);
 
-	down(&board_lock);
+	mutex_lock(&board_lock);
 	list_add_tail(&bi->list, &board_list);
-	up(&board_lock);
+	mutex_unlock(&board_lock);
 	return 0;
 }
 
@@ -308,7 +309,7 @@ scan_boardinfo(struct spi_master *master)
 	struct boardinfo	*bi;
 	struct device		*dev = master->cdev.dev;
 
-	down(&board_lock);
+	mutex_lock(&board_lock);
 	list_for_each_entry(bi, &board_list, list) {
 		struct spi_board_info	*chip = bi->board_info;
 		unsigned		n;
@@ -330,7 +331,7 @@ scan_boardinfo(struct spi_master *master)
 			(void) spi_new_device(master, chip);
 		}
 	}
-	up(&board_lock);
+	mutex_unlock(&board_lock);
 }
 
 /*-------------------------------------------------------------------------*/

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

    Ma patrie est où je suis, où personne ne me dérange, où personne
    ne me demande que je suis, d'où je viens et ce que je fais
                              (B. Traven)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
