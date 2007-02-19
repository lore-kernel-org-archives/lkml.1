Return-Path: <linux-kernel-owner+w=401wt.eu-S932072AbXBSK73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072AbXBSK73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 05:59:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932074AbXBSK73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 05:59:29 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55008 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072AbXBSK72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 05:59:28 -0500
Date: Mon, 19 Feb 2007 10:59:27 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: Re: [PATCH 06/44 take 2] [UBI] startup code
Message-ID: <20070219105927.GB16930@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Artem Bityutskiy <dedekind@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Frank Haverkamp <haver@vnet.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	David Woodhouse <dwmw2@infradead.org>,
	Josh Boyer <jwboyer@linux.vnet.ibm.com>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <20070217165454.5845.30875.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070217165454.5845.30875.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 06:54:54PM +0200, Artem Bityutskiy wrote:
> +/* UBI headers must take 64 bytes. The below is a hacky way to ensure this */
> +static int __ubi_check_ec_hdr_size[(UBI_EC_HDR_SIZE == 64) - 1]
> +    __attribute__ ((__unused__));
> +static int __ubi_check_ec_hdr_size[(UBI_VID_HDR_SIZE == 64) - 1]
> +    __attribute__ ((__unused__));

please use BUILD_BUG_ON instead.

> +
> +static int ubi_attach_mtd_dev(const char *mtd_dev, int vid_hdr_offset,
> +			      int data_offset);
> +static void ubi_destroy_dev(int ubi_num);

Can you reorder the code to avoid all these forward declarations please?

> +	/* Attach MTD devices */
> +	for (i = 0; i < mtd_devs; i++) {
> +		struct mtd_dev_param *p = &mtd_dev_param[i];
> +
> +		cond_resched();
> +		err = -EINVAL;

This looks very odd.

> +module_param_call(mtd, ubi_mtd_param_parse, NULL, NULL, 000);
> +MODULE_PARM_DESC(mtd, "MTD devices to attach. Parameter format: "
> +		      "mtd=<name|num>[,<vid_hdr_offs>,<data_offs>]. "
> +		      "Multiple \"mtd\" parameters may be specified.\n"
> +		      "MTD devices may be specified by their number or name. "
> +		      "Optional \"vid_hdr_offs\" and \"data_offs\" parameters "
> +		      "specify UBI VID header position and data starting "
> +		      "position to be used by UBI.\n"
> +		      "Example: mtd=content,1984,2048 mtd=4 - attach MTD device"
> +		      "with name content using VID header offset 1984 and data "
> +		      "start 2048, and MTD device number 4 using default "
> +		      "offsets");

This is a very odd paramater interface.  We really don't want drivers to use
module_param_call directly.  You probably want various module_param_array calls
instead.
