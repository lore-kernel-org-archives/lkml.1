Return-Path: <linux-kernel-owner+w=401wt.eu-S1752978AbZIWOBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbZIWOBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 10:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbZIWOBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 10:01:45 -0400
Received: from mail-px0-f194.google.com ([209.85.216.194]:42436 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbZIWOBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 10:01:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Bd6+YkKJVUbaXBI1PTB1RFvVWuh0DM4CY699VAvDjLE6JZ5EyGEp7mKpRUvYxtgQdT
         FAUObGWEub+ZuCI9/jx220engFnPc6X+5ftnVnp5fGkDfGC/5+n6I7mCoonYO0lVhE33
         UAfMi72NqMmVKG0ke0sFFSipdJrw6uUhmagx8=
MIME-Version: 1.0
Date: Wed, 23 Sep 2009 20:01:47 +0600
Message-ID: <b9df5fa10909230701u128fbec2x78bb433e3a2f42b@mail.gmail.com>
Subject: [PATCH] hwmon: Fix spurious section mismatch warning in sht15.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: lm-sensors@lm-sensors.org, LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix spurious section mismatch warnings, caused due to reference from
variable sht_drivers to
 __devinit/__devexit functions sht15_probe()/remove().

 We were warned by the following warnings:

  LD      drivers/hwmon/built-in.o
WARNING: drivers/hwmon/built-in.o(.data+0x264a0): Section mismatch in
reference from the variable sht_drivers to the function
.devinit.text:sht15_probe()
The variable sht_drivers references
the function __devinit sht15_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/hwmon/built-in.o(.data+0x264a4): Section mismatch in
reference from the variable sht_drivers to the function
.devexit.text:sht15_remove()
The variable sht_drivers references
the function __devexit sht15_remove()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/hwmon/built-in.o(.data+0x264f0): Section mismatch in
reference from the variable sht_drivers to the function
.devinit.text:sht15_probe()
The variable sht_drivers references
the function __devinit sht15_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/hwmon/built-in.o(.data+0x264f4): Section mismatch in
reference from the variable sht_drivers to the function
.devexit.text:sht15_remove()
The variable sht_drivers references
the function __devexit sht15_remove()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/hwmon/built-in.o(.data+0x26540): Section mismatch in
reference from the variable sht_drivers to the function
.devinit.text:sht15_probe()
The variable sht_drivers references
the function __devinit sht15_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/hwmon/built-in.o(.data+0x26544): Section mismatch in
reference from the variable sht_drivers to the function
.devexit.text:sht15_remove()
The variable sht_drivers references
the function __devexit sht15_remove()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/hwmon/built-in.o(.data+0x26590): Section mismatch in
reference from the variable sht_drivers to the function
.devinit.text:sht15_probe()
The variable sht_drivers references
the function __devinit sht15_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

-------
Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linus/drivers/hwmon/sht15.c	2009-09-22 16:28:07.000000000 +0600
+++ rakib/drivers/hwmon/sht15.c	2009-09-23 14:47:48.000000000 +0600
@@ -619,8 +619,12 @@ static int __devexit sht15_remove(struct
 	return 0;
 }

-
-static struct platform_driver sht_drivers[] = {
+/*
+ * sht_drivers simultaneously refers to __devinit and __devexit function
+ * which causes spurious section mismatch warning. So use __refdata to
+ * get rid from this.
+ */
+static struct platform_driver __refdata sht_drivers[] = {
 	{
 		.driver = {
 			.name = "sht10",
