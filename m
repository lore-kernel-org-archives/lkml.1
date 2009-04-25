Return-Path: <linux-kernel-owner+w=401wt.eu-S1753187AbZDYLgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbZDYLgQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 07:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbZDYLgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 07:36:00 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:49806 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbZDYLf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 07:35:59 -0400
X-Greylist: delayed 442 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Apr 2009 07:35:59 EDT
Date: Sat, 25 Apr 2009 05:28:36 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com
cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       dbrownell@users.sourceforge.net
Subject: [PATCH] regulator core: fix double-free in regulator_register()
 error path
Message-ID: <alpine.DEB.2.00.0904250526210.28378@utopia.booyaka.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


During regulator registration, any error after device_register() will 
cause a double-free on the struct regulator_dev 'rdev'.  The bug is in 
drivers/regulator/core.c:regulator_register():

...
scrub:
	device_unregister(&rdev->dev);
clean:
	kfree(rdev);                           <---
	rdev = ERR_PTR(ret);
	goto out;
...

device_unregister() calls regulator_dev_release() which frees rdev.  The 
subsequent kfree corrupts memory and causes some OMAP3 systems to oops on 
boot in regulator_get().

Applies against 2.6.30-rc3.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
---
 drivers/regulator/core.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 01f7702..fabd2e0 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2080,6 +2080,10 @@ out:
 
 scrub:
 	device_unregister(&rdev->dev);
+	/* device core frees rdev */
+	rdev = ERR_PTR(ret);
+	goto out;
+
 clean:
 	kfree(rdev);
 	rdev = ERR_PTR(ret);
-- 
1.6.3.rc1.51.gea0b7

