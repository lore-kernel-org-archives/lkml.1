Return-Path: <linux-kernel-owner+w=401wt.eu-S1756153AbYKQVM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbYKQVM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 16:12:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbYKQVMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 16:12:18 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:28154 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752202AbYKQVMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 16:12:17 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:Reply-To:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=VMf4AAA1mlK6D0MymhyzogBmCbJxhka8t3e7CWnPKvLManNM66xZniHRwyQ0U13LL0dVgQ9jBzxig4skeuiJtjrgrKIlyGDziNe3vvCIevR6jAqv/yfKjaDO5HjRtDxRViusuO+2iEjXgCJiVNhhwDRcrhPtpk005fCrvT9PliU=  ;
X-YMail-OSG: lUjlYPoVM1mDftHhmuk3Mt8U2I_s4FaQnfhGdLLv1_ailpZgfPyH1t2hLxmzkooDd5GRU1i3_OvxW2yuplQ2ROp54dSPAgPafNRx3GJ10oBHSSL_zp2dOUYEgbRN1t.Zh59RplrNEWYD2s8vUvb2qSgZ
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
Reply-To: dbrownell@users.sourceforge.net
To: Samuel Ortiz <sameo@openedhand.com>
Subject: [patch 2.6.28-rc5] mfd da903x: section fix
Date: Mon, 17 Nov 2008 11:42:38 -0800
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>, Eric Miao <eric.miao@marvell.com>,
       Mike Rapoport <mike@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811171142.38587.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

This fixes the following section warning:

  WARNING: vmlinux.o(.devinit.text+0x3d36): Section mismatch in reference from the function 
  da903x_add_subdevs() to the function .devexit.text:da903x_remove_subdevs()
  The function __devinit da903x_add_subdevs() references
  a function __devexit da903x_remove_subdevs().
  This is often seen when error handling in the init function
  uses functionality in the exit path.
  The fix is often to remove the __devexit annotation of
  da903x_remove_subdevs() so it may be used outside an exit section.

It might be nice to have an "init and exit" section annotation for such
cases; in this case the waste is only about 40 bytes (x86 test build).

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/mfd/da903x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mfd/da903x.c
+++ b/drivers/mfd/da903x.c
@@ -435,13 +435,13 @@ static const struct i2c_device_id da903x
 };
 MODULE_DEVICE_TABLE(i2c, da903x_id_table);
 
-static int __devexit __remove_subdev(struct device *dev, void *unused)
+static int __remove_subdev(struct device *dev, void *unused)
 {
 	platform_device_unregister(to_platform_device(dev));
 	return 0;
 }
 
-static int __devexit da903x_remove_subdevs(struct da903x_chip *chip)
+static int da903x_remove_subdevs(struct da903x_chip *chip)
 {
 	return device_for_each_child(chip->dev, NULL, __remove_subdev);
 }
