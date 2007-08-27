Return-Path: <linux-kernel-owner+w=401wt.eu-S932608AbXH0RkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608AbXH0RkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 13:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756473AbXH0Rj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 13:39:56 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43353 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932340AbXH0Rjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 13:39:54 -0400
Subject: Re: [PATCH 1/3] Implement emulator_write_phys()
From: Anthony Liguori <aliguori@us.ibm.com>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <46D3095A.6020305@qumranet.com>
References: <11882278064002-git-send-email-aliguori@us.ibm.com>
	 <1188227808405-git-send-email-aliguori@us.ibm.com>
	 <46D2F1B7.70604@qumranet.com> <1188235419.6364.2.camel@squirrel>
	 <46D3095A.6020305@qumranet.com>
Content-Type: text/plain
Organization: IBM
Date: Mon, 27 Aug 2007 12:39:51 -0500
Message-Id: <1188236391.6364.14.camel@squirrel>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-08-27 at 20:26 +0300, Avi Kivity wrote:
> Anthony Liguori wrote:
> > On Mon, 2007-08-27 at 18:45 +0300, Avi Kivity wrote:
> >   
> >> Anthony Liguori wrote:
> >>     
> >>> Since a hypercall may span two pages and is a gva, we need a function to write
> >>> to a gva that may span multiple pages.  emulator_write_phys() seems like the
> >>> logical choice for this.
> >>>
> >>> @@ -962,8 +962,35 @@ static int emulator_write_std(unsigned long addr,
> >>>  			      unsigned int bytes,
> >>>  			      struct kvm_vcpu *vcpu
> >>>       
> >> I think that emulator_write_emulated(), except for being awkwardly 
> >> named, should do the job.  We have enough APIs.
> >>
> >> But!  We may not overwrite the hypercall instruction while a vcpu may be 
> >> executing, since there's no atomicity guarantee for code fetch.  We have 
> >> to to be out of guest mode while writing that insn.
> >>     
> >
> >
> > Hrm, good catch.
> >
> > How can we get out of guest mode given SMP guest support?
> >
> >   
> 
> kvm_flush_remote_tlbs() is something that can be generalized.  
> Basically, you set a bit in each vcpu and send an IPI to take them out.
> 
> But that's deadlock prone and complex.  Maybe you can just take 
> kvm->lock, zap the mmu and the flush tlbs, and patch the instruction at 
> your leisure, as no vcpu will be able to map memory until the lock is 
> released.

This works for shadow paging but not necessarily with NPT.  Do code
fetches really not respect atomic writes?  We could switch to a 32-bit
atomic operation and that should result in no worse than the code being
patched twice.

Regards,

Anthony Liguori


