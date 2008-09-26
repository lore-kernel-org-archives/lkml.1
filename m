Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbYIZSGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbYIZSGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 14:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326AbYIZSGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 14:06:07 -0400
Received: from mail.windriver.com ([147.11.1.11]:37179 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278AbYIZSGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 14:06:02 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 5/5] kgdboc,tty: Fix tty polling search to use name correctly
Date: Fri, 26 Sep 2008 13:05:20 -0500
Message-Id: <1222452320-16281-6-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.0.90.g436ed.dirty
In-Reply-To: <1222452320-16281-5-git-send-email-jason.wessel@windriver.com>
References: <1222452320-16281-1-git-send-email-jason.wessel@windriver.com>
 <1222452320-16281-2-git-send-email-jason.wessel@windriver.com>
 <1222452320-16281-3-git-send-email-jason.wessel@windriver.com>
 <1222452320-16281-4-git-send-email-jason.wessel@windriver.com>
 <1222452320-16281-5-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 26 Sep 2008 18:05:40.0190 (UTC) FILETIME=[7C29AFE0:01C92002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tty_find_polling_driver() routine did not correctly check the base
part of the tty name.  This can lead to kgdboc selecting an incorrect
driver, as well as accepting a completely invalid tty such as "echo
ffff0 > /sys/module/kgdboc/parameters/kgdboc".

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/char/tty_io.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index daeb8f7..e4dce87 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -695,13 +695,23 @@ struct tty_driver *tty_find_polling_driver(char *name, int *line)
 {
 	struct tty_driver *p, *res = NULL;
 	int tty_line = 0;
+	int len;
 	char *str;
 
+	for (str = name; *str; str++)
+		if ((*str >= '0' && *str <= '9') || *str == ',')
+			break;
+	if (!*str)
+		return NULL;
+
+	len = str - name;
+	tty_line = simple_strtoul(str, &str, 10);
+
 	mutex_lock(&tty_mutex);
 	/* Search through the tty devices to look for a match */
 	list_for_each_entry(p, &tty_drivers, tty_drivers) {
-		str = name + strlen(p->name);
-		tty_line = simple_strtoul(str, &str, 10);
+		if (strncmp(name, p->name, len) != 0)
+			continue;
 		if (*str == ',')
 			str++;
 		if (*str == '\0')
-- 
1.6.0.90.g436ed.dirty

