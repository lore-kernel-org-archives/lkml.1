Return-Path: <linux-kernel-owner+w=401wt.eu-S1752278AbZKOHOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbZKOHOo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 02:14:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbZKOHOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 02:14:42 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:40952 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbZKOHOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 02:14:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=igfHtDpTxCJVFe/KXewAMJTVcYfpVJjaX++YFATaPAdy5cXU34Ex/4MhHWWcu90ny/
         cq4MqLbIyLqDKKoqQ0Rba6qSlRPodvUIMcixez1FOF8ytUjcRJpEYR0E57RufeZG4q3C
         dLlAjYynrIpzIkFaxwVGZs7VN6ZtjslnRkgAQ=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: "linux list" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>,
       Julia Lawall <julia@diku.dk>
Subject: [PATCH v5 12/12] tree-wide: convert open calls to remove spaces to skip_spaces() lib function
Date: Sat, 14 Nov 2009 05:12:00 -0200
Message-Id: <623fc6c1c58b8c3ccf4a1373e94aba3639a0714e.1258181837.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e.dirty
In-Reply-To: <cover.1258181836.git.andre.goddard@gmail.com>
References: <cover.1258181836.git.andre.goddard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makes use of skip_spaces() defined in lib/string.c for removing leading
spaces from strings all over the tree.

It decreases lib.a code size by 47 bytes and reuses the function tree-wide:
   text    data     bss     dec     hex filename
  64688     584     592   65864   10148 (TOTALS-BEFORE)
  64641     584     592   65817   10119 (TOTALS-AFTER)

Also, while at it, if we see (*str && isspace(*str)), we can be sure to
remove the first condition (*str) as the second one (isspace(*str)) also
evaluates to 0 whenever *str == 0, making it redundant. In other words,
"a char equals zero is never a space".

Julia Lawall tried the semantic patch (http://coccinelle.lip6.fr) below,
and found occurrences of this pattern on 3 more files:
    drivers/leds/led-class.c
    drivers/leds/ledtrig-timer.c
    drivers/video/output.c

@@
expression str;
@@

( // ignore skip_spaces cases
while (*str &&  isspace(*str)) { \(str++;\|++str;\) }
|
- *str &&
isspace(*str)
)

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
cc: Julia Lawall <julia@diku.dk>
---
 arch/s390/kernel/debug.c              |    3 +-
 arch/um/drivers/mconsole_kern.c       |   16 ++++++--------
 arch/x86/kernel/cpu/mtrr/if.c         |   11 +++------
 drivers/leds/led-class.c              |    2 +-
 drivers/leds/ledtrig-timer.c          |    4 +-
 drivers/md/dm-table.c                 |    6 +---
 drivers/md/md.c                       |    4 +-
 drivers/parisc/pdc_stable.c           |    9 ++-----
 drivers/platform/x86/thinkpad_acpi.c  |    7 +----
 drivers/pnp/interface.c               |   36 +++++++++-----------------------
 drivers/s390/block/dasd_proc.c        |    5 ++-
 drivers/video/backlight/lcd.c         |    4 +-
 drivers/video/display/display-sysfs.c |    2 +-
 drivers/video/output.c                |    2 +-
 fs/cachefiles/daemon.c                |    4 +-
 fs/ext4/super.c                       |    7 +----
 kernel/params.c                       |    8 ++----
 lib/argv_split.c                      |   13 ++---------
 lib/dynamic_debug.c                   |    4 +-
 lib/vsprintf.c                        |   15 +++----------
 net/irda/irnet/irnet.h                |    1 +
 net/irda/irnet/irnet_ppp.c            |    8 ++----
 net/netfilter/xt_recent.c             |    3 +-
 sound/pci/hda/hda_hwdep.c             |    7 ++---
 24 files changed, 66 insertions(+), 115 deletions(-)

diff --git a/arch/s390/kernel/debug.c b/arch/s390/kernel/debug.c
index 20f282c..7a0f4a9 100644
--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -18,6 +18,7 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/ctype.h>
+#include <linux/string.h>
 #include <linux/sysctl.h>
 #include <asm/uaccess.h>
 #include <linux/module.h>
@@ -1183,7 +1184,7 @@ debug_get_uint(char *buf)
 {
 	int rc;
 
-	for(; isspace(*buf); buf++);
+	buf = skip_spaces(buf);
 	rc = simple_strtoul(buf, &buf, 10);
 	if(*buf){
 		rc = -EINVAL;
diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
index e14629c..f5d459a 100644
--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -6,6 +6,7 @@
 
 #include <linux/console.h>
 #include <linux/ctype.h>
+#include <linux/string.h>
 #include <linux/interrupt.h>
 #include <linux/list.h>
 #include <linux/mm.h>
@@ -131,7 +132,7 @@ void mconsole_proc(struct mc_request *req)
 	char *ptr = req->request.data, *buf;
 
 	ptr += strlen("proc");
-	while (isspace(*ptr)) ptr++;
+	ptr = skip_spaces(ptr);
 
 	proc = get_fs_type("proc");
 	if (proc == NULL) {
@@ -212,8 +213,7 @@ void mconsole_proc(struct mc_request *req)
 	char *ptr = req->request.data;
 
 	ptr += strlen("proc");
-	while (isspace(*ptr))
-		ptr++;
+	ptr = skip_spaces(ptr);
 	snprintf(path, sizeof(path), "/proc/%s", ptr);
 
 	fd = sys_open(path, 0, 0);
@@ -560,8 +560,7 @@ void mconsole_config(struct mc_request *req)
 	int err;
 
 	ptr += strlen("config");
-	while (isspace(*ptr))
-		ptr++;
+	ptr = skip_spaces(ptr);
 	dev = mconsole_find_dev(ptr);
 	if (dev == NULL) {
 		mconsole_reply(req, "Bad configuration option", 1, 0);
@@ -588,7 +587,7 @@ void mconsole_remove(struct mc_request *req)
 	int err, start, end, n;
 
 	ptr += strlen("remove");
-	while (isspace(*ptr)) ptr++;
+	ptr = skip_spaces(ptr);
 	dev = mconsole_find_dev(ptr);
 	if (dev == NULL) {
 		mconsole_reply(req, "Bad remove option", 1, 0);
@@ -712,7 +711,7 @@ void mconsole_sysrq(struct mc_request *req)
 	char *ptr = req->request.data;
 
 	ptr += strlen("sysrq");
-	while (isspace(*ptr)) ptr++;
+	ptr = skip_spaces(ptr);
 
 	/*
 	 * With 'b', the system will shut down without a chance to reply,
@@ -757,8 +756,7 @@ void mconsole_stack(struct mc_request *req)
 	 */
 
 	ptr += strlen("stack");
-	while (isspace(*ptr))
-		ptr++;
+	ptr = skip_spaces(ptr);
 
 	/*
 	 * Should really check for multiple pids or reject bad args here
diff --git a/arch/x86/kernel/cpu/mtrr/if.c b/arch/x86/kernel/cpu/mtrr/if.c
index 3c1b12d..e006e56 100644
--- a/arch/x86/kernel/cpu/mtrr/if.c
+++ b/arch/x86/kernel/cpu/mtrr/if.c
@@ -4,6 +4,7 @@
 #include <linux/proc_fs.h>
 #include <linux/module.h>
 #include <linux/ctype.h>
+#include <linux/string.h>
 #include <linux/init.h>
 
 #define LINE_SIZE 80
@@ -133,8 +134,7 @@ mtrr_write(struct file *file, const char __user *buf, size_t len, loff_t * ppos)
 		return -EINVAL;
 
 	base = simple_strtoull(line + 5, &ptr, 0);
-	while (isspace(*ptr))
-		ptr++;
+	ptr = skip_spaces(ptr);
 
 	if (strncmp(ptr, "size=", 5))
 		return -EINVAL;
@@ -142,14 +142,11 @@ mtrr_write(struct file *file, const char __user *buf, size_t len, loff_t * ppos)
 	size = simple_strtoull(ptr + 5, &ptr, 0);
 	if ((base & 0xfff) || (size & 0xfff))
 		return -EINVAL;
-	while (isspace(*ptr))
-		ptr++;
+	ptr = skip_spaces(ptr);
 
 	if (strncmp(ptr, "type=", 5))
 		return -EINVAL;
-	ptr += 5;
-	while (isspace(*ptr))
-		ptr++;
+	ptr = skip_spaces(ptr + 5);
 
 	for (i = 0; i < MTRR_NUM_TYPES; ++i) {
 		if (strcmp(ptr, mtrr_strings[i]))
diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index f2cc13d..782f958 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -50,7 +50,7 @@ static ssize_t led_brightness_store(struct device *dev,
 	unsigned long state = simple_strtoul(buf, &after, 10);
 	size_t count = after - buf;
 
-	if (*after && isspace(*after))
+	if (isspace(*after))
 		count++;
 
 	if (count == size) {
diff --git a/drivers/leds/ledtrig-timer.c b/drivers/leds/ledtrig-timer.c
index 3b83406..38b3378 100644
--- a/drivers/leds/ledtrig-timer.c
+++ b/drivers/leds/ledtrig-timer.c
@@ -83,7 +83,7 @@ static ssize_t led_delay_on_store(struct device *dev,
 	unsigned long state = simple_strtoul(buf, &after, 10);
 	size_t count = after - buf;
 
-	if (*after && isspace(*after))
+	if (isspace(*after))
 		count++;
 
 	if (count == size) {
@@ -127,7 +127,7 @@ static ssize_t led_delay_off_store(struct device *dev,
 	unsigned long state = simple_strtoul(buf, &after, 10);
 	size_t count = after - buf;
 
-	if (*after && isspace(*after))
+	if (isspace(*after))
 		count++;
 
 	if (count == size) {
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 1a6cb3c..91976e8 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -12,6 +12,7 @@
 #include <linux/blkdev.h>
 #include <linux/namei.h>
 #include <linux/ctype.h>
+#include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/mutex.h>
@@ -600,11 +601,8 @@ int dm_split_args(int *argc, char ***argvp, char *input)
 		return -ENOMEM;
 
 	while (1) {
-		start = end;
-
 		/* Skip whitespace */
-		while (*start && isspace(*start))
-			start++;
+		start = skip_spaces(end);
 
 		if (!*start)
 			break;	/* success, we hit the end */
diff --git a/drivers/md/md.c b/drivers/md/md.c
index e64c971..01468a1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -39,6 +39,7 @@
 #include <linux/buffer_head.h> /* for invalidate_bdev */
 #include <linux/poll.h>
 #include <linux/ctype.h>
+#include <linux/string.h>
 #include <linux/hdreg.h>
 #include <linux/proc_fs.h>
 #include <linux/random.h>
@@ -3225,8 +3226,7 @@ bitmap_store(mddev_t *mddev, const char *buf, size_t len)
 		}
 		if (*end && !isspace(*end)) break;
 		bitmap_dirty_bits(mddev->bitmap, chunk, end_chunk);
-		buf = end;
-		while (isspace(*buf)) buf++;
+		buf = skip_spaces(end);
 	}
 	bitmap_unplug(mddev->bitmap); /* flush the bits to disk */
 out:
diff --git a/drivers/parisc/pdc_stable.c b/drivers/parisc/pdc_stable.c
index 13a64bc..0bc5d47 100644
--- a/drivers/parisc/pdc_stable.c
+++ b/drivers/parisc/pdc_stable.c
@@ -779,12 +779,9 @@ static ssize_t pdcs_auto_write(struct kobject *kobj,
 	read_unlock(&pathentry->rw_lock);
 	
 	DPRINTK("%s: flags before: 0x%X\n", __func__, flags);
-			
-	temp = in;
-	
-	while (*temp && isspace(*temp))
-		temp++;
-	
+
+	temp = skip_spaces(in);
+
 	c = *temp++ - '0';
 	if ((c != 0) && (c != 1))
 		goto parse_error;
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index d93108d..e8026d9 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -1006,11 +1006,8 @@ static int parse_strtoul(const char *buf,
 {
 	char *endp;
 
-	while (*buf && isspace(*buf))
-		buf++;
-	*value = simple_strtoul(buf, &endp, 0);
-	while (*endp && isspace(*endp))
-		endp++;
+	*value = simple_strtoul(skip_spaces(buf), &endp, 0);
+	endp = skip_spaces(endp);
 	if (*endp || *value > max)
 		return -EINVAL;
 
diff --git a/drivers/pnp/interface.c b/drivers/pnp/interface.c
index c3f1c8e..68b0c04 100644
--- a/drivers/pnp/interface.c
+++ b/drivers/pnp/interface.c
@@ -310,8 +310,7 @@ static ssize_t pnp_set_current_resources(struct device *dmdev,
 		goto done;
 	}
 
-	while (isspace(*buf))
-		++buf;
+	buf = skip_spaces(buf);
 	if (!strnicmp(buf, "disable", 7)) {
 		retval = pnp_disable_dev(dev);
 		goto done;
@@ -353,19 +352,13 @@ static ssize_t pnp_set_current_resources(struct device *dmdev,
 		pnp_init_resources(dev);
 		mutex_lock(&pnp_res_mutex);
 		while (1) {
-			while (isspace(*buf))
-				++buf;
+			buf = skip_spaces(buf);
 			if (!strnicmp(buf, "io", 2)) {
-				buf += 2;
-				while (isspace(*buf))
-					++buf;
+				buf = skip_spaces(buf + 2);
 				start = simple_strtoul(buf, &buf, 0);
-				while (isspace(*buf))
-					++buf;
+				buf = skip_spaces(buf);
 				if (*buf == '-') {
-					buf += 1;
-					while (isspace(*buf))
-						++buf;
+					buf = skip_spaces(buf + 1);
 					end = simple_strtoul(buf, &buf, 0);
 				} else
 					end = start;
@@ -373,16 +366,11 @@ static ssize_t pnp_set_current_resources(struct device *dmdev,
 				continue;
 			}
 			if (!strnicmp(buf, "mem", 3)) {
-				buf += 3;
-				while (isspace(*buf))
-					++buf;
+				buf = skip_spaces(buf + 3);
 				start = simple_strtoul(buf, &buf, 0);
-				while (isspace(*buf))
-					++buf;
+				buf = skip_spaces(buf);
 				if (*buf == '-') {
-					buf += 1;
-					while (isspace(*buf))
-						++buf;
+					buf = skip_spaces(buf + 1);
 					end = simple_strtoul(buf, &buf, 0);
 				} else
 					end = start;
@@ -390,17 +378,13 @@ static ssize_t pnp_set_current_resources(struct device *dmdev,
 				continue;
 			}
 			if (!strnicmp(buf, "irq", 3)) {
-				buf += 3;
-				while (isspace(*buf))
-					++buf;
+				buf = skip_spaces(buf + 3);
 				start = simple_strtoul(buf, &buf, 0);
 				pnp_add_irq_resource(dev, start, 0);
 				continue;
 			}
 			if (!strnicmp(buf, "dma", 3)) {
-				buf += 3;
-				while (isspace(*buf))
-					++buf;
+				buf = skip_spaces(buf + 3);
 				start = simple_strtoul(buf, &buf, 0);
 				pnp_add_dma_resource(dev, start, 0);
 				continue;
diff --git a/drivers/s390/block/dasd_proc.c b/drivers/s390/block/dasd_proc.c
index 654daa3..c2d8792 100644
--- a/drivers/s390/block/dasd_proc.c
+++ b/drivers/s390/block/dasd_proc.c
@@ -14,6 +14,7 @@
 #define KMSG_COMPONENT "dasd"
 
 #include <linux/ctype.h>
+#include <linux/string.h>
 #include <linux/seq_file.h>
 #include <linux/vmalloc.h>
 #include <linux/proc_fs.h>
@@ -272,10 +273,10 @@ dasd_statistics_write(struct file *file, const char __user *user_buf,
 	DBF_EVENT(DBF_DEBUG, "/proc/dasd/statictics: '%s'\n", buffer);
 
 	/* check for valid verbs */
-	for (str = buffer; isspace(*str); str++);
+	str = skip_spaces(buffer);
 	if (strncmp(str, "set", 3) == 0 && isspace(str[3])) {
 		/* 'set xxx' was given */
-		for (str = str + 4; isspace(*str); str++);
+		str = skip_spaces(str + 4);
 		if (strcmp(str, "on") == 0) {
 			/* switch on statistics profiling */
 			dasd_profile_level = DASD_PROFILE_ON;
diff --git a/drivers/video/backlight/lcd.c b/drivers/video/backlight/lcd.c
index b644947..3b20cbf 100644
--- a/drivers/video/backlight/lcd.c
+++ b/drivers/video/backlight/lcd.c
@@ -101,7 +101,7 @@ static ssize_t lcd_store_power(struct device *dev,
 	int power = simple_strtoul(buf, &endp, 0);
 	size_t size = endp - buf;
 
-	if (*endp && isspace(*endp))
+	if (isspace(*endp))
 		size++;
 	if (size != count)
 		return -EINVAL;
@@ -140,7 +140,7 @@ static ssize_t lcd_store_contrast(struct device *dev,
 	int contrast = simple_strtoul(buf, &endp, 0);
 	size_t size = endp - buf;
 
-	if (*endp && isspace(*endp))
+	if (isspace(*endp))
 		size++;
 	if (size != count)
 		return -EINVAL;
diff --git a/drivers/video/display/display-sysfs.c b/drivers/video/display/display-sysfs.c
index 4830b1b..80abbf3 100644
--- a/drivers/video/display/display-sysfs.c
+++ b/drivers/video/display/display-sysfs.c
@@ -67,7 +67,7 @@ static ssize_t display_store_contrast(struct device *dev,
 	contrast = simple_strtoul(buf, &endp, 0);
 	size = endp - buf;
 
-	if (*endp && isspace(*endp))
+	if (isspace(*endp))
 		size++;
 
 	if (size != count)
diff --git a/drivers/video/output.c b/drivers/video/output.c
index 5e6439a..5137aa0 100644
--- a/drivers/video/output.c
+++ b/drivers/video/output.c
@@ -50,7 +50,7 @@ static ssize_t video_output_store_state(struct device *dev,
 	int request_state = simple_strtoul(buf,&endp,0);
 	size_t size = endp - buf;
 
-	if (*endp && isspace(*endp))
+	if (isspace(*endp))
 		size++;
 	if (size != count)
 		return -EINVAL;
diff --git a/fs/cachefiles/daemon.c b/fs/cachefiles/daemon.c
index 4618516..c241356 100644
--- a/fs/cachefiles/daemon.c
+++ b/fs/cachefiles/daemon.c
@@ -21,6 +21,7 @@
 #include <linux/mount.h>
 #include <linux/statfs.h>
 #include <linux/ctype.h>
+#include <linux/string.h>
 #include <linux/fs_struct.h>
 #include "internal.h"
 
@@ -257,8 +258,7 @@ static ssize_t cachefiles_daemon_write(struct file *file,
 		if (args == data)
 			goto error;
 		*args = '\0';
-		for (args++; isspace(*args); args++)
-			continue;
+		args = skip_spaces(++args);
 	}
 
 	/* run the appropriate command handler */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d4ca92a..8b9e3bb 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2099,11 +2099,8 @@ static int parse_strtoul(const char *buf,
 {
 	char *endp;
 
-	while (*buf && isspace(*buf))
-		buf++;
-	*value = simple_strtoul(buf, &endp, 0);
-	while (*endp && isspace(*endp))
-		endp++;
+	*value = simple_strtoul(skip_spaces(buf), &endp, 0);
+	endp = skip_spaces(endp);
 	if (*endp || *value > max)
 		return -EINVAL;
 
diff --git a/kernel/params.c b/kernel/params.c
index d656c27..cf1b691 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -24,6 +24,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/ctype.h>
+#include <linux/string.h>
 
 #if 0
 #define DEBUGP printk
@@ -122,9 +123,7 @@ static char *next_arg(char *args, char **param, char **val)
 		next = args + i;
 
 	/* Chew up trailing spaces. */
-	while (isspace(*next))
-		next++;
-	return next;
+	return skip_spaces(next);
 }
 
 /* Args looks like "foo=bar,bar2 baz=fuz wiz". */
@@ -139,8 +138,7 @@ int parse_args(const char *name,
 	DEBUGP("Parsing ARGS: %s\n", args);
 
 	/* Chew leading spaces */
-	while (isspace(*args))
-		args++;
+	args = skip_spaces(args);
 
 	while (*args) {
 		int ret;
diff --git a/lib/argv_split.c b/lib/argv_split.c
index 5205a8d..4b1b083 100644
--- a/lib/argv_split.c
+++ b/lib/argv_split.c
@@ -4,17 +4,10 @@
 
 #include <linux/kernel.h>
 #include <linux/ctype.h>
+#include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 
-static const char *skip_sep(const char *cp)
-{
-	while (*cp && isspace(*cp))
-		cp++;
-
-	return cp;
-}
-
 static const char *skip_arg(const char *cp)
 {
 	while (*cp && !isspace(*cp))
@@ -28,7 +21,7 @@ static int count_argc(const char *str)
 	int count = 0;
 
 	while (*str) {
-		str = skip_sep(str);
+		str = skip_spaces(str);
 		if (*str) {
 			count++;
 			str = skip_arg(str);
@@ -82,7 +75,7 @@ char **argv_split(gfp_t gfp, const char *str, int *argcp)
 	argvp = argv;
 
 	while (*str) {
-		str = skip_sep(str);
+		str = skip_spaces(str);
 
 		if (*str) {
 			const char *p = str;
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index e22c148..f935029 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -21,6 +21,7 @@
 #include <linux/list.h>
 #include <linux/sysctl.h>
 #include <linux/ctype.h>
+#include <linux/string.h>
 #include <linux/uaccess.h>
 #include <linux/dynamic_debug.h>
 #include <linux/debugfs.h>
@@ -209,8 +210,7 @@ static int ddebug_tokenize(char *buf, char *words[], int maxwords)
 		char *end;
 
 		/* Skip leading whitespace */
-		while (*buf && isspace(*buf))
-			buf++;
+		buf = skip_spaces(buf);
 		if (!*buf)
 			break;	/* oh, it was trailing whitespace */
 
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 7799a6e..1eb66dd 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1713,13 +1713,6 @@ EXPORT_SYMBOL_GPL(bprintf);
 
 #endif /* CONFIG_BINARY_PRINTF */
 
-static noinline char *skip_space(const char *str)
-{
-	while (isspace(*str))
-		++str;
-	return (char *)str;
-}
-
 /**
  * vsscanf - Unformat a buffer into a list of arguments
  * @buf:	input buffer
@@ -1741,8 +1734,8 @@ int vsscanf(const char *buf, const char *fmt, va_list args)
 		 * white space, including none, in the input.
 		 */
 		if (isspace(*fmt)) {
-			fmt = skip_space(fmt);
-			str = skip_space(str);
+			fmt = skip_spaces(++fmt);
+			str = skip_spaces(str);
 		}
 
 		/* anything that is not a conversion must match exactly */
@@ -1812,7 +1805,7 @@ int vsscanf(const char *buf, const char *fmt, va_list args)
 			if (field_width == -1)
 				field_width = INT_MAX;
 			/* first, skip leading white space in buffer */
-			str = skip_space(str);
+			str = skip_spaces(str);
 
 			/* now copy until next white space */
 			while (*str && !isspace(*str) && field_width--)
@@ -1854,7 +1847,7 @@ int vsscanf(const char *buf, const char *fmt, va_list args)
 		/* have some sort of integer conversion.
 		 * first, skip white space in buffer.
 		 */
-		str = skip_space(str);
+		str = skip_spaces(str);
 
 		digit = *str;
 		if (is_sign && digit == '-')
diff --git a/net/irda/irnet/irnet.h b/net/irda/irnet/irnet.h
index b001c36..4300df3 100644
--- a/net/irda/irnet/irnet.h
+++ b/net/irda/irnet/irnet.h
@@ -249,6 +249,7 @@
 #include <linux/poll.h>
 #include <linux/capability.h>
 #include <linux/ctype.h>	/* isspace() */
+#include <linux/string.h>	/* skip_spaces() */
 #include <asm/uaccess.h>
 #include <linux/init.h>
 
diff --git a/net/irda/irnet/irnet_ppp.c b/net/irda/irnet/irnet_ppp.c
index 7dea882..156020d 100644
--- a/net/irda/irnet/irnet_ppp.c
+++ b/net/irda/irnet/irnet_ppp.c
@@ -76,9 +76,8 @@ irnet_ctrl_write(irnet_socket *	ap,
       /* Look at the next command */
       start = next;
 
-      /* Scrap whitespaces before the command */
-      while(isspace(*start))
-	start++;
+	/* Scrap whitespaces before the command */
+	start = skip_spaces(start);
 
       /* ',' is our command separator */
       next = strchr(start, ',');
@@ -133,8 +132,7 @@ irnet_ctrl_write(irnet_socket *	ap,
 	      char *	endp;
 
 	      /* Scrap whitespaces before the command */
-	      while(isspace(*begp))
-		begp++;
+	      begp = skip_spaces(begp);
 
 	      /* Convert argument to a number (last arg is the base) */
 	      addr = simple_strtoul(begp, &endp, 16);
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index eb0ceb8..fc70a49 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -482,8 +482,7 @@ static ssize_t recent_old_proc_write(struct file *file,
 	if (copy_from_user(buf, input, size))
 		return -EFAULT;
 
-	while (isspace(*c))
-		c++;
+	c = skip_spaces(c);
 
 	if (size - (c - buf) < 5)
 		return c - buf;
diff --git a/sound/pci/hda/hda_hwdep.c b/sound/pci/hda/hda_hwdep.c
index cc24e67..4e17b43 100644
--- a/sound/pci/hda/hda_hwdep.c
+++ b/sound/pci/hda/hda_hwdep.c
@@ -24,6 +24,7 @@
 #include <linux/compat.h>
 #include <linux/mutex.h>
 #include <linux/ctype.h>
+#include <linux/string.h>
 #include <linux/firmware.h>
 #include <sound/core.h>
 #include "hda_codec.h"
@@ -390,8 +391,7 @@ static int parse_hints(struct hda_codec *codec, const char *buf)
 	char *key, *val;
 	struct hda_hint *hint;
 
-	while (isspace(*buf))
-		buf++;
+	buf = skip_spaces(buf);
 	if (!*buf || *buf == '#' || *buf == '\n')
 		return 0;
 	if (*buf == '=')
@@ -406,8 +406,7 @@ static int parse_hints(struct hda_codec *codec, const char *buf)
 		return -EINVAL;
 	}
 	*val++ = 0;
-	while (isspace(*val))
-		val++;
+	val = skip_spaces(val);
 	remove_trail_spaces(key);
 	remove_trail_spaces(val);
 	hint = get_hint(codec, key);
-- 
1.6.5.2.180.gc5b3e.dirty

