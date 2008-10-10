Return-Path: <linux-kernel-owner+w=401wt.eu-S1762198AbYJJXT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762198AbYJJXT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 19:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbYJJXTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 19:19:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54885 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758751AbYJJXTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 19:19:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 2/2] ide: add proper PCI PM support
Date: Sat, 11 Oct 2008 01:23:29 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200808021917.04847.bzolnier@gmail.com> <20080819153437.68272594.akpm@linux-foundation.org> <200810102122.07573.bzolnier@gmail.com>
In-Reply-To: <200810102122.07573.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810110123.30087.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 10 of October 2008, Bartlomiej Zolnierkiewicz wrote:
> On Wednesday 20 August 2008, Andrew Morton wrote:
> > On Sat, 2 Aug 2008 19:17:04 +0200
> > Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> > 
> > > -static unsigned int __devinit init_chipset_aec62xx(struct pci_dev *dev)
> > > +static unsigned int init_chipset_aec62xx(struct pci_dev *dev)
> > >  {
> > >  	/* These are necessary to get AEC6280 Macintosh cards to work */
> > >  	if ((dev->device == PCI_DEVICE_ID_ARTOP_ATP865) ||
> > > @@ -307,6 +307,10 @@ static struct pci_driver driver = {
> > >  	.id_table	= aec62xx_pci_tbl,
> > >  	.probe		= aec62xx_init_one,
> > >  	.remove		= aec62xx_remove,
> > > +#ifdef CONFIG_PM
> > > +	.suspend	= ide_pci_suspend,
> > > +	.resume		= ide_pci_resume,
> > > +#endif
> > >  };
> > >  
> > >  static int __init aec62xx_ide_init(void)
> > > Index: b/drivers/ide/pci/alim15x3.c
> > > ===================================================================
> > > --- a/drivers/ide/pci/alim15x3.c
> > > +++ b/drivers/ide/pci/alim15x3.c
> > > @@ -213,7 +213,7 @@ static int ali15x3_dma_setup(ide_drive_t
> > >   *	appropriate also sets up the 1533 southbridge.
> > >   */
> > >  
> > > -static unsigned int __devinit init_chipset_ali15x3(struct pci_dev *dev)
> > > +static unsigned int init_chipset_ali15x3(struct pci_dev *dev)
> > >  {
> > >  	unsigned long flags;
> > >  	u8 tmpbyte;
> > > @@ -581,6 +581,10 @@ static struct pci_driver driver = {
> > >  	.id_table	= alim15x3_pci_tbl,
> > >  	.probe		= alim15x3_init_one,
> > >  	.remove		= ide_pci_remove,
> > > +#ifdef CONFIG_PM
> > > +	.suspend	= ide_pci_suspend,
> > > +	.resume		= ide_pci_resume,
> > > +#endif
> > 
> > Please do
> > 
> > #ifndef CONFIG_PM
> > #define ide_pci_suspend NULL
> > #define ide_pci_resume NULL
> > #endif
> > 
> > in a header file and then remove all these ifdefs.
> > 
> > It's a pretty common convention and will clean things up rather a lot.
> 
> Thanks for the hint.
> 
> "better late than never" v1 -> v2 inter-diff:

Looks good to me, FWIW.

> ...
> v2:
> * Cleanup CONFIG_PM #ifdef-s per akpm's suggestion.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ...
> 
> diff -u b/drivers/ide/pci/aec62xx.c b/drivers/ide/pci/aec62xx.c
> --- b/drivers/ide/pci/aec62xx.c
> +++ b/drivers/ide/pci/aec62xx.c
> @@ -307,10 +307,8 @@
>  	.id_table	= aec62xx_pci_tbl,
>  	.probe		= aec62xx_init_one,
>  	.remove		= __devexit_p(aec62xx_remove),
> -#ifdef CONFIG_PM
>  	.suspend	= ide_pci_suspend,
>  	.resume		= ide_pci_resume,
> -#endif
>  };
>  
>  static int __init aec62xx_ide_init(void)
> diff -u b/drivers/ide/pci/alim15x3.c b/drivers/ide/pci/alim15x3.c
> --- b/drivers/ide/pci/alim15x3.c
> +++ b/drivers/ide/pci/alim15x3.c
> @@ -581,10 +581,8 @@
>  	.id_table	= alim15x3_pci_tbl,
>  	.probe		= alim15x3_init_one,
>  	.remove		= ide_pci_remove,
> -#ifdef CONFIG_PM
>  	.suspend	= ide_pci_suspend,
>  	.resume		= ide_pci_resume,
> -#endif
>  };
>  
>  static int __init ali15x3_ide_init(void)
> diff -u b/drivers/ide/pci/amd74xx.c b/drivers/ide/pci/amd74xx.c
> --- b/drivers/ide/pci/amd74xx.c
> +++ b/drivers/ide/pci/amd74xx.c
> @@ -324,10 +324,8 @@
>  	.id_table	= amd74xx_pci_tbl,
>  	.probe		= amd74xx_probe,
>  	.remove		= ide_pci_remove,
> -#ifdef CONFIG_PM
>  	.suspend	= ide_pci_suspend,
>  	.resume		= ide_pci_resume,
> -#endif
>  };
>  
>  static int __init amd74xx_ide_init(void)
> diff -u b/drivers/ide/pci/atiixp.c b/drivers/ide/pci/atiixp.c
> --- b/drivers/ide/pci/atiixp.c
> +++ b/drivers/ide/pci/atiixp.c
> @@ -187,10 +187,8 @@
>  	.id_table	= atiixp_pci_tbl,
>  	.probe		= atiixp_init_one,
>  	.remove		= ide_pci_remove,
> -#ifdef CONFIG_PM
>  	.suspend	= ide_pci_suspend,
>  	.resume		= ide_pci_resume,
> -#endif
>  };
>  
>  static int __init atiixp_ide_init(void)
> diff -u b/drivers/ide/pci/cmd64x.c b/drivers/ide/pci/cmd64x.c
> --- b/drivers/ide/pci/cmd64x.c
> +++ b/drivers/ide/pci/cmd64x.c
> @@ -510,10 +510,8 @@
>  	.id_table	= cmd64x_pci_tbl,
>  	.probe		= cmd64x_init_one,
>  	.remove		= ide_pci_remove,
> -#ifdef CONFIG_PM
>  	.suspend	= ide_pci_suspend,
>  	.resume		= ide_pci_resume,
> -#endif
>  };
>  
>  static int __init cmd64x_ide_init(void)
> diff -u b/drivers/ide/pci/cs5520.c b/drivers/ide/pci/cs5520.c
> --- b/drivers/ide/pci/cs5520.c
> +++ b/drivers/ide/pci/cs5520.c
> @@ -149,10 +149,8 @@
>  	.name		= "Cyrix_IDE",
>  	.id_table	= cs5520_pci_tbl,
>  	.probe		= cs5520_init_one,
> -#ifdef CONFIG_PM
>  	.suspend	= ide_pci_suspend,
>  	.resume		= ide_pci_resume,
> -#endif
>  };
>  
>  static int __init cs5520_ide_init(void)
> diff -u b/drivers/ide/pci/cs5530.c b/drivers/ide/pci/cs5530.c
> --- b/drivers/ide/pci/cs5530.c
> +++ b/drivers/ide/pci/cs5530.c
> @@ -272,10 +272,8 @@
>  	.id_table	= cs5530_pci_tbl,
>  	.probe		= cs5530_init_one,
>  	.remove		= ide_pci_remove,
> -#ifdef CONFIG_PM
>  	.suspend	= ide_pci_suspend,
>  	.resume		= ide_pci_resume,
> -#endif
>  };
>  
>  static int __init cs5530_ide_init(void)
> diff -u b/drivers/ide/pci/cs5535.c b/drivers/ide/pci/cs5535.c
> --- b/drivers/ide/pci/cs5535.c
> +++ b/drivers/ide/pci/cs5535.c
> @@ -197,10 +197,8 @@
>  	.id_table	= cs5535_pci_tbl,
>  	.probe		= cs5535_init_one,
>  	.remove		= ide_pci_remove,
> -#ifdef CONFIG_PM
>  	.suspend	= ide_pci_suspend,
>  	.resume		= ide_pci_resume,
> -#endif
>  };
>  
>  static int __init cs5535_ide_init(void)
> diff -u b/drivers/ide/pci/cy82c693.c b/drivers/ide/pci/cy82c693.c
> --- b/drivers/ide/pci/cy82c693.c
> +++ b/drivers/ide/pci/cy82c693.c
> @@ -448,10 +448,8 @@
>  	.id_table	= cy82c693_pci_tbl,
>  	.probe		= cy82c693_init_one,
>  	.remove		= __devexit_p(cy82c693_remove),
> -#ifdef CONFIG_PM
>  	.suspend	= ide_pci_suspend,
>  	.resume		= ide_pci_resume,
> -#endif
>  };
>  
>  static int __init cy82c693_ide_init(void)
> diff -u b/drivers/ide/pci/generic.c b/drivers/ide/pci/generic.c
> --- b/drivers/ide/pci/generic.c
> +++ b/drivers/ide/pci/generic.c
> @@ -171,10 +171,8 @@
>  	.id_table	= generic_pci_tbl,
>  	.probe		= generic_init_one,
>  	.remove		= ide_pci_remove,
> -#ifdef CONFIG_PM
>  	.suspend	= ide_pci_suspend,
>  	.resume		= ide_pci_resume,
> -#endif
>  };
>  
>  static int __init generic_ide_init(void)
> diff -u b/drivers/ide/pci/hpt34x.c b/drivers/ide/pci/hpt34x.c
> --- b/drivers/ide/pci/hpt34x.c
> +++ b/drivers/ide/pci/hpt34x.c
> @@ -171,10 +171,8 @@
>  	.id_table	= hpt34x_pci_tbl,
>  	.probe		= hpt34x_init_one,
>  	.remove		= ide_pci_remove,
> -#ifdef CONFIG_PM
>  	.suspend	= ide_pci_suspend,
>  	.resume		= ide_pci_resume,
> -#endif
>  };
>  
>  static int __init hpt34x_ide_init(void)
> diff -u b/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
> --- b/drivers/ide/pci/hpt366.c
> +++ b/drivers/ide/pci/hpt366.c
> @@ -1627,10 +1627,8 @@
>  	.id_table	= hpt366_pci_tbl,
>  	.probe		= hpt366_init_one,
>  	.remove		= __devexit_p(hpt366_remove),
> -#ifdef CONFIG_PM
>  	.suspend	= ide_pci_suspend,
>  	.resume		= ide_pci_resume,
> -#endif
>  };
>  
>  static int __init hpt366_ide_init(void)
> diff -u b/drivers/ide/pci/it8213.c b/drivers/ide/pci/it8213.c
> --- b/drivers/ide/pci/it8213.c
> +++ b/drivers/ide/pci/it8213.c
> @@ -194,10 +194,8 @@
>  	.id_table	= it8213_pci_tbl,
>  	.probe		= it8213_init_one,
>  	.remove		= ide_pci_remove,
> -#ifdef CONFIG_PM
>  	.suspend	= ide_pci_suspend,
>  	.resume		= ide_pci_resume,
> -#endif
>  };
>  
>  static int __init it8213_ide_init(void)
> diff -u b/drivers/ide/pci/it821x.c b/drivers/ide/pci/it821x.c
> --- b/drivers/ide/pci/it821x.c
> +++ b/drivers/ide/pci/it821x.c
> @@ -685,10 +685,8 @@
>  	.id_table	= it821x_pci_tbl,
>  	.probe		= it821x_init_one,
>  	.remove		= __devexit_p(it821x_remove),
> -#ifdef CONFIG_PM
>  	.suspend	= ide_pci_suspend,
>  	.resume		= ide_pci_resume,
> -#endif
>  };
>  
>  static int __init it821x_ide_init(void)
> diff -u b/drivers/ide/pci/jmicron.c b/drivers/ide/pci/jmicron.c
> --- b/drivers/ide/pci/jmicron.c
> +++ b/drivers/ide/pci/jmicron.c
> @@ -154,10 +154,8 @@
>  	.id_table	= jmicron_pci_tbl,
>  	.probe		= jmicron_init_one,
>  	.remove		= ide_pci_remove,
> -#ifdef CONFIG_PM
>  	.suspend	= ide_pci_suspend,
>  	.resume		= ide_pci_resume,
> -#endif
>  };
>  
>  static int __init jmicron_ide_init(void)
> diff -u b/drivers/ide/pci/ns87415.c b/drivers/ide/pci/ns87415.c
> --- b/drivers/ide/pci/ns87415.c
> +++ b/drivers/ide/pci/ns87415.c
> @@ -339,10 +339,8 @@
>  	.id_table	= ns87415_pci_tbl,
>  	.probe		= ns87415_init_one,
>  	.remove		= ide_pci_remove,
> -#ifdef CONFIG_PM
>  	.suspend	= ide_pci_suspend,
>  	.resume		= ide_pci_resume,
> -#endif
>  };
>  
>  static int __init ns87415_ide_init(void)
> diff -u b/drivers/ide/pci/opti621.c b/drivers/ide/pci/opti621.c
> --- b/drivers/ide/pci/opti621.c
> +++ b/drivers/ide/pci/opti621.c
> @@ -225,10 +225,8 @@
>  	.id_table	= opti621_pci_tbl,
>  	.probe		= opti621_init_one,
>  	.remove		= ide_pci_remove,
> -#ifdef CONFIG_PM
>  	.suspend	= ide_pci_suspend,
>  	.resume		= ide_pci_resume,
> -#endif
>  };
>  
>  static int __init opti621_ide_init(void)
> diff -u b/drivers/ide/pci/pdc202xx_new.c b/drivers/ide/pci/pdc202xx_new.c
> --- b/drivers/ide/pci/pdc202xx_new.c
> +++ b/drivers/ide/pci/pdc202xx_new.c
> @@ -566,10 +566,8 @@
>  	.id_table	= pdc202new_pci_tbl,
>  	.probe		= pdc202new_init_one,
>  	.remove		= __devexit_p(pdc202new_remove),
> -#ifdef CONFIG_PM
>  	.suspend	= ide_pci_suspend,
>  	.resume		= ide_pci_resume,
> -#endif
>  };
>  
>  static int __init pdc202new_ide_init(void)
> diff -u b/drivers/ide/pci/pdc202xx_old.c b/drivers/ide/pci/pdc202xx_old.c
> --- b/drivers/ide/pci/pdc202xx_old.c
> +++ b/drivers/ide/pci/pdc202xx_old.c
> @@ -431,10 +431,8 @@
>  	.id_table	= pdc202xx_pci_tbl,
>  	.probe		= pdc202xx_init_one,
>  	.remove		= ide_pci_remove,
> -#ifdef CONFIG_PM
>  	.suspend	= ide_pci_suspend,
>  	.resume		= ide_pci_resume,
> -#endif
>  };
>  
>  static int __init pdc202xx_ide_init(void)
> diff -u b/drivers/ide/pci/piix.c b/drivers/ide/pci/piix.c
> --- b/drivers/ide/pci/piix.c
> +++ b/drivers/ide/pci/piix.c
> @@ -449,10 +449,8 @@
>  	.id_table	= piix_pci_tbl,
>  	.probe		= piix_init_one,
>  	.remove		= ide_pci_remove,
> -#ifdef CONFIG_PM
>  	.suspend	= ide_pci_suspend,
>  	.resume		= ide_pci_resume,
> -#endif
>  };
>  
>  static int __init piix_ide_init(void)
> diff -u b/drivers/ide/pci/serverworks.c b/drivers/ide/pci/serverworks.c
> --- b/drivers/ide/pci/serverworks.c
> +++ b/drivers/ide/pci/serverworks.c
> @@ -448,10 +448,8 @@
>  	.id_table	= svwks_pci_tbl,
>  	.probe		= svwks_init_one,
>  	.remove		= ide_pci_remove,
> -#ifdef CONFIG_PM
>  	.suspend	= ide_pci_suspend,
>  	.resume		= ide_pci_resume,
> -#endif
>  };
>  
>  static int __init svwks_ide_init(void)
> diff -u b/drivers/ide/pci/siimage.c b/drivers/ide/pci/siimage.c
> --- b/drivers/ide/pci/siimage.c
> +++ b/drivers/ide/pci/siimage.c
> @@ -834,10 +834,8 @@
>  	.id_table	= siimage_pci_tbl,
>  	.probe		= siimage_init_one,
>  	.remove		= __devexit_p(siimage_remove),
> -#ifdef CONFIG_PM
>  	.suspend	= ide_pci_suspend,
>  	.resume		= ide_pci_resume,
> -#endif
>  };
>  
>  static int __init siimage_ide_init(void)
> diff -u b/drivers/ide/pci/sis5513.c b/drivers/ide/pci/sis5513.c
> --- b/drivers/ide/pci/sis5513.c
> +++ b/drivers/ide/pci/sis5513.c
> @@ -610,10 +610,8 @@
>  	.id_table	= sis5513_pci_tbl,
>  	.probe		= sis5513_init_one,
>  	.remove		= __devexit_p(sis5513_remove),
> -#ifdef CONFIG_PM
>  	.suspend	= ide_pci_suspend,
>  	.resume		= ide_pci_resume,
> -#endif
>  };
>  
>  static int __init sis5513_ide_init(void)
> diff -u b/drivers/ide/pci/sl82c105.c b/drivers/ide/pci/sl82c105.c
> --- b/drivers/ide/pci/sl82c105.c
> +++ b/drivers/ide/pci/sl82c105.c
> @@ -350,10 +350,8 @@
>  	.id_table	= sl82c105_pci_tbl,
>  	.probe		= sl82c105_init_one,
>  	.remove		= ide_pci_remove,
> -#ifdef CONFIG_PM
>  	.suspend	= ide_pci_suspend,
>  	.resume		= ide_pci_resume,
> -#endif
>  };
>  
>  static int __init sl82c105_ide_init(void)
> diff -u b/drivers/ide/pci/slc90e66.c b/drivers/ide/pci/slc90e66.c
> --- b/drivers/ide/pci/slc90e66.c
> +++ b/drivers/ide/pci/slc90e66.c
> @@ -159,10 +159,8 @@
>  	.id_table	= slc90e66_pci_tbl,
>  	.probe		= slc90e66_init_one,
>  	.remove		= ide_pci_remove,
> -#ifdef CONFIG_PM
>  	.suspend	= ide_pci_suspend,
>  	.resume		= ide_pci_resume,
> -#endif
>  };
>  
>  static int __init slc90e66_ide_init(void)
> diff -u b/drivers/ide/pci/triflex.c b/drivers/ide/pci/triflex.c
> --- b/drivers/ide/pci/triflex.c
> +++ b/drivers/ide/pci/triflex.c
> @@ -119,10 +119,8 @@
>  	.id_table	= triflex_pci_tbl,
>  	.probe		= triflex_init_one,
>  	.remove		= ide_pci_remove,
> -#ifdef CONFIG_PM
>  	.suspend	= ide_pci_suspend,
>  	.resume		= ide_pci_resume,
> -#endif
>  };
>  
>  static int __init triflex_ide_init(void)
> diff -u b/drivers/ide/pci/via82cxxx.c b/drivers/ide/pci/via82cxxx.c
> --- b/drivers/ide/pci/via82cxxx.c
> +++ b/drivers/ide/pci/via82cxxx.c
> @@ -492,10 +492,8 @@
>  	.id_table 	= via_pci_tbl,
>  	.probe 		= via_init_one,
>  	.remove		= __devexit_p(via_remove),
> -#ifdef CONFIG_PM
>  	.suspend	= ide_pci_suspend,
>  	.resume		= ide_pci_resume,
> -#endif
>  };
>  
>  static int __init via_ide_init(void)
> diff -u b/include/linux/ide.h b/include/linux/ide.h
> --- b/include/linux/ide.h
> +++ b/include/linux/ide.h
> @@ -1269,6 +1269,9 @@
>  #ifdef CONFIG_PM
>  int ide_pci_suspend(struct pci_dev *, pm_message_t);
>  int ide_pci_resume(struct pci_dev *);
> +#else
> +#define ide_pci_suspend NULL
> +#define ide_pci_resume NULL
>  #endif
>  
>  void ide_map_sg(ide_drive_t *, struct request *);
> 
> 
> 
> 


