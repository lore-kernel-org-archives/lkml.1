Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbZKRBM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbZKRBM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 20:12:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755583AbZKRBM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 20:12:57 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:50097 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910AbZKRBMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 20:12:55 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, yakui.zhao@intel.com,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: [linux-pm] intermittent suspend problem again
References: <87fx93pwv2.fsf@tac.ki.iif.hu> <200911132059.46377.rjw@sisk.pl>
	<874ooxho2b.fsf@tac.ki.iif.hu> <200911141952.50030.rjw@sisk.pl>
Date: Wed, 18 Nov 2009 02:12:17 +0100
In-Reply-To: <200911141952.50030.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Sat, 14 Nov 2009 19:52:49 +0100")
Message-ID: <876398tz4e.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Saturday 14 November 2009, Ferenc Wagner wrote:
>
>> Are other pm_test values meaningful, or possibly harmful?
>
> They are supposed to work as for suspend.
>
>> I think I tried freezer, which resulted in a seemingly perfect
>> suspend, but the machine didn't try to resume afterwards, but booted
>> normally instead...
>
> So this sounds like there's a bug (will check).

I rechecked this: the freezer "test" goes on to suspend the machine;
generally it's even possible to resume from the image, but this still
should be a bug.  Can you reproduce it?

Meanwhile I managed to freeze the machine in the "Snapshotting system"
phase (that is, in the SNAPSHOT_CREATE_IMAGE ioctl) again.  SysRq
reacted, but didn't produce any output besides the name of the invoked
function or the help text.  It couldn't power off the machine, but it
was able to reboot it.

Since I've instrumented s2disk and the hibernation path, no freeze
happened during hibernating the machine.  However, it instead froze once
rebooting, when I wanted to replace the kernel.  It was the usual stuff:
everything smooth until the last step, then the final syscall with the
magic constants, then silence... It's starting to look like this bug has
nothing to do with hibernation after all, it's just the shutdown method
I use most often, so it surfaced with that.

I tried various things after starting with init=/bin/bash, but I wasn't
able to cancel the suspend then, so I introduced the "always cancel"
parameter (please find my current patch queue attached).  With that, I'm
able to freeze the machine in 2-5 tries: after a couple of perfect runs,
s2disk -P"always cancel=y" returns normally to the starting screen, but
I'm left with a totally unresponsive machine.  If I didn't botch my
patches, this may be a trace to follow: still not 100% reproducible, but
almost.

Btw. no matter I tried setting suspend loglevel to 1 or 2, usual
unqualified printks didn't make it to the console s2disk uses (not even
ones from before suspend_console() in hibernation_platform_enter, or
even simple ioctl traces for /dev/snapshot).  Would it be possible to
work around this by skipping prepare_console or similar?

And a last thing: when I set resume device to /root/strace (yes, that
binary), s2disk gave a rater strange report:
s2disk: Invalid resume device. Reason: Success.
-- 
Regards,
Feri.


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0001-Set-config-file-location-to-etc-uswsusp.conf-the-D.patch

>From 9df438995d040c8d4e46f3d79d0aabcd5092ee6b Mon Sep 17 00:00:00 2001
From: Ferenc Wagner <wferi@niif.hu>
Date: Tue, 10 Nov 2009 01:15:59 +0100
Subject: [PATCH] Set config file location to /etc/uswsusp.conf (the Debian default)

---
 config_parser.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/config_parser.h b/config_parser.h
index b1adb7f..3a85793 100644
--- a/config_parser.h
+++ b/config_parser.h
@@ -27,4 +27,4 @@ int parse(char *my_name, char *file_name, struct config_par *parv);
 void usage(char *my_name, struct option options[], const char *short_options);
 void version(char *my_name, char *extra_version);
 
-#define CONFIG_FILE	"/etc/suspend.conf"
+#define CONFIG_FILE	"/etc/uswsusp.conf"
-- 
1.5.6.5


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline; filename=0002-Add-some-debugging-output.patch

>From 26f25561e1608984faac83b7df1e9d4030be1c83 Mon Sep 17 00:00:00 2001
From: Ferenc Wagner <wferi@niif.hu>
Date: Tue, 10 Nov 2009 01:16:20 +0100
Subject: [PATCH] Add some debugging output

---
 config_parser.c |    2 ++
 suspend.c       |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/config_parser.c b/config_parser.c
index d017ccd..91cc4fc 100644
--- a/config_parser.c
+++ b/config_parser.c
@@ -66,6 +66,8 @@ int parse_line(char *str, struct config_par *parv)
 					if (sscanf(str, fmt, parv[i].ptr) <= 0)
 						error = -EINVAL;
 				}
+				if (!error)
+					fprintf (stderr, "Parsed %s=%s\n", parv[i].name, str);
 				break;
 			}
 		}
diff --git a/suspend.c b/suspend.c
index 51cab6f..5248dba 100644
--- a/suspend.c
+++ b/suspend.c
@@ -2421,7 +2421,7 @@ int main(int argc, char *argv[])
 
 	ret = 0;
 	if (stat(resume_dev_name, &stat_buf)) {
-		suspend_error("Could not stat the resume device file.");
+		suspend_error("Could not stat the resume device file '%s'.", resume_dev_name);
 		ret = ENODEV;
 		goto Umount;
 	}
-- 
1.5.6.5


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0003-Add-debugging-around-syscalls-and-ioctls.patch

>From f3472f84e44ccf41010aecc3971801c8825ae045 Mon Sep 17 00:00:00 2001
From: Ferenc Wagner <wferi@niif.hu>
Date: Sat, 14 Nov 2009 01:25:05 +0100
Subject: [PATCH] Add debugging around syscalls and ioctls

---
 suspend.c |   22 +++++++++++++++++++---
 swsusp.h  |   29 ++++++++++++++++++++++++++---
 2 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/suspend.c b/suspend.c
index 5248dba..6a7dbb4 100644
--- a/suspend.c
+++ b/suspend.c
@@ -295,17 +295,26 @@ static int atomic_snapshot(int dev, int *in_suspend)
 {
 	int error;
 
+	fprintf (stderr, "SNAPSHOT_CREATE_IMAGE...\n");
 	error = ioctl(dev, SNAPSHOT_CREATE_IMAGE, in_suspend);
+	fprintf (stderr, "SNAPSHOT_CREATE_IMAGE: %d\n", error);
 	if (error && errno == ENOTTY) {
 		report_unsupported_ioctl("SNAPSHOT_CREATE_IMAGE");
+		fprintf (stderr, "SNAPSHOT_ATOMIC_SNAPSHOT...\n");
 		error = ioctl(dev, SNAPSHOT_ATOMIC_SNAPSHOT, in_suspend);
+		fprintf (stderr, "SNAPSHOT_ATOMIC_SNAPSHOT: %d\n", error);
 	}
 	return error;
 }
 
 static inline int free_snapshot(int dev)
 {
-	return ioctl(dev, SNAPSHOT_FREE, 0);
+	int error;
+
+	fprintf (stderr, "SNAPSHOT_FREE...\n");
+	error = ioctl(dev, SNAPSHOT_FREE, 0);
+	fprintf (stderr, "SNAPSHOT_FREE: %d\n", error);
+	return error;
 }
 
 static int set_image_size(int dev, unsigned int size)
@@ -329,10 +338,14 @@ static int platform_enter(int dev)
 {
 	int error;
 
+	fprintf (stderr, "SNAPSHOT_POWER_OFF...\n");
 	error = ioctl(dev, SNAPSHOT_POWER_OFF, 0);
+	fprintf (stderr, "SNAPSHOT_POWER_OFF: %d\n", error);
 	if (error  && errno == ENOTTY) {
 		report_unsupported_ioctl("SNAPSHOT_POWER_OFF");
+		fprintf (stderr, "SNAPSHOT_PMOPS(PMOPS_ENTER)...\n");
 		error = ioctl(dev, SNAPSHOT_PMOPS, PMOPS_ENTER);
+		fprintf (stderr, "SNAPSHOT_PMOPS(PMOPS_ENTER): %d\n", error);
 	}
 	return error;
 }
@@ -1258,7 +1271,7 @@ static int flush_buffer(struct swap_writer *handle)
  */
 static int save_image(struct swap_writer *handle, unsigned int nr_pages)
 {
-	unsigned int m, writeout_rate;
+	unsigned int m, writeout_rate, expected_nr_pages = nr_pages;
 	ssize_t ret;
 	struct termios newtrm, savedtrm;
 	int abort_possible, key, error = 0;
@@ -1350,7 +1363,7 @@ static int save_image(struct swap_writer *handle, unsigned int nr_pages)
 		if (!error)
 			error = save_extents(handle, 1);
 		if (!error)
-			printf(" done (%u pages)\n", nr_pages);
+			printf(" done (%u pages of expected %u)\n", nr_pages, expected_nr_pages);
 	}
 
  Exit:
@@ -1670,12 +1683,15 @@ static void suspend_shutdown(int snapshot_fd)
 	splash.set_caption("Done.");
 
 	if (shutdown_method == SHUTDOWN_METHOD_REBOOT) {
+		fprintf (stderr, "Shutdown method was REBOOT, so rebooting...\n");
 		reboot();
 	} else if (shutdown_method == SHUTDOWN_METHOD_PLATFORM) {
+		fprintf (stderr, "Shutdown method was PLATFORM, so entering...\n");
 		if (platform_enter(snapshot_fd))
 			suspend_error("Could not enter the hibernation state, "
 					"calling power_off.");
 	}
+	fprintf (stderr, "Shutdown method was SHUTDOWN or something went wrong, so powering off...\n");
 	power_off();
 	/* Signature is on disk, it is very dangerous to continue now.
 	 * We'd do resume with stale caches on next boot. */
diff --git a/swsusp.h b/swsusp.h
index e6abc83..fe47702 100644
--- a/swsusp.h
+++ b/swsusp.h
@@ -90,41 +90,64 @@ static inline void report_unsupported_ioctl(char *name)
 
 static inline int freeze(int dev)
 {
-	return ioctl(dev, SNAPSHOT_FREEZE, 0);
+	int error;
+
+	fprintf (stderr, "SNAPSHOT_FREEZE...\n");
+	error = ioctl(dev, SNAPSHOT_FREEZE, 0);
+	fprintf (stderr, "SNAPSHOT_FREEZE: %d\n", error);
+	return error;
 }
 
 static inline int unfreeze(int dev)
 {
-	return ioctl(dev, SNAPSHOT_UNFREEZE, 0);
+	int error;
+
+	fprintf (stderr, "SNAPSHOT_UNFREEZE...\n");
+	error = ioctl(dev, SNAPSHOT_UNFREEZE, 0);
+	fprintf (stderr, "SNAPSHOT_UNFREEZE: %d\n", error);
+	return error;
 }
 
 static inline int platform_prepare(int dev)
 {
 	int error;
 
+	fprintf (stderr, "SNAPSHOT_PLATFORM_SUPPORT(1)...\n");
 	error = ioctl(dev, SNAPSHOT_PLATFORM_SUPPORT, 1);
+	fprintf (stderr, "SNAPSHOT_PLATFORM_SUPPORT(1): %d\n", error);
 	if (error && errno == ENOTTY) {
 		report_unsupported_ioctl("SNAPSHOT_PLATFORM_SUPPORT");
+		fprintf (stderr, "SNAPSHOT_PMOPS(PMOPS_PREPARE)...\n");
 		error = ioctl(dev, SNAPSHOT_PMOPS, PMOPS_PREPARE);
+		fprintf (stderr, "SNAPSHOT_PMOPS(PMOPS_PREPARE): %d\n", error);
 	}
 	return error;
 }
 
 static inline int platform_finish(int dev)
 {
-	return ioctl(dev, SNAPSHOT_PMOPS, PMOPS_FINISH);
+	int error;
+
+	fprintf (stderr, "SNAPSHOT_PMOPS(PMOPS_FINISH)...\n");
+	error = ioctl(dev, SNAPSHOT_PMOPS, PMOPS_FINISH);
+	fprintf (stderr, "SNAPSHOT_PMOPS(PMOPS_FINISH): %d\n", error);
+	return error;
 }
 
 static inline void reboot(void)
 {
+	fprintf (stderr, "reboot syscall...\n");
 	syscall(SYS_reboot, LINUX_REBOOT_MAGIC1, LINUX_REBOOT_MAGIC2,
 		LINUX_REBOOT_CMD_RESTART, 0);
+	fprintf (stderr, "reboot syscall failed!\n");
 }
 
 static inline void power_off(void)
 {
+	fprintf (stderr, "power off syscall...\n");
 	syscall(SYS_reboot, LINUX_REBOOT_MAGIC1, LINUX_REBOOT_MAGIC2,
 		LINUX_REBOOT_CMD_POWER_OFF, 0);
+	fprintf (stderr, "power off syscall failed!\n");
 }
 
 #ifndef SYS_sync_file_range
-- 
1.5.6.5


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0004-Add-the-always-cancel-parameter.patch

>From 9b04b5ab4d4e963aef630fa96f84e1c433c49476 Mon Sep 17 00:00:00 2001
From: Ferenc Wagner <wferi@niif.hu>
Date: Tue, 17 Nov 2009 23:37:02 +0100
Subject: [PATCH] Add the 'always cancel' parameter

---
 resume.c  |    5 +++++
 suspend.c |   12 ++++++++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/resume.c b/resume.c
index 50ea2c8..4b70fe4 100644
--- a/resume.c
+++ b/resume.c
@@ -148,6 +148,11 @@ static struct config_par parameters[] = {
 		.fmt = "%c",
 		.ptr = NULL,
 	},
+	{
+		.name = "always cancel",
+		.fmt = "%c",
+		.ptr = NULL,
+	},
 #ifdef CONFIG_THREADS
 	{
 		.name = "threads",
diff --git a/suspend.c b/suspend.c
index 6a7dbb4..2dc1311 100644
--- a/suspend.c
+++ b/suspend.c
@@ -96,6 +96,7 @@ static enum {
 } shutdown_method = SHUTDOWN_METHOD_PLATFORM;
 static int resume_pause;
 static char verify_image;
+static char always_cancel;
 #ifdef CONFIG_THREADS
 static char use_threads;
 #else
@@ -204,6 +205,11 @@ static struct config_par parameters[] = {
 		.fmt = "%c",
 		.ptr = &verify_image,
 	},
+	{
+		.name = "always cancel",
+		.fmt = "%c",
+		.ptr = &always_cancel,
+	},
 #ifdef CONFIG_THREADS
 	{
 		.name = "threads",
@@ -1373,6 +1379,9 @@ static int save_image(struct swap_writer *handle, unsigned int nr_pages)
 	if (abort_possible)
 		splash.restore_abort(&savedtrm);
 
+	if (always_cancel)
+		error = -EINTR;
+
 	return error;
 }
 
@@ -2339,6 +2348,9 @@ int main(int argc, char *argv[])
 	if (verify_image != 'y' && verify_image != 'Y')
 		verify_image = 0;
 
+	if (always_cancel != 'y' && always_cancel != 'Y')
+		always_cancel = 0;
+
 #ifdef CONFIG_THREADS
 	if (use_threads != 'y' && use_threads != 'Y')
 		use_threads = 0;
-- 
1.5.6.5


--=-=-=--
