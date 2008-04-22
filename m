Return-Path: <linux-kernel-owner+w=401wt.eu-S1762305AbYDVREm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762305AbYDVREm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 13:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761826AbYDVRE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 13:04:29 -0400
Received: from relay1.sgi.com ([192.48.171.29]:50957 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755599AbYDVRE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 13:04:28 -0400
Message-ID: <480E1A9A.6070301@sgi.com>
Date: Tue, 22 Apr 2008 10:04:26 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] sched: remove unnecessary kzalloc in sched_init_smp
References: <20080405011100.720014000@polaris-admin.engr.sgi.com>	 <20080405011101.534396000@polaris-admin.engr.sgi.com> <12c511ca0804220916i5c181202pecf8fee7153e54fc@mail.gmail.com>
In-Reply-To: <12c511ca0804220916i5c181202pecf8fee7153e54fc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Luck wrote:
> On Fri, Apr 4, 2008 at 6:11 PM, Mike Travis <travis@sgi.com> wrote:
>>  @@ -7297,6 +7287,11 @@ void __init sched_init_smp(void)
>>   #else
>>   void __init sched_init_smp(void)
>>   {
>>  +#if defined(CONFIG_NUMA)
>>  +       sched_group_nodes_bycpu = kzalloc(nr_cpu_ids * sizeof(void **),
>>  +                                                               GFP_KERNEL);
>>  +       BUG_ON(sched_group_nodes_bycpu == NULL);
>>  +#endif
>>         sched_init_granularity();
>>   }
>>   #endif /* CONFIG_SMP */
> 
> This hunk is causing problems with one of my builds (generic,
> uniprocessor). Note
> that the #else at the start of this hunk is from a #ifdef CONFIG_SMP ... so I'm
> wondering why we need #if defined(CONFIG_NUMA) inside uniprocessor code :-)
> How can you have NUMA issues with only one cpu!!!

>>> CONFIG_NUMA is dependent on CONFIG_SMP for x86 so that caused me to miss
>>> the error.  But here's the fix:

  * sched_group_nodes_bycpu is defined only for the SMP + NUMA case,
    it should not be referenced in the !SMP + NUMA case.

For inclusion into sched-devel/latest tree.

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git

Signed-off-by: Mike Travis <travis@sgi.com>
---
 kernel/sched.c |    5 -----
 1 file changed, 5 deletions(-)

--- linux-2.6.sched.orig/kernel/sched.c
+++ linux-2.6.sched/kernel/sched.c
@@ -8028,11 +8028,6 @@ void __init sched_init_smp(void)
 #else
 void __init sched_init_smp(void)
 {
-#if defined(CONFIG_NUMA)
-	sched_group_nodes_bycpu = kzalloc(nr_cpu_ids * sizeof(void **),
-								GFP_KERNEL);
-	BUG_ON(sched_group_nodes_bycpu == NULL);
-#endif
 	sched_init_granularity();
 }
 #endif /* CONFIG_SMP */
