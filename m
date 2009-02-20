Return-Path: <linux-kernel-owner+w=401wt.eu-S1755748AbZBTOC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748AbZBTOC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 09:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbZBTOCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 09:02:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42513 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbZBTOCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 09:02:20 -0500
Date: Fri, 20 Feb 2009 15:01:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>, stable@kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
Message-ID: <20090220140157.GA12799@elte.hu>
References: <20090220134121.GA19575@damson.getinternet.no> <20090220135000.GA9616@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220135000.GA9616@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> ah, indeed:
> 
>         list_del_rcu(&va->list);
> 
> i suspect it could be hit big time in a workload that opens 
> more than 512 files, as expand_files() uses a 
> vmalloc()+vfree() pair in that case.

hm, perhaps it's not a problem after all. The freeing is done 
via rcu, and list_del_rcu() leaves the forward pointer intact.

So how did it happen that the entry got kfree()d before the loop 
was done? We are in a spinlocked section so the CPU should not 
have entered rcu processing.

	Ingo
