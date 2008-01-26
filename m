Return-Path: <linux-kernel-owner+w=401wt.eu-S1756693AbYAZJ5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693AbYAZJ5W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 04:57:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbYAZJ5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 04:57:15 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:48744 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822AbYAZJ5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 04:57:14 -0500
Date: Sat, 26 Jan 2008 10:57:23 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [Patch] Shut up warnings from files under drivers/
Message-ID: <20080126095723.GA22285@uranus.ravnborg.org>
References: <20080126093007.GB20935@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080126093007.GB20935@hacking>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi WANG.
On Sat, Jan 26, 2008 at 05:30:07PM +0800, WANG Cong wrote:
> 
> Fix two kind of defined-but-not-used warnings.
> 
> One is due to defination of MODULE_DEVICE_TABLE, the
> other is due to __devexit_p. The solution is just to
> add proper directives to protect those usages.

Please include the actual warnings that you fix.

> 
> Compile tests passed.
> 
> Cc: Greg KH <gregkh@suse.de>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> 
> ---
> 
> diff --git a/drivers/char/applicom.c b/drivers/char/applicom.c
> index 1f0b752..247bc16 100644
> --- a/drivers/char/applicom.c
> +++ b/drivers/char/applicom.c
> @@ -65,6 +65,7 @@ static char *applicom_pci_devnames[] = {
>  	"PCI2000PFB"
>  };
>  
> +#ifdef MODULE
>  static struct pci_device_id applicom_pci_tbl[] = {
>  	{ PCI_VENDOR_ID_APPLICOM, PCI_DEVICE_ID_APPLICOM_PCIGENERIC,
>  	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
> @@ -74,6 +75,8 @@ static struct pci_device_id applicom_pci_tbl[] = {
>  	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
>  	{ 0 }
>  };
> +#endif
> +

As replacement for the above I would prefer som kind of annotation
so we can drop the symbol at linker time.
Something like:

>+  static struct pci_device_id applicom_pci_tbl[] __moduseddata = {
>       { PCI_VENDOR_ID_APPLICOM, PCI_DEVICE_ID_APPLICOM_PCIGENERIC,
>         PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
> @@ -74,6 +75,8 @@ static struct pci_device_id applicom_pci_tbl[] = {
>         PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
>       { 0 }
>  };

where we have:
#ifdef MODULE
#define __moduseddata  __section(.module.data)
#define __modusedconst __section(.module.rodata)
#define __modused      __section(.module.text)
#else
#define __moduseddata  __section(.discard.data)
#define __modusedconst __section(.discard.rodata)
#define __modused      __section(.discard.text)
#endif

And we can then discard the symbols as we do for
__initdata today.


Another much simpler solution could be to say:

>static struct pci_device_id applicom_pci_tbl[] __used = {
>       { PCI_VENDOR_ID_APPLICOM, PCI_DEVICE_ID_APPLICOM_PCIGENERIC,
>         PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
> @@ -74,6 +75,8 @@ static struct pci_device_id applicom_pci_tbl[] = {
>         PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
>       { 0 }
>  };

But we would then in the built-in case waste some memory.

> index 905d1f5..2009dc9 100644
> --- a/drivers/char/synclink.c
> +++ b/drivers/char/synclink.c
> @@ -897,7 +897,9 @@ static char *driver_version = "$Revision: 4.38 $";
>  
>  static int synclink_init_one (struct pci_dev *dev,
>  				     const struct pci_device_id *ent);
> +#if defined(MODULE) || defined(CONFIG_HOTPLUG)
>  static void synclink_remove_one (struct pci_dev *dev);
> +#endif
>  
>  static struct pci_device_id synclink_pci_tbl[] = {
>  	{ PCI_VENDOR_ID_MICROGATE, PCI_DEVICE_ID_MICROGATE_USC, PCI_ANY_ID, PCI_ANY_ID, },
> @@ -8166,7 +8168,8 @@ static int __devinit synclink_init_one (struct pci_dev *dev,
>  	return 0;
>  }
>  
> +#if defined(MODULE) || defined(CONFIG_HOTPLUG)
>  static void __devexit synclink_remove_one (struct pci_dev *dev)
>  {
>  }
> -
> +#endif

This function is properly annotated and __devexit_p() is used
so it should not generate a warning.

The root casue is that __devexit is defined to nothing in the
#ifdef CONFIG_HOTPLUG case - it should have been defined as
#define __devexit __used
if MODULE was not defined.

This is the better fix for these kind of warnings.
For the latter I have fixed this in kbuild.git.
So we are only left with the DEVICE_MOD_TABLE issue.

	Sam
