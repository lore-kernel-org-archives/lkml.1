Return-Path: <linux-kernel-owner+w=401wt.eu-S1764629AbYEGSt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764629AbYEGSt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 14:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159AbYEGStp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 14:49:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42270 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072AbYEGStn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 14:49:43 -0400
Date: Wed, 7 May 2008 20:49:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-ID: <20080507184921.GA15452@elte.hu>
References: <87hcdab8zp.fsf@basil.nowhere.org> <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org> <20080507162012.GA10096@elte.hu> <alpine.LFD.1.10.0805070929310.3024@woody.linux-foundation.org> <20080507170528.GA11511@elte.hu> <alpine.LFD.1.10.0805071017130.3024@woody.linux-foundation.org> <20080507173612.GA13591@elte.hu> <alpine.LFD.1.10.0805071049180.3024@woody.linux-foundation.org> <20080507175959.GZ19219@parisc-linux.org> <alpine.LFD.1.10.0805071104290.3024@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805071104290.3024@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> .. Hmm ... Time passes. Linus looks at git history.
> 
> It does look like "cond_resched()" has not worked with the BKL since 
> 2005, and hasn't taken the BKL into account. Commit 5bbcfd9000:
> 
>     [PATCH] cond_resched(): fix bogus might_sleep() warning
> 
> +       if (unlikely(preempt_count()))
> +               return;
> 
> which talks about the BKS, ie it only took the *semaphore* 
> implementation into account. Never the spinlock-with-preemption-count 
> one.
> 
> Or am I blind?

hm, i think you are right.

most latency reduction was concentrated on the PREEMPT+PREEMPT_BKL case, 
and not getting proper cond_resched() behavior in case of !PREEMPT_BKL 
would certainly not be noticed by distros or users.

We made CONFIG_PREEMPT_BKL=y the default on SMP in v2.6.8, in this 
post-2.6.7 commit that introduced the feature:

|  commit fb8f6499abc6a847109d9602b797aa6afd2d5a3d
|  Author: Ingo Molnar <mingo@elte.hu>
|  Date:   Fri Jan 7 21:59:57 2005 -0800
|
|     [PATCH] remove the BKL by turning it into a semaphore

There was constant trouble around all these variations of preemptability 
and their combination with debugging helpers. (So i was rather happy to 
get rid of !PREEMPT_BKL - in the (apparently wrong) assumption that no 
tears will be shed.)

	Ingo
