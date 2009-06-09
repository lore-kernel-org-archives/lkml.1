Return-Path: <linux-kernel-owner+w=401wt.eu-S1752547AbZFIQoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbZFIQoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 12:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbZFIQoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 12:44:10 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54541 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbZFIQoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 12:44:09 -0400
Message-ID: <4A2E9157.2030108@linux.vnet.ibm.com>
Date: Tue, 09 Jun 2009 09:44:07 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Reply-To: cjashfor@linux.vnet.ibm.com
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf_counter: extensible perf_counter_attr
References: <1244481941.13761.9119.camel@twins> <4A2D6041.4050309@linux.vnet.ibm.com> <1244490680.6691.1.camel@laptop> <4A2D8011.9050502@linux.vnet.ibm.com> <1244496223.6691.2.camel@laptop> <4A2D82CE.9000206@linux.vnet.ibm.com> <20090608215002.GB22049@elte.hu> <4A2DB1C6.6090209@linux.vnet.ibm.com> <20090609065117.GA16707@elte.hu> <4A2E19A9.3070201@linux.vnet.ibm.com> <20090609115346.GB3062@elte.hu>
In-Reply-To: <20090609115346.GB3062@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your reply, Ingo.

Ingo Molnar wrote:
> I think PEBS is best supported by a generic abstraction. Something 
> like this: it's basically a special sampling format, that generates 
> a record of:
>
> 	struct pt_regs regs;
> 	__u64 insn_latency; /* optional */
> 	__u64 data_address; /* optional */
>
> this is pretty generic.
>
> The raw CPU records have a CPU specific format, and they have to be 
> demultiplexed anyway (on Nehalem, which can have up to four separate 
> PEBS counters - but each output into the same DS area), so the 
> lowlevel arch code converts the CPU record into the above generic 
> sample record when it copies it into the mmap pages. It's a quick 
> copy so no big deal performance-wise.
>
> ( Details:
>
>    - there might be some additional complications from sampling 
>      32-bit contexts, but that too is a mostly low level detail that 
>      gets hidden.
>
>    - we might use a tiny bit more compact registers structure than
>      struct pt_regs. OTOH it's a well-known structure so it makes 
>      sense to standardize on it, even if the CPU doesnt sample all 
>      registers.
> )
>
>   
I see, so that's how you'd return the data.  How would a user specify 
that they want to use PEBS?

Another observation is that you'd need some sort of bit vector, or at 
the least a document, that describes which registers are valid in the 
pt_regs struct.

> Can you see desirable PEBS-alike PMU features that cannot be 
> expressed via such means?
>
> 	Ingo
Power PMU's provide some fairly complex features, such as a thresholding 
mechanism which is used for marking instructions, and also there's an 
Instruction Matching CAM which can be used to mark only on certain 
instruction types.  Since these features are present only on Power, I'm 
not sure it makes sense to go to the trouble of abstracting them for use 
on other arch/chip designs.

- Corey
