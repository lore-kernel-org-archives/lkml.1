Return-Path: <linux-kernel-owner+w=401wt.eu-S1755021AbYIHPxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021AbYIHPxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 11:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbYIHPx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 11:53:27 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51229 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753732AbYIHPx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 11:53:27 -0400
Subject: [PATCH] fix RTC_CLASS regression with PARISC
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Parisc List <linux-parisc@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>
Content-Type: text/plain
Date: Mon, 08 Sep 2008 10:53:25 -0500
Message-Id: <1220889205.8074.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of 2.6.26, most distribution kernels for PARISC are coming with the
wrong RTC infrastructure enabled, meaning that userland can no longer
get at the RTC, so all our parisc clocks are drifting.

The fault is this patch:

commit c750090085f260503d8beec1c73c4d2e4fe93628
Author: David Brownell <david-b@pacbell.net>
Date:   Mon Apr 28 02:11:52 2008 -0700

    rtc: avoid legacy drivers with generic framework

Which makes drivers/rtc take precedence over the generic rtc.  However,
for parisc we only have the generic rtc, so in essence this turns off
our ability to access the rtc.  Put it back again by making RTC_CLASS
unselectable if the architecture is parisc.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 9a9755c..472fb19 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -8,7 +8,7 @@ config RTC_LIB
 menuconfig RTC_CLASS
 	tristate "Real Time Clock"
 	default n
-	depends on !S390
+	depends on !(S390 || PARISC)
 	select RTC_LIB
 	help
 	  Generic RTC class support. If you say yes here, you will


