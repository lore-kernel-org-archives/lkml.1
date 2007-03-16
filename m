Return-Path: <linux-kernel-owner+w=401wt.eu-S965880AbXCPTRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965880AbXCPTRK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 15:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965882AbXCPTRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 15:17:10 -0400
Received: from gw.goop.org ([64.81.55.164]:33411 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965880AbXCPTRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 15:17:08 -0400
Message-ID: <45FAED2B.8070403@goop.org>
Date: Fri, 16 Mar 2007 12:16:59 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: David Miller <davem@davemloft.net>, ak@muc.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, chrisw@sous-sol.org, zach@vmware.com,
       rusty@rustcorp.com.au, anthony@codemonkey.ws,
       torvalds@linux-foundation.org
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops
 callsites to make them patchable
References: <20070301232443.195603797@goop.org> <20070301232527.956565107@goop.org> <20070316092445.GM23174@elte.hu> <20070316.023331.59468179.davem@davemloft.net> <20070316095702.GA301@elte.hu>
In-Reply-To: <20070316095702.GA301@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> * David Miller <davem@davemloft.net> wrote:

> > Perhaps the problem can be dealt with using ELF relocations.
> > 
> > There is another case, discussed yesterday on netdev, where run-time 
> > resolution of ELF relocations would be useful (for 
> > very-very-very-read-only variables) so if it can solve this problem 
> > too it would be nice to have a generic infrastructure for it.
>   


> yeah, and i really think this is very fundamental: [...]

I think what Dave is suggesting is that we use the reloc information the
compiler generates to find the patchable callsites rather than have
special wrappers.  This is an interesting idea.

> Limited, instruction-level patching like alternatives.h is fine because 
> that makes it easier to support multiple, incompatible CPU 
> architectures, without having to do a hugely intrusive split at the 
> kernel RPM level.
>
> but the level of 'binary patching' done by the paravirt and Xen goes way 
> beyond that,

Not really.  There are only three cases:

   1. replace an indirect call with a direct call
   2. nop out a callsite
   3. patch in a short inline sequence

And as I pointed out, this is used by all pv_op backends, using a common
piece of code to implement at least 1 and 2.  3 could be implemented
semi-generically by using rules like "if (func == native_sti) {
patch("sti"); }", which would cover many cases where a hypervisor
doesn't need any special handling for a particular operation.

The goal is to eliminate the cost of the indirect calls with nice
predictable indirect calls.  There's a 1 byte/callsite overhead, but I
don't think that's a horrible overhead.

And, at worst, its only a little more complex than the kinds of
transformations.

Ideally, its a mechanism which could be used elsewhere.  It applies with
you have some kind of ops_vector table which is updated once (or perhaps
very rarely), and you don't want to wear the overhead of indirect calls
everywhere.

>  and the changes here really underscore that we:
>
>   _should not emulate the closed source world_
>
> There the only solution is to binary-patch - because they have no source 
> code. But here, we've got all the source code.
>   

I don't think this is a relevant comparison.  This is purely a matter of
optimising out unnecessary indirect calls.

> nobody wants to boot a xen-paravirt kernel from a floppy, so image size 
> is not an issue. In-RAM overhead would in fact be /reduced/, because 
> currently all the paravirt overhead hits both the native and the 
> paravirt kernel. Nor would /all/ of the vmlinuz have to be replicated in 
> the images - it's enough to replicate only those functions that truly 
> differ between the two build methods.

One of the explicit goals of pv_ops was to allow a single kernel to
either boot on native hardware or under any one of the supported
hypervisors, explicitly to avoid having to manage multiple kernel
images.  Compiling the kernel N+1 times for N hypervisors, and then
bundling them up in some kind of multi-image format doesn't seem like a
particularly good tradeoff.  The kernel RPM on my machine here is
already ~50Mbytes; expanding that to 250Mbytes to support native, Xen,
vmi, lguest and kvm doesn't seem reasonable.

    J
