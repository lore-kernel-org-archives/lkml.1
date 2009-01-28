Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855AbZA1KZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbZA1KZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 05:25:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbZA1KYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 05:24:12 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:48744 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752284AbZA1KYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 05:24:10 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 5/6] input: Allow certain EV_ABS events to bypass all filtering
Date: Wed, 28 Jan 2009 11:23:48 +0100
Message-Id: <1233138229-12489-6-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1233138229-12489-5-git-send-email-rydberg@euromail.se>
References: <1233138229-12489-1-git-send-email-rydberg@euromail.se>
 <1233138229-12489-2-git-send-email-rydberg@euromail.se>
 <1233138229-12489-3-git-send-email-rydberg@euromail.se>
 <1233138229-12489-4-git-send-email-rydberg@euromail.se>
 <1233138229-12489-5-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.192.132
X-Scan-Result: No virus found in message 1LS7aZ-0005tR-3j.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1LS7aZ-0005tR-3j 356e7f2ab7bc89a51d54a806b99f4d24
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
index 1730d73..7f9180c 100644
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
-- 
1.5.6.3

