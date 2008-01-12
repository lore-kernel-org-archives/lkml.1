Return-Path: <linux-kernel-owner+w=401wt.eu-S1759261AbYALRqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261AbYALRqc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 12:46:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755090AbYALRqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 12:46:23 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49188 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbYALRqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 12:46:23 -0500
Date: Sat, 12 Jan 2008 09:45:57 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Greg KH <greg@kroah.com>, Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Tony Camuso <tcamuso@redhat.com>,
       Loic Prylli <loic@myri.com>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
Message-ID: <20080112094557.71f5382a@laptopd505.fenrus.org>
In-Reply-To: <20080112144030.GA19279@jurassic.park.msu.ru>
References: <alpine.LFD.1.00.0801111156230.3148@woody.linux-foundation.org>
	<20080111201716.GO18741@parisc-linux.org>
	<alpine.LFD.1.00.0801111224090.3148@woody.linux-foundation.org>
	<20080111204228.GP18741@parisc-linux.org>
	<alpine.LFD.1.00.0801111311170.3148@woody.linux-foundation.org>
	<20080111211753.GR18741@parisc-linux.org>
	<alpine.LFD.1.00.0801111326120.3148@woody.linux-foundation.org>
	<20080111213803.GS18741@parisc-linux.org>
	<20080111235856.GA16079@jurassic.park.msu.ru>
	<20080112002638.GA18710@kroah.com>
	<20080112144030.GA19279@jurassic.park.msu.ru>
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

On Sat, 12 Jan 2008 17:40:30 +0300
Ivan Kokshaysky <ink@jurassic.park.msu.ru> wrote:
> --- a/arch/x86/pci/mmconfig_32.c
> +++ b/arch/x86/pci/mmconfig_32.c
> @@ -30,10 +30,6 @@ static u32 get_base_addr(unsigned int seg, int
> bus, unsigned devfn) struct acpi_mcfg_allocation *cfg;
>  	int cfg_num;
>  
> -	if (seg == 0 && bus < PCI_MMCFG_MAX_CHECK_BUS &&
> -	    test_bit(PCI_SLOT(devfn) + 32*bus,
> pci_mmcfg_fallback_slots))
> -		return 0;
> -
>  	for (cfg_num = 0; cfg_num < pci_mmcfg_config_num; cfg_num++)
> { cfg = &pci_mmcfg_config[cfg_num];
>  		if (cfg->pci_segment == seg &&
> @@ -68,13 +64,16 @@ static int pci_mmcfg_read(unsigned int seg,
> unsigned int bus, u32 base;
>  
>  	if ((bus > 255) || (devfn > 255) || (reg > 4095)) {
> -		*value = -1;
> +err:		*value = -1;
>  		return -EINVAL;
>  	}
>  
> +	if (reg < 256)
> +		return pci_conf1_read(seg,bus,devfn,reg,len,value);
> +


btw this is my main objection to your patch; it intertwines the conf1 and mmconfig code even more.
When (and I'm saying "when" not "if") systems arrive that only have MMCONFIG for some of the devices,
we'll have to detangle this again, and I'm really not looking forward to that.
