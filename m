Return-Path: <linux-kernel-owner+w=401wt.eu-S1757377AbYDHPCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377AbYDHPCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 11:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbYDHPCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 11:02:41 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:22067 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbYDHPCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 11:02:40 -0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Subject: [PATCH 10/12] proc: switch /proc/ip2mem to seq_file interface
Date: Tue, 8 Apr 2008 19:01:35 +0400
User-Agent: KMail/1.9.9
Cc: den@openvz.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804081901.36301.adobriyan@sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/******************************************/
/* Remove useless comment, while I am it. */
/******************************************/

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 drivers/char/ip2/ip2main.c |   53 +++++++++++++++++++++------------------------
 1 file changed, 25 insertions(+), 28 deletions(-)

--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -133,8 +133,9 @@
  *****************/
 
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 
-static int ip2_read_procmem(char *, char **, off_t, int);
+static const struct file_operations ip2mem_proc_fops;
 static int ip2_read_proc(char *, char **, off_t, int, int *, void * );
 
 /********************/
@@ -697,7 +698,7 @@ ip2_loadmain(int *iop, int *irqp, unsigned char *firmware, int firmsize)
 		}
 	}
 	/* Register the read_procmem thing */
-	if (!create_proc_info_entry("ip2mem",0,NULL,ip2_read_procmem)) {
+	if (!proc_create("ip2mem",0,NULL,&ip2mem_proc_fops)) {
 		printk(KERN_ERR "IP2: failed to register read_procmem\n");
 	} else {
 
@@ -2969,65 +2970,61 @@ ip2_ipl_open( struct inode *pInode, struct file *pFile )
 	}
 	return 0;
 }
-/******************************************************************************/
-/* Function:   ip2_read_procmem                                               */
-/* Parameters:                                                                */
-/*                                                                            */
-/* Returns: Length of output                                                  */
-/*                                                                            */
-/* Description:                                                               */
-/*   Supplies some driver operating parameters                                */
-/*	Not real useful unless your debugging the fifo							  */
-/*                                                                            */
-/******************************************************************************/
-
-#define LIMIT  (PAGE_SIZE - 120)
 
 static int
-ip2_read_procmem(char *buf, char **start, off_t offset, int len)
+proc_ip2mem_show(struct seq_file *m, void *v)
 {
 	i2eBordStrPtr  pB;
 	i2ChanStrPtr  pCh;
 	PTTY tty;
 	int i;
 
-	len = 0;
-
 #define FMTLINE	"%3d: 0x%08x 0x%08x 0%011o 0%011o\n"
 #define FMTLIN2	"     0x%04x 0x%04x tx flow 0x%x\n"
 #define FMTLIN3	"     0x%04x 0x%04x rc flow\n"
 
-	len += sprintf(buf+len,"\n");
+	seq_printf(m,"\n");
 
 	for( i = 0; i < IP2_MAX_BOARDS; ++i ) {
 		pB = i2BoardPtrTable[i];
 		if ( pB ) {
-			len += sprintf(buf+len,"board %d:\n",i);
-			len += sprintf(buf+len,"\tFifo rem: %d mty: %x outM %x\n",
+			seq_printf(m,"board %d:\n",i);
+			seq_printf(m,"\tFifo rem: %d mty: %x outM %x\n",
 				pB->i2eFifoRemains,pB->i2eWaitingForEmptyFifo,pB->i2eOutMailWaiting);
 		}
 	}
 
-	len += sprintf(buf+len,"#: tty flags, port flags,     cflags,     iflags\n");
+	seq_printf(m,"#: tty flags, port flags,     cflags,     iflags\n");
 	for (i=0; i < IP2_MAX_PORTS; i++) {
-		if (len > LIMIT)
-			break;
 		pCh = DevTable[i];
 		if (pCh) {
 			tty = pCh->pTTY;
 			if (tty && tty->count) {
-				len += sprintf(buf+len,FMTLINE,i,(int)tty->flags,pCh->flags,
+				seq_printf(m,FMTLINE,i,(int)tty->flags,pCh->flags,
 									tty->termios->c_cflag,tty->termios->c_iflag);
 
-				len += sprintf(buf+len,FMTLIN2,
+				seq_printf(m,FMTLIN2,
 						pCh->outfl.asof,pCh->outfl.room,pCh->channelNeeds);
-				len += sprintf(buf+len,FMTLIN3,pCh->infl.asof,pCh->infl.room);
+				seq_printf(m,FMTLIN3,pCh->infl.asof,pCh->infl.room);
 			}
 		}
 	}
-	return len;
+	return 0;
+}
+
+static int proc_ip2mem_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, proc_ip2mem_show, NULL);
 }
 
+static const struct file_operations ip2mem_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= proc_ip2mem_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /*
  * This is the handler for /proc/tty/driver/ip2
  *
-- 
1.5.4.3

