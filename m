Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbZLBRTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbZLBRTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 12:19:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755253AbZLBRTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 12:19:14 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:42289 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236AbZLBRTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 12:19:10 -0500
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
       Rodolfo Giometti <giometti@linux.it>
Date: Wed,  2 Dec 2009 18:18:40 +0100
Message-Id: <1259774329-29663-3-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1259774329-29663-2-git-send-email-giometti@linux.it>
References: <1259774329-29663-1-git-send-email-giometti@linux.it>
 <1259774329-29663-2-git-send-email-giometti@linux.it>
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH 02/11] pps: documentation programs and examples.
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here some utilities and examples about the PPS API and the LinuxPPS
support.

* ppstest.c implements an useful testing program, while

* ppsfind tries to help the user into finding a specific PPS source by
  using its name or path.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 Documentation/pps/Makefile  |   27 ++++++++
 Documentation/pps/ppsfind   |   17 +++++
 Documentation/pps/ppstest.c |  150 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 194 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/pps/Makefile
 create mode 100644 Documentation/pps/ppsfind
 create mode 100644 Documentation/pps/ppstest.c

diff --git a/Documentation/pps/Makefile b/Documentation/pps/Makefile
new file mode 100644
index 0000000..3848aba
--- /dev/null
+++ b/Documentation/pps/Makefile
@@ -0,0 +1,27 @@
+TARGETS = ppstest
+
+CFLAGS += -Wall -O2 -D_GNU_SOURCE
+CFLAGS += -I . -I ../../include/
+CFLAGS += -ggdb
+
+# -- Actions section --
+
+.PHONY : all depend dep
+
+all : .depend $(TARGETS)
+
+.depend depend dep :
+	$(CC) $(CFLAGS) -M $(TARGETS:=.c) > .depend
+
+ifeq (.depend,$(wildcard .depend))
+include .depend
+endif
+
+
+# -- Clean section --
+
+.PHONY : clean
+
+clean :
+	rm -f *.o *~ core .depend
+	rm -f ${TARGETS}
diff --git a/Documentation/pps/ppsfind b/Documentation/pps/ppsfind
new file mode 100644
index 0000000..93c0e17
--- /dev/null
+++ b/Documentation/pps/ppsfind
@@ -0,0 +1,17 @@
+#!/bin/sh
+
+SYS="/sys/class/pps/"
+
+if [ $# -lt 1 ] ; then
+	echo "usage: ppsfind <name>" >&2
+	exit 1
+fi
+
+for d in $(ls $SYS) ; do
+	if grep $1 $SYS/$d/name >& /dev/null || \
+	   grep $1 $SYS/$d/path >& /dev/null ; then
+		echo "$d: name=$(cat $SYS/$d/name) path=$(cat $SYS/$d/path)"
+	fi
+done
+
+exit 0
diff --git a/Documentation/pps/ppstest.c b/Documentation/pps/ppstest.c
new file mode 100644
index 0000000..30c8f6d
--- /dev/null
+++ b/Documentation/pps/ppstest.c
@@ -0,0 +1,150 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+
+#include <timepps.h>
+
+int find_source(char *path, pps_handle_t *handle, int *avail_mode)
+{
+	pps_params_t params;
+	int ret;
+
+	printf("trying PPS source \"%s\"\n", path);
+
+	/* Try to find the source by using the supplied "path" name */
+	ret = open(path, O_RDWR);
+	if (ret < 0) {
+		fprintf(stderr, "unable to open device \"%s\" (%m)\n", path);
+		return ret;
+	}
+
+	/* Open the PPS source (and check the file descriptor) */
+	ret = time_pps_create(ret, handle);
+	if (ret < 0) {
+		fprintf(stderr, "cannot create a PPS source from device "
+				"\"%s\" (%m)\n", path);
+		return -1;
+	}
+	printf("found PPS source \"%s\"\n", path);
+
+	/* Find out what features are supported */
+	ret = time_pps_getcap(*handle, avail_mode);
+	if (ret < 0) {
+		fprintf(stderr, "cannot get capabilities (%m)\n");
+		return -1;
+	}
+	if ((*avail_mode & PPS_CAPTUREASSERT) == 0) {
+		fprintf(stderr, "cannot CAPTUREASSERT\n");
+		return -1;
+	}
+	if ((*avail_mode & PPS_OFFSETASSERT) == 0) {
+		fprintf(stderr, "cannot OFFSETASSERT\n");
+		return -1;
+	}
+
+	/* Capture assert timestamps, and compensate for a 675 nsec
+	 * propagation delay */
+	ret = time_pps_getparams(*handle, &params);
+	if (ret < 0) {
+		fprintf(stderr, "cannot get parameters (%m)\n");
+		return -1;
+	}
+	params.assert_offset.tv_sec = 0;
+	params.assert_offset.tv_nsec = 675;
+	params.mode |= PPS_CAPTUREASSERT | PPS_OFFSETASSERT;
+	params.mode &= ~(PPS_CAPTURECLEAR | PPS_OFFSETCLEAR);
+	ret = time_pps_setparams(*handle, &params);
+	if (ret < 0) {
+		fprintf(stderr, "cannot set parameters (%m)\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+int fetch_source(int i, pps_handle_t *handle, int *avail_mode)
+{
+	struct timespec timeout;
+	pps_info_t infobuf;
+	int ret;
+
+	/* create a zero-valued timeout */
+	timeout.tv_sec = 3;
+	timeout.tv_nsec = 0;
+
+retry:
+	if (*avail_mode & PPS_CANWAIT) /* waits for the next event */
+		ret = time_pps_fetch(*handle, PPS_TSFMT_TSPEC, &infobuf,
+				   &timeout);
+	else {
+		sleep(1);
+		ret = time_pps_fetch(*handle, PPS_TSFMT_TSPEC, &infobuf,
+				   &timeout);
+	}
+	if (ret < 0) {
+		if (ret == -EINTR) {
+			fprintf(stderr, "time_pps_fetch() got a signal!\n");
+			goto retry;
+		}
+
+		fprintf(stderr, "time_pps_fetch() error %d (%m)\n", ret);
+		return -1;
+	}
+
+	printf("source %d - "
+	       "assert %ld.%09ld, sequence: %ld - "
+	       "clear  %ld.%09ld, sequence: %ld\n",
+	       i,
+	       infobuf.assert_timestamp.tv_sec,
+	       infobuf.assert_timestamp.tv_nsec,
+	       infobuf.assert_sequence,
+	       infobuf.clear_timestamp.tv_sec,
+	       infobuf.clear_timestamp.tv_nsec, infobuf.clear_sequence);
+
+	return 0;
+}
+
+void usage(char *name)
+{
+	fprintf(stderr, "usage: %s <ppsdev> [<ppsdev> ...]\n", name);
+	exit(EXIT_FAILURE);
+}
+
+int main(int argc, char *argv[])
+{
+	int num;
+	pps_handle_t handle[4];
+	int avail_mode[4];
+	int i = 0;
+	int ret;
+
+	/* Check the command line */
+	if (argc < 2)
+		usage(argv[0]);
+
+	for (i = 1; i < argc && i <= 4; i++) {
+		ret = find_source(argv[i], &handle[i - 1], &avail_mode[i - 1]);
+		if (ret < 0)
+			exit(EXIT_FAILURE);
+	}
+
+	num = i - 1;
+	printf("ok, found %d source(s), now start fetching data...\n", num);
+
+	/* loop, printing the most recent timestamp every second or so */
+	while (1) {
+		for (i = 0; i < num; i++) {
+			ret = fetch_source(i, &handle[i], &avail_mode[i]);
+			if (ret < 0 && errno != ETIMEDOUT)
+				exit(EXIT_FAILURE);
+		}
+	}
+
+	for (; i >= 0; i--)
+		time_pps_destroy(handle[i]);
+
+	return 0;
+}
-- 
1.6.3.3

