Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022AbYKOW7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbYKOW7p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 17:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbYKOW7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 17:59:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41236 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbYKOW7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 17:59:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tino Keitel <tino.keitel@gmx.de>
Subject: Re: [stable] Suspend regression in stable kernel 2.6.27.4 on Mac mini Core Duo
Date: Sun, 16 Nov 2008 00:04:16 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, "Bob Copeland" <me@bobcopeland.com>
References: <20081109202830.GA7206@x61> <20081113192656.GA5735@dose.home.local> <200811132318.13821.rjw@sisk.pl>
In-Reply-To: <200811132318.13821.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811160004.17804.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 13 of November 2008, Rafael J. Wysocki wrote:
> On Thursday, 13 of November 2008, Tino Keitel wrote:
> > On Wed, Nov 12, 2008 at 22:41:08 +0100, Rafael J. Wysocki wrote:
> > > On Wednesday, 12 of November 2008, Tino Keitel wrote:
> > > > On Wed, Nov 12, 2008 at 01:03:54 +0100, Rafael J. Wysocki wrote:
> > > > 
> > > > [...]
> > > > 
> > > > > Also, can you check this patch on top of 2.6.27.4 and see what happens?
> > > > 
> > > > With that patch, resume works (although I used 2.6.27.5 and not
> > > > 2.6.27.5, if that matters).
> > > 
> > > It shouldn't really matter.
> > > 
> > > Thanks for testing and please send me the output of dmidecode.
> > > It seems that blacklisting may be the only way to handle your box. :-(
> > 
> > Attached.
> 
> Please try the appended patch on top of the Linus' tree.

This patch also applies to current -stable, so you can test it on top of that.

I need your confirmation that the patch works to push it upstream.

Thanks,
Rafael


> ---
>  drivers/acpi/sleep/main.c |   40 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 39 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/acpi/sleep/main.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/sleep/main.c
> +++ linux-2.6/drivers/acpi/sleep/main.c
> @@ -104,6 +104,18 @@ void __init acpi_s4_no_nvs(void)
>  	s4_no_nvs = true;
>  }
>  
> +/*
> + * According to the ACPI specification the BIOS should make sure that ACPI is
> + * enabled and SCI_EN bit is set on wake-up from S1 - S3 sleep states.  Still,
> + * some BIOSes don't do that and therefore we use acpi_enable() to enable ACPI
> + * on such systems during resume.  Unfortunately that doesn't help in
> + * particularly pathological cases in which SCI_EN has to be set directly on
> + * resume, although the specification states very clearly that this flag is
> + * owned by the hardware.  The set_sci_en_on_resume variable will be set in such
> + * cases.
> + */
> +static bool set_sci_en_on_resume;
> +
>  /**
>   *	acpi_pm_disable_gpes - Disable the GPEs.
>   */
> @@ -249,7 +261,11 @@ static int acpi_suspend_enter(suspend_st
>  	}
>  
>  	/* If ACPI is not enabled by the BIOS, we need to enable it here. */
> -	acpi_enable();
> +	if (set_sci_en_on_resume)
> +		acpi_set_register(ACPI_BITREG_SCI_ENABLE, 1);
> +	else
> +		acpi_enable();
> +
>  	/* Reprogram control registers and execute _BFS */
>  	acpi_leave_sleep_state_prep(acpi_state);
>  
> @@ -337,6 +353,12 @@ static int __init init_old_suspend_order
>  	return 0;
>  }
>  
> +static int __init init_set_sci_en_on_resume(const struct dmi_system_id *d)
> +{
> +	set_sci_en_on_resume = true;
> +	return 0;
> +}
> +
>  static struct dmi_system_id __initdata acpisleep_dmi_table[] = {
>  	{
>  	.callback = init_old_suspend_ordering,
> @@ -354,6 +376,22 @@ static struct dmi_system_id __initdata a
>  		DMI_MATCH(DMI_PRODUCT_NAME, "HP xw4600 Workstation"),
>  		},
>  	},
> +	{
> +	.callback = init_set_sci_en_on_resume,
> +	.ident = "Apple MacBook 1,1",
> +	.matches = {
> +		DMI_MATCH(DMI_SYS_VENDOR, "Apple Computer, Inc."),
> +		DMI_MATCH(DMI_PRODUCT_NAME, "MacBook1,1"),
> +		},
> +	},
> +	{
> +	.callback = init_set_sci_en_on_resume,
> +	.ident = "Apple MacMini 1,1",
> +	.matches = {
> +		DMI_MATCH(DMI_SYS_VENDOR, "Apple Computer, Inc."),
> +		DMI_MATCH(DMI_PRODUCT_NAME, "Macmini1,1"),
> +		},
> +	},
>  	{},
>  };
>  #endif /* CONFIG_SUSPEND */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 



-- 
Everyone knows that debugging is twice as hard as writing a program
in the first place.  So if you're as clever as you can be when you write it,
how will you ever debug it? --- Brian Kernighan
