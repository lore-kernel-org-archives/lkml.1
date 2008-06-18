Return-Path: <linux-kernel-owner+w=401wt.eu-S1755649AbYFRVJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649AbYFRVJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 17:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbYFRVJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 17:09:24 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:55140 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbYFRVJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 17:09:24 -0400
Date: Wed, 18 Jun 2008 14:09:07 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: ankita@in.ibm.com, akpm <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] lkdtm: fix for CONFIG_SCSI=n
Message-Id: <20080618140907.fd0dbc95.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix lkdtm test code for case of CONFIG_SCSI=n, to avoid build errors:

In file included from linux-next-20080618/tests/lkdtm.c:55:
linux-next-20080618/include/scsi/scsi_cmnd.h:28:25: warning: "BLK_MAX_CDB" is not defined
linux-next-20080618/include/scsi/scsi_cmnd.h:29:3: error: #error MAX_COMMAND_SIZE can not be bigger than BLK_MAX_CDB
In file included from linux-next-20080618/tests/lkdtm.c:55:
linux-next-20080618/include/scsi/scsi_cmnd.h: In function 'scsi_bidi_cmnd':
linux-next-20080618/include/scsi/scsi_cmnd.h:183: error: implicit declaration of function 'blk_bidi_rq'
linux-next-20080618/include/scsi/scsi_cmnd.h:184: error: dereferencing pointer to incomplete type
linux-next-20080618/include/scsi/scsi_cmnd.h: In function 'scsi_in':
linux-next-20080618/include/scsi/scsi_cmnd.h:190: error: dereferencing pointer to incomplete type
make[2]: *** [tests/lkdtm.o] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 tests/lkdtm.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- linux-next-20080618.orig/tests/lkdtm.c
+++ linux-next-20080618/tests/lkdtm.c
@@ -52,7 +52,9 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/hrtimer.h>
+#ifdef CONFIG_SCSI
 #include <scsi/scsi_cmnd.h>
+#endif
 
 #ifdef CONFIG_IDE
 #include <linux/ide.h>
@@ -175,12 +177,14 @@ static int jp_hrtimer_start(struct hrtim
 	return 0;
 }
 
+#ifdef CONFIG_SCSI
 static int jp_scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 {
 	lkdtm_handler();
 	jprobe_return();
 	return 0;
 }
+#endif
 
 #ifdef CONFIG_IDE
 int jp_generic_ide_ioctl(ide_drive_t *drive, struct file *file,
@@ -307,8 +311,12 @@ static int __init lkdtm_module_init(void
 		lkdtm.entry = (kprobe_opcode_t*) jp_hrtimer_start;
 		break;
 	case SCSI_DISPATCH_CMD:
+#ifdef CONFIG_SCSI
 		lkdtm.kp.symbol_name = "scsi_dispatch_cmd";
 		lkdtm.entry = (kprobe_opcode_t*) jp_scsi_dispatch_cmd;
+#else
+		printk(KERN_INFO "lkdtm : Crash point not available\n");
+#endif
 		break;
 	case IDE_CORE_CP:
 #ifdef CONFIG_IDE


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
