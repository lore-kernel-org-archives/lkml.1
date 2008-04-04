Return-Path: <linux-kernel-owner+w=401wt.eu-S1759842AbYDDPdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759842AbYDDPdx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 11:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbYDDPdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 11:33:45 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:48327
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754572AbYDDPdo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 11:33:44 -0400
Message-Id: <47F66691.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Fri, 04 Apr 2008 16:34:09 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <hpa@kernel.org>, <tglx@linutronix.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386: additional fix for making ioremap()
	accept64-bit addresses
References: <47F638FD.76E4.0078.0@novell.com>
 <20080404125543.GA29423@elte.hu>
In-Reply-To: <20080404125543.GA29423@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 04.04.08 14:55 >>>
>
>* Jan Beulich <jbeulich@novell.com> wrote:
>
>> The recent change to __ioremap()'s first parameter's type didn't yield 
>> the intended effect as the first conditional inside the function would 
>> still have filtered out any addresses with bits [63:32] set. Correct 
>> last_addr's type and at once also add a check that the address range 
>> doesn't extend into space hardware cannot support even theoretically.
>
>i fixed this in x86.git more than a week ago, see:
>
>|  Subject: x86: ioremap of 64-bit resource on 32-bit kernel fix
>|  From: Ingo Molnar <mingo@elte.hu>
>|  Date: Tue, 25 Mar 2008 08:31:17 +0100
>
>but since 64-bit resources never worked on 32-bit and the initiator 
>regression causing this discussion turned out to be something else, i 
>delayed this fix as .26 material.
>
>the PHYSICAL_MASK fix looks good as an additional check - could you 
>please resend it against x86.git/latest which has my fix already?

No need to do this afaics: you've already got the better

	if (!phys_addr_valid(phys_addr)) {
		printk(KERN_WARNING "ioremap: invalid physical address %llx\n",
		       phys_addr);
		WARN_ON_ONCE(1);
		return NULL;
	}

in there. What needs fixing is that this returns 1 on 32-bits
unconditionally, whereas the x86-64 definition should also be used for
PAE (and the parameter type should also be resource_size_t).

Jan

