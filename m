Return-Path: <linux-kernel-owner+w=401wt.eu-S933919AbYBHJMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933919AbYBHJMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 04:12:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760813AbYBHJME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 04:12:04 -0500
Received: from ns2.suse.de ([195.135.220.15]:55995 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756963AbYBHJL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 04:11:58 -0500
Subject: Re: [PATCH 2/5] Provide acpi_check_{mem_}region.
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Jean Delvare <khali@linux-fr.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
In-Reply-To: <20080207234002.e31563be.akpm@linux-foundation.org>
References: <1193236379.4590.229.camel@queen.suse.de>
	 <20080207234002.e31563be.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Fri, 08 Feb 2008 10:11:54 +0100
Message-Id: <1202461914.7977.323.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-07 at 23:40 -0800, Andrew Morton wrote:
> On Wed, 24 Oct 2007 16:32:59 +0200 Thomas Renninger <trenn@suse.de> wrote:
> 
> > Provide acpi_check_{mem_}region.
> > 
> > Drivers can additionally check against possible ACPI interference by also
> > invoking this shortly before they call request_region.
> > If -EBUSY is returned, the driver must not load.
> > Use acpi_enforce_resources=strict/lax/no options to:
> >   - strict: let conflicting drivers fail to load with an error message
> >   - lax:    let conflicting driver work normal with a warning message
> >   - no:     no functional change at all
> > 
> > 
> 
> OK, so Len has merged these into the acpi test tree.  My understanding is
> that once this work hits mainline, we can then merge
> check-for-acpi-resource-conflicts-in-hwmon-drivers.patch.
> 
> My normal approach would be to send
> check-for-acpi-resource-conflicts-in-hwmon-drivers.patch to Mark for
> inclusion in git-hwmon one Len has merged the prerequisites into mainline. 
> 
> Problem is, if Len merges late in the 2.6.26 merge window, Mark might not
> have time to gets these changes into mainline before 2.6.27.  Which is all
> getting a bit dumb considering I first merged everything in October. 
> Fortunately things aren't mormally _this_ inefficient when one follows the
> rules - this was an unusual patchset.
> 
> But still, I think we could afford to speed things up a bit more than that.
>  We could ask Len to consider merging this work into 2.6.25 and then if
> Mark can ack check-for-acpi-resource-conflicts-in-hwmon-drivers.patch
> (below) for an akpm-merge, we're good to go.  But I do recall that people
> were a bit uncertain about it all back in October.
The patch is totally unrisky, beside of an overseen typo that always can
slip in (if this should be a concern)...
About the mechanism and the fact that there is another instance to check
IO port and system memory resources?
IIRC Bjorn did not like that, but also wanted to integrated that into
pnp layer somehow. But I expect after fighting already that hard with
mainboard/system pnp resource conflicts and BIOS weirdness the last
weeks..., he also agrees that it makes not much sense that the
OperationRegion port/memory checks should get integrated into the pnp
layer now or at all (which could conflict as a third instance (driver
resources vs pnp resources vs ACPI OperationRegion declarations)
depending on how broken the BIOS is, even with overlapping!)

    Thomas

> Please share your thoughts with us.
> 
> 
> 
> From: Jean Delvare <jdelvare@suse.de>
> 
> Check for ACPI resource conflicts in hwmon drivers. I've included
> all Super-I/O and PCI drivers.
> 
> I've voluntarily left out:
> * Laptop specific and vendor-specific drivers: if they conflicted
>   on any system, this would pretty much mean that they conflict on all
>   systems, and we would know by now.
> * Legacy ISA drivers (lm78 and w83781d): they only support chips found
>   on old designs were ACPI either wasn't supported or didn't deal with
>   thermal management.
> * Drivers accessing the I/O resources indirectly (e.g. through SMBus):
>   the check will be added where it belongs, i.e. in the bus drivers.
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
> Cc: Len Brown <lenb@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/hwmon/dme1737.c    |    5 +++++
>  drivers/hwmon/f71805f.c    |    5 +++++
>  drivers/hwmon/f71882fg.c   |    5 +++++
>  drivers/hwmon/it87.c       |    5 +++++
>  drivers/hwmon/pc87360.c    |    6 ++++++
>  drivers/hwmon/pc87427.c    |    5 +++++
>  drivers/hwmon/sis5595.c    |    5 +++++
>  drivers/hwmon/smsc47b397.c |    5 +++++
>  drivers/hwmon/smsc47m1.c   |    5 +++++
>  drivers/hwmon/via686a.c    |    5 +++++
>  drivers/hwmon/vt1211.c     |    5 +++++
>  drivers/hwmon/vt8231.c     |    5 +++++
>  drivers/hwmon/w83627ehf.c  |    6 ++++++
>  drivers/hwmon/w83627hf.c   |    5 +++++
>  14 files changed, 72 insertions(+)
> 
> diff -puN drivers/hwmon/dme1737.c~check-for-acpi-resource-conflicts-in-hwmon-drivers drivers/hwmon/dme1737.c
> --- a/drivers/hwmon/dme1737.c~check-for-acpi-resource-conflicts-in-hwmon-drivers
> +++ a/drivers/hwmon/dme1737.c
> @@ -34,6 +34,7 @@
>  #include <linux/hwmon-vid.h>
>  #include <linux/err.h>
>  #include <linux/mutex.h>
> +#include <linux/acpi.h>
>  #include <asm/io.h>
>  
>  /* ISA device, if found */
> @@ -2238,6 +2239,10 @@ static int __init dme1737_isa_device_add
>  	};
>  	int err;
>  
> +	err = acpi_check_resource_conflict(&res);
> +	if (err)
> +		goto exit;
> +
>  	if (!(pdev = platform_device_alloc("dme1737", addr))) {
>  		printk(KERN_ERR "dme1737: Failed to allocate device.\n");
>  		err = -ENOMEM;
> diff -puN drivers/hwmon/f71805f.c~check-for-acpi-resource-conflicts-in-hwmon-drivers drivers/hwmon/f71805f.c
> --- a/drivers/hwmon/f71805f.c~check-for-acpi-resource-conflicts-in-hwmon-drivers
> +++ a/drivers/hwmon/f71805f.c
> @@ -39,6 +39,7 @@
>  #include <linux/mutex.h>
>  #include <linux/sysfs.h>
>  #include <linux/ioport.h>
> +#include <linux/acpi.h>
>  #include <asm/io.h>
>  
>  static unsigned short force_id;
> @@ -1455,6 +1456,10 @@ static int __init f71805f_device_add(uns
>  	}
>  
>  	res.name = pdev->name;
> +	err = acpi_check_resource_conflict(&res);
> +	if (err)
> +		goto exit_device_put;
> +
>  	err = platform_device_add_resources(pdev, &res, 1);
>  	if (err) {
>  		printk(KERN_ERR DRVNAME ": Device resource addition failed "
> diff -puN drivers/hwmon/f71882fg.c~check-for-acpi-resource-conflicts-in-hwmon-drivers drivers/hwmon/f71882fg.c
> --- a/drivers/hwmon/f71882fg.c~check-for-acpi-resource-conflicts-in-hwmon-drivers
> +++ a/drivers/hwmon/f71882fg.c
> @@ -27,6 +27,7 @@
>  #include <linux/hwmon-sysfs.h>
>  #include <linux/err.h>
>  #include <linux/mutex.h>
> +#include <linux/acpi.h>
>  #include <asm/io.h>
>  
>  #define DRVNAME "f71882fg"
> @@ -898,6 +899,10 @@ static int __init f71882fg_device_add(un
>  		return -ENOMEM;
>  
>  	res.name = f71882fg_pdev->name;
> +	err = acpi_check_resource_conflict(&res);
> +	if (err)
> +		return err;
> +
>  	err = platform_device_add_resources(f71882fg_pdev, &res, 1);
>  	if (err) {
>  		printk(KERN_ERR DRVNAME ": Device resource addition failed\n");
> diff -puN drivers/hwmon/it87.c~check-for-acpi-resource-conflicts-in-hwmon-drivers drivers/hwmon/it87.c
> --- a/drivers/hwmon/it87.c~check-for-acpi-resource-conflicts-in-hwmon-drivers
> +++ a/drivers/hwmon/it87.c
> @@ -46,6 +46,7 @@
>  #include <linux/err.h>
>  #include <linux/mutex.h>
>  #include <linux/sysfs.h>
> +#include <linux/acpi.h>
>  #include <asm/io.h>
>  
>  #define DRVNAME "it87"
> @@ -1487,6 +1488,10 @@ static int __init it87_device_add(unsign
>  	};
>  	int err;
>  
> +	err = acpi_check_resource_conflict(&res);
> +	if (err)
> +		goto exit;
> +
>  	pdev = platform_device_alloc(DRVNAME, address);
>  	if (!pdev) {
>  		err = -ENOMEM;
> diff -puN drivers/hwmon/pc87360.c~check-for-acpi-resource-conflicts-in-hwmon-drivers drivers/hwmon/pc87360.c
> --- a/drivers/hwmon/pc87360.c~check-for-acpi-resource-conflicts-in-hwmon-drivers
> +++ a/drivers/hwmon/pc87360.c
> @@ -43,6 +43,7 @@
>  #include <linux/hwmon-vid.h>
>  #include <linux/err.h>
>  #include <linux/mutex.h>
> +#include <linux/acpi.h>
>  #include <asm/io.h>
>  
>  static u8 devid;
> @@ -1425,6 +1426,11 @@ static int __init pc87360_device_add(uns
>  			continue;
>  		res.start = extra_isa[i];
>  		res.end = extra_isa[i] + PC87360_EXTENT - 1;
> +
> +		err = acpi_check_resource_conflict(&res);
> +		if (err)
> +			goto exit_device_put;
> +
>  		err = platform_device_add_resources(pdev, &res, 1);
>  		if (err) {
>  			printk(KERN_ERR "pc87360: Device resource[%d] "
> diff -puN drivers/hwmon/pc87427.c~check-for-acpi-resource-conflicts-in-hwmon-drivers drivers/hwmon/pc87427.c
> --- a/drivers/hwmon/pc87427.c~check-for-acpi-resource-conflicts-in-hwmon-drivers
> +++ a/drivers/hwmon/pc87427.c
> @@ -32,6 +32,7 @@
>  #include <linux/mutex.h>
>  #include <linux/sysfs.h>
>  #include <linux/ioport.h>
> +#include <linux/acpi.h>
>  #include <asm/io.h>
>  
>  static unsigned short force_id;
> @@ -524,6 +525,10 @@ static int __init pc87427_device_add(uns
>  	};
>  	int err;
>  
> +	err = acpi_check_resource_conflict(&res);
> +	if (err)
> +		goto exit;
> +
>  	pdev = platform_device_alloc(DRVNAME, address);
>  	if (!pdev) {
>  		err = -ENOMEM;
> diff -puN drivers/hwmon/sis5595.c~check-for-acpi-resource-conflicts-in-hwmon-drivers drivers/hwmon/sis5595.c
> --- a/drivers/hwmon/sis5595.c~check-for-acpi-resource-conflicts-in-hwmon-drivers
> +++ a/drivers/hwmon/sis5595.c
> @@ -62,6 +62,7 @@
>  #include <linux/jiffies.h>
>  #include <linux/mutex.h>
>  #include <linux/sysfs.h>
> +#include <linux/acpi.h>
>  #include <asm/io.h>
>  
> 
> @@ -727,6 +728,10 @@ static int __devinit sis5595_device_add(
>  	};
>  	int err;
>  
> +	err = acpi_check_resource_conflict(&res);
> +	if (err)
> +		goto exit;
> +
>  	pdev = platform_device_alloc("sis5595", address);
>  	if (!pdev) {
>  		err = -ENOMEM;
> diff -puN drivers/hwmon/smsc47b397.c~check-for-acpi-resource-conflicts-in-hwmon-drivers drivers/hwmon/smsc47b397.c
> --- a/drivers/hwmon/smsc47b397.c~check-for-acpi-resource-conflicts-in-hwmon-drivers
> +++ a/drivers/hwmon/smsc47b397.c
> @@ -36,6 +36,7 @@
>  #include <linux/err.h>
>  #include <linux/init.h>
>  #include <linux/mutex.h>
> +#include <linux/acpi.h>
>  #include <asm/io.h>
>  
>  static unsigned short force_id;
> @@ -303,6 +304,10 @@ static int __init smsc47b397_device_add(
>  	};
>  	int err;
>  
> +	err = acpi_check_resource_conflict(&res);
> +	if (err)
> +		goto exit;
> +
>  	pdev = platform_device_alloc(DRVNAME, address);
>  	if (!pdev) {
>  		err = -ENOMEM;
> diff -puN drivers/hwmon/smsc47m1.c~check-for-acpi-resource-conflicts-in-hwmon-drivers drivers/hwmon/smsc47m1.c
> --- a/drivers/hwmon/smsc47m1.c~check-for-acpi-resource-conflicts-in-hwmon-drivers
> +++ a/drivers/hwmon/smsc47m1.c
> @@ -37,6 +37,7 @@
>  #include <linux/init.h>
>  #include <linux/mutex.h>
>  #include <linux/sysfs.h>
> +#include <linux/acpi.h>
>  #include <asm/io.h>
>  
>  static unsigned short force_id;
> @@ -686,6 +687,10 @@ static int __init smsc47m1_device_add(un
>  	};
>  	int err;
>  
> +	err = acpi_check_resource_conflict(&res);
> +	if (err)
> +		goto exit;
> +
>  	pdev = platform_device_alloc(DRVNAME, address);
>  	if (!pdev) {
>  		err = -ENOMEM;
> diff -puN drivers/hwmon/via686a.c~check-for-acpi-resource-conflicts-in-hwmon-drivers drivers/hwmon/via686a.c
> --- a/drivers/hwmon/via686a.c~check-for-acpi-resource-conflicts-in-hwmon-drivers
> +++ a/drivers/hwmon/via686a.c
> @@ -41,6 +41,7 @@
>  #include <linux/init.h>
>  #include <linux/mutex.h>
>  #include <linux/sysfs.h>
> +#include <linux/acpi.h>
>  #include <asm/io.h>
>  
> 
> @@ -755,6 +756,10 @@ static int __devinit via686a_device_add(
>  	};
>  	int err;
>  
> +	err = acpi_check_resource_conflict(&res);
> +	if (err)
> +		goto exit;
> +
>  	pdev = platform_device_alloc("via686a", address);
>  	if (!pdev) {
>  		err = -ENOMEM;
> diff -puN drivers/hwmon/vt1211.c~check-for-acpi-resource-conflicts-in-hwmon-drivers drivers/hwmon/vt1211.c
> --- a/drivers/hwmon/vt1211.c~check-for-acpi-resource-conflicts-in-hwmon-drivers
> +++ a/drivers/hwmon/vt1211.c
> @@ -32,6 +32,7 @@
>  #include <linux/err.h>
>  #include <linux/mutex.h>
>  #include <linux/ioport.h>
> +#include <linux/acpi.h>
>  #include <asm/io.h>
>  
>  static int uch_config = -1;
> @@ -1259,6 +1260,10 @@ static int __init vt1211_device_add(unsi
>  	}
>  
>  	res.name = pdev->name;
> +	err = acpi_check_resource_conflict(&res);
> +	if (err)
> +		goto EXIT;
> +
>  	err = platform_device_add_resources(pdev, &res, 1);
>  	if (err) {
>  		printk(KERN_ERR DRVNAME ": Device resource addition failed "
> diff -puN drivers/hwmon/vt8231.c~check-for-acpi-resource-conflicts-in-hwmon-drivers drivers/hwmon/vt8231.c
> --- a/drivers/hwmon/vt8231.c~check-for-acpi-resource-conflicts-in-hwmon-drivers
> +++ a/drivers/hwmon/vt8231.c
> @@ -35,6 +35,7 @@
>  #include <linux/hwmon-vid.h>
>  #include <linux/err.h>
>  #include <linux/mutex.h>
> +#include <linux/acpi.h>
>  #include <asm/io.h>
>  
>  static int force_addr;
> @@ -858,6 +859,10 @@ static int __devinit vt8231_device_add(u
>  	};
>  	int err;
>  
> +	err = acpi_check_resource_conflict(&res);
> +	if (err)
> +		goto exit;
> +
>  	pdev = platform_device_alloc("vt8231", address);
>  	if (!pdev) {
>  		err = -ENOMEM;
> diff -puN drivers/hwmon/w83627ehf.c~check-for-acpi-resource-conflicts-in-hwmon-drivers drivers/hwmon/w83627ehf.c
> --- a/drivers/hwmon/w83627ehf.c~check-for-acpi-resource-conflicts-in-hwmon-drivers
> +++ a/drivers/hwmon/w83627ehf.c
> @@ -48,6 +48,7 @@
>  #include <linux/hwmon-vid.h>
>  #include <linux/err.h>
>  #include <linux/mutex.h>
> +#include <linux/acpi.h>
>  #include <asm/io.h>
>  #include "lm75.h"
>  
> @@ -1544,6 +1545,11 @@ static int __init sensors_w83627ehf_init
>  	res.start = address + IOREGION_OFFSET;
>  	res.end = address + IOREGION_OFFSET + IOREGION_LENGTH - 1;
>  	res.flags = IORESOURCE_IO;
> +
> +	err = acpi_check_resource_conflict(&res);
> +	if (err)
> +		goto exit;
> +
>  	err = platform_device_add_resources(pdev, &res, 1);
>  	if (err) {
>  		printk(KERN_ERR DRVNAME ": Device resource addition failed "
> diff -puN drivers/hwmon/w83627hf.c~check-for-acpi-resource-conflicts-in-hwmon-drivers drivers/hwmon/w83627hf.c
> --- a/drivers/hwmon/w83627hf.c~check-for-acpi-resource-conflicts-in-hwmon-drivers
> +++ a/drivers/hwmon/w83627hf.c
> @@ -50,6 +50,7 @@
>  #include <linux/err.h>
>  #include <linux/mutex.h>
>  #include <linux/ioport.h>
> +#include <linux/acpi.h>
>  #include <asm/io.h>
>  #include "lm75.h"
>  
> @@ -1746,6 +1747,10 @@ static int __init w83627hf_device_add(un
>  	};
>  	int err;
>  
> +	err = acpi_check_resource_conflict(&res);
> +	if (err)
> +		goto exit;
> +
>  	pdev = platform_device_alloc(DRVNAME, address);
>  	if (!pdev) {
>  		err = -ENOMEM;
> _
> 

