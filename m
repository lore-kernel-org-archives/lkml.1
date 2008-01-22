Return-Path: <linux-kernel-owner+w=401wt.eu-S1759479AbYAVJTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759479AbYAVJTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 04:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755576AbYAVJSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 04:18:43 -0500
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:53683 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755048AbYAVJSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 04:18:42 -0500
Date: Tue, 22 Jan 2008 09:18:34 +0000
From: Ben Dooks <ben@fluff.org>
To: Corey Minyard <minyard@acm.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, hvr@gnu.org,
       rmk@arm.linux.org.uk, nico@cam.org
Subject: Re: [PATCH] ARM: Ignore memory tags with invalid data
Message-ID: <20080122091834.GC27399@fluff.org.uk>
References: <20080122040556.GA24515@minyard.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080122040556.GA24515@minyard.local>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2008 at 10:05:56PM -0600, Corey Minyard wrote:
> From: Corey Minyard <minyard@acm.org>
> 
> The DNS-323 system has several bogus memory entries in the tag table,
> and it caused the system to crash at startup.  Ignore tag entries that
> are obviously bogus.

This should have gone to the linux-arm-kernel mailing list as well,
so that all the people interested in ARM can see it as soon as
possible. See linux-arm-kernel@lists.arm.linux.org.uk

The only suggestion I could think of would to be change to having
an check_tag_mem32() function, or put each check on its own line
to make it easier to read what each check is doing.

ie:
	if (meminfo.nr_banks >= NR_BANKS ||
	    tag->u.mem.size & ~PAGE_MASK || /* size is unaligned */
	    tag->u.mem.size == 0 ||	    /* no memory here */
	    tag->u.mem.start & ~PAGE_MASK)  /* start is unaligned */ 
	{

(even without the comments it makes it easier to see what each test
is.
 
> Signed-off-by: Corey Minyard <minyard@acm.org>
> ---
>  arch/arm/kernel/setup.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> index bf56eb3..dfdb469 100644
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -630,7 +630,12 @@ __tagtable(ATAG_CORE, parse_tag_core);
>  
>  static int __init parse_tag_mem32(const struct tag *tag)
>  {
> -	if (meminfo.nr_banks >= NR_BANKS) {
> +	/*
> +	 * Make sure that the memory size is non-zero, page aligned,
> +	 * and that it doesn't overflow the meminfo table.
> +	 */
> +	if (meminfo.nr_banks >= NR_BANKS || tag->u.mem.size & ~PAGE_MASK ||
> +	    tag->u.mem.size == 0 || tag->u.mem.start & ~PAGE_MASK) {
>  		printk(KERN_WARNING
>  		       "Ignoring memory bank 0x%08x size %dKB\n",
>  			tag->u.mem.start, tag->u.mem.size / 1024);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
