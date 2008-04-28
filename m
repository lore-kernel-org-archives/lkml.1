Return-Path: <linux-kernel-owner+w=401wt.eu-S936622AbYD1UfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936622AbYD1UfL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965662AbYD1Uef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:34:35 -0400
Received: from outbound-mail-141.bluehost.com ([67.222.38.31]:40989 "HELO
	outbound-mail-141.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965443AbYD1Uee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:34:34 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [git pull] "big box" x86 changes, PCI
Date: Mon, 28 Apr 2008 13:34:15 -0700
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai.lu@sun.com>, Yinghai Lu <yhlu.kernel@gmail.com>
References: <20080426185516.GA32364@elte.hu> <alpine.LFD.1.10.0804261205490.2813@woody.linux-foundation.org> <20080426215540.GA3545@elte.hu>
In-Reply-To: <20080426215540.GA3545@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200804281334.16713.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m3SKZHEB019079

On Saturday, April 26, 2008 2:55 pm Ingo Molnar wrote:> @@ -184,51 +322,80 @@ static void __init pci_mmcfg_reject_broken(int type)>  >         cfg = &pci_mmcfg_config[0];>  > -       /*> -        * Handle more broken MCFG tables on Asus etc.> -        * They only contain a single entry for bus 0-0.> -        */> -       if (pci_mmcfg_config_num == 1 &&> -           cfg->pci_segment == 0 &&> -           (cfg->start_bus_number | cfg->end_bus_number) == 0) {> -               printk(KERN_ERR "PCI: start and end of bus number is 0. "> -                      "Rejected as broken MCFG.\n");> -               goto reject;> +       for (i = 0; i < pci_mmcfg_config_num; i++) {> +               int valid = 0;> +               u32 size = (cfg->end_bus_number + 1) << 20;> +               cfg = &pci_mmcfg_config[i];> +               printk(KERN_NOTICE "PCI: MCFG configuration %d: base %lx "> +                      "segment %hu buses %u - %u\n",> +                      i, (unsigned long)cfg->address, cfg->pci_segment,> +                      (unsigned int)cfg->start_bus_number,> +                      (unsigned int)cfg->end_bus_number);> +> +               if (!early &&> +                   is_acpi_reserved(cfg->address, cfg->address + size -> 1)) { +                       printk(KERN_NOTICE "PCI: MCFG area at %Lx> reserved " +                              "in ACPI motherboard> resources\n",> +                              cfg->address);> +                       valid = 1;> +               }> +> +               if (valid)> +                       continue;> +> +               if (!early)> +                       printk(KERN_ERR "PCI: BIOS Bug: MCFG area at %Lx is> not" +                              " reserved in ACPI motherboard> resources\n", +                              cfg->address);> +               /* Don't try to do this check unless configuration> +                  type 1 is available. how about type 2 ?*/> +               if (raw_pci_ops && e820_all_mapped(cfg->address,> +                                                 cfg->address + size - 1,> +                                                 E820_RESERVED)) {> +                       printk(KERN_NOTICE> +                              "PCI: MCFG area at %Lx reserved in E820\n",> +                              cfg->address);> +                       valid = 1;> +               }> +> +               if (!valid)> +                       goto reject;>         }
This loop is a bit messy, is there some way of making it clearer?  Maybe the early vs. late stuff should be split into separate routines entirely...
> @@ -842,11 +842,14 @@ static void set_pcie_port_type(struct pci_dev *pdev)>   * reading the dword at 0x100 which must either be 0 or a valid extended>   * capability header.>   */> -int pci_cfg_space_size(struct pci_dev *dev)> +int pci_cfg_space_size_ext(struct pci_dev *dev, unsigned check_exp_pcix)>  {>         int pos;>         u32 status;>  > +       if (!check_exp_pcix)> +               goto skip;> +
Rather than adding a flag to pci_cfg_space_size, you could either factor out the extended space probe into a separate routine and use it from both pci_cfg_space_size and the fixup code, or just make the fixup code do the probe & cfg_size setting by hand, moving the PCI_CFG_SPACE_SIZE and PCI_CFG_SPACE_EXP_SIZE to pci.h.
In both cases I'm just trying to avoid having a flag you pass to a routine that changes its behavior significantly enough that a new function would make things more readable.
Other than that, things look pretty good.  And the resulting kernel boots fine on my test box, which is nice...
Thanks,Jesseÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
