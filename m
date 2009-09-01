Return-Path: <linux-kernel-owner+w=401wt.eu-S1752892AbZIAHLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbZIAHLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 03:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbZIAHLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 03:11:32 -0400
Received: from mail-pz0-f175.google.com ([209.85.222.175]:51862 "EHLO
	mail-pz0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbZIAHLb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 03:11:31 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0908311959460.13560@sister.anvils>
References: <200908302149.10981.ngupta@vflare.org>
	 <Pine.LNX.4.64.0908311151190.16326@sister.anvils>
	 <4A9C06B2.3040009@vflare.org>
	 <Pine.LNX.4.64.0908311959460.13560@sister.anvils>
Date: Tue, 1 Sep 2009 12:41:33 +0530
Message-ID: <d760cf2d0909010011g75a918c0hedd4b2571afc054c@mail.gmail.com>
Subject: Re: [PATCH] swap: Fix swap size in case of block devices
From: Nitin Gupta <ngupta@vflare.org>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 1, 2009 at 12:56 AM, Hugh Dickins<hugh.dickins@tiscali.co.uk> wrote:
> On Mon, 31 Aug 2009, Nitin Gupta wrote:
>> For block devices, setup_swap_extents() leaves p->pages untouched.
>> For regular files, it sets p->pages
>>       == total usable swap pages (including header page) - 1;
>
> I think you're overlooking the "page < sis->max" condition
> in setup_swap_extents()'s loop.  So at the end of the loop,
> if no pages were lost to fragmentation, we have
>
>                sis->max = page_no;             /* no change */
>                sis->pages = page_no - 1;       /* no change */
>

Oh, I missed this loop condition. The variable naming is so bad, I
find it very hard to follow this part of code.

Still, if there is even a single page in swap file that is not usable
(i.e. non-contiguous on disk) -- which is what usually happens for swap
files of any practical size -- setup_swap_extents() gives correct value
in sis->pages == total usable pages (including header) - 1;

However, if all the file pages are usable, it gives off-by-one error, as
you noted.

> Yes, I'd dislike that discrepancy between regular files and block
> devices, if I could see it.  Though I'd probably still be cautious
> about the disk partitions.

> dd if=/dev/zero of=/swap bs=200k        # says 204800 bytes (205kB)
> mkswap /swap                            # says size = 196 KiB
> swapon /swap                            # dmesg says Adding 192k swap

> which is what I've come to expect from the off-by-one,
> even on regular files.

In general, its not correct to compare size repored by mkswap and
swapon like this. The size reported by mkswap includes pages which
are not contiguous on disk. While, kernel considers only
PAGE_SIZE-length, PAGE_SIZE-aligned contiguous run of blocks. So, size
reported by mkswap and swapon can vary wildly. For e.g.:

(on mtdram with ext2 fs)
dd if=/dev/zero of=swap.dd bs=1M count=10
mkswap swap.dd # says size = 10236 KiB
swapon swap.dd # says Adding 10112k swap

====

So, to summarize:

1. mkswap always behaves correctly: It sets number of pages in swap file
minus one as 'last_page' in swap header (since this is a 0-based index).
This same value (total pages - 1) is printed out as size since it knows
that first page is swap header.

2. swapon() for block devices: off-by-one error causing last swap page
to remain unused.

3. swapon() for regular files:
  3.1 off-by-one error if every swap page in this file is usable i.e.
      every PAGE_SIZE-length, PAGE_SIZE-aligned chunk is contiguous on
      disk.
  3.2 correct size value if there is at least one swap page which is
      unusable -- which is expected from swap file of any practical
      size.


I will go through swap code again to find other possible off-by-one
errors. The revised patch will fix these inconsistencies.

Thanks,
Nitin
