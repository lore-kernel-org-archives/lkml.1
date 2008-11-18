Return-Path: <linux-kernel-owner+w=401wt.eu-S1752695AbYKRICh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbYKRICh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 03:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbYKRIC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 03:02:28 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:2817 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbYKRIC2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 03:02:28 -0500
Message-Id: <492284CE.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 18 Nov 2008 08:03:10 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Zachary Amsden" <zach@vmware.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: arch_flush_lazy_mmu_mode() in arch/x86/mm/highmem_32.c
References: <4921428A.76E4.0078.0@novell.com>
 <1226944387.9969.77.camel@bodhitayantram.eng.vmware.com>
 <4921BA8E.60806@goop.org>
In-Reply-To: <4921BA8E.60806@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <jeremy@goop.org> 17.11.08 19:40 >>>
>Zachary Amsden wrote:
>> On Mon, 2008-11-17 at 01:08 -0800, Jan Beulich wrote:
>>> the batch should be prevented in asynchronous contexts altogether, or
>>> things should properly nest. As a positive side effect, disabling interrupts
>>> in the batch handling - in particular around the submission of the batch -
>>> could also be avoided, reducing interrupt latency (perhaps significantly
>>> in some case).
>>>     
>>
>> Jeremy already fixed that; we don't disable interrupts, the change he
>> made was to flush and then immediately restart the batching.
>>   
>
>Yes.  The Xen code only disables interrupts temporarily while actually 
>constructing a new multicall list member, to stop a half-constructed 
>multicall from being issued by a nested flush.  But that's very brief, 
>and cheap under Xen.

Where's that fixed? Even in the -tip tree I still see xen_mc_flush()
disabling interrupts (and multicalls.c didn't change for over two months)...

>>> Likewise I would think that the flush out of vmalloc_sync_one() isn't
>>> appropriate, and it should rather be avoided for the set_pmd() there to
>>> get into the batching code altogether.
>>>     
>>
>> That's impossible.  The flush is needed and there is no way to avoid it.
>> The kernel has no general restrictions about contexts in which it is
>> safe vs. unsafe to touch the kernel's own vmalloc'ed memory, so you can
>> get a page fault due to lazy syncing of vmalloc area PDEs in non-PAE
>> mode.  You really have to service that fault.
>>   
>
>You could do the flush in the fault handler itself, rather than 
>vmalloc_sync_one.  If you enter the handler with outstanding updates, 
>then flush them and return.  Hm, but that only works if you're always 
>going from NP->P; if you're doing P->P updates then you may just end up 
>with stale mappings.

There's no reason to do any flush at all if you suppress batching temporarily.
And it only needs (would need) explicit suppressing here because you can't
easily recognize being in the context of a page fault handler from the
batching functions (other than recognizing being in the context of an
interrupt handler, which is what would allow removing the flush calls from
highmem_32.c).

Jan

