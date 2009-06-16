Return-Path: <linux-kernel-owner+w=401wt.eu-S1759435AbZFPPge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435AbZFPPge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 11:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbZFPPg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 11:36:27 -0400
Received: from mx.binnacle.cx ([74.95.187.105]:12684 "EHLO mx.binnacle.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186AbZFPPg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 11:36:26 -0400
Message-Id: <6.2.5.6.2.20090616111535.05b5e4b0@binnacle.cx>
X-Mailer: QUALCOMM Windows Eudora Version 6.2.5.6
Date: Tue, 16 Jun 2009 11:25:29 -0400
To: Mel Gorman <mel@csn.ul.ie>
From: starlight@binnacle.cx
Subject: Re: QUESTION: can netdev_alloc_skb() errors be reduced
  by tuning?
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       hugh.dickins@tiscali.co.uk, Lee.Schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com, ebmunson@us.ibm.com, agl@us.ibm.com,
       apw@canonical.com, wli@movementarian.org
In-Reply-To: <20090616091932.GB14241@csn.ul.ie>
References: <1243422749-6256-1-git-send-email-mel@csn.ul.ie>
 <20090527131437.5870e342.akpm@linux-foundation.org>
 <20090527231949.GB30002@elte.hu>
 <6.2.5.6.2.20090615201713.05b5d408@binnacle.cx>
 <20090616091932.GB14241@csn.ul.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 10:19 AM 6/16/2009 +0100, Mel Gorman wrote:

>Can you give an example of an allocation failure? Specifically, I want to
>see what sort of allocation it was and what order.

I think it's just the basic buffer allocation for
Ethernet frames arriving in the 'ixgbe' driver.  Seems
like it's one allocation per frame.  Per the original
message the allocations are made with the 'netdev_alloc_skb()'
kernel call.  The function where this code appears is
named 'ixgbe_alloc_rx_buffers()' and the comment is
"Replace used receive buffers."

The code path in question does not generate an error.  It just
increments the 'alloc_rx_buff_failed' counter for the ethX
device.  In addition it appears that the frame is dropped
only if the PCIe hardware ring-queue associated with each
interface is full.  So on the next interrupt the allocation
is retried and appears to be successful 99% of the time.

>For reliable protocols, an allocation failure should recover and the
>data get through but obviously there is a drop in network performance
>when this happens.

This is for a specialized high-volume UDP multicast application
where data loss of any kind is unacceptable.

>If the allocations are high-order and atomic, increasing min_free_kbytes
>can help, particularly in situations where there is a burst of network
>traffic. I won't know if they are atomic until I see an error message
>though.

Doesn't the use of 'netdev_alloc_skb()' kernel primitive
imply what the nature of the allocation is?  I followed the
call graph down into "kmem" land, but it's a complex place
and so I abandoned the review.

My impression is that 'min_free_kbytes' relates mainly to systems
where significant paging pressure exists.  The servers have zero
paging pressure and lots of free memory, though mostly in the
form of instantly discardable file data cache pages.  In the
past disabling the program that generates the cache pressure
has had no effect on data loss, though I haven't tried it in
relation this specific issue.

Tried increasing a few /proc/slabinfo tuneable parameters today
and this appears to have fixed the issue so far today.

