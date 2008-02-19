Return-Path: <linux-kernel-owner+w=401wt.eu-S1760187AbYBSJrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760187AbYBSJrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 04:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbYBSJrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 04:47:05 -0500
Received: from n7.bullet.mud.yahoo.com ([216.252.100.58]:34106 "HELO
	n7.bullet.mud.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752471AbYBSJrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 04:47:04 -0500
X-Yahoo-Newman-Id: 745547.2473.bm@omp415.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=kHS6//g+hrCUYpf2UTGsAzL35ljgpyGtz+QOdc7Up/crgkc1MFI3cfcCdA7v6jLOHVd7EVVDmXlAmgROs5MZF1c/ybXV16g/UGbhaavPL4sZDj4MBHKJycyET0OODGXKetlUL2e9Tqzd+Ndeolki6L/zR9gQ5sDUob7QcF52xf4=  ;
X-YMail-OSG: KuH.4pgVM1mbbTxb5mlsXgvDZxU1z76i7pmgxHFiDr3VENEvMPnBmwvgTmMIHbzS8lAAd6IL.w--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/3] Fix Unlikely(x) == y
Date: Tue, 19 Feb 2008 20:46:46 +1100
User-Agent: KMail/1.9.5
Cc: Arjan van de Ven <arjan@infradead.org>, Willy Tarreau <w@1wt.eu>,
       Roel Kluin <12o3l@tiscali.nl>, geoffrey.levand@am.sony.com,
       linuxppc-dev@ozlabs.org, cbe-oss-dev@ozlabs.org,
       lkml <linux-kernel@vger.kernel.org>
References: <47B70A61.9030306@tiscali.nl> <200802191333.53607.nickpiggin@yahoo.com.au> <20080219092537.GA6485@one.firstfloor.org>
In-Reply-To: <20080219092537.GA6485@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802192046.46955.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2008 20:25, Andi Kleen wrote:
> On Tue, Feb 19, 2008 at 01:33:53PM +1100, Nick Piggin wrote:

> > I actually once measured context switching performance in the scheduler,
> > and removing the  unlikely hint for testing RT tasks IIRC gave about 5%
> > performance drop.
>
> OT: what benchmarks did you use for that? I had a change some time
> ago to the CFS scheduler to avoid unpredicted indirect calls for
> the common case, but I wasn't able to benchmark a difference with the usual
> suspect benchmark (lmbench). Since it increased code size by
> a few bytes it was rejected then.

I think it was just a simple context switch benchmark, but not lmbench
(which I found to be a bit too variable). But it was a long time ago...


> > This was on a P4 which is very different from more modern CPUs both in
> > terms of branch performance characteristics,
> >
> > and icache characteristics.
>
> Hmm, the P4 the trace cache actually should not care about inline
> code that is not executed.

Yeah, which is why it is a bit different than other CPUs. Although
the L2 cache I guess is still going to suffer from sparse code, but
I guess that is a bit less important.


> > However, the P4's branch predictor is pretty good, and it should easily
>
> I think it depends on the generation. Prescott class branch
> prediction should be much better than the earlier ones.

I was using a Nocona Xeon, which I think is a Prescott class? And
don't they have much higher mispredict penalty (than older P4s)?


> > Actually one thing I don't like about gcc is that I think it still emits
> > cmovs for likely/unlikely branches,
>
> That's -Os.

And -O2 and -O3, on the gccs that I'm using, AFAIKS.


> > which is silly (the gcc developers
>
> It depends on the CPU. e.g. on K8 and P6 using CMOV if possible
> makes sense. P4 doesn't like it though.

If the branch is completely predictable (eg. annotated), then I
think branches should be used anyway. Even on well predicted
branches, cmov is similar speed on microbenchmarks, but it will
increase data hazards I think, so it will probably be worse for
some real world situations.


> > the quite good numbers that cold CPU predictors can attain. However
> > for really performance critical code (or really "never" executed
> > code), then I think it is OK to have the hints and not have to rely
> > on gcc heuristics.
>
> But only when the explicit hints are different from what the implicit
> branch predictors would predict anyways. And if you look at the
> heuristics that is not often the case...

But a likely branch will be _strongly_ predicted to be taken,
wheras a lot of the gcc heuristics simply have slightly more or
slightly less probability. So it's not just a question of which
way is more likely, but also _how_ likely it is to go that way.

