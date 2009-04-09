Return-Path: <linux-kernel-owner+w=401wt.eu-S936393AbZDIV3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936393AbZDIV3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 17:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762102AbZDIV3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 17:29:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47635
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761612AbZDIV3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 17:29:32 -0400
Date: Thu, 09 Apr 2009 14:29:23 -0700 (PDT)
Message-Id: <20090409.142923.252620650.davem@davemloft.net>
To: tj@kernel.org
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12]: sparc64: Use new dynamic per-cpu allocator.
From: David Miller <davem@davemloft.net>
In-Reply-To: <49DDE07C.8050101@kernel.org>
References: <20090408.223758.81953207.davem@davemloft.net>
	<49DDE07C.8050101@kernel.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Thu, 09 Apr 2009 04:48:12 -0700

> 
> David Miller wrote:
>>  void __init setup_per_cpu_areas(void)
>>  {
>> -	unsigned long size, i, nr_possible_cpus = num_possible_cpus();
>> -	char *ptr;
>> +	size_t dyn_size, static_size = __per_cpu_end - __per_cpu_start;
>> +	static struct vm_struct vm;
>> +	unsigned long delta, cpu;
>> +	size_t pcpu_unit_size;
>> +	size_t ptrs_size;
>> +
>> +	pcpur_size = PFN_ALIGN(static_size + PERCPU_MODULE_RESERVE +
>> +			       PERCPU_DYNAMIC_RESERVE);
>> +	dyn_size = pcpur_size - static_size - PERCPU_MODULE_RESERVE;
> 
> Isn't it better to use embedding allocator for !NUMA cases (one less
> TLB entry usage for each CPU)?

Heck, the embedding case would probably be optimal for Niagara NUMA
systems too.

On Niagara systems all of the "possible" cpu numbers are linear and in
order.  No holes, gaps, or other stuff like this.  So just allocating
big TLB mapping chunks and chopping them up to the individual cpus is
the best scheme possible.

Indeed, these are the kinds of things I plan to experiment with.
