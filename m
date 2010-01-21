Return-Path: <linux-kernel-owner+w=401wt.eu-S1752539Ab0AUPPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab0AUPPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 10:15:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129Ab0AUPPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 10:15:49 -0500
Received: from smtp.nokia.com ([192.100.122.230]:50642 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab0AUPPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 10:15:49 -0500
Date: Thu, 21 Jan 2010 17:13:44 +0200
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH] mm: Fix nr_good_pages calculation
Message-ID: <20100121151344.GA31975@angel.research.nokia.com>
Reply-To: Jarkko Lavinen <jarkko.lavinen@nokia.com>
References: <20100120151912.GA27747@angel.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100120151912.GA27747@angel.research.nokia.com>
X-Operating-System: GNU/Linux angel.research.nokia.com
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 21 Jan 2010 15:13:47.0342 (UTC) FILETIME=[545576E0:01CA9AAC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc to Hugh added.

On Wed, Jan 20, 2010 at 05:19:12PM +0200, Jarkko Lavinen wrote:
> Swapon wastes one page of swap space to no effect.

Perhaps this last page newer used problem needs some more explanation.

On x86 example machine A, swap partition is 15631245 kB. /proc/swaps
says the swap space is 15631236 KB, 9 KB less than the partition size
or two page difference. One page for the swap header, and the other
for what ?

On another x86 macine B, swap partition is 409626 KB, /proc/swaps says
it is 409616 KB, 10 KB difference or two pages and alignment bytes.
Again I can understand the need for one header page, but not two.

However swapon system call intends to use all the space available
except the header.  This can be seen from swap_map allocation:

  SYSCALL_DEFINE2(swapon, ...
        ...			
	maxpages = swp_offset(pte_to_swp_entry(
			swp_entry_to_pte(swp_entry(0, ~0UL)))) - 1;
	if (maxpages > swap_header->info.last_page)
		maxpages = swap_header->info.last_page;
	p->highest_bit = maxpages - 1;
	...
	swap_map = vmalloc(maxpages);

This way the swap_map has entries for the whole swap space
except for the header.

Then the nr_good_pages could be calculted with:

-	nr_good_pages = swap_header->info.last_page -
-			swap_header->info.nr_badpages -
-			1 /* header page */;
+	nr_good_pages = maxpages - swap_header->info.nr_badpages;

This change corrects the last swap file page never used problem.
If the last_page is ever greater than maxpages, this would also avoid
setting nr_good_pages to too large value.

Jarkko Lacinen

