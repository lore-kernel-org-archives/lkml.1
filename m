Return-Path: <linux-kernel-owner+w=401wt.eu-S933853AbYBNVId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933853AbYBNVId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756717AbYBNVIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:08:22 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:23837 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228AbYBNVIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:08:21 -0500
Date: Thu, 14 Feb 2008 13:05:54 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       Daniel Walker <dwalker@mvista.com>, Ingo Molnar <mingo@elte.hu>,
       Richard Knutsson <ricknu-0@student.ltu.se>,
       Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 1/4] kmemcheck v4
Message-Id: <20080214130554.c7f963d1.randy.dunlap@oracle.com>
In-Reply-To: <47B49DB2.2090402@gmail.com>
References: <47B49DB2.2090402@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008 20:59:46 +0100 Vegard Nossum wrote:

> Greetings,
> 

Just a few doc comments (below).

> 
>  From 0fcca4341b6b1b277d936558aa3cab0f212bad9b Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Thu, 14 Feb 2008 19:10:40 +0100
> Subject: [PATCH] kmemcheck: add the core kmemcheck changes
> 
> General description: kmemcheck is a patch to the linux kernel that
> detects use of uninitialized memory. It does this by trapping every
> read and write to memory that was allocated dynamically (e.g. using
> kmalloc()). If a memory address is read that has not previously been
> written to, a message is printed to the kernel log.
> 
> Signed-off-by: Vegard Nossum <vegardno@ifi.uio.no>
> ---
>   Documentation/kmemcheck.txt    |   73 ++++
>   arch/x86/Kconfig.debug         |   35 ++
>   arch/x86/kernel/Makefile       |    2 +
>   arch/x86/kernel/kmemcheck_32.c |  781 ++++++++++++++++++++++++++++++++++++++++
>   include/asm-x86/kmemcheck.h    |    3 +
>   include/asm-x86/kmemcheck_32.h |   22 ++
>   include/asm-x86/pgtable.h      |    4 +-
>   include/asm-x86/pgtable_32.h   |    1 +
>   include/linux/gfp.h            |    3 +-
>   include/linux/kmemcheck.h      |   17 +
>   include/linux/page-flags.h     |    7 +
>   11 files changed, 945 insertions(+), 3 deletions(-)
>   create mode 100644 Documentation/kmemcheck.txt
>   create mode 100644 arch/x86/kernel/kmemcheck_32.c
>   create mode 100644 include/asm-x86/kmemcheck.h
>   create mode 100644 include/asm-x86/kmemcheck_32.h
>   create mode 100644 include/linux/kmemcheck.h
> 
> diff --git a/Documentation/kmemcheck.txt b/Documentation/kmemcheck.txt
> new file mode 100644
> index 0000000..d234571
> --- /dev/null
> +++ b/Documentation/kmemcheck.txt
> @@ -0,0 +1,73 @@

> +
> +Changes to the memory allocator (SLUB)
> +======================================
> +
> +kmemcheck requires some assistance from the memory allocator in order to work.
> +The memory allocator needs to
> +
> +1. Request twice as much memory as would normally be needed. The bottom half
> +   of the memory is what the user actually sees and uses; the upper half
> +   contains the so-called shadow memory, which stores the status of each byte
> +   in the bottom half, e.g. initialized or uninitialized.
> +2. Tell kmemcheck which parts of memory that should be marked uninitialized.

Drop "that".

> +   There are actually a few more states, such as "not yet allocated" and
> +   "recently freed".
> +
> +If a slab cache is set up using the SLAB_NOTRACK flag, it will never return
> +memory that can take page faults because of kmemcheck.
> +
> +If a slab cache is NOT set up using the SLAB_NOTRACK flag, callers can still
> +request memory with the __GFP_NOTRACK flag. This does not prevent the page
> +faults from occuring, however, but marks the object in question as being

               occurring,

> +initialized so that no warnings will ever be produced for this object.
> +
> +
> +Problems
> +========
> +
> +The most prominent problem seems to be that of bit-fields. kmemcheck can only
> +track memory with byte granularity. Therefore, when gcc generates code to
> +access only one bit in a bit-field, there is really no way for kmemcheck to
> +know which of the other bits that will be used or thrown away. Consequently,

Drop "that".

> +there may be bogus warnings for bit-field accesses. There is some experimental
> +support to detect this automatically, though it is probably better to work
> +around this by explicitly initializing whole bit-fields at once.
> +
> +Some allocations are used for DMA. As DMA doesn't go through the paging
> +mechanism, we have absolutely no way to detect DMA writes. This means that
> +spurious warnings may be seen on access to DMA memory. DMA allocations should
> +be annotated with the __GFP_NOTRACK flag or allocated from caches marked
> +SLAB_NOTRACK to work around this problem.
> +

---
~Randy
