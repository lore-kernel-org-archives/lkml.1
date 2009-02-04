Return-Path: <linux-kernel-owner+w=401wt.eu-S1760109AbZBDVZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760109AbZBDVZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 16:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbZBDVZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 16:25:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51417 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261AbZBDVZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 16:25:30 -0500
Date: Wed, 4 Feb 2009 22:25:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ed Swierk <eswierk@aristanetworks.com>, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lenb@kernel.org, linux-acpi@vger.kernel.org, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] Detect mmconfig on nVidia MCP55
Message-ID: <20090204212517.GM22608@elte.hu>
References: <1233765552.16414.6.camel@localhost.localdomain> <86802c440902041212q51f2a444l84e1ac29ee6f702e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440902041212q51f2a444l84e1ac29ee6f702e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> On Wed, Feb 4, 2009 at 8:39 AM, Ed Swierk <eswierk@aristanetworks.com> wrote:
> > Detect and enable memory-mapped PCI configuration space on the nVidia
> > MCP55 southbridge even if the ACPI MCFG table is missing or wrong.
> >
> > Signed-off-by: Ed Swierk <eswierk@aristanetworks.com>
> >
> > ---
> > Index: linux-2.6.27.4/arch/x86/pci/mmconfig-shared.c
> > ===================================================================
> > --- linux-2.6.27.4.orig/arch/x86/pci/mmconfig-shared.c
> > +++ linux-2.6.27.4/arch/x86/pci/mmconfig-shared.c
> > @@ -155,6 +155,26 @@ static const char __init *pci_mmcfg_amd_
> >        return "AMD Family 10h NB";
> >  }
> >
> > +static const char __init *pci_mmcfg_nvidia_mcp55(void)
> > +{
> > +       u32 extcfg;
> > +
> > +       raw_pci_ops->read(0, 0, PCI_DEVFN(0, 0), 0x90, 4, &extcfg);
> > +
> > +       if (!(extcfg & 0x80000000))
> > +               return NULL;
> > +       pci_mmcfg_config = kzalloc(sizeof(pci_mmcfg_config[0]), GFP_KERNEL);
> > +       if (!pci_mmcfg_config)
> > +               return NULL;
> > +       pci_mmcfg_config[0].address = (extcfg & 0x00007fff) << 25;
> > +       pci_mmcfg_config[0].pci_segment = 0;
> > +       pci_mmcfg_config[0].start_bus_number = 0;
> > +       pci_mmcfg_config[0].end_bus_number = (1 << (8 - ((extcfg >> 28) & 3))) - 1;
> > +       pci_mmcfg_config_num = 1;
> > +
> > +       return "nVidia MCP55";
> > +}
> > +
> >  struct pci_mmcfg_hostbridge_probe {
> >        u32 bus;
> >        u32 devfn;
> > @@ -172,6 +192,8 @@ static struct pci_mmcfg_hostbridge_probe
> >          0x1200, pci_mmcfg_amd_fam10h },
> >        { 0xff, PCI_DEVFN(0, 0), PCI_VENDOR_ID_AMD,
> >          0x1200, pci_mmcfg_amd_fam10h },
> > +       { 0, PCI_DEVFN(0, 0), PCI_VENDOR_ID_NVIDIA,
> > +         0x0369, pci_mmcfg_nvidia_mcp55 },
> 
> may break amd family 10h + mcp55 system. because some system have setting 
> in AMD cpu and mcp55 it will find setting in CPU nb, and your code will 
> partially overwrite those setting.

That's a good point ...

We could do something like:

	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
		boot_cpu_data.x86 >= 0x10) {
		u64 mmconf_val;

		rdmsrl(MSR_FAM10H_MMIO_CONF_BASE, mmconf_val);
		if (mmconf_val & FAM10H_MMIO_CONF_ENABLE)
			return;
	}

To detect enabled on-CPU mmconf support. We could even put this into a 
helper function as other places might want to use it too.

	Ingo
