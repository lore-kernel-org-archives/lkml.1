Return-Path: <linux-kernel-owner+w=401wt.eu-S1755200AbYHDNo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbYHDNo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 09:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbYHDNor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 09:44:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753596AbYHDNoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 09:44:46 -0400
Message-ID: <48970779.80902@linux-foundation.org>
Date: Mon, 04 Aug 2008 08:43:21 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, andi@firstfloor.org,
       Rik van Riel <riel@redhat.com>
Subject: Re: No, really, stop trying to delete slab until you've finished
 making slub perform as well
References: <20080801182324.572058187@lameter.com> <20080803015847.GD26461@parisc-linux.org>
In-Reply-To: <20080803015847.GD26461@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Fri, May 09, 2008 at 07:21:01PM -0700, Christoph Lameter wrote:
>> - Add a patch that obsoletes SLAB and explains why SLOB does not support
>>   defrag (Either of those could be theoretically equipped to support
>>   slab defrag in some way but it seems that Andrew/Linus want to reduce
>>   the number of slab allocators).
> 
> Do we have to once again explain that slab still outperforms slub on at
> least one important benchmark?  I hope Nick Piggin finds time to finish
> tuning slqb; it already outperforms slub.
> 

Uhh. I forgot to delete that statement. I did not include the patch in the series.

We have a fundamental issue design issue there. Queuing on free can result in
better performance as in SLAB. However, it limits concurrency (per node lock
taking) and causes latency spikes due to queue processing (f.e. one test load
had 118.65 vs. 34 usecs just by switching to SLUB).

Could you address the performance issues in different ways? F.e. try to free
when the object is hot or free from multiple processors? SLAB has to take the
list_lock rather frequently under high concurrent loads (depends on queue
size). That will not occur with SLUB. So you actually can free (and allocate)
concurrently with high performance.
