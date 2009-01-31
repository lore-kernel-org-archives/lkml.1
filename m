Return-Path: <linux-kernel-owner+w=401wt.eu-S1752167AbZAaOIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbZAaOIj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 09:08:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbZAaOIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 09:08:18 -0500
Received: from smtp-out.neti.ee ([194.126.126.44]:56360 "EHLO smtp-out.neti.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155AbZAaOIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 09:08:16 -0500
X-Greylist: delayed 752 seconds by postgrey-1.27 at vger.kernel.org; Sat, 31 Jan 2009 09:08:16 EST
X-SMTP-Auth-NETI-Businesmail: no
Message-ID: <49845853.3020402@artecdesign.ee>
Date: Sat, 31 Jan 2009 15:55:31 +0200
From: Andrei Birjukov <andrei.birjukov@artecdesign.ee>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux@maxim.org.za
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix for Atmel AT91 powersaving
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

We've discovered that our AT91SAM9260 board consumed too much power when 
returning from a slowclock low-power mode. RAM self-refresh is enabled 
in a bootloader in our case, this is how we saw a difference. Estimated 
ca. 30mA more on 4V battery than the same state before powersaving. 
After a small research we found that there seems to be a bogus 
sdram_selfrefresh_disable() call at the end of at91_pm_enter() call, 
which overwrites the LPR register with uninitialized value. Please find 
the suggested patch attached.

The below patch is tested and works ok. The patch was generated against 
a 2.6.28 kernel with no additional patches.

Regards,
andrei

---
This patch fixes correct restoring of LPR register of the Atmel AT91 
SDRAM controller
when returning from a power saving mode.

Signed-off-by: Andrei Birjukov <andrei.birjukov@artecdesign.ee>

---
diff -purN linux-2.6.28-clean/arch/arm/mach-at91/pm.c 
linux-2.6.28/arch/arm/mach-at91/pm.c
--- linux-2.6.28-clean/arch/arm/mach-at91/pm.c    2008-12-25 
01:26:37.000000000 +0200
+++ linux-2.6.28/arch/arm/mach-at91/pm.c    2009-01-20 
13:00:01.000000000 +0200
@@ -332,7 +332,6 @@ static int at91_pm_enter(suspend_state_t
             at91_sys_read(AT91_AIC_IPR) & at91_sys_read(AT91_AIC_IMR));
 
 error:
-    sdram_selfrefresh_disable();
     target_state = PM_SUSPEND_ON;
     at91_irq_resume();
     at91_gpio_resume();


-- 
Andrei Birjukov
Embedded Software Engineer
Artec Design LLC
Akadeemia tee 23a, 12618, Tallinn, Estonia
Phone: +3726718559
Fax: +3726718555
GSM: +37256908939
E-mail: andrei.birjukov@artecdesign.ee
WWW: http://www.artecdesign.com

