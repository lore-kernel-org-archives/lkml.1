Return-Path: <linux-kernel-owner+w=401wt.eu-S1752803AbYKQTAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbYKQTAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 14:00:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbYKQTAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 14:00:09 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:60141 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751076AbYKQTAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 14:00:08 -0500
Subject: Re: arch_flush_lazy_mmu_mode() in arch/x86/mm/highmem_32.c
From: Zachary Amsden <zach@vmware.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jan Beulich <jbeulich@novell.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4921BA8E.60806@goop.org>
References: <4921428A.76E4.0078.0@novell.com>
	 <1226944387.9969.77.camel@bodhitayantram.eng.vmware.com>
	 <4921BA8E.60806@goop.org>
Content-Type: text/plain
Date: Mon, 17 Nov 2008 11:54:44 -0800
Message-Id: <1226951684.6905.13.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-17 at 10:40 -0800, Jeremy Fitzhardinge wrote:

> Yes.  The Xen code only disables interrupts temporarily while actually 
> constructing a new multicall list member, to stop a half-constructed 
> multicall from being issued by a nested flush.  But that's very brief, 
> and cheap under Xen.

We have truly magical ways of doing the same thing.

> You could do the flush in the fault handler itself, rather than 
> vmalloc_sync_one.  If you enter the handler with outstanding updates, 
> then flush them and return.  Hm, but that only works if you're always 
> going from NP->P; if you're doing P->P updates then you may just end up 
> with stale mappings.

vmalloc_sync_one really is just the fault handler, factored out to look
nice... in any case, the faults here will aways be NP->P; once created,
the page tables handling the vmalloc area will never be released, so the
PDE never transitions from P->P or P->NP (the PTEs do).

> The Novell kernel tree.  Jan's been doggedly forward-porting the old Xen 
> patches.

Okay, that explains it... the patch sequence here contains a bit of
"fun" IIRC.

