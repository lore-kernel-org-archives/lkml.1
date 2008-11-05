Return-Path: <linux-kernel-owner+w=401wt.eu-S1757557AbYKEAld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557AbYKEAld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 19:41:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755517AbYKEAlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 19:41:15 -0500
Received: from mga11.intel.com ([192.55.52.93]:19309 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755325AbYKEAlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 19:41:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,546,1220252400"; 
   d="scan'208";a="635587925"
Subject: Re: [patch 51/57] ACPI: Ingore the RESET_REG_SUP bit when using
	ACPI reset mechanism
From: Zhao Yakui <yakui.zhao@intel.com>
To: Greg KH <gregkh@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "Brown, Len" <len.brown@intel.com>
In-Reply-To: <20081104233325.GZ659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
	 <20081104233325.GZ659@suse.de>
Content-Type: text/plain
Date: Wed, 05 Nov 2008 08:48:12 +0800
Message-Id: <1225846092.26020.89.camel@yakui_zhao.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-05 at 07:33 +0800, Greg KH wrote:
> 2.6.27-stable review patch.  If anyone has any objections, please let us know.
Please don't apply this patch.And this causes the reboot regression on
AMD chipset. (Bug11942)
    Now the default reboot type is changed from BOOT_KBD to BOOT_ACPI.
      
On the AMD box there exists the definition of RESET_REG &RESET_VALUE,
which is identical to the definition in Intel Chipset. After the
RESET_REG_SUP is ignored, the AMD box can't be rebooted by writing the
RESET_VALUE to RESET_REG I/O port.

Thanks.
   Yakui
    
> 
> ------------------
> From: Zhao Yakui <yakui.zhao@intel.com>
> 
> Subject: [patch 51/57] ACPI: Ingore the RESET_REG_SUP bit when using ACPI reset mechanism
> 
> commit 8fd145917fb62368a9b80db59562c20576238f5a upstream
> 
> ACPI: Ingore the RESET_REG_SUP bit when using ACPI reset mechanism
> 
> According to ACPI 3.0, FADT.flags.RESET_REG_SUP indicates
> whether the ACPI reboot mechanism is supported.
> 
> However, some boxes have this bit clear, have a valid
> ACPI_RESET_REG & RESET_VALUE, and ACPI reboot is the only
> mechanism that works for them after S3.
> 
> This suggests that other operating systems may not be checking
> the RESET_REG_SUP bit, and are using other means to decide
> whether to use the ACPI reboot mechanism or not.
> 
> Here we stop checking RESET_REG_SUP.
> Instead, When acpi reboot is requested,
> only the reset_register is checked. If the following
> conditions are met, it indicates that the reset register is supported.
> 	a. reset_register is not zero
> 	b. the access width is eight
> 	c. the bit_offset is zero
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=7299
> http://bugzilla.kernel.org/show_bug.cgi?id=1148
> 
> Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
> Signed-off-by: Len Brown <len.brown@intel.com>
> Cc: Chuck Ebbert <cebbert@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/acpi/reboot.c |   25 ++++++++++++++++++++++---
>  1 file changed, 22 insertions(+), 3 deletions(-)
> 
> --- a/drivers/acpi/reboot.c
> +++ b/drivers/acpi/reboot.c
> @@ -15,9 +15,28 @@ void acpi_reboot(void)
>  
>  	rr = &acpi_gbl_FADT.reset_register;
>  
> -	/* Is the reset register supported? */
> -	if (!(acpi_gbl_FADT.flags & ACPI_FADT_RESET_REGISTER) ||
> -	    rr->bit_width != 8 || rr->bit_offset != 0)
> +	/*
> +	 * Is the ACPI reset register supported?
> +	 *
> +	 * According to ACPI 3.0, FADT.flags.RESET_REG_SUP indicates
> +	 * whether the ACPI reset mechanism is supported.
> +	 *
> +	 * However, some boxes have this bit clear, yet a valid
> +	 * ACPI_RESET_REG & RESET_VALUE, and ACPI reboot is the only
> +	 * mechanism that works for them after S3.
> +	 *
> +	 * This suggests that other operating systems may not be checking
> +	 * the RESET_REG_SUP bit, and are using other means to decide
> +	 * whether to use the ACPI reboot mechanism or not.
> +	 *
> +	 * So when acpi reboot is requested,
> +	 * only the reset_register is checked. If the following
> +	 * conditions are met, it indicates that the reset register is supported.
> +	 * 	a. reset_register is not zero
> +	 * 	b. the access width is eight
> +	 * 	c. the bit_offset is zero
> +	 */
> +	if (!(rr->address) || rr->bit_width != 8 || rr->bit_offset != 0)
>  		return;
>  
>  	reset_value = acpi_gbl_FADT.reset_value;
> 

