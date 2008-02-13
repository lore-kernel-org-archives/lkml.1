Return-Path: <linux-kernel-owner+w=401wt.eu-S932831AbYBMXZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932831AbYBMXZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 18:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756953AbYBMXZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 18:25:11 -0500
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:22554 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756502AbYBMXZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 18:25:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4bqSmRc1EJzALJxHizPpl+bxiFZ4mewJkWqGrz+B+q2fPUE87tisHOGo4qrsfk890WY2zUg42Ms6Doz4OivinaLQLr+tLJ+0t7IGeemwpYzK1dpXb0VAQbyNWfjKnTTscK6O/AHeWGK40bvOBLGxDGuhc6MhLu/vlGhxz7ZQSok=  ;
X-YMail-OSG: M7fpUeQVM1lrNz1T4iLDpboQgGGm0VMo26qL2rcVHtrZXdu2Wlz7JFjHRTFFqvamo1Gwi4QQ8A--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4 resend] [x86] Add generic GPIO support to x86
Date: Wed, 13 Feb 2008 15:25:05 -0800
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
Message-Id: <200802131525.05967.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 February 2008, Andrew Morton wrote:
> Someone please fix.

This is what I was using purely for test builds ... most x86 hardware
actually has no GPIOs, and I sure don't have any of the "unusual" x86
platforms here, so I'd not want to see this version merge.  Someone
more clued in on how x86 handles what ARM does with e.g. <asm/arch/...>
should make a better patch.

(And my vote is to **NOT** use the "-I..." magic that PowerPC uses,
that's just confusing as all get-out.  And not needed.)


> It would be more modern to have a <linux/gpio.h> which takes care of
> cruddy details, but it's getting too late for that.

That could be added eventually ... if the platform has GPIO support
it could include the <asm/gpio.h> else it could define all the calls
as error-returning inlines.

- Dave


========= CUT HERE
DEBUG ONLY -- make X86_PC use gpiolib.

It's not clear to me how the various x86-ish platforms should
be made to work here, since there seems to be no convention
that each platform type has its own <asm/arch/...> subdir.

---
 arch/x86/Kconfig       |    2 ++
 include/asm-x86/gpio.h |   19 ++++++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

--- g26.orig/arch/x86/Kconfig	2008-02-10 16:06:30.000000000 -0800
+++ g26/arch/x86/Kconfig	2008-02-10 16:09:44.000000000 -0800
@@ -228,6 +228,8 @@ choice
 
 config X86_PC
 	bool "PC-compatible"
+	select GENERIC_GPIO
+	select HAVE_GPIO_LIB
 	help
 	  Choose this option if your computer is a standard PC or compatible.
 
--- g26.orig/include/asm-x86/gpio.h	2008-02-10 16:06:30.000000000 -0800
+++ g26/include/asm-x86/gpio.h	2008-02-10 16:09:44.000000000 -0800
@@ -1,6 +1,23 @@
 #ifndef _ASM_I386_GPIO_H
 #define _ASM_I386_GPIO_H
 
-#include <gpio.h>
+// #include <gpio.h>
+
+#include <asm-generic/gpio.h>           /* cansleep wrappers */
+
+#define gpio_get_value	__gpio_get_value
+#define gpio_set_value	__gpio_set_value
+#define gpio_cansleep	__gpio_cansleep
+
+static inline int gpio_to_irq(unsigned gpio)
+{
+	return -ENOSYS;
+}
+
+static inline int irq_to_gpio(unsigned irq)
+{
+	return -EINVAL;
+}
+
 
 #endif /* _ASM_I386_GPIO_H */

