Return-Path: <linux-kernel-owner+w=401wt.eu-S1759061AbZFLD5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759061AbZFLD5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 23:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbZFLD51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 23:57:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:37627 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbZFLD50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 23:57:26 -0400
Subject: Re: slab: setup allocators earlier in the boot sequence
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <1244770230.7172.4.camel@pasglop>
References: <200906111959.n5BJxFj9021205@hera.kernel.org>
	 <1244770230.7172.4.camel@pasglop>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 13:56:49 +1000
Message-Id: <1244779009.7172.52.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This seem to explode in various places on powerpc :-(

Main breakage is that slab now gets used a lot earlier than init_IRQ and
time_init(), but kmalloc() internally hard-enables interrupts when
GFP_WAIT is passed (it should not but that another side effect of the
change, see below). So we have the decrementer (CPU timer) popping and
it crashes on uninitialized data structures in the timer code.

The reason GFP_WAIT is passed comes from various bits of init code we
have using a function we call alloc_maybe_bootmem() which does kmalloc
if initialized and alloc_bootmem() before...

The problem is that we routinely call that with GFP_KERNEL since we used
to know it would default to bootmem before IRQs can be enabled safely,
which is no longer the case.

At this stage, I'm tempted to rip the all off and just use kmalloc
GFP_NOWAIT for now.

But it would be useful to have kmalloc -itself- remove GFP_WAIT when
called to early so that code doesn't have to do something different
depending on when it's called. In fact, we similarily need to remove
__GFP_IO/FS when in suspend/resume sequence...

For example, we have code for allocating IRQ remapping related data
structures that can be called very early at init_IRQ() time, or later if
some driver or bus wants to register a cascaded IRQ controller.

Cheers,
Ben.

