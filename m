Return-Path: <linux-kernel-owner+w=401wt.eu-S1753098AbZKPETS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbZKPETS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 23:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbZKPETP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 23:19:15 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:56872 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbZKPETM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 23:19:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mLmwLuu9QfKJ10nx5iEw+qJXwupYBxjiMkODEDlvWDWkR7Gqt2HK3HL0Zsm5lZUdHR
         tCxvFGvBnZNwtBeLYCMht1u7OS3bikLFioSEG8jAHa/CdP+XHE7/6FkZdJsPYYW2izMi
         dQcEMmXR3Tn6GvEhTHGSBQ+dnnKYe0kea/Hh0=
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 12/13] staging: line6: Convert simple_strtoul to strict_strtoul in pod.c
Date: Sun, 15 Nov 2009 22:18:01 -0600
Message-Id: <1258345082-11811-13-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1258345082-11811-1-git-send-email-shawn.bohrer@gmail.com>
References: <1258345082-11811-1-git-send-email-shawn.bohrer@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
---
 drivers/staging/line6/pod.c |   56 ++++++++++++++++++++++++++++++++++++-------
 1 files changed, 47 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index 4c5b9d5..306b47c 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -422,13 +422,21 @@ void pod_transmit_parameter(struct usb_line6_pod *pod, int param, int value)
 /*
 	Resolve value to memory location.
 */
-static void pod_resolve(const char *buf, short block0, short block1, unsigned char *location)
+static int pod_resolve(const char *buf, short block0, short block1, unsigned char *location)
 {
-	int value = simple_strtoul(buf, NULL, 10);
-	short block = (value < 0x40) ? block0 : block1;
+	unsigned long value;
+	short block;
+	int ret;
+
+	ret = strict_strtoul(buf, 10, &value);
+	if (ret)
+		return ret;
+
+	block = (value < 0x40) ? block0 : block1;
 	value &= 0x3f;
 	location[0] = block >> 7;
 	location[1] = value | (block & 0x7f);
+	return 0;
 }
 
 /*
@@ -438,14 +446,20 @@ static ssize_t pod_send_store_command(struct device *dev, const char *buf, size_
 {
 	struct usb_interface *interface = to_usb_interface(dev);
 	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-
+	int ret;
 	int size = 3 + sizeof(pod->prog_data_buf);
 	char *sysex = pod_alloc_sysex_buffer(pod, POD_SYSEX_STORE, size);
+
 	if (!sysex)
 		return 0;
 
 	sysex[SYSEX_DATA_OFS] = 5;  /* see pod_dump() */
-	pod_resolve(buf, block0, block1, sysex + SYSEX_DATA_OFS + 1);
+	ret = pod_resolve(buf, block0, block1, sysex + SYSEX_DATA_OFS + 1);
+	if (ret) {
+		kfree(sysex);
+		return ret;
+	}
+
 	memcpy(sysex + SYSEX_DATA_OFS + 3, &pod->prog_data_buf, sizeof(pod->prog_data_buf));
 
 	line6_send_sysex_message(&pod->line6, sysex, size);
@@ -461,13 +475,18 @@ static ssize_t pod_send_retrieve_command(struct device *dev, const char *buf, si
 {
 	struct usb_interface *interface = to_usb_interface(dev);
 	struct usb_line6_pod *pod = usb_get_intfdata(interface);
+	int ret;
 	int size = 4;
 	char *sysex = pod_alloc_sysex_buffer(pod, POD_SYSEX_DUMPMEM, size);
 
 	if (!sysex)
 		return 0;
 
-	pod_resolve(buf, block0, block1, sysex + SYSEX_DATA_OFS);
+	ret = pod_resolve(buf, block0, block1, sysex + SYSEX_DATA_OFS);
+	if (ret) {
+		kfree(sysex);
+		return ret;
+	}
 	sysex[SYSEX_DATA_OFS + 2] = 0;
 	sysex[SYSEX_DATA_OFS + 3] = 0;
 	line6_dump_started(&pod->dumpreq, POD_DUMP_MEMORY);
@@ -526,7 +545,13 @@ static ssize_t pod_set_channel(struct device *dev,
 {
 	struct usb_interface *interface = to_usb_interface(dev);
 	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-	int value = simple_strtoul(buf, NULL, 10);
+	unsigned long value;
+	int ret;
+
+	ret = strict_strtoul(buf, 10, &value);
+	if (ret)
+		return ret;
+
 	pod_send_channel(pod, value);
 	return count;
 }
@@ -645,6 +670,8 @@ static ssize_t pod_set_system_param(struct usb_line6_pod *pod, const char *buf,
 	char *sysex;
 	static const int size = 5;
 	unsigned short value;
+	unsigned long result;
+	int ret;
 
 	if (((pod->prog_data.control[POD_tuner] & 0x40) == 0) && tuner)
 		return -EINVAL;
@@ -653,7 +680,12 @@ static ssize_t pod_set_system_param(struct usb_line6_pod *pod, const char *buf,
 	sysex = pod_alloc_sysex_buffer(pod, POD_SYSEX_SYSTEM, size);
 	if (!sysex)
 		return 0;
-	value = simple_strtoul(buf, NULL, 10) & mask;
+
+	ret = strict_strtoul(buf, 10, &result);
+	if (ret)
+		return ret;
+
+	value = result & mask;
 	sysex[SYSEX_DATA_OFS] = code;
 	sysex[SYSEX_DATA_OFS + 1] = (value >> 12) & 0x0f;
 	sysex[SYSEX_DATA_OFS + 2] = (value >>  8) & 0x0f;
@@ -812,7 +844,13 @@ static ssize_t pod_set_midi_postprocess(struct device *dev,
 {
 	struct usb_interface *interface = to_usb_interface(dev);
 	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-	int value = simple_strtoul(buf, NULL, 10);
+	unsigned long value;
+	int ret;
+
+	ret = strict_strtoul(buf, 10, &value);
+	if (ret)
+		return ret;
+
 	pod->midi_postprocess = value ? 1 : 0;
 	return count;
 }
-- 
1.6.5

