Return-Path: <linux-kernel-owner+w=401wt.eu-S1753337AbYK2HnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbYK2HnB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 02:43:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbYK2Hmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 02:42:50 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:37979 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbYK2Hmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 02:42:49 -0500
Date: Sat, 29 Nov 2008 08:38:16 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Len Brown <lenb@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Len Brown <len.brown@intel.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, x86@kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [RFC PATCH] x86: create drivers/x86/ from drivers/misc/
Message-ID: <20081129073816.GB8351@uranus.ravnborg.org>
References: <20081128213620.2ec593d4.sfr@canb.auug.org.au> <4930307C.30106@oracle.com> <20081129083550.3c23af37.sfr@canb.auug.org.au> <alpine.LFD.2.00.0811281649001.24773@localhost.localdomain> <alpine.LFD.2.00.0811281702570.24773@localhost.localdomain> <alpine.LFD.2.00.0811281706540.24773@localhost.localdomain> <20081128223533.GA5175@uranus.ravnborg.org> <alpine.LFD.2.00.0811281801520.24773@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811281801520.24773@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comments below in case we stick to this drivers/x86 thing...

	Sam

> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 93224b5..b89db1e 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1904,6 +1904,8 @@ source "drivers/Kconfig"
>  
>  source "drivers/firmware/Kconfig"
>  
> +source "drivers/x86/Kconfig"
> +
>  source "fs/Kconfig"

Any chance we can have this in drivers/Kconfig?

Just wrap all of the file in an

if X86
.....
endif

So we keep all the drivers/ stuff in one Kconfig file and
not spread all over.

> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> index d1a47ad..a750519 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -171,6 +171,9 @@ ifeq ($(CONFIG_X86_32),y)
>  drivers-$(CONFIG_FB) += arch/x86/video/
>  endif
>  
> +# x86 platform-specific drivers
> +drivers-y       += drivers/x86/
> +


Can this be included in drivers/Makefile like this:

obj-$(CONFIG_X86) += x86/

Notice that parisc already do the same. (Yes they have
a drivers/parisc dir).

We shall try to visit our tree in natural order when we build
and such a rule breaks this.
Also it is good to keep drivers/ stuff in one place.

> +++ b/drivers/x86/Kconfig
> @@ -0,0 +1,290 @@
> +#
> +# X86 Platform Specific Drivers
> +#
> +
> +menuconfig X86_PLATFORM_DEVICES
> +	bool "X86 Platform devices"
> +	default y
> +	---help---
> +	  Say Y here to get to see options for device drivers for various
> +	  x86 platforms, including vendor-specific laptop extension drivers.
> +	  This option alone does not add any kernel code.
> +
> +	  If you say N, all options in this submenu will be skipped and disabled.
> +
> +if X86_PLATFORM_DEVICES
> +
> +config ACER_WMI
> +        tristate "Acer WMI Laptop Extras (EXPERIMENTAL)"
spaces => tab

> +config ASUS_LAPTOP
> +        tristate "Asus Laptop Extras (EXPERIMENTAL)"
> +        depends on ACPI
spaces => tab

> +config FUJITSU_LAPTOP
> +        tristate "Fujitsu Laptop Extras"
> +        depends on ACPI
> +	depends on INPUT
> +        depends on BACKLIGHT_CLASS_DEVICE
> +        ---help---
spaces => tab

> +config HP_WMI
> +       tristate "HP WMI extras"
> +       depends on ACPI_WMI
> +       depends on INPUT
> +       depends on RFKILL
> +       help
> +         Say Y here if you want to support WMI-based hotkeys on HP laptops and
spaces => tab

> +	 to read data from WMI such as docking or ambient light sensor state.
> +
> +         To compile this driver as a module, choose M here: the module will
> +         be called hp-wmi.
> +
> +config MSI_LAPTOP
> +        tristate "MSI Laptop Extras"
> +        depends on ACPI
> +        depends on BACKLIGHT_CLASS_DEVICE
> +        ---help---
spaces => tab

> diff --git a/drivers/x86/Makefile b/drivers/x86/Makefile
> new file mode 100644
> index 0000000..4f14f28
> --- /dev/null
> +++ b/drivers/x86/Makefile
> @@ -0,0 +1,17 @@
> +#
> +# x86 Platform-Specific Drivers
> +#
> +obj- := x86.o	# Dummy rule to force built-in.o to be made

This is not needed. I can see divers/misc uses the same
but it is bogus.

	Sam
