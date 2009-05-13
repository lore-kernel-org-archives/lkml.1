Return-Path: <linux-kernel-owner+w=401wt.eu-S1757303AbZEMFx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbZEMFx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 01:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbZEMFxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 01:53:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:34686 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbZEMFxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 01:53:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,185,1241420400"; 
   d="scan'208";a="411941516"
Subject: Re: [BISECTED] Was Re: acpi/suspend - irq 9: nobody cared
From: Lin Ming <ming.m.lin@intel.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, yakui_zhao <yakui.zhao@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Moore, Robert" <robert.moore@intel.com>
In-Reply-To: <d3f22a0905122245h15786220g31ad0dcb8caa3a38@mail.gmail.com>
References: <20090507105821.GA5864@hash.localnet>
	 <1241747634.3773.129.camel@localhost.localdomain>
	 <200905121301.08524.bjorn.helgaas@hp.com>
	 <20090513040502.GA26515@hash.localnet>
	 <d3f22a0905122245h15786220g31ad0dcb8caa3a38@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 13 May 2009 13:36:08 +0800
Message-Id: <1242192968.14626.40.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: Bob Copeland <me@bobcopeland.com>
> Date: Wed, May 13, 2009 at 12:05 PM
> Subject: [BISECTED] Was Re: acpi/suspend - irq 9: nobody cared
> To: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Cc: yakui_zhao <yakui.zhao@intel.com>, "linux-kernel@vger.kernel.org"
> <linux-kernel@vger.kernel.org>, "linux-acpi@vger.kernel.org"
> <linux-acpi@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
> robert.moore@intel.com
> 
> 
> On Tue, May 12, 2009 at 01:01:06PM -0600, Bjorn Helgaas wrote:
> > Even if you can't bisect this, can you please open a bugzilla at
> > http://bugzilla.kernel.org?
> 
> Done: http://bugzilla.kernel.org/show_bug.cgi?id=13289
> 
> I have bisected it.  I don't know if it's related, but I have a
> "MacBook 1,1" which in sleep.c has a quirk related to SCI_EN, and I
> see that this patch changed ACPI_PM1_CONTROL_PRESERVED_BITS to include
> SCI_EN.  I have verified that reverting the patch on top of latest -rc
> prevents irq 9 from being disabled.

>From ACPI Spec 3.0a 4.7.3.2.1,

"SCI_EN: Selects the power management event to be either an SCI or SMI
interrupt for the following events. When this bit is set, then power
management events will generate an SCI interrupt. When this bit is reset
power management events will generate an SMI interrupt. It is the
responsibility of the hardware to set or reset this bit. OSPM always
preserves this bit position."

So we preserve SCI_EN bit per spec.

Anyway, would you please try below patch to see if the bug is caused by
SCI_EN bit preserved?

diff --git a/drivers/acpi/acpica/aclocal.h b/drivers/acpi/acpica/aclocal.h
index 772ee5c..3d082bb 100644
--- a/drivers/acpi/acpica/aclocal.h
+++ b/drivers/acpi/acpica/aclocal.h
@@ -787,7 +787,7 @@ struct acpi_bit_register_info {
 
 /* For control registers, both ignored and reserved bits must be preserved */
 
-#define ACPI_PM1_CONTROL_IGNORED_BITS           0x0201	/* Bits 9, 0(SCI_EN) */
+#define ACPI_PM1_CONTROL_IGNORED_BITS           0x0200	/* Bits 9 */
 #define ACPI_PM1_CONTROL_RESERVED_BITS          0xC1F8	/* Bits 14-15, 3-8 */
 #define ACPI_PM1_CONTROL_PRESERVED_BITS \
 	       (ACPI_PM1_CONTROL_IGNORED_BITS | ACPI_PM1_CONTROL_RESERVED_BITS)

---
Lin Ming

> 
> commit 20869dcfde204e1c21b642608d708d82472fee2b
> Author: Bob Moore <robert.moore@intel.com>
> Date:   Fri Mar 13 09:10:46 2009 +0800
> 
>    ACPICA: Preserve all PM control reserved and ignored bits
> 
>    As per the ACPI specification, preserve (read/modify/write) all
>    bits that are defined as either reserved or ignored (PM control
>    control registers only.)
> 
>    Signed-off-by: Bob Moore <robert.moore@intel.com>
>    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
>    Signed-off-by: Len Brown <len.brown@intel.com>
> 
> diff --git a/drivers/acpi/acpica/aclocal.h b/drivers/acpi/acpica/aclocal.h
> index 18a8d96..f01e155 100644
> --- a/drivers/acpi/acpica/aclocal.h
> +++ b/drivers/acpi/acpica/aclocal.h
> @@ -780,7 +780,15 @@ struct acpi_bit_register_info {
>  * must be preserved.
>  */
>  #define ACPI_PM1_STATUS_PRESERVED_BITS          0x0800 /* Bit 11 */
> -#define ACPI_PM1_CONTROL_PRESERVED_BITS         0x0200 /* Bit 9 (whatever) */
> +
> +/* For control registers, both ignored and reserved bits must be preserved */
> +
> +#define ACPI_PM1_CONTROL_IGNORED_BITS           0x0201 /* Bits 9, 0(SCI_EN) */
> +#define ACPI_PM1_CONTROL_RESERVED_BITS          0xC1F8 /* Bits 14-15, 3-8 */
> +#define ACPI_PM1_CONTROL_PRESERVED_BITS \
> +              (ACPI_PM1_CONTROL_IGNORED_BITS | ACPI_PM1_CONTROL_RESERVED_BITS)
> +
> +#define ACPI_PM2_CONTROL_PRESERVED_BITS         0xFFFFFFFE     /* All
> except bit 0 */
> 
>  /*
>  * Register IDs
> diff --git a/drivers/acpi/acpica/hwregs.c b/drivers/acpi/acpica/hwregs.c
> index fd7abe2..6117362 100644
> --- a/drivers/acpi/acpica/hwregs.c
> +++ b/drivers/acpi/acpica/hwregs.c
> @@ -328,6 +328,21 @@ acpi_status acpi_hw_register_write(u32
> register_id, u32 value)
> 
>        case ACPI_REGISTER_PM2_CONTROL: /* 8-bit access */
> 
> +               /*
> +                * For control registers, all reserved bits must be preserved,
> +                * as per the ACPI spec.
> +                */
> +               status =
> +                   acpi_read(&read_value, &acpi_gbl_FADT.xpm2_control_block);
> +               if (ACPI_FAILURE(status)) {
> +                       goto exit;
> +               }
> +
> +               /* Insert the bits to be preserved */
> +
> +               ACPI_INSERT_BITS(value, ACPI_PM2_CONTROL_PRESERVED_BITS,
> +                                read_value);
> +
>                status = acpi_write(value, &acpi_gbl_FADT.xpm2_control_block);
>                break;
> 
> 
> 
> --
> Bob Copeland %% www.bobcopeland.com
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

