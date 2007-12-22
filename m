Return-Path: <linux-kernel-owner+w=401wt.eu-S1753670AbXLVCNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbXLVCNn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 21:13:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbXLVCNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 21:13:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48972 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbXLVCNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 21:13:33 -0500
Date: Sat, 22 Dec 2007 03:07:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com, roland@redhat.com
Subject: Re: [PATCH 18/19] move _set_gate and its users to a common location
Message-ID: <20071222020700.GA7966@elte.hu>
References: <11975543592701-git-send-email-gcosta@redhat.com> <11975543641360-git-send-email-gcosta@redhat.com> <11975543691134-git-send-email-gcosta@redhat.com> <11975543742848-git-send-email-gcosta@redhat.com> <11975543792334-git-send-email-gcosta@redhat.com> <11975543843977-git-send-email-gcosta@redhat.com> <11975543892403-git-send-email-gcosta@redhat.com> <11975543942657-git-send-email-gcosta@redhat.com> <1197554399402-git-send-email-gcosta@redhat.com> <1197554404337-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197554404337-git-send-email-gcosta@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Glauber de Oliveira Costa <gcosta@redhat.com> wrote:

> This patch moves _set_gate and its users to desc.h. We can now use 
> common code for x86_64 and i386.

a few days ago i started seeing weird crashes on 64-bit x86 in the 
random-kernel-bootup tests. Nothing truly reproducable to be bisectable, 
but quality of x86.git went down drastically. Double faults, triple 
faults, crashes all around the place, with every few dozen kernel 
bootups.

Today i found a config and a workload that triggered the crashes a bit 
more reliably. I still needed a 6 hours bisection marathon to pinpoint 
the patch - the one in this thread. A review of it with H. Peter Anvin 
pinpointed the breakage:

> +static inline void set_system_gate(unsigned int n, void *addr)
> +{
> +	BUG_ON((unsigned)n > 0xFF);
> +	_set_gate(n, GATE_TRAP, addr, 0x3, 0, __KERNEL_CS);
> +}

> -static inline void set_system_gate(int nr, void *func)
> -{
> -	BUG_ON((unsigned)nr > 0xFF);
> -	_set_gate(nr, GATE_INTERRUPT, (unsigned long) func, 3, 0);
> -}

you changed the type of system gates on 64-bit from GATE_INTERRUPT to 
GATE_TRAP. The effect of this is that these gates enter with interrupts 
enabled - instead of interrupts disabled. This, amongst others, affects 
the following key gate:

        set_system_gate(IA32_SYSCALL_VECTOR, ia32_syscall);

which relies on disabled interrupts to fix up its stack. If an interrupt 
comes in the wrong moment then we get a kernel stack corruption that is 
not survivable.

the reason for this bug was that you tried to do too many changes in a 
single patch. You did a cleanup, you did unification and you moved code 
around. It was totally non-obvious what you did and the resulting patch 
was not reviewable at all - even after the bisection poinpointed the 
patch, it took us almost 30 minutes to figure out where the bug was. If 
this unstructured, careless mess of patches continues then we are not 
going to be able to accept any more 64-bit paravirt patches into 
x86.git.

	Ingo
