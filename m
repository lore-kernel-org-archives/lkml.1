Return-Path: <linux-kernel-owner+w=401wt.eu-S1754683AbXJYEyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbXJYEyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 00:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbXJYEye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 00:54:34 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:22321 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752028AbXJYEye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 00:54:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=WWNlO3q7wS9/qJMKk4DzSP/+uiuMYn+O4N95hIBDxMlw0l10/iXn+zkSdG4o9C79n2KWe41bcffuhmJ3ZhVvcVccykKFVcPKe0OYH4I6nIlZN525j3OTHEMN/fHSRu78BahdfszgZMc1c86OXt4zM+rmIkhZUlJAWh1lO0G0yj4=  ;
X-YMail-OSG: CbE42akVM1m9ZPc8OEN6V4t3qLHD5Vb8LpErxSC8qyam5ue0
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: davids@webmaster.com, "Kleen, Andi" <ak@suse.de>,
       "Torvalds, Linus" <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Is gcc thread-unsafe?
Date: Thu, 25 Oct 2007 14:47:51 +1000
User-Agent: KMail/1.9.5
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
References: <MDEHLPKNGKAHNMBLJOLKAEOKHLAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKAEOKHLAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710251447.51370.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

[BTW. can you retain cc lists, please?]

On Thursday 25 October 2007 14:29, David Schwartz wrote:
> > Well that's exactly right. For threaded programs (and maybe even
> > real-world non-threaded ones in general), you don't want to be
> > even _reading_ global variables if you don't need to. Cache misses
> > and cacheline bouncing could easily cause performance to completely
> > tank in some cases while only gaining a cycle or two in
> > microbenchmarks for doing these funny x86 predication things.
>
> For some CPUs, replacing an conditional branch with a conditional move is a
> *huge* win because it cannot be mispredicted.

A *conditional* store should no be a problem.

However the funny trick of doing this conditional add (implemented with
unconditional store), is what is going to cause breakage.

On the CPUs where predicated instructions are a big win, I'd expect
they should also implement a conditional store for use here. However
they might be slower than an unconditional store (eg. x86's cmov),
and in those cases, gcc might just do the non-conditional store.


> In general, compilers should 
> optimize for unshared data since that's much more common in typical code.
> Even for shared data, the usual case is that you are going to access the
> data few times, so pulling the cache line to the CPU is essentially free
> since it will happen eventually.

This is not just a question of data that you were going to use anyway.
gcc generates memory accesses to locations that would never be accessed
Even stores. It is basically impossible to say that this is a real
performance win. Even on single threaded code: consider that cache
misses take the vast majority of time in many loads, which gives a
little hint that maybe it's a bad idea to do this ;)


> Heuristics may show that the vast majority of such constructs write anyway.
> So the optimization may also be valid based on such heuristics.

I'd never say the optimisation would always be useless. But it's a nasty
thing to have on by default, and apparently even with no good way to
supress it even if we want to.


> A better question is whether it's legal for a compiler that claims to
> support POSIX threads. I'm going to post on comp.programming.threads, where
> the threading experts hang out.

Either way, I think we really need a way to turn it off for Linux.
