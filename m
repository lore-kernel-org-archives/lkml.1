Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbYIJTtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbYIJTtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 15:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbYIJTtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 15:49:42 -0400
Received: from serrano.cc.columbia.edu ([128.59.29.6]:49697 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbYIJTtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 15:49:42 -0400
Message-ID: <48C824A2.8050708@cs.columbia.edu>
Date: Wed, 10 Sep 2008 15:48:50 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: containers@lists.linux-foundation.org, jeremy@goop.org,
       linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [RFC v4][PATCH 5/9] Memory managemnet (restore)
References: <1220946154-15174-1-git-send-email-orenl@cs.columbia.edu>	 <1220946154-15174-6-git-send-email-orenl@cs.columbia.edu> <1221075083.6781.34.camel@nimitz>
In-Reply-To: <1221075083.6781.34.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dave Hansen wrote:
> On Tue, 2008-09-09 at 03:42 -0400, Oren Laadan wrote:
>> +/**
>> + * cr_vma_read_pages_vaddrs - read addresses of pages to page-array chain
>> + * @ctx - restart context
>> + * @npages - number of pages
>> + */
>> +static int cr_vma_read_pages_vaddrs(struct cr_ctx *ctx, int npages)
>> +{
>> +	struct cr_pgarr *pgarr;
>> +	int nr, ret;
>> +
>> +	while (npages) {
>> +		pgarr = cr_pgarr_prep(ctx);
>> +		if (!pgarr)
>> +			return -ENOMEM;
>> +		nr = min(npages, (int) pgarr->nr_free);
>> +		ret = cr_kread(ctx, pgarr->vaddrs, nr * sizeof(unsigned long));
>> +		if (ret < 0)
>> +			return ret;
>> +		pgarr->nr_free -= nr;
>> +		pgarr->nr_used += nr;
>> +		npages -= nr;
>> +	}
>> +	return 0;
>> +}
> 
> cr_pgarr_prep() can return a partially full pgarr, right?  Won't the
> cr_kread() always start at the beginning of the pgarr->vaddrs[] array?
> Seems to me like it will clobber things from the last call.

Note that 'nr' is either equal to ->nr_free - in which case we consume
the entire 'pgarr' vaddr array such that the next call to cr_pgarr_prep()
will get a fresh one, or is smaller than ->nr_free - in which case that
is the last iteration of the loop anyhow, so it won't be clobbered.

Also, after we return - our caller, cr_vma_read_pages(), resets the state
of the page-array chain by calling cr_pgarr_reset().

Oren.
