Return-Path: <linux-kernel-owner+w=401wt.eu-S1754217AbXDPSwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbXDPSwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 14:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754218AbXDPSwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 14:52:18 -0400
Received: from smtp-out.google.com ([216.239.45.13]:59761 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217AbXDPSwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 14:52:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=vHC7BW7O+I8/weDJm/DfnijPSKIWNypWrOElHBu3B0WdIKSH/n+Yb0ffB5NuYbi7l
	S9SYR7/MiMBJ1+2nMu4Mw==
Date: Mon, 16 Apr 2007 11:51:53 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Hugh Dickins <hugh@veritas.com>
cc: Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch -mm] i386: use pte_update_defer in ptep_test_and_clear_{dirty,young}
In-Reply-To: <Pine.LNX.4.64.0704161831500.8213@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0704161139020.12097@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0703252335560.4535@chino.kir.corp.google.com>
 <46082BE6.30402@vmware.com> <Pine.LNX.4.64.0704131838310.8399@blonde.wat.veritas.com>
 <461FD9BF.90609@vmware.com> <Pine.LNX.4.64.0704132108430.14740@blonde.wat.veritas.com>
 <461FEF1C.5010806@vmware.com> <Pine.LNX.4.64.0704161831500.8213@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2007, Hugh Dickins wrote:

> When, as now, core mm people make some change, failing to take your
> case into account.
> 

That's exactly what happened here: include/asm-i386/pgtable.h is 
advertising both __HAVE_ARCH_PTEP_TEST_AND_CLEAR_{DIRTY,YOUNG} without 
actually having them.  No consideration is going to be given to such a 
hack when clearing A/D bits in generic code.  If the optimization for a 
specific architecture is not possible for an atomic test and clear of A/D 
bits generically, then it's not an optimization at all.  It's a bug.

> You're right to want to defer your pte_updates, David is right to want
> to batch his TLB flushes.  It bothers me that you have a surprising case,
> and that unless you abandon your optimization, it imposes a new constraint
> on how to proceed in common code (without #ifdef'ing around).
> 

Batching the TLB flushes was really a no brainer: there was a significant 
speed-up in /proc/pid/clear_refs by using flush_tlb_mm() over 
flush_tlb_page().  If there's an "optimization" for paravirt that gets in 
the way by defering the updated A/D bit, then it needs to be eliminated.  
It was merged because there were no generic uses of 
ptep_test_and_clear_{dirty,young}, but now there are.

If it was really considered to be an "optimization," which is was 
advertised to be in the changelog associated with a very trivial patch, 
then removing it by definition would not introduce new constraints that 
would need to be patched.  I'd like to see a patch without the defer and 
see how invasive it truly is on generic code because it was not originally 
merged that invasively.

> Compromise patch below: would that be satisfactory to you, David?
> 

I really like the patch, but for perhaps a slightly different reason: 
we're only flushing ranges that have been shown to need it.  We aren't 
completely flushing the entire mm which is likely to be excessive in 
situations where we're actually using /proc/pid/clear_refs in combination 
with /proc/pid/smaps for memory footprint approximation (i.e. it's on a 
fine granularity).

		David
