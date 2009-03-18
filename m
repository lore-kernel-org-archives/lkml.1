Return-Path: <linux-kernel-owner+w=401wt.eu-S1759522AbZCRTRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759522AbZCRTRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 15:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbZCRTRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 15:17:11 -0400
Received: from gw.goop.org ([64.81.55.164]:55725 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbZCRTRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 15:17:10 -0400
Message-ID: <49C148AF.5050601@goop.org>
Date: Wed, 18 Mar 2009 12:17:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>
Subject: Question about x86/mm/gup.c's use of disabled interrupts
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

The comment in arch/x86/mm/gup.c:gup_get_pte() says:

	[...] What
	 * we do have is the guarantee that a pte will only either go from not
	 * present to present, or present to not present or both -- it will not
	 * switch to a completely different present page without a TLB flush in
	 * between; something that we are blocking by holding interrupts off.


Disabling the interrupt will prevent the tlb flush IPI from coming in 
and flushing this cpu's tlb, but I don't see how it will prevent some 
other cpu from actually updating the pte in the pagetable, which is what 
we're concerned about here.  Is this the only reason to disable 
interrupts?  Would we need to do it for the !PAE cases?

Also, assuming that disabling the interrupt is enough to get the 
guarantees we need here, there's a Xen problem because we don't use IPIs 
for cross-cpu tlb flushes (well, it happens within Xen).  I'll have to 
think a bit about how to deal with that, but I'm thinking that we could 
add a per-cpu "tlb flushes blocked" flag, and maintain some kind of 
per-cpu deferred tlb flush count so we can get around to doing the flush 
eventually.

But I want to make sure I understand the exact algorithm here.

(I couldn't find an instance of a pte update going from present->present 
anyway; the only caller of set_pte_present is set_pte_vaddr which only 
operates on kernel mappings, so perhaps this is moot.  Oh, look, 
native_set_pte_present thinks its only called on user mappings...  In 
fact set_pte_present seems to have completely lost its rationale for 
existing.)

Thanks,
    J
