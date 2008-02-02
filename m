Return-Path: <linux-kernel-owner+w=401wt.eu-S1761534AbYBBHwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761534AbYBBHwj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 02:52:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbYBBHwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 02:52:32 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:13277 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756300AbYBBHwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 02:52:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=J+rjQiHd8Ve4mK40R9Bsp2OQXC/kOjaG0KJv+Hd0dTDBtoqrFpwtRDZwCYkrbZM4FIOcH+ssidWMAH+novX3Pi0iAmSLuHViKTjNoSR6y3oNzOIrp+NobwzeSXxh7IG7+o5/znzb3P4kSV2DAfz5qhvYxlgJpt0LfsPv9OifXhc=
From: Denis Cheng <crquan@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ide-core: remove conditional compiling with MODULE in ide-core.c
Date: Sat,  2 Feb 2008 15:52:30 +0800
Message-Id: <1201938750-22423-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use module_init/module_exit to replace the original cond-compiling, these
macros were well designed to deal module/built-in compiling.

the original __setup with null string was invalid and not executed,
	__setup("", ide_setup);

however, with the current module_param mechanics, module parameters also can
be input on the kernel command line, with this style:

	ide-core.options="ide=nodma hdd=cdrom idebus=..."

so Documentation/kernel-parameters.txt also updated.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 Documentation/kernel-parameters.txt |   11 +------
 drivers/ide/ide.c                   |   55 ++++++++++++++--------------------
 2 files changed, 25 insertions(+), 41 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index cf38689..c94730c 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -759,15 +759,8 @@ and is between 256 and 4096 characters. It is defined in the file
 	icn=		[HW,ISDN]
 			Format: <io>[,<membase>[,<icn_id>[,<icn_id2>]]]
 
-	ide=		[HW] (E)IDE subsystem
-			Format: ide=nodma or ide=doubler or ide=reverse
-			See Documentation/ide.txt.
-
-	ide?=		[HW] (E)IDE subsystem
-			Format: ide?=noprobe or chipset specific parameters.
-			See Documentation/ide.txt.
-
-	idebus=		[HW] (E)IDE subsystem - VLB/PCI bus speed
+	ide-core.options= [HW] (E)IDE subsystem
+			Format: ide-core.options="ide=nodma hdd=cdrom idebus=..."
 			See Documentation/ide.txt.
 
 	idle=		[X86]
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index ab9ca2b..28923ef 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -1654,6 +1654,25 @@ struct bus_type ide_bus_type = {
 
 EXPORT_SYMBOL_GPL(ide_bus_type);
 
+static char *options;
+module_param(options, charp, S_IRUGO);
+MODULE_LICENSE("GPL");
+
+static void __init parse_options(char *line)
+{
+	char *next = line;
+
+	if (line == NULL || !*line)
+		return;
+	while ((line = next) != NULL) {
+		next = strchr(line, ' ');
+		if (next != NULL)
+			*next++ = 0;
+		if (!ide_setup(line))
+			printk(KERN_INFO "Unknown option '%s'\n", line);
+	}
+}
+
 /*
  * This is gets invoked once during initialization, to set *everything* up
  */
@@ -1661,6 +1680,8 @@ static int __init ide_init(void)
 {
 	int ret;
 
+	parse_options(options);
+
 	printk(KERN_INFO "Uniform Multi-Platform E-IDE driver " REVISION "\n");
 	system_bus_speed = ide_system_bus_speed();
 
@@ -1681,32 +1702,7 @@ static int __init ide_init(void)
 	return 0;
 }
 
-#ifdef MODULE
-static char *options = NULL;
-module_param(options, charp, 0);
-MODULE_LICENSE("GPL");
-
-static void __init parse_options (char *line)
-{
-	char *next = line;
-
-	if (line == NULL || !*line)
-		return;
-	while ((line = next) != NULL) {
- 		if ((next = strchr(line,' ')) != NULL)
-			*next++ = 0;
-		if (!ide_setup(line))
-			printk (KERN_INFO "Unknown option '%s'\n", line);
-	}
-}
-
-int __init init_module (void)
-{
-	parse_options(options);
-	return ide_init();
-}
-
-void __exit cleanup_module (void)
+static void __exit ide_exit(void)
 {
 	int index;
 
@@ -1718,10 +1714,5 @@ void __exit cleanup_module (void)
 	bus_unregister(&ide_bus_type);
 }
 
-#else /* !MODULE */
-
-__setup("", ide_setup);
-
 module_init(ide_init);
-
-#endif /* MODULE */
+module_exit(ide_exit);
-- 
1.5.3.8

