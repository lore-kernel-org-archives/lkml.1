Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035Ab0BRAlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 19:41:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:51690 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757979Ab0BRAl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 19:41:28 -0500
Message-ID: <4B7C8E84.2030701@kernel.org>
Date: Thu, 18 Feb 2010 09:49:08 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH hw_breakpoint] percpu: add __percpu sparse annotations
 to hw_breakpoint
References: <4B7B4B7A.9050902@kernel.org> <20100217163944.GC5041@nowhere>
In-Reply-To: <20100217163944.GC5041@nowhere>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Feb 2010 00:40:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/18/2010 01:39 AM, Frederic Weisbecker wrote:
> On Wed, Feb 17, 2010 at 10:50:50AM +0900, Tejun Heo wrote:
> Yeah, looks good, I'm queuing it.
> Just few comments below, for nano-considerations.
>>  	cpu_events = alloc_percpu(typeof(*cpu_events));
>>  	if (!cpu_events)
>> -		return ERR_PTR(-ENOMEM);
>> +		return (void __percpu __force *)ERR_PTR(-ENOMEM);
> 
> Is this pattern common enough that we can think about a ERR_CPU_PTR ?

I thought about that but there aren't too many yet, so I just added
the ugly castings.  It would be cool if sparse can be taught that
ERR_PTR() returns universal pseudo pointer.

>>  	sample_hbp = register_wide_hw_breakpoint(&attr, sample_hbp_handler);
>> -	if (IS_ERR(sample_hbp)) {
>> -		ret = PTR_ERR(sample_hbp);
>> +	if (IS_ERR((void __force *)sample_hbp)) {
>> +		ret = PTR_ERR((void __force *)sample_hbp);
> 
> Same comments here, although I wouldn't like much a CPU_PTR_ERR or
> IS_ERR_CPU.... CPP is just so poor in magic for that.
> 
> I must confess I miss a bit the old per_cpu prefix that guarded the implicit
> separate namespace.

Yeap, I agree that the prefix had its advantages.  It's just that it
can't scale to the new situation where static and dynamic percpu
variables behave uniformly.

Thank you.

-- 
tejun
