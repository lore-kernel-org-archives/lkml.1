Return-Path: <linux-kernel-owner+w=401wt.eu-S1761389AbXHXQUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761389AbXHXQUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 12:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756946AbXHXQTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 12:19:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:7467 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756646AbXHXQTu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 12:19:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,305,1183359600"; 
   d="scan'208";a="283429047"
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [PATCH] i386: Fix a couple busy loops in mach_wakecpu.h:wait_for_init_deassert()
Date: Fri, 24 Aug 2007 09:19:47 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A023EB8FB@scsmsx411.amr.corp.intel.com>
In-reply-to: <200708241259.33659.vda.linux@googlemail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] i386: Fix a couple busy loops in mach_wakecpu.h:wait_for_init_deassert()
Thread-Index: AcfmRlb48uQPXHOXSlajn+/gvFRV/gAIveXw
References: <46C2350A.1010807@redhat.com> <20070815081841.GA16551@osiris.boeblingen.de.ibm.com> <alpine.LFD.0.999.0708160606580.24380@enigma.security.iitk.ac.in> <200708241259.33659.vda.linux@googlemail.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Denys Vlasenko" <vda.linux@googlemail.com>,
       "Satyam Sharma" <satyam@infradead.org>
Cc: "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Herbert Xu" <herbert@gondor.apana.org.au>,
       "Chris Snook" <csnook@redhat.com>, <clameter@sgi.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       <linux-arch@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       <netdev@vger.kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>,
       <ak@suse.de>, <davem@davemloft.net>, <schwidefsky@de.ibm.com>,
       <wensong@linux-vs.org>, <horms@verge.net.au>, <wjiang@resilience.com>,
       <cfriesen@nortel.com>, <zlynx@acm.org>, <rpjday@mindspring.com>,
       <jesper.juhl@gmail.com>, <segher@kernel.crashing.org>
X-OriginalArrivalTime: 24 Aug 2007 16:19:48.0201 (UTC) FILETIME=[9742D590:01C7E66A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>  static inline void wait_for_init_deassert(atomic_t *deassert)
>>  {
>> -	while (!atomic_read(deassert));
>> +	while (!atomic_read(deassert))
>> +		cpu_relax();
>>  	return;
>>  }
>
> For less-than-briliant people like me, it's totally non-obvious that
> cpu_relax() is needed for correctness here, not just to make P4 happy.

Not just P4 ... there are other threaded cpus where it is useful to
let the core know that this is a busy loop so it would be a good thing
to let other threads have priority.

Even on a non-threaded cpu the cpu_relax() could be useful in the
future to hint to the cpu that it could drop into a lower power
hogging state.

But I agree with your main point that the loop without the cpu_relax()
looks like it ought to work because atomic_read() ought to actually
go out and read memory each time around the loop.

-Tony
