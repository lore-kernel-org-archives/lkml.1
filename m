Return-Path: <linux-kernel-owner+w=401wt.eu-S1763524AbXKNBCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763524AbXKNBCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 20:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757483AbXKNBCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 20:02:42 -0500
Received: from nz-out-0506.google.com ([64.233.162.236]:10985 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633AbXKNBCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 20:02:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lt17fN5L7f6drH69HPTxc2K+kmfXtlV0dI+ey4vSy9mz1is7DollpsB/YInLygF0pz1a+kRkaKDrrkJxCPlBa9WTAzt/bBRHvNGeD71LzSZtuETJExLM9wIbTb/3Wi6FQPDwnx+B3IyTGgjQ0M50PMGzgiLGRarLZVXjrdtmA8M=
Message-ID: <f17812d70711131702m4315a1f3ia16e1d0fedf30825@mail.gmail.com>
Date: Wed, 14 Nov 2007 09:02:40 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [patch/rfc 1/4] GPIO implementation framework
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Felipe Balbi" <felipebalbi@users.sourceforge.net>,
       "Bill Gatliff" <bgat@billgatliff.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Andrew Victor" <andrew@sanpeople.com>,
       "Tony Lindgren" <tony@atomide.com>, "Jean Delvare" <khali@linux-fr.org>,
       "Kevin Hilman" <khilman@mvista.com>, "Paul Mundt" <lethal@linux-sh.org>,
       "Ben Dooks" <ben@trinity.fluff.org>
In-Reply-To: <f17812d70711131700n74236a8naa6dbfc5cb62e42d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710291809.29936.david-b@pacbell.net>
	 <200711051305.13980.david-b@pacbell.net>
	 <f17812d70711121828k49fe25b4ycf538061d0fb33b4@mail.gmail.com>
	 <200711131106.11277.david-b@pacbell.net>
	 <f17812d70711131657wbdcc089kadb6024a47ad4a3@mail.gmail.com>
	 <f17812d70711131700n74236a8naa6dbfc5cb62e42d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

so that requested will always be used, only *requested_str will be used
for DEBUG_FS tracking assistance

Subject: [PATCH 2/5] define gpio_chip.requested_str as a debugfs tracking string

---
 include/asm-generic/gpio.h |   11 ++---------
 lib/gpiolib.c              |   34 ++++++++++++++--------------------
 2 files changed, 16 insertions(+), 29 deletions(-)

diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index d00a287..ba3e336 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -73,13 +73,10 @@ struct gpio_chip {

 	/* other fields are modified by the gpio library only */
 	DECLARE_BITMAP(is_out, ARCH_GPIOS_PER_CHIP);
+	DECLARE_BITMAP(requested, ARCH_GPIOS_PER_CHIP);

 #ifdef CONFIG_DEBUG_FS
-	/* fat bits */
-	const char		*requested[ARCH_GPIOS_PER_CHIP];
-#else
-	/* thin bits */
-	DECLARE_BITMAP(requested, ARCH_GPIOS_PER_CHIP);
+	const char		*requested_str[ARCH_GPIOS_PER_CHIP];
 #endif
 };

@@ -89,11 +86,7 @@ struct gpio_chip {
 static inline int
 gpiochip_is_requested(struct gpio_chip *chip, unsigned offset)
 {
-#ifdef CONFIG_DEBUG_FS
-	return chip->requested[offset] != NULL;
-#else
 	return test_bit(offset, chip->requested);
-#endif
 }

 /* add/remove chips */
diff --git a/lib/gpiolib.c b/lib/gpiolib.c
index c627efb..d52c7f1 100644
--- a/lib/gpiolib.c
+++ b/lib/gpiolib.c
@@ -48,12 +48,11 @@ static void gpio_ensure_requested(struct gpio_chip
*chip, unsigned offset)
 {
 	int		requested;

+	requested = test_and_set_bit(offset, chip->requested);
+
 #ifdef CONFIG_DEBUG_FS
-	requested = (int) chip->requested[offset];
 	if (!requested)
-		chip->requested[offset] = "(auto)";
-#else
-	requested = test_and_set_bit(offset, chip->requested);
+		chip->requested_str[offset] = "(auto)";
 #endif

 	if (!requested)
@@ -158,16 +157,13 @@ int gpio_request(unsigned gpio, const char *label)
 	 */

 	status = 0;
-#ifdef CONFIG_DEBUG_FS
-	if (!label)
-		label = "?";
-	if (chip->requested[gpio])
-		status = -EBUSY;
-	else
-		chip->requested[gpio] = label;
-#else
+
 	if (test_and_set_bit(gpio, chip->requested))
 		status = -EBUSY;
+
+#ifdef CONFIG_DEBUG_FS
+	if (status == 0)
+		chip->requested_str[gpio] = (label == NULL) ? "?" : label;
 #endif

 done:
@@ -190,14 +186,12 @@ void gpio_free(unsigned gpio)

 	gpio -= chip->base;

-#ifdef CONFIG_DEBUG_FS
-	if (chip->requested[gpio])
-		chip->requested[gpio] = NULL;
-	else
-		chip = NULL;
-#else
 	if (!test_and_clear_bit(gpio, chip->requested))
 		chip = NULL;
+
+#ifdef CONFIG_DEBUG_FS
+	if (chip != NULL)
+		chip->requested_str[gpio] = NULL;
 #endif
 	WARN_ON(extra_checks && chip == NULL);
 done:
@@ -400,14 +394,14 @@ static void gpiolib_dbg_show(struct seq_file *s,
struct gpio_chip *chip)
 		unsigned	gpio;
 		int		is_out;

-		if (!chip->requested[i])
+		if (!chip->requested_str[i])
 			continue;

 		gpio = chip->base + i;
 		is_out = test_bit(i, chip->is_out);

 		seq_printf(s, " gpio-%-3d (%-12s) %s %s",
-			gpio, chip->requested[i],
+			gpio, chip->requested_str[i],
 			is_out ? "out" : "in ",
 			chip->get
 				? (chip->get(chip, i) ? "hi" : "lo")
-- 
1.5.2.5.GIT
