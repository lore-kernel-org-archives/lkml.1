Return-Path: <linux-kernel-owner+w=401wt.eu-S1753072AbXDRASa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072AbXDRASa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 20:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbXDRASa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 20:18:30 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:54719 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753072AbXDRAST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 20:18:19 -0400
Message-ID: <4624AD08.3030006@vmware.com>
Date: Tue, 17 Apr 2007 04:18:32 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>, Hugh Dickins <hugh@veritas.com>,
       David Rientjes <rientjes@google.com>,
       Michel Lespinasse <walken@vmware.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] Pte drop ptep_get_and_clear paravirt op.patch
References: <200704120530.l3C5Ubs0022821@zach-dev.vmware.com> <4624CC7C.6040107@goop.org>
In-Reply-To: <4624CC7C.6040107@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Zachary Amsden wrote:
>   
>> In shadow mode hypervisors, ptep_get_and_clear achieves the desired
>> purpose of keeping the shadows in sync by issuing a native_get_and_clear,
>> followed by a call to pte_update, which indicates the PTE has been
>> modified.
>>
>> Direct mode hypervisors (Xen) have no need for this anyway, and will trap
>> the update using writable pagetables.
>>   
>>     
>
> Jan Beulich just posted a patch for Xen/linux which specialzes
> ptep_get_and_clear, which apparently improves kernel-compile performance
> by 25-30% on some configurations.  I think we'll want to keep this.
>   

Are you sure that it still wins even with these patches?  I can't see 
ptep_get_and_clear getting much faster than a pure non-emulated, and the 
stress case which wins 25-30% is fork/exit being able to drop the pte 
updates in zap_pte_range from trapping and / or going into a pte update 
queue.  That is what my patches addressed for shadow paging performance 
- the call to pte_update can be dropped - but you should already be 
getting this benefit for Xen, since there pte_update is a nop.  Are you 
sure you are unpinning the page tables and mapping them back as writable 
pages prior to address space destruction?

Or is there another case which exercises zap_pte_range via munmap?  In 
which case, you might be able to do things faster than trap and emulate 
with a hypercall, but a 25-30% speedup sounds rather para-normal for 
this type of change.  I would like to see a patch and some basic data 
showing the speedup if possible.

I certainly have no objection to adding back ptep_get_and_clear hook, 
but we need to fix the naming to be consistent (raw vs. native), which 
is one thing the patch (dropping the hook) is trying to do.  We can 
always re-add specialization for ptep_get_and_clear; the question is 
what level is appropriate.  Do you allow ptep_get_and_clear itself to be 
redefined or allow redefine of native_ptep_get_and_clear?

One line of reasoning - for consistency, it seems that 
native_ptep_get_and_clear should be just that, a non-paravirtualized pte 
udpate.  Then it follows we should not allow native_ptep_get_and_clear 
to be overridden.  In this case, for cleanliness is it better to add a 
midlevel indirection; use raw_ptep_get_and_clear as the paravirt-hook, 
which is called from ptep_get_and_clear, and allow access to the 
non-paravirtualized native functions with native_ptep_get_and_clear.  If 
that sounds agreeable, then this patch should be backed out.  I think 
backing it out will damage the immediately following patches due to 
sensitivity from code proximity.

Maybe the best strategy is to just re-add ptep_get_and_clear as a 
paravirt-op after the whole set of patches and before Jan's speedup patch?

Zach
