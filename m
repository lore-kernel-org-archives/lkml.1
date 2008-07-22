Return-Path: <linux-kernel-owner+w=401wt.eu-S1754544AbYGVTTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbYGVTTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbYGVTTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:19:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbYGVTTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:19:31 -0400
To: Avi Kivity <avi@qumranet.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       kvm@vger.kernel.org
Subject: Re: [patch 0/4] Port KVM-trace to tracepoints
References: <20080717155724.897537670@polymtl.ca>
	<48862A30.7050701@qumranet.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Tue, 22 Jul 2008 15:16:12 -0400
In-Reply-To: <48862A30.7050701@qumranet.com> (Avi Kivity's message of "Tue, 22 Jul 2008 21:42:56 +0300")
Message-ID: <y0mabg991c3.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi@qumranet.com> writes:

> [...]
> kvm tracepoints are heavily tied into the implementation; and making
> them harder to write means we will have less information.  In fact, I
> am contemplating moving in another direction (when looking at the
> pgprintk()s scattered around arch/x86/kvm/mmu.c:
>
>   kvm_trace("pfentry", "page_fault entry addr %lx error code %x\n",
> cr2, error_code);
>
> Unlike printk()s, no actual formatting would occur during runtime.

Have you considered using trace_mark() directly - eliminating the
KVM_TRACEN() middlemen?

> Instead, at initialization time all the strings would be parsed into
> a data structure that describes the data types, and the runtime
> would simply consult this structure and copy the arguments into
> trace records.  User space would also be able to pull this structure
> and so recreate the formatted string.

If one really wanted to, one could build such a mechanism on top of
marker-based callbacks.

> The advantages I see to this are:
>
>  - easy to add traces; the most important advantage
>  - when the code changes, obsolete traces are completely removed
>  - good performance

Ditto.

>  - no need to have a formats file in userspace (which is tied to the
> kernel version)

OTOH, you'd have the kernel collecting compact binary records
containing just the parameters, which are at least as tied to kernel
version.

>  - can also send printk()s along, for synchronization with other kvm
> and kernel events

Ditto.  It is elementary to attach a printk-generating marker callback.


- FChE
