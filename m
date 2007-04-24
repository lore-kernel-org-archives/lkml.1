Return-Path: <linux-kernel-owner+w=401wt.eu-S965407AbXDXVON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965407AbXDXVON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 17:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965472AbXDXVON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 17:14:13 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:57785 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965407AbXDXVN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 17:13:56 -0400
Message-ID: <462E730F.3090401@simon.arlott.org.uk>
Date: Tue, 24 Apr 2007 22:13:51 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
       Duncan Sands <duncan.sands@math.u-psud.fr>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] cxacru: Cleanup sysfs attribute code
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

On 27/02/07 20:26, Andrew Morton wrote:
>> +static ssize_t cxacru_sysfs_showattr_MODU(u32 value, char *buf)
>> +{
>> +	switch (value) {
>> +	case 0: return 0;
>> +	case 1: return snprintf(buf, PAGE_SIZE, "ANSI T1.413\n");
>> +	case 2: return snprintf(buf, PAGE_SIZE, "ITU-T G.992.1 (G.DMT)\n");
>> +	case 3: return snprintf(buf, PAGE_SIZE, "ITU-T G.992.2 (G.LITE)\n");
>> +	default: return snprintf(buf, PAGE_SIZE, "unknown (%u)\n", value);
>> +	}
>> +}
>  
> It is conventional to do
> 
> 	switch (a) {
> 	case 0:
> 		stuff();
> 		break;
> 	case 1:
> 		stuff();
> 	}
> 
> But all the above could be array-driven anyway.

Is the code below close to what you meant?

static char *str[] = { NULL, "not connected", "connected", "lost" };
if (unlikely(value >= ARRAY_SIZE(str) || str[value] == NULL))
	return snprintf(buf, PAGE_SIZE, "%u\n", value);
return snprintf(buf, PAGE_SIZE, "%s\n", str[value]);

On 21/04/07 18:56, Duncan Sands wrote:
>> +named device points to the USB interface device's directory which contains
>> +several sysfs attribute files for retriving device statistics:
> retrieving

Thanks.

 drivers/usb/atm/cxacru.c |   73 +++++++++++++++++++--------------------------
 1 files changed, 31 insertions(+), 42 deletions(-)

diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index 0c47755..1c5d6de 100644
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
+	return snprintf(buf, PAGE_SIZE, "%u.%02u\n",
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
