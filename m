Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbZBCBeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbZBCBeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 20:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbZBCBeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 20:34:09 -0500
Received: from smtp115.mail.mud.yahoo.com ([209.191.84.164]:23274 "HELO
	smtp115.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751283AbZBCBeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 20:34:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=A4H2zRNilonmqnmfekzB34pdMWWbCqtf+pMdiTymriHChCnasO1bZxpGJ0gHaAqr61O7qjamk3pAq2oJg6YWOKQOFKZfykxaRx/Dov4BaS+uA3PDJuizHcXF0aWB2s8Fzj3x7zxlPaP0bKiz91u8YWUszvjVFNG/Rhbsw8rStXc=  ;
X-YMail-OSG: uHtrcJkVM1nJdhKc7Lh_HmGkSfpuO9JoWPgoHEURkmsW6WWt1VgAt76HhVPLaF97Td70wapPUr6ZoheT7IS5tWxK7IBaBbdwg6O07aaqBPxvaZI0pXr3_qdKcIa4BxsoMs7J7KNktPE0QBsRolzdlzZNclkTlAM5oSwejUGsUb331j6pRnYLXczVj5LUSg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] SLUB: revert direct page allocator pass through
Date: Tue, 3 Feb 2009 12:33:39 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, yanmin_zhang@linux.intel.com,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <Pine.LNX.4.64.0901231041210.8574@melkki.cs.Helsinki.FI> <200901240317.26227.nickpiggin@yahoo.com.au> <alpine.DEB.1.10.0901261206500.32192@qirst.com>
In-Reply-To: <alpine.DEB.1.10.0901261206500.32192@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902031233.40987.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 January 2009 04:17:28 Christoph Lameter wrote:
> On Sat, 24 Jan 2009, Nick Piggin wrote:

> > Other ones which could be changed but could introduce regressions are
> > watermarks, buddy merging, and struct page error checking and setup.
>
> Isnt it possible to defer that (queuing them (sigh)).

If you defer it then you lose merge opportunities and effectively increase
the rate of fragmentation.


> A bitmap could be
> used to avoid queuing and may even allow fully concurrent allocations
> without locks. Use a counter to check watermarks once in a while.

Bitmap? Involving locks or atomic operations, right?


> > (I did make that patch to enable refcounting to be avoided FWIW, which
> > avoids a couple of atomic operations, but I don't think it brought
> > performance up too much, but I still intend to dust it off at some
> > point).
>
> Well if the page stays with a refcount of one then we do not need to check
> the refcount at all but just push it in an out of some queue / bitmap or
> something.

I sent you the patch but I don't think you ever came back with numbers.
It's trivial, you just can avoid the put_page_testzero if the caller does
not need refcounting and the refcount remains at 0 (has to remain 0, not
1, because of speculative page references).

The page refcounting layer lives on top of the buddy/queueing/etc layers,
so the same technique works no matter what the underlying allocator looks
like.

The only reason I didn't merge it is that it added another branch. I wanted
to rework the APIs a little bit to avoid it.

