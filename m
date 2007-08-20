Return-Path: <linux-kernel-owner+w=401wt.eu-S1758707AbXHTIdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707AbXHTIdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 04:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbXHTIde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 04:33:34 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34493 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751840AbXHTIdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 04:33:33 -0400
Date: Mon, 20 Aug 2007 09:41:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Dave Airlie" <airlied@gmail.com>
Cc: dri-devel <dri-devel@lists.sourceforge.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: uncached page allocator
Message-ID: <20070820094125.209e0811@the-village.bc.nu>
In-Reply-To: <21d7e9970708191745h3b579f3bp72f138e089c624da@mail.gmail.com>
References: <21d7e9970708191745h3b579f3bp72f138e089c624da@mail.gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> allocate pixmap gets cached memory
> copy data into the pixmap
> pre-use from hardware we flush the cache lines and tlb
> use the pixmap in hardware
> pre-free we need to set the page back to cached so we flush the tlb
> free the memory.

> Now the big issue here on SMP is that the cache and/or tlb flushes
> require IPIs and they are very noticeable on the profiles,

Blame intel ;)

> Any other ideas and suggestions?

Without knowing exactly what you are doing:

- Copies to uncached memory are very expensive on an x86 processor
(so it might be faster not to write and flush)
- Its not clear from your description how intelligent your transfer
system is.


I'd expect for example that the process was something like

	Parse pending commands until either
	1. Queue empties
	2. A time target passes

	For each command we need to shove a pixmap over add it
	to the buffer to transfer

	Do a single CLFLUSH and maybe IPI

	Fire up the command queue

	Keep the buffers hanging around until there is memory pressure
	if we may reuse that pixmap

Can you clarify that ?

If the hugepage anti-frag stuff ever gets merged this would also help as
you could possibly grab a huge page from the allocator for this purpose
and have to flip only one TLB entry.

Alan
