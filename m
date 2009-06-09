Return-Path: <linux-kernel-owner+w=401wt.eu-S1757820AbZFILyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820AbZFILyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 07:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755035AbZFILyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 07:54:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40660 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978AbZFILyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 07:54:04 -0400
Date: Tue, 9 Jun 2009 13:53:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf_counter: extensible perf_counter_attr
Message-ID: <20090609115346.GB3062@elte.hu>
References: <1244481941.13761.9119.camel@twins> <4A2D6041.4050309@linux.vnet.ibm.com> <1244490680.6691.1.camel@laptop> <4A2D8011.9050502@linux.vnet.ibm.com> <1244496223.6691.2.camel@laptop> <4A2D82CE.9000206@linux.vnet.ibm.com> <20090608215002.GB22049@elte.hu> <4A2DB1C6.6090209@linux.vnet.ibm.com> <20090609065117.GA16707@elte.hu> <4A2E19A9.3070201@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2E19A9.3070201@linux.vnet.ibm.com>
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

>> So 'arch dependent attributes' per se are bad and against the 
>> perfcounters design. "Generic perfcounter feature only supported 
>> by a single architecture initially" is better.
>   
> Well, I think Intel has PEBS and AMD has some similar mechanism.  
> I would guess that at some point you would want to provide access 
> to those PMU features via these attributes.  Since these 
> mechanisms are very chip-specific, I don't think you would want to 
> try to create an arch-independent interface to them.  There may be 
> future mechanisms that only make sense on one particular chip 
> design, and would therefore not be a candidate for wider use, but 
> would still make sense to provide some support for that mechanism 
> via the attributes.
>
> Did you have some different plan for PEBS (etc.) ?

I think PEBS is best supported by a generic abstraction. Something 
like this: it's basically a special sampling format, that generates 
a record of:

	struct pt_regs regs;
	__u64 insn_latency; /* optional */
	__u64 data_address; /* optional */

this is pretty generic.

The raw CPU records have a CPU specific format, and they have to be 
demultiplexed anyway (on Nehalem, which can have up to four separate 
PEBS counters - but each output into the same DS area), so the 
lowlevel arch code converts the CPU record into the above generic 
sample record when it copies it into the mmap pages. It's a quick 
copy so no big deal performance-wise.

( Details:

   - there might be some additional complications from sampling 
     32-bit contexts, but that too is a mostly low level detail that 
     gets hidden.

   - we might use a tiny bit more compact registers structure than
     struct pt_regs. OTOH it's a well-known structure so it makes 
     sense to standardize on it, even if the CPU doesnt sample all 
     registers.
)

Can you see desirable PEBS-alike PMU features that cannot be 
expressed via such means?

	Ingo
