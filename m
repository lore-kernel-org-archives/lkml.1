Return-Path: <linux-kernel-owner+w=401wt.eu-S1752620AbZCVKWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbZCVKWr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 06:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbZCVKWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 06:22:35 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:58616 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbZCVKWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 06:22:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Zb++I4Svt4JkAwyebZN6scDPPNDlrW9RBQ0+i6I9MhgxfjaaBnRp9C3+1zvJbnRAxU
         wgntuI807xUw8q363Bh71Sijwm0idhsvI++l7YKC0egzZZMh5u7ICd3DxaetSdDYWtZX
         7qLtVUgP1hmU6toOIDYrTk5LgqU2oqUOOz2To=
Message-ID: <49C61157.6070604@gmail.com>
Date: Sun, 22 Mar 2009 11:22:15 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 4/8] exofs: address_space_operations
References: <49C1331D.1080805@panasas.com> <1237399473-29344-1-git-send-email-bharrosh@panasas.com>
In-Reply-To: <1237399473-29344-1-git-send-email-bharrosh@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
> (...)
> +struct page_collect {
> +	struct exofs_sb_info *sbi;
> +	struct request_queue *req_q;
> +	struct inode *inode;
> +	unsigned expected_pages;
> +
> +	struct bio *bio;
> +	unsigned nr_pages;
> +	unsigned long length;
> +	long pg_first;
> +};
> (...)
> +int pcol_try_alloc(struct page_collect *pcol)
> +{
> +	int pages = min_t(unsigned, pcol->expected_pages, BIO_MAX_PAGES);
> +
> +	for (; pages; pages >>= 1) {
> +		pcol->bio = bio_alloc(GFP_KERNEL, pages);
> +		if (likely(pcol->bio))
> +			return 0;
> +	}
> +
> +	EXOFS_ERR("Failed to kcalloc expected_pages=%d\n",

%u

> +		  pcol->expected_pages);
> +	return -ENOMEM;
> +}
> +
> (...)
> +static int __readpages_done(struct osd_request *or, struct page_collect *pcol,
> +			    bool do_unlock)
> +{
> +	struct bio_vec *bvec;
> +	int i;
> +	u64 resid;
> +	u64 good_bytes;
> +	u64 length = 0;
> +	int ret = exofs_check_ok_resid(or, &resid, NULL);
> +
> +	osd_end_request(or);
> +
> +	if (!ret)
> +		good_bytes = pcol->length;
> +	else if (ret && !resid)
> +		good_bytes = 0;
> +	else
> +		good_bytes = pcol->length - resid;

Second ret check is not needed.

> (...)
> +
> +int read_exec(struct page_collect *pcol, bool is_sync)

read_exec is too generic name for globally visible symbol

> +{
> (...)
> +static void writepages_done(struct osd_request *or, void *p)
> +{
> +	struct page_collect *pcol = p;
> +	struct bio_vec *bvec;
> +	int i;
> +	u64 resid;
> +	u64  good_bytes;
> +	u64  length = 0;
> +
> +	int ret = exofs_check_ok_resid(or, NULL, &resid);
> +
> +	osd_end_request(or);
> +	atomic_dec(&pcol->sbi->s_curr_pending);
> +
> +	if (likely(!ret))
> +		good_bytes = pcol->length;
> +	else if (ret && !resid)
> +		good_bytes = 0;
> +	else
> +		good_bytes = pcol->length - resid;

Ret check again.

> (...)
> +
> +int write_exec(struct page_collect *pcol)

Too generic name.

> (...)

