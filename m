Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbYIGKAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbYIGKAU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 06:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbYIGKAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 06:00:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:29142 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbYIGKAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 06:00:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KAsGDdczPlKi591oyFnkOx1+/nMRlJnds/KWZnmCM/pNdVc293Obp5GXce6v6PJfym
         nVxPU39de/Tbiltie1JVwTjmmt3Vz4ngh+lv2t2erzvbul/2bO92gNJ0uOp+sLGWjECb
         4qExNS8bdVxUhS5btj8aGLzhdqEu8M6a/VGm8=
Date: Sun, 7 Sep 2008 14:00:00 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, yhlu.kernel@gmail.com
Subject: Re: [patch 3/3] x86: io-apic - code style cleaning for
	setup_IO_APIC_irqs
Message-ID: <20080907100000.GA7515@lenovo>
References: <20080904183748.950151853@gmail.com>> <48c02b6a.0637560a.15e9.ffffa39d@mx.google.com> <20080905080447.GC12409@elte.hu> <20080905180126.GA19334@lenovo> <20080905181111.GG27395@elte.hu> <20080905183347.GB19334@lenovo> <20080905183835.GA19215@elte.hu> <20080906101533.GA7273@lenovo> <Pine.LNX.4.55.0809061938250.13851@cliff.in.clinika.pl> <20080906184914.GG21872@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080906184914.GG21872@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Sat, Sep 06, 2008 at 08:49:14PM +0200]
| 
| * Maciej W. Rozycki <macro@linux-mips.org> wrote:
| 
| > On Sat, 6 Sep 2008, Cyrill Gorcunov wrote:
| > 
| > > Ingo, how about the following approach? We don't introduce new
| > > functions but rather srink the code by new printout form.
| > 
| >  Honestly, this one should probably use sprintf() or suchlike to avoid the
| > mess of printk() calls building a line of output from pieces.  It's quite
| > easy to calculate here what the maximum size of the buffer required could
| > be and automatic arrays can have variable size, so no need for the hassle
| > of heap management.  Calls to printk() without a trailing newline should
| > be avoided where possible as it messes up logging priority if a message
| > pops up from an interrupt inbetween.
| 
| hm, is it worth the trouble? This is during very early init.
| 
| 	Ingo
| 

Ingo, Maciej,

here is an another attempt to satisfy the requirements :)
Please review and comment if it looks better or worse now.

		- Cyrill -

---
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH] x86: io-apic - cleanup of setup_IO_APIC_irqs v3

Use local buffer to accumulate all not connected pin info
on each io-apic and printout it if needed.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---


Index: linux-2.6.git/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/io_apic.c	2008-09-07 10:10:15.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/io_apic.c	2008-09-07 13:50:46.000000000 +0400
@@ -1514,46 +1514,69 @@ static void setup_IO_APIC_irq(int apic, 
 	ioapic_write_entry(apic, pin, entry);
 }
 
+/* check and setup io-apic irq */
+static int __init setup_ioapic_irq(int apic, int pin)
+{
+	int idx, irq;
+
+	idx = find_irq_entry(apic, pin, mp_INT);
+	if (idx == -1)
+		return -1;
+
+	irq = pin_2_irq(idx, apic, pin);
+
+#ifdef CONFIG_X86_32
+	if (multi_timer_check(apic, irq))
+		return 0;
+#endif
+
+	add_pin_to_irq(irq, apic, pin);
+	setup_IO_APIC_irq(apic, pin, irq,
+			irq_trigger(idx), irq_polarity(idx));
+	return 0;
+}
+
 static void __init setup_IO_APIC_irqs(void)
 {
-	int apic, pin, idx, irq;
-	int notcon = 0;
+	int apic, pin;
+	char buf[64], *p;
+	int len;
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
+	p = buf, buf[0] = 0, len = 0;
+
 	for (apic = 0; apic < nr_ioapics; apic++) {
 		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
 
-			idx = find_irq_entry(apic, pin, mp_INT);
-			if (idx == -1) {
-				apic_printk(APIC_VERBOSE,
-					KERN_DEBUG " %d-%d",
-					mp_ioapics[apic].mp_apicid, pin);
-				if (!notcon)
-					notcon = 1;
+			if (!setup_ioapic_irq(apic, pin))
 				continue;
-			}
 
-			irq = pin_2_irq(idx, apic, pin);
-#ifdef CONFIG_X86_32
-			if (multi_timer_check(apic, irq))
+			/*
+			 * pin is not connected
+			 *  - we try to save this info in the buffer
+			 *    and print it out later
+			 *  - we don't expect too much not connected
+			 *    pins (as MP specification says the maximum
+			 *    value is 2 not connected pins) but if we
+			 *    have buggy BIOS or just get too many of them -
+			 *    truncate output with "..."
+			 */
+			if (!p)
 				continue;
-#endif
-			add_pin_to_irq(irq, apic, pin);
-
-			setup_IO_APIC_irq(apic, pin, irq,
-					irq_trigger(idx), irq_polarity(idx));
+			len += snprintf(p + len, sizeof(buf) - len, " %d-%d",
+					mp_ioapics[apic].mp_apicid, pin);
+			if (len >= sizeof(buf)) {
+				memcpy(&buf[sizeof(buf) - 4], "...", 3);
+				p = NULL;
+			}
 		}
-		if (notcon) {
-			apic_printk(APIC_VERBOSE,
-				KERN_DEBUG " (apicid-pin) not connected\n");
-			notcon = 0;
+		if (buf[0]) {
+			apic_printk(APIC_VERBOSE, KERN_DEBUG
+				" (apicid-pin) not connected:%s\n", buf);
+			p = buf, buf[0] = 0, len = 0;
 		}
 	}
-
-	if (notcon)
-		apic_printk(APIC_VERBOSE,
-			KERN_DEBUG " (apicid-pin) not connected\n");
 }
 
 /*
