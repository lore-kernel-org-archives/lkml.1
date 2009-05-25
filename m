Return-Path: <linux-kernel-owner+w=401wt.eu-S1755003AbZEYDj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003AbZEYDj5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 23:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbZEYDjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 23:39:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59564 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbZEYDjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 23:39:48 -0400
Date: Mon, 25 May 2009 05:39:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Jan Beulich <JBeulich@novell.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>, suresh.b.siddha@intel.com,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2.6.30-rc7] x86: remove remap percpu allocator for the
	time being
Message-ID: <20090525033920.GD20687@elte.hu>
References: <4A1A0A27.4050301@kernel.org> <20090525033429.GC20687@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090525033429.GC20687@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > @@ -365,9 +249,7 @@ void __init setup_per_cpu_areas(void)
> >  	 * of large page mappings.  Please read comments on top of
> >  	 * each allocator for details.
> >  	 */
> > -	ret = setup_pcpu_remap(static_size);
> > -	if (ret < 0)
> > -		ret = setup_pcpu_embed(static_size);
> > +	ret = setup_pcpu_embed(static_size);
> >  	if (ret < 0)
> >  		ret = setup_pcpu_4k(static_size);
> >  	if (ret < 0)
> 
> Please send a patch that only does the above chunk in essence. We 
> can deal with the rest in .31.

I've committed the minimal patch below.

Thanks,

	Ingo

>From 71c9d8b68b299bef614afc7907393564a9f1476f Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Mon, 25 May 2009 12:01:59 +0900
Subject: [PATCH] x86: Remove remap percpu allocator for the time being

Remap percpu allocator has subtle bug when combined with page
attribute changing.  Remap percpu allocator aliases PMD pages for the
first chunk and as pageattr doesn't know about the alias it ends up
updating page attributes of the original mapping thus leaving the
alises in inconsistent state which might lead to subtle data
corruption.  Please read the following threads for more information:

  http://thread.gmane.org/gmane.linux.kernel/835783

The following is the proposed fix which teaches pageattr about percpu
aliases.

  http://thread.gmane.org/gmane.linux.kernel/837157

However, the above changes are deemed too pervasive for upstream
inclusion for 2.6.30 release, so this patch essentially disables
the remap allocator for the time being.

Signed-off-by: Tejun Heo <tj@kernel.org>
LKML-Reference: <4A1A0A27.4050301@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/setup_percpu.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 3a97a4c..8f0e13b 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -160,8 +160,10 @@ static ssize_t __init setup_pcpu_remap(size_t static_size)
 	/*
 	 * If large page isn't supported, there's no benefit in doing
 	 * this.  Also, on non-NUMA, embedding is better.
+	 *
+	 * NOTE: disabled for now.
 	 */
-	if (!cpu_has_pse || !pcpu_need_numa())
+	if (true || !cpu_has_pse || !pcpu_need_numa())
 		return -EINVAL;
 
 	/*
