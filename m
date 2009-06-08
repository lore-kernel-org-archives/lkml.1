Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbZFHI0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbZFHI0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 04:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbZFHI0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 04:26:06 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:54318 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbZFHI0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 04:26:04 -0400
Message-ID: <4A2CCAD1.6020802@linux.vnet.ibm.com>
Date: Mon, 08 Jun 2009 10:24:49 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: michaele@au1.ibm.com, Andrew Morton <akpm@linux-foundation.org>
CC: Amerigo Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, ying.huang@intel.com, W.Li@Sun.COM, mingo@elte.hu,
       heicars2@linux.vnet.ibm.com, mschwid2@linux.vnet.ibm.com
Subject: Re: [PATCH 3/4] gcov: add gcov profiling infrastructure
References: <20090602114359.129247921@linux.vnet.ibm.com> <20090602114402.951631599@linux.vnet.ibm.com> <20090602150324.c706b1d2.akpm@linux-foundation.org> <4A266546.5080601@linux.vnet.ibm.com>	<4A26961E.7040207@linux.vnet.ibm.com> <20090604090839.GB7030@cr0.nay.redhat.com> <4A28E3F8.5050908@linux.vnet.ibm.com> <20090605023434.8a49d673.akpm@linux-foundation.org> <4A28EF7D.5030704@linux.vnet.ibm.com> <1244277057.4277.7.camel@concordia>
In-Reply-To: <1244277057.4277.7.camel@concordia>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman wrote:
> On Fri, 2009-06-05 at 12:12 +0200, Peter Oberparleiter wrote:
>> Andrew Morton wrote:
>>> On Fri, 05 Jun 2009 11:23:04 +0200 Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:
>>>
>>>> Amerigo Wang wrote:
>>>>> On Wed, Jun 03, 2009 at 05:26:22PM +0200, Peter Oberparleiter wrote:
>>>>>> Peter Oberparleiter wrote:
>>>>>>> Andrew Morton wrote:
>>>>>>>> On Tue, 02 Jun 2009 13:44:02 +0200
>>>>>>>> Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:
>>>>>>>>> +	/* Duplicate gcov_info. */
>>>>>>>>> +	active = num_counter_active(info);
>>>>>>>>> +	dup = kzalloc(sizeof(struct gcov_info) +
>>>>>>>>> +		      sizeof(struct gcov_ctr_info) * active, GFP_KERNEL);
>>>>>>>> How large can this allocation be?
>>>>>>> Hm, good question. Having a look at my test system, I see coverage data 
>>>>>>> files of up to 60kb size. With counters making up the largest part of 
>>>>>>> those, I'd guess the allocation size can be around ~55kb. I assume that 
>>>>>>> makes it a candidate for vmalloc?
>>>>>> A further run with debug output showed that the maximum size is
>>>>>> actually around 4k, so in my opinion, there is no need to switch
>>>>>> to vmalloc.
>>>>> Unless you want virtually continious memory, you don't need to
>>>>> bother vmalloc().
>>>>>
>>>>> kmalloc() and get_free_pages() are all fine for this.
>>>> kmalloc() requires contiguous pages to serve an allocation request 
>>>> larger than a single page. The longer a kernel runs, the more fragmented 
>>>> the pool of free pages gets and the probability to find enough 
>>>> contiguous free pages is significantly reduced.
>>>>
>>>> In this case (having had a 3rd look), I found allocations of up to 
>>>> ~50kb, so to be sure, I'll switch that particular allocation to vmalloc().
>>> Well, vmalloc() isn't magic.  It can suffer internal fragmentation of
>>> the fixed-sized virtual address arena.
>>>
>>> Is it possible to redo the data structures so that the large array
>>> isn't needed?  Use a list, or move the data elsewhere or such?
>> Unfortunately not - the format of the data is dictated by gcc. Any 
>> attempt to break it down into page-sized chunks would only imitate what 
>> vmalloc() already does.
>>
>> Note though that this function is not called very often - it's only used 
>> to preserve coverage data for modules which are unloaded. And I only saw 
>> the 50kb counter data size for one file: kernel/sched.c (using a 
>> debugging patch).
> 
> Isn't it also called from gcov_seq_open() ?

Duh, of course - I totally forgot about that one. It used to be on 
module unload only but is, as you rightly pointed out, now basically 
called every time a coverage file is opened.

> 
>> So hm, I'm not sure about this anymore. I can also leave it at kmalloc() 
>> - chances are slim that anyone will actually experience a problem and if 
>> they do, they get an "order-n allocation failed" message so theres a 
>> hint at the cause for the problem.
> 
> Why are we duping it anyway? Rather than allocating it in the beginning,
> is it because gcc-generated code is writing directly to the original
> copy?

Yes - gcc's profiling code is writing to the original data structure. 
We're duping it on open() so that
a) data is consistent across reads() from the same file description
b) a non-vetoable module unload does not leave us with a defunct file 
descriptor

> 
> If there's any chance of memory allocation failure it'd be preferable
> for it to happen before the test run that generates the coverage data,
> that way you know before hand that you are out of memory. Rather than
> running some (possibly long & involved) test case, and then losing all
> your data.
> 

I agree - though I would not want to artificially limit the number of 
times a coverage file can be opened concurrently (which would need to be 
done in case of pre-allocation). If, after a long and difficult test 
you're running out of memory while collecting coverage data, you could 
try to free up some memory manually. Alternatively, assuming that the 
gcov-kdump tool will be ported to the upstream version as well, you 
could then create a kernel dump and extract coverage information from that.

So even with vmalloc() not being a perfect solution, it should reduce 
the number of allocation failures that might be seen after long running 
test cases and is therefore the method of choice.

===================
Subject: gcov: use vmalloc for duplicating counter data

From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>

Coverage data is duplicated during each open() of a data file and when
modules are unloaded. The contained data areas can get large (>50 kb)
so that kmalloc()-based allocations may fail due to memory
fragmentation, especially when a system has run for a long time. As
we only need virtually contiguous memory for the duplicate, the use
of vmalloc() can help prevent this problem.

Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
---
 kernel/gcov/gcc_3_4.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6.30-rc8-mm1/kernel/gcov/gcc_3_4.c
===================================================================
--- linux-2.6.30-rc8-mm1.orig/kernel/gcov/gcc_3_4.c
+++ linux-2.6.30-rc8-mm1/kernel/gcov/gcc_3_4.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/seq_file.h>
+#include <linux/vmalloc.h>
 #include "gcov.h"
 
 /* Symbolic links to be created for each profiling data file. */
@@ -152,9 +153,10 @@ struct gcov_info *gcov_info_dup(struct g
 
 		dup->counts[i].num = ctr->num;
 		dup->counts[i].merge = ctr->merge;
-		dup->counts[i].values = kmemdup(ctr->values, size, GFP_KERNEL);
+		dup->counts[i].values = vmalloc(size);
 		if (!dup->counts[i].values)
 			goto err_free;
+		memcpy(dup->counts[i].values, ctr->values, size);
 	}
 	return dup;
 
@@ -173,7 +175,7 @@ void gcov_info_free(struct gcov_info *in
 	unsigned int i;
 
 	for (i = 0; i < active ; i++)
-		kfree(info->counts[i].values);
+		vfree(info->counts[i].values);
 	kfree(info->functions);
 	kfree(info->filename);
 	kfree(info);

