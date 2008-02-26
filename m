Return-Path: <linux-kernel-owner+w=401wt.eu-S1764754AbYBZUm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764754AbYBZUm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 15:42:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763641AbYBZUmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 15:42:42 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:56966 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616AbYBZUml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 15:42:41 -0500
Date: Tue, 26 Feb 2008 21:42:37 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: corentincj@iksaif.net, sziwan@users.sourceforge.net,
       acpi4asus-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/9] drivers/acpi/asus_acpi.c: Correct use of ! and &
Message-ID: <Pine.LNX.4.64.0802262142120.18200@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In commit e6bafba5b4765a5a252f1b8d31cbf6d2459da337, a bug was fixed that
involved converting !x & y to !(x & y).  The code below shows the same
pattern, and thus should perhaps be fixed in the same way.

This is not tested and clearly changes the semantics, so it is only
something to consider.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@ expression E1,E2; @@
(
  !E1 & !E2
|
- !E1 & E2
+ !(E1 & E2)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

diff -u -p a/drivers/acpi/asus_acpi.c b/drivers/acpi/asus_acpi.c
--- a/drivers/acpi/asus_acpi.c 2008-02-10 22:34:05.000000000 +0100
+++ b/drivers/acpi/asus_acpi.c 2008-02-26 08:00:42.000000000 +0100
@@ -610,7 +610,7 @@ write_led(const char __user * buffer, un
 	    (led_out) ? (hotk->status | ledmask) : (hotk->status & ~ledmask);
 
 	if (invert)		/* invert target value */
-		led_out = !led_out & 0x1;
+		led_out = !(led_out & 0x1);
 
 	if (!write_acpi_int(hotk->handle, ledname, led_out, NULL))
 		printk(KERN_WARNING "Asus ACPI: LED (%s) write failed\n",
