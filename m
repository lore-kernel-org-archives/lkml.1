Return-Path: <linux-kernel-owner+w=401wt.eu-S968354AbYD1XJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968354AbYD1XJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 19:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967882AbYD1Wxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:53:36 -0400
Received: from rv-out-0708.google.com ([209.85.198.240]:8823 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S967842AbYD1Wxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:53:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MvOiilEJWU8DSrf7R/4c2z1uHUC/CDFqWSQw9sd5l2NqxOqI2ZTdn0Rg29+a9VeLbOJXUftYIIGm0xzmaq8f6yxP3RGxu6fkBhHPrsvkRBWsQEd9Y1ufA2tCfGeXC76D7aN4gv/3TQCiCHRjIiM/MZpg/iZXKsJQ28su/pBoy9E=
Message-ID: <86802c440804281553y69a40b91l4b238cd5281e08d9@mail.gmail.com>
Date: Mon, 28 Apr 2008 15:53:33 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>
Subject: Re: [git pull] "big box" x86 changes, PCI
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <200804281334.16713.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080426185516.GA32364@elte.hu>
	 <alpine.LFD.1.10.0804261205490.2813@woody.linux-foundation.org>
	 <20080426215540.GA3545@elte.hu>
	 <200804281334.16713.jbarnes@virtuousgeek.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 1:34 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Saturday, April 26, 2008 2:55 pm Ingo Molnar wrote:
>
>
> > @@ -184,51 +322,80 @@ static void __init pci_mmcfg_reject_broken(int type)
>  >
>  >         cfg = &pci_mmcfg_config[0];
>  >
>  > -       /*
>  > -        * Handle more broken MCFG tables on Asus etc.
>  > -        * They only contain a single entry for bus 0-0.
>  > -        */
>  > -       if (pci_mmcfg_config_num == 1 &&
>  > -           cfg->pci_segment == 0 &&
>  > -           (cfg->start_bus_number | cfg->end_bus_number) == 0) {
>  > -               printk(KERN_ERR "PCI: start and end of bus number is 0. "
>  > -                      "Rejected as broken MCFG.\n");
>  > -               goto reject;
>  > +       for (i = 0; i < pci_mmcfg_config_num; i++) {
>  > +               int valid = 0;
>  > +               u32 size = (cfg->end_bus_number + 1) << 20;
>  > +               cfg = &pci_mmcfg_config[i];
>  > +               printk(KERN_NOTICE "PCI: MCFG configuration %d: base %lx "
>  > +                      "segment %hu buses %u - %u\n",
>  > +                      i, (unsigned long)cfg->address, cfg->pci_segment,
>  > +                      (unsigned int)cfg->start_bus_number,
>  > +                      (unsigned int)cfg->end_bus_number);
>  > +
>  > +               if (!early &&
>  > +                   is_acpi_reserved(cfg->address, cfg->address + size -
>  > 1)) { +                       printk(KERN_NOTICE "PCI: MCFG area at %Lx
>  > reserved " +                              "in ACPI motherboard
>  > resources\n",
>  > +                              cfg->address);
>  > +                       valid = 1;
>  > +               }
>  > +
>  > +               if (valid)
>  > +                       continue;
>  > +
>  > +               if (!early)
>  > +                       printk(KERN_ERR "PCI: BIOS Bug: MCFG area at %Lx is
>  > not" +                              " reserved in ACPI motherboard
>  > resources\n", +                              cfg->address);
>  > +               /* Don't try to do this check unless configuration
>  > +                  type 1 is available. how about type 2 ?*/
>  > +               if (raw_pci_ops && e820_all_mapped(cfg->address,
>  > +                                                 cfg->address + size - 1,
>  > +                                                 E820_RESERVED)) {
>  > +                       printk(KERN_NOTICE
>  > +                              "PCI: MCFG area at %Lx reserved in E820\n",
>  > +                              cfg->address);
>  > +                       valid = 1;
>  > +               }
>  > +
>  > +               if (!valid)
>  > +                       goto reject;
>  >         }
>
>  This loop is a bit messy, is there some way of making it clearer?  Maybe the
>  early vs. late stuff should be split into separate routines entirely...

        for (i = 0; i < pci_mmcfg_config_num; i++) {
                int valid = 0;
                u32 size = (cfg->end_bus_number + 1) << 20;
                cfg = &pci_mmcfg_config[i];
                printk(KERN_NOTICE "PCI: MCFG configuration %d: base %lx "
                       "segment %hu buses %u - %u\n",
                       i, (unsigned long)cfg->address, cfg->pci_segment,
                       (unsigned int)cfg->start_bus_number,
                       (unsigned int)cfg->end_bus_number);

                if (!early &&
============================================> early check..
                    is_acpi_reserved(cfg->address, cfg->address + size - 1)) {
                        printk(KERN_NOTICE "PCI: MCFG area at %Lx reserved "
                               "in ACPI motherboard resources\n",
                               cfg->address);
                        valid = 1;
                }

                if (valid)
                        continue;

                if (!early)
=================================================> check early
                        printk(KERN_ERR "PCI: BIOS Bug: MCFG area at %Lx is not"
                               " reserved in ACPI motherboard resources\n",
                               cfg->address);
                /* Don't try to do this check unless configuration
                   type 1 is available. how about type 2 ?*/
                if (raw_pci_ops && e820_all_mapped(cfg->address,
                                                  cfg->address + size - 1,
                                                  E820_RESERVED)) {
                        printk(KERN_NOTICE
                               "PCI: MCFG area at %Lx reserved in E820\n",
                               cfg->address);
                        valid = 1;
                }

                if (!valid)
                        goto reject;
        }

        return;

only two early check ... , if split that we will get almost same
duplicated lines.

>
>
>  > @@ -842,11 +842,14 @@ static void set_pcie_port_type(struct pci_dev *pdev)
>  >   * reading the dword at 0x100 which must either be 0 or a valid extended
>  >   * capability header.
>  >   */
>  > -int pci_cfg_space_size(struct pci_dev *dev)
>  > +int pci_cfg_space_size_ext(struct pci_dev *dev, unsigned check_exp_pcix)
>  >  {
>  >         int pos;
>  >         u32 status;
>  >
>  > +       if (!check_exp_pcix)
>  > +               goto skip;
>  > +
>
>  Rather than adding a flag to pci_cfg_space_size, you could either factor out
>  the extended space probe into a separate routine and use it from both
>  pci_cfg_space_size and the fixup code, or just make the fixup code do the
>  probe & cfg_size setting by hand, moving the PCI_CFG_SPACE_SIZE and
>  PCI_CFG_SPACE_EXP_SIZE to pci.h.

by hand, will need to check if mmconf is enabled or not.
will check if can factor out it.

YH
