Return-Path: <linux-kernel-owner+w=401wt.eu-S1758842AbXIXMtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842AbXIXMtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 08:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756308AbXIXMtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 08:49:07 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:40271 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263AbXIXMtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 08:49:06 -0400
Message-ID: <46F7B21E.3030007@linux.vnet.ibm.com>
Date: Mon, 24 Sep 2007 18:18:30 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [RFC][PATCH] mm: couple rcu and memory reclaim
References: <20070924104517.7d8126ae@twins> <46F7948B.7000802@linux.vnet.ibm.com> <20070924130616.4141a084@twins> <46F79DE7.40402@linux.vnet.ibm.com> <20070924135035.1e02d4fa@twins>
In-Reply-To: <20070924135035.1e02d4fa@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
>>> Only kswapd can do this, direct reclaim has deadlock potential.
>> Yes, but not in all cases, do you want to add any gfp_mask
>> based smartness for direct reclaim?
> 
> gfp_mask doesn't carry the needed information. It depends on whether
> the current context holds a rcu_read_lock().
> 

What I meant was that nobody would hold rcu_read_lock() and pass
gfp_mask of GFP_KERNEL in scan_control or to do_try_to_free_pages()

> so something like:
> 
>    rcu_read_lock()
>    foo = kmalloc(sizeof(foo))

At this point, you really can't use GFP_KERNEL, since rcu_read_lock()
disables pre-emption in the current kernel, ideally you should see
a might_sleep() BUG.

>       new_slab()
>         __alloc_pages()
>           try_to_free_pages()
>             synchronise_rcu() <-- deadlock
>    rcu_read_unlock()


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
