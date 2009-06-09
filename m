Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbZFIXQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbZFIXQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 19:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbZFIXQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 19:16:49 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:46860 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbZFIXQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 19:16:48 -0400
Message-ID: <4A2EED64.9070605@linux.vnet.ibm.com>
Date: Tue, 09 Jun 2009 16:16:52 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf_counter: extensible perf_counter_attr
References: <1244490680.6691.1.camel@laptop> <4A2D8011.9050502@linux.vnet.ibm.com> <1244496223.6691.2.camel@laptop> <4A2D82CE.9000206@linux.vnet.ibm.com> <20090608215002.GB22049@elte.hu> <4A2DB1C6.6090209@linux.vnet.ibm.com> <20090609065117.GA16707@elte.hu> <4A2E19A9.3070201@linux.vnet.ibm.com> <20090609115346.GB3062@elte.hu> <4A2E9157.2030108@linux.vnet.ibm.com> <20090609220020.GA26526@elte.hu>
In-Reply-To: <20090609220020.GA26526@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:
> * Corey Ashford <cjashfor@linux.vnet.ibm.com> wrote:
> 
>> Thanks for your reply, Ingo.
>>
>> Ingo Molnar wrote:
>>> I think PEBS is best supported by a generic abstraction. Something  
>>> like this: it's basically a special sampling format, that generates a 
>>> record of:
>>>
>>> 	struct pt_regs regs;
>>> 	__u64 insn_latency; /* optional */
>>> 	__u64 data_address; /* optional */
>>>
>>> this is pretty generic.
>>>
>>> The raw CPU records have a CPU specific format, and they have to be  
>>> demultiplexed anyway (on Nehalem, which can have up to four separate  
>>> PEBS counters - but each output into the same DS area), so the  
>>> lowlevel arch code converts the CPU record into the above generic  
>>> sample record when it copies it into the mmap pages. It's a quick copy 
>>> so no big deal performance-wise.
>>>
>>> ( Details:
>>>
>>>    - there might be some additional complications from sampling      
>>> 32-bit contexts, but that too is a mostly low level detail that      
>>> gets hidden.
>>>
>>>    - we might use a tiny bit more compact registers structure than
>>>      struct pt_regs. OTOH it's a well-known structure so it makes      
>>> sense to standardize on it, even if the CPU doesnt sample all      
>>> registers.
>>> )
>>>
>>>   
>> I see, so that's how you'd return the data.  How would a user 
>> specify that they want to use PEBS?
> 
> They wouldnt need to. PEBS would result in more precise samples when 
> certain counters are used - and transparently so.
> 
> The non-PEBS NMI samples are pretty accurate to begin with, so it's 
> not a _major_ difference in quality.
> 
> PEBS would also auto-activate when a user wants to sample say the 
> instruction latency as well - and on non-PEBS hardware the platform 
> code would refuse to open the counter.
> 
> PEBS could also be used to reduce the number of NMIs needed - so 
> it's a transparent speedup as well.
> 
>> Another observation is that you'd need some sort of bit vector, or 
>> at the least a document, that describes which registers are valid 
>> in the pt_regs struct.
> 
> Initially i think we should use PEBS to transparently enhance 
> regular IP samples.
> 
> What would we use the other registers for? Many registers will have 
> stack context dependencies so the PEBS data cannot really be 
> analyzed in any meaningful way after the fact.

Well, you were the one that offered up the idea of using pt_regs as an 
abstraction.  For the case of PEBS, I think 98% of it would be emptry since the 
sampling mechanism can get a PC and maybe a data address (?).

> 
> (except perhaps for the narrow purpose of debugging)
> 
>>> Can you see desirable PEBS-alike PMU features that cannot be expressed 
>>> via such means?
>> Power PMU's provide some fairly complex features, such as a 
>> thresholding mechanism which is used for marking instructions, and 
>> also there's an Instruction Matching CAM which can be used to mark 
>> only on certain instruction types.  Since these features are 
>> present only on Power, I'm not sure it makes sense to go to the 
>> trouble of abstracting them for use on other arch/chip designs.
> 
> Could you please describe the low level semantics more accurately - 
> at least of the ones you find to be the most useful in practice?

Ok, some disclosure here: we have not yet supported either of these features in 
the Power PMU's in any open source code (and perhaps the proprietary code too, 
but I don't know about that).  Since these features are described in an IBM 
proprietary document, I can't describe how they work here, except to say that 
they are present in the chip.

I realize this is not very useful to come here and complain there's no support 
for something I can't describe!  (maybe later or maybe never... not sure)

But in general I do think there should be some sort of provision in the 
interface for some chip-specific features for which fully abstracting their 
function doesn't make a lot of sense.  At some point, if we find that there's a 
good reason to support these features in open source code (and thereby divulging 
how they work), it would be nice if there was an avenue for adding such support 
to PCL.

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
cjashfor@us.ibm.com

