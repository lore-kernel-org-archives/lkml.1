Return-Path: <linux-kernel-owner+w=401wt.eu-S1756488AbZDUBlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488AbZDUBlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 21:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbZDUBl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 21:41:27 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40579 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbZDUBl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 21:41:27 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH V3] Fix Committed_AS underflow
Cc: kosaki.motohiro@jp.fujitsu.com, Eric B Munson <ebmunson@us.ibm.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       mel@linux.vnet.ibm.com, cl@linux-foundation.org
In-Reply-To: <1240256999.32604.330.camel@nimitz>
References: <1240244120.32604.278.camel@nimitz> <1240256999.32604.330.camel@nimitz>
Message-Id: <20090421102317.F113.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 21 Apr 2009 10:41:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> void vm_acct_memory(long pages)
> {
>         long *local;
> 	long local_min = -ACCT_THRESHOLD;
> 	long local_max = ACCT_THRESHOLD;
> 	long local_goal = 0;
> 
>         preempt_disable();
>         local = &__get_cpu_var(committed_space);
>         *local += pages;
>         if (*local > local_max || *local < local_min) {
>                 atomic_long_add(*local - local_goal, &vm_committed_space);
>                 *local = local_goal;
>         }
>         preempt_enable();
> }
> 
> But now consider if we changed the local_* variables a bit:
> 
> 	long local_min = -(ACCT_THRESHOLD*2);
> 	long local_max = 0
> 	long local_goal = -ACCT_THRESHOLD;
> 
> We'll get some possibly *large* numbers in meminfo, but it will at least
> never underflow.

if *local == -(ACCT_THRESHOLD*2), 
  *local - local_goal = -(ACCT_THRESHOLD*2) + ACCT_THRESHOLD = -ACCT_THRESHOLD

Then, we still pass negative value to atomic_long_add().
IOW, vm_committed_space still can be negative value.

Am I missing anything?



