Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbYCQPqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbYCQPqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 11:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbYCQPqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 11:46:00 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:51536 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbYCQPp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 11:45:59 -0400
Date: Mon, 17 Mar 2008 16:45:57 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, agk@redhat.com, jbrassow@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: + dm-raid1-bitops-bug.patch added to -mm tree
Message-ID: <20080317154557.GD6500@osiris.boeblingen.de.ibm.com>
References: <200802230732.m1N7Wdmr018088@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802230732.m1N7Wdmr018088@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: dm raid1: bitops bug
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Commit 8f0205b798f926e2745de5fdebf0a8605c621de6
> "dm raid1: handle recovery failures" introduces a test_bit on an
> integer. test_bit is only defined to do something useful on arrays
> of long. Remove the test_bit code and use hand coded test bit
> instead.
> 
> Cc: Jonathan Brassow <jbrassow@redhat.com>
> Cc: Alasdair G Kergon <agk@redhat.com>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/md/dm-raid1.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff -puN drivers/md/dm-raid1.c~dm-raid1-bitops-bug drivers/md/dm-raid1.c
> --- a/drivers/md/dm-raid1.c~dm-raid1-bitops-bug
> +++ a/drivers/md/dm-raid1.c
> @@ -758,7 +758,8 @@ static void recovery_complete(int read_e
>  {
>  	struct region *reg = (struct region *)context;
>  	struct mirror_set *ms = reg->rh->ms;
> -	int m, bit = 0;
> +	unsigned int mask = 1;
> +	int m;
> 
>  	if (read_err) {
>  		/* Read error means the failure of default mirror. */
> @@ -776,10 +777,10 @@ static void recovery_complete(int read_e
>  		for (m = 0; m < ms->nr_mirrors; m++) {
>  			if (&ms->mirror[m] == get_default_mirror(ms))
>  				continue;
> -			if (test_bit(bit, &write_err))
> +			if (write_err & mask)
>  				fail_mirror(ms->mirror + m,
>  					    DM_RAID1_SYNC_ERROR);
> -			bit++;
> +			mask <<= 1;
>  		}
>  	}

Could we have this patch or something similar in 2.6.25, please?
It's broken doing a test_bit() on an int since the result is random
whenever sizeof(int) != sizeof(long).
It might also lead to exceptions if an architecture requires a
sizeof(long) alignment for test_bit().
