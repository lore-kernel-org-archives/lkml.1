Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbZG0WB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbZG0WB2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 18:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbZG0WB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 18:01:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45043 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751110AbZG0WB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 18:01:27 -0400
Date: Mon, 27 Jul 2009 15:00:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: mingo@elte.hu, jens.axboe@oracle.com, nickpiggin@yahoo.com.au,
       peterz@infradead.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] generic-ipi: make struct call_function_data lockless
Message-Id: <20090727150027.20d60f0a.akpm@linux-foundation.org>
In-Reply-To: <4A6983D8.8090805@cn.fujitsu.com>
References: <4A6983D8.8090805@cn.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jul 2009 17:50:16 +0800
Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:

> This patch can remove spinlock from struct call_function_data, the 
> reasons are below:
> 
> 1: add a new interface for cpumask named cpumask_test_and_clear_cpu(),
>    it can atomically test and clear specific cpu, we can use it instead
>    of cpumask_test_cpu() and cpumask_clear_cpu() and no need data->lock
>    to protect those in generic_smp_call_function_interrupt().
> 
> 2: in smp_call_function_many(), after csd_lock() return, the current's
>    cfd_data is deleted from call_function list, so it not have race
>    between other cpus, then cfs_data is only used in
>    smp_call_function_many() that must disable preemption and not from
>    a hardware interrupthandler or from a bottom half handler to call,
>    only the correspond cpu can use it, so it not have race in current
>    cpu, no need cfs_data->lock to protect it.
> 
> 3: after 1 and 2, cfs_data->lock is only use to protect cfs_data->refs in
>    generic_smp_call_function_interrupt(), so we can define cfs_data->refs
>    to atomic_t, and no need cfs_data->lock any more.

Looks good to me.  One tiny cleanup:

--- a/kernel/smp.c~generic-ipi-make-struct-call_function_data-lockless-cleanup
+++ a/kernel/smp.c
@@ -193,7 +193,7 @@ void generic_smp_call_function_interrupt
 
 		data->csd.func(data->csd.info);
 
-		refs = atomic_sub_return(1, &data->refs);
+		refs = atomic_dec_return(&data->refs);
 		WARN_ON(refs < 0);
 		if (!refs) {
 			spin_lock(&call_function.lock);
_


