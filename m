Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbZGUKRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbZGUKRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634AbZGUKRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:17:07 -0400
Received: from bu3sch.de ([62.75.166.246]:56875 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754569AbZGUKRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:17:06 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [PATCH] thinkpad-acpi: Avoid heap buffer overrun
Date: Tue, 21 Jul 2009 12:16:17 +0200
User-Agent: KMail/1.9.9
Cc: ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907211216.18135.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid a heap buffer overrun triggered by an integer overflow of the userspace
controlled "count" variable.
If userspace passes in a "count" of (size_t)-1l, the kmalloc size will overflow
to ((size_t)-1l + 2) = 1, so only one byte will be allocated. However, copy_from_user()
will attempt to copy 0xFFFFFFFF (or 0xFFFFFFFFFFFFFFFF on 64bit) bytes to the buffer.

A possible testcase could look like this:

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>

int main(int argc, char **argv)
{
	int fd;
	char c;

	if (argc != 2) {
		printf("Usage: %s /proc/acpi/ibm/filename\n", argv[0]);
		return 1;
	}
	fd = open(argv[1], O_RDWR);
	if (fd < 0) {
		printf("Could not open proc file\n");
		return 1;
	}
	write(fd, &c, (size_t)-1l);
}

We avoid the integer overrun by putting an arbitrary limit on the count.
PAGE_SIZE sounds like a sane limit.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

This patch is completely untested due to lack of supported device.
The proc file is only writeable by root, so it's probably not exploitable as-is.

---
 drivers/platform/x86/thinkpad_acpi.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.orig/drivers/platform/x86/thinkpad_acpi.c
+++ linux-2.6/drivers/platform/x86/thinkpad_acpi.c
@@ -777,20 +777,22 @@ static int dispatch_procfs_read(char *pa
 static int dispatch_procfs_write(struct file *file,
 			const char __user *userbuf,
 			unsigned long count, void *data)
 {
 	struct ibm_struct *ibm = data;
 	char *kernbuf;
 	int ret;
 
 	if (!ibm || !ibm->write)
 		return -EINVAL;
+	if (count > PAGE_SIZE - 2)
+		return -EINVAL;
 
 	kernbuf = kmalloc(count + 2, GFP_KERNEL);
 	if (!kernbuf)
 		return -ENOMEM;
 
 	if (copy_from_user(kernbuf, userbuf, count)) {
 		kfree(kernbuf);
 		return -EFAULT;
 	}
 
 

-- 
Greetings, Michael.
