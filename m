Return-Path: <linux-kernel-owner+w=401wt.eu-S1767494AbXEDLL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767494AbXEDLL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 07:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767567AbXEDLL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 07:11:28 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49520 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767494AbXEDLL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 07:11:26 -0400
Date: Fri, 4 May 2007 12:11:25 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, Kristian H??gsberg <krh@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/6] firewire: OHCI-1394 lowlevel driver
Message-ID: <20070504111125.GA3028@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	linux-kernel@vger.kernel.org, Kristian H??gsberg <krh@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux1394-devel <linux1394-devel@lists.sourceforge.net>
References: <4637A29F.6070302@redhat.com> <20070502090007.GA28174@infradead.org> <tkrat.087ee29add656926@s5r6.in-berlin.de> <tkrat.350cb4dfe522266e@s5r6.in-berlin.de> <tkrat.65aea95f1451c211@s5r6.in-berlin.de> <tkrat.2aa3f3ac11a3d60d@s5r6.in-berlin.de> <tkrat.a41f7f10d21d3cc4@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tkrat.a41f7f10d21d3cc4@s5r6.in-berlin.de>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +/* ---------- pci subsystem interface ---------- */
> +
> +enum {
> +	CLEANUP_SELF_ID,
> +	CLEANUP_REGISTERS,
> +	CLEANUP_IOMEM,
> +	CLEANUP_DISABLE,
> +	CLEANUP_PUT_CARD,
> +};
> +
> +static int cleanup(struct fw_ohci *ohci, int stage, int code)
> +{
> +	struct pci_dev *dev = to_pci_dev(ohci->card.device);
> +
> +	switch (stage) {
> +	case CLEANUP_SELF_ID:
> +		dma_free_coherent(ohci->card.device, SELF_ID_BUF_SIZE,
> +				  ohci->self_id_cpu, ohci->self_id_bus);
> +	case CLEANUP_REGISTERS:
> +		kfree(ohci->it_context_list);
> +		kfree(ohci->ir_context_list);
> +		pci_iounmap(dev, ohci->registers);
> +	case CLEANUP_IOMEM:
> +		pci_release_region(dev, 0);
> +	case CLEANUP_DISABLE:
> +		pci_disable_device(dev);
> +	case CLEANUP_PUT_CARD:
> +		fw_card_put(&ohci->card);
> +	}
> +
> +	return code;
> +}
> +
> +static int __devinit
> +pci_probe(struct pci_dev *dev, const struct pci_device_id *ent)
> +{
> +	struct fw_ohci *ohci;
> +	u32 bus_options, max_receive, link_speed;
> +	u64 guid;
> +	int error_code;
> +	size_t size;
> +
> +	ohci = kzalloc(sizeof *ohci, GFP_KERNEL);
> +	if (ohci == NULL) {
> +		fw_error("Could not malloc fw_ohci data.\n");
> +		return -ENOMEM;
> +	}
> +
> +	fw_card_initialize(&ohci->card, &ohci_driver, &dev->dev);
> +
> +	if (pci_enable_device(dev)) {
> +		fw_error("Failed to enable OHCI hardware.\n");
> +		return cleanup(ohci, CLEANUP_PUT_CARD, -ENODEV);

Please use normal goto unwinding so the driver follows the same model
as almost all other pci drivers and allows people to follow your driver
more easily.  Also it's not a alot of cleanup code, so removing this
might actually be a net decrease in lines of code.

> +	if (software_reset(ohci)) {

Please give all your function a nice prefix so that oops messages are
more readable.

