Return-Path: <linux-kernel-owner+w=401wt.eu-S1760055AbYDJPR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760055AbYDJPR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 11:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759221AbYDJPQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 11:16:22 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:40698 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759109AbYDJPQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 11:16:19 -0400
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Rodolfo Giometti <giometti@linux.it>
Date: Thu, 10 Apr 2008 17:15:59 +0200
Message-Id: <1207840560-24015-7-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1207840560-24015-6-git-send-email-giometti@linux.it>
References: <>
 <1207840560-24015-1-git-send-email-giometti@linux.it>
 <1207840560-24015-2-git-send-email-giometti@linux.it>
 <1207840560-24015-3-git-send-email-giometti@linux.it>
 <1207840560-24015-4-git-send-email-giometti@linux.it>
 <1207840560-24015-5-git-send-email-giometti@linux.it>
 <1207840560-24015-6-git-send-email-giometti@linux.it>
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH 6/7] PPS: example program to enable PPS support on serial ports.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 Documentation/pps/Makefile |    2 +-
 Documentation/pps/ppsctl.c |   62 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/pps/ppsctl.c

diff --git a/Documentation/pps/Makefile b/Documentation/pps/Makefile
index af4f9b4..8ef4f47 100644
--- a/Documentation/pps/Makefile
+++ b/Documentation/pps/Makefile
@@ -1,4 +1,4 @@
-TARGETS = ppstest
+TARGETS = ppstest ppsctl
 
 CFLAGS += -Wall -O2 -D_GNU_SOURCE
 CFLAGS += -I .
diff --git a/Documentation/pps/ppsctl.c b/Documentation/pps/ppsctl.c
new file mode 100644
index 0000000..83fd08a
--- /dev/null
+++ b/Documentation/pps/ppsctl.c
@@ -0,0 +1,62 @@
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <errno.h>
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <string.h>
+#include <linux/serial.h>
+
+void usage(char *name)
+{
+	fprintf(stderr, "usage: %s <ttyS> [enable|disable]\n", name);
+
+	exit(EXIT_FAILURE);
+}
+
+int main(int argc, char *argv[])
+{
+	int fd;
+	int ret;
+	struct serial_struct ss;
+
+	if (argc < 2)
+		usage(argv[0]);
+
+	fd = open(argv[1], O_RDWR);
+	if (fd < 0) {
+		perror("open");
+		exit(EXIT_FAILURE);
+	}
+
+	ret = ioctl(fd, TIOCGSERIAL, &ss);
+	if (ret < 0) {
+		perror("ioctl(TIOCGSERIAL)");
+		exit(EXIT_FAILURE);
+	}
+
+	if (argc < 3) {		/* just read PPS status */
+		printf("PPS is %sabled\n",
+		       ss.flags & ASYNC_HARDPPS_CD ? "en" : "dis");
+		exit(EXIT_SUCCESS);
+	}
+
+	if (argv[2][0] == 'e' || argv[2][0] == '1')
+		ss.flags |= ASYNC_HARDPPS_CD;
+	else if (argv[2][0] == 'd' || argv[2][0] == '0')
+		ss.flags &= ~ASYNC_HARDPPS_CD;
+	else {
+		fprintf(stderr, "invalid state argument \"%s\"\n", argv[2]);
+		exit(EXIT_FAILURE);
+	}
+
+	ret = ioctl(fd, TIOCSSERIAL, &ss);
+	if (ret < 0) {
+		perror("ioctl(TIOCSSERIAL)");
+		exit(EXIT_FAILURE);
+	}
+
+	return 0;
+}
-- 
1.5.4.3

