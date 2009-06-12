Return-Path: <linux-kernel-owner+w=401wt.eu-S1758373AbZFLE0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373AbZFLE0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 00:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbZFLE0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 00:26:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:53022 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbZFLE0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 00:26:04 -0400
Subject: Re: slab: setup allocators earlier in the boot sequence
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <1244779009.7172.52.camel@pasglop>
References: <200906111959.n5BJxFj9021205@hera.kernel.org>
	 <1244770230.7172.4.camel@pasglop>  <1244779009.7172.52.camel@pasglop>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 14:25:56 +1000
Message-Id: <1244780756.7172.58.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 13:56 +1000, Benjamin Herrenschmidt wrote:
> > This seem to explode in various places on powerpc :-(
> 
> Main breakage is that slab now gets used a lot earlier than init_IRQ and
> time_init(), but kmalloc() internally hard-enables interrupts when
> GFP_WAIT is passed (it should not but that another side effect of the
> change, see below). So we have the decrementer (CPU timer) popping and
> it crashes on uninitialized data structures in the timer code.
> 
> The reason GFP_WAIT is passed comes from various bits of init code we
> have using a function we call alloc_maybe_bootmem() which does kmalloc
> if initialized and alloc_bootmem() before...

 .../...

And that's not the only problem. The next one is a bit more sneaky, and
I suppose doesn't hit only us...

I'm not sure what's the right fix other than going all the way to having
kmalloc() automagically mask out bits when called at the wrong time.

Typically, what happens here is ioremap() causes __get_vm_area() which
blows up because it does GFP_KERNEL.

Now, that used to work because we have a trick for early ioremap's
(which the arch need, since we do need to ioremap very early, for things
like accessing memory mapped interrupt controllers, or other various low
level platform things).

What we do is VMALLOC_END is defined to be a variable (which we misnamed
ioremap_bot for historical reasons). If ioremap is called before
mem_init() then we allocate virtual space by moving down that variable.
Else, we use get_vm_area().

Now this is broken with the change because after mem_init(), we now use
get_vm_area() which does a kmalloc(...,GFP_KERNEL), which explodes
because it turns on interrupts way too early.

I'll cook up a patch that defines a global bitmask of "forbidden" GFP
bits and see how things go.

Cheers,
Ben.


