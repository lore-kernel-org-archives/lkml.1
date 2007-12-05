Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbXLERsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbXLERsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 12:48:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbXLERsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 12:48:05 -0500
Received: from ccs17.jlab.org ([129.57.35.82]:57697 "EHLO ccs17.jlab.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbXLERsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 12:48:04 -0500
Message-ID: <4756E44E.8080607@jlab.org>
Date: Wed, 05 Dec 2007 12:47:58 -0500
From: Jie Chen <chen@jlab.org>
Organization: Jefferson Lab
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Simon Holm Th??gersen <odie@cs.aau.dk>, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Possible bug from kernel 2.6.22 and above, 2.6.24-rc4
References: <4744966C.900@jlab.org> <4744ADA9.7040905@cosmosbay.com> <4744E0DC.7050808@jlab.org> <1195698770.11808.4.camel@odie.local> <4744F042.4070002@jlab.org> <20071204131707.GA4232@elte.hu> <4756C3D9.9030107@jlab.org> <20071205154014.GA6491@elte.hu> <4756D058.1070500@jlab.org> <20071205164723.GA25641@elte.hu>
In-Reply-To: <20071205164723.GA25641@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jie Chen <chen@jlab.org> wrote:
> 
>>> the moment you saturate the system a bit more, the numbers should 
>>> improve even with such a ping-pong test.
>> You are right. If I manually do load balance (bind unrelated processes 
>> on the other cores), my test code perform as well as it did in the 
>> kernel 2.6.21.
> 
> so right now the results dont seem to be too bad to me - the higher 
> overhead comes from two threads running on two different cores and 
> incurring the overhead of cross-core communications. In a true 
> spread-out workloads that synchronize occasionally you'd get the same 
> kind of overhead so in fact this behavior is more informative of the 
> real overhead i guess. In 2.6.21 the two threads would stick on the same 
> core and produce artificially low latency - which would only be true in 
> a real spread-out workload if all tasks ran on the same core. (which is 
> hardly the thing you want on openmp)
> 

I use pthread_setaffinity_np call to bind one thread to one core. Unless 
  the kernel 2.6.21 does not honor the affinity, I do not see the 
difference running two threads on two cores between the new kernel and 
the old kernel. My test code does not do any numerical calculation, but 
it does spin waiting on shared/non-shared flags. The reason I am using 
the affinity is to test synchronization overheads among different cores.
In either the new and the old kernel, I do see 200% CPU usage when I ran 
my test code for two threads. Does this mean two threads are running on 
two cores? Also I verify a thread is indeed bound to a core by using 
pthread_getaffinity_np.

> In any case, if i misinterpreted your numbers or if you just disagree, 
> or if have a workload/test that shows worse performance that it 
> could/should, let me know.
> 
> 	Ingo

Hi, Ingo:

Since I am using affinity flag to bind each thread to a different core, 
the synchronization overhead should increases as the number of 
cores/threads increases. But what we observed in the new kernel is the 
opposite. The barrier overhead of two threads is 8.93 micro seconds vs 
1.86 microseconds for 8 threads (the old kernel is 0.49 vs 1.86). This 
will confuse most of people who study the synchronization/communication 
scalability. I know my test code is not real-world computation which 
usually use up all cores. I hope I have explained myself clearly. Thank 
you very much.

-- 
###############################################
Jie Chen
Scientific Computing Group
Thomas Jefferson National Accelerator Facility
12000, Jefferson Ave.
Newport News, VA 23606

(757)269-5046 (office) (757)269-6248 (fax)
chen@jlab.org
###############################################

