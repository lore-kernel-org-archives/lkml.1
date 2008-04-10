Return-Path: <linux-kernel-owner+w=401wt.eu-S1755859AbYDJDCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbYDJDCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 23:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbYDJDBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 23:01:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:36694 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293AbYDJDBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 23:01:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,633,1199692800"; 
   d="scan'208";a="548771827"
Subject: Re: [PATCH 2.6.25-rc7 001/001] ACPI: workaround for buggy BIOS to
	ignore error LINK CRS method
From: Zhao Yakui <yakui.zhao@intel.com>
To: NoWhereMan <uncommonnonsense@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>
In-Reply-To: <20080409161251.0c0e73e9.akpm@linux-foundation.org>
References: <f7430a760804090842s44ece7bh216d5d28e347955@mail.gmail.com>
	 <20080409161251.0c0e73e9.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 10 Apr 2008 18:40:57 +0800
Message-Id: <1207824057.8704.12.camel@yakui_zhao.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-09 at 16:12 -0700, Andrew Morton wrote:
> On Wed, 9 Apr 2008 17:42:34 +0200
> NoWhereMan <uncommonnonsense@gmail.com> wrote:
> 
> > >From : Edoardo Vacchi <uncommonnonsense@gmail.com>
> > 
> > When acpi_pci_link_crs_ignore is passed at boot to the kernel,
> > ignores the error about the _CRS method of LINK device and selects
> > IRQ from possible IRQ list returned by _PRS method.
> > 
> > Signed-off-by: Edoardo Vacchi <uncommonnonsense@gmail.com>
> > 
> 
> Let's add some cc's.
> 
> > 
> > This is nothing more than the patch on comment #127 on bug #8896
> > http://bugzilla.kernel.org/show_bug.cgi?id=8896#c127
> > 
> > originally by Zhao Yakui <yakui.zhao@intel.com>
> > 
> > ported to 2.6.25 and wrapped into an additional check for the kernel parameter
> > (plus of course the defintion of the kernel param itself)
> > 
> > The patch provides a workaround for some buggy BIOSes such as Insyde
> > in Packard Bell EasyNote r1938 (of which I'm an unfortunate owner),
> > while still keeping boot safe for people not suffering from this bug
> > 
> 
> That patch is about four months old.  Hopefully there was a reason why we
> dodn't proceed with it?
It seems that the system can work after applying the patch. 
But the patch depends on the returned result(-ENODEV).
> if (ACPI_FAILURE(status)) {
>               ACPI_EXCEPTION((AE_INFO, status, "Evaluating _CRS"));
>                result = -ENODEV;
 >               goto end;
 >       }
Now I am writing another workaround patch about this problem.
> 
> > diff --git a/drivers/acpi/pci_link.c b/drivers/acpi/pci_link.c
> > index 233c40c..ed54c63 100644
> > --- a/drivers/acpi/pci_link.c
> > +++ b/drivers/acpi/pci_link.c
> > @@ -297,6 +297,16 @@ static int acpi_pci_link_get_current(struct
> > acpi_pci_link *link)
> >         return result;
> >  }
> > 
> > +
> > +/*
> > + * this is set when acpi_pci_link_crs_ignore is passed on boot
> > + * it will ignore the -ENODEV error on buggy BIOSes
> > + *
> > + * workaround for bug #8896
> > + *
> > + */
> > +static int acpi_pci_link_crs_ignore; /* 0 or 1*/
> > +
> >  static int acpi_pci_link_set(struct acpi_pci_link *link, int irq)
> >  {
> >         int result = 0;
> > @@ -385,9 +395,16 @@ static int acpi_pci_link_set(struct acpi_pci_link
> > *link, int irq)
> > 
> >         /* Query _CRS, set link->irq.active */
> >         result = acpi_pci_link_get_current(link);
> > -       if (result) {
> > -               goto end;
> > -       }
> > +       if (acpi_pci_link_crs_ignore && result == -ENODEV) {
> > +               /*
> > +                * Ignore the error about the _CRS method of Link device and
> > +                * select IRQ from the Possible IRQ list
> > +                * returned by _PRS method.
> > +                */
> > +                printk(KERN_WARNING "Ignore error LINK CRS method.\n");
> > +                link->irq.active = irq;
> > +                result = 0;
> > +        }
> > 
> >         /*
> >          * Is current setting not what we set?
> > @@ -412,7 +429,16 @@ static int acpi_pci_link_set(struct acpi_pci_link
> > *link, int irq)
> >         return result;
> >  }
> > 
> > -/* --------------------------------------------------------------------------
> > +int __init acpi_pci_link_crs_ignore_set(char *str)
> > +{
> > +       acpi_pci_link_crs_ignore = 1;
> > +       return 1;
> > +}
> > +
> > +__setup("acpi_pci_link_crs_ignore", acpi_pci_link_crs_ignore_set);
> > +
> > +
> > + /* --------------------------------------------------------------------------
> >                              PCI Link IRQ Management
> >     --------------------------------------------------------------------------
> > */
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/

