Return-Path: <linux-kernel-owner+w=401wt.eu-S2992885AbXDYSl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992885AbXDYSl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 14:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992894AbXDYSl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 14:41:28 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:53294 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992893AbXDYSl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 14:41:27 -0400
Message-ID: <462FA0D0.9040901@simon.arlott.org.uk>
Date: Wed, 25 Apr 2007 19:41:20 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Duncan Sands <duncan.sands@math.u-psud.fr>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH (rev 2)] cxacru: Cleanup sysfs attribute code
References: <462E730F.3090401@simon.arlott.org.uk>    <200704250919.50382.duncan.sands@math.u-psud.fr> <11882.simon.1177499883@5ec7c279.invalid>
In-Reply-To: <11882.simon.1177499883@5ec7c279.invalid>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This changes the format of unknown status values to be less verbose and 
uses an array instead of several different snprintf calls. Since only 
enum values are assigned to it, poll_state is changed from int to enum. 
Use abs() for dB values instead of two almost identical return lines.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Duncan Sands <duncan.sands@math.u-psud.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
Patch depends on existing cxacru patches in -rc7-mm.

On 25/04/07 12:18, Simon Arlott wrote:
> On Wed, April 25, 2007 08:19, Duncan Sands wrote:
>>>  static ssize_t cxacru_sysfs_showattr_dB(s16 value, char *buf)
>>>  {
>>> +	return snprintf(buf, PAGE_SIZE, "%u.%02u\n",
>>> +					value / 100, abs(value) % 100);
>> shouldn't this be "%d.%02u\n"?

I've updated the patch to fix this... I wasn't thinking properly when 
I changed that to %u.

 drivers/usb/atm/cxacru.c |   73 +++++++++++++++++++--------------------------
 1 files changed, 31 insertions(+), 42 deletions(-)

diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index 0c47755..d53de3c 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -171,7 +171,7 @@ struct cxacru_data {
 	struct delayed_work poll_work;
 	u32 card_info[CXINF_MAX];
 	struct mutex poll_state_serialize;
-	int poll_state;
+	enum cxacru_poll_state poll_state;
 
 	/* contol handles */
 	struct mutex cm_serialize;
@@ -226,58 +226,48 @@ static ssize_t cxacru_sysfs_showattr_s8(s8 value, char *buf)
 
 static ssize_t cxacru_sysfs_showattr_dB(s16 value, char *buf)
 {
-	if (unlikely(value < 0)) {
-		return snprintf(buf, PAGE_SIZE, "%d.%02u\n",
-						value / 100, -value % 100);
-	} else {
-		return snprintf(buf, PAGE_SIZE, "%d.%02u\n",
-						value / 100, value % 100);
-	}
+	return snprintf(buf, PAGE_SIZE, "%d.%02u\n",
+					value / 100, abs(value) % 100);
 }
 
 static ssize_t cxacru_sysfs_showattr_bool(u32 value, char *buf)
 {
-	switch (value) {
-	case 0: return snprintf(buf, PAGE_SIZE, "no\n");
-	case 1: return snprintf(buf, PAGE_SIZE, "yes\n");
-	default: return 0;
-	}
+	static char *str[] = { "no", "yes" };
+	if (unlikely(value >= ARRAY_SIZE(str)))
+		return snprintf(buf, PAGE_SIZE, "%u\n", value);
+	return snprintf(buf, PAGE_SIZE, "%s\n", str[value]);
 }
 
 static ssize_t cxacru_sysfs_showattr_LINK(u32 value, char *buf)
 {
-	switch (value) {
-	case 1: return snprintf(buf, PAGE_SIZE, "not connected\n");
-	case 2: return snprintf(buf, PAGE_SIZE, "connected\n");
-	case 3: return snprintf(buf, PAGE_SIZE, "lost\n");
-	default: return snprintf(buf, PAGE_SIZE, "unknown (%u)\n", value);
-	}
+	static char *str[] = { NULL, "not connected", "connected", "lost" };
+	if (unlikely(value >= ARRAY_SIZE(str) || str[value] == NULL))
+		return snprintf(buf, PAGE_SIZE, "%u\n", value);
+	return snprintf(buf, PAGE_SIZE, "%s\n", str[value]);
 }
 
 static ssize_t cxacru_sysfs_showattr_LINE(u32 value, char *buf)
 {
-	switch (value) {
-	case 0: return snprintf(buf, PAGE_SIZE, "down\n");
-	case 1: return snprintf(buf, PAGE_SIZE, "attempting to activate\n");
-	case 2: return snprintf(buf, PAGE_SIZE, "training\n");
-	case 3: return snprintf(buf, PAGE_SIZE, "channel analysis\n");
-	case 4: return snprintf(buf, PAGE_SIZE, "exchange\n");
-	case 5: return snprintf(buf, PAGE_SIZE, "up\n");
-	case 6: return snprintf(buf, PAGE_SIZE, "waiting\n");
-	case 7: return snprintf(buf, PAGE_SIZE, "initialising\n");
-	default: return snprintf(buf, PAGE_SIZE, "unknown (%u)\n", value);
-	}
+	static char *str[] = { "down", "attempting to activate",
+		"training", "channel analysis", "exchange", "up",
+		"waiting", "initialising"
+	};
+	if (unlikely(value >= ARRAY_SIZE(str)))
+		return snprintf(buf, PAGE_SIZE, "%u\n", value);
+	return snprintf(buf, PAGE_SIZE, "%s\n", str[value]);
 }
 
 static ssize_t cxacru_sysfs_showattr_MODU(u32 value, char *buf)
 {
-	switch (value) {
-	case 0: return 0;
-	case 1: return snprintf(buf, PAGE_SIZE, "ANSI T1.413\n");
-	case 2: return snprintf(buf, PAGE_SIZE, "ITU-T G.992.1 (G.DMT)\n");
-	case 3: return snprintf(buf, PAGE_SIZE, "ITU-T G.992.2 (G.LITE)\n");
-	default: return snprintf(buf, PAGE_SIZE, "unknown (%u)\n", value);
-	}
+	static char *str[] = {
+			NULL,
+			"ANSI T1.413",
+			"ITU-T G.992.1 (G.DMT)",
+			"ITU-T G.992.2 (G.LITE)"
+	};
+	if (unlikely(value >= ARRAY_SIZE(str) || str[value] == NULL))
+		return snprintf(buf, PAGE_SIZE, "%u\n", value);
+	return snprintf(buf, PAGE_SIZE, "%s\n", str[value]);
 }
 
 /*
@@ -308,11 +298,10 @@ static ssize_t cxacru_sysfs_show_adsl_state(struct device *dev,
 	struct cxacru_data *instance = usbatm_instance->driver_data;
 	u32 value = instance->card_info[CXINF_LINE_STARTABLE];
 
-	switch (value) {
-	case 0: return snprintf(buf, PAGE_SIZE, "running\n");
-	case 1: return snprintf(buf, PAGE_SIZE, "stopped\n");
-	default: return snprintf(buf, PAGE_SIZE, "unknown (%u)\n", value);
-	}
+	static char *str[] = { "running", "stopped" };
+	if (unlikely(value >= ARRAY_SIZE(str)))
+		return snprintf(buf, PAGE_SIZE, "%u\n", value);
+	return snprintf(buf, PAGE_SIZE, "%s\n", str[value]);
 }
 
 static ssize_t cxacru_sysfs_store_adsl_state(struct device *dev,
-- 
1.5.0.1

-- 
Simon Arlott
