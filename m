Return-Path: <linux-kernel-owner+w=401wt.eu-S1756837AbYDHO4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbYDHO4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 10:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbYDHO4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 10:56:12 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:24530 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756500AbYDHO4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 10:56:10 -0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Subject: [PATCH 05/12] proc: remove /proc/mac_iop
Date: Tue, 8 Apr 2008 18:55:33 +0400
User-Agent: KMail/1.9.9
Cc: devel@openvz.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804081855.34300.adobriyan@sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Entry creation was commented for a long time and right now it stands on
the way of ->get_info removal, so unless nobody objects...

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 arch/m68k/mac/iop.c |   85 ----------------------------------------------------
 1 file changed, 85 deletions(-)

--- a/arch/m68k/mac/iop.c
+++ b/arch/m68k/mac/iop.c
@@ -109,7 +109,6 @@
 #include <linux/mm.h>
 #include <linux/delay.h>
 #include <linux/init.h>
-#include <linux/proc_fs.h>
 #include <linux/interrupt.h>
 
 #include <asm/bootinfo.h>
@@ -124,10 +123,6 @@
 
 int iop_scc_present,iop_ism_present;
 
-#ifdef CONFIG_PROC_FS
-static int iop_get_proc_info(char *, char **, off_t, int);
-#endif /* CONFIG_PROC_FS */
-
 /* structure for tracking channel listeners */
 
 struct listener {
@@ -299,12 +294,6 @@ void __init iop_init(void)
 		iop_listeners[IOP_NUM_ISM][i].devname = NULL;
 		iop_listeners[IOP_NUM_ISM][i].handler = NULL;
 	}
-
-#if 0	/* Crashing in 2.4 now, not yet sure why.   --jmt */
-#ifdef CONFIG_PROC_FS
-	create_proc_info_entry("mac_iop", 0, NULL, iop_get_proc_info);
-#endif
-#endif
 }
 
 /*
@@ -637,77 +626,3 @@ irqreturn_t iop_ism_irq(int irq, void *dev_id)
 	}
 	return IRQ_HANDLED;
 }
-
-#ifdef CONFIG_PROC_FS
-
-char *iop_chan_state(int state)
-{
-	switch(state) {
-		case IOP_MSG_IDLE	: return "idle      ";
-		case IOP_MSG_NEW	: return "new       ";
-		case IOP_MSG_RCVD	: return "received  ";
-		case IOP_MSG_COMPLETE	: return "completed ";
-		default			: return "unknown   ";
-	}
-}
-
-int iop_dump_one_iop(char *buf, int iop_num, char *iop_name)
-{
-	int i,len = 0;
-	volatile struct mac_iop *iop = iop_base[iop_num];
-
-	len += sprintf(buf+len, "%s IOP channel states:\n\n", iop_name);
-	len += sprintf(buf+len, "##  send_state  recv_state  device\n");
-	len += sprintf(buf+len, "------------------------------------------------\n");
-	for (i = 0 ; i < NUM_IOP_CHAN ; i++) {
-		len += sprintf(buf+len, "%2d  %10s  %10s  %s\n", i,
-			iop_chan_state(iop_readb(iop, IOP_ADDR_SEND_STATE+i)),
-			iop_chan_state(iop_readb(iop, IOP_ADDR_RECV_STATE+i)),
-			iop_listeners[iop_num][i].handler?
-				      iop_listeners[iop_num][i].devname : "");
-
-	}
-	len += sprintf(buf+len, "\n");
-	return len;
-}
-
-static int iop_get_proc_info(char *buf, char **start, off_t pos, int count)
-{
-	int len, cnt;
-
-	cnt = 0;
-	len =  sprintf(buf, "IOPs detected:\n\n");
-
-	if (iop_scc_present) {
-		len += sprintf(buf+len, "SCC IOP (%p): status %02X\n",
-				iop_base[IOP_NUM_SCC],
-				(uint) iop_base[IOP_NUM_SCC]->status_ctrl);
-	}
-	if (iop_ism_present) {
-		len += sprintf(buf+len, "ISM IOP (%p): status %02X\n\n",
-				iop_base[IOP_NUM_ISM],
-				(uint) iop_base[IOP_NUM_ISM]->status_ctrl);
-	}
-
-	if (iop_scc_present) {
-		len += iop_dump_one_iop(buf+len, IOP_NUM_SCC, "SCC");
-
-	}
-
-	if (iop_ism_present) {
-		len += iop_dump_one_iop(buf+len, IOP_NUM_ISM, "ISM");
-
-	}
-
-	if (len >= pos) {
-		if (!*start) {
-			*start = buf + pos;
-			cnt = len - pos;
-		} else {
-			cnt += len;
-		}
-	}
-	return (count > cnt) ? cnt : count;
-}
-
-#endif /* CONFIG_PROC_FS */
-- 
1.5.4.3

