Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088AbZCVKnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbZCVKnF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 06:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbZCVKmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 06:42:50 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:16782 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752102AbZCVKmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 06:42:50 -0400
Message-ID: <49C615D3.2020603@panasas.com>
Date: Sun, 22 Mar 2009 12:41:23 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 4/8] exofs: address_space_operations
References: <49C1331D.1080805@panasas.com> <1237399473-29344-1-git-send-email-bharrosh@panasas.com> <49C61157.6070604@gmail.com>
In-Reply-To: <49C61157.6070604@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Mar 2009 10:42:46.0986 (UTC) FILETIME=[F06A4AA0:01C9AADA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcin Slusarz wrote:
> Boaz Harrosh wrote:
>> (...)
>> +struct page_collect {
>> +	struct exofs_sb_info *sbi;
>> +	struct request_queue *req_q;
>> +	struct inode *inode;
>> +	unsigned expected_pages;
>> +
>> +	struct bio *bio;
>> +	unsigned nr_pages;
>> +	unsigned long length;
>> +	long pg_first;
>> +};
>> (...)
>> +int pcol_try_alloc(struct page_collect *pcol)
>> +{
>> +	int pages = min_t(unsigned, pcol->expected_pages, BIO_MAX_PAGES);
>> +
>> +	for (; pages; pages >>= 1) {
>> +		pcol->bio = bio_alloc(GFP_KERNEL, pages);
>> +		if (likely(pcol->bio))
>> +			return 0;
>> +	}
>> +
>> +	EXOFS_ERR("Failed to kcalloc expected_pages=%d\n",
> 
> %u
> 
>> +		  pcol->expected_pages);
>> +	return -ENOMEM;
>> +}
>> +
>> (...)
>> +static int __readpages_done(struct osd_request *or, struct page_collect *pcol,
>> +			    bool do_unlock)
>> +{
>> +	struct bio_vec *bvec;
>> +	int i;
>> +	u64 resid;
>> +	u64 good_bytes;
>> +	u64 length = 0;
>> +	int ret = exofs_check_ok_resid(or, &resid, NULL);
>> +
>> +	osd_end_request(or);
>> +
>> +	if (!ret)
>> +		good_bytes = pcol->length;
>> +	else if (ret && !resid)
>> +		good_bytes = 0;
>> +	else
>> +		good_bytes = pcol->length - resid;
> 
> Second ret check is not needed.
> 
>> (...)
>> +
>> +int read_exec(struct page_collect *pcol, bool is_sync)
> 
> read_exec is too generic name for globally visible symbol
> 
>> +{
>> (...)
>> +static void writepages_done(struct osd_request *or, void *p)
>> +{
>> +	struct page_collect *pcol = p;
>> +	struct bio_vec *bvec;
>> +	int i;
>> +	u64 resid;
>> +	u64  good_bytes;
>> +	u64  length = 0;
>> +
>> +	int ret = exofs_check_ok_resid(or, NULL, &resid);
>> +
>> +	osd_end_request(or);
>> +	atomic_dec(&pcol->sbi->s_curr_pending);
>> +
>> +	if (likely(!ret))
>> +		good_bytes = pcol->length;
>> +	else if (ret && !resid)
>> +		good_bytes = 0;
>> +	else
>> +		good_bytes = pcol->length - resid;
> 
> Ret check again.
> 
>> (...)
>> +
>> +int write_exec(struct page_collect *pcol)
> 
> Too generic name.
> 
>> (...)
> 

Right on all accounts. Thanks
will repost

Boaz

