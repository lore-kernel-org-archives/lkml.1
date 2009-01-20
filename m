Return-Path: <linux-kernel-owner+w=401wt.eu-S1760316AbZATUqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760316AbZATUqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 15:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480AbZATUqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 15:46:07 -0500
Received: from gw.goop.org ([64.81.55.164]:54641 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753423AbZATUqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 15:46:06 -0500
Message-ID: <49763806.5090009@goop.org>
Date: Tue, 20 Jan 2009 12:45:58 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
       jeremy@xensource.com, chrisw@sous-sol.org, zach@vmware.com,
       rusty@rustcorp.com.au, Andrew Morton <akpm@linux-foundation.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: lmbench lat_mmap slowdown with CONFIG_PARAVIRT
References: <20090120110542.GE19505@wotan.suse.de> <20090120112634.GA20858@elte.hu> <20090120140324.GA26424@elte.hu>
In-Reply-To: <20090120140324.GA26424@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>   
>>> Times I believe are in nanoseconds for lmbench, anyway lower is 
>>> better.
>>>
>>> non pv   AVG=464.22 STD=5.56
>>> paravirt AVG=502.87 STD=7.36
>>>
>>> Nearly 10% performance drop here, which is quite a bit... hopefully 
>>> people are testing the speed of their PV implementations against 
>>> non-PV bare metal :)
>>>       
>> Ouch, that looks unacceptably expensive. All the major distros turn 
>> CONFIG_PARAVIRT on. paravirt_ops was introduced in x86 with the express 
>> promise to have no measurable runtime overhead.
>>     
>
> Here are some more precise stats done via hw counters on a perfcounters 
> kernel using 'timec', running a modified version of the 'mmap performance 
> stress-test' app i made years ago.
>
> The MM benchmark app can be downloaded from:
>
>    http://redhat.com/~mingo/misc/mmap-perf.c
>
> timec.c can be picked up from:
>
>    http://redhat.com/~mingo/perfcounters/timec.c
>
> mmap-perf conducts 1 million mmap()/munmap()/mremap() calls, and touches 
> the mapped area as well with a certain chance. The patterns are 
> pseudo-random and the random seed is initialized to the same value so 
> repeated runs produce the exact same mmap sequence.
>
> I ran the test with a single thread and bound to a single core:
>
>   # taskset 2 timec -e -5,-4,-3,0,1,2,3 ./mmap-perf 1
>
> [ I ran it as root - so that kernel-space hardware-counter statistics are 
>   included as well. ]
>
> The results are quite surprisingly candid about the true costs of 
> paravirt_ops on the native kernel's overhead (CONFIG_PARAVIRT=y):
>
> -----------------------------------------------
> | Performance counter stats for './mmap-perf' |
> -----------------------------------------------
> |                |
> |  x86-defconfig |   PARAVIRT=y         
> |------------------------------------------------------------------
> |
> |    1311.554526 |  1360.624932  task clock ticks (msecs)    +3.74%
> |                |
> |              1 |            1  CPU migrations
> |             91 |           79  context switches
> |          55945 |        55943  pagefaults
> |    ............................................
> |     3781392474 |   3918777174  CPU cycles                  +3.63%
> |     1957153827 |   2161280486  instructions               +10.43%
>   

!!

> |       50234816 |     51303520  cache references            +2.12%
> |        5428258 |      5583728  cache misses                +2.86%
>   

Is this I or D, or combined?

> |                |
> |    1314.782469 |  1363.694447  time elapsed (msecs)        +3.72%
> |                |
> -----------------------------------
>
> The most surprising element is that in the paravirt_ops case we run 204 
> million more instructions - out of the ~2000 million instructions total. 
>
> That's an increase of over 10%!
>   

Yow!  That's pretty awful.  We knew that static instruction count was 
up, but wouldn't have thought that it would hit the dynamic instruction 
count so much...

I think there are some immediate tweaks we can make to the code 
generated for each call site,  which will help to an extent.

    J
