Return-Path: <linux-kernel-owner+w=401wt.eu-S935870AbYBVOCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935870AbYBVOCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 09:02:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764716AbYBVOAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 09:00:55 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:36418 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765962AbYBVOAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 09:00:52 -0500
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Rodolfo Giometti <giometti@linux.it>
Date: Fri, 22 Feb 2008 15:03:32 +0100
Message-Id: <12036890142501-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <12036890142414-git-send-email-giometti@linux.it>
References: <12036890132090-git-send-email-giometti@linux.it>
 <1203689013811-git-send-email-giometti@linux.it>
 <12036890131940-git-send-email-giometti@linux.it>
 <12036890133944-git-send-email-giometti@linux.it>
 <12036890141964-git-send-email-giometti@linux.it>
 <12036890142414-git-send-email-giometti@linux.it>
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH] PPS: example program to enable PPS support on serial ports.
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
1.5.2.5

