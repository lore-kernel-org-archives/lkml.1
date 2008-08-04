Return-Path: <linux-kernel-owner+w=401wt.eu-S1762590AbYHDTxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762590AbYHDTxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 15:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711AbYHDTxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 15:53:12 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:36872 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbYHDTxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 15:53:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Mike Travis <travis@sgi.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <1217844601-4298-1-git-send-email-yhlu.kernel@gmail.com>
	<1217844601-4298-2-git-send-email-yhlu.kernel@gmail.com>
	<1217844601-4298-3-git-send-email-yhlu.kernel@gmail.com>
	<48971A1E.5040704@sgi.com>
Date: Mon, 04 Aug 2008 12:43:01 -0700
In-Reply-To: <48971A1E.5040704@sgi.com> (Mike Travis's message of "Mon, 04 Aug
	2008 08:02:54 -0700")
Message-ID: <m1k5ew4ldm.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Mike Travis <travis@sgi.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0043]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 02/04] x86: add get_irq_cfg in io_apic_64.c
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis <travis@sgi.com> writes:


>> arch/x86/kernel/io_apic_64.c | 181 +++++++++++++++++++++++++++++++++----------
>>  1 file changed, 141 insertions(+), 40 deletions(-)
>> 
>> Index: linux-2.6/arch/x86/kernel/io_apic_64.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/io_apic_64.c
>> +++ linux-2.6/arch/x86/kernel/io_apic_64.c
>> @@ -57,7 +57,11 @@
>>  
>>  #define __apicdebuginit(type) static type __init
>>  
>> +struct irq_cfg;
>> +
>>  struct irq_cfg {
>> +	unsigned int irq;
>> +	struct irq_cfg *next;
>>  	cpumask_t domain;
>>  	cpumask_t old_domain;
>         ^^^^^^^^^
> One thought here... most interrupts cannot be serviced by any cpu in
> the system, but instead need to be serviced by the cpu attached to
> the ioapic or on the local node.  So defining some subset of cpumask_t
> would save a lot of space.  For example:
>
> 	nodecpumask_t {
> 		int	node;
> 		DEFINE_BITMAP(..., MAX_CPUS_PER_NODE);
> 	};
>
> And of course, providing some utilities to convert nodecpumask_t <==>
> cpumask_t.
>
> ("node" might not be the proper abstraction... maybe "irqcpumask_t"?

I agree this is someplace we could optimize.  In practice we seem
to have 3 choices on x86.

1) A single cpu.
2) lowest priority interrupt delivery to a set of possibly 8 cpus.
3) A class of interrupt that is delivered locally to each individual
   cpu.

If you have a true NUMA system it should still be possible to handle
interrupts on the wrong Node just prohibitively expensive.

Eric
