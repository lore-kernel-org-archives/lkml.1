Return-Path: <linux-kernel-owner+w=401wt.eu-S1754380AbYKVUaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbYKVUaZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 15:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYKVUaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 15:30:11 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48413 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbYKVUaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 15:30:10 -0500
Date: Sat, 22 Nov 2008 21:31:51 +0100
From: Pavel Machek <pavel@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Subject: Re: backlight: catch invalid input
Message-ID: <20081122203151.GA1856@elf.ucw.cz>
References: <20081121111414.GA1455@elf.ucw.cz> <20081121155421.152cc555.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121155421.152cc555.akpm@linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew hinted that strict_strtoul is right fix. Check input properly
in backlight, echo > brightness should not turn off the backlight.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index 5c2e23d..e4c93fc 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -80,22 +80,18 @@ static ssize_t backlight_show_power(stru
 static ssize_t backlight_store_power(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
-	int rc = -ENXIO;
-	char *endp;
+	int rc;
 	struct backlight_device *bd = to_backlight_device(dev);
-	int power = simple_strtoul(buf, &endp, 0);
-	size_t size = endp - buf;
+	unsigned long power;
 
-	if (!size)
-		return -EINVAL;
-	if (*endp && isspace(*endp))
-		size++;
-	if (size != count)
-		return -EINVAL;
+	rc = strict_strtoul(buf, 0, &power);
+	if (rc)
+		return rc;
 
+	rc = -ENXIO;
 	mutex_lock(&bd->ops_lock);
 	if (bd->ops) {
-		pr_debug("backlight: set power to %d\n", power);
+		pr_debug("backlight: set power to %lu\n", power);
 		if (bd->props.power != power) {
 			bd->props.power = power;
 			backlight_update_status(bd);
@@ -118,23 +114,22 @@ static ssize_t backlight_show_brightness
 static ssize_t backlight_store_brightness(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
-	int rc = -ENXIO;
-	char *endp;
+	int rc;
 	struct backlight_device *bd = to_backlight_device(dev);
-	int brightness = simple_strtoul(buf, &endp, 0);
-	size_t size = endp - buf;
+	unsigned long brightness;
+
+ 	rc = strict_strtoul(buf, 0, &brightness);
+	if (rc)
+		return rc;
 
-	if (*endp && isspace(*endp))
-		size++;
-	if (size != count)
-		return -EINVAL;
+	rc = -ENXIO;
 
 	mutex_lock(&bd->ops_lock);
 	if (bd->ops) {
 		if (brightness > bd->props.max_brightness)
 			rc = -EINVAL;
 		else {
-			pr_debug("backlight: set brightness to %d\n",
+			pr_debug("backlight: set brightness to %lu\n",
 				 brightness);
 			if (bd->props.brightness != brightness) {
 				bd->props.brightness = brightness;


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
