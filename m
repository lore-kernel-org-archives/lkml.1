Return-Path: <linux-kernel-owner+w=401wt.eu-S1757534AbYL1W64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534AbYL1W64 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 17:58:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbYL1W6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 17:58:47 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:52832 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752421AbYL1W6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 17:58:46 -0500
Message-ID: <49580497.6090808@euromail.se>
Date: Sun, 28 Dec 2008 23:58:31 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org
CC: Peter Hutterer <peter.hutterer@who-t.net>, jg@laptop.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] input: Allow certain EV_ABS events to bypass all filtering
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.192.132
X-Scan-Result: No virus found in message 1LH4ap-0006sT-7B.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1LH4ap-0006sT-7B fc3e2c15fceb45397ff699750fddf62c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the upcoming multi-touch interface as an example, there is
a need to make certain that all reported events actually get passed
to the event handler. This patch equips the input core with the
ability to bypass all filtering for certain EV_ABS events.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/input.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index c13ced3..8b865ba 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -29,6 +29,13 @@ MODULE_LICENSE("GPL");

 #define INPUT_DEVICES	256

+/*
+ * EV_ABS events which should not be cached are listed here.
+ */
+static __initdata unsigned int input_abs_bypass_init_data[] = {
+	0
+};
+
 static LIST_HEAD(input_dev_list);
 static LIST_HEAD(input_handler_list);

@@ -42,6 +49,8 @@ static DEFINE_MUTEX(input_mutex);

 static struct input_handler *input_table[8];

+static unsigned long input_abs_bypass[BITS_TO_LONGS(ABS_CNT)];
+
 static inline int is_event_supported(unsigned int code,
 				     unsigned long *bm, unsigned int max)
 {
@@ -185,6 +194,11 @@ static void input_handle_event(struct input_dev *dev,
 	case EV_ABS:
 		if (is_event_supported(code, dev->absbit, ABS_MAX)) {

+			if (test_bit(code, input_abs_bypass)) {
+				disposition = INPUT_PASS_TO_HANDLERS;
+				break;
+			}
+
 			value = input_defuzz_abs_event(value,
 					dev->abs[code], dev->absfuzz[code]);

@@ -1630,10 +1644,19 @@ static const struct file_operations input_fops = {
 	.open = input_open_file,
 };

+static void __init input_init_abs_bypass()
+{
+	const unsigned int *p;
+	for (p = input_abs_bypass_init_data; *p; p++)
+		input_abs_bypass[BIT_WORD(*p)] |= BIT_MASK(*p);
+}
+
 static int __init input_init(void)
 {
 	int err;

+	input_init_abs_bypass();
+
 	err = class_register(&input_class);
 	if (err) {
 		printk(KERN_ERR "input: unable to register input_dev class\n");

