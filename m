Return-Path: <linux-kernel-owner+w=401wt.eu-S1754332AbYJOQrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbYJOQrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 12:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYJOQrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 12:47:09 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:38124 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751760AbYJOQrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 12:47:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=e0B8wWQMHVqvr2m+QBpa3GueNMXUFw7N0WhwPz3MRXwqUJmdzPio97q+PYUjvZ0IX4Xb5UUwMVjYCTBg/rsSjY0mYkg6ePfS1N//NJihf+a0cOskUDXan1+T1fzCMxKn7YfOh4oik8hlR07IWhR+RL3aSgRJVk6vlyG6CWfWjCw=  ;
X-YMail-OSG: klDNMHwVM1m1CUafA8f143kYDzkih6PflumjknmibyrpCz5Wpl7ZKtOaFk.LmKbp6bFcUwLgv3vNLZbBuPn7rH37Sgqmc1ftPjJc9Yyr0ugsxYK6HuS6KDiJ3mFez0FM6lIcQF9VpA1N.dv6CkmV2DdDm7wDoLRIEha9rs.X
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: torvalds@linux-foundation.org
Subject: Re: [rfc] SLOB memory ordering issue
Date: Thu, 16 Oct 2008 03:46:58 +1100
User-Agent: KMail/1.9.5
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <200810160334.13082.nickpiggin@yahoo.com.au>
In-Reply-To: <200810160334.13082.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810160346.59166.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 October 2008 03:34, Nick Piggin wrote:
> I think I see a possible memory ordering problem with SLOB:
> In slab caches with constructors, the constructor is run
> before returning the object to caller, with no memory barrier
> afterwards.
>
> Now there is nothing that indicates the _exact_ behaviour
> required here. Is it at all reasonable to expect ->ctor() to
> be visible to all CPUs and not just the allocating CPU?
>
> SLAB and SLUB don't appear to have this problem. Of course,
> they have per-CPU fastpath queues, so _can_ have effectively
> exactly the same ordering issue if the object was brought
> back into the "initialized" state before being freed, rather
> than by ->ctor(). However in that case, it is at least
> kind of visible to the caller.

Although I guess it's just as much of a SLAB implementation
detail as the lack of ->ctor() barrier... And I really doubt
_any_ of the callers would have ever thought about either
possible problem.

I'd really hate to add a branch to the slab fastpath for this
though. Maybe we just have to document it, assume there are
no problems, and maybe take a look at some of the core users
of this.
