Return-Path: <linux-kernel-owner+w=401wt.eu-S1758733AbZCRWzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbZCRWzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 18:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZCRWzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 18:55:33 -0400
Received: from gw.goop.org ([64.81.55.164]:40473 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604AbZCRWzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 18:55:32 -0400
Message-ID: <49C17BD8.6050609@goop.org>
Date: Wed, 18 Mar 2009 15:55:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Question about x86/mm/gup.c's use of disabled interrupts
References: <49C148AF.5050601@goop.org> <49C16411.2040705@redhat.com> <49C1665A.4080707@goop.org> <49C16A48.4090303@redhat.com> <49C17230.20109@goop.org> <49C17880.7080109@redhat.com>
In-Reply-To: <49C17880.7080109@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
>> Hm, awkward if flush_tlb_others doesn't IPI...
>>
>
> How can it avoid flushing the tlb on cpu [01]?  It's it's 
> gup_fast()ing a pte, it may as well load it into the tlb.

xen_flush_tlb_others uses a hypercall rather than an IPI, so none of the 
logic which depends on there being an IPI will work.

>> Simplest fix is to make gup_get_pte() a pvop, but that does seem like 
>> putting a red flag in front of an inner-loop hotspot, or something...
>>
>> The per-cpu tlb-flush exclusion flag might really be the way to go.
>
> I don't see how it will work, without changing Xen to look at the flag?
>
> local_irq_disable() is used here to lock out a remote cpu, I don't see 
> why deferring the flush helps.

Well, no, not deferring.  Making xen_flush_tlb_others() spin waiting for 
"doing_gup" to clear on the target cpu.  Or add an explicit notion of a 
"pte update barrier" rather than implicitly relying on the tlb IPI 
(which is extremely convenient when available...).

    J
