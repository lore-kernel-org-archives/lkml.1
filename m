Return-Path: <linux-kernel-owner+w=401wt.eu-S1754655AbZGSP0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbZGSP0T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 11:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754596AbZGSP0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 11:26:17 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:34789 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493AbZGSP0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 11:26:16 -0400
Date: Sun, 19 Jul 2009 17:26:13 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: jkosina@suse.cz, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 3/10] drivers/hid: Move dereferences below a NULL test
Message-ID: <Pine.LNX.4.64.0907191725530.16542@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If the NULL test is necessary, then the dereferences should be moved below
the NULL test.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
expression E,E1;
identifier i,fld;
statement S;
@@

- T i = E->fld;
+ T i;
  ... when != E=E1
      when != i
  if (E == NULL||...) S
+ i = E->fld;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/hid/hid-core.c              |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 5ebbb8a..ca69cc3 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1072,8 +1072,8 @@ EXPORT_SYMBOL_GPL(hid_report_raw_event);
  */
 int hid_input_report(struct hid_device *hid, int type, u8 *data, int size, int interrupt)
 {
-	struct hid_report_enum *report_enum = hid->report_enum + type;
-	struct hid_driver *hdrv = hid->driver;
+	struct hid_report_enum *report_enum;
+	struct hid_driver *hdrv;
 	struct hid_report *report;
 	char *buf;
 	unsigned int i;
@@ -1081,6 +1081,8 @@ int hid_input_report(struct hid_device *hid, int type, u8 *data, int size, int i
 
 	if (!hid || !hid->driver)
 		return -ENODEV;
+	report_enum = hid->report_enum + type;
+	hdrv = hid->driver;
 
 	if (!size) {
 		dbg_hid("empty report\n");
