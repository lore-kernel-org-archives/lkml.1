Return-Path: <linux-kernel-owner+w=401wt.eu-S1758879AbYHRUmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879AbYHRUmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 16:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758649AbYHRUmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 16:42:21 -0400
Received: from isilmar.linta.de ([213.133.102.198]:42372 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758351AbYHRUmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 16:42:19 -0400
Date: Mon, 18 Aug 2008 22:42:10 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, johnstul@us.ibm.com,
       hirofumi@mail.parknet.co.jp, alan@lxorguk.ukuu.org.uk,
       arjan@infradead.org
Subject: Re: [PATCH 2/2] acpi_pm.c: check for monotonicity
Message-ID: <20080818204210.GA21678@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org, johnstul@us.ibm.com,
	hirofumi@mail.parknet.co.jp, alan@lxorguk.ukuu.org.uk,
	arjan@infradead.org
References: <20080810162920.GA9860@comet.dominikbrodowski.net> <20080810190759.GA1879@rhlx01.hs-esslingen.de> <20080818190325.GA12581@comet.dominikbrodowski.net> <20080818121924.6b61f7af.akpm@linux-foundation.org> <20080818193517.GA22097@isilmar.linta.de> <20080818124755.162f24d1.akpm@linux-foundation.org> <20080818200916.GA18209@comet.dominikbrodowski.net> <20080818201115.GC18209@comet.dominikbrodowski.net> <20080818201844.GA3506@rhlx01.hs-esslingen.de> <20080818132858.b844a1d4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080818132858.b844a1d4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Aug 18, 2008 at 01:28:58PM -0700, Andrew Morton wrote:
> > On Mon, Aug 18, 2008 at 10:11:15PM +0200, Dominik Brodowski wrote:
> > > +	if (good != 10) {
> > > +		printk(KERN_INFO "PM-Timer had no reasonable result:"
> > > +		       " 0x%#llx - aborting.\n", value1);
> > > +		return -ENODEV;
> > >  	}
> > > -	printk(KERN_INFO "PM-Timer had no reasonable result:"
> > > -			" 0x%#llx - aborting.\n", value1);
> > > -	return -ENODEV;
> > 
> > Technically spoken this log message could now be considered partially
> > outdated... (we're doing 10 evaluations after all, not one with a
> > precise end result).
> > 
> > 
> > Seeing a define for those several open-coded 10 loops values would be nice.
> > 
> 
> Also it's a bit dodgy printing a cycle_t with %llx.  We don't _know_
> that cycle_t was implemented with `long long' - if this was always
> true, we wouldn't (or shouldn't) have a cycle_t at all.
> 
> But it seems that it happens to work for all architectures which
> implement acpi.

Well, adding a format modifier just for this isn't necessary IMO, especially
as all acpi-implementing architectures seem to be fine. Regarding the other
issues: well, I don't care all that much about a define for something used
twice and this comment; but if you want to squash it into the other patch
I'm fine with it.

Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>

diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index f05c4fb..09d4650 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -175,6 +175,9 @@ static int verify_pmtmr_rate(void)
 #define verify_pmtmr_rate() (0)
 #endif
 
+/* Number of monotonicity checks to perform during initialization */
+#define ACPI_PM_MONOTONICITY_CHECKS 10
+
 static int __init init_acpi_pm_clocksource(void)
 {
 	cycle_t value1, value2;
@@ -187,7 +190,7 @@ static int __init init_acpi_pm_clocksource(void)
 						clocksource_acpi_pm.shift);
 
 	/* "verify" this timing source: */
-	for (j = 0; j < 10; j++) {
+	for (j = 0; j < ACPI_PM_MONOTONICITY_CHECKS; j++) {
 		value1 = clocksource_acpi_pm.read();
 		for (i = 0; i < 10000; i++) {
 			value2 = clocksource_acpi_pm.read();
@@ -207,9 +210,9 @@ static int __init init_acpi_pm_clocksource(void)
 		udelay(300 * i);
 	}
 
-	if (good != 10) {
-		printk(KERN_INFO "PM-Timer had no reasonable result:"
-		       " 0x%#llx - aborting.\n", value1);
+	if (good != ACPI_PM_MONOTONICITY_CHECKS) {
+		printk(KERN_INFO "PM-Timer failed consistency check "
+		       " (0x%#llx) - aborting.\n", value1);
 		return -ENODEV;
 	}
 
