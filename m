Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab0COG2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 02:28:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565Ab0COG2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 02:28:12 -0400
Date: Mon, 15 Mar 2010 03:27:21 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/18][RFC] Nested Paging support for Nested SVM (aka
 NPT-Virtualization)
Message-ID: <20100315062721.GA3654@amt.cnet>
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
 <20100304144255.GA26657@amt.cnet>
 <20100304155820.GA6019@amd.com>
 <20100311205803.GA18849@amt.cnet>
 <4B99EF09.1080608@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B99EF09.1080608@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 09:36:41AM +0200, Avi Kivity wrote:
> On 03/11/2010 10:58 PM, Marcelo Tosatti wrote:
> >
> >>>Can't you translate l2_gpa ->  l1_gpa walking the current l1 nested
> >>>pagetable, and pass that to the kvm tdp fault path (with the correct
> >>>context setup)?
> >>If I understand your suggestion correctly, I think thats exactly whats
> >>done in the patches. Some words about the design:
> >>
> >>For nested-nested we need to shadow the l1-nested-ptable on the host.
> >>This is done using the vcpu->arch.mmu context which holds the l1 paging
> >>modes while the l2 is running. On a npt-fault from the l2 we just
> >>instrument the shadow-ptable code. This is the common case. because it
> >>happens all the time while the l2 is running.
> >OK, makes sense now, I was missing the fact that the l1-nested-ptable
> >needs to be shadowed and l1 translations to it must be write protected.
> 
> Shadow converts (gva -> gpa -> hpa) to (gva -> hpa) or (ngpa -> gpa
> -> hpa) to (ngpa -> hpa) equally well.  In the second case npt still
> does (ngva -> ngpa).
> 
> >You should disable out of sync shadow so that l1 guest writes to
> >l1-nested-ptables always trap.
> 
> Why?  The guest is under obligation to flush the tlb if it writes to
> a page table, and we will resync on that tlb flush.

The guests hypervisor will not flush the tlb with invlpg for updates of
its NPT pagetables. It'll create a new ASID, and KVM will not trap
that.

> Unsync makes just as much sense for nnpt.  Think of khugepaged in
> the guest eating a page table and spitting out a PDE.
> 
> >And in the trap case, you'd have to
> >invalidate l2 shadow pagetable entries that used the (now obsolete)
> >l1-nested-ptable entry. Does that happen automatically?
> 
> What do you mean by 'l2 shadow ptable entries'?  There are the
> guest's page tables (ordinary direct mapped, unless the guest's
> guest is also running an npt-enabled hypervisor), and the host page
> tables.  When the guest writes to each page table, we invalidate the
> shadows.

With 'l2 shadow ptable entries' i mean the shadow pagetables that
translate GPA-L2 -> HPA.
