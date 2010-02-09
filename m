Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab0BIA6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 19:58:05 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:52278 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab0BIA6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 19:58:01 -0500
Date: Mon, 8 Feb 2010 16:56:10 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH 2/4] docum/laptop: split txt and source files
Message-Id: <20100208165610.b445504e.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4B70B2E1.0084:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Documentation/laptops/laptop-mode.txt:
Expose example and tool source files in the Documentation/ directory in
their own files instead of being buried (almost hidden) in readme/txt files.
This should help to prevent bitrot.

This will make them more visible/usable to users who may need
to use them, to developers who may need to test with them, and
to anyone who would fix/update them if they were more visible.

Also, if any of these possibly should not be in the kernel tree at
all, it will be clearer that they are here and we can discuss if
they should be removed.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/Makefile                |    2 
 Documentation/laptops/00-INDEX        |    6 
 Documentation/laptops/Makefile        |    8 +
 Documentation/laptops/dslm.c          |  166 +++++++++++++++++++++++
 Documentation/laptops/laptop-mode.txt |  170 ------------------------
 5 files changed, 182 insertions(+), 170 deletions(-)

--- /dev/null
+++ lnx-2633-rc7/Documentation/laptops/dslm.c
@@ -0,0 +1,166 @@
+/*
+ * dslm.c
+ * Simple Disk Sleep Monitor
+ *  by Bartek Kania
+ * Licenced under the GPL
+ */
+#include <unistd.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <time.h>
+#include <string.h>
+#include <signal.h>
+#include <sys/ioctl.h>
+#include <linux/hdreg.h>
+
+#ifdef DEBUG
+#define D(x) x
+#else
+#define D(x)
+#endif
+
+int endit = 0;
+
+/* Check if the disk is in powersave-mode
+ * Most of the code is stolen from hdparm.
+ * 1 = active, 0 = standby/sleep, -1 = unknown */
+static int check_powermode(int fd)
+{
+    unsigned char args[4] = {WIN_CHECKPOWERMODE1,0,0,0};
+    int state;
+
+    if (ioctl(fd, HDIO_DRIVE_CMD, &args)
+	&& (args[0] = WIN_CHECKPOWERMODE2) /* try again with 0x98 */
+	&& ioctl(fd, HDIO_DRIVE_CMD, &args)) {
+	if (errno != EIO || args[0] != 0 || args[1] != 0) {
+	    state = -1; /* "unknown"; */
+	} else
+	    state = 0; /* "sleeping"; */
+    } else {
+	state = (args[2] == 255) ? 1 : 0;
+    }
+    D(printf(" drive state is:  %d\n", state));
+
+    return state;
+}
+
+static char *state_name(int i)
+{
+    if (i == -1) return "unknown";
+    if (i == 0) return "sleeping";
+    if (i == 1) return "active";
+
+    return "internal error";
+}
+
+static char *myctime(time_t time)
+{
+    char *ts = ctime(&time);
+    ts[strlen(ts) - 1] = 0;
+
+    return ts;
+}
+
+static void measure(int fd)
+{
+    time_t start_time;
+    int last_state;
+    time_t last_time;
+    int curr_state;
+    time_t curr_time = 0;
+    time_t time_diff;
+    time_t active_time = 0;
+    time_t sleep_time = 0;
+    time_t unknown_time = 0;
+    time_t total_time = 0;
+    int changes = 0;
+    float tmp;
+
+    printf("Starting measurements\n");
+
+    last_state = check_powermode(fd);
+    start_time = last_time = time(0);
+    printf("  System is in state %s\n\n", state_name(last_state));
+
+    while(!endit) {
+	sleep(1);
+	curr_state = check_powermode(fd);
+
+	if (curr_state != last_state || endit) {
+	    changes++;
+	    curr_time = time(0);
+	    time_diff = curr_time - last_time;
+
+	    if (last_state == 1) active_time += time_diff;
+	    else if (last_state == 0) sleep_time += time_diff;
+	    else unknown_time += time_diff;
+
+	    last_state = curr_state;
+	    last_time = curr_time;
+
+	    printf("%s: State-change to %s\n", myctime(curr_time),
+		   state_name(curr_state));
+	}
+    }
+    changes--; /* Compensate for SIGINT */
+
+    total_time = time(0) - start_time;
+    printf("\nTotal running time:  %lus\n", curr_time - start_time);
+    printf(" State changed %d times\n", changes);
+
+    tmp = (float)sleep_time / (float)total_time * 100;
+    printf(" Time in sleep state:   %lus (%.2f%%)\n", sleep_time, tmp);
+    tmp = (float)active_time / (float)total_time * 100;
+    printf(" Time in active state:  %lus (%.2f%%)\n", active_time, tmp);
+    tmp = (float)unknown_time / (float)total_time * 100;
+    printf(" Time in unknown state: %lus (%.2f%%)\n", unknown_time, tmp);
+}
+
+static void ender(int s)
+{
+    endit = 1;
+}
+
+static void usage(void)
+{
+    puts("usage: dslm [-w <time>] <disk>");
+    exit(0);
+}
+
+int main(int argc, char **argv)
+{
+    int fd;
+    char *disk = 0;
+    int settle_time = 60;
+
+    /* Parse the simple command-line */
+    if (argc == 2)
+	disk = argv[1];
+    else if (argc == 4) {
+	settle_time = atoi(argv[2]);
+	disk = argv[3];
+    } else
+	usage();
+
+    if (!(fd = open(disk, O_RDONLY|O_NONBLOCK))) {
+	printf("Can't open %s, because: %s\n", disk, strerror(errno));
+	exit(-1);
+    }
+
+    if (settle_time) {
+	printf("Waiting %d seconds for the system to settle down to "
+	       "'normal'\n", settle_time);
+	sleep(settle_time);
+    } else
+	puts("Not waiting for system to settle down");
+
+    signal(SIGINT, ender);
+
+    measure(fd);
+
+    close(fd);
+
+    return 0;
+}
--- lnx-2633-rc7.orig/Documentation/laptops/laptop-mode.txt
+++ lnx-2633-rc7/Documentation/laptops/laptop-mode.txt
@@ -779,172 +779,4 @@ Monitoring tool
 ---------------
 
 Bartek Kania submitted this, it can be used to measure how much time your disk
-spends spun up/down.
-
----------------------------dslm.c BEGIN-----------------------------------------
-/*
- * Simple Disk Sleep Monitor
- *  by Bartek Kania
- * Licenced under the GPL
- */
-#include <unistd.h>
-#include <stdlib.h>
-#include <stdio.h>
-#include <fcntl.h>
-#include <errno.h>
-#include <time.h>
-#include <string.h>
-#include <signal.h>
-#include <sys/ioctl.h>
-#include <linux/hdreg.h>
-
-#ifdef DEBUG
-#define D(x) x
-#else
-#define D(x)
-#endif
-
-int endit = 0;
-
-/* Check if the disk is in powersave-mode
- * Most of the code is stolen from hdparm.
- * 1 = active, 0 = standby/sleep, -1 = unknown */
-int check_powermode(int fd)
-{
-    unsigned char args[4] = {WIN_CHECKPOWERMODE1,0,0,0};
-    int state;
-
-    if (ioctl(fd, HDIO_DRIVE_CMD, &args)
-	&& (args[0] = WIN_CHECKPOWERMODE2) /* try again with 0x98 */
-	&& ioctl(fd, HDIO_DRIVE_CMD, &args)) {
-	if (errno != EIO || args[0] != 0 || args[1] != 0) {
-	    state = -1; /* "unknown"; */
-	} else
-	    state = 0; /* "sleeping"; */
-    } else {
-	state = (args[2] == 255) ? 1 : 0;
-    }
-    D(printf(" drive state is:  %d\n", state));
-
-    return state;
-}
-
-char *state_name(int i)
-{
-    if (i == -1) return "unknown";
-    if (i == 0) return "sleeping";
-    if (i == 1) return "active";
-
-    return "internal error";
-}
-
-char *myctime(time_t time)
-{
-    char *ts = ctime(&time);
-    ts[strlen(ts) - 1] = 0;
-
-    return ts;
-}
-
-void measure(int fd)
-{
-    time_t start_time;
-    int last_state;
-    time_t last_time;
-    int curr_state;
-    time_t curr_time = 0;
-    time_t time_diff;
-    time_t active_time = 0;
-    time_t sleep_time = 0;
-    time_t unknown_time = 0;
-    time_t total_time = 0;
-    int changes = 0;
-    float tmp;
-
-    printf("Starting measurements\n");
-
-    last_state = check_powermode(fd);
-    start_time = last_time = time(0);
-    printf("  System is in state %s\n\n", state_name(last_state));
-
-    while(!endit) {
-	sleep(1);
-	curr_state = check_powermode(fd);
-
-	if (curr_state != last_state || endit) {
-	    changes++;
-	    curr_time = time(0);
-	    time_diff = curr_time - last_time;
-
-	    if (last_state == 1) active_time += time_diff;
-	    else if (last_state == 0) sleep_time += time_diff;
-	    else unknown_time += time_diff;
-
-	    last_state = curr_state;
-	    last_time = curr_time;
-
-	    printf("%s: State-change to %s\n", myctime(curr_time),
-		   state_name(curr_state));
-	}
-    }
-    changes--; /* Compensate for SIGINT */
-
-    total_time = time(0) - start_time;
-    printf("\nTotal running time:  %lus\n", curr_time - start_time);
-    printf(" State changed %d times\n", changes);
-
-    tmp = (float)sleep_time / (float)total_time * 100;
-    printf(" Time in sleep state:   %lus (%.2f%%)\n", sleep_time, tmp);
-    tmp = (float)active_time / (float)total_time * 100;
-    printf(" Time in active state:  %lus (%.2f%%)\n", active_time, tmp);
-    tmp = (float)unknown_time / (float)total_time * 100;
-    printf(" Time in unknown state: %lus (%.2f%%)\n", unknown_time, tmp);
-}
-
-void ender(int s)
-{
-    endit = 1;
-}
-
-void usage()
-{
-    puts("usage: dslm [-w <time>] <disk>");
-    exit(0);
-}
-
-int main(int argc, char **argv)
-{
-    int fd;
-    char *disk = 0;
-    int settle_time = 60;
-
-    /* Parse the simple command-line */
-    if (argc == 2)
-	disk = argv[1];
-    else if (argc == 4) {
-	settle_time = atoi(argv[2]);
-	disk = argv[3];
-    } else
-	usage();
-
-    if (!(fd = open(disk, O_RDONLY|O_NONBLOCK))) {
-	printf("Can't open %s, because: %s\n", disk, strerror(errno));
-	exit(-1);
-    }
-
-    if (settle_time) {
-	printf("Waiting %d seconds for the system to settle down to "
-	       "'normal'\n", settle_time);
-	sleep(settle_time);
-    } else
-	puts("Not waiting for system to settle down");
-
-    signal(SIGINT, ender);
-
-    measure(fd);
-
-    close(fd);
-
-    return 0;
-}
----------------------------dslm.c END-------------------------------------------
+spends spun up/down.  See Documentation/laptops/dslm.c
--- lnx-2633-rc7.orig/Documentation/Makefile
+++ lnx-2633-rc7/Documentation/Makefile
@@ -1,3 +1,3 @@
 obj-m := DocBook/ accounting/ auxdisplay/ connector/ \
-	filesystems/configfs/ ia64/ networking/ \
+	filesystems/configfs/ ia64/ laptops/ networking/ \
 	pcmcia/ spi/ timers/ video4linux/ vm/ watchdog/src/
--- /dev/null
+++ lnx-2633-rc7/Documentation/laptops/Makefile
@@ -0,0 +1,8 @@
+# kbuild trick to avoid linker error. Can be omitted if a module is built.
+obj- := dummy.o
+
+# List of programs to build
+hostprogs-y := dslm
+
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
--- lnx-2633-rc7.orig/Documentation/laptops/00-INDEX
+++ lnx-2633-rc7/Documentation/laptops/00-INDEX
@@ -2,6 +2,12 @@
 	- This file
 acer-wmi.txt
 	- information on the Acer Laptop WMI Extras driver.
+asus-laptop.txt
+	- information on the Asus Laptop Extras driver.
+disk-shock-protection.txt
+	- information on Hard disk shock protection
+dslm.c
+	- Simple Disk Sleep Monitor program
 laptop-mode.txt
 	- how to conserve battery power using laptop-mode.
 sony-laptop.txt
