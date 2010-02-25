Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab0BYMls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 07:41:48 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:59963 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932371Ab0BYMlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 07:41:37 -0500
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Alexander Gordeev <lasaine@lvk.cs.msu.su>,
       Rodolfo Giometti <giometti@linux.it>
Date: Thu, 25 Feb 2010 13:41:08 +0100
Message-Id: <1267101671-23575-4-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267101671-23575-3-git-send-email-giometti@linux.it>
References: <1267101671-23575-1-git-send-email-giometti@linux.it>
 <1267101671-23575-2-git-send-email-giometti@linux.it>
 <1267101671-23575-3-git-send-email-giometti@linux.it>
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH 3/6] ldisc n_tty: add new method n_tty_inherit_ops()
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This new method can be used to init a new struct tty_ldisc_ops as the
default tty_ldisc_N_TTY struct.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 drivers/char/n_tty.c |   17 +++++++++++++++++
 include/linux/tty.h  |    1 +
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
index 2e50f4d..bdae832 100644
--- a/drivers/char/n_tty.c
+++ b/drivers/char/n_tty.c
@@ -48,6 +48,7 @@
 #include <linux/audit.h>
 #include <linux/file.h>
 #include <linux/uaccess.h>
+#include <linux/module.h>
 
 #include <asm/system.h>
 
@@ -2091,3 +2092,19 @@ struct tty_ldisc_ops tty_ldisc_N_TTY = {
 	.receive_buf     = n_tty_receive_buf,
 	.write_wakeup    = n_tty_write_wakeup
 };
+
+/**
+ *	n_tty_inherit_ops	-	inherit N_TTY methods
+ *	@ops: struct tty_ldisc_ops where to save N_TTY methods
+ *
+ *	Used by a generic struct tty_ldisc_ops to easily inherit N_TTY
+ *	methods.
+ */
+
+void n_tty_inherit_ops(struct tty_ldisc_ops *ops)
+{
+	*ops = tty_ldisc_N_TTY;
+	ops->owner = NULL;
+	ops->refcount = ops->flags = 0;
+}
+EXPORT_SYMBOL_GPL(n_tty_inherit_ops);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 6abfcf5..d6cc652 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -504,6 +504,7 @@ extern void tty_ldisc_enable(struct tty_struct *tty);
 
 /* n_tty.c */
 extern struct tty_ldisc_ops tty_ldisc_N_TTY;
+extern void n_tty_inherit_ops(struct tty_ldisc_ops *ops);
 
 /* tty_audit.c */
 #ifdef CONFIG_AUDIT
-- 
1.6.3.3

