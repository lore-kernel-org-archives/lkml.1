Return-Path: <linux-kernel-owner+w=401wt.eu-S1754343AbXKNIUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbXKNIUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 03:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbXKNIUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 03:20:10 -0500
Received: from [222.73.24.84] ([222.73.24.84]:59585 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbXKNIUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 03:20:09 -0500
Message-ID: <473AAF26.1030407@cn.fujitsu.com>
Date: Wed, 14 Nov 2007 16:17:42 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: jkosina@suse.cz, linux-usb-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] HID: fix a potential bug in pointer casting
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Don't directly cast list_head * to foo *, this works only when list
is the first member of struct foo, and we should not make the assumption
how members are ordered in the structure.

i.e. struct *f = (struct *f)pos will work if:
	struct foo {
		struct list_head list;
		int i;
	};

but will fail if:
	struct foo {
		int i;
		struct list_head list;
	}

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

---
 drivers/hid/usbhid/hid-tmff.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/usbhid/hid-tmff.c b/drivers/hid/usbhid/hid-tmff.c
index 69882a7..144578b 100644
--- a/drivers/hid/usbhid/hid-tmff.c
+++ b/drivers/hid/usbhid/hid-tmff.c
@@ -137,7 +137,8 @@ static int hid_tmff_play(struct input_dev *dev, void *data, struct ff_effect *ef
 int hid_tmff_init(struct hid_device *hid)
 {
 	struct tmff_device *tmff;
-	struct list_head *pos;
+	struct hid_report *report;
+	struct list_head *report_list;
 	struct hid_input *hidinput = list_entry(hid->inputs.next, struct hid_input, list);
 	struct input_dev *input_dev = hidinput->input;
 	const signed short *ff_bits = ff_joystick;
@@ -149,8 +150,8 @@ int hid_tmff_init(struct hid_device *hid)
 		return -ENOMEM;
 
 	/* Find the report to use */
-	list_for_each(pos, &hid->report_enum[HID_OUTPUT_REPORT].report_list) {
-		struct hid_report *report = (struct hid_report *)pos;
+	report_list = &hid->report_enum[HID_OUTPUT_REPORT].report_list;
+	list_for_each_entry(report, report_list, list) {
 		int fieldnum;
 
 		for (fieldnum = 0; fieldnum < report->maxfield; ++fieldnum) {
-- 
1.5.3.rc7

