Return-Path: <linux-kernel-owner+w=401wt.eu-S932242AbZKMTzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242AbZKMTzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 14:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757464AbZKMTzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 14:55:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38705 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757403AbZKMTzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 14:55:13 -0500
Date: Fri, 13 Nov 2009 11:54:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: d451564 breakage
Message-Id: <20091113115429.94e0885b.akpm@linux-foundation.org>
In-Reply-To: <20091113151119.GA27752@flint.arm.linux.org.uk>
References: <20091113151119.GA27752@flint.arm.linux.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Nov 2009 15:11:19 +0000
Russell King <rmk@arm.linux.org.uk> wrote:

> Change:
> 
> highmem: Fix debug_kmap_atomic() to also handle KM_IRQ_PTE, KM_NMI, and KM_NMI_PTE
> 
> Appears to break ARM:
> 
> mm/highmem.c: In function ___debug_kmap_atomic___:
> mm/highmem.c:436: error: ___KM_NMI___ undeclared (first use in this function)
> mm/highmem.c:436: error: (Each undeclared identifier is reported only once
> mm/highmem.c:436: error: for each function it appears in.)
> mm/highmem.c:436: error: ___KM_NMI_PTE___ undeclared (first use in this function)
> mm/highmem.c:443: error: ___KM_IRQ_PTE___ undeclared (first use in this function)
> make[2]: *** [mm/highmem.o] Error 1
> make[1]: *** [mm] Error 2
> 
> I'd prefer not to have to add these definitions just so that highmem
> debugging can work for two reasons:
> 
> 1. either we allocate mappings for these which will never be used, which
>    unnecessarily wastes precious virtual memory space.
> 
> 2. we define them to be some other KM_* value and hope that they never
>    get used.  If they do get used, we'll never know by way of compiler
>    error but could result in silent data corruption.
> 
> The only sane alternative I can see would be to define these as KM_TYPE_NR
> and either ensure that kmap_atomic() always fails for out-of-bounds kmap
> types (more preferable to catch problems but has a performance impact) or
> we have the kmap debugging detect this as well.
> 
> Any preferences?

Could we do something nasty with ifdefs?

In arch header:
#define KM_NMI KM_NMI


In generic code:
#ifdef KM_NMI
	<stuff which references KM_NMI>
#endif

or similar?
