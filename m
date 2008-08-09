Return-Path: <linux-kernel-owner+w=401wt.eu-S1752655AbYHIRju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbYHIRju (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 13:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750725AbYHIRjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 13:39:42 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:51338 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbYHIRjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 13:39:41 -0400
Message-ID: <489DD669.2090207@keyaccess.nl>
Date: Sat, 09 Aug 2008 19:39:53 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Fritz Elfert <fritz@isdn4linux.de>, Karsten Keil <kkeil@suse.de>,
       isdn4linux@listserv.isdn4linux.de,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] ISDN: make ICN not auto-grab port 0x320
Content-Type: multipart/mixed;
 boundary="------------010707000301090404070404"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010707000301090404070404
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Andrew.

Stop Breaking Ingo's Randconfig Testing, Part II.

Rene.

--------------010707000301090404070404
Content-Type: text/plain;
 name="0001-ISDN-make-ICN-not-auto-grab-port-0x320.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-ISDN-make-ICN-not-auto-grab-port-0x320.patch"

>From 6f6a39c8dbc42d69d6dd654821cae8214ec382d5 Mon Sep 17 00:00:00 2001
From: Rene Herman <rene.herman@gmail.com>
Date: Sat, 9 Aug 2008 18:12:12 +0200
Subject: [PATCH] ISDN: make ICN not auto-grab port 0x320

Grabbing ISA bus resources without anything or anyone telling us we
should can break boot on randconfig/allyesconfig builds by keeping
resources that are in fact owned by different hardware busy and does
as reported by Ingo Molnar.

Generally it's also dangerous to just poke at random I/O ports and
especially those in the range where other old easily confused ISA
hardware might live.

For this old I4L ISA ISDN driver, insist that the user specify the
port before grabbing it.

Users of this driver are nonexistent or howling mad and a one time

echo "options icn baseport=0x320" >> /etc/modprobe.conf

away from the old behaviour.

This is a deprecated driver (stack, even) but as long as it's in the
tree, might as well fix it I guess.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
---
 drivers/isdn/icn/icn.c |   41 ++++++++++++++++++++++++++++++++++++++---
 1 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/icn/icn.c b/drivers/isdn/icn/icn.c
index bf7997a..56fc1bd 100644
--- a/drivers/isdn/icn/icn.c
+++ b/drivers/isdn/icn/icn.c
@@ -13,8 +13,9 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/sched.h>
+#include <linux/isa.h>
 
-static int portbase = ICN_BASEADDR;
+static int portbase;
 static unsigned long membase = ICN_MEMADDR;
 static char *icn_id = "\0";
 static char *icn_id2 = "\0";
@@ -1623,7 +1624,20 @@ icn_setup(char *line)
 __setup("icn=", icn_setup);
 #endif /* MODULE */
 
-static int __init icn_init(void)
+static int __devinit icn_isa_match(struct device *isa_dev, unsigned int id)
+{
+	int match = portbase != 0;
+
+	if (match)
+		dev_info(isa_dev, "portbase = %#x, membase = %#lx\n",
+			 portbase, membase);
+	else
+		dev_err(isa_dev, "please specify portbase\n");
+
+	return match;
+}
+
+static int __devinit icn_isa_probe(struct device *isa_dev, unsigned int id)
 {
 	char *p;
 	char rev[10];
@@ -1646,7 +1660,7 @@ static int __init icn_init(void)
 	return (icn_addcard(portbase, icn_id, icn_id2));
 }
 
-static void __exit icn_exit(void)
+static int __devexit icn_isa_remove(struct device *isa_dev, unsigned int id)
 {
 	isdn_ctrl cmd;
 	icn_card *card = cards;
@@ -1685,6 +1699,27 @@ static void __exit icn_exit(void)
 		iounmap(dev.shmem);
 		release_mem_region(dev.memaddr, 0x4000);
 	}
+	return 0;
+}
+
+static struct isa_driver icn_isa_driver = {
+	.match		= icn_isa_match,
+	.probe		= icn_isa_probe,
+	.remove		= __devexit_p(icn_isa_remove),
+
+	.driver	= {
+		.name	= "icn"
+	}
+};
+
+static int __init icn_init(void)
+{
+	return isa_register_driver(&icn_isa_driver, 1);
+}
+
+static void __exit icn_exit(void)
+{
+	isa_unregister_driver(&icn_isa_driver);
 	printk(KERN_NOTICE "ICN-ISDN-driver unloaded\n");
 }
 
-- 
1.5.5


--------------010707000301090404070404--
