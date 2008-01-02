Return-Path: <linux-kernel-owner+w=401wt.eu-S1757713AbYABLM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713AbYABLM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 06:12:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbYABLMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 06:12:50 -0500
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:38781 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751808AbYABLMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 06:12:49 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=vjtdBu4reVH6kuWv0Qm7MXgdn2XDkwlhGEmqsLU8PIw0lrMX3AD8wYjeoLorfQOMZQCQQzabSU/0zxQCRHCIA9OEu7lcpvIWKNSrXxTrAGjuWNUFVqjueaHRyxp62vY0Pd83ljoGrJASloP+sxsYHrygkVaeV6KZ6fnJJxE8bmY=  ;
X-YMail-OSG: yzbrmdYVM1llue2pcHcDeL0Fu5UqvJFq2RgagHxhee.V9gdF
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: 2.6.24-rc6-mm1
Date: Wed, 2 Jan 2008 22:12:28 +1100
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Herbert Xu <herbert@gondor.apana.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, trem <tremyfr@yahoo.fr>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <9DtBq-2jD-3@gated-at.bofh.it> <200801022131.15482.nickpiggin@yahoo.com.au> <1199271676.6821.112.camel@twins>
In-Reply-To: <1199271676.6821.112.camel@twins>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801022212.29303.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 January 2008 22:01, Peter Zijlstra wrote:
> On Wed, 2008-01-02 at 21:31 +1100, Nick Piggin wrote:
> > On Monday 31 December 2007 00:10, Ingo Molnar wrote:
> > > * Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > > > > Ingo, it's not good that we have cond_resched() definitions
> > > > > conditionally duplicated in kernel.h - that's increasing the risk
> > > > > of bugs like this one.
> > > >
> > > > Actually, why do we even have cond_resched when real preemption is
> > > > on? It seems to be a waste of space and time.
> > >
> > > due to the BKL. cond_resched() in BKL code breaks up BKL latencies.
> > >
> > > i dont mind not doing that though - we should increase the pain for BKL
> > > users, so that subsystems finally get rid of it altogether.
> > > lock_kernel() use within the kernel is still rampant - there are still
> > > more than 400 callsites to lock_kernel().
> >
> > It would be silly to potentially increase latency in some areas
> > for CONFIG_PREEMPT kernels, though.
> >
> > Better may be to detect when there is CONFIG_PREEMPT and
> > CONFIG_PREEMPT_BKL, and ifdef away the cond_resched in that case
> > (or -- why do we even make CONFIG_PREEMPT_BKL an option? Are there
> > really workloads left where it causes throughput regressions?)
>
> I've seen 1s+ desktop latencies due to PREEMPT_BKL when I was still
> using reiserfs.

Fair enough; so the former ifdefery would be preferable for now then.

> Both reiserfs and tty were fighting for the bkl and massive prio
> inversion ensued. Turning PREEMPT_BKL off made the system usable again.

Are either of those subsystems actually using the BKL to protect against
anything else (than themselves)? It would be sweet to have them use
private mutexes for the job instead (although even then it probably
wouldn't be a straight conversion)...
