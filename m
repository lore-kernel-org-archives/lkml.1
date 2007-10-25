Return-Path: <linux-kernel-owner+w=401wt.eu-S1762221AbXJYPm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762221AbXJYPm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 11:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759588AbXJYPmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 11:42:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48928 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759025AbXJYPmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 11:42:39 -0400
Date: Thu, 25 Oct 2007 08:40:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <jens.axboe@oracle.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, mingo@elte.hu
Subject: Re: [PATCH 09/10] Change table chaining layout
In-Reply-To: <200710251840.02157.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.0.999.0710250834390.30120@woody.linux-foundation.org>
References: <1193076664-13652-10-git-send-email-jens.axboe@oracle.com>
 <471DCBB2.9020706@panasas.com> <alpine.LFD.0.999.0710230808260.30120@woody.linux-foundation.org>
 <200710251840.02157.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Oct 2007, Rusty Russell wrote:
> On Wednesday 24 October 2007 01:22:55 Linus Torvalds wrote:
> >
> > Well, I'd personally actually prefer to *not* have the count be passed
> > down explicitly, because it's just too error prone.
> 
> Well, the duplication is bad, but walking lists to find the length is
> inefficient so you pass around the length as well.

Nobody should *ever* walk the list to find the length. Does anybody really 
do that? Yes, we pass the thing down, but do people *need* it?

[ Side note: some of the users of that length currently would seem to be 
  buggy in the presense of continuation entries, and seem to assume that 
  the "list" is just a contiguous array. In fatc, that's almost the only 
  valid use for the "count" thing, since any other use _has_ to walk it 
  entry by entry anyway, no? ]

The thing is, nobody should care. You walk the list to fill things in, or 
to write it out to some HW-specific DMA table, you should never care about 
the length. However, you *do* care about the "where does it end" part: to 
be able to detect overflows (which should never happen, but from a 
debugging standpoint it needs to be detectable rather than just silently 
use or corrupt memory).

But if people really want/need the length, then we damn well should have a 
"header" thing, not two independent "list + length" parameters.

			Linus
