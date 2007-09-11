Return-Path: <linux-kernel-owner+w=401wt.eu-S932258AbXIKSre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258AbXIKSre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 14:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762573AbXIKSrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 14:47:25 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:40932 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762151AbXIKSrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 14:47:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=RX0MeBx6ZE6FMJa8Sjn+KfrmRoptNB67qqzuoSQXgVyKadcRxDDZZieHpotW3U3BnRRHW5DiDzkRL915O0bF6iRWZFDyHCO4cK12Qdd1L5d7E1NUH3Kle2V578CazaJQQfc+eQWJEvNaXAELkbMcBVb7yla51bupderxqOKM0kk=  ;
X-YMail-OSG: i3JQajMVM1n7aB7rCtpz9cWjCBhjqkWi_mBY50Qjk_75aaD27wKQP_2Kw4yYpNeNRDbV4i2ZIg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Date: Tue, 11 Sep 2007 13:05:45 +1000
User-Agent: KMail/1.9.5
Cc: Mel Gorman <mel@csn.ul.ie>, Andrea Arcangeli <andrea@suse.de>,
       Christoph Lameter <clameter@sgi.com>, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
References: <20070911060349.993975297@sgi.com> <200709111226.06728.nickpiggin@yahoo.com.au> <200709112125.44188.maximlevitsky@gmail.com>
In-Reply-To: <200709112125.44188.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709111305.46094.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 September 2007 04:25, Maxim Levitsky wrote:

> Hi,
>
> I think that fundamental problem is no fragmentation/large pages/...
>
> The problem is the VM itself.
> The vm doesn't use virtual memory, thats all, that the problem.
> Although this will be probably linux 3.0, I think that the right way to
> solve all those problems is to make all kernel memory vmalloced (except few
> areas like kernel .text)
>
> It will suddenly remove the buddy allocator, it will remove need for
> highmem, it will allow to allocate any amount of memory (for example 4k
> stacks will be obsolete)
> It will even allow kernel memory to be swapped to disk.
>
> This is the solution, but it is very very hard.

I'm not sure that it is too hard. OK it is far from trivial...

This is not a new idea though, it has been floated around for a long
time (since before Linux I'm sure, although have no references).

There are lots of reasons why such an approach has fundamental
performance problems too, however. Your kernel can't use huge tlbs
for a lot of memory, you can't find the physical address of a page
without walking page tables, defragmenting still has a significant
cost in terms of moving pages and flushing TLBs etc.

So the train of thought up to now has been that a virtually mapped
kernel would be "the problem with the VM itself" ;)

We're actually at a point now where higher order allocations are
pretty rare and not a big problem (except with very special cases
like hugepages and memory hotplug which can mostly get away
with compromises, so we don't want to turn over the kernel just
for these).

So in my opinion, any increase of the dependence on higher order
allocations is simply a bad move until a killer use-case can be found.
They move us further away from good behaviour on our assumed
ideal of an identity mapped kernel.

(I don't actually dislike the idea of virtually mapped kernel. Maybe
hardware trends will favour that model and there are some potential
simple instructions a CPU can implement to help with some of the
performance hits. I'm sure it will be looked at again for Linux one day)
