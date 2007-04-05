Return-Path: <linux-kernel-owner+w=401wt.eu-S1750979AbXDEU2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750979AbXDEU2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 16:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbXDEU2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 16:28:51 -0400
Received: from ns.suse.de ([195.135.220.2]:54395 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbXDEU2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 16:28:50 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: What protects cpu_tlbstate?
Date: Thu, 5 Apr 2007 22:28:36 +0200
User-Agent: KMail/1.9.6
Cc: Benjamin LaHaise <bcrl@kvack.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4615518A.4070003@goop.org>
In-Reply-To: <4615518A.4070003@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704052228.36590.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 April 2007 21:44:10 Jeremy Fitzhardinge wrote:
> Hi,
> 
> What protects the cpu_tlbstate?  I see in i386/kernel/smp.c that its
> always used in a non-preemptable area, but what prevents races with
> interrupts?  For example, what prevents leave_mm() called via the
> flush_tlb_all IPI from racing with, say, enter_lazy_tlb?  Couldn't a
> race leave cpu_tlbstate in an inconsistent state?
> 
> Or does it simply not matter?  But if that were true, it seems to me
> that there should be at least some barriers or something to make sure
> the final state is consistent.

The interrupts can only happen when the other CPU is already lazy
and enter_lazy_tlb would be a nop then.  The flushers itself are
synchronized by the page_table_lock or the mm semaphore.

Against switch_mm it tries to protect with ordering.

wmb()s are not needed on x86 (ok minus errata on ppro and
VIA magic mode but which is UP only). That would leave some rmb()s,
but I don't see any place they would be needed. 

-Andi

