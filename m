Return-Path: <linux-kernel-owner+w=401wt.eu-S1161161AbXCHXgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161161AbXCHXgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 18:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161123AbXCHXgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 18:36:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:33526 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161161AbXCHXgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 18:36:46 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: [4/6] 2.6.21-rc2: known regressions
Date: Thu, 8 Mar 2007 18:28:32 -0500
User-Agent: KMail/1.9.5
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Nelless <andrew@nelless.net>, linux-acpi@vger.kernel.org,
       Jiri Kosina <jikos@jikos.cz>, Richard Purdie <rpurdie@rpsys.net>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Yaroslav Halchenko <kernel@onerussian.com>,
       Alex Romosan <romosan@sycorax.lbl.gov>,
       David Miller <davem@davemloft.net>,
       James Simmons <jsimmons@infradead.org>, benh@kernel.crashing.org,
       Andreas Schwab <schwab@suse.de>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015039.GI3441@stusta.de> <1173090919.6782.13.camel@daplas>
In-Reply-To: <1173090919.6782.13.camel@daplas>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703081828.33606.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 March 2007 05:35, Antonino A. Daplas wrote:
> On Mon, 2007-03-05 at 02:50 +0100, Adrian Bunk wrote:
> > This email lists some known regressions in 2.6.21-rc2 compared to 2.6.20
> > that are not yet fixed in Linus' tree.
> > 
> > If you find your name in the Cc header, you are either submitter of one
> > of the bugs, maintainer of an affectected subsystem or driver, a patch
> > of you caused a breakage or I'm considering you in any other way
> > possibly involved with one or more of these issues.
> > 
> > Due to the huge amount of recipients, please trim the Cc when answering.
> > 
> > 
> > Subject    : Asus A8N-VM motherboard:
> >              framebuffer/console boot failure boot failure (ACPI related)
> > References : http://lkml.org/lkml/2007/2/23/132
> > Submitter  : Andrew Nelless <andrew@nelless.net>
> > Caused-By  : Len Brown <len.brown@intel.com>
> >              commit 7f8f97c3cc75d5783d0b45cf323dedf17684be19
> > Handled-By : Antonino A. Daplas <adaplas@gmail.com>
> > Status     : problem is being debugged
> > 
> 
> This is not a framebuffer nor console problem.
> 
> I think Andrew Nelless confirmed that the cause is from the above
> commit. How to fix it, I don't know.  Perhaps the
> acpi_skip_timer_override boot option has to be used.

Looks like I got fooled by the negative logic for the nvidia_bugs().
Please test this patch -- it should fix it,
as well as simplify the code a bit.

thanks,
-Len


Subject: ACPI: repair nvidia early quirk breakage on x86_64

x86_64 nvidia_bugs() broke when we bailed out on not finding the HPET.
However, the quirk works by checking for _not_ finding the HPET...

Delete the nvidia_hpet_detected flag and simply test for
not finding the HPET, which is simple to do now that
acpi_table_parse returns 1 on failure.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 i386/kernel/acpi/earlyquirk.c |    7 +------
 x86_64/kernel/early-quirks.c  |    9 +--------
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/arch/i386/kernel/acpi/earlyquirk.c b/arch/i386/kernel/acpi/earlyquirk.c
index bf86f76..7fdba8a 100644
--- a/arch/i386/kernel/acpi/earlyquirk.c
+++ b/arch/i386/kernel/acpi/earlyquirk.c
@@ -14,11 +14,8 @@
 
 #ifdef CONFIG_ACPI
 
-static int nvidia_hpet_detected __initdata;
-
 static int __init nvidia_hpet_check(struct acpi_table_header *header)
 {
-	nvidia_hpet_detected = 1;
 	return 0;
 }
 #endif
@@ -29,9 +26,7 @@ static int __init check_bridge(int vendor, int device)
 	/* According to Nvidia all timer overrides are bogus unless HPET
 	   is enabled. */
 	if (!acpi_use_timer_override && vendor == PCI_VENDOR_ID_NVIDIA) {
-		nvidia_hpet_detected = 0;
-		acpi_table_parse(ACPI_SIG_HPET, nvidia_hpet_check);
-		if (nvidia_hpet_detected == 0) {
+		if (acpi_table_parse(ACPI_SIG_HPET, nvidia_hpet_check) {
 			acpi_skip_timer_override = 1;
 			  printk(KERN_INFO "Nvidia board "
                        "detected. Ignoring ACPI "
diff --git a/arch/x86_64/kernel/early-quirks.c b/arch/x86_64/kernel/early-quirks.c
index 8047ea8..dec587b 100644
--- a/arch/x86_64/kernel/early-quirks.c
+++ b/arch/x86_64/kernel/early-quirks.c
@@ -30,11 +30,8 @@ static void via_bugs(void)
 
 #ifdef CONFIG_ACPI
 
-static int nvidia_hpet_detected __initdata;
-
 static int __init nvidia_hpet_check(struct acpi_table_header *header)
 {
-	nvidia_hpet_detected = 1;
 	return 0;
 }
 #endif
@@ -52,11 +49,7 @@ static void nvidia_bugs(void)
 	if (acpi_use_timer_override)
 		return;
 
-	nvidia_hpet_detected = 0;
-	if (acpi_table_parse(ACPI_SIG_HPET, nvidia_hpet_check))
-		return;
-
-	if (nvidia_hpet_detected == 0) {
+	if (acpi_table_parse(ACPI_SIG_HPET, nvidia_hpet_check)) {
 		acpi_skip_timer_override = 1;
 		printk(KERN_INFO "Nvidia board "
 		       "detected. Ignoring ACPI "
