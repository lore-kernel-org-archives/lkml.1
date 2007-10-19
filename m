Return-Path: <linux-kernel-owner+w=401wt.eu-S966168AbXJSCMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966168AbXJSCMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 22:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764312AbXJSCMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 22:12:30 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:46898 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1764181AbXJSCM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 22:12:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=CEgIpOKHQ6tw1DvNJ900LM0Su5D7LYeVbeF4IuVkJmPkt6d7zm90dhApQ2C39gDHkjRvJY6PvQrFTRyDJqRCdF2WltZXGRYTzS64yUi/FkQmesKKOkjpn2edcFTgWA/yFwNR7xSMlj/I6cLWmEKzGKhJBaMm7r0ZjCofTUqSG4o=  ;
X-YMail-OSG: 0M8Q9MUVM1m1YrIfbsFaJX8aDJScbraj.sI7Nxwlt429jx1KqndszUyr_DlUzEY5yKQR8LNrOA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: SLUB: Avoid atomic operation for slab_unlock
Date: Fri, 19 Oct 2007 12:12:00 +1000
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org, linux-mm@kvack.org
References: <Pine.LNX.4.64.0710181514310.3584@schroedinger.engr.sgi.com> <200710191156.43049.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0710181858240.4685@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0710181858240.4685@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710191212.00653.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 October 2007 12:01, Christoph Lameter wrote:
> On Fri, 19 Oct 2007, Nick Piggin wrote:
> > > Yes that is what I attempted to do with the write barrier. To my
> > > knowledge there are no reads that could bleed out and I wanted to avoid
> > > a full fence instruction there.
> >
> > Oh, OK. Bit risky ;) You might be right, but anyway I think it
> > should be just as fast with the optimised bit_unlock on most
> > architectures.
>
> How expensive is the fence? An store with release semantics would be safer
> and okay for IA64.

I'm not sure, I had an idea it was relatively expensive on ia64,
but I didn't really test with a good workload (a microbenchmark
probably isn't that good because it won't generate too much out
of order memory traffic that needs to be fenced).


> > Which reminds me, it would be interesting to test the ia64
> > implementation I did. For the non-atomic unlock, I'm actually
> > doing an atomic operation there so that it can use the release
> > barrier rather than the mf. Maybe it's faster the other way around
> > though? Will be useful to test with something that isn't a trivial
> > loop, so the slub case would be a good benchmark.
>
> Lets avoid mf (too expensive) and just use a store with release semantics.

OK, that's what I've done at the moment.


> Where can I find your patchset? I looked through lkml but did not see it.

Infrastructure in -mm, starting at bitops-introduce-lock-ops.patch.
bit_spin_lock-use-lock-bitops.patch and ia64-lock-bitops.patch are
ones to look at.

The rest of the patches I have queued here, apart from the SLUB patch,
I guess aren't so interesting to you (they don't do anything fancy
like convert to non-atomic unlocks, just switch things like page and
buffer locks to use new bitops).
