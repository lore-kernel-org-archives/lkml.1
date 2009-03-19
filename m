Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbZCSRRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbZCSRRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 13:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753666AbZCSRRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 13:17:06 -0400
Received: from gw.goop.org ([64.81.55.164]:33167 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbZCSRRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 13:17:03 -0400
Message-ID: <49C27E09.5070307@goop.org>
Date: Thu, 19 Mar 2009 10:16:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Keir Fraser <keir.fraser@eu.citrix.com>
Subject: Re: Question about x86/mm/gup.c's use of disabled interrupts
References: <49C148AF.5050601@goop.org> <49C16411.2040705@redhat.com> <49C1665A.4080707@goop.org> <49C16A48.4090303@redhat.com> <49C17230.20109@goop.org> <49C17880.7080109@redhat.com> <49C17BD8.6050609@goop.org> <49C17E22.9040807@redhat.com> <49C18487.1020703@goop.org> <49C21473.2000702@redhat.com>
In-Reply-To: <49C21473.2000702@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
>> And the hypercall could result in no Xen-level IPIs at all, so it 
>> could be very quick by comparison to an IPI-based Linux 
>> implementation, in which case the flag polling would be particularly 
>> harsh.
>
> Maybe we could bring these optimizations into Linux as well.  The only 
> thing Xen knows that Linux doesn't is if a vcpu is not scheduled; all 
> other information is shared.

I don't think there's a guarantee that just because a vcpu isn't running 
now, it won't need a tlb flush.  If a pcpu does runs vcpu 1 -> idle -> 
vcpu 1, then there's no need for it to do a tlb flush, but the hypercall 
can make force a flush when it reschedules vcpu 1 (if the tlb hasn't 
already been flushed by some other means).

(I'm not sure to what extent Xen implements this now, but I wouldn't 
want to over-constrain it.)

>> Also, the straightforward implementation of "poll until all target 
>> cpu's flags are clear" may never make progress, so you'd have to 
>> "scan flags, remove busy cpus from set, repeat until all cpus done".
>>
>> All annoying because this race is pretty unlikely, and it seems a 
>> shame to slow down all tlb flushes to deal with it.  Some kind of 
>> global "doing gup_fast" counter would get flush_tlb_others bypass the 
>> check, at the cost of putting a couple of atomic ops around the 
>> outside of gup_fast.
>
> The nice thing about local_irq_disable() is that it scales so well.

Right.  But it effectively puts the burden on the tlb-flusher to check 
the state (implicitly, by trying to send an interrupt).  Putting an 
explicit poll in gets the same effect, but its pure overhead just to 
deal with the gup race.

I'll put a patch together and see how it looks.

    J
