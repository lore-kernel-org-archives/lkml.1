Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbYKCSaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbYKCSaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 13:30:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbYKCSa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 13:30:28 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:22290 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbYKCSa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 13:30:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Q9Wt0uAAwWlt9COQD/cuHrzLJQm8DmqPMbtqhFHzY/1xObuIhQBqEzp6pc28Kbub/E
         8iHFTc8wLgleGBlHwU89k+rAHsJvreN+TCTMk++vGA9yKC5hjlbpOxl5mU8fD4qGDrB6
         hI388dfWrQ7NRn86PkbcSnpqZ2AjwqiahpB10=
Date: Mon, 3 Nov 2008 21:29:55 +0300
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: linux-kernel@vger.kernel.org, cbou@mail.ru,
       Andrew Morton <akpm@linux-foundation.org>,
       Marek Vasut <marek.vasut@gmail.com>,
       Jonathan Cameron <Jonathan.Cameron@gmail.com>
Subject: Re: [PATCH] power_supply: change the way how wm97xx-bat driver is
	registered
Message-ID: <20081103182955.GA17171@doriath.ww600.siemens.net>
References: <1225271050-21171-1-git-send-email-dbaryshkov@gmail.com> <1225271050-21171-2-git-send-email-dbaryshkov@gmail.com> <20081103151151.GB23466@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081103151151.GB23466@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2008 at 06:11:51PM +0300, Anton Vorontsov wrote:
> On Wed, Oct 29, 2008 at 12:04:10PM +0300, Dmitry Baryshkov wrote:
> >  #ifdef CONFIG_BATTERY_WM97XX
> > -void __init wm97xx_bat_set_pdata(struct wm97xx_batt_info *data);
> > +int wm97xx_bat_set_pdata(struct wm97xx_batt_info *data);
> >  #else
> > -static inline void wm97xx_bat_set_pdata(struct wm97xx_batt_info *data) {}
> > +static inline int wm97xx_bat_set_pdata(struct wm97xx_batt_info *data)
> > +{
> > +	return -ENODEV;
> > +}
> >  #endif
> 
> How that supposed to work when BATTERY_WM97XX is a module?
> #ifdef CONFIG_BATTERY_WM97XX will evaluate to false, and you'll have
> dummy wm97xx_bat_set_pdata() that returns -ENODEV...

This won't of course fix the wm97xx driver model, but the module issue
should be fixed. What about this patch?


>From f4b2e46cbac0d3ce77643c008d44fdaea8864366 Mon Sep 17 00:00:00 2001
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
Date: Wed, 29 Oct 2008 12:00:57 +0300
Subject: [PATCH] power_supply: change the way how wm97xx-bat driver is registered

Do register the driver from wm97xx_bat_set_pdata instead of module init.
This has several positive outcome points:
1) This driver for wm97xx-battery is now registered on demand, thus allowing
  other driver (e.g. tosa-battery) to claim the battery.
2) After dropping __init from wm97xx_bat_set_pdata(), the wm97xx_bat driver
  can be correctly built as a module. Then one can request it and set the
  battery data.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Marek Vasut <marek.vasut@gmail.com>

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 drivers/power/Kconfig          |    4 ++--
 drivers/power/wm97xx_battery.c |   12 +++++-------
 include/linux/wm97xx_batt.h    |    9 ++++++---
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 8e0c2b4..053f20b 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -57,8 +57,8 @@ config BATTERY_TOSA
 	  SL-6000 (tosa) models.
 
 config BATTERY_WM97XX
-	bool "WM97xx generic battery driver"
-	depends on TOUCHSCREEN_WM97XX=y
+	tristate "WM97xx generic battery driver"
+	depends on TOUCHSCREEN_WM97XX
 	help
 	  Say Y to enable support for battery measured by WM97xx aux port.
 
diff --git a/drivers/power/wm97xx_battery.c b/drivers/power/wm97xx_battery.c
index 8bde921..94727dc 100644
--- a/drivers/power/wm97xx_battery.c
+++ b/drivers/power/wm97xx_battery.c
@@ -248,23 +248,21 @@ static struct platform_driver wm97xx_bat_driver = {
 	.resume		= wm97xx_bat_resume,
 };
 
-static int __init wm97xx_bat_init(void)
-{
-	return platform_driver_register(&wm97xx_bat_driver);
-}
-
 static void __exit wm97xx_bat_exit(void)
 {
 	platform_driver_unregister(&wm97xx_bat_driver);
 }
 
-void __init wm97xx_bat_set_pdata(struct wm97xx_batt_info *data)
+int wm97xx_bat_set_pdata(struct wm97xx_batt_info *data)
 {
+	if (pdata)
+		return -EEXIST;
+
 	pdata = data;
+	return platform_driver_register(&wm97xx_bat_driver);
 }
 EXPORT_SYMBOL_GPL(wm97xx_bat_set_pdata);
 
-module_init(wm97xx_bat_init);
 module_exit(wm97xx_bat_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/include/linux/wm97xx_batt.h b/include/linux/wm97xx_batt.h
index 9681d1a..eb9cbf3 100644
--- a/include/linux/wm97xx_batt.h
+++ b/include/linux/wm97xx_batt.h
@@ -17,10 +17,13 @@ struct wm97xx_batt_info {
 	char	*batt_name;
 };
 
-#ifdef CONFIG_BATTERY_WM97XX
-void __init wm97xx_bat_set_pdata(struct wm97xx_batt_info *data);
+#if defined(CONFIG_BATTERY_WM97XX) || defined(CONFIG_BATTERY_WM97XX_MODULE)
+int wm97xx_bat_set_pdata(struct wm97xx_batt_info *data);
 #else
-static inline void wm97xx_bat_set_pdata(struct wm97xx_batt_info *data) {}
+static inline int wm97xx_bat_set_pdata(struct wm97xx_batt_info *data)
+{
+	return -ENODEV;
+}
 #endif
 
 #endif
-- 
1.5.6.5


-- 
With best wishes
Dmitry

