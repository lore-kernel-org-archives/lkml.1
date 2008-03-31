Return-Path: <linux-kernel-owner+w=401wt.eu-S1757187AbYCaKNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187AbYCaKNF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 06:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755623AbYCaKMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 06:12:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50420 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591AbYCaKMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 06:12:52 -0400
Date: Mon, 31 Mar 2008 12:12:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC,PATCH] loopback: calls netif_receive_skb() instead of
	netif_rx()
Message-ID: <20080331101237.GA12324@elte.hu>
References: <47BDC848.50607@cosmosbay.com> <20080226.182120.183405235.davem@davemloft.net> <47C92F49.4070100@cosmosbay.com> <20080323.032949.194309002.davem@davemloft.net> <47E6A5FD.6060407@cosmosbay.com> <20080331094823.GA11651@elte.hu> <47F0B66C.6080404@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47F0B66C.6080404@cosmosbay.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Dumazet <dada1@cosmosbay.com> wrote:

> Problem is to check available space :
>
> It depends on stack growing UP or DOWN, and depends on caller running 
> on process stack, or softirq stack, or even hardirq stack.

ok - i wish such threads were on lkml so that everyone not just the 
netdev kabal can read it. It's quite ugly, but if we want to check stack 
free space i'd suggest for you to put a stack_can_recurse() call into 
arch/x86/kernel/process.c and offer a default __weak implementation in 
kernel/fork.c that always returns 0.

the rule on x86 should be something like this: on 4K stacks and 64-bit 
[which have irqstacks] free stack space can go as low as 25%. On 8K 
stacks [which doesnt have irqstacks but nests irqs] it should not go 
below 50% before falling back to the explicitly queued packet branch.

this way other pieces of kernel code code can choose between on-stack 
fast recursion and explicit iterators. Although i'm not sure i like the 
whole concept to begin with ...

	Ingo
