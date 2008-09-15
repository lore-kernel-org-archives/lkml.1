Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbYIOUDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbYIOUDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 16:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbYIOUCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 16:02:52 -0400
Received: from atlas.informatik.uni-freiburg.de ([132.230.150.3]:39904 "EHLO
	atlas.informatik.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753653AbYIOUCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 16:02:51 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <david-b@pacbell.net>,
       Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
       Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH] gpio_free might sleep, generic part
Date: Mon, 15 Sep 2008 22:02:39 +0200
Message-Id: <1221508963-27259-1-git-send-email-ukleinek@informatik.uni-freiburg.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1216884515-12084-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
References: <1216884515-12084-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: Universitaet Freiburg, Institut f. Informatik
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the documentation gpio_free should only be called from task
context only.  To make this more explicit add a might sleep to all
implementations.

This is the generic part which changes gpiolib and the fallback
implementation only.

Signed-off-by: Uwe Kleine-König <ukleinek@informatik.uni-freiburg.de>
Cc: David Brownell <david-b@pacbell.net>
Cc: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
---
Hello,

this is a new version of the patch I sent on 2008-07-24 07:28:35 GMT
(http://thread.gmane.org/gmane.linux.kernel/711078)

David Brownell suggested (via private mail) to split the patch along
arch lines.  I did that, added Blackfin (which I missed last time) and
left out DaVinci (in ARCH=arm) on Dave's request.

Something that really made me happy is that git managed to use the old
patch although many includes for arm changed location with only three
conflicts.

Note the series is not compile tested because I only have an x86
compiler handy at the moment.

Best regards
Uwe

 drivers/gpio/gpiolib.c |    2 ++
 include/linux/gpio.h   |    3 +++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 8d29405..317004f 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -792,6 +792,8 @@ void gpio_free(unsigned gpio)
 	unsigned long		flags;
 	struct gpio_desc	*desc;
 
+	might_sleep();
+
 	if (!gpio_is_valid(gpio)) {
 		WARN_ON(extra_checks);
 		return;
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 730a20b..e10c49a 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -8,6 +8,7 @@
 
 #else
 
+#include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 
@@ -32,6 +33,8 @@ static inline int gpio_request(unsigned gpio, const char *label)
 
 static inline void gpio_free(unsigned gpio)
 {
+	might_sleep();
+
 	/* GPIO can never have been requested */
 	WARN_ON(1);
 }
-- 
1.5.6.5

