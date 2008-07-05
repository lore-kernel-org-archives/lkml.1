Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbYGEN2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbYGEN2x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 09:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbYGEN2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 09:28:45 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:57567 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbYGEN2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 09:28:44 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/4] Char: merge ip2main and ip2base
Date: Sat,  5 Jul 2008 15:28:23 +0200
Message-Id: <1215264506-32455-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's pretty useless to have one setup() function separated along with
module_init() which only calls a function from ip2main anyway. Get rid
of ip2base.

Remove also checks of always-true now.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/ip2/Makefile  |    2 +-
 drivers/char/ip2/ip2base.c |  108 --------------------------------------------
 drivers/char/ip2/ip2main.c |   92 +++++++++++++++++++++++++++++++-------
 3 files changed, 77 insertions(+), 125 deletions(-)
 delete mode 100644 drivers/char/ip2/ip2base.c

diff --git a/drivers/char/ip2/Makefile b/drivers/char/ip2/Makefile
index 939618f..bc397d9 100644
--- a/drivers/char/ip2/Makefile
+++ b/drivers/char/ip2/Makefile
@@ -4,5 +4,5 @@
 
 obj-$(CONFIG_COMPUTONE)         += ip2.o
 
-ip2-objs			:= ip2base.o ip2main.o
+ip2-objs			:= ip2main.o
 
diff --git a/drivers/char/ip2/ip2base.c b/drivers/char/ip2/ip2base.c
deleted file mode 100644
index 8155e24..0000000
--- a/drivers/char/ip2/ip2base.c
+++ /dev/null
@@ -1,108 +0,0 @@
-// ip2.c
-// This is a dummy module to make the firmware available when needed
-// and allows it to be unloaded when not. Rumor is the __initdata 
-// macro doesn't always works on all platforms so we use this kludge.
-// If not compiled as a module it just makes fip_firm avaliable then
-//  __initdata should work as advertized
-//
-
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/wait.h>
-
-#ifndef __init
-#define __init
-#endif
-#ifndef __initfunc
-#define __initfunc(a) a
-#endif
-#ifndef __initdata
-#define __initdata
-#endif
-
-#include "ip2types.h"		
-
-int
-ip2_loadmain(int *, int *); // ref into ip2main.c
-
-/* Note: Add compiled in defaults to these arrays, not to the structure
-	in ip2.h any longer.  That structure WILL get overridden
-	by these values, or command line values, or insmod values!!!  =mhw=
-*/
-static int io[IP2_MAX_BOARDS]= { 0, 0, 0, 0 };
-static int irq[IP2_MAX_BOARDS] = { -1, -1, -1, -1 }; 
-
-static int poll_only = 0;
-
-MODULE_AUTHOR("Doug McNash");
-MODULE_DESCRIPTION("Computone IntelliPort Plus Driver");
-module_param_array(irq, int, NULL, 0);
-MODULE_PARM_DESC(irq,"Interrupts for IntelliPort Cards");
-module_param_array(io, int, NULL, 0);
-MODULE_PARM_DESC(io,"I/O ports for IntelliPort Cards");
-module_param(poll_only, bool, 0);
-MODULE_PARM_DESC(poll_only,"Do not use card interrupts");
-
-
-static int __init ip2_init(void)
-{
-	if( poll_only ) {
-		/* Hard lock the interrupts to zero */
-		irq[0] = irq[1] = irq[2] = irq[3] = 0;
-	}
-
-	return ip2_loadmain(io, irq);
-}
-module_init(ip2_init);
-
-MODULE_LICENSE("GPL");
-
-#ifndef MODULE
-/******************************************************************************
- *	ip2_setup:
- *		str: kernel command line string
- *
- *	Can't autoprobe the boards so user must specify configuration on
- *	kernel command line.  Sane people build it modular but the others
- *	come here.
- *
- *	Alternating pairs of io,irq for up to 4 boards.
- *		ip2=io0,irq0,io1,irq1,io2,irq2,io3,irq3
- *
- *		io=0 => No board
- *		io=1 => PCI
- *		io=2 => EISA
- *		else => ISA I/O address
- *
- *		irq=0 or invalid for ISA will revert to polling mode
- *
- *		Any value = -1, do not overwrite compiled in value.
- *
- ******************************************************************************/
-static int __init ip2_setup(char *str)
-{
-	int	ints[10];	/* 4 boards, 2 parameters + 2 */
-	int	i, j;
-
-	str = get_options (str, ARRAY_SIZE(ints), ints);
-
-	for( i = 0, j = 1; i < 4; i++ ) {
-		if( j > ints[0] ) {
-			break;
-		}
-		if( ints[j] >= 0 ) {
-			io[i] = ints[j];
-		}
-		j++;
-		if( j > ints[0] ) {
-			break;
-		}
-		if( ints[j] >= 0 ) {
-			irq[i] = ints[j];
-		}
-		j++;
-	}
-	return 1;
-}
-__setup("ip2=", ip2_setup);
-#endif /* !MODULE */
diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index d00b132..8ac1dfe 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -157,9 +157,6 @@ static char *pcVersion = "1.2.14";
 static char *pcDriver_name   = "ip2";
 static char *pcIpl    		 = "ip2ipl";
 
-// cheezy kludge or genius - you decide?
-int ip2_loadmain(int *, int *);
-
 /***********************/
 /* Function Prototypes */
 /***********************/
@@ -287,6 +284,7 @@ static int tracewrap;
 
 MODULE_AUTHOR("Doug McNash");
 MODULE_DESCRIPTION("Computone IntelliPort Plus Driver");
+MODULE_LICENSE("GPL");
 
 static int poll_only = 0;
 
@@ -297,6 +295,22 @@ static int iindx;
 static char rirqs[IP2_MAX_BOARDS];
 static int Valid_Irqs[] = { 3, 4, 5, 7, 10, 11, 12, 15, 0};
 
+/* Note: Add compiled in defaults to these arrays, not to the structure
+	in ip2.h any longer.  That structure WILL get overridden
+	by these values, or command line values, or insmod values!!!  =mhw=
+*/
+static int io[IP2_MAX_BOARDS];
+static int irq[IP2_MAX_BOARDS] = { -1, -1, -1, -1 };
+
+MODULE_AUTHOR("Doug McNash");
+MODULE_DESCRIPTION("Computone IntelliPort Plus Driver");
+module_param_array(irq, int, NULL, 0);
+MODULE_PARM_DESC(irq, "Interrupts for IntelliPort Cards");
+module_param_array(io, int, NULL, 0);
+MODULE_PARM_DESC(io, "I/O ports for IntelliPort Cards");
+module_param(poll_only, bool, 0);
+MODULE_PARM_DESC(poll_only, "Do not use card interrupts");
+
 /* for sysfs class support */
 static struct class *ip2_class;
 
@@ -492,8 +506,53 @@ static const struct firmware *ip2_request_firmware(void)
 	return fw;
 }
 
-int
-ip2_loadmain(int *iop, int *irqp)
+#ifndef MODULE
+/******************************************************************************
+ *	ip2_setup:
+ *		str: kernel command line string
+ *
+ *	Can't autoprobe the boards so user must specify configuration on
+ *	kernel command line.  Sane people build it modular but the others
+ *	come here.
+ *
+ *	Alternating pairs of io,irq for up to 4 boards.
+ *		ip2=io0,irq0,io1,irq1,io2,irq2,io3,irq3
+ *
+ *		io=0 => No board
+ *		io=1 => PCI
+ *		io=2 => EISA
+ *		else => ISA I/O address
+ *
+ *		irq=0 or invalid for ISA will revert to polling mode
+ *
+ *		Any value = -1, do not overwrite compiled in value.
+ *
+ ******************************************************************************/
+static int __init ip2_setup(char *str)
+{
+	int j, ints[10];	/* 4 boards, 2 parameters + 2 */
+	unsigned int i;
+
+	str = get_options(str, ARRAY_SIZE(ints), ints);
+
+	for (i = 0, j = 1; i < 4; i++) {
+		if (j > ints[0])
+			break;
+		if (ints[j] >= 0)
+			io[i] = ints[j];
+		j++;
+		if (j > ints[0])
+			break;
+		if (ints[j] >= 0)
+			irq[i] = ints[j];
+		j++;
+	}
+	return 1;
+}
+__setup("ip2=", ip2_setup);
+#endif /* !MODULE */
+
+static int ip2_loadmain(void)
 {
 	int i, j, box;
 	int err = 0;
@@ -503,6 +562,11 @@ ip2_loadmain(int *iop, int *irqp)
 	static struct pci_dev *pci_dev_i = NULL;
 	const struct firmware *fw = NULL;
 
+	if (poll_only) {
+		/* Hard lock the interrupts to zero */
+		irq[0] = irq[1] = irq[2] = irq[3] = poll_only = 0;
+	}
+
 	ip2trace (ITRC_NO_PORT, ITRC_INIT, ITRC_ENTER, 0 );
 
 	/* process command line arguments to modprobe or
@@ -510,14 +574,11 @@ ip2_loadmain(int *iop, int *irqp)
 	/* irqp and iop should ALWAYS be specified now...  But we check
 		them individually just to be sure, anyways... */
 	for ( i = 0; i < IP2_MAX_BOARDS; ++i ) {
-		if (iop) {
-			ip2config.addr[i] = iop[i];
-			if (irqp) {
-				if( irqp[i] >= 0 ) {
-					ip2config.irq[i] = irqp[i];
-				} else {
-					ip2config.irq[i] = 0;
-				}
+		ip2config.addr[i] = io[i];
+		if (irq[i] >= 0)
+			ip2config.irq[i] = irq[i];
+		else
+			ip2config.irq[i] = 0;
 	// This is a little bit of a hack.  If poll_only=1 on command
 	// line back in ip2.c OR all IRQs on all specified boards are
 	// explicitly set to 0, then drop to poll only mode and override
@@ -529,9 +590,7 @@ ip2_loadmain(int *iop, int *irqp)
 	// to -1, is to use 0 as a hard coded, do not probe.
 	//
 	//	/\/\|=mhw=|\/\/
-				poll_only |= irqp[i];
-			}
-		}
+		poll_only |= irq[i];
 	}
 	poll_only = !poll_only;
 
@@ -781,6 +840,7 @@ out_chrdev:
 out:
 	return err;
 }
+module_init(ip2_loadmain);
 
 /******************************************************************************/
 /* Function:   ip2_init_board()                                               */
-- 
1.5.5.1

