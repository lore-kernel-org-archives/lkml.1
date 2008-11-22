Return-Path: <linux-kernel-owner+w=401wt.eu-S1759047AbYKVRhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759047AbYKVRhj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:37:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759389AbYKVRf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:35:27 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55430 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759028AbYKVRfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:35:25 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH 13/32] rackmeter section fixes
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Message-Id: <E1L3wOC-0006T5-Ji@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 22 Nov 2008 17:35:24 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* rackmeter_remove() reference needs devexit_p
* rackmeter_setup() is calls devinit and is called only from devinit

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/macintosh/rack-meter.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/macintosh/rack-meter.c b/drivers/macintosh/rack-meter.c
--- a/drivers/macintosh/rack-meter.c
+++ b/drivers/macintosh/rack-meter.c
@@ -288,7 +288,7 @@ static void __devexit rackmeter_stop_cpu_sniffer(struct rackmeter *rm)
 	cancel_rearming_delayed_work(&rm->cpu[1].sniffer);
 }
 
-static int rackmeter_setup(struct rackmeter *rm)
+static int __devinit rackmeter_setup(struct rackmeter *rm)
 {
 	pr_debug("rackmeter: setting up i2s..\n");
 	rackmeter_setup_i2s(rm);
@@ -582,12 +582,12 @@ static struct of_device_id rackmeter_match[] = {
 	{ }
 };
 
-static struct macio_driver rackmeter_drv = {
+static struct macio_driver rackmeter_driver = {
 	.name = "rackmeter",
 	.owner = THIS_MODULE,
 	.match_table = rackmeter_match,
 	.probe = rackmeter_probe,
-	.remove = rackmeter_remove,
+	.remove = __devexit_p(rackmeter_remove),
 	.shutdown = rackmeter_shutdown,
 };
 
@@ -596,14 +596,14 @@ static int __init rackmeter_init(void)
 {
 	pr_debug("rackmeter_init()\n");
 
-	return macio_register_driver(&rackmeter_drv);
+	return macio_register_driver(&rackmeter_driver);
 }
 
 static void __exit rackmeter_exit(void)
 {
 	pr_debug("rackmeter_exit()\n");
 
-	macio_unregister_driver(&rackmeter_drv);
+	macio_unregister_driver(&rackmeter_driver);
 }
 
 module_init(rackmeter_init);
