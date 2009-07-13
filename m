Return-Path: <linux-kernel-owner+w=401wt.eu-S1757601AbZGMXgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601AbZGMXgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 19:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754489AbZGMXgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 19:36:23 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57408 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045AbZGMXgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 19:36:22 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/4][resend]  Show kernel stack usage in /proc/meminfo and OOM log output
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com, cl@linux-foundation.org,
       riel@redhat.com
In-Reply-To: <20090713152952.9b1f6388.akpm@linux-foundation.org>
References: <20090713150114.6260.A69D9226@jp.fujitsu.com> <20090713152952.9b1f6388.akpm@linux-foundation.org>
Message-Id: <20090714083344.626C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 14 Jul 2009 08:36:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 13 Jul 2009 15:02:25 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > ChangeLog
> >   Since v1
> >    - Rewrote the descriptin (Thanks Christoph!)
> > 
> > =====================
> > Subject: [PATCH] Show kernel stack usage in /proc/meminfo and OOM log output
> > 
> > The amount of memory allocated to kernel stacks can become significant and
> > cause OOM conditions. However, we do not display the amount of memory
> > consumed by stacks.
> > 
> > Add code to display the amount of memory used for stacks in /proc/meminfo.
> > 
> > ...
> >  
> > +static void account_kernel_stack(struct thread_info *ti, int account)
> > +{
> > +	struct zone *zone = page_zone(virt_to_page(ti));
> > +
> > +	mod_zone_page_state(zone, NR_KERNEL_STACK, account);
> > +}
> > +
> >  void free_task(struct task_struct *tsk)
> >  {
> >  	prop_local_destroy_single(&tsk->dirties);
> > +	account_kernel_stack(tsk->stack, -1);
> 
> But surely there are other less expensive ways of calculating this. 
> The number we want is small-known-constant * number-of-tasks.
> 
> number-of-tasks probably isn't tracked, but can be calculated along the
> lines of nr_running(), nr_uninterruptible() and nr_iowait().

But, nr_running() don't know zone information. we really need
per-zone tracking IMHO.


> number-of-tasks is also equal to number-of-task_structs and
> number-of_thread_infos which can be obtained from slab (if the arch
> implemented these via slab - uglier).

You know, Almost architecture doesn't use slab for kernel-stack.




