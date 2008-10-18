Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbYJRTSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbYJRTSk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbYJRTFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:05:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:47791 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbYJRTFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:05:39 -0400
Date: Sat, 18 Oct 2008 11:48:21 -0700
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
       linux-acpi@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
       Andi Kleen <ak@linux.intel.com>, Len Brown <lenb@kernel.org>
Subject: [patch 24/26] ACPI: Ignore _BQC object when registering backlight
	device
Message-ID: <20081018184821.GY301@suse.de>
References: <20081018183853.004667035@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-ignore-_bqc-object-when-registering-backlight-device.patch"
In-Reply-To: <20081018184708.GA301@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Zhao Yakui <yakui.zhao@intel.com>

upstream commmit: c2c789057f075022658b38b498755c29c1ba8055

According to acpi spec , the objectes of  _BCL and _BCM are required if
integrated LCD is present and supports brightness level and the _BQC is
the optional object. So the _BQC object will be ignored when the backlight
device is registered.
At the same time when there is no _BQC object, the current brightness will be
set to the maximum.

http://bugzilla.kernel.org/show_bug.cgi?id=10206

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Zhang Rui  <rui.zhang@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/video.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -720,7 +720,7 @@ static void acpi_video_device_find_cap(s
 
 	kfree(obj);
 
-	if (device->cap._BCL && device->cap._BCM && device->cap._BQC && max_level > 0){
+	if (device->cap._BCL && device->cap._BCM && max_level > 0) {
 		int result;
 		static int count = 0;
 		char *name;
@@ -732,7 +732,17 @@ static void acpi_video_device_find_cap(s
 		device->backlight = backlight_device_register(name,
 			NULL, device, &acpi_backlight_ops);
 		device->backlight->props.max_brightness = device->brightness->count-3;
-		device->backlight->props.brightness = acpi_video_get_brightness(device->backlight);
+		/*
+		 * If there exists the _BQC object, the _BQC object will be
+		 * called to get the current backlight brightness. Otherwise
+		 * the brightness will be set to the maximum.
+		 */
+		if (device->cap._BQC)
+			device->backlight->props.brightness =
+				acpi_video_get_brightness(device->backlight);
+		else
+			device->backlight->props.brightness =
+				device->backlight->props.max_brightness;
 		backlight_update_status(device->backlight);
 		kfree(name);
 

-- 
