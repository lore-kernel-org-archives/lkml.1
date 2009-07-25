Return-Path: <linux-kernel-owner+w=401wt.eu-S1752289AbZGYTAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289AbZGYTAS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 15:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbZGYTAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 15:00:17 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:52140 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751996AbZGYTAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 15:00:16 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] hpfall: accept disk device to unload as argument
Date: Sat, 25 Jul 2009 21:00:12 +0200
User-Agent: KMail/1.9.9
Cc: Jiri Kosina <trivial@kernel.org>, Christian Thaeter <ct@pipapo.org>,
       Pavel Machek <pavel@ucw.cz>
References: <200907252055.16416.elendil@planet.nl>
In-Reply-To: <200907252055.16416.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907252100.14175.elendil@planet.nl>
X-OriginalArrivalTime: 25 Jul 2009 19:00:15.0159 (UTC) FILETIME=[24F2CC70:01CA0D5A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows users who use an IDE driver for their disk to use hpfall without
having to modify the source. By default /dev/sda is used.
Suggested by Christian Thaeter in http://lkml.org/lkml/2009/3/25/505.

While we're add it, improve error message if opening /dev/freefall fails.

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Christian Thaeter <ct@pipapo.org>

diff --git a/Documentation/hwmon/hpfall.c b/Documentation/hwmon/hpfall.c
index a3cfe1a..681ec22 100644
--- a/Documentation/hwmon/hpfall.c
+++ b/Documentation/hwmon/hpfall.c
@@ -19,6 +19,32 @@
 #include <sys/mman.h>
 #include <sched.h>
 
+char unload_heads_path[64];
+
+int set_unload_heads_path(char *device)
+{
+	char devname[64];
+
+	if (strlen(device) <= 5 || strncmp(device, "/dev/", 5) != 0)
+		return -EINVAL;
+	strncpy(devname, device + 5, sizeof(devname));
+
+	snprintf(unload_heads_path, sizeof(unload_heads_path),
+				"/sys/block/%s/device/unload_heads", devname);
+	return 0;
+}
+int valid_disk(void)
+{
+	int fd = open(unload_heads_path, O_RDONLY);
+	if (fd < 0) {
+		perror(unload_heads_path);
+		return 0;
+	}
+
+	close(fd);
+	return 1;
+}
+
 void write_int(char *path, int i)
 {
 	char buf[1024];
@@ -42,7 +68,7 @@ void set_led(int on)
 
 void protect(int seconds)
 {
-	write_int("/sys/block/sda/device/unload_heads", seconds*1000);
+	write_int(unload_heads_path, seconds*1000);
 }
 
 int on_ac(void)
@@ -61,14 +87,27 @@ void ignore_me(void)
 	set_led(0);
 }
 
-int main(int argc, char *argv[])
+int main(int argc, char **argv)
 {
 	int fd, ret;
 	struct sched_param param;
 
+	if (argc == 1)
+		ret = set_unload_heads_path("/dev/sda");
+	else if (argc == 2)
+		ret = set_unload_heads_path(argv[1]);
+	else
+		ret = -EINVAL;
+
+	if (ret || !valid_disk()) {
+		fprintf(stderr, "usage: %s <device> (default: /dev/sda)\n",
+				argv[0]);
+		exit(1);
+	}
+
 	fd = open("/dev/freefall", O_RDONLY);
 	if (fd < 0) {
-		perror("open");
+		perror("/dev/freefall");
 		return EXIT_FAILURE;
 	}
 
