Return-Path: <linux-kernel-owner+w=401wt.eu-S1759611AbZBKAhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759611AbZBKAhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:37:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757746AbZBKA2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:28:31 -0500
Received: from kroah.org ([198.145.64.141]:51247 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757700AbZBKA22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:28:28 -0500
Date: Tue, 10 Feb 2009 16:25:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Zhao Yakui <yakui.zhao@intel.com>,
       Len Brown <len.brown@intel.com>
Subject: [patch 26/56] ACPI: Skip the first two elements in the _BCL package
Message-ID: <20090211002508.GA14660@kroah.com>
References: <20090211001439.873435357@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-skip-the-first-two-elements-in-the-_bcl-package.patch"
In-Reply-To: <20090211002328.GA14660@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Zhao Yakui <yakui.zhao@intel.com>

commit 0a3db1cec5d476804185114ff5d1845aed3936b3 upstream.

According to the Spec the first two elements in the _BCL package won't be

regarded as the available brightness level. The first is the brightness when
full power is connected to the box(It means that the AC adapter is plugged).
The second is the brightness level when the box is on battery.
    If the first two elements are still used while finding the next brightness
level, it will fall back to the lowest level when keeping on pressing
hotkey. (On some boxes the brightness will be changed twice when hotkey is
pressed once. One is in the ACPI video driver. The other is changed by sys I/F.
In the ACPI video driver the first two elements will be used while changing
the brightness. But the first two elements is skipped while using sys I/F.
In such case there exists the inconsistency).
    So he first two elements had better be skipped while showing the available
brightness or finding the next brightness level.

http://bugzilla.kernel.org/show_bug.cgi?id=12450

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/video.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -997,7 +997,7 @@ acpi_video_device_brightness_seq_show(st
 	}
 
 	seq_printf(seq, "levels: ");
-	for (i = 0; i < dev->brightness->count; i++)
+	for (i = 2; i < dev->brightness->count; i++)
 		seq_printf(seq, " %d", dev->brightness->levels[i]);
 	seq_printf(seq, "\ncurrent: %d\n", dev->brightness->curr);
 
@@ -1036,7 +1036,7 @@ acpi_video_device_write_brightness(struc
 		return -EFAULT;
 
 	/* validate through the list of available levels */
-	for (i = 0; i < dev->brightness->count; i++)
+	for (i = 2; i < dev->brightness->count; i++)
 		if (level == dev->brightness->levels[i]) {
 			if (ACPI_SUCCESS
 			    (acpi_video_device_lcd_set_level(dev, level)))
@@ -1689,7 +1689,7 @@ acpi_video_get_next_level(struct acpi_vi
 	max = max_below = 0;
 	min = min_above = 255;
 	/* Find closest level to level_current */
-	for (i = 0; i < device->brightness->count; i++) {
+	for (i = 2; i < device->brightness->count; i++) {
 		l = device->brightness->levels[i];
 		if (abs(l - level_current) < abs(delta)) {
 			delta = l - level_current;
@@ -1699,7 +1699,7 @@ acpi_video_get_next_level(struct acpi_vi
 	}
 	/* Ajust level_current to closest available level */
 	level_current += delta;
-	for (i = 0; i < device->brightness->count; i++) {
+	for (i = 2; i < device->brightness->count; i++) {
 		l = device->brightness->levels[i];
 		if (l < min)
 			min = l;

