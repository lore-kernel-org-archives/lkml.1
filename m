Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbZAZPIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbZAZPIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 10:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbZAZPIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 10:08:25 -0500
Received: from adelie.canonical.com ([91.189.90.139]:48904 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbZAZPIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 10:08:24 -0500
Date: Mon, 26 Jan 2009 15:08:21 +0000
From: Andy Whitcroft <apw@canonical.com>
To: arjan@opmeer.net, patrakov@gmail.com, dmitry.torokhov@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: elantech touchpad driver miss-recognising logitech mice
Message-ID: <20090126150821.GC31179@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have been receiving reports of the elantech driver miss-recognising
logitech mice as per the patchwork thread below:

    http://patchwork.kernel.org/patch/319/

That thread indicates that the patch as presented is not sufficient
so I am wondering if this has progressed and if there is a later patch I
could test with.  I cannot see anything later in mainline as yet?

Failing that I did build a modified patch (below) based on that from the
thread plus the suggested improvements.  This has been tested by people
with the Logitech mice successfully, and also by people with elantech
touchpads who report no regressions.

If there is no later patches then perhaps you could test this one, and
then I can push it upstream.

Comments?

-apw


>From b39b647dfd5106c340d588920704b6d696b182d9 Mon Sep 17 00:00:00 2001
From: Andy Whitcroft <apw@canonical.com>
Date: Fri, 23 Jan 2009 17:42:05 +0000
Subject: [PATCH 1/1] elantech touchpad -- weed out incorrectly identified Logitech Mice

Some Logitech USB-PS/2 Optical Mouse are triggering on the special knock
sequence when attached on PS/2.  Use the version number to weed those out.
Note that as we have no private data we end up doing the version check
twice.

Based on an original patch by Arjan Opmeer <arjan@opmeer.net> and based
on suggestions from him on how to improve it.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 drivers/input/mouse/elantech.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index b9a25d5..32febf5 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -556,6 +556,22 @@ int elantech_detect(struct psmouse *psmouse, int set_properties)
 		return -1;
 	}
 
+	/*
+	 * Some Logitech USB-PS/2 Optical Mouse devices are responding to
+	 * our magic knock.  So ask for our device version and validate
+	 * using that.
+	 */
+	if (synaptics_send_cmd(psmouse, ETP_FW_VERSION_QUERY, param)) {
+		pr_err("elantech.c: failed to query firmware version.\n");
+		return -1;
+	}
+	pr_info("elantech.c: Elantech version query result 0x%02x, 0x%02x, 0x%02x.\n",
+		param[0], param[1], param[2]);
+	if (param[0] == 0 || param[1] != 0) {
+		pr_info("elantech.c: Probably not a real Elantech touchpad. Aborting.\n");
+		return -1;
+	}
+
 	if (set_properties) {
 		psmouse->vendor = "Elantech";
 		psmouse->name = "Touchpad";
-- 
1.6.1.258.g7ff14.dirty
