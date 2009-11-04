Return-Path: <linux-kernel-owner+w=401wt.eu-S933126AbZKDX2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933126AbZKDX2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 18:28:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933074AbZKDX2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 18:28:14 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:8412 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514AbZKDX2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 18:28:14 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] pci/pcie: Avoid unnecessary PCIe link retrains
Date: Wed, 4 Nov 2009 17:28:17 -0600
User-Agent: KMail/1.9.10
Cc: rdh@east.sun.com, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
References: <19184.41676.262206.134000@gargle.gargle.HOWL> <20091104110321.5e58e112@jbarnes-piketon>
In-Reply-To: <20091104110321.5e58e112@jbarnes-piketon>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911041628.17905.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 November 2009 12:03:21 pm Jesse Barnes wrote:
> [Cc'ing linux-pci@vger.kernel.org too]
> 
> On Tue, 3 Nov 2009 16:38:20 -0500
> RDH <rdh@east.sun.com> wrote:
> 
> > 
> > This patch avoids unnecessary PCIe link retraining sequences within
> > the PCIe ASPM common clock setup code by issuing a link retrain
> > command only if we are actually changing the PCIe clock configuration.
> > 
> > Signed-off-by: Robert D. Houk <rdh@East.Sun.COM>
> > ---
> >  aspm.c |   20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> > --- a/drivers/pci/pcie/aspm.c	2009-10-15 20:41:50.000000000
> > -0400 +++ b/drivers/pci/pcie/aspm.c	2009-11-02
> > 14:29:35.000000000 -0500 @@ -183,6 +183,7 @@ static void
> > pcie_aspm_configure_common_c {
> >  	int ppos, cpos, same_clock = 1;
> >  	u16 reg16, parent_reg, child_reg[8];
> > +	u16 lnkctl_ccc_or, lnkctl_ccc_and;
> >  	unsigned long start_jiffies;
> >  	struct pci_dev *child, *parent = link->pdev;
> >  	struct pci_bus *linkbus = parent->subordinate;
> > @@ -205,6 +206,25 @@ static void pcie_aspm_configure_common_c
> >  	if (!(reg16 & PCI_EXP_LNKSTA_SLC))
> >  		same_clock = 0;
> >  
> > +	/* Check upstream component for Common Clock Config */
> > +	pci_read_config_word(parent, ppos + PCI_EXP_LNKCTL, &reg16);
> > +	lnkctl_ccc_and = lnkctl_ccc_or = (reg16 &
> > PCI_EXP_LNKCTL_CCC); +
> > +	/* Scan downstream component for CCC, all functions */
> > +	list_for_each_entry(child, &linkbus->devices, bus_list) {
> > +		cpos = pci_find_capability(child, PCI_CAP_ID_EXP);

Some other places in pcie/aspm (e.g., pcie_set_clkpm_nocheck() and
pcie_clkpm_cap_init()) check cpos for NULL.  Your code looks
superficially similar, so maybe you should check it, too, although
I do see many other place in aspm where we *don't* check it.

We look up this capability so often, I wonder if we should save it
in the struct pci_dev or struct pcie_link or something in such a
way that if we have a struct pcie_link, we are guaranteed that there
is a PCIe capability, and we don't have to search for it again.

Bjorn
