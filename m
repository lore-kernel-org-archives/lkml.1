Return-Path: <linux-kernel-owner+w=401wt.eu-S1752180AbZAZNcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbZAZNcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 08:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750872AbZAZNcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 08:32:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38784 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbZAZNcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 08:32:23 -0500
Date: Mon, 26 Jan 2009 14:32:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mandeep Singh Baines <msb@google.com>
Subject: Re: [RFC][PATCH 2/2] add a counter for writers spinning on a rwlock
Message-ID: <20090126133207.GC13567@elte.hu>
References: <497cd08f.0c11660a.33a7.ffffdf39@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497cd08f.0c11660a.33a7.ffffdf39@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> This patch adds a counter for writers that enter a rwlock slow path. For 
> example it can be useful for slow background tasks which perform some 
> jobs on the tasklist, such as the hung_task detector 
> (kernel/hung_task.c).
> 
> It adds a inc/dec pair on the slow path and 4 bytes for each rwlocks, so 
> the overhead is not null.
> 
> Only x86 is supported for now, writers_spinning_lock() will return 0 on 
> other archs (which is perhaps not a good idea).
> 
> Comments?

hm, it increases the rwlock data type:

> diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
> index 845f81c..163e6de 100644
> --- a/arch/x86/include/asm/spinlock_types.h
> +++ b/arch/x86/include/asm/spinlock_types.h
> @@ -13,6 +13,7 @@ typedef struct raw_spinlock {
>  
>  typedef struct {
>  	unsigned int lock;
> +	unsigned int spinning_writers;
>  } raw_rwlock_t;

that's generally not done lightly. Performance figures for a relevant 
workload are obligatory in this case - proving that it's worth the size 
bloat.

	Ingo
