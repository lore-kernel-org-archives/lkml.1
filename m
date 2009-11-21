Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbZKUPRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbZKUPRo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 10:17:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755630AbZKUPRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 10:17:32 -0500
Received: from proxima.lp0.eu ([81.2.80.65]:39196 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910AbZKUPR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 10:17:26 -0500
Message-ID: <4B0803B9.2070700@simon.arlott.org.uk>
Date: Sat, 21 Nov 2009 15:14:01 +0000
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.23 (X11/20090927)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 6/8] cxacru: add write-only sysfs attribute for modem configuration
References: <4B08013B.90403@simon.arlott.org.uk>
In-Reply-To: <4B08013B.90403@simon.arlott.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The modem can be configured using CM_REQUEST_CARD_DATA_SET,
although CM_REQUEST_CARD_DATA_GET does not return any data.

Tested by setting the modulation (0x0a) option.

There is a list of parameters in the following archive,
but the meaning of many of them is not well documented:
  http://sourceforge.net/project/shownotes.php?release_id=301825

This source also indicates that the highest parameter set
is 0x4a but this varies by model so an arbitrary limit of
0x7f has been used (the index is a 32-bit integer).

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 Documentation/networking/cxacru.txt |    9 ++++
 drivers/usb/atm/cxacru.c            |   76 ++++++++++++++++++++++++++++++++++-
 2 files changed, 84 insertions(+), 1 deletions(-)

diff --git a/Documentation/networking/cxacru.txt b/Documentation/networking/cxacru.txt
index 3532cee..f4fbf4c 100644
--- a/Documentation/networking/cxacru.txt
+++ b/Documentation/networking/cxacru.txt
@@ -15,6 +15,15 @@ several sysfs attribute files for retrieving device statistics:
 * adsl_headend_environment
 	Information about the remote headend.
 
+* adsl_config
+	Configuration writing interface.
+	Write parameters in hexadecimal format <index>=<value>,
+	separated by whitespace, e.g.:
+		"1=0 a=5"
+	Up to 7 parameters at a time will be sent and the modem will restart
+	the ADSL connection when any value is set. These are logged for future
+	reference.
+
 * downstream_attenuation (dB)
 * downstream_bits_per_frame
 * downstream_rate (kbps)
diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index c6ec10e..4168574 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -52,6 +52,7 @@ static const char cxacru_driver_name[] = "cxacru";
 #define CXACRU_EP_DATA		0x02	/* Bulk in/out */
 
 #define CMD_PACKET_SIZE		64	/* Should be maxpacket(ep)? */
+#define CMD_MAX_CONFIG		((CMD_PACKET_SIZE / 4 - 1) / 2)
 
 /* Addresses */
 #define PLLFCLK_ADDR	0x00350068
@@ -216,6 +217,10 @@ static DEVICE_ATTR(_name, S_IRUGO, cxacru_sysfs_show_##_name, NULL)
 static DEVICE_ATTR(_name, S_IWUSR | S_IRUGO, \
 	cxacru_sysfs_show_##_name, cxacru_sysfs_store_##_name)
 
+#define CXACRU_SET_INIT(_name) \
+static DEVICE_ATTR(_name, S_IWUSR, \
+	NULL, cxacru_sysfs_store_##_name)
+
 #define CXACRU_ATTR_INIT(_value, _type, _name) \
 static ssize_t cxacru_sysfs_show_##_name(struct device *dev, \
 	struct device_attribute *attr, char *buf) \
@@ -232,10 +237,12 @@ CXACRU__ATTR_INIT(_name)
 
 #define CXACRU_ATTR_CREATE(_v, _t, _name) CXACRU_DEVICE_CREATE_FILE(_name)
 #define CXACRU_CMD_CREATE(_name)          CXACRU_DEVICE_CREATE_FILE(_name)
+#define CXACRU_SET_CREATE(_name)          CXACRU_DEVICE_CREATE_FILE(_name)
 #define CXACRU__ATTR_CREATE(_name)        CXACRU_DEVICE_CREATE_FILE(_name)
 
 #define CXACRU_ATTR_REMOVE(_v, _t, _name) CXACRU_DEVICE_REMOVE_FILE(_name)
 #define CXACRU_CMD_REMOVE(_name)          CXACRU_DEVICE_REMOVE_FILE(_name)
+#define CXACRU_SET_REMOVE(_name)          CXACRU_DEVICE_REMOVE_FILE(_name)
 #define CXACRU__ATTR_REMOVE(_name)        CXACRU_DEVICE_REMOVE_FILE(_name)
 
 static ssize_t cxacru_sysfs_showattr_u32(u32 value, char *buf)
@@ -437,6 +444,72 @@ static ssize_t cxacru_sysfs_store_adsl_state(struct device *dev,
 	return ret;
 }
 
+/* CM_REQUEST_CARD_DATA_GET times out, so no show attribute */
+
+static ssize_t cxacru_sysfs_store_adsl_config(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct cxacru_data *instance = to_usbatm_driver_data(
+			to_usb_interface(dev));
+	int len = strlen(buf);
+	int ret, pos, num;
+	__le32 data[CMD_PACKET_SIZE / 4];
+
+	if (!capable(CAP_NET_ADMIN))
+		return -EACCES;
+
+	if (instance == NULL)
+		return -ENODEV;
+
+	pos = 0;
+	num = 0;
+	while (pos < len) {
+		int tmp;
+		u32 index;
+		u32 value;
+
+		ret = sscanf(buf + pos, "%x=%x%n", &index, &value, &tmp);
+		if (ret < 2)
+			return -EINVAL;
+		if (index < 0 || index > 0x7f)
+			return -EINVAL;
+		pos += tmp;
+
+		/* skip trailing newline */
+		if (buf[pos] == '\n' && pos == len-1)
+			pos++;
+
+		data[num * 2 + 1] = cpu_to_le32(index);
+		data[num * 2 + 2] = cpu_to_le32(value);
+		num++;
+
+		/* send config values when data buffer is full
+		 * or no more data
+		 */
+		if (pos >= len || num >= CMD_MAX_CONFIG) {
+			char log[CMD_MAX_CONFIG * 12 + 1]; /* %02x=%08x */
+
+			data[0] = cpu_to_le32(num);
+			ret = cxacru_cm(instance, CM_REQUEST_CARD_DATA_SET,
+				(u8 *) data, 4 + num * 8, NULL, 0);
+			if (ret < 0) {
+				atm_err(instance->usbatm,
+					"set card data returned %d\n", ret);
+				return -EIO;
+			}
+
+			for (tmp = 0; tmp < num; tmp++)
+				snprintf(log + tmp*12, 13, " %02x=%08x",
+					le32_to_cpu(data[tmp * 2 + 1]),
+					le32_to_cpu(data[tmp * 2 + 2]));
+			atm_info(instance->usbatm, "config%s\n", log);
+			num = 0;
+		}
+	}
+
+	return len;
+}
+
 /*
  * All device attributes are included in CXACRU_ALL_FILES
  * so that the same list can be used multiple times:
@@ -472,7 +545,8 @@ CXACRU_ATTR_##_action(CXINF_MODULATION,                MODU, modulation); \
 CXACRU_ATTR_##_action(CXINF_ADSL_HEADEND,              u32,  adsl_headend); \
 CXACRU_ATTR_##_action(CXINF_ADSL_HEADEND_ENVIRONMENT,  u32,  adsl_headend_environment); \
 CXACRU_ATTR_##_action(CXINF_CONTROLLER_VERSION,        u32,  adsl_controller_version); \
-CXACRU_CMD_##_action(                                        adsl_state);
+CXACRU_CMD_##_action(                                        adsl_state); \
+CXACRU_SET_##_action(                                        adsl_config);
 
 CXACRU_ALL_FILES(INIT);
 
-- 
1.6.3.3

-- 
Simon Arlott

