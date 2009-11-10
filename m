Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497AbZKJWJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbZKJWJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbZKJWJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:09:20 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60623 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbZKJWJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:09:20 -0500
Subject: Re: [PATCH 5/6] mm: stop ptlock enlarging struct page
From: Peter Zijlstra <peterz@infradead.org>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Izik Eidus <ieidus@redhat.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0911102200480.2816@sister.anvils>
References: <Pine.LNX.4.64.0911102142570.2272@sister.anvils>
	 <Pine.LNX.4.64.0911102200480.2816@sister.anvils>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Nov 2009 23:09:19 +0100
Message-ID: <1257890959.4108.496.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-10 at 22:02 +0000, Hugh Dickins wrote:
> CONFIG_DEBUG_SPINLOCK adds 12 or 16 bytes to a 32- or 64-bit spinlock_t,
> and CONFIG_DEBUG_LOCK_ALLOC adds another 12 or 24 bytes to it: lockdep
> enables both of those, and CONFIG_LOCK_STAT adds 8 or 16 bytes to that.
> 
> When 2.6.15 placed the split page table lock inside struct page (usually
> sized 32 or 56 bytes), only CONFIG_DEBUG_SPINLOCK was a possibility, and
> we ignored the enlargement (but fitted in CONFIG_GENERIC_LOCKBREAK's 4
> by letting the spinlock_t occupy both page->private and page->mapping).
> 
> Should these debugging options be allowed to double the size of a struct
> page, when only one minority use of the page (as a page table) needs to
> fit a spinlock in there?  Perhaps not.
> 
> Take the easy way out: switch off SPLIT_PTLOCK_CPUS when DEBUG_SPINLOCK
> or DEBUG_LOCK_ALLOC is in force.  I've sometimes tried to be cleverer,
> kmallocing a cacheline for the spinlock when it doesn't fit, but given
> up each time.  Falling back to mm->page_table_lock (as we do when ptlock
> is not split) lets lockdep check out the strictest path anyway.

Why? we know lockdep bloats stuff we never cared.. and hiding a popular
CONFIG option from lockdep doesn't seem like a good idea to me.

> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> ---
> 
>  mm/Kconfig |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> --- mm4/mm/Kconfig	2009-11-04 10:52:58.000000000 +0000
> +++ mm5/mm/Kconfig	2009-11-04 10:53:13.000000000 +0000
> @@ -161,11 +161,13 @@ config PAGEFLAGS_EXTENDED
>  # Default to 4 for wider testing, though 8 might be more appropriate.
>  # ARM's adjust_pte (unused if VIPT) depends on mm-wide page_table_lock.
>  # PA-RISC 7xxx's spinlock_t would enlarge struct page from 32 to 44 bytes.
> +# DEBUG_SPINLOCK and DEBUG_LOCK_ALLOC spinlock_t also enlarge struct page.
>  #
>  config SPLIT_PTLOCK_CPUS
>  	int
> -	default "4096" if ARM && !CPU_CACHE_VIPT
> -	default "4096" if PARISC && !PA20
> +	default "999999" if ARM && !CPU_CACHE_VIPT
> +	default "999999" if PARISC && !PA20
> +	default "999999" if DEBUG_SPINLOCK || DEBUG_LOCK_ALLOC
>  	default "4"
>  
>  #


