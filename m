Return-Path: <linux-kernel-owner+w=401wt.eu-S966038AbXFGTwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966038AbXFGTwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 15:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965425AbXFGTwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 15:52:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47748 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965475AbXFGTwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 15:52:09 -0400
Date: Thu, 7 Jun 2007 21:51:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       James Carter <jwcart2@tycho.nsa.gov>, Paul Moore <paul.moore@hp.com>,
       James Morris <jmorris@namei.org>
Subject: Re: [bug] very high non-preempt latency in
	context_struct_compute_av()
Message-ID: <20070607195151.GA30899@elte.hu>
References: <20070604112745.GA26350@elte.hu> <1181244850.11979.66.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181244850.11979.66.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Smalley <sds@tycho.nsa.gov> wrote:

> Can you try the patch below to see whether it helps?
> 
> In security_get_user_sids, move the transition permission checks 
> outside of the section holding the policy rdlock, and use the AVC to 
> perform the checks, calling cond_resched after each one.  These 
> changes should allow preemption between the individual checks and 
> enable caching of the results.  It may however increase the overall 
> time spent in the function in some cases, particularly in the cache 
> miss case.
> 
> The long term fix will be to take much of this logic to userspace by 
> exporting additional state via selinuxfs, and ultimately deprecating 
> and eliminating this interface from the kernel.
> 
> Signed-off-by: Stephen Smalley <sds@tycho.nsa.gov>

i have just tried your patch and it completely solves the issue! Without 
the patch, a simple script that keeps logging in on a box:

	while :; do ssh testbox true; done

would cause glxgears to get into a very jerky motion due to the 
latencies. With the patch it's 100%, totally smooth! Thanks!

Tested-by: Ingo Molnar <mingo@elte.hu>

	Ingo
