Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbZGRA5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbZGRA5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 20:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbZGRA5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 20:57:33 -0400
Received: from bu3sch.de ([62.75.166.246]:58782 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbZGRA5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 20:57:32 -0400
From: Michael Buesch <mb@bu3sch.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] nvram: Fix root triggerable integer overflow crash
Date: Sat, 18 Jul 2009 02:56:45 +0200
User-Agent: KMail/1.9.9
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907180256.45934.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch fixes a root triggerable integer overflow based kernel crash.

The nvram_write() file operation subtracts the loff_t file offset from NVRAM_BYTES
without checks. This might result in an overflow of the integer. That value
is used for bounds checking of the "count", which is the buffer size to be copied
from userspace to the kernel stack.
So root can render the "count" check useless by overflowing the loff_t offset (which is "i").
copy_from_user() will then copy arbitrary amounts of memory to the kernel stack.


The userspace program to crash the kernel is as follows:
(Be careful when running the testcase. It might trash your NVRAM)

#include <unistd.h>
#include <fcntl.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>


#define NVRAM_BYTES	128

int main(void)
{
	ssize_t res;
	int fd;
	char *buf;
	unsigned int bufsize;

	fd = open("/dev/nvram", O_RDWR);
	if (fd < 0) {
		printf("Could not open nvram device\n");
		return 1;
	}
	bufsize = NVRAM_BYTES + 100;
	buf = malloc(bufsize);
	if (!buf) {
		printf("Out of memory\n");
		return 1;
	}
	memset(buf, 0, bufsize);
	res = pwrite(fd, buf, bufsize, NVRAM_BYTES + 1);
	if (res == bufsize)
		printf("NVRAM write succeed\n");
	else
		printf("NVRAM write failed\n");
}


Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

This bug probably is exploitable by overwriting the function return address or something
like that. But let's hope there's no distribution out there with user write permissions
on the /dev/nvram node. So it's probably only exploitable by root.
Comments on the exploitability are welcome. :)


Index: linux-2.6.30/drivers/char/nvram.c
===================================================================
--- linux-2.6.30.orig/drivers/char/nvram.c	2009-07-18 01:29:50.000000000 +0200
+++ linux-2.6.30/drivers/char/nvram.c	2009-07-18 02:47:35.000000000 +0200
@@ -267,6 +267,8 @@
 	unsigned char *tmp;
 	int len;
 
+	if (i >= NVRAM_BYTES)
+		return -EINVAL;
 	len = (NVRAM_BYTES - i) < count ? (NVRAM_BYTES - i) : count;
 	if (copy_from_user(contents, buf, len))
 		return -EFAULT;

-- 
Greetings, Michael.
