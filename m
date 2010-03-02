Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab0CBXuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:50:15 -0500
Received: from kroah.org ([198.145.64.141]:51606 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754361Ab0CBXg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:36:58 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Rakib Mullick <rakib.mullick@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 17/36] ip2: Add module parameter.
Date: Tue,  2 Mar 2010 15:36:24 -0800
Message-Id: <1267573003-782-17-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230956.GC32287@kroah.com>
References: <20100302230956.GC32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rakib Mullick <rakib.mullick@gmail.com>

Stephen Rothwell found the following warning (x86_64 allmodconfig):

drivers/char/ip2/ip2main.c:511: warning: 'ip2_setup' defined but not used

This patch adds module parameter to fix the above warning.


Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/ip2/ip2main.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index 2913d05..c2c915a 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -208,6 +208,7 @@ static int DumpFifoBuffer( char __user *, int);
 
 static void ip2_init_board(int, const struct firmware *);
 static unsigned short find_eisa_board(int);
+static int ip2_setup(char *str);
 
 /***************/
 /* Static Data */
@@ -285,7 +286,10 @@ MODULE_AUTHOR("Doug McNash");
 MODULE_DESCRIPTION("Computone IntelliPort Plus Driver");
 MODULE_LICENSE("GPL");
 
+#define	MAX_CMD_STR	50
+
 static int poll_only;
+static char cmd[MAX_CMD_STR];
 
 static int Eisa_irq;
 static int Eisa_slot;
@@ -309,6 +313,8 @@ module_param_array(io, int, NULL, 0);
 MODULE_PARM_DESC(io, "I/O ports for IntelliPort Cards");
 module_param(poll_only, bool, 0);
 MODULE_PARM_DESC(poll_only, "Do not use card interrupts");
+module_param_string(ip2, cmd, MAX_CMD_STR, 0);
+MODULE_PARM_DESC(ip2, "Contains module parameter passed with 'ip2='");
 
 /* for sysfs class support */
 static struct class *ip2_class;
@@ -538,12 +544,19 @@ static int __init ip2_loadmain(void)
 	i2eBordStrPtr pB = NULL;
 	int rc = -1;
 	const struct firmware *fw = NULL;
+	char *str;
+
+	str = cmd;
 
 	if (poll_only) {
 		/* Hard lock the interrupts to zero */
 		irq[0] = irq[1] = irq[2] = irq[3] = poll_only = 0;
 	}
 
+	/* Check module parameter with 'ip2=' has been passed or not */
+	if (!poll_only && (!strncmp(str, "ip2=", 4)))
+		ip2_setup(str);
+
 	ip2trace(ITRC_NO_PORT, ITRC_INIT, ITRC_ENTER, 0);
 
 	/* process command line arguments to modprobe or
-- 
1.7.0.1

