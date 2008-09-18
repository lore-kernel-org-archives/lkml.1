Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbYIRSAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbYIRSAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 14:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755298AbYIRSAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 14:00:34 -0400
Received: from gw.goop.org ([64.81.55.164]:57277 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285AbYIRSAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 14:00:34 -0400
Message-ID: <48D29741.4070404@goop.org>
Date: Thu, 18 Sep 2008 11:00:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86: x86_{phys,virt}_bits field also for i386 (v3)
References: <48D21BA3.76E4.0078.0@novell.com> <20080918071852.GA7639@elte.hu> <20080918091003.GA3751@elte.hu> <48D23BF6.76E4.0078.0@novell.com> <20080918095710.GA11633@elte.hu> <20080918112018.GA456@elte.hu> <48D25E87.76E4.0078.0@novell.com>
In-Reply-To: <48D25E87.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>>>> Ingo Molnar <mingo@elte.hu> 18.09.08 13:20 >>>
>>>>         
>> * Ingo Molnar <mingo@elte.hu> wrote:
>>
>>     
>>> * Jan Beulich <jbeulich@novell.com> wrote:
>>>
>>>       
>>>> I'm really sorry for that, yet another merge oversight (not caught 
>>>> because only re-tested on x86-64). Here's a better one.
>>>>         
>>> ah, i see, the delta below. Nasty.
>>>       
>> the attached config fails in a similar way.
>>     
>
> Hmm, yes, other than in .27, -tip derives resource_size_t from phys_addr_t,
> regardless of CONFIG_RESOURCES_64BIT (and the config you provided
> is a non-PAE one). I have to question that change, which I'm sure is
> responsible for this failure. If there's a good reason for this, then
> phys_addr_valid() should use phys_addr_t as its parameter type (and
> so should ioremap() & Co), and the pre-processor conditional should
> then change to depend on CONFIG_PHYS_ADDR_T_64BIT. Since ioremap()
> would need to change first, I'd have to withdraw the patch until that
> gets sorted out.

I take it we're talking about this chunk:

-static inline int phys_addr_valid(unsigned long addr)
+static inline int phys_addr_valid(resource_size_t addr)
 {
-	return addr < (1UL << boot_cpu_data.x86_phys_bits);
+#ifdef CONFIG_RESOURCES_64BIT
+	return !(addr >> boot_cpu_data.x86_phys_bits);
+#else
+	return 1;
+#endif


Is x86_phys_bits defined to be the actual number of address lines poking
out of the CPU package, or the number of address bits we can
meaningfully put into a pte?

I would say the simplest thing to do here is be explicit:

	if (sizeof(addr) == sizeof(u64))
		return !(addr >> boot_cpu_data.x86_phys_bits);
	else
		return 1; 

That's not ideal, but I guess its good enough.  I assume x86_phys_bits
can never be less than 32?

    J
