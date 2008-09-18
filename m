Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbYIRJI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbYIRJI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 05:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbYIRJIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 05:08:20 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:3255 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752147AbYIRJIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 05:08:20 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiQFAE+30UhR9R6M/2dsb2JhbACBZLgVgWc
Date: Thu, 18 Sep 2008 11:08:14 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Oliver Schuster <olivers137@aol.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add watchdog driver IT8716 IT8718 IT8726 IT8712J/K
Message-ID: <20080918090814.GD22550@infomag.infomag.iguana.be>
References: <47C579FA.7060403@aol.com> <20080229155136.49c34bed.akpm@linux-foundation.org> <47D72865.1010304@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D72865.1010304@aol.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

> But first: Add support for it8718, which made the driver slightly more
> complex.
> Now the driver supports it8716, it8718, it8726, it8712-j and it8712-k,
> which are all 16-bit watchdog timer on ITE lpc-super-io-chips.

I added it into my linux-2.6-watchdog-mm tree. I noticed that the initialization
sequence should be done differenly (the misc_device should be registered last
because that opens up userspace to your driver).

Could you therefor test my patch and 2 check if the "misc_register(&wdt_miscdev);"
can be moved after the "/* Initialize CIR to use it as keepalive source */" part
(just before the printk(...)?

Thanks in advance,
Wim.

-------------------------------------------------------------------------------------
commit b8a047e5a678357ef2bc8c79ce539957579965dd
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Thu Sep 18 08:58:27 2008 +0000

    [WATCHDOG] it87_wdt.c - fix initialization sequence
    
    register_miscdevice gives userspace access to the device (via /dev/watchdog).
    It should therfore be done after the setting og the default value for the timeout
    and after the reboot_notifier registration.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

diff --git a/drivers/watchdog/it87_wdt.c b/drivers/watchdog/it87_wdt.c
index cbf5e83..5cd8473 100644
--- a/drivers/watchdog/it87_wdt.c
+++ b/drivers/watchdog/it87_wdt.c
@@ -625,26 +625,26 @@ static int __init it87_wdt_init(void)
 		spin_unlock_irqrestore(&spinlock, flags);
 	}
 
-	rc = misc_register(&wdt_miscdev);
-	if (rc) {
-		printk(KERN_ERR PFX
-		       "Cannot register miscdev on minor=%d (err=%d)\n",
-			wdt_miscdev.minor, rc);
-		goto err_out_region;
+	if (timeout < 1 || timeout > 65535) {
+		timeout = DEFAULT_TIMEOUT;
+		printk(KERN_WARNING PFX
+		       "Timeout value out of range, use default %d sec\n",
+		       DEFAULT_TIMEOUT);
 	}
 
 	rc = register_reboot_notifier(&wdt_notifier);
 	if (rc) {
 		printk(KERN_ERR PFX
 		       "Cannot register reboot notifier (err=%d)\n", rc);
-		goto err_out_miscdev;
+		goto err_out_region;
 	}
 
-	if (timeout < 1 || timeout > 65535) {
-		timeout = DEFAULT_TIMEOUT;
-		printk(KERN_WARNING PFX
-		       "Timeout value out of range, use default %d sec\n",
-		       DEFAULT_TIMEOUT);
+	rc = misc_register(&wdt_miscdev);
+	if (rc) {
+		printk(KERN_ERR PFX
+		       "Cannot register miscdev on minor=%d (err=%d)\n",
+			wdt_miscdev.minor, rc);
+		goto err_out_reboot;
 	}
 
 	/* Initialize CIR to use it as keepalive source */
@@ -665,8 +665,8 @@ static int __init it87_wdt_init(void)
 
 	return 0;
 
-err_out_miscdev:
-	misc_deregister(&wdt_miscdev);
+err_out_reboot:
+	unregister_reboot_notifier(&wdt_notifier);
 err_out_region:
 	release_region(base, test_bit(WDTS_USE_GP, &wdt_status) ? 1 : 8);
 	if (!test_bit(WDTS_USE_GP, &wdt_status)) {
