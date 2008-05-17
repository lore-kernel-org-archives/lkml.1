Return-Path: <linux-kernel-owner+w=401wt.eu-S1755619AbYEQHgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619AbYEQHgu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 03:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbYEQHgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 03:36:40 -0400
Received: from smtp25.orange.fr ([193.252.22.21]:8105 "EHLO smtp25.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbYEQHgj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 03:36:39 -0400
X-ME-UUID: 20080517073637743.1221E1C00081@mwinf2536.orange.fr
Message-ID: <482E8AF5.9050804@cosmosbay.com>
Date: Sat, 17 May 2008 09:36:21 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] modules: Use a better scheme for refcounting
References: <482C9FC5.2070508@cosmosbay.com> <482D1BCE.3060501@cosmosbay.com> <482D8EFC.8040109@sgi.com> <200805171533.46295.rusty@rustcorp.com.au>
In-Reply-To: <200805171533.46295.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell a écrit :
> On Friday 16 May 2008 23:41:16 Mike Travis wrote:
>   
>> Eric Dumazet wrote:
>>     
>>> Rusty Russell a Ã©crit :
>>>       
>>>>    Any chance I can ask you look at the issue of full dynamic per-cpu
>>>> allocation?
>>>>         
>>> You mean using alloc_percpu() ? Problem is that current implementation
>>> is expensive,
>>>       
>
> I mean rewriting alloc_percpu :)
>
>   
>>> We probably can change this to dynamic per-cpu as soon as Mike or
>>> Christopher finish their work on new dynamic per-cpu implementation ?
>>>       
>> Yes, the zero-based percpu variables followed by the cpu_alloc patch should
>> provide this and shrink the code quite well, including in some cases
>> removing locking requirements (because the resultant instructions will be
>> atomic.)
>>     
>
> Ah, I hadn't realized that Mike was already working on this.  Mike, have you 
> published patches already?
>
>   
Christoph Lameter made good work last year and apparently the path is to :

1) Put pda at the begining of percpu section.
2) Relocate percpu variables to begin at zero
3) Use %gs (or %fs) register to address pda AND percpu section.
4) Reserve an appropriate large virtual zone into percpu section so that 
it can fullfill :
- percpu "static" allocations needed by module loader.
- per_cpu "dynamic" allocations
  (No more need for an array of pointers to find the address of dynamic 
per_cpu variable)
- Eventually allocates PAGES dynamically into this zone to satisfy any 
size of percpu needs.
(But with a limit of say 256 MB per cpu on x86_64)

Thats a lot of work and apparently Mike and Christoph are doing it.

Some pointers to previous work:

http://groups.google.pl/group/linux.kernel/browse_thread/thread/f2ff6901ca6ae9fc/b2ed3b7f3612a157?lnk=raot

http://kerneltrap.org/mailarchive/linux-kernel/2008/2/1/683104

http://linux.derkeiler.com/Mailing-Lists/Kernel/2008-01/msg09052.html




