Return-Path: <linux-kernel-owner+w=401wt.eu-S932242AbYJMJvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242AbYJMJvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 05:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760876AbYJMJkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:40:35 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48688 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759540AbYJMJkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:40:33 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 48/80] tty: the vhangup syscall is racy
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Oct 2008 10:40:30 +0100
Message-ID: <20081013094024.21645.47677.stgit@localhost.localdomain>
In-Reply-To: <20081013092758.21645.2359.stgit@localhost.localdomain>
References: <20081013092758.21645.2359.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

We now have the infrastructure to sort this out but rather than teaching
the syscall tty lock rules we move the hard work into a tty helper

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/tty_io.c |   19 +++++++++++++++++++
 fs/open.c             |    3 +--
 include/linux/tty.h   |    1 +
 3 files changed, 21 insertions(+), 2 deletions(-)


diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 913b502..b5f57d0 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -730,6 +730,25 @@ void tty_vhangup(struct tty_struct *tty)
 EXPORT_SYMBOL(tty_vhangup);
 
 /**
+ *	tty_vhangup_self	-	process vhangup for own ctty
+ *
+ *	Perform a vhangup on the current controlling tty
+ */
+
+void tty_vhangup_self(void)
+{
+	struct tty_struct *tty;
+
+	mutex_lock(&tty_mutex);
+	tty = get_current_tty();
+	if (tty) {
+		tty_vhangup(tty);
+		tty_kref_put(tty);
+	}
+	mutex_unlock(&tty_mutex);
+}
+
+/**
  *	tty_hung_up_p		-	was tty hung up
  *	@filp: file pointer of tty
  *
diff --git a/fs/open.c b/fs/open.c
index 07da935..5596049 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1141,8 +1141,7 @@ EXPORT_SYMBOL(sys_close);
 asmlinkage long sys_vhangup(void)
 {
 	if (capable(CAP_SYS_TTY_CONFIG)) {
-		/* XXX: this needs locking */
-		tty_vhangup(current->signal->tty);
+		tty_vhangup_self();
 		return 0;
 	}
 	return -EPERM;
diff --git a/include/linux/tty.h b/include/linux/tty.h
index c30ed8d..e00393a 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -361,6 +361,7 @@ extern int is_ignored(int sig);
 extern int tty_signal(int sig, struct tty_struct *tty);
 extern void tty_hangup(struct tty_struct *tty);
 extern void tty_vhangup(struct tty_struct *tty);
+extern void tty_vhangup_self(void);
 extern void tty_unhangup(struct file *filp);
 extern int tty_hung_up_p(struct file *filp);
 extern void do_SAK(struct tty_struct *tty);

