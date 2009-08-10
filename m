Return-Path: <linux-kernel-owner+w=401wt.eu-S1754222AbZHJW46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbZHJW46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 18:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbZHJW45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 18:56:57 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:43166 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754205AbZHJW44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 18:56:56 -0400
Subject: Re: kmemleak: Protect the seq start/next/stop sequence by
	rcu_read_lock()
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090810184527.GA9601@elte.hu>
References: <20090729152101.1878.71159.stgit@pc1117.cambridge.arm.com>
	 <20090802111453.GA24927@elte.hu>
	 <1249919718.10848.55.camel@pc1117.cambridge.arm.com>
	 <20090810184527.GA9601@elte.hu>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 10 Aug 2009 23:56:43 +0100
Message-Id: <1249945003.26205.23.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Aug 2009 22:56:44.0530 (UTC) FILETIME=[D514FD20:01CA1A0D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-10 at 20:45 +0200, Ingo Molnar wrote:
> * Catalin Marinas <catalin.marinas@arm.com> wrote:
> 
> > On Sun, 2009-08-02 at 13:14 +0200, Ingo Molnar wrote:
> > > hm, some recent kmemleak patch is causing frequent hard and 
> > > soft lockups in -tip testing (-rc5 based).
> > 
> > Thanks for reporting this. It shouldn't be caused by the patch 
> > mentioned in the subject as this only deals with reading the seq 
> > file which doesn't seem to be the case here.
> 
> Since i turned off kmemleak in -tip completely via the patch below i 
> havent had a single such lockup.
> 
> Have you tried the config i sent - does it work fine for you? For me 
> it locks up on various boxes within a couple of minutes - without 
> doing anything particular beyond building a kernel or so.

I couldn't tried your config as I don't have an x86_64 machine (I only
rely on an x86_32 laptop at home and several ARM machines at work for
testing).

I tried similar config and with the mainline kernel I get some lockups
(several seconds) with CONFIG_PREEMPT disabled on ARM machines or x86
during a scanning episode but it eventually completes the scanning. With
the kmemleak patches for the next merging window, I don't get any
lockups as it has more cond_resched() calls.

Maybe on your x86_64 box you get some bigger objects allocated
(alloc_bootmem, per-cpu, data/bss, NODE_DATA, task stacks) which are
scanned without cond_resched() calls and CONFIG_PREEMPT disabled.
Scanning the memory can even take several minutes especially with
CONFIG_PROVE_LOCKING enabled and maybe that's why you see the lockups.
Enabling CONFIG_PREEMPT reduces the lockup period.

I'll try tomorrow with x86_32 allyesconfig on my laptop and see how it
goes.

Thanks.

-- 
Catalin

