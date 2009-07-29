Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084AbZG2HID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbZG2HID (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 03:08:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbZG2HID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 03:08:03 -0400
Received: from brick.kernel.dk ([93.163.65.50]:47543 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbZG2HIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 03:08:01 -0400
Date: Wed, 29 Jul 2009 09:08:01 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] generic-ipi: make struct call_function_data lockless
Message-ID: <20090729070801.GH4148@kernel.dk>
References: <4A6983D8.8090805@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A6983D8.8090805@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24 2009, Xiao Guangrong wrote:
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

Very nice, looks good to me! Tested on x86-64 and sparc64 here.
Andrew, shall I include it, or shall we just let it funnel through
your patch stream?

Acked-by: Jens Axboe <jens.axboe@oracle.com>

-- 
Jens Axboe

