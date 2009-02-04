Return-Path: <linux-kernel-owner+w=401wt.eu-S1760972AbZBDSrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760972AbZBDSrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756372AbZBDShi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:37:38 -0500
Received: from kroah.org ([198.145.64.141]:51202 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758567AbZBDShZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:37:25 -0500
Date: Wed, 4 Feb 2009 10:35:10 -0800
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
       alan@lxorguk.ukuu.org.uk, Matthew Garrett <mjg59@srcf.ucam.org>,
       Len Brown <len.brown@intel.com>, Thomas Renninger <trenn@suse.de>
Subject: [patch 28/33] video: always update the brightness when poking
	"brightness"
Message-ID: <20090204183510.GC13936@kroah.com>
References: <20090204182823.831027530@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="video-always-update-the-brightness-when-poking-brightness.patch"
In-Reply-To: <20090204183403.GA13936@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

commit 9e6dada9d255497127251c03aaa59296d186f959 upstream.

always update props.brightness no matter the backlight is changed
via procfs, hotkeys or sysfs.

Sighed-off-by: Zhang Rui <rui.zhang@intel.com>
Acked-by: Matthew Garrett <mjg59@srcf.ucam.org>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/video.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -481,6 +481,7 @@ acpi_video_device_lcd_set_level(struct a
 	int status = AE_OK;
 	union acpi_object arg0 = { ACPI_TYPE_INTEGER };
 	struct acpi_object_list args = { 1, &arg0 };
+	int state;
 
 
 	arg0.integer.value = level;
@@ -489,6 +490,10 @@ acpi_video_device_lcd_set_level(struct a
 		status = acpi_evaluate_object(device->dev->handle, "_BCM",
 					      &args, NULL);
 	device->brightness->curr = level;
+	for (state = 2; state < device->brightness->count; state++)
+		if (level == device->brightness->levels[state])
+			device->backlight->props.brightness = state - 2;
+
 	return status;
 }
 

