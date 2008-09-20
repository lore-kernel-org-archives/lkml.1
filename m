Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbYITNHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbYITNHW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 09:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbYITNHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 09:07:10 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:46334 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751511AbYITNHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 09:07:09 -0400
Message-ID: <48D4F57C.5010902@suse.de>
Date: Sat, 20 Sep 2008 17:07:08 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Sitsofe Wheeler <sitsofe@yahoo.com>
CC: linux-kernel@vger.kernel.org, lenb@kernel.org
Subject: Re: Reading EeePC900 battery info causes stalls
References: <fa.aea4e10hJLpVS/qr4bumSa5e9C0@ifi.uio.no> <fa.uDmoMIWw4thxpZxpYeSIpVJhAOo@ifi.uio.no> <fa.RIMmQqN9ybFSKBqOk9Gxi/mOeB4@ifi.uio.no> <fa.XLGLzP+T4fm9CkeATkS1VL/Yz4Q@ifi.uio.no> <fa.z8sKLpwDO3qQ15ZJIm152YEty4I@ifi.uio.no> <fa.KyW7dWWjiSFnFxwdZZLurmVn8qA@ifi.uio.no> <48D4CC1B.7030708@yahoo.com> <48D4CFA5.7010501@suse.de> <48D4D5CA.1060104@yahoo.com> <48D4D6AE.70705@yahoo.com> <48D4DB23.5080901@suse.de> <48D4DD3C.3050308@yahoo.com>
In-Reply-To: <48D4DD3C.3050308@yahoo.com>
Content-Type: multipart/mixed;
 boundary="------------030409050706080203080301"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030409050706080203080301
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Sitsofe Wheeler wrote:
> Alexey Starikovskiy wrote:
>> Could you cat /proc/interrupts ?
> 
>            CPU0
>   0:     106942   IO-APIC-edge      timer
>   1:        426   IO-APIC-edge      i8042
>   8:         41   IO-APIC-edge      rtc0
>   9:      27346   IO-APIC-fasteoi   acpi
>  12:       6840   IO-APIC-edge      i8042
>  14:          0   IO-APIC-edge      ata_piix
>  15:        203   IO-APIC-edge      ata_piix
>  16:      92357   IO-APIC-fasteoi   uhci_hcd:usb5, HDA Intel, 
> i915@pci:0000:00:02.0
>  18:      38195   IO-APIC-fasteoi   ath, uhci_hcd:usb4
>  19:          0   IO-APIC-fasteoi   uhci_hcd:usb3
>  23:      25150   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2
> NMI:          0   Non-maskable interrupts
> LOC:     142112   Local timer interrupts
> TRM:          0   Thermal event interrupts
> SPU:          0   Spurious interrupts
> ERR:          0
> MIS:          0
Could you please try following patch on top?

--------------030409050706080203080301
Content-Type: text/x-diff;
 name="more_storm.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="more_storm.patch"

ACPI: EC: disable GPE during QUERY handling too.

From: Alexey Starikovskiy <astarikovskiy@suse.de>


---

 drivers/acpi/ec.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)


diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 8d6b7e9..e027077 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -226,9 +226,16 @@ static void acpi_ec_gpe_query(void *ec_cxt);
 static int ec_check_sci(struct acpi_ec *ec, u8 state)
 {
 	if (state & ACPI_EC_FLAG_SCI) {
-		if (!test_and_set_bit(EC_FLAGS_QUERY_PENDING, &ec->flags))
+		if (!test_and_set_bit(EC_FLAGS_QUERY_PENDING, &ec->flags)) {
+			/* disable GPE until next transaction */
+			if (in_interrupt() &&
+			    test_bit(EC_FLAGS_GPE_STORM, &ec->flags)) {
+				clear_bit(EC_FLAGS_GPE_MODE, &ec->flags);
+				acpi_disable_gpe(NULL, ec->gpe, ACPI_ISR);
+			}
 			return acpi_os_execute(OSL_EC_BURST_HANDLER,
 				acpi_ec_gpe_query, ec);
+		}
 	}
 	return 0;
 }
@@ -281,8 +288,9 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec, u8 command,
 	if (test_bit(EC_FLAGS_GPE_STORM, &ec->flags)) {
 		/* check if we received SCI during transaction */
 		ec_check_sci(ec, acpi_ec_read_status(ec));
-		/* it is safe to enable GPE outside of transaction */
-		acpi_enable_gpe(NULL, ec->gpe, ACPI_NOT_ISR);
+		/* we expect query, enable GPE back */
+		if (!test_bit(EC_FLAGS_QUERY_PENDING, &ec->flags))
+			acpi_enable_gpe(NULL, ec->gpe, ACPI_NOT_ISR);
 	} else if (test_bit(EC_FLAGS_GPE_MODE, &ec->flags) &&
 		   ec->irq_count > ACPI_EC_STORM_THRESHOLD) {
 		pr_debug(PREFIX "GPE storm detected\n");

--------------030409050706080203080301--
