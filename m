Return-Path: <linux-kernel-owner+w=401wt.eu-S1760570AbZFIWAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760570AbZFIWAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 18:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756063AbZFIWAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 18:00:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54478 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755785AbZFIWAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 18:00:41 -0400
Date: Wed, 10 Jun 2009 00:00:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf_counter: extensible perf_counter_attr
Message-ID: <20090609220020.GA26526@elte.hu>
References: <1244490680.6691.1.camel@laptop> <4A2D8011.9050502@linux.vnet.ibm.com> <1244496223.6691.2.camel@laptop> <4A2D82CE.9000206@linux.vnet.ibm.com> <20090608215002.GB22049@elte.hu> <4A2DB1C6.6090209@linux.vnet.ibm.com> <20090609065117.GA16707@elte.hu> <4A2E19A9.3070201@linux.vnet.ibm.com> <20090609115346.GB3062@elte.hu> <4A2E9157.2030108@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2E9157.2030108@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Corey Ashford <cjashfor@linux.vnet.ibm.com> wrote:

> Thanks for your reply, Ingo.
>
> Ingo Molnar wrote:
>> I think PEBS is best supported by a generic abstraction. Something  
>> like this: it's basically a special sampling format, that generates a 
>> record of:
>>
>> 	struct pt_regs regs;
>> 	__u64 insn_latency; /* optional */
>> 	__u64 data_address; /* optional */
>>
>> this is pretty generic.
>>
>> The raw CPU records have a CPU specific format, and they have to be  
>> demultiplexed anyway (on Nehalem, which can have up to four separate  
>> PEBS counters - but each output into the same DS area), so the  
>> lowlevel arch code converts the CPU record into the above generic  
>> sample record when it copies it into the mmap pages. It's a quick copy 
>> so no big deal performance-wise.
>>
>> ( Details:
>>
>>    - there might be some additional complications from sampling      
>> 32-bit contexts, but that too is a mostly low level detail that      
>> gets hidden.
>>
>>    - we might use a tiny bit more compact registers structure than
>>      struct pt_regs. OTOH it's a well-known structure so it makes      
>> sense to standardize on it, even if the CPU doesnt sample all      
>> registers.
>> )
>>
>>   
> I see, so that's how you'd return the data.  How would a user 
> specify that they want to use PEBS?

They wouldnt need to. PEBS would result in more precise samples when 
certain counters are used - and transparently so.

The non-PEBS NMI samples are pretty accurate to begin with, so it's 
not a _major_ difference in quality.

PEBS would also auto-activate when a user wants to sample say the 
instruction latency as well - and on non-PEBS hardware the platform 
code would refuse to open the counter.

PEBS could also be used to reduce the number of NMIs needed - so 
it's a transparent speedup as well.

> Another observation is that you'd need some sort of bit vector, or 
> at the least a document, that describes which registers are valid 
> in the pt_regs struct.

Initially i think we should use PEBS to transparently enhance 
regular IP samples.

What would we use the other registers for? Many registers will have 
stack context dependencies so the PEBS data cannot really be 
analyzed in any meaningful way after the fact.

(except perhaps for the narrow purpose of debugging)

>> Can you see desirable PEBS-alike PMU features that cannot be expressed 
>> via such means?
>
> Power PMU's provide some fairly complex features, such as a 
> thresholding mechanism which is used for marking instructions, and 
> also there's an Instruction Matching CAM which can be used to mark 
> only on certain instruction types.  Since these features are 
> present only on Power, I'm not sure it makes sense to go to the 
> trouble of abstracting them for use on other arch/chip designs.

Could you please describe the low level semantics more accurately - 
at least of the ones you find to be the most useful in practice?

	Ingo
