Return-Path: <linux-kernel-owner+w=401wt.eu-S932083AbXBSLFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083AbXBSLFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 06:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932082AbXBSLFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 06:05:45 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53959 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083AbXBSLFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 06:05:44 -0500
Date: Mon, 19 Feb 2007 11:05:43 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: Re: [PATCH 16/44 take 2] [UBI] scanning unit implementation
Message-ID: <20070219110543.GE16930@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Artem Bityutskiy <dedekind@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Frank Haverkamp <haver@vnet.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	David Woodhouse <dwmw2@infradead.org>,
	Josh Boyer <jwboyer@linux.vnet.ibm.com>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <20070217165545.5845.27214.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070217165545.5845.27214.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +	for (pnum = 0; pnum < io->peb_count; pnum++) {
> +		cond_resched();
> +
> +		err = process_eb(ubi, si, pnum);
> +		if (unlikely(err < 0))
> +			goto out_vidh;
> +	}

> +	rb_for_each_entry(rb1, sv, &si->volumes, rb) {
> +		cond_resched();
> +		rb_for_each_entry(rb2, seb, &sv->root, u.rb)
> +			if (seb->ec == NAND_SCAN_UNKNOWN_EC)
> +				seb->ec = si->mean_ec;
> +	}
> +
> +	cond_resched();
> +	list_for_each_entry(seb, &si->free, u.list)
> +		if (seb->ec == NAND_SCAN_UNKNOWN_EC)
> +			seb->ec = si->mean_ec;
> +
> +	cond_resched();
> +	list_for_each_entry(seb, &si->corr, u.list)
> +		if (seb->ec == NAND_SCAN_UNKNOWN_EC)
> +			seb->ec = si->mean_ec;
> +
> +	cond_resched();
> +	list_for_each_entry(seb, &si->erase, u.list)
> +		if (seb->ec == NAND_SCAN_UNKNOWN_EC)
> +			seb->ec = si->mean_ec;

You really shouldn't need random cond_resched all over the place.

> +static int vid_hdr_sanity_check(const struct ubi_info *ubi,
> +				const struct ubi_vid_hdr *vid_hdr,
> +				const struct ubi_scan_volume *sv, int pnum);
> +
> +static int add_to_erase(struct ubi_scan_info *si, int pnum, int ec);
> +
> +static struct ubi_scan_volume *add_volume(const struct ubi_info *ubi,
> +					  struct ubi_scan_info *si, int vol_id,
> +					  int pnum,
> +					  const struct ubi_vid_hdr *vid_hdr);
> +
> +static int compare_lebs(const struct ubi_info *ubi,
> +			const struct ubi_scan_leb *seb, int pnum,
> +			const struct ubi_vid_hdr *vid_hdr);

forward declarations in the middle of the file are really annoying.  Please try
to reorder the code to not need them at all if needed, and if needed add them
to the top of the file.

> +void ubi_scan_destroy_si(struct ubi_scan_info *si)
> +{
> +	struct ubi_scan_leb *seb, *seb_tmp;
> +	struct ubi_scan_volume *sv;
> +	struct rb_node *rb;
> +
> +	list_for_each_entry_safe(seb, seb_tmp, &si->alien, u.list) {
> +		list_del(&seb->u.list);
> +		ubi_free_scan_leb(seb);
> +	}

no locking needed here?

