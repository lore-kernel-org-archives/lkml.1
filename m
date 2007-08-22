Return-Path: <linux-kernel-owner+w=401wt.eu-S1758125AbXHVH5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbXHVH5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 03:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755307AbXHVH44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 03:56:56 -0400
Received: from mx12.go2.pl ([193.17.41.142]:48420 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754970AbXHVH4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 03:56:55 -0400
Date: Wed, 22 Aug 2007 09:57:58 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>,
       WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, len.brown@intel.com,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [Git Patch] ACPI: Fix a warning of discarding qualifiers from pointer target type
Message-ID: <20070822075758.GC1684@ff.dom.local>
References: <20070821132038.GA22254@ff.dom.local> <20070821150714.GA7591@hacking> <46CB0169.7090207@suse.de> <20070821151820.GB21089@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070821151820.GB21089@ftp.linux.org.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 04:18:20PM +0100, Al Viro wrote:
> On Tue, Aug 21, 2007 at 07:14:49PM +0400, Alexey Starikovskiy wrote:
> > WANG Cong wrote:
> > > Fix this warning:
> > >
> > > drivers/acpi/ec.c: In function `acpi_ec_ecdt_probe':
> > > drivers/acpi/ec.c:873: warning: passing arg 1 of `acpi_get_devices' discards qualifiers from pointer target type
> > >
> > > (I don't know whether this fix hits the real problem.)
> > >   
> > It is safe to give acpi_get_devices() const string, as it should not
> > modify it in any condition.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> diff --git a/drivers/acpi/namespace/nsxfeval.c b/drivers/acpi/namespace/nsxfeval.c
> index ab65b2c..f39fbc6 100644
> --- a/drivers/acpi/namespace/nsxfeval.c
> +++ b/drivers/acpi/namespace/nsxfeval.c
> @@ -540,7 +540,7 @@ acpi_ns_get_device_callback(acpi_handle obj_handle,
>   ******************************************************************************/
>  
>  acpi_status
> -acpi_get_devices(char *HID,
> +acpi_get_devices(const char *HID,
>  		 acpi_walk_callback user_function,
>  		 void *context, void **return_value)
>  {
> diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
> index b5cca5d..3d7ab9e 100644
> --- a/include/acpi/acpixf.h
> +++ b/include/acpi/acpixf.h
> @@ -130,7 +130,7 @@ acpi_walk_namespace(acpi_object_type type,
>  		    void *context, void **return_value);
>  
>  acpi_status
> -acpi_get_devices(char *HID,
> +acpi_get_devices(const char *HID,
>  		 acpi_walk_callback user_function,
>  		 void *context, void **return_value);
>  
> diff --git a/include/acpi/acstruct.h b/include/acpi/acstruct.h
> index aeb4498..8848265 100644
> --- a/include/acpi/acstruct.h
> +++ b/include/acpi/acstruct.h
> @@ -146,7 +146,7 @@ struct acpi_init_walk_info {
>  struct acpi_get_devices_info {
>  	acpi_walk_callback user_function;
>  	void *context;
> -	char *hid;
> +	const char *hid;
>  };
>  
>  union acpi_aml_operands {
> 

So, it looks like this patch (or at least its -mm version) is working.

Now there is 'only' like this (there could be something new, because
I've forgotten to mention this yesterday's log was the second make,
after removing some small testing patch; here it's after make clean;
.config is the same; gcc 3.2.3):

sed: -e expression #1, char 154: Unknown option to 's'
kernel/power/pm.c:205: warning: `pm_register' is deprecated (declared at kernel/power/pm.c:64)
kernel/power/pm.c:205: warning: `pm_register' is deprecated (declared at kernel/power/pm.c:64)
kernel/power/pm.c:206: warning: `pm_send_all' is deprecated (declared at kernel/power/pm.c:180)
kernel/power/pm.c:206: warning: `pm_send_all' is deprecated (declared at kernel/power/pm.c:180)
drivers/pci/search.c: In function `pci_find_slot':
drivers/pci/search.c:99: warning: `pci_find_device' is deprecated (declared at include/linux/pci.h:480)
drivers/pci/search.c: At top level:
drivers/pci/search.c:437: warning: `pci_find_device' is deprecated (declared at drivers/pci/search.c:244)
drivers/pci/search.c:437: warning: `pci_find_device' is deprecated (declared at drivers/pci/search.c:244)
drivers/pci/search.c:438: warning: `pci_find_slot' is deprecated (declared at drivers/pci/search.c:96)
drivers/pci/search.c:438: warning: `pci_find_slot' is deprecated (declared at drivers/pci/search.c:96)
drivers/pci/msi.c:686: warning: weak declaration of `arch_msi_check_device' after first use results in unspecified behavior
drivers/pci/msi.c:698: warning: weak declaration of `arch_setup_msi_irqs' after first use results in unspecified behavior
drivers/pci/msi.c:718: warning: weak declaration of `arch_teardown_msi_irqs' after first use results in unspecified behavior
In file included from drivers/usb/host/ohci-hcd.c:859:
drivers/usb/host/ohci-pci.c: In function `ohci_pci_start':
drivers/usb/host/ohci-pci.c:202: warning: unused variable `pdev'
include/asm/processor.h: In function `native_get_debugreg':
include/asm/processor.h:524: warning: asm operand 0 probably doesn't match constraints
include/asm/processor.h: In function `native_set_debugreg':
include/asm/processor.h:551: warning: asm operand 0 probably doesn't match constraints
Root device is (8, 1)
Setup is 11036 bytes (padded to 11264 bytes).
System is 2428 kB

Cheers,
Jarek P.

PS: does somebody here remember these old good times:
real    56m19.454s
user    53m38.580s
sys     2m7.610s
