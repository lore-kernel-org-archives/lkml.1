Return-Path: <linux-kernel-owner+w=401wt.eu-S933334AbXDFXl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334AbXDFXl6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 19:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933410AbXDFXl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 19:41:57 -0400
Received: from smtp.osdl.org ([65.172.181.24]:38862 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933334AbXDFXl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 19:41:56 -0400
Date: Fri, 6 Apr 2007 16:41:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Zachary Amsden <zach@vmware.com>, Christoph Lameter <clameter@sgi.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 07/20] Allow paravirt backend to choose kernel PMD
 sharing
Message-Id: <20070406164139.08cd343b.akpm@linux-foundation.org>
In-Reply-To: <20070404191205.392155702@goop.org>
References: <20070404191151.009821039@goop.org>
	<20070404191205.392155702@goop.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Apr 2007 12:11:58 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Normally when running in PAE mode, the 4th PMD maps the kernel address
> space, which can be shared among all processes (since they all need
> the same kernel mappings).
> 
> Xen, however, does not allow guests to have the kernel pmd shared
> between page tables, so parameterize pgtable.c to allow both modes of
> operation.
> 
> There are several side-effects of this.  One is that vmalloc will
> update the kernel address space mappings, and those updates need to be
> propagated into all processes if the kernel mappings are not
> intrinsically shared.  In the non-PAE case, this is done by
> maintaining a pgd_list of all processes; this list is used when all
> process pagetables must be updated.  pgd_list is threaded via
> otherwise unused entries in the page structure for the pgd, which
> means that the pgd must be page-sized for this to work.
> 
> Normally the PAE pgd is only 4x64 byte entries large, but Xen requires
> the PAE pgd to page aligned anyway, so this patch forces the pgd to be
> page aligned+sized when the kernel pmd is unshared, to accomodate both
> these requirements.
> 
> Also, since there may be several distinct kernel pmds (if the
> user/kernel split is below 3G), there's no point in allocating them
> from a slab cache; they're just allocated with get_free_page and
> initialized appropriately.  (Of course the could be cached if there is
> just a single kernel pmd - which is the default with a 3G user/kernel
> split - but it doesn't seem worthwhile to add yet another case into
> this code).

All this paravirt stuff isn't making the kernel any prettier, is it?

> ...
>  
> -#ifndef CONFIG_X86_PAE
> -void vmalloc_sync_all(void)
> +void _vmalloc_sync_all(void)
>  {
>  	/*
>  	 * Note that races in the updates of insync and start aren't
> @@ -600,6 +599,8 @@ void vmalloc_sync_all(void)
>  	static DECLARE_BITMAP(insync, PTRS_PER_PGD);
>  	static unsigned long start = TASK_SIZE;
>  	unsigned long address;
> +
> +	BUG_ON(SHARED_KERNEL_PMD);
>  
>  	BUILD_BUG_ON(TASK_SIZE & ~PGDIR_MASK);
>  	for (address = start; address >= TASK_SIZE; address += PGDIR_SIZE) {
> @@ -623,4 +624,3 @@ void vmalloc_sync_all(void)
>  			start = address + PGDIR_SIZE;
>  	}
>  }

This is a functional change for non-paravirt kernels.  Non-PAE kernels now
get a vmalloc_sync_all().  How come?

We normally use double-underscore for things like this.

Your change clashes pretty fundamantally with
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm4/broken-out/move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all.patch,
and
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm4/broken-out/move-die-notifier-handling-to-common-code.patch
_does_ make the kernel prettier.

But I'm a bit reluctant to rework
move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all.patch
(somehow) until I understand why your patch is a) futzing with non-PAE,
non-paravirt code and b) overengineered.

Why didn't you just stick a

	if (SHARED_KERNEL_PMD)
		return;

into vmalloc_sync_all()?


