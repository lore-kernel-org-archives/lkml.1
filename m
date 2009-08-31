Return-Path: <linux-kernel-owner+w=401wt.eu-S1754320AbZHaT07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbZHaT07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 15:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbZHaT06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 15:26:58 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:46257 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753708AbZHaT06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 15:26:58 -0400
X-Trace: 255534147/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.118.155/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.118.155
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEACPBm0pPRXab/2dsb2JhbACBU9gEhBoF
X-IronPort-AV: E=Sophos;i="4.44,306,1249254000"; 
   d="scan'208";a="255534147"
Date: Mon, 31 Aug 2009 20:26:22 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Nitin Gupta <ngupta@vflare.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] swap: Fix swap size in case of block devices
In-Reply-To: <4A9C06B2.3040009@vflare.org>
Message-ID: <Pine.LNX.4.64.0908311959460.13560@sister.anvils>
References: <200908302149.10981.ngupta@vflare.org>
 <Pine.LNX.4.64.0908311151190.16326@sister.anvils> <4A9C06B2.3040009@vflare.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Aug 2009, Nitin Gupta wrote:
> 
> mkswap sets last_page correctly: 0-based index of last usable
> swap page. To explain why this bug affects only block swap devices,
> some code walkthrough is done below:
> (BTW, I only checked mkswap which is part of util-linux-ng 2.14.2).
> 
> swapon()
> {
>  ...
>         nr_good_pages = swap_header->info.last_page -
>                         swap_header->info.nr_badpages -
>                         1 /* header page */;
> 
> ====
> 	off-by-one error: for both regular and block device case, but...
> ====
> 
>         if (nr_good_pages) {
>                 swap_map[0] = SWAP_MAP_BAD;
>                 p->max = maxpages;
>                 p->pages = nr_good_pages;
>                 nr_extents = setup_swap_extents(p, &span);
> ====
> For block devices, setup_swap_extents() leaves p->pages untouched.
> For regular files, it sets p->pages
> 	== total usable swap pages (including header page) - 1;

I think you're overlooking the "page < sis->max" condition
in setup_swap_extents()'s loop.  So at the end of the loop,
if no pages were lost to fragmentation, we have

		sis->max = page_no;		/* no change */
		sis->pages = page_no - 1;	/* no change */

> ====
>                 if (nr_extents < 0) {
>                         error = nr_extents;
>                         goto bad_swap;
>                 }
>                 nr_good_pages = p->pages;
> 
> ====
> So, for block device, nr_good_pages == last_page - nr_badpages - 1
> 				== (total pages - 1) - nr_badpages - 1 (error)
> 			For regular files, nr_good_pages == total pages - 1
> (correct)
> ====
> 
>         }
> ...
> }
> 
> 
> With this fix, block device case is corrected to last_page - nr_badpages - 1
> while regular file case remain correct since setup_swap_extents() still gives
> same correct value in p->pages (== total pages - 1).
> 
> 
> > And regarding the patch itself: my understanding is that the problem
> > is with the interpretation of last_page, so I don't think one change
> > to nr_good_pages would be enough to fix it - you'd need to change the
> > other places where last_page is referred to too.
> >
> 
> I looked at other instances of last_page in swapon() -- all these other
> instances looked correct to me.

I believe they're all consistent with the off-by-oneness of nr_good_pages.
p->max, for example, is consistently one more than p->pages, so long as
there are no bad pages and no overflowing the swp_entry_t.

Perhaps you're placing too much faith in your interpretation of "max"?
I dislike several conventions in swapfile.c, it does lend itself to
off-by-oneness.

> 
> > I'm still disinclined to make any change here myself (beyond
> > a comment noting the discrepancy); but tell me I'm a fool.
> >
> 
> I agree that nobody would bother losing 1 swap slot, so it might
> not be desirable to have this fix. But IMHO, I don't see any reason
> to leave this discrepancy between regular files and swap devices -- its
> just so odd.

Yes, I'd dislike that discrepancy between regular files and block
devices, if I could see it.  Though I'd probably still be cautious
about the disk partitions.

dd if=/dev/zero of=/swap bs=200k	# says 204800 bytes (205kB)
mkswap /swap				# says size = 196 KiB
swapon /swap				# dmesg says Adding 192k swap

which is what I've come to expect from the off-by-one,
even on regular files.

Hugh
