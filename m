Return-Path: <linux-kernel-owner+w=401wt.eu-S1753387AbZASOzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbZASOzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:55:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756669AbZASOwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:52:09 -0500
Received: from mailer2.option.com ([81.246.70.163]:44291 "EHLO
	mailer2.option.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760050AbZASOwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:52:05 -0500
X-Greylist: delayed 606 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Jan 2009 09:52:04 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AigBAMsfdEkKAAAZ/2dsb2JhbAAI0U+Fcw
Message-ID: <49749133.1020904@option.com>
Date: Mon, 19 Jan 2009 15:41:55 +0100
From: Denis Joseph Barrow <D.Barow@option.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] gdb serial debugging appears be broken since at least 2.6.28-rc6
 by tty layer now hopefully fixed
Content-Type: multipart/mixed;
 boundary="------------070307090607060204080900"
X-OriginalArrivalTime: 19 Jan 2009 14:41:55.0409 (UTC) FILETIME=[13216410:01C97A44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070307090607060204080900
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi all
I mailed this patch to linux-serial@vger.kernel.org & kgdb-bugreport@lists.sourceforge.net
but I received no comment on it one way or the other the patch is neccessary to get kgdb going
over the serial port.

I changed the code back to something it was like in 2.6.27-rc6 & it now works again.

Changed tty_find_polling driver back to something
close to 2.6.27-rc6 the new stuff broke kgdb when
used with the usual kgdboc=/dev/ttyS0,115200 parameter & similar.
Signed-off-by: Denis Joseph Barrow <D.Barow@option.com>
---Index: linux-2.6/drivers/char/tty_io.c
===================================================================
Index: linux-2.6/drivers/char/tty_io.c
===================================================================
--- linux-2.6.orig/drivers/char/tty_io.c	2009-01-16 16:41:41.000000000 +0100
+++ linux-2.6/drivers/char/tty_io.c	2009-01-16 16:43:59.000000000 +0100
@@ -294,23 +294,13 @@
 {
 	struct tty_driver *p, *res = NULL;
 	int tty_line = 0;
-	int len;
 	char *str;
 
-	for (str = name; *str; str++)
-		if ((*str >= '0' && *str <= '9') || *str == ',')
-			break;
-	if (!*str)
-		return NULL;
-
-	len = str - name;
-	tty_line = simple_strtoul(str, &str, 10);
-
 	mutex_lock(&tty_mutex);
 	/* Search through the tty devices to look for a match */
 	list_for_each_entry(p, &tty_drivers, tty_drivers) {
-		if (strncmp(name, p->name, len) != 0)
-			continue;
+		str = name + strlen(p->name);
+		tty_line = simple_strtoul(str, &str, 10);
 		if (*str == ',')
 			str++;
 		if (*str == '\0')


best regards,
D.J. Barrow

Linux Kernel Developer
Option NV, Gaston Geenslaan 14, 3001 Leuven, Belgium
 
T: +32 16 311 621
F: +32 16 207 164
d.barow@option.com
www.option.com

Disclaimer:
http://www.option.com/company/disclaimer.shtml


-- 
best regards,
D.J. Barrow

Linux Kernel Developer
Option NV, Gaston Geenslaan 14, 3001 Leuven, Belgium
 
T: +32 16 311 621
F: +32 16 207 164
d.barow@option.com
www.option.com

Disclaimer:
http://www.option.com/company/disclaimer.shtml

--------------070307090607060204080900
Content-Type: text/x-diff;
 name="tty_io_kgdbdoc_fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="tty_io_kgdbdoc_fix.patch"

Changed tty_find_polling driver back to something
close to 2.6.27-rc6 the new stuff broke kgdb when
used with the usual kgdboc=/dev/ttyS0,115200 parameter & similar.
Signed-off-by: Denis Joseph Barrow <D.Barow@option.com>
---Index: linux-2.6/drivers/char/tty_io.c
===================================================================
Index: linux-2.6/drivers/char/tty_io.c
===================================================================
--- linux-2.6.orig/drivers/char/tty_io.c	2009-01-16 16:41:41.000000000 +0100
+++ linux-2.6/drivers/char/tty_io.c	2009-01-16 16:43:59.000000000 +0100
@@ -294,23 +294,13 @@
 {
 	struct tty_driver *p, *res = NULL;
 	int tty_line = 0;
-	int len;
 	char *str;
 
-	for (str = name; *str; str++)
-		if ((*str >= '0' && *str <= '9') || *str == ',')
-			break;
-	if (!*str)
-		return NULL;
-
-	len = str - name;
-	tty_line = simple_strtoul(str, &str, 10);
-
 	mutex_lock(&tty_mutex);
 	/* Search through the tty devices to look for a match */
 	list_for_each_entry(p, &tty_drivers, tty_drivers) {
-		if (strncmp(name, p->name, len) != 0)
-			continue;
+		str = name + strlen(p->name);
+		tty_line = simple_strtoul(str, &str, 10);
 		if (*str == ',')
 			str++;
 		if (*str == '\0')


--------------070307090607060204080900--
