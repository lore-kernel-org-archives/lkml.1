Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178Ab0CIG3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 01:29:40 -0500
Received: from mail.windriver.com ([147.11.1.11]:33646 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab0CIG3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 01:29:34 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>,
       Alan Cox <alan@linux.intel.com>
Subject: [PATCH 6/6] usb-serialy,sysrq: Run the sysrq handler in a tasklet
Date: Tue,  9 Mar 2010 00:29:11 -0600
Message-Id: <1268116151-1448-7-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1268116151-1448-6-git-send-email-jason.wessel@windriver.com>
References: <1268116151-1448-1-git-send-email-jason.wessel@windriver.com>
 <1268116151-1448-2-git-send-email-jason.wessel@windriver.com>
 <1268116151-1448-3-git-send-email-jason.wessel@windriver.com>
 <1268116151-1448-4-git-send-email-jason.wessel@windriver.com>
 <1268116151-1448-5-git-send-email-jason.wessel@windriver.com>
 <1268116151-1448-6-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 09 Mar 2010 06:29:29.0558 (UTC) FILETIME=[DF72CF60:01CABF51]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a sysrq is processed on the while holding the usb hcd lock, it is
impossible to drain the queue of urbs via the polling interface and
all the printk output is lost.

Using a tasklet to schedule the sysrq allows the hcd device lock to
free up, and you can issue a sysrq-t to get the task list.

CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Alan Cox <alan@linux.intel.com>
CC: Alan Stern <stern@rowland.harvard.edu>
CC: linux-usb@vger.kernel.org
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/char/sysrq.c       |   29 +++++++++++++++++++++++++++++
 include/linux/sysrq.h      |    4 ++++
 include/linux/usb/serial.h |    2 +-
 3 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
index 1ae2de7..ad62e53 100644
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -584,6 +584,35 @@ int unregister_sysrq_key(int key, struct sysrq_key_op *op_p)
 }
 EXPORT_SYMBOL(unregister_sysrq_key);
 
+/* The sysrq tasklet is used only in the rare case that an
+ * input/output character device processes a sysrq in its input
+ * routine while holding a lock required for the output routine for
+ * the console device.
+ */
+static struct sysrq_tasklet_data {
+	struct tty_struct *tty;
+	unsigned int key;
+	int pending;
+} priv_sysrq_data;
+
+static void sysrq_task(unsigned long args)
+{
+	handle_sysrq(priv_sysrq_data.key, priv_sysrq_data.tty);
+	priv_sysrq_data.pending = 0;
+}
+static DECLARE_TASKLET(sysrq_tasklet, sysrq_task, 0);
+
+void handle_sysrq_tasklet(int key, struct tty_struct *tty)
+{
+	if (priv_sysrq_data.pending)
+		return;
+	priv_sysrq_data.pending = 1;
+	priv_sysrq_data.key = key;
+	priv_sysrq_data.tty = tty;
+	tasklet_schedule(&sysrq_tasklet);
+}
+EXPORT_SYMBOL(handle_sysrq_tasklet);
+
 #ifdef CONFIG_PROC_FS
 /*
  * writing 'C' to /proc/sysrq-trigger is like sysrq-C
diff --git a/include/linux/sysrq.h b/include/linux/sysrq.h
index 99adcdc..0ff5fb4 100644
--- a/include/linux/sysrq.h
+++ b/include/linux/sysrq.h
@@ -52,6 +52,7 @@ extern int __sysrq_enabled;
  */
 
 void handle_sysrq(int key, struct tty_struct *tty);
+void handle_sysrq_tasklet(int key, struct tty_struct *tty);
 void __handle_sysrq(int key, struct tty_struct *tty, int check_mask);
 int register_sysrq_key(int key, struct sysrq_key_op *op);
 int unregister_sysrq_key(int key, struct sysrq_key_op *op);
@@ -70,6 +71,9 @@ static inline int __reterr(void)
 static inline void handle_sysrq(int key, struct tty_struct *tty)
 {
 }
+static inline void handle_sysrq_tasklet(int key, struct tty_struct *tty)
+{
+}
 
 #define register_sysrq_key(ig,nore) __reterr()
 #define unregister_sysrq_key(ig,nore) __reterr()
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index 60f8422..ae8887e 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -333,7 +333,7 @@ static inline int usb_serial_handle_sysrq_char(struct tty_struct *tty,
 #ifdef CONFIG_MAGIC_SYSRQ
 	if (port->sysrq && port->port.console) {
 		if (ch && time_before(jiffies, port->sysrq)) {
-			handle_sysrq(ch, tty);
+			handle_sysrq_tasklet(ch, tty);
 			port->sysrq = 0;
 			return 1;
 		}
-- 
1.6.3.1.9.g95405b

