Return-Path: <linux-kernel-owner+w=401wt.eu-S1761492AbYA2XqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761492AbYA2XqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 18:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbYA2Xp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 18:45:58 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:39112 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbYA2Xp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 18:45:57 -0500
Message-ID: <479FBA93.5080904@web.de>
Date: Wed, 30 Jan 2008 00:45:23 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 3/5] KGDB-8250: respect early parameters
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/nhfNq5hgK4fCeAv/fRFqbSBMkE3By7t3P24SY
	JDBMtoc5kS1y6ucsKiNhVkPx6wS/XFxyytAFLt8bg+JY12CajV
	O1l5Wl5HU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes sure that the config string passed via "kgdb8250="
takes precedence over any built-time configuration.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>

---
 drivers/serial/8250_kgdb.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

Index: b/drivers/serial/8250_kgdb.c
===================================================================
--- a/drivers/serial/8250_kgdb.c
+++ b/drivers/serial/8250_kgdb.c
@@ -39,7 +39,9 @@ module_param_string(kgdb8250, config, 25
 MODULE_PARM_DESC(kgdb8250,
 		 " kgdb8250=<io or mmio>,<address>,<baud rate>,<irq>\n");
 static struct kgdb_io local_kgdb_io_ops;
-#endif				/* CONFIG_KGDB_8250_MODULE */
+#else  /* !CONFIG_KGDB_8250_MODULE */
+static int params_evaluated;
+#endif /* !CONFIG_KGDB_8250_MODULE */

 /* Speed of the UART. */
 static int kgdb8250_baud;
@@ -320,16 +322,17 @@ static __init int kgdb_init_io(void)
 		       "kgdb8250=<line #>,<baud rate>\n");
 		return -EINVAL;
 	}
-#elif defined(CONFIG_KGDB_SIMPLE_SERIAL)
-	kgdb8250_baud = CONFIG_KGDB_BAUDRATE;
-
-	/* Setup our pointer to the serial port now. */
-	current_port = &kgdb8250_ports[CONFIG_KGDB_PORT_NUM];
-#else
-	if (kgdb8250_opt(CONFIG_KGDB_8250_CONF_STRING))
-		return -EINVAL;
-#endif
-
+#else  /* !CONFIG_KGDB_8250_MODULE */
+	if (!params_evaluated) {
+#ifdef CONFIG_KGDB_SIMPLE_SERIAL
+		kgdb8250_baud = CONFIG_KGDB_BAUDRATE;
+		current_port = &kgdb8250_ports[CONFIG_KGDB_PORT_NUM];
+#else /* !CONFIG_KGDB_SIMPLE_SERIAL */
+		if (kgdb8250_opt(CONFIG_KGDB_8250_CONF_STRING))
+			return -EINVAL;
+#endif /* !CONFIG_KGDB_SIMPLE_SERIAL */
+	}
+#endif /* !CONFIG_KGDB_8250_MODULE */

 	/* Internal driver setup. */
 	switch (current_port->iotype) {
@@ -512,7 +515,9 @@ finish:
 #ifdef CONFIG_KGDB_SIMPLE_SERIAL
 	should_copy_rs_table = 0;
 #endif
-
+#ifdef CONFIG_KGDB_8250
+	params_evaluated = 1;
+#endif
 	return 0;

 errout:
