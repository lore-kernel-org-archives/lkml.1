Return-Path: <linux-kernel-owner+w=401wt.eu-S1762639AbZATU5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762639AbZATU5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 15:57:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757258AbZATU5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 15:57:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35304 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757353AbZATU5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 15:57:31 -0500
Date: Tue, 20 Jan 2009 21:56:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
       jeremy@xensource.com, chrisw@sous-sol.org, zach@vmware.com,
       rusty@rustcorp.com.au, Andrew Morton <akpm@linux-foundation.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: lmbench lat_mmap slowdown with CONFIG_PARAVIRT
Message-ID: <20090120205653.GA19710@elte.hu>
References: <20090120110542.GE19505@wotan.suse.de> <20090120112634.GA20858@elte.hu> <20090120140324.GA26424@elte.hu> <49763806.5090009@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49763806.5090009@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> * Ingo Molnar <mingo@elte.hu> wrote:
>>
>>   
>>>> Times I believe are in nanoseconds for lmbench, anyway lower is  
>>>> better.
>>>>
>>>> non pv   AVG=464.22 STD=5.56
>>>> paravirt AVG=502.87 STD=7.36
>>>>
>>>> Nearly 10% performance drop here, which is quite a bit... hopefully 
>>>> people are testing the speed of their PV implementations against  
>>>> non-PV bare metal :)
>>>>       
>>> Ouch, that looks unacceptably expensive. All the major distros turn  
>>> CONFIG_PARAVIRT on. paravirt_ops was introduced in x86 with the 
>>> express promise to have no measurable runtime overhead.
>>>     
>>
>> Here are some more precise stats done via hw counters on a perfcounters 
>> kernel using 'timec', running a modified version of the 'mmap 
>> performance stress-test' app i made years ago.
>>
>> The MM benchmark app can be downloaded from:
>>
>>    http://redhat.com/~mingo/misc/mmap-perf.c
>>
>> timec.c can be picked up from:
>>
>>    http://redhat.com/~mingo/perfcounters/timec.c
>>
>> mmap-perf conducts 1 million mmap()/munmap()/mremap() calls, and 
>> touches the mapped area as well with a certain chance. The patterns are 
>> pseudo-random and the random seed is initialized to the same value so  
>> repeated runs produce the exact same mmap sequence.
>>
>> I ran the test with a single thread and bound to a single core:
>>
>>   # taskset 2 timec -e -5,-4,-3,0,1,2,3 ./mmap-perf 1
>>
>> [ I ran it as root - so that kernel-space hardware-counter statistics 
>> are   included as well. ]
>>
>> The results are quite surprisingly candid about the true costs of  
>> paravirt_ops on the native kernel's overhead (CONFIG_PARAVIRT=y):
>>
>> -----------------------------------------------
>> | Performance counter stats for './mmap-perf' |
>> -----------------------------------------------
>> |                |
>> |  x86-defconfig |   PARAVIRT=y          
>> |------------------------------------------------------------------
>> |
>> |    1311.554526 |  1360.624932  task clock ticks (msecs)    +3.74%
>> |                |
>> |              1 |            1  CPU migrations
>> |             91 |           79  context switches
>> |          55945 |        55943  pagefaults
>> |    ............................................
>> |     3781392474 |   3918777174  CPU cycles                  +3.63%
>> |     1957153827 |   2161280486  instructions               +10.43%
>>   
>
> !!
>
>> |       50234816 |     51303520  cache references            +2.12%
>> |        5428258 |      5583728  cache misses                +2.86%
>>   
>
> Is this I or D, or combined?

That's last-level-cache references+misses (L2 cache):

 Bit Position Event Name                UMask Event Select
 CPUID.AH.EBX
 3            LLC Reference             4FH   2EH
 4            LLC Misses                41H   2EH

	Ingo
