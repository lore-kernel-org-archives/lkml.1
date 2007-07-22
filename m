Return-Path: <linux-kernel-owner+w=401wt.eu-S1762838AbXGVStr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762838AbXGVStr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 14:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759661AbXGVStj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 14:49:39 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:35544
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757922AbXGVSti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 14:49:38 -0400
Date: Sun, 22 Jul 2007 20:51:28 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 2/5] kernel/time/clocksource.c: Use list_for_each_entry instead of list_for_each
Message-ID: <20070722185128.GH27415@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070722184202.GF27415@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070722184202.GF27415@traven>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/time/clocksource.c: Convert list_for_each to
list_for_each_entry in clocksource_resume(),
sysfs_override_clocksource() and show_available_clocksources()

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 51b6a6a..c8a9d13 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -207,15 +207,12 @@ static inline void clocksource_resume_watchdog(void) { }
  */
 void clocksource_resume(void)
 {
-	struct list_head *tmp;
+	struct clocksource *cs;
 	unsigned long flags;
 
 	spin_lock_irqsave(&clocksource_lock, flags);
 
-	list_for_each(tmp, &clocksource_list) {
-		struct clocksource *cs;
-
-		cs = list_entry(tmp, struct clocksource, list);
+	list_for_each_entry(cs, &clocksource_list, list) {
 		if (cs->resume)
 			cs->resume();
 	}
@@ -369,7 +366,6 @@ static ssize_t sysfs_override_clocksource(struct sys_device *dev,
 					  const char *buf, size_t count)
 {
 	struct clocksource *ovr = NULL;
-	struct list_head *tmp;
 	size_t ret = count;
 	int len;
 
@@ -389,12 +385,11 @@ static ssize_t sysfs_override_clocksource(struct sys_device *dev,
 
 	len = strlen(override_name);
 	if (len) {
+		struct clocksource *cs;
+
 		ovr = clocksource_override;
 		/* try to select it: */
-		list_for_each(tmp, &clocksource_list) {
-			struct clocksource *cs;
-
-			cs = list_entry(tmp, struct clocksource, list);
+		list_for_each_entry(cs, &clocksource_list, list) {
 			if (strlen(cs->name) == len &&
 			    !strcmp(cs->name, override_name))
 				ovr = cs;
@@ -422,14 +417,11 @@ static ssize_t sysfs_override_clocksource(struct sys_device *dev,
 static ssize_t
 sysfs_show_available_clocksources(struct sys_device *dev, char *buf)
 {
-	struct list_head *tmp;
+	struct clocksource *src;
 	char *curr = buf;
 
 	spin_lock_irq(&clocksource_lock);
-	list_for_each(tmp, &clocksource_list) {
-		struct clocksource *src;
-
-		src = list_entry(tmp, struct clocksource, list);
+	list_for_each_entry(src, &clocksource_list, list) {
 		curr += sprintf(curr, "%s ", src->name);
 	}
 	spin_unlock_irq(&clocksource_lock);

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

     The assumption that what currently exists must necessarily
      exist is the acid that corrodes all visionary thinking
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
