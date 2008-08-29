Return-Path: <linux-kernel-owner+w=401wt.eu-S1754775AbYH2UFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbYH2UFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 16:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbYH2UFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 16:05:01 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47099
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751184AbYH2UFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 16:05:00 -0400
Date: Fri, 29 Aug 2008 13:04:55 -0700 (PDT)
Message-Id: <20080829.130455.54621315.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: jes@sgi.com, travis@sgi.com, mingo@elte.hu, Alan.Brunelle@hp.com,
       tglx@linutronix.de, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, akpm@linux-foundation.org,
       arjan@linux.intel.com, rusty@rustcorp.com.au
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
 bisected
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0808290909020.3300@nehalem.linux-foundation.org>
References: <20080826.134535.193703558.davem@davemloft.net>
	<48B7EEA2.7090300@sgi.com>
	<alpine.LFD.1.10.0808290909020.3300@nehalem.linux-foundation.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 29 Aug 2008 09:14:44 -0700 (PDT)

> Well, it probably boots because it doesn't really seem to _change_ much of 
> anything.
> 
> Things like this:
> 
> 	-static inline void arch_send_call_function_ipi(cpumask_t mask)
> 	+static inline void arch_send_call_function_ipi(cpumask_t *mask)
> 	 {
> 	-       smp_ops.send_call_func_ipi(mask);
> 	+       smp_ops.send_call_func_ipi(*mask);
> 	 }
> 
> will still do that stack allocation at the time of the call. You'd have to 
> pass the thing all the way down as a pointer..

True, but we have to get there one step at a time.

BTW, sparc64 already wants a pointer here, so it's completely ready for
this:

void arch_send_call_function_ipi(cpumask_t mask)
{
	xcall_deliver((u64) &xcall_call_function, 0, 0, &mask);
}
