Return-Path: <linux-kernel-owner+w=401wt.eu-S1753936AbYGVQqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbYGVQqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 12:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbYGVQq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 12:46:26 -0400
Received: from xenotime.net ([66.160.160.81]:59244 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750857AbYGVQqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 12:46:25 -0400
Date: Tue, 22 Jul 2008 09:46:13 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: tglx <tglx@linutronix.de>
Subject: [PATCH] documentation: move hpet.txt to timers/ subdirectory
Message-Id: <20080722094613.dac28859.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Move hpet.txt to Documentation/timers/ subdirectory.
Add 00-INDEX to Documentation/timers/ subdirectory.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/00-INDEX        |    2 
 Documentation/hpet.txt        |  300 ------------------------------------------
 Documentation/timers/00-INDEX |   10 +
 Documentation/timers/hpet.txt |  300 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 310 insertions(+), 302 deletions(-)

--- lin2626-git9.orig/Documentation/00-INDEX
+++ lin2626-git9/Documentation/00-INDEX
@@ -161,8 +161,6 @@ hayes-esp.txt
 	- info on using the Hayes ESP serial driver.
 highuid.txt
 	- notes on the change from 16 bit to 32 bit user/group IDs.
-hpet.txt
-	- High Precision Event Timer Driver for Linux.
 timers/
 	- info on the timer related topics
 hw_random.txt
--- lin2626-git9.orig/Documentation/hpet.txt
+++ /dev/null
@@ -1,300 +0,0 @@
-		High Precision Event Timer Driver for Linux
-
-The High Precision Event Timer (HPET) hardware is the future replacement
-for the 8254 and Real Time Clock (RTC) periodic timer functionality.
-Each HPET can have up to 32 timers.  It is possible to configure the
-first two timers as legacy replacements for 8254 and RTC periodic timers.
-A specification done by Intel and Microsoft can be found at
-<http://www.intel.com/technology/architecture/hpetspec.htm>.
-
-The driver supports detection of HPET driver allocation and initialization
-of the HPET before the driver module_init routine is called.  This enables
-platform code which uses timer 0 or 1 as the main timer to intercept HPET
-initialization.  An example of this initialization can be found in
-arch/i386/kernel/time_hpet.c.
-
-The driver provides two APIs which are very similar to the API found in
-the rtc.c driver.  There is a user space API and a kernel space API.
-An example user space program is provided below.
-
-#include <stdio.h>
-#include <stdlib.h>
-#include <unistd.h>
-#include <fcntl.h>
-#include <string.h>
-#include <memory.h>
-#include <malloc.h>
-#include <time.h>
-#include <ctype.h>
-#include <sys/types.h>
-#include <sys/wait.h>
-#include <signal.h>
-#include <fcntl.h>
-#include <errno.h>
-#include <sys/time.h>
-#include <linux/hpet.h>
-
-
-extern void hpet_open_close(int, const char **);
-extern void hpet_info(int, const char **);
-extern void hpet_poll(int, const char **);
-extern void hpet_fasync(int, const char **);
-extern void hpet_read(int, const char **);
-
-#include <sys/poll.h>
-#include <sys/ioctl.h>
-#include <signal.h>
-
-struct hpet_command {
-	char		*command;
-	void		(*func)(int argc, const char ** argv);
-} hpet_command[] = {
-	{
-		"open-close",
-		hpet_open_close
-	},
-	{
-		"info",
-		hpet_info
-	},
-	{
-		"poll",
-		hpet_poll
-	},
-	{
-		"fasync",
-		hpet_fasync
-	},
-};
-
-int
-main(int argc, const char ** argv)
-{
-	int	i;
-
-	argc--;
-	argv++;
-
-	if (!argc) {
-		fprintf(stderr, "-hpet: requires command\n");
-		return -1;
-	}
-
-
-	for (i = 0; i < (sizeof (hpet_command) / sizeof (hpet_command[0])); i++)
-		if (!strcmp(argv[0], hpet_command[i].command)) {
-			argc--;
-			argv++;
-			fprintf(stderr, "-hpet: executing %s\n",
-				hpet_command[i].command);
-			hpet_command[i].func(argc, argv);
-			return 0;
-		}
-
-	fprintf(stderr, "do_hpet: command %s not implemented\n", argv[0]);
-
-	return -1;
-}
-
-void
-hpet_open_close(int argc, const char **argv)
-{
-	int	fd;
-
-	if (argc != 1) {
-		fprintf(stderr, "hpet_open_close: device-name\n");
-		return;
-	}
-
-	fd = open(argv[0], O_RDONLY);
-	if (fd < 0)
-		fprintf(stderr, "hpet_open_close: open failed\n");
-	else
-		close(fd);
-
-	return;
-}
-
-void
-hpet_info(int argc, const char **argv)
-{
-}
-
-void
-hpet_poll(int argc, const char **argv)
-{
-	unsigned long		freq;
-	int			iterations, i, fd;
-	struct pollfd		pfd;
-	struct hpet_info	info;
-	struct timeval		stv, etv;
-	struct timezone		tz;
-	long			usec;
-
-	if (argc != 3) {
-		fprintf(stderr, "hpet_poll: device-name freq iterations\n");
-		return;
-	}
-
-	freq = atoi(argv[1]);
-	iterations = atoi(argv[2]);
-
-	fd = open(argv[0], O_RDONLY);
-
-	if (fd < 0) {
-		fprintf(stderr, "hpet_poll: open of %s failed\n", argv[0]);
-		return;
-	}
-
-	if (ioctl(fd, HPET_IRQFREQ, freq) < 0) {
-		fprintf(stderr, "hpet_poll: HPET_IRQFREQ failed\n");
-		goto out;
-	}
-
-	if (ioctl(fd, HPET_INFO, &info) < 0) {
-		fprintf(stderr, "hpet_poll: failed to get info\n");
-		goto out;
-	}
-
-	fprintf(stderr, "hpet_poll: info.hi_flags 0x%lx\n", info.hi_flags);
-
-	if (info.hi_flags && (ioctl(fd, HPET_EPI, 0) < 0)) {
-		fprintf(stderr, "hpet_poll: HPET_EPI failed\n");
-		goto out;
-	}
-
-	if (ioctl(fd, HPET_IE_ON, 0) < 0) {
-		fprintf(stderr, "hpet_poll, HPET_IE_ON failed\n");
-		goto out;
-	}
-
-	pfd.fd = fd;
-	pfd.events = POLLIN;
-
-	for (i = 0; i < iterations; i++) {
-		pfd.revents = 0;
-		gettimeofday(&stv, &tz);
-		if (poll(&pfd, 1, -1) < 0)
-			fprintf(stderr, "hpet_poll: poll failed\n");
-		else {
-			long 	data;
-
-			gettimeofday(&etv, &tz);
-			usec = stv.tv_sec * 1000000 + stv.tv_usec;
-			usec = (etv.tv_sec * 1000000 + etv.tv_usec) - usec;
-
-			fprintf(stderr,
-				"hpet_poll: expired time = 0x%lx\n", usec);
-
-			fprintf(stderr, "hpet_poll: revents = 0x%x\n",
-				pfd.revents);
-
-			if (read(fd, &data, sizeof(data)) != sizeof(data)) {
-				fprintf(stderr, "hpet_poll: read failed\n");
-			}
-			else
-				fprintf(stderr, "hpet_poll: data 0x%lx\n",
-					data);
-		}
-	}
-
-out:
-	close(fd);
-	return;
-}
-
-static int hpet_sigio_count;
-
-static void
-hpet_sigio(int val)
-{
-	fprintf(stderr, "hpet_sigio: called\n");
-	hpet_sigio_count++;
-}
-
-void
-hpet_fasync(int argc, const char **argv)
-{
-	unsigned long		freq;
-	int			iterations, i, fd, value;
-	sig_t			oldsig;
-	struct hpet_info	info;
-
-	hpet_sigio_count = 0;
-	fd = -1;
-
-	if ((oldsig = signal(SIGIO, hpet_sigio)) == SIG_ERR) {
-		fprintf(stderr, "hpet_fasync: failed to set signal handler\n");
-		return;
-	}
-
-	if (argc != 3) {
-		fprintf(stderr, "hpet_fasync: device-name freq iterations\n");
-		goto out;
-	}
-
-	fd = open(argv[0], O_RDONLY);
-
-	if (fd < 0) {
-		fprintf(stderr, "hpet_fasync: failed to open %s\n", argv[0]);
-		return;
-	}
-
-
-	if ((fcntl(fd, F_SETOWN, getpid()) == 1) ||
-		((value = fcntl(fd, F_GETFL)) == 1) ||
-		(fcntl(fd, F_SETFL, value | O_ASYNC) == 1)) {
-		fprintf(stderr, "hpet_fasync: fcntl failed\n");
-		goto out;
-	}
-
-	freq = atoi(argv[1]);
-	iterations = atoi(argv[2]);
-
-	if (ioctl(fd, HPET_IRQFREQ, freq) < 0) {
-		fprintf(stderr, "hpet_fasync: HPET_IRQFREQ failed\n");
-		goto out;
-	}
-
-	if (ioctl(fd, HPET_INFO, &info) < 0) {
-		fprintf(stderr, "hpet_fasync: failed to get info\n");
-		goto out;
-	}
-
-	fprintf(stderr, "hpet_fasync: info.hi_flags 0x%lx\n", info.hi_flags);
-
-	if (info.hi_flags && (ioctl(fd, HPET_EPI, 0) < 0)) {
-		fprintf(stderr, "hpet_fasync: HPET_EPI failed\n");
-		goto out;
-	}
-
-	if (ioctl(fd, HPET_IE_ON, 0) < 0) {
-		fprintf(stderr, "hpet_fasync, HPET_IE_ON failed\n");
-		goto out;
-	}
-
-	for (i = 0; i < iterations; i++) {
-		(void) pause();
-		fprintf(stderr, "hpet_fasync: count = %d\n", hpet_sigio_count);
-	}
-
-out:
-	signal(SIGIO, oldsig);
-
-	if (fd >= 0)
-		close(fd);
-
-	return;
-}
-
-The kernel API has three interfaces exported from the driver:
-
-	hpet_register(struct hpet_task *tp, int periodic)
-	hpet_unregister(struct hpet_task *tp)
-	hpet_control(struct hpet_task *tp, unsigned int cmd, unsigned long arg)
-
-The kernel module using this interface fills in the ht_func and ht_data
-members of the hpet_task structure before calling hpet_register.
-hpet_control simply vectors to the hpet_ioctl routine and has the same
-commands and respective arguments as the user API.  hpet_unregister
-is used to terminate usage of the HPET timer reserved by hpet_register.
--- /dev/null
+++ lin2626-git9/Documentation/timers/00-INDEX
@@ -0,0 +1,10 @@
+00-INDEX
+	- this file
+highres.txt
+	- High resolution timers and dynamic ticks design notes
+hpet.txt
+	- High Precision Event Timer Driver for Linux
+hrtimers.txt
+	- subsystem for high-resolution kernel timers
+timer_stats.txt
+	- timer usage statistics
--- /dev/null
+++ lin2626-git9/Documentation/timers/hpet.txt
@@ -0,0 +1,300 @@
+		High Precision Event Timer Driver for Linux
+
+The High Precision Event Timer (HPET) hardware is the future replacement
+for the 8254 and Real Time Clock (RTC) periodic timer functionality.
+Each HPET can have up to 32 timers.  It is possible to configure the
+first two timers as legacy replacements for 8254 and RTC periodic timers.
+A specification done by Intel and Microsoft can be found at
+<http://www.intel.com/technology/architecture/hpetspec.htm>.
+
+The driver supports detection of HPET driver allocation and initialization
+of the HPET before the driver module_init routine is called.  This enables
+platform code which uses timer 0 or 1 as the main timer to intercept HPET
+initialization.  An example of this initialization can be found in
+arch/i386/kernel/time_hpet.c.
+
+The driver provides two APIs which are very similar to the API found in
+the rtc.c driver.  There is a user space API and a kernel space API.
+An example user space program is provided below.
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <string.h>
+#include <memory.h>
+#include <malloc.h>
+#include <time.h>
+#include <ctype.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <signal.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <sys/time.h>
+#include <linux/hpet.h>
+
+
+extern void hpet_open_close(int, const char **);
+extern void hpet_info(int, const char **);
+extern void hpet_poll(int, const char **);
+extern void hpet_fasync(int, const char **);
+extern void hpet_read(int, const char **);
+
+#include <sys/poll.h>
+#include <sys/ioctl.h>
+#include <signal.h>
+
+struct hpet_command {
+	char		*command;
+	void		(*func)(int argc, const char ** argv);
+} hpet_command[] = {
+	{
+		"open-close",
+		hpet_open_close
+	},
+	{
+		"info",
+		hpet_info
+	},
+	{
+		"poll",
+		hpet_poll
+	},
+	{
+		"fasync",
+		hpet_fasync
+	},
+};
+
+int
+main(int argc, const char ** argv)
+{
+	int	i;
+
+	argc--;
+	argv++;
+
+	if (!argc) {
+		fprintf(stderr, "-hpet: requires command\n");
+		return -1;
+	}
+
+
+	for (i = 0; i < (sizeof (hpet_command) / sizeof (hpet_command[0])); i++)
+		if (!strcmp(argv[0], hpet_command[i].command)) {
+			argc--;
+			argv++;
+			fprintf(stderr, "-hpet: executing %s\n",
+				hpet_command[i].command);
+			hpet_command[i].func(argc, argv);
+			return 0;
+		}
+
+	fprintf(stderr, "do_hpet: command %s not implemented\n", argv[0]);
+
+	return -1;
+}
+
+void
+hpet_open_close(int argc, const char **argv)
+{
+	int	fd;
+
+	if (argc != 1) {
+		fprintf(stderr, "hpet_open_close: device-name\n");
+		return;
+	}
+
+	fd = open(argv[0], O_RDONLY);
+	if (fd < 0)
+		fprintf(stderr, "hpet_open_close: open failed\n");
+	else
+		close(fd);
+
+	return;
+}
+
+void
+hpet_info(int argc, const char **argv)
+{
+}
+
+void
+hpet_poll(int argc, const char **argv)
+{
+	unsigned long		freq;
+	int			iterations, i, fd;
+	struct pollfd		pfd;
+	struct hpet_info	info;
+	struct timeval		stv, etv;
+	struct timezone		tz;
+	long			usec;
+
+	if (argc != 3) {
+		fprintf(stderr, "hpet_poll: device-name freq iterations\n");
+		return;
+	}
+
+	freq = atoi(argv[1]);
+	iterations = atoi(argv[2]);
+
+	fd = open(argv[0], O_RDONLY);
+
+	if (fd < 0) {
+		fprintf(stderr, "hpet_poll: open of %s failed\n", argv[0]);
+		return;
+	}
+
+	if (ioctl(fd, HPET_IRQFREQ, freq) < 0) {
+		fprintf(stderr, "hpet_poll: HPET_IRQFREQ failed\n");
+		goto out;
+	}
+
+	if (ioctl(fd, HPET_INFO, &info) < 0) {
+		fprintf(stderr, "hpet_poll: failed to get info\n");
+		goto out;
+	}
+
+	fprintf(stderr, "hpet_poll: info.hi_flags 0x%lx\n", info.hi_flags);
+
+	if (info.hi_flags && (ioctl(fd, HPET_EPI, 0) < 0)) {
+		fprintf(stderr, "hpet_poll: HPET_EPI failed\n");
+		goto out;
+	}
+
+	if (ioctl(fd, HPET_IE_ON, 0) < 0) {
+		fprintf(stderr, "hpet_poll, HPET_IE_ON failed\n");
+		goto out;
+	}
+
+	pfd.fd = fd;
+	pfd.events = POLLIN;
+
+	for (i = 0; i < iterations; i++) {
+		pfd.revents = 0;
+		gettimeofday(&stv, &tz);
+		if (poll(&pfd, 1, -1) < 0)
+			fprintf(stderr, "hpet_poll: poll failed\n");
+		else {
+			long 	data;
+
+			gettimeofday(&etv, &tz);
+			usec = stv.tv_sec * 1000000 + stv.tv_usec;
+			usec = (etv.tv_sec * 1000000 + etv.tv_usec) - usec;
+
+			fprintf(stderr,
+				"hpet_poll: expired time = 0x%lx\n", usec);
+
+			fprintf(stderr, "hpet_poll: revents = 0x%x\n",
+				pfd.revents);
+
+			if (read(fd, &data, sizeof(data)) != sizeof(data)) {
+				fprintf(stderr, "hpet_poll: read failed\n");
+			}
+			else
+				fprintf(stderr, "hpet_poll: data 0x%lx\n",
+					data);
+		}
+	}
+
+out:
+	close(fd);
+	return;
+}
+
+static int hpet_sigio_count;
+
+static void
+hpet_sigio(int val)
+{
+	fprintf(stderr, "hpet_sigio: called\n");
+	hpet_sigio_count++;
+}
+
+void
+hpet_fasync(int argc, const char **argv)
+{
+	unsigned long		freq;
+	int			iterations, i, fd, value;
+	sig_t			oldsig;
+	struct hpet_info	info;
+
+	hpet_sigio_count = 0;
+	fd = -1;
+
+	if ((oldsig = signal(SIGIO, hpet_sigio)) == SIG_ERR) {
+		fprintf(stderr, "hpet_fasync: failed to set signal handler\n");
+		return;
+	}
+
+	if (argc != 3) {
+		fprintf(stderr, "hpet_fasync: device-name freq iterations\n");
+		goto out;
+	}
+
+	fd = open(argv[0], O_RDONLY);
+
+	if (fd < 0) {
+		fprintf(stderr, "hpet_fasync: failed to open %s\n", argv[0]);
+		return;
+	}
+
+
+	if ((fcntl(fd, F_SETOWN, getpid()) == 1) ||
+		((value = fcntl(fd, F_GETFL)) == 1) ||
+		(fcntl(fd, F_SETFL, value | O_ASYNC) == 1)) {
+		fprintf(stderr, "hpet_fasync: fcntl failed\n");
+		goto out;
+	}
+
+	freq = atoi(argv[1]);
+	iterations = atoi(argv[2]);
+
+	if (ioctl(fd, HPET_IRQFREQ, freq) < 0) {
+		fprintf(stderr, "hpet_fasync: HPET_IRQFREQ failed\n");
+		goto out;
+	}
+
+	if (ioctl(fd, HPET_INFO, &info) < 0) {
+		fprintf(stderr, "hpet_fasync: failed to get info\n");
+		goto out;
+	}
+
+	fprintf(stderr, "hpet_fasync: info.hi_flags 0x%lx\n", info.hi_flags);
+
+	if (info.hi_flags && (ioctl(fd, HPET_EPI, 0) < 0)) {
+		fprintf(stderr, "hpet_fasync: HPET_EPI failed\n");
+		goto out;
+	}
+
+	if (ioctl(fd, HPET_IE_ON, 0) < 0) {
+		fprintf(stderr, "hpet_fasync, HPET_IE_ON failed\n");
+		goto out;
+	}
+
+	for (i = 0; i < iterations; i++) {
+		(void) pause();
+		fprintf(stderr, "hpet_fasync: count = %d\n", hpet_sigio_count);
+	}
+
+out:
+	signal(SIGIO, oldsig);
+
+	if (fd >= 0)
+		close(fd);
+
+	return;
+}
+
+The kernel API has three interfaces exported from the driver:
+
+	hpet_register(struct hpet_task *tp, int periodic)
+	hpet_unregister(struct hpet_task *tp)
+	hpet_control(struct hpet_task *tp, unsigned int cmd, unsigned long arg)
+
+The kernel module using this interface fills in the ht_func and ht_data
+members of the hpet_task structure before calling hpet_register.
+hpet_control simply vectors to the hpet_ioctl routine and has the same
+commands and respective arguments as the user API.  hpet_unregister
+is used to terminate usage of the HPET timer reserved by hpet_register.


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
