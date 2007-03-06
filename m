Return-Path: <linux-kernel-owner+w=401wt.eu-S1030257AbXCFVqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030257AbXCFVqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 16:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030258AbXCFVqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 16:46:39 -0500
Received: from gw.goop.org ([64.81.55.164]:59115 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030257AbXCFVqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 16:46:37 -0500
Message-ID: <45EDE13A.4070204@goop.org>
Date: Tue, 06 Mar 2007 13:46:34 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Nakajima, Jun" <jun.nakajima@intel.com>,
       virtualization <virtualization@lists.osdl.org>,
       Roland McGrath <roland@redhat.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@novell.com>
Subject: Re: Xen & VMI?
References: <45ED82D9.6050204@codemonkey.ws> <8FFF7E42E93CC646B632AB40643802A80229779B@scsmsx412.amr.corp.intel.com> <20070306203712.GC21736@elte.hu> <45EDD6F1.7080100@goop.org> <20070306211105.GD26348@elte.hu> <45EDD96D.1030108@goop.org> <20070306212037.GB31568@elte.hu>
In-Reply-To: <20070306212037.GB31568@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 1 sane ABI instead of 4 parallel ones? It's the same difference as the 
> difference between 300 system calls and 1200 system calls. Alot more 
> focus, alot more integration, alot less pain. Every time i change a 
> detail in Linux i have to update (and think about) 1 virtualization 
> aspect - not 4 (or more).
>   

But you're just pushing the problem off; it doesn't go away, and it
doesn't really stop being your problem.  If you change the way you use
the abi and something breaks in one of its implementations, you're still
going to get "wahh, you broke Xen/ESX/whatever".  And then you either
have to wait for the ABI implementation to get fixed, or work around it
on the Linux side.

I don't see why you think an ABI is easier to reason about than the
pv_ops api?  If you're going to make a kernel change that has an effect
on the API, its also going to have an effect on the ABI, but with the
ABI you're stuck waiting for the ABI to catch up before you can do
something.  If your kernel change relies on pv_ops but won't need to
change it, then reasoning about the pv_ops API is enough to make things
work.

pvops has, what, about 90 calls in it, which break down into a few broad
classes:

   1. various setup things, which more or less correspond to subsystems
      (interrupts, time, memory, etc)
   2. calls which are direct analogues of hardware operations
   3. pagetable/tlb operations
   4. random corner cases (like the apic stuff to plug into ESX's apic
      emulation)

The (functionally) large missing component is SMP support, though I
expect that will only come down to a handful of extra operations.

All of these operations are pretty easily understood in their own terms
at the pv_ops interface level.  Knowing how the pv_ops backends map
these onto a particular hypercall interface is not really necessary to
understand the pv_ops interface, though its readily visible by reading
the source.  But if you need to look and change it, you can; hiding it
under a layer of magic ABI dust isn't going to fix that.

The other big part that's missing from paravirt_ops is all the hooks for
calling back into the kernel - because they're not necessary.  You
skipped that point in my earlier mail, but it is important.  A basic
element in Xen's design is that it interacts with the guest kernel in a
fairly high level, and makes use of existing kernel mechanisms whereever
possible.  How do you see that working in your proposal?

    J
