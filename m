Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbZGTWLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbZGTWLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 18:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbZGTWLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 18:11:19 -0400
Received: from bu3sch.de ([62.75.166.246]:42119 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753865AbZGTWLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 18:11:18 -0400
From: Michael Buesch <mb@bu3sch.de>
To: steiner@sgi.com
Subject: [PATCH] sgi-gru: Fix kernel stack buffer overrun
Date: Tue, 21 Jul 2009 00:08:38 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907210008.38990.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a kernel stack buffer overrun in the sgi-gru procfs
interface implementation.
The "count" parameter to options_write() is user controlled. So this bug
can be used to write '\0' bytes to almost arbitrary places on the kernel stack.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: stable@kernel.org

---

This procfs file has 0644 permissions, so the bug is probably not exploitable
for local privilege escalation.

---
 drivers/misc/sgi-gru/gruprocfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/drivers/misc/sgi-gru/gruprocfs.c
+++ linux-2.6/drivers/misc/sgi-gru/gruprocfs.c
@@ -157,23 +157,23 @@ static int options_show(struct seq_file 
 	seq_printf(s, "0x%lx\n", gru_options);
 	return 0;
 }
 
 static ssize_t options_write(struct file *file, const char __user *userbuf,
 			     size_t count, loff_t *data)
 {
 	unsigned long val;
 	char buf[80];
 
+	memset(buf, 0, sizeof(buf));
 	if (strncpy_from_user(buf, userbuf, sizeof(buf) - 1) < 0)
 		return -EFAULT;
-	buf[count - 1] = '\0';
 	if (!strict_strtoul(buf, 10, &val))
 		gru_options = val;
 
 	return count;
 }
 
 static int cch_seq_show(struct seq_file *file, void *data)
 {
 	long gid = *(long *)data;
 	int i;

-- 
Greetings, Michael.
