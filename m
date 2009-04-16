Return-Path: <linux-kernel-owner+w=401wt.eu-S1753082AbZDPAmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbZDPAmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 20:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbZDPAm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 20:42:27 -0400
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.106]:52978
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752535AbZDPAm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 20:42:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArgBALcb5kl8qNY8/2dsb2JhbAAI0S6DfQY
X-IronPort-AV: E=Sophos;i="4.40,195,1238947200"; 
   d="scan'208";a="482979595"
Subject: [PATCH] ads7846: fix unsafe disable_irq (was [REGRESSION] threaded
	interrupt handler support breaks (some) irq handling on AVR32)
From: Ben Nizette <bn@niasdigital.com>
To: dmitry.torokhov@gmail.com
Cc: tglx@linutronix.de, David Brownell <david-b@pacbell.net>,
       hskinnemoen@atmel.com, kernel@avr32linux.org,
       linux-kernel@vger.kernel.org, imre.deak@nokia.com, mingo@elte.hu,
       Bill Gatliff <bgat@billgatliff.com>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
In-Reply-To: <20090415095710.5c853a7f@hskinnemoen-d830>
References: <1239685153.19815.12.camel@linux-51e8.site>
	 <1239698225.29831.14.camel@linux-51e8.site>
	 <1239759053.29831.37.camel@linux-51e8.site>
	 <20090415095710.5c853a7f@hskinnemoen-d830>
Content-Type: text/plain
Date: Thu, 16 Apr 2009 10:41:57 +1000
Message-Id: <1239842517.29831.47.camel@linux-51e8.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-15 at 09:57 +0200, Haavard Skinnemoen wrote:
> Shouldn't that be disable_irq_nosync()?

Indeed, good catch.  That fixes it.

--------------8<--------------------

The use of disable_irq inside the handler for the interrupt being
disabled has always been dangerous.  disable_irq should wait for that
handler to complete before returning -> deadlock.

For some reason this wasn't actually the case until 3aa551c9b was merged
but since this time, the ads7846 driver has deadlocked the system on
first interrupt.

Convert the driver to use the handler-safe _nosync variant.

Signed-off-by: Ben Nizette <bn@niasdigital.com>

---

diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index 61b4a02..f2513e6 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -746,7 +746,7 @@ static irqreturn_t ads7846_irq(int irq, void *handle)
 			 * that here.  (The "generic irq" framework may help...)
 			 */
 			ts->irq_disabled = 1;
-			disable_irq(ts->spi->irq);
+			disable_irq_nosync(ts->spi->irq);
 			ts->pending = 1;
 			hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_DELAY),
 					HRTIMER_MODE_REL);


