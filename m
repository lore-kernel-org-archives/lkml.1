Return-Path: <linux-kernel-owner+w=401wt.eu-S1753407AbYJ1In3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbYJ1In3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 04:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbYJ1InV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 04:43:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41827 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbYJ1InU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 04:43:20 -0400
Date: Tue, 28 Oct 2008 09:42:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Shaohua Li <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [PATCH] x86: remove wrong -1 in calling init_memory_mapping
Message-ID: <20081028084255.GM15734@elte.hu>
References: <49061E86.6080408@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49061E86.6080408@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> From: Shaohua Li <shaohua.li@intel.com>
> 
> impact: make memory hot plug got last page mapped.
> 
> Shuahua Li found:
> Round up address to a page, otherwise the last page isn't mapped.
> 
> No, I just did some experiments on a desktop for memory hotplug and this bug
> triggered a crash in my test.
> Yinghai's suggestion also fixed the bug. I just want to have safer method. Anyway, either approach is ok to me.
> 
> So acctually we don't need to round it.
> just remove that extra -1
> 
> Signed-off-by: Yinghai <yinghai@kernel.org>

applied to tip/x86/urgent, thanks guys!

Note, i changed the "Impact:" line. We try to use it to provide a 
single-line description of what practical impact a patch has. For 
example if it's a bugfix, we try to describe what type of bug effect 
it fixes. If it's a cleanup, we mark it as a cleanup. If it introduces 
a new feature or changes existing behavior to improve the code, we 
describe that.

There's no hard rules, so here are a few common examples:

 Impact: fix crash with memory hotplug
 Impact: cleanup
 Impact: fix bootup crash on certain types of hardware
 Impact: improve printk output
 Impact: add (default-off) debug feature
 Impact: make the implementation faster
 Impact: cleanup (no object code changed)
 Impact: change the implementation to be more robust
 Impact: fix bootup hang on certain systems
 Impact: add new system call
 Impact: enable hardware feature and make use of it
 Impact: fix rare crash under high DB load

etc. etc.

"Wrong" impact lines are the ones which just describe the change 
itself, not the general impact:

 Impact: add +1 to condition
 Impact: change foo() to call bar() as well
 Impact: flush the TLB when tearing down a mapping
 Impact: check for NULL

these are less useful because they just duplicate the information 
already available in the patch itself.

	Ingo

----------------->
>From 60817c9b31ef7897d60bca2f384cbc316a3fdd8b Mon Sep 17 00:00:00 2001
From: Shaohua Li <shaohua.li@intel.com>
Date: Mon, 27 Oct 2008 13:03:18 -0700
Subject: [PATCH] x86, memory hotplug: remove wrong -1 in calling init_memory_mapping()

Impact: fix crash with memory hotplug

Shuahua Li found:

| I just did some experiments on a desktop for memory hotplug and this bug
| triggered a crash in my test.
|
| Yinghai's suggestion also fixed the bug.

We don't need to round it, just remove that extra -1

Signed-off-by: Yinghai <yinghai@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/init_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index c7a4c5a..f79a02f 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -837,7 +837,7 @@ int arch_add_memory(int nid, u64 start, u64 size)
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	int ret;
 
-	last_mapped_pfn = init_memory_mapping(start, start + size-1);
+	last_mapped_pfn = init_memory_mapping(start, start + size);
 	if (last_mapped_pfn > max_pfn_mapped)
 		max_pfn_mapped = last_mapped_pfn;
 
