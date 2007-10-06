Return-Path: <linux-kernel-owner+w=401wt.eu-S1763521AbXJFPK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763521AbXJFPK6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 11:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760302AbXJFPKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 11:10:39 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:47013 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760134AbXJFPKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 11:10:38 -0400
Date: Sat, 6 Oct 2007 16:10:26 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: ohyama_sec@ariel-networks.com
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]dose it make get_swap_page(mm/swapfiles.c) good performance
 ?, kernel<2.6.22.9>.
In-Reply-To: <20071006000403.DF6E2378020@ns.ariel-networks.com>
Message-ID: <Pine.LNX.4.64.0710061547350.4924@blonde.wat.veritas.com>
References: <20071006000403.DF6E2378020@ns.ariel-networks.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Oct 2007, ohyama_sec@ariel-networks.com wrote:
> -hiroyasu ohyama
> 
> I wonder what corrected attached source makes good performance of 
> getting page slot cluster from page area discripter which is written 
> "si" in the source codes.
> Because I think head of swap_list_t discripter doesn't suggest index of 
> swap area which is same priority that swap_list.next but one which is 
> the highest priority in the priority's list.
> the si->swap_map which have high priority may be chosen by 
> get_swap_page(), so that page slot of low priority's swap area may have 
> more blank cluster than one of hich priority's swap area.
> Then, I think substitute "swap_list.head" for "next" is privent them 
> from finding cluster of page slot when "swap_info[next].prio"'s priority 
> is different swap_list.next.

Thanks for making the suggestion.  I think you are right in what you
say, but that nevertheless we should not make the change you suggest.

The idea behind the swap priorities is that we use partitions or
swapfiles with high priorities before going to use those with lower
priorities.  That could be useful, for example, if the high priority
swap partitions are on fast disks, and the lower priority partitions
on slower disks, ones we'd really prefer to avoid using normally.

With your change, yes, once get_swap_page() fails to find a slot in
the last area at a particular priority, it will proceed to the next
lower priority: you're right that it'll probably find a swap cluster
there much more easily than by going back to the top priority as it
does; but that would then go against the priorities - get_swap_page()
itself would be quicker, but swap I/O would be slower (if those
priorities are indeed according to the speed of the disks).

To get the get_swap_page() speedup you want, simply add
more swap partitions or swapfiles at the _same_ priority.

Hugh

> *** mm/swapfile_bck.c   2007-10-04 12:09:37.000000000 +0900
> --- mm/swapfile.c       2007-10-04 12:31:34.000000000 +0900
> ***************
> *** 186,193 ****
>        for (type = swap_list.next; type >= 0 && wrapped < 2; type = next) {
>                si = swap_info + type;
>                next = si->next;
> !               if (next < 0 ||
> !                   (!wrapped && si->prio != swap_info[next].prio)) {
>                        next = swap_list.head;
>                        wrapped++;
>                }
> --- 186,192 ----
>        for (type = swap_list.next; type >= 0 && wrapped < 2; type = next) {
>                si = swap_info + type;
>                next = si->next;
> !               if (next < 0) {
>                        next = swap_list.head;
>                        wrapped++;
>                }
