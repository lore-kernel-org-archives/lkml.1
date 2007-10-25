Return-Path: <linux-kernel-owner+w=401wt.eu-S1760220AbXJYEFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760220AbXJYEFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 00:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbXJYEFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 00:05:38 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:41471 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750710AbXJYEFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 00:05:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qafxt9rb99RUqKyTY5aL9vy4IgK1o0hqLuF8dJbH294thPvVeCCEePIb4GekQfFR+MiMk+3LJKOGH+1qezZ2WnnGpI4Z8fId+XE+1asAhPRXeK+0BCqrtw9tGM74eD1/C920xg2l2op4R83sBjeFULn5N8kd4+3p4lxON9pOh/Y=  ;
X-YMail-OSG: ht6Z_BUVM1l0yAJTTP7Be5Z8IzHxa63S0MKKLpiI.R84jCwYa74qpOB5xo.mWnt_KbFcih6Gr1L5YkzPuNEHIEu8niE1HnmVxWT79B2KYCtD69a.q.g-
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Is gcc thread-unsafe?
Date: Thu, 25 Oct 2007 13:58:54 +1000
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Kleen, Andi" <ak@suse.de>
References: <200710251324.49888.nickpiggin@yahoo.com.au> <20071024204631.7e7e3c47@laptopd505.fenrus.org>
In-Reply-To: <20071024204631.7e7e3c47@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710251358.55185.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 October 2007 13:46, Arjan van de Ven wrote:
> On Thu, 25 Oct 2007 13:24:49 +1000
>
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > Hi,
> >
> > Andi spotted this exchange on the gcc list. I don't think he's
> > brought it up here yet, but it worries me enough that I'd like
> > to discuss it.
> >
> > Starts here
> > http://gcc.gnu.org/ml/gcc/2007-10/msg00266.html
> >
> > Concrete example here
> > http://gcc.gnu.org/ml/gcc/2007-10/msg00275.html
> >
> > Basically, what the gcc developers are saying is that gcc is
> > free to load and store to any memory location, so long as it
> > behaves as if the instructions were executed in sequence.
>
> this optimization btw is a serious mis-optimization, it makes memory
> more dirty and causes cachelines to become unshared.... I'm sure it
> works great on microbenchmarks but it sucks bigtime for anything real

Well that's exactly right. For threaded programs (and maybe even
real-world non-threaded ones in general), you don't want to be
even _reading_ global variables if you don't need to. Cache misses
and cacheline bouncing could easily cause performance to completely
tank in some cases while only gaining a cycle or two in
microbenchmarks for doing these funny x86 predication things.

I'm not sure about ia64 -- I _hope_ that for most of their
predication stuff, they also predicate the stores, rather than
just store unconditionally and rely on the source operand not
changing in the case they didn't intend the memory to change.
