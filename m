Return-Path: <linux-kernel-owner+w=401wt.eu-S1752752AbXJYQDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbXJYQDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 12:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbXJYQDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 12:03:34 -0400
Received: from sa15.bezeqint.net ([192.115.104.30]:59018 "EHLO
	sa15.bezeqint.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756544AbXJYQDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 12:03:33 -0400
Message-ID: <4720BE4D.1010100@panasas.com>
Date: Thu, 25 Oct 2007 18:03:25 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, Boaz Harrosh <bharrosh@panasas.com>,
       Jens Axboe <jens.axboe@oracle.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, mingo@elte.hu
Subject: Re: [PATCH 09/10] Change table chaining layout
References: <1193076664-13652-10-git-send-email-jens.axboe@oracle.com> <471DCBB2.9020706@panasas.com> <alpine.LFD.0.999.0710230808260.30120@woody.linux-foundation.org> <200710251840.02157.rusty@rustcorp.com.au> <alpine.LFD.0.999.0710250834390.30120@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710250834390.30120@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct. 25, 2007, 17:40 +0200, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> On Thu, 25 Oct 2007, Rusty Russell wrote:
>> On Wednesday 24 October 2007 01:22:55 Linus Torvalds wrote:
>>> Well, I'd personally actually prefer to *not* have the count be passed
>>> down explicitly, because it's just too error prone.
>> Well, the duplication is bad, but walking lists to find the length is
>> inefficient so you pass around the length as well.
> 
> Nobody should *ever* walk the list to find the length. Does anybody really 
> do that? Yes, we pass the thing down, but do people *need* it?
> 
> [ Side note: some of the users of that length currently would seem to be 
>   buggy in the presense of continuation entries, and seem to assume that 
>   the "list" is just a contiguous array. In fatc, that's almost the only 
>   valid use for the "count" thing, since any other use _has_ to walk it 
>   entry by entry anyway, no? ]
> 
> The thing is, nobody should care. You walk the list to fill things in, or 
> to write it out to some HW-specific DMA table, you should never care about 
> the length. However, you *do* care about the "where does it end" part: to 
> be able to detect overflows (which should never happen, but from a 
> debugging standpoint it needs to be detectable rather than just silently 
> use or corrupt memory).
> 
> But if people really want/need the length, then we damn well should have a 
> "header" thing, not two independent "list + length" parameters.

There are a number of indicators that need to be kept in sync, depending
on the usage.  The number of entries is set when it is allocated and is
currently needed to free it up (note that in the sgtable "sketch" James
proposed we saved the sg pool index in the sgtable header and used it to
free each chunk to the right pool).  The number of entries is then used in
many places to scan the list, however, after the sg list is dma mapped, the
dma mapping may be shorter than the original sg list when multiple pages are
coalesced and there we need to defer to use the dma_length (plus the number
of entries) to determine the end of the list.

IMO I think that the byte count can be used authoritatively to scan
the contents of the sg list either before or after dma mapping
while the number of entries is relevant to walking the list in a context free
manner (i.e. to go over all the entries that were allocated)

> 
> 			Linus
> -

