Return-Path: <linux-kernel-owner+w=401wt.eu-S1760986AbZDAILd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760986AbZDAILd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 04:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbZDAILQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 04:11:16 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:48392 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368AbZDAILN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 04:11:13 -0400
Date: Wed, 1 Apr 2009 10:10:54 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, rusty@rustcorp.com.au, tglx@linutronix.de,
       x86@kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com
Subject: Re: [GIT RFC] percpu: use dynamic percpu allocator as the default
 percpu allocator
Message-ID: <20090401101054.0a4b187d@skybase>
In-Reply-To: <49D2B04D.4070604@kernel.org>
References: <1236671631-9305-1-git-send-email-tj@kernel.org>
	<20090316190132.7965a49a@skybase>
	<49C300D8.5080204@kernel.org>
	<49C8FAC4.6060508@kernel.org>
	<20090325122738.42d105b7@skybase>
	<49CA1AC3.9080908@kernel.org>
	<20090325122241.GE11571@elte.hu>
	<49CA2345.70204@kernel.org>
	<20090325141330.2717dc97@skybase>
	<49CA2FBF.9000207@kernel.org>
	<20090325142525.2d31c522@skybase>
	<49CA32F6.2030408@kernel.org>
	<20090331185431.72ff1707@skybase>
	<49D2B04D.4070604@kernel.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Apr 2009 09:07:41 +0900
Tejun Heo <tj@kernel.org> wrote:

> Martin Schwidefsky wrote:
> > 
> > I got the dynamic cpu allocator to work with the patch below. Anybody
> > with an objection against the SHIFT_PERCPU_VAR macro ?
> 
> One of the main goals of the percpu allocator is removing the
> distinction between statically and dynamically allocated percpu
> variables, so that it can be treated like other normal variables.  For
> all archs other than s390, alpha and ia64, achieving this is easy, so
> I wish we could come up with solution for the three archs too.  Is it
> possible to do similar stuff with pointer values with input
> constraint which can take both constant and variable?

Is the goal to use the same access macros for both dynamically and
statically allocated percpu variables? That would make the proposed
solution impractical.

The "X" constraint trick we used so far tells the compiler to pass the
argument verbatim to the assembler. The assembler knows how to deal
with symbol@GOTENT. If we pass a gcc variable or even a more general
term via an "X" constraint the assembler gets <something C-ish>@GOTENT.
It is not possible to parse this in the assembler. To do what you want
to achieve would mean to avoid using the "X" constraint. Which means
that we cannot use the GOTENT trick anymore. If we let the compiler
resolve the address for a static per cpu variable we end up with the
larl problem. Ouch!

So far the SHIFT_PERCPU_PTR/SHIFT_PERCPU_VAR is the only solution
I have found for s390 and the dynamic percpu allocator. I'll keep
looking for a better solution but I am not optimistic.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

