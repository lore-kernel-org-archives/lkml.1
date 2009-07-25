Return-Path: <linux-kernel-owner+w=401wt.eu-S1752438AbZGYSzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbZGYSzT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 14:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbZGYSzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 14:55:18 -0400
Received: from cpsmtpm-eml103.kpnxchange.com ([195.121.3.7]:59536 "EHLO
	CPSMTPM-EML103.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751652AbZGYSzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 14:55:17 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] hpfall: reduce risk that hpfall can do harm
Date: Sat, 25 Jul 2009 20:55:15 +0200
User-Agent: KMail/1.9.9
Cc: Jiri Kosina <trivial@kernel.org>, Christian Thaeter <ct@pipapo.org>,
       Pavel Machek <pavel@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907252055.16416.elendil@planet.nl>
X-OriginalArrivalTime: 25 Jul 2009 18:55:17.0227 (UTC) FILETIME=[735DFBB0:01CA0D59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Thaeter <ct@pipapo.org>

Improve the example code to be at least useable, as in not causing
harm (as shown below). Code can still be improved further, but this
adds some basic safeguards.

1. hpfall *MUST* mlockall(MCL_CURRENT|MCL_FUTURE); itself!
Since the Program sits and waits most of the time it becomes very likely
swapped out. If it gets woken up when the laptop drops from the table
while it is swapped out it actually triggers harddrive activity!

2. Daemonize hpfall using 'daemon(0,0)' (quick and dirty).

3. Give hpfall realtime priority.
Should give a chance that it has less latency when woken up.

Signed-off-by: Christian Thaeter <ct@pipapo.org>
Signed-off-by: Frans Pop <elendil@planet.nl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---

This patch was posted some time back by Christian and acked by Pavel, but
was never picked up: http://lkml.org/lkml/2009/3/25/505.
All I've done is cleaned up whitespace and the commit message.

The patch is on top of my patch to clean up checkpatch errors which is
already in the trivial tree for .32. As this is only example code, I guess
this could go through trivial too.


diff --git a/Documentation/hwmon/hpfall.c b/Documentation/hwmon/hpfall.c
index d2f6711..a3cfe1a 100644
--- a/Documentation/hwmon/hpfall.c
+++ b/Documentation/hwmon/hpfall.c
@@ -16,6 +16,8 @@
 #include <stdint.h>
 #include <errno.h>
 #include <signal.h>
+#include <sys/mman.h>
+#include <sched.h>
 
 void write_int(char *path, int i)
 {
@@ -62,6 +64,7 @@ void ignore_me(void)
 int main(int argc, char *argv[])
 {
 	int fd, ret;
+	struct sched_param param;
 
 	fd = open("/dev/freefall", O_RDONLY);
 	if (fd < 0) {
@@ -69,6 +72,11 @@ int main(int argc, char *argv[])
 		return EXIT_FAILURE;
 	}
 
+	daemon(0, 0);
+	param.sched_priority = sched_get_priority_max(SCHED_FIFO);
+	sched_setscheduler(0, SCHED_FIFO, &param);
+	mlockall(MCL_CURRENT|MCL_FUTURE);
+
 	signal(SIGALRM, ignore_me);
 
 	for (;;) {
