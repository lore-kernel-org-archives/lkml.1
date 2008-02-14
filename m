Return-Path: <linux-kernel-owner+w=401wt.eu-S1758363AbYBNCCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363AbYBNCCi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 21:02:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbYBNCC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 21:02:27 -0500
Received: from smtp103.sbc.mail.re2.yahoo.com ([68.142.229.102]:33654 "HELO
	smtp103.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751521AbYBNCCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 21:02:14 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2008 21:02:13 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=XmC1XpaPDoL4qe427RV5NETWybU/BNgAw1a80zLYDhNSivQ44jd79IaNlnGS6szfaCPm/aHyhOAAKG2pgtjFl7wJiZSUoUeG1t1jkXuA2PUqV9jigxXKevfC8+p4LcRNuoZOoFmzX9CUbGw/1HApRL6nLyO0G9jQzAajU6d9Ho8=  ;
X-YMail-OSG: EKlLoK8VM1k5I80JPqTpPRMlE8HMUWHOcMqlqaHS7_.QXZbgqi_FpzpJ3L9t8Qqa99AencpXP3Z8dfSZwPd3vPff0FMxycsDdp2wQkz30wyYw.mrzV524Ct99WId5pULYoxYrcQ4V9gjwag-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4 resend] [x86] Add generic GPIO support to x86
Date: Wed, 13 Feb 2008 17:55:30 -0800
User-Agent: KMail/1.9.6
Cc: Florian Fainelli <florian.fainelli@telecomint.eu>,
       linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
       Ingo Molnar <mingo@elte.hu>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
References: <200710181551.24912.florian.fainelli@telecomint.eu> <20080213140258.78380f5d.akpm@linux-foundation.org>
In-Reply-To: <20080213140258.78380f5d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802131755.30921.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 February 2008, Andrew Morton wrote:
> It would be more modern to have a <linux/gpio.h> which takes care of
> cruddy details, but it's getting too late for that.

Sort of like this?  For drivers that don't want to list themselves
in Kconfig as depending on GENERIC_GPIO (e.g. one NAND driver I heard
about), this lets them use <linux/gpio.h> ... existing code can't
break, and it won't hurt if new code uses this.

- Dave


============== CUT HERE
Add a <linux/gpio.h> defining fail/warn stubs for GPIO calls on
platforms that don't support the GPIO programming interface.  It
includes the arch-specific interface glue otherwise.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 include/linux/gpio.h |   93 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 93 insertions(+)

--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ g26/include/linux/gpio.h	2008-02-13 17:40:06.000000000 -0800
@@ -0,0 +1,93 @@
+#ifndef __LINUX_GPIO_H
+#define __LINUX_GPIO_H
+
+#ifdef CONFIG_GENERIC_GPIO
+#include <asm/gpio.h>
+
+#else
+
+/*
+ * Some platforms don't support the GPIO programming interface.
+ *
+ * In case some driver uses it anyway (it should normally have
+ * depended on GENERIC_GPIO), these routines help the compiler
+ * optimize out much GPIO-related code ... or trigger a runtime
+ * warning when something is wrongly called.
+ */
+
+static inline int gpio_is_valid(int number)
+{
+	return 0;
+}
+
+static inline int gpio_request(unsigned gpio, const char *label)
+{
+	return -EINVAL;
+}
+
+static inline void gpio_free(unsigned gpio)
+{
+	/* GPIO can never have been requested */
+	WARN_ON(1);
+}
+
+static inline int gpio_direction_input(unsigned gpio)
+{
+	return -EINVAL;
+}
+
+static inline int gpio_direction_output(unsigned gpio, int value)
+{
+	return -EINVAL;
+}
+
+static inline int gpio_get_value(unsigned gpio)
+{
+	/* GPIO can never have been requested or set as {in,out}put */
+	WARN_ON(1);
+	return 0;
+}
+
+static inline void gpio_set_value(unsigned gpio, int value)
+{
+	/* GPIO can never have been requested or set as output */
+	WARN_ON(1);
+}
+
+static int gpio_cansleep(unsigned gpio)
+{
+	/* GPIO can never have been requested or set as {in,out}put */
+	WARN_ON(1);
+	return 0;
+}
+
+static inline int gpio_get_value_cansleep(unsigned gpio)
+{
+	/* GPIO can never have been requested or set as {in,out}put */
+	WARN_ON(1);
+	return 0;
+}
+
+static inline void gpio_set_value_cansleep(unsigned gpio, int value)
+{
+	/* GPIO can never have been requested or set as output */
+	WARN_ON(1);
+}
+
+static inline int gpio_to_irq(unsigned gpio)
+{
+	/* GPIO can never have been requested or set as input */
+	WARN_ON(1);
+	return -EINVAL;
+}
+
+static inline int irq_to_gpio(unsigned irq)
+{
+	/* irq can never have been returned from gpio_to_irq() */
+	WARN_ON(1);
+	return -EINVAL;
+}
+
+#endif
+
+#endif /* __LINUX_GPIO_H */

