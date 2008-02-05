Return-Path: <linux-kernel-owner+w=401wt.eu-S1758308AbYBEAnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308AbYBEAnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 19:43:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757355AbYBEAmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 19:42:51 -0500
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:39562 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756915AbYBEAmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 19:42:50 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=EWgYIf+m1f73xjYKZuLrHhUnKXR5PvRygILsMOAn6PzEQ1I+J6rv6ncbVJToRSY311ncTtiBn4gE7brIJxoIcZ0xnEiM7nyZnHNC7JNyN8KBoufdspgrAjSF+xqt7kPPp/qK9R8HRUpsz04dX28E+2Ue1CD5lFEG+IZMbQYpFcU=  ;
X-YMail-OSG: fQ0nAHsVM1lb4P2qxm4y8RhpGxU2DS9jArjW0ywG119powlsh5XpDFMqcYIG306jR_s1obX7dA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [git pull] SLUB updates for 2.6.25
Date: Tue, 5 Feb 2008 11:42:20 +1100
User-Agent: KMail/1.9.5
Cc: willy@linux.intel.com, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
References: <Pine.LNX.4.64.0802041206190.3241@schroedinger.engr.sgi.com> <200802051105.12194.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0802041629290.5057@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0802041629290.5057@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802051142.20413.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 February 2008 11:32, Christoph Lameter wrote:
> On Tue, 5 Feb 2008, Nick Piggin wrote:
> > Ok. But the approach is just not so good. If you _really_ need something
> > like that and it is a win over the regular non-atomic unlock, then you
> > just have to implement it as a generic locking / atomic operation and
> > allow all architectures to implement the optimal (and correct) memory
> > barriers.
>
> Assuming this really gives a benefit on several benchmarks then we need
> to think about how to do this some more. Its a rather strange form of
> locking.
>
> Basically you lock the page with a single atomic operation that sets
> PageLocked and retrieves the page flags.

This operation is not totally unusual. I could use it for my optimised
page lock patches for example (although I need an operation that clears
a flag and has release semantics, but similar class of "thing").


> Then we shovel the page state 
> around a couple of functions in a register and finally store the page
> state back which at the same time unlocks the page.

And this is a store-for-unlock (eg. with release semantics).
Nothing too special about that either I guess. (it is almost the word
equivalent of clear_bit_unlock).


> So two memory 
> references with one of them being atomic with none in between. We have
> nothing that can do something like that right now.

The load you are trying to avoid in the lock really isn't that
expensive. The cacheline is in L1. Even after a store, many CPUs
have store forwarding so it is probably not going to matter at all
on those.

Anyway, not saying the operations are useless, but they should be
made available to core kernel and implemented per-arch. (if they are
found to be useful)
