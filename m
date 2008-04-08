Return-Path: <linux-kernel-owner+w=401wt.eu-S1757628AbYDHO7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628AbYDHO7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 10:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbYDHO7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 10:59:14 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:32498 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793AbYDHO7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 10:59:11 -0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Subject: [PATCH 10/12] proc: switch /proc/irda/irnet to seq_file interface
Date: Tue, 8 Apr 2008 18:58:35 +0400
User-Agent: KMail/1.9.9
Cc: devel@openvz.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804081858.36132.adobriyan@sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Probably interface misuse, because of the way iterating over hashbin is done.
However! Printing of socket number ("IrNET socket %d - ", i++") made conversion
to proper ->start/->next difficult enough to do blindly without hardware.
Said that, please apply.

Remove useless comment while I am it.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 net/irda/irnet/irnet_irda.c |   65 +++++++++++++++++++++++---------------------
 net/irda/irnet/irnet_irda.h |    8 -----
 2 files changed, 34 insertions(+), 39 deletions(-)

--- a/net/irda/irnet/irnet_irda.c
+++ b/net/irda/irnet/irnet_irda.c
@@ -9,6 +9,7 @@
  */
 
 #include "irnet_irda.h"		/* Private header */
+#include <linux/seq_file.h>
 
 /*
  * PPP disconnect work: we need to make sure we're in
@@ -1717,34 +1718,23 @@ irnet_expiry_indication(discinfo_t *	expiry,
  */
 
 #ifdef CONFIG_PROC_FS
-/*------------------------------------------------------------------*/
-/*
- * Function irnet_proc_read (buf, start, offset, len, unused)
- *
- *    Give some info to the /proc file system
- */
 static int
-irnet_proc_read(char *	buf,
-		char **	start,
-		off_t	offset,
-		int	len)
+irnet_proc_show(struct seq_file *m, void *v)
 {
   irnet_socket *	self;
   char *		state;
   int			i = 0;
 
-  len = 0;
-
   /* Get the IrNET server information... */
-  len += sprintf(buf+len, "IrNET server - ");
-  len += sprintf(buf+len, "IrDA state: %s, ",
+  seq_printf(m, "IrNET server - ");
+  seq_printf(m, "IrDA state: %s, ",
 		 (irnet_server.running ? "running" : "dead"));
-  len += sprintf(buf+len, "stsap_sel: %02x, ", irnet_server.s.stsap_sel);
-  len += sprintf(buf+len, "dtsap_sel: %02x\n", irnet_server.s.dtsap_sel);
+  seq_printf(m, "stsap_sel: %02x, ", irnet_server.s.stsap_sel);
+  seq_printf(m, "dtsap_sel: %02x\n", irnet_server.s.dtsap_sel);
 
   /* Do we need to continue ? */
   if(!irnet_server.running)
-    return len;
+    return 0;
 
   /* Protect access to the instance list */
   spin_lock_bh(&irnet_server.spinlock);
@@ -1754,23 +1744,23 @@ irnet_proc_read(char *	buf,
   while(self != NULL)
     {
       /* Start printing info about the socket. */
-      len += sprintf(buf+len, "\nIrNET socket %d - ", i++);
+      seq_printf(m, "\nIrNET socket %d - ", i++);
 
       /* First, get the requested configuration */
-      len += sprintf(buf+len, "Requested IrDA name: \"%s\", ", self->rname);
-      len += sprintf(buf+len, "daddr: %08x, ", self->rdaddr);
-      len += sprintf(buf+len, "saddr: %08x\n", self->rsaddr);
+      seq_printf(m, "Requested IrDA name: \"%s\", ", self->rname);
+      seq_printf(m, "daddr: %08x, ", self->rdaddr);
+      seq_printf(m, "saddr: %08x\n", self->rsaddr);
 
       /* Second, get all the PPP info */
-      len += sprintf(buf+len, "	PPP state: %s",
+      seq_printf(m, "	PPP state: %s",
 		 (self->ppp_open ? "registered" : "unregistered"));
       if(self->ppp_open)
 	{
-	  len += sprintf(buf+len, ", unit: ppp%d",
+	  seq_printf(m, ", unit: ppp%d",
 			 ppp_unit_number(&self->chan));
-	  len += sprintf(buf+len, ", channel: %d",
+	  seq_printf(m, ", channel: %d",
 			 ppp_channel_index(&self->chan));
-	  len += sprintf(buf+len, ", mru: %d",
+	  seq_printf(m, ", mru: %d",
 			 self->mru);
 	  /* Maybe add self->flags ? Later... */
 	}
@@ -1789,10 +1779,10 @@ irnet_proc_read(char *	buf,
 	      state = "weird";
 	    else
 	      state = "idle";
-      len += sprintf(buf+len, "\n	IrDA state: %s, ", state);
-      len += sprintf(buf+len, "daddr: %08x, ", self->daddr);
-      len += sprintf(buf+len, "stsap_sel: %02x, ", self->stsap_sel);
-      len += sprintf(buf+len, "dtsap_sel: %02x\n", self->dtsap_sel);
+      seq_printf(m, "\n	IrDA state: %s, ", state);
+      seq_printf(m, "daddr: %08x, ", self->daddr);
+      seq_printf(m, "stsap_sel: %02x, ", self->stsap_sel);
+      seq_printf(m, "dtsap_sel: %02x\n", self->dtsap_sel);
 
       /* Next socket, please... */
       self = (irnet_socket *) hashbin_get_next(irnet_server.list);
@@ -1801,8 +1791,21 @@ irnet_proc_read(char *	buf,
   /* Spin lock end */
   spin_unlock_bh(&irnet_server.spinlock);
 
-  return len;
+  return 0;
 }
+
+static int irnet_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, irnet_proc_show, NULL);
+}
+
+static const struct file_operations irnet_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= irnet_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 #endif /* PROC_FS */
 
 
@@ -1841,7 +1844,7 @@ irda_irnet_init(void)
 
 #ifdef CONFIG_PROC_FS
   /* Add a /proc file for irnet infos */
-  create_proc_info_entry("irnet", 0, proc_irda, irnet_proc_read);
+  proc_create("irnet", 0, proc_irda, &irnet_proc_fops);
 #endif /* CONFIG_PROC_FS */
 
   /* Setup the IrNET server */
--- a/net/irda/irnet/irnet_irda.h
+++ b/net/irda/irnet/irnet_irda.h
@@ -159,14 +159,6 @@ static void
 				DISCOVERY_MODE,
 				void *);
 #endif
-/* -------------------------- PROC ENTRY -------------------------- */
-#ifdef CONFIG_PROC_FS
-static int
-	irnet_proc_read(char *,
-			char **,
-			off_t,
-			int);
-#endif /* CONFIG_PROC_FS */
 
 /**************************** VARIABLES ****************************/
 
-- 
1.5.4.3

