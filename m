Return-Path: <linux-kernel-owner+w=401wt.eu-S1752560Ab0AWWmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab0AWWmY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 17:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956Ab0AWWmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 17:42:23 -0500
Received: from ns.penguin.cz ([84.21.108.25]:58325 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255Ab0AWWmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 17:42:22 -0500
Subject: gpio_keys and how PXA27x sets gpio_set_wake() (was Re: sharp
 c-3000 aka spitz: fix warn_on introduced in 2.6.32-rc1)
From: Stanislav Brabec <utx@penguin.cz>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, thommycheck@gmail.com, dbaryshkov@gmail.com,
       dtor@mail.ru, arminlitzel@web.de, linux-input@vger.kernel.org,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       "Rafael J. Wysocki" <rjw@sisk.pl>, lenz@cs.wisc.edu, rpurdie@rpsys.net,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Pavel Machek <pavel@ucw.cz>, Cyril Hrubis <metan@ucw.cz>,
       zaurus-devel@www.linuxtogo.org, omegamoon@gmail.com
In-Reply-To: <1264275669.9100.11.camel@utx.utx.cz>
References: <20100106071026.GD1382@ucw.cz>
	 <f17812d71001052317h2bf25fady6bd729b35ef6db63@mail.gmail.com>
	 <20100107065230.GA1303@ucw.cz>
	 <f17812d71001062333y2e49fa21scf91718da9ae3091@mail.gmail.com>
	 <1264275669.9100.11.camel@utx.utx.cz>
Content-Type: text/plain; charset="ISO-8859-2"
Date: Sat, 23 Jan 2010 23:43:31 +0100
Message-Id: <1264286611.11766.49.camel@utx.utx.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanislav Brabec wrote:

> Looking deeper into it, the problem seems to be elsewhere:
> I just added debug message to start and end of set_irq_wake().

> I think that if (desc->wake_depth == 0) when set_irq_wake(foo, 1) is
> done, then something went wrong. And it is not surprise, that it reports
> Unbalanced IRQ on resume.

Going even deeper, I see:
set_irq_wake() started IRQ: 191 to 1, desc->wake_depth: 0
pxa27x_set_wake() IRQ: 191 to 1, GPIO: 95
pxa27x_set_wake() calling gpio_set_wake()
gpio_set_wake() GPIO: 95, on: 1
gpio_set_wake() returning EINVAL (keypad_gpio)
set_irq_wake() done IRQ: 191 to 1, desc->wake_depth: 0

IRQ 191 is associated with GPIO 95. GPIO 95 is listed as one of GPIO
supported by Power Manager Keyboard Wake-Up Enable Register (PKWR, see
pxa27x_pkwr_gpio[] in arch/arm/mach-pxa/mfp-pxa2xx.c) (section 3.8.1.15
of Intel PXA27x Processor Family Developer's Manual).

gpio_set_wake() in arch/arm/mach-pxa/mfp-pxa2xx.c explicitly refuses to
configure PWER capable registers.

To finish the mess, spitz_presuspend() from arch/arm/mach-pxa/spitz_pm.c
reprograms all wake-up registers on its own.

So I see two possible fixes:

1) Follow include/linux/interrupt.h:
   When
 * requesting an interrupt without specifying a IRQF_TRIGGER, the
 * setting should be assumed to be "as already configured", which
 * may be as per machine or firmware initialisation.

and keep the spitz_pm.c code.

It would mean that gpio_set_wake() should be able to set keypad
interrpupts. The code would be very uncomfortable. Without knowing
whether the GPIO is programmed for by PKWR or PWER, it needs one extra
translation and register lookup. Or one extra record in the table and a
more complicated initialization in the platform file.

2) gpio_keys driver should be capable to set IRQF_TRIGGER_* and no
settings of wake-up registers in spitz_pm.c would not be needed.

On platforms with shared interrupts it would introduce possible multiple
trigger initialization (not a big problem). But it would easily
introduce breakage if programmer makes a mistake and configures
interrupt with different trigger in different drivers.


I am not sure what solution of these two is in spirit of modern kernels.
I guess that 2. Especially because somebody may want to use gpio_keys on
a different machine/GPIO layout that would require different
IRQF_TRIGGER_*.


Notes:

Automatic PKWR/PWER logic is impossible for PXA270. GPIO 38 can be
programmed to use both PKWR or PWER.

The gpio_keys seems to have problems with debounce - in 50% of all
resumes, Zaurus goes back to sleep in a second or so.

Adding debugging patch for your convenience:

diff --git a/arch/arm/mach-pxa/mfp-pxa2xx.c b/arch/arm/mach-pxa/mfp-pxa2xx.c
index cf6b720..4e82cea 100644
--- a/arch/arm/mach-pxa/mfp-pxa2xx.c
+++ b/arch/arm/mach-pxa/mfp-pxa2xx.c
@@ -168,22 +168,35 @@ int gpio_set_wake(unsigned int gpio, unsigned int on)
 {
 	struct gpio_desc *d;
 	unsigned long c, mux_taken;
+printk(KERN_INFO "gpio_set_wake() GPIO: %d, on: %d\n", gpio, on);
 
 	if (gpio > mfp_to_gpio(MFP_PIN_GPIO127))
+{
+printk(KERN_INFO "gpio_set_wake() returning EINVAL\n");
 		return -EINVAL;
+}
 
 	d = &gpio_desc[gpio];
 	c = d->config;
 
 	if (!d->valid)
+{
+printk(KERN_INFO "gpio_set_wake() returning EINVAL (not valid)\n");
 		return -EINVAL;
+}
 
 	if (d->keypad_gpio)
+{
+printk(KERN_INFO "gpio_set_wake() returning EINVAL (keypad_gpio)\n");
 		return -EINVAL;
+}
 
 	mux_taken = (PWER & d->mux_mask) & (~d->mask);
 	if (on && mux_taken)
+{
+printk(KERN_INFO "gpio_set_wake() returning EBUSY\n");
 		return -EBUSY;
+}
 
 	if (d->can_wakeup && (c & MFP_LPM_CAN_WAKEUP)) {
 		if (on) {
@@ -203,6 +216,7 @@ int gpio_set_wake(unsigned int gpio, unsigned int on)
 			PRER &= ~d->mask;
 			PFER &= ~d->mask;
 		}
+printk(KERN_INFO "gpio_set_wake() modified P?ER\n");
 	}
 	return 0;
 }
diff --git a/arch/arm/mach-pxa/pxa27x.c b/arch/arm/mach-pxa/pxa27x.c
index 6a0b731..7fef6b1 100644
--- a/arch/arm/mach-pxa/pxa27x.c
+++ b/arch/arm/mach-pxa/pxa27x.c
@@ -320,11 +320,18 @@ static int pxa27x_set_wake(unsigned int irq, unsigned int on)
 	int gpio = IRQ_TO_GPIO(irq);
 	uint32_t mask;
 
+	printk(KERN_INFO "pxa27x_set_wake() IRQ: %d to %d, GPIO: %d\n", irq, on, gpio);
 	if (gpio >= 0 && gpio < 128)
+{
+	printk(KERN_INFO "pxa27x_set_wake() calling gpio_set_wake()\n");
 		return gpio_set_wake(gpio, on);
+}
 
 	if (irq == IRQ_KEYPAD)
+{
+	printk(KERN_INFO "pxa27x_set_wake() calling keypad_set_wake(()\n");
 		return keypad_set_wake(on);
+}
 
 	switch (irq) {
 	case IRQ_RTCAlrm:
@@ -334,6 +341,7 @@ static int pxa27x_set_wake(unsigned int irq, unsigned int on)
 		mask = 1u << 26;
 		break;
 	default:
+	printk(KERN_INFO "pxa27x_set_wake() returning EINVAL\n");
 		return -EINVAL;
 	}
 
@@ -341,6 +349,7 @@ static int pxa27x_set_wake(unsigned int irq, unsigned int on)
 		PWER |= mask;
 	else
 		PWER &=~mask;
+	printk(KERN_INFO "pxa27x_set_wake() modified PWER\n");
 
 	return 0;
 }
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index eb6078c..e5d2187 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -344,6 +344,7 @@ int set_irq_wake(unsigned int irq, unsigned int on)
 	unsigned long flags;
 	int ret = 0;
 
+printk(KERN_INFO "set_irq_wake() started IRQ: %d to %d, desc->wake_depth: %d\n", irq, on, desc->wake_depth);
 	/* wakeup-capable irqs can be shared between drivers that
 	 * don't need to have the same sleep mode behaviors.
 	 */
@@ -369,6 +370,7 @@ int set_irq_wake(unsigned int irq, unsigned int on)
 	}
 
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
+printk(KERN_INFO "set_irq_wake() done IRQ: %d to %d, desc->wake_depth: %d\n", irq, on, desc->wake_depth);
 	return ret;
 }
 EXPORT_SYMBOL(set_irq_wake);



________________________________________________________________________
Stanislav Brabec
http://www.penguin.cz/~utx/zaurus

