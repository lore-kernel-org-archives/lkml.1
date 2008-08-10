Return-Path: <linux-kernel-owner+w=401wt.eu-S1754063AbYHJQ3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbYHJQ3j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 12:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbYHJQ3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 12:29:31 -0400
Received: from isilmar.linta.de ([213.133.102.198]:37951 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752346AbYHJQ3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 12:29:30 -0400
Date: Sun, 10 Aug 2008 18:29:20 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Andreas Mohr <andi@lisas.de>
Cc: LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-acpi@vger.kernel.org
Subject: Re: ACPI PM-Timer on K6-3 SiS5591: Houston...
Message-ID: <20080810162920.GA9860@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Andreas Mohr <andi@lisas.de>, LKML <linux-kernel@vger.kernel.org>,
	john stultz <johnstul@us.ibm.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-acpi@vger.kernel.org
References: <20080810101730.GA10024@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080810101730.GA10024@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

On Sun, Aug 10, 2008 at 12:17:30PM +0200, Andreas Mohr wrote:
> Result: catastrophic timer behaviour (a large backwards skip is possible),
> even in case we do a triple-read workaround, due to a floating bit at
> 0x0400 (possibly caused by underclocking from 400 to 150, but whatever...).

this isn't the bug which is handled by the read-three-times-workaround.
Instead, that handels the following PIIX4 errata:

 * PIIX4 Errata:
 *
 * The power management timer may return improper results when read.
 * Although the timer value settles properly after incrementing,
 * while incrementing there is a 3 ns window every 69.8 ns where the
 * timer value is indeterminate (a 4.2% chance that the data will be
 * incorrect when read). As a result, the ACPI free running count up
 * timer specification is violated due to erroneous reads.

> And my system does pass the bootup PM-Timer check quite often despite
> this severe defect (2 in 4 bootups _did_ register my defective
> acpi_pm clocksource).

No surprise there -- it is the first time I see such an error; and it might
actually be a bug specific to your computer's motherboard. 

> I realized that in historic versions (e.g. 2.6.12) read_pmtmr()
> encompassed the _entire_ "triple-reading due to latch bug" logic.
> Nowadays read_pmtmr() is the raw inline version of a single inl() only!
> However despite this large change, the initial hardware check
> (at init_acpi_pm_clocksource()) _kept using_ the now single-read read_pmtmr()
> as if nothing had happened.

See patch below. Is there a proper format modifier for cycle_t ?

> Both issues are caused by very weak monotony verification in
> init_acpi_pm_clocksource(), thus that init check should get improved
> by leaps and bounds instead of stupidly exiting at the very first sign of a
> working timer (or maybe even create a generic "verify counter increment" function to be used for all sorts of hardware counters of a configurable counter width?).
> I.e. something like
> if (timer_ok(timeout_loops, num_checks, counter_width, read_val_func()))
> 	"everything's ok"

Well, we could do something like this for sure, but I haven't seen any other
such bug report before...

> - "known good workaround" systems should provide workaround from the beginning
=> see patch below.
> - initial timer check should then do at least 10 increment checks with
>   10 of 10 successful
=> might do this, but currently I'm not yet convinced whether we really need
it.

Best,
	Dominik


acpi_pm.c: use proper read function also in errata mode.

When acpi_pm is used in errata mode (three reads instead of one), also the
acpi_pm init functions need to use three reads instead of just one.

Thanks to Andreas Mohr for spotting this issue.

Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.de>

diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index 5ca1d80..2c00edd 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -151,13 +151,13 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_LE,
  */
 static int verify_pmtmr_rate(void)
 {
-	u32 value1, value2;
+	cycle_t value1, value2;
 	unsigned long count, delta;
 
 	mach_prepare_counter();
-	value1 = read_pmtmr();
+	value1 = clocksource_acpi_pm.read()
 	mach_countup(&count);
-	value2 = read_pmtmr();
+	value2 = clocksource_acpi_pm.read()
 	delta = (value2 - value1) & ACPI_PM_MASK;
 
 	/* Check that the PMTMR delta is within 5% of what we expect */
@@ -177,7 +177,7 @@ static int verify_pmtmr_rate(void)
 
 static int __init init_acpi_pm_clocksource(void)
 {
-	u32 value1, value2;
+	cycle_t value1, value2;
 	unsigned int i;
 
 	if (!pmtmr_ioport)
@@ -187,9 +187,9 @@ static int __init init_acpi_pm_clocksource(void)
 						clocksource_acpi_pm.shift);
 
 	/* "verify" this timing source: */
-	value1 = read_pmtmr();
+	value1 = clocksource_acpi_pm.read();
 	for (i = 0; i < 10000; i++) {
-		value2 = read_pmtmr();
+		value2 = clocksource_acpi_pm.read();
 		if (value2 == value1)
 			continue;
 		if (value2 > value1)
@@ -197,11 +197,11 @@ static int __init init_acpi_pm_clocksource(void)
 		if ((value2 < value1) && ((value2) < 0xFFF))
 			goto pm_good;
 		printk(KERN_INFO "PM-Timer had inconsistent results:"
-			" 0x%#x, 0x%#x - aborting.\n", value1, value2);
+			" 0x%#llx, 0x%#llx - aborting.\n", value1, value2);
 		return -EINVAL;
 	}
 	printk(KERN_INFO "PM-Timer had no reasonable result:"
-			" 0x%#x - aborting.\n", value1);
+			" 0x%#llx - aborting.\n", value1);
 	return -ENODEV;
 
 pm_good:
