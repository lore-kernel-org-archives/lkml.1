Return-Path: <linux-kernel-owner+w=401wt.eu-S1758085AbZBJTTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085AbZBJTTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755957AbZBJTER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:04:17 -0500
Received: from kroah.org ([198.145.64.141]:54111 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754574AbZBJTEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:04:13 -0500
Date: Tue, 10 Feb 2009 11:01:21 -0800
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
       alan@lxorguk.ukuu.org.uk, Zhang Rui <rui.zhang@intel.com>,
       Len Brown <len.brown@intel.com>, Thomas Renninger <trenn@suse.de>
Subject: [patch 43/53] ACPI: video: Fix reversed brightness behavior on
	ThinkPad SL series
Message-ID: <20090210190121.GR14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-video-fix-reversed-brightness-behavior-on-thinkpad-sl-series.patch"
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Zhang Rui <rui.zhang@intel.com>

commit 935e5f290ec1eb0f1c15004421f5fd3154380fd5 upstream.

Section B.6.2 of ACPI 3.0b specification that defines _BCL method
doesn't require the brightness levels returned to be sorted.
At least ThinkPad SL300 (and probably all IdeaPads) returns the
array reversed (i.e. bightest levels have lowest indexes), which
causes the brightness management behave in completely reversed
manner on these machines (brightness increases when the laptop is
idle, while the display dims when used).

Sorting the array by brightness level values after reading the list
fixes the issue.

http://bugzilla.kernel.org/show_bug.cgi?id=12037

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Tested-by: Lubomir Rintel <lkundrak@v3.sk>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/video.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -36,6 +36,7 @@
 #include <linux/backlight.h>
 #include <linux/thermal.h>
 #include <linux/video_output.h>
+#include <linux/sort.h>
 #include <asm/uaccess.h>
 
 #include <acpi/acpi_bus.h>
@@ -631,6 +632,16 @@ acpi_video_bus_DOS(struct acpi_video_bus
 }
 
 /*
+ * Simple comparison function used to sort backlight levels.
+ */
+
+static int
+acpi_video_cmp_level(const void *a, const void *b)
+{
+	return *(int *)a - *(int *)b;
+}
+
+/*
  *  Arg:	
  *  	device	: video output device (LCD, CRT, ..)
  *
@@ -681,6 +692,10 @@ acpi_video_init_brightness(struct acpi_v
 		count++;
 	}
 
+	/* don't sort the first two brightness levels */
+	sort(&br->levels[2], count - 2, sizeof(br->levels[2]),
+		acpi_video_cmp_level, NULL);
+
 	if (count < 2)
 		goto out_free_levels;
 

