Return-Path: <linux-kernel-owner+w=401wt.eu-S932820AbZHDKze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820AbZHDKze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 06:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932778AbZHDKzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 06:55:32 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:40633 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932599AbZHDKz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 06:55:28 -0400
Subject: gpiolib: add export/unexport by gpio name
Message-Id: <20090804105459.960604743@fluff.org>
User-Agent: quilt/0.46-1
From: ben@fluff.org
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: David Brownell <dbrownell@users.sourceforge.net>
Content-Disposition: inline; filename=gpio-export-by-name.patch
Date: Tue, 04 Aug 2009 11:55:00 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the facility to export/unexport a gpio by the name assigned to it
as well as the number.

Signed-off-by: Ben Dooks <ben@simtec.co.uk>
Cc: David Brownell <dbrownell@users.sourceforge.net>

---
 drivers/gpio/gpiolib.c |   70 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 66 insertions(+), 4 deletions(-)

Index: b/drivers/gpio/gpiolib.c
===================================================================
--- a/drivers/gpio/gpiolib.c	2009-08-04 11:53:53.000000000 +0100
+++ b/drivers/gpio/gpiolib.c	2009-08-04 11:54:12.000000000 +0100
@@ -364,6 +364,64 @@ static const struct attribute_group gpio
 	.attrs = (struct attribute **) gpiochip_attrs,
 };
 
+static int search_names(char **names, const char *match, int ngpio)
+{
+	int len = strlen(match);
+	char *m;
+	int ptr;
+
+	/* if cr terminated, remove */
+	if (match[len-1] == '\n')
+		len--;
+
+	if (names) {
+		for (ptr = 0; ptr < ngpio; ptr++) {
+			m = names[ptr];
+			if (!m)
+				continue;
+
+			if (strlen(m) != len)
+				continue;
+
+			if (strncmp(m, match, len) == 0)
+				return ptr;
+		}
+	}
+
+	return -ENOENT;
+}
+
+static long gpio_from_string(const char *buf)
+{
+	struct gpio_chip *chip;
+	struct gpio_desc *desc;
+	long status;
+	long gpio;
+	int ptr, off;
+
+	status = strict_strtol(buf, 0, &gpio);
+	if (status < 0) {
+		for (ptr = 0; ptr < ARCH_NR_GPIOS && status < 0;) {
+			desc = gpio_desc + ptr;
+			chip = desc->chip;
+
+			if (!chip) {
+				ptr++;
+				continue;
+			}
+
+			off = search_names(chip->names, buf, chip->ngpio);
+			if (off >= 0)
+				status = ptr + off;
+
+			ptr += chip->ngpio;
+		}
+	} else
+		status = gpio;
+
+	return status;
+}
+
 /*
  * /sys/class/gpio/export ... write-only
  *	integer N ... number of GPIO to export (full access)
@@ -375,9 +433,11 @@ static ssize_t export_store(struct class
 	long	gpio;
 	int	status;
 
-	status = strict_strtol(buf, 0, &gpio);
-	if (status < 0)
+	gpio = gpio_from_string(buf);
+	if (gpio < 0) {
+		status = gpio;
 		goto done;
+	}
 
 	/* No extra locking here; FLAG_SYSFS just signifies that the
 	 * request and export were done by on behalf of userspace, so
@@ -405,9 +465,11 @@ static ssize_t unexport_store(struct cla
 	long	gpio;
 	int	status;
 
-	status = strict_strtol(buf, 0, &gpio);
-	if (status < 0)
+	gpio = gpio_from_string(buf);
+	if (gpio < 0) {
+		status = gpio;
 		goto done;
+	}
 
 	status = -EINVAL;
 

-- 
