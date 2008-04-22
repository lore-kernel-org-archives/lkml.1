Return-Path: <linux-kernel-owner+w=401wt.eu-S1757907AbYDVIoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907AbYDVIoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 04:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757059AbYDVIoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 04:44:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58980 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756971AbYDVIoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 04:44:20 -0400
Date: Tue, 22 Apr 2008 10:44:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] use canary at end of stack to indicate overruns at
	oops time
Message-ID: <20080422084404.GA2388@elte.hu>
References: <480D5F27.1030101@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480D5F27.1030101@redhat.com>
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


* Eric Sandeen <sandeen@redhat.com> wrote:

> Use a canary at the end of the stack to clearly indicate at oops time 
> whether the stack has ever overflowed.
> 
> This is a very simple implementation with a couple of drawbacks:
> 
> 1) a thread may legitimately use exactly up to the last
>    word on the stack
> 
>  -- but the chances of doing this and then oopsing later seem slim

even that narrow case is a bug - an NMI might arrive at exactly that 
point and overflow the stack for real.

> 2) it's possible that the stack usage isn't dense enough
>    that the canary location could get skipped over
> 
>  -- but the worst that happens is that we don't flag the overrun

yeah.

> With the code in place, an intentionally-bloated stack oops does:
> 
> BUG: unable to handle kernel paging request at ffff8103f84cc680
> IP: [<ffffffff810253df>] update_curr+0x9a/0xa8
> PGD 8063 PUD 0 
> Thread overran stack or stack corrupted
> Oops: 0000 [1] SMP 
> CPU 0 
> ...

excellent. I've queued this up, it's definitely an improvement in 
debuggability.

we used to have something comparable in ancient kernels (it was called 
the stack red zone IIRC) - but it was not printed in oopses and we lost 
the feature somewhere anyway.

	Ingo
