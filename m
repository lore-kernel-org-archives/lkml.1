Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbYAMRCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbYAMRCB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 12:02:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbYAMRBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 12:01:53 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40503 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbYAMRBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 12:01:53 -0500
Date: Sun, 13 Jan 2008 09:01:08 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Martin Mares <mj@ucw.cz>, Tony Camuso <tcamuso@redhat.com>,
       Loic Prylli <loic@myri.com>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
Message-ID: <20080113090108.3224698c@laptopd505.fenrus.org>
In-Reply-To: <20080113072415.GB18741@parisc-linux.org>
References: <alpine.LFD.1.00.0801111224090.3148@woody.linux-foundation.org>
	<20080111204228.GP18741@parisc-linux.org>
	<alpine.LFD.1.00.0801111311170.3148@woody.linux-foundation.org>
	<20080111211753.GR18741@parisc-linux.org>
	<alpine.LFD.1.00.0801111326120.3148@woody.linux-foundation.org>
	<20080111213803.GS18741@parisc-linux.org>
	<20080111235856.GA16079@jurassic.park.msu.ru>
	<20080112002638.GA18710@kroah.com>
	<20080112144030.GA19279@jurassic.park.msu.ru>
	<1200208085.6896.134.camel@pasglop>
	<20080113072415.GB18741@parisc-linux.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

as a general thing I like where this patch is going

On Sun, 13 Jan 2008 00:24:15 -0700
Matthew Wilcox <matthew@wil.cx> wrote:
> +
> +int raw_pci_read(unsigned int domain, unsigned int bus, unsigned int
> devfn,
> +						int reg, int len,
> u32 *val) +{
> +	if (reg < 256)
> +		return raw_pci_ops->read(domain, bus, devfn, reg,
> len, val);
> +	if (raw_pci_ext_ops)
> +		return raw_pci_ext_ops->read(domain, bus, devfn,
> reg, len, val);
> +	return -EINVAL;

would be nice the "reg > 256 && raw_pci_Ext_ops==NULL" case would just
call the raw_pci_ops-> pointer, to give that a chance of refusal
(but I guess that shouldn't really happen)

> --- a/arch/x86/pci/mmconfig-shared.c
> +++ b/arch/x86/pci/mmconfig-shared.c
> @@ -28,7 +28,7 @@ static int __initdata pci_mmcfg_resources_inserted;
>  static const char __init *pci_mmcfg_e7520(void)
>  {
>  	u32 win;
> -	pci_conf1_read(0, 0, PCI_DEVFN(0,0), 0xce, 2, &win);
> +	pci_direct_conf1.read(0, 0, PCI_DEVFN(0,0), 0xce, 2, &win);

	couldn't this (at least in some next patch) use the vector if it exists?

\

> @@ -140,5 +134,6 @@ int __init pci_mmcfg_arch_init(void)
>  {
>  	printk(KERN_INFO "PCI: Using MMCONFIG\n");
>  	raw_pci_ops = &pci_mmcfg;
> +	raw_pci_ext_ops = &pci_mmcfg;

why set BOTH vectors? you probably ONLY want to set the ext one, so 
that calls to the lower 256 go to the original

