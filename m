Return-Path: <linux-kernel-owner+w=401wt.eu-S1759969AbYFZTu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969AbYFZTu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbYFZTus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:50:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:32768 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754364AbYFZTuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:50:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
Date: Thu, 26 Jun 2008 21:52:00 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <Pine.LNX.4.55.0806202241120.19614@cliff.in.clinika.pl> <20080621014047.GA20908@srcf.ucam.org>
In-Reply-To: <20080621014047.GA20908@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806262152.02099.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 21 of June 2008, Matthew Garrett wrote:
> On Sat, Jun 21, 2008 at 02:09:00AM +0100, Maciej W. Rozycki wrote:
> 
> >  Meanwhile we may consider implementing a workaround.  I think one that 
> > does not hurt competent vendors would be preferable.  The DSDT containing 
> > the rubbish described here is marked with an OEM ID: "HP    " and OEM 
> > Table ID: "SB400".  These keys could be used to remove IRQ0 information
> > from the IRQ tables.  Our code is prepared to handle such a case.  
> > Something easy to do for a seasoned ACPI fiddler, I suppose. ;)
> 
> Something roughly like the following? Entirely untested, my 6125 is in a 
> box somewhere. My recollection is that skip_timer_override will disable 
> the IRQ 0->2 mapping, which I believe is what's broken here?

Well, actually, I'm not sure that will work.  I have only found
acpi_skip_timer_override being set to 1 in two places, but it doesn't seem to
be read anywhere.  What am I missing?


> diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
> index 33c5216..6ca5eff 100644
> --- a/arch/x86/kernel/acpi/boot.c
> +++ b/arch/x86/kernel/acpi/boot.c
> @@ -1060,6 +1060,16 @@ static int __init force_acpi_ht(const struct dmi_system_id *d)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_X86_IO_APIC
> +static int __init force_skip_timer_override(const struct dmi_system_id *d)
> +{
> +	printk(KERN_NOTICE "%s detected: disabling timer overrides",
> +	       d->ident);
> +	acpi_skip_timer_override = 1;
> +	return 0;
> +}
> +#endif
> +
>  /*
>   * If your system is blacklisted here, but you find that acpi=force
>   * works for you, please contact acpi-devel@sourceforge.net
> @@ -1227,6 +1237,24 @@ static struct dmi_system_id __initdata acpi_dmi_table[] = {
>  		     DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 360"),
>  		     },
>  	 },
> +#ifdef CONFIG_X86_IO_APIC
> +	{
> +	 .callback = force_skip_timer_override,
> +	 .ident = "HP NX6125 laptop",
> +	 .matches = {
> +		     DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
> +		     DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nx6125"),
> +		     },
> +	 },
> +	{
> +	 .callback = force_skip_timer_override,
> +	 .ident = "HP NX6325 laptop",
> +	 .matches = {
> +		     DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
> +		     DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nx6325"),
> +		     },
> +	 },
> +#endif
>  	{}
>  };
> 
