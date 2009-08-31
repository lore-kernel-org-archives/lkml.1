Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbZHaRWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbZHaRWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 13:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbZHaRWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 13:22:36 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:44603 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbZHaRWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 13:22:35 -0400
Message-ID: <4A9C06B2.3040009@vflare.org>
Date: Mon, 31 Aug 2009 22:51:54 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] swap: Fix swap size in case of block devices
References: <200908302149.10981.ngupta@vflare.org> <Pine.LNX.4.64.0908311151190.16326@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0908311151190.16326@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2009 04:57 PM, Hugh Dickins wrote:
> On Sun, 30 Aug 2009, Nitin Gupta wrote:
>
>> During swapon, swap size is set to number of usable pages in the given
>> swap file/block device minus 1 (for header page). In case of block devices,
>> this size is incorrectly set as one page less than the actual due to an
>> off-by-one error. For regular files, this size is set correctly.
>>
>> Signed-off-by: Nitin Gupta<ngupta@vflare.org>
>
> I agree that there's an off-by-one disagreement between swapon and mkswap
> regarding last_page.  The kernel seems to interpret it as the index of
> what I'd call the end page, the first page beyond the swap area.
>
> I'd never noticed that until the beginning of this year, and out of
> caution I've done nothing about it.  I believe that the kernel has
> been wrong since Linux 2.2.? or 2.3.?, ever since swap header version 1
> was first introduced; and that mkswap has set it the same way all along.
>
> But I've not spent time on the research to establish that for sure.
>
> What if there used to be a version of mkswap which set last_page one
> greater as the kernel expects?  Neither Karel nor I think that's the
> case, but we're not absolutely certain.  And what if (I suppose I'm
> getting even more wildly cautious here!) someone has learnt that
> that page remains untouched and is now putting it to other use?
> or has compensated for the off-by-one and is setting it one greater,
> beyond the end of the partition, not using mkswap?
>

All this regarding mkswap is even more unlikely considering that for
regular files, kernel uses last page too (details below). Only for block
devices, we leave last page unused due to this bug.


> Since nobody has been hurt by it in all these years, I felt safer
> to go on leaving that discrepancy as is.  Call me over cautious.
>
> Regarding your patch comment: I'm puzzled by the remark "For regular
> files, this size is set correctly".  Do you mean that mkswap is
> setting last_page one higher when dealing with a regular file rather
> than a block device (I was unaware of that, but never looked to see)?
> But your patch appears to be to code shared equally between block
> devices and regular files, so then you'd be introducing a bug on
> regular files?  And shouldn't mkswap be fixed to be consistent
> with itself?  Hopefully I've misunderstood: please explain further.
>

mkswap sets last_page correctly: 0-based index of last usable
swap page. To explain why this bug affects only block swap devices,
some code walkthrough is done below:
(BTW, I only checked mkswap which is part of util-linux-ng 2.14.2).

swapon()
{
  ...
         nr_good_pages = swap_header->info.last_page -
                         swap_header->info.nr_badpages -
                         1 /* header page */;

====
	off-by-one error: for both regular and block device case, but...
====

         if (nr_good_pages) {
                 swap_map[0] = SWAP_MAP_BAD;
                 p->max = maxpages;
                 p->pages = nr_good_pages;
                 nr_extents = setup_swap_extents(p, &span);
====
For block devices, setup_swap_extents() leaves p->pages untouched.
For regular files, it sets p->pages
	== total usable swap pages (including header page) - 1;
====
                 if (nr_extents < 0) {
                         error = nr_extents;
                         goto bad_swap;
                 }
                 nr_good_pages = p->pages;

====
So, for block device, nr_good_pages == last_page - nr_badpages - 1
				== (total pages - 1) - nr_badpages - 1 (error)
			
For regular files, nr_good_pages == total pages - 1 (correct)
====

         }
...
}


With this fix, block device case is corrected to last_page - nr_badpages - 1
while regular file case remain correct since setup_swap_extents() still gives
same correct value in p->pages (== total pages - 1).


> And regarding the patch itself: my understanding is that the problem
> is with the interpretation of last_page, so I don't think one change
> to nr_good_pages would be enough to fix it - you'd need to change the
> other places where last_page is referred to too.
>

I looked at other instances of last_page in swapon() -- all these other
instances looked correct to me.

> I'm still disinclined to make any change here myself (beyond
> a comment noting the discrepancy); but tell me I'm a fool.
>

I agree that nobody would bother losing 1 swap slot, so it might
not be desirable to have this fix. But IMHO, I don't see any reason
to leave this discrepancy between regular files and swap devices -- its
just so odd.

Thanks for your detailed comments.

Regards,
Nitin
