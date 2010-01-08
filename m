Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038Ab0AHQsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab0AHQsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 11:48:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753982Ab0AHQsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 11:48:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753845Ab0AHQsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 11:48:09 -0500
Date: Fri, 8 Jan 2010 18:47:09 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       avi@redhat.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, hpa@zytor.com, riel@redhat.com,
       cl@linux-foundation.org
Subject: Re: [PATCH v3 00/12] KVM: Add host swap event notifications for PV
 guest
Message-ID: <20100108164709.GA15187@redhat.com>
References: <1262700774-1808-1-git-send-email-gleb@redhat.com>
 <20100108161828.GA30404@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100108161828.GA30404@amt.cnet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 02:18:28PM -0200, Marcelo Tosatti wrote:
> On Tue, Jan 05, 2010 at 04:12:42PM +0200, Gleb Natapov wrote:
> > KVM virtualizes guest memory by means of shadow pages or HW assistance
> > like NPT/EPT. Not all memory used by a guest is mapped into the guest
> > address space or even present in a host memory at any given time.
> > When vcpu tries to access memory page that is not mapped into the guest
> > address space KVM is notified about it. KVM maps the page into the guest
> > address space and resumes vcpu execution. If the page is swapped out
> > from host memory vcpu execution is suspended till the page is not swapped
> > into the memory again. This is inefficient since vcpu can do other work
> > (run other task or serve interrupts) while page gets swapped in.
> > 
> > To overcome this inefficiency this patch series implements "asynchronous
> > page fault" for paravirtualized KVM guests. If a page that vcpu is
> > trying to access is swapped out KVM sends an async PF to the vcpu
> > and continues vcpu execution. Requested page is swapped in by another
> > thread in parallel.  When vcpu gets async PF it puts faulted task to
> > sleep until "wake up" interrupt is delivered. When the page is brought
> > to the host memory KVM sends "wake up" interrupt and the guest's task
> > resumes execution.
> 
> Some high level comments:
> 
> - cr2 used as token: better use the shared region? what if:
>  
>  async pf queued
>  guest triple faults without a vmexit
>  inject async-pf-done with token in cr2
> 
> Also, in such scenario, can't you potentially corrupt guest memory after
> the triple fault by writing to the previously registered shared region
> address?
> 
After triple faults guest will reboot and this should clear all pending
async pf injections. I'll check that this is indeed happens.

> - The token can overflow relatively easy. Use u64?
It not only can it frequently does, but since there can't be 2^20
outstanding page faults per vcpu simultaneously this doesn't cause
any problem.

> 
> - Does it really inject interrupts for non-pv guests while waiting
> for swapin? Can't see that. Wish it was more geared towards fv.
> 
No it does not yet. I only started to play with this to see how it can
work.

> - Please share some perf numbers.
> 
OK.

> - Limit the number of queued async pf's per guest ?
> 
Make sense.

> - Unify gfn_to_pfn / gfn_to_pfn_async code in the pf handlers (easier
> to review).
OK.

--
			Gleb.
