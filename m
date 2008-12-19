Return-Path: <linux-kernel-owner+w=401wt.eu-S1752869AbYLSQyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbYLSQyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 11:54:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbYLSQym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 11:54:42 -0500
Received: from relay3.sgi.com ([192.48.171.31]:57100 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751310AbYLSQym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 11:54:42 -0500
Message-ID: <494BD1D0.5080201@sgi.com>
Date: Fri, 19 Dec 2008 08:54:40 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] cpumask: convert kernel trace functions
References: <20081219160144.697518000@polaris-admin.engr.sgi.com> <20081219160145.272814000@polaris-admin.engr.sgi.com> <alpine.DEB.1.10.0812191114070.28744@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0812191114070.28744@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Fri, 19 Dec 2008, Mike Travis wrote:
> 
>> Impact: Reduce memory usage, use new cpumask API.
>>
>> Convert kernel trace functions to use struct cpumask.
>>
> 
> [..]
> 
>>  #define for_each_buffer_cpu(buffer, cpu)		\
>> -	for_each_cpu_mask(cpu, buffer->cpumask)
>> +	for_each_cpu(cpu, buffer->cpumask)
>>  
>>  #define TS_SHIFT	27
>>  #define TS_MASK		((1ULL << TS_SHIFT) - 1)
>> @@ -262,7 +262,7 @@ struct ring_buffer {
>>  	unsigned			pages;
>>  	unsigned			flags;
>>  	int				cpus;
>> -	cpumask_t			cpumask;
>> +	cpumask_var_t			cpumask;
>>  	atomic_t			record_disabled;
>>  
>>  	struct mutex			mutex;
>> @@ -453,6 +453,9 @@ struct ring_buffer *ring_buffer_alloc(un
>>  	if (!buffer)
>>  		return NULL;
>>  
>> +	if (!alloc_cpumask_var(&buffer->cpumask, GFP_KERNEL))
>> +		goto fail_free_buffer;
>> +
> 
> 
> How does this save memory if we just allocate a cpumask var everytime
> we allocate a ring buffer?  Is cpumask_var_t a mask of possible CPUS and 
> not NR_CPUS?
> 
> Otherwise, I see this as just adding one extra pointer.
> 
> -- Steve

Hi Steve,

Yes, eventually, the cpumask_var_t will be allocated based on cpumask_size()
which will become BITS_TO_LONG(nr_cpu_ids) instead of BITS_TO_LONGS(NR_CPUS)
as soon as the kernel becomes "cpumask" clean.  (clean being that it ignores
all bits >= nr_cpu_ids.)

Note that on small NR_CPUS count systems, cpumask_var_t is a static array
and no allocation happens, so it only kicks in when CONFIG_CPUMASK_OFFSTACK=y.

Thanks,
Mike
