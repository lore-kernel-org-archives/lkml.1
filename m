Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbYJEQTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbYJEQTw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755824AbYJEQP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:15:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49618 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756983AbYJEQP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:15:27 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 42/76] tty: the vhangup syscall is racy
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:15:27 +0100
Message-ID: <20081005161501.1997.99059.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We now have the infrastructure to sort this out but rather than teaching
the syscall tty lock rules we move the hard work into a tty helper

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/tty_io.c |   19 +++++++++++++++++++
 fs/open.c             |    3 +--
 2 files changed, 20 insertions(+), 2 deletions(-)

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

