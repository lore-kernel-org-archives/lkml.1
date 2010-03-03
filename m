Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab0CCICg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 03:02:36 -0500
Received: from isilmar.linta.de ([213.133.102.198]:49109 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753933Ab0CCICe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 03:02:34 -0500
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: <linux-pcmcia@lists.infradead.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] pcmcia: disable pcmcia ioctl for !ARM, prepare for removal
Date: Wed,  3 Mar 2010 09:00:48 +0100
Message-Id: <1267603248-23866-5-git-send-email-linux@dominikbrodowski.net>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20100303075944.GA23354@comet.dominikbrodowski.net>
References: <20100303075944.GA23354@comet.dominikbrodowski.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCMCIA ioctl -- deprecated for years -- suffers from insufficient
locking. As it already has been deprecated for years, with its removal
long overdue, limit it to !SMP and !PREEMPT.

Furthermore, the last legitimate use of the ioctl to be reported
relates to the ARM architecture in 2008.[1] Attempts to resolve
this issue turned out unsuccessful so far.[2] Other usages have only
been reported as hear-say. If there are any legitiate and necessary
use-cases remaining, please speak out before the end of the grace
period until 2.6.3{5,6}(-rc1).

[1] http://lists.infradead.org/pipermail/linux-pcmcia/2008-April/005440.html
    see also: http://lkml.org/lkml/2008/2/27/291
[2] http://lists.infradead.org/pipermail/linux-pcmcia/2008-April/005450.html
    http://lists.infradead.org/pipermail/linux-pcmcia/2010-January/006740.html
    see also: http://lists.infradead.org/pipermail/linux-pcmcia/2008-April/005453.html

CC: Russell King <rmk+kernel@arm.linux.org.uk>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Robert P. J. Day <rpjday@crashcourse.ca>
CC: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: linux-kernel@vger.kernel.org
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
---
 Documentation/feature-removal-schedule.txt |   12 +++++++++---
 drivers/pcmcia/Kconfig                     |   14 ++++++++++----
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 732b1fa..3e57a75 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -138,19 +138,25 @@ Who:	Mauro Carvalho Chehab <mchehab@infradead.org>
 ---------------------------
 
 What:	PCMCIA control ioctl (needed for pcmcia-cs [cardmgr, cardctl])
-When:	November 2005
+When:	2.6.35/2.6.36
 Files:	drivers/pcmcia/: pcmcia_ioctl.c
 Why:	With the 16-bit PCMCIA subsystem now behaving (almost) like a
 	normal hotpluggable bus, and with it using the default kernel
 	infrastructure (hotplug, driver core, sysfs) keeping the PCMCIA
 	control ioctl needed by cardmgr and cardctl from pcmcia-cs is
-	unnecessary, and makes further cleanups and integration of the
+	unnecessary and potentially harmful (it does not provide for
+	proper locking), and makes further cleanups and integration of the
 	PCMCIA subsystem into the Linux kernel device driver model more
 	difficult. The features provided by cardmgr and cardctl are either
 	handled by the kernel itself now or are available in the new
 	pcmciautils package available at
 	http://kernel.org/pub/linux/utils/kernel/pcmcia/
-Who:	Dominik Brodowski <linux@brodo.de>
+
+	For all architectures except ARM, the associated config symbol
+	has been removed from kernel 2.6.34; for ARM, it will be likely
+	be removed from kernel 2.6.35. The actual code will then likely
+	be removed from kernel 2.6.36.
+Who:	Dominik Brodowski <linux@dominikbrodowski.net>
 
 ---------------------------
 
diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
index 0a6601c..d189e47 100644
--- a/drivers/pcmcia/Kconfig
+++ b/drivers/pcmcia/Kconfig
@@ -51,17 +51,23 @@ config PCMCIA_LOAD_CIS
 
 config PCMCIA_IOCTL
 	bool "PCMCIA control ioctl (obsolete)"
-	depends on PCMCIA
+	depends on PCMCIA && ARM && !SMP && !PREEMPT
 	default y
 	help
 	  If you say Y here, the deprecated ioctl interface to the PCMCIA
-	  subsystem will be built. It is needed by cardmgr and cardctl
-	  (pcmcia-cs) to function properly.
+	  subsystem will be built. It is needed by the deprecated pcmcia-cs
+	  tools (cardmgr, cardctl) to function properly.
 
 	  You should use the new pcmciautils package instead (see
 	  <file:Documentation/Changes> for location and details).
 
-	  If unsure, say Y.
+	  This config option will most likely be removed from kernel 2.6.35,
+	  the associated code from kernel 2.6.36.
+
+	  As the PCMCIA ioctl is not locking safe, it depends on !SMP and
+	  !PREEMPT.
+
+	  If unsure, say N.
 
 config CARDBUS
 	bool "32-bit CardBus support"
-- 
1.6.3.3

