Return-Path: <linux-kernel-owner+w=401wt.eu-S1754922AbYFBUJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbYFBUJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 16:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbYFBUJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 16:09:27 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:49491 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751516AbYFBUJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 16:09:26 -0400
Subject: Re: [PATCH 0 of 4] mm+paravirt+xen: add
	pte	read-modify-write	abstraction
From: Zachary Amsden <zach@vmware.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hugh@veritas.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <48409847.4000902@goop.org>
References: <patchbomb.1211552448@localhost>
	 <1211567273.7465.36.camel@bodhitayantram.eng.vmware.com>
	 <483729E7.9010002@goop.org>
	 <1211585122.7465.70.camel@bodhitayantram.eng.vmware.com>
	 <48409847.4000902@goop.org>
Content-Type: text/plain
Date: Mon, 02 Jun 2008 13:09:53 -0700
Message-Id: <1212437393.972.50.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-05-31 at 01:13 +0100, Jeremy Fitzhardinge wrote:
> Zachary Amsden wrote:
> > We don't fault.  We write directly to the primary page tables, and clear
> > the pte just like native.  We just issue all mprotect updates in the
> > queue, and flush the queue when leaving lazy mmu mode.  You can't wait
> > for the TLB flush, you must flush the updates before releasing the
> > pagetable lock, or you could get misordered updates in an SMP system.
> >   
> 
> How do you track which ptes need shadow updates?  Do you walk the entire 
> pagetable on tlb flush?  Or just rebuild the shadow from scratch on demand?

No, we queue the updates as well as writing the primaries, we just flush
the queue before dropping the PT lock for one trip to the hypervisor.

