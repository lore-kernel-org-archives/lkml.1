Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbYIGWia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbYIGWia (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 18:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbYIGWiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 18:38:22 -0400
Received: from gw.goop.org ([64.81.55.164]:55253 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504AbYIGWiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 18:38:21 -0400
Message-ID: <48C457DC.9050904@goop.org>
Date: Sun, 07 Sep 2008 15:38:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Rambaldi <rambaldi@xs4all.nl>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.27-rc5 xen balloon driver warnings
References: <48C0F09C.1000101@xs4all.nl>
In-Reply-To: <48C0F09C.1000101@xs4all.nl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rambaldi wrote:
> Hi,
>
> when running the 2.6.27-rc5 kernel as 64 bits dumU I get the following
> warnings:

This patch, change 167e6cf62979df03513898966f9227847d192327 in tip.git,
should fix this.  I'm not sure if the other sysfs changes apply to
mainline git or not.

Could you try this and see how it goes?  The first chunk should be
sufficient to fix your problem.

     J

Subject: xen-balloon: fix up sysfs issues

1. Set the class so it doesn't clash with the normal memory class
2. Fix up the sysfs show functions to match the new prototype
3. Clean up use of memparse

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: viets@work.de
Cc: Andi Kleen <andi@firstfloor.org>
---
 drivers/xen/balloon.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

===================================================================
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -60,7 +60,7 @@
 
 #define PAGES2KB(_p) ((_p)<<(PAGE_SHIFT-10))
 
-#define BALLOON_CLASS_NAME "memory"
+#define BALLOON_CLASS_NAME "xen_memory"
 
 struct balloon_stats {
 	/* We aim for 'current allocation' == 'target allocation'. */
@@ -588,12 +587,13 @@
 }
 
 
-#define BALLOON_SHOW(name, format, args...)			\
-	static ssize_t show_##name(struct sys_device *dev,	\
-				   char *buf)			\
-	{							\
-		return sprintf(buf, format, ##args);		\
-	}							\
+#define BALLOON_SHOW(name, format, args...)				\
+	static ssize_t show_##name(struct sys_device *dev,		\
+				   struct sysdev_attribute *attr,	\
+				   char *buf)				\
+	{								\
+		return sprintf(buf, format, ##args);			\
+	}								\
 	static SYSDEV_ATTR(name, S_IRUGO, show_##name, NULL)
 
 BALLOON_SHOW(current_kb, "%lu\n", PAGES2KB(balloon_stats.current_pages));
@@ -604,7 +604,8 @@
 	     (balloon_stats.hard_limit!=~0UL) ? PAGES2KB(balloon_stats.hard_limit) : 0);
 BALLOON_SHOW(driver_kb, "%lu\n", PAGES2KB(balloon_stats.driver_pages));
 
-static ssize_t show_target_kb(struct sys_device *dev, char *buf)
+static ssize_t show_target_kb(struct sys_device *dev, struct sysdev_attribute *attr,
+			      char *buf)
 {
 	return sprintf(buf, "%lu\n", PAGES2KB(balloon_stats.target_pages));
 }
@@ -614,19 +615,14 @@
 			       const char *buf,
 			       size_t count)
 {
-	char memstring[64], *endchar;
+	char *endchar;
 	unsigned long long target_bytes;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (count <= 1)
-		return -EBADMSG; /* runt */
-	if (count > sizeof(memstring))
-		return -EFBIG;   /* too long */
-	strcpy(memstring, buf);
+	target_bytes = memparse(buf, &endchar);
 
-	target_bytes = memparse(memstring, &endchar);
 	balloon_set_new_target(target_bytes >> PAGE_SHIFT);
 
 	return count;



