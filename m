Return-Path: <linux-kernel-owner+w=401wt.eu-S1030457AbXDPWEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030457AbXDPWEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 18:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030997AbXDPWEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 18:04:09 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:50932 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030457AbXDPWEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 18:04:08 -0400
Message-ID: <4623F212.5030904@vmware.com>
Date: Mon, 16 Apr 2007 15:00:50 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch -mm] i386: use pte_update_defer in ptep_test_and_clear_{dirty,young}
References: <Pine.LNX.4.64.0703252335560.4535@chino.kir.corp.google.com> <46082BE6.30402@vmware.com> <Pine.LNX.4.64.0704131838310.8399@blonde.wat.veritas.com> <461FD9BF.90609@vmware.com> <Pine.LNX.4.64.0704132108430.14740@blonde.wat.veritas.com> <461FEF1C.5010806@vmware.com> <Pine.LNX.4.64.0704161831500.8213@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0704161831500.8213@blonde.wat.veritas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> You're right to want to defer your pte_updates, David is right to want
> to batch his TLB flushes.  It bothers me that you have a surprising case,
> and that unless you abandon your optimization, it imposes a new constraint
> on how to proceed in common code (without #ifdef'ing around).
>
> But perhaps in this case David might concede that the longer we delay
> the TLB flush, the more likely a referenced bit is to be missed - that is,
> it gets cleared from the pte, but if that page is accessed again before
> the TLB is flushed, the processor may well omit to reinstate the accessed
> bit, and our stats drift away from reality.
>
> Compromise patch below: would that be satisfactory to you, David?
>   

Although I appreciate the heroics, you needn't do this on our account; 
the win of a couple thousand cycles is not worth the cost in complexity, 
IMHO, and the penalty on native quite potentially overshadows this.  If 
you still issue the flush inside the spinlock, as required for this 
paravirt optimization, you are taking the risk of holding the spinlock 
an extra long time while issuing a TLB shootdown - which means waiting 
for an IPI.

It might not matter that much on i386, but on big iron (or realtime) 
systems, this could have significant negative scaling effects for 
workloads where the page page table was hot on some set of CPUs (say, 
remapping file pages for database access).  In time, the benefits of 
this optimization to the hypervisor will decrease, while the benefits of 
optimizing the other way for shorter spinlock time may increase, both in 
a VM and on native hardware.

So I would rather just drop the pte_update_defer down to a pte_update if 
the flush is not immediately following - as it is nice and simply 
correct without getting in the way.  I see there is more in this thread 
that I haven't read yet, so I preemptively reserve the right to issue an 
invalidation of this opinion...

Thanks,

Zach
