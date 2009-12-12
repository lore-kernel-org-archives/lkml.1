Return-Path: <linux-kernel-owner+w=401wt.eu-S1762868AbZLLARO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762868AbZLLARO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 19:17:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762564AbZLLARJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 19:17:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:36743 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761538AbZLLARI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 19:17:08 -0500
Date: Sat, 12 Dec 2009 00:16:24 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       wim@iguana.be, arjan@infradead.org, fweisbec@gmail.com,
       akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: arjan@infradead.org, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       akpm@linux-foundation.org, wim@iguana.be, tglx@linutronix.de
In-Reply-To: <tip-*@git.kernel.org>
References: <tip-*@git.kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] nvram: Fix write beyond end condition; prove to gcc copy is safe
Message-ID: <tip-a01c7800420d2c294ca403988488a635d4087a6d@git.kernel.org>
Git-Commit-ID: a01c7800420d2c294ca403988488a635d4087a6d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a01c7800420d2c294ca403988488a635d4087a6d
Gitweb:     http://git.kernel.org/tip/a01c7800420d2c294ca403988488a635d4087a6d
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Fri, 11 Dec 2009 15:48:23 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 11 Dec 2009 15:48:23 -0800

nvram: Fix write beyond end condition; prove to gcc copy is safe

In nvram_write, first of all, correctly handle the case where the file
pointer is already beyond the end; we should return EOF in that case.

Second, make the logic a bit more explicit so that gcc can statically
prove that the copy_from_user() is safe.  Once the condition of the
beyond-end filepointer is eliminated, the copy is safe but gcc can't
prove it, causing build failures for i386 allyesconfig.

Third, eliminate the entirely superfluous variable "len", and just use
the passed-in variable "count" instead.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <tip-*@git.kernel.org>
---
 drivers/char/nvram.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/char/nvram.c b/drivers/char/nvram.c
index 4008e2c..fdbcc9f 100644
--- a/drivers/char/nvram.c
+++ b/drivers/char/nvram.c
@@ -264,10 +264,16 @@ static ssize_t nvram_write(struct file *file, const char __user *buf,
 	unsigned char contents[NVRAM_BYTES];
 	unsigned i = *ppos;
 	unsigned char *tmp;
-	int len;
 
-	len = (NVRAM_BYTES - i) < count ? (NVRAM_BYTES - i) : count;
-	if (copy_from_user(contents, buf, len))
+	if (i >= NVRAM_BYTES)
+		return 0;	/* Past EOF */
+
+	if (count > NVRAM_BYTES - i)
+		count = NVRAM_BYTES - i;
+	if (count > NVRAM_BYTES)
+		return -EFAULT;	/* Can't happen, but prove it to gcc */
+
+	if (copy_from_user(contents, buf, count))
 		return -EFAULT;
 
 	spin_lock_irq(&rtc_lock);
@@ -275,7 +281,7 @@ static ssize_t nvram_write(struct file *file, const char __user *buf,
 	if (!__nvram_check_checksum())
 		goto checksum_err;
 
-	for (tmp = contents; count-- > 0 && i < NVRAM_BYTES; ++i, ++tmp)
+	for (tmp = contents; count--; ++i, ++tmp)
 		__nvram_write_byte(*tmp, i);
 
 	__nvram_set_checksum();
