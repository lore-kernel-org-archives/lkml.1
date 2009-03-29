Return-Path: <linux-kernel-owner+w=401wt.eu-S1758735AbZC2SJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735AbZC2SJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 14:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbZC2SJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 14:09:17 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:35035 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751119AbZC2SJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 14:09:16 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAFZWz0lR9cC9/2dsb2JhbADHNgeDcwY
Date: Sun, 29 Mar 2009 20:09:12 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       "George G. Davis" <gdavis@mvista.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH 35/58] move omap_wdt's probe function to .devinit.text
Message-ID: <20090329180912.GA6979@infomag.iguana.be>
References: <20090327232153.GA16348@pengutronix.de> <1238196439-16535-35-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238196439-16535-35-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

> A pointer to omap_wdt_probe is passed to the core via
> platform_driver_register and so the function must not disappear when the
> .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> unbinding and binding a device to the driver via sysfs will result in an
> oops as does a device being registered late.
> 
> An alternative to this patch is using platform_driver_probe instead of
> platform_driver_register plus removing the pointer to the probe function
> from the struct platform_driver.

Agree with the explanation, but ...

> diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
> index 2f2ce74..c9c14dd 100644
> --- a/drivers/watchdog/omap_wdt.c
> +++ b/drivers/watchdog/omap_wdt.c
> @@ -269,7 +269,7 @@ static const struct file_operations omap_wdt_fops = {
>  	.release = omap_wdt_release,
>  };
>  
> -static int __init omap_wdt_probe(struct platform_device *pdev)
> +static int __devinit omap_wdt_probe(struct platform_device *pdev)
>  {
>  	struct resource *res, *mem;
>  	struct omap_wdt_dev *wdev;

...imho this would be the correct fix:

diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index aa5ad6e..f271385 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -258,7 +258,7 @@ static const struct file_operations omap_wdt_fops = {
 	.release = omap_wdt_release,
 };
 
-static int __init omap_wdt_probe(struct platform_device *pdev)
+static int __devinit omap_wdt_probe(struct platform_device *pdev)
 {
 	struct resource *res, *mem;
 	struct omap_wdt_dev *wdev;
@@ -367,7 +367,7 @@ static void omap_wdt_shutdown(struct platform_device *pdev)
 		omap_wdt_disable(wdev);
 }
 
-static int omap_wdt_remove(struct platform_device *pdev)
+static int __devexit omap_wdt_remove(struct platform_device *pdev)
 {
 	struct omap_wdt_dev *wdev = platform_get_drvdata(pdev);
 	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -426,7 +426,7 @@ static int omap_wdt_resume(struct platform_device *pdev)
 
 static struct platform_driver omap_wdt_driver = {
 	.probe		= omap_wdt_probe,
-	.remove		= omap_wdt_remove,
+	.remove		= __devexit_p(omap_wdt_remove),
 	.shutdown	= omap_wdt_shutdown,
 	.suspend	= omap_wdt_suspend,
 	.resume		= omap_wdt_resume,

Kind regards,
Wim.

