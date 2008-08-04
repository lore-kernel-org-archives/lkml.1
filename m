Return-Path: <linux-kernel-owner+w=401wt.eu-S1759963AbYHDSty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759963AbYHDSty (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 14:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760325AbYHDStK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 14:49:10 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:57903 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758496AbYHDStH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 14:49:07 -0400
X-SourceIP: 80.57.229.25
Subject: Re: [PATCH] workaround minor lockdep bug triggered by
	mm_take_all_locks
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Dave Jones <davej@redhat.com>, Roland Dreier <rdreier@cisco.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080804175730.GL11476@duo.random>
References: <ada63qgvppx.fsf@cisco.com> <1217859571.3589.7.camel@twins>
	 <aday73cua99.fsf@cisco.com> <1217860332.3589.11.camel@twins>
	 <20080804145318.GA17867@redhat.com> <1217861763.3589.13.camel@twins>
	 <20080804162657.GI11476@duo.random> <1217867935.3589.35.camel@twins>
	 <20080804172728.GJ11476@duo.random> <20080804174659.GK11476@duo.random>
	 <20080804175730.GL11476@duo.random>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 20:48:59 +0200
Message-Id: <1217875739.3589.56.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 19:57 +0200, Andrea Arcangeli wrote:
> From: Andrea Arcangeli <andrea@qumranet.com>
> 
> Lockdep can't recognize if spinlocks are at a different address. So
> using trylock in a loop is one way to avoid lockdep to generate false
> positives. After lockdep will be fixed this change can and should be
> reverted.
> 
> Signed-off-by: Andrea Arcangeli <andrea@qumranet.com>

NAK, come-on, you didn't even bother to look at the available
annotations..

> ---
> 
> Resubmit because I didn't update the subject and so I improved the
> comments too. This is mostly to show it's a bug in lockdep and it can
> be trivially worked around without having to fix lockdep for real, any
> superior solution to this hack is more than welcome and recommended.
> 
> diff -r 3469dce61df1 mm/mmap.c
> --- a/mm/mmap.c	Tue Jul 29 20:01:28 2008 +0200
> +++ b/mm/mmap.c	Mon Aug 04 19:54:27 2008 +0200
> @@ -2279,8 +2279,12 @@ static void vm_lock_anon_vma(struct anon
>  		/*
>  		 * The LSB of head.next can't change from under us
>  		 * because we hold the mm_all_locks_mutex.
> +		 *
> +		 * spin_lock would confuse lockdep who doesn't notice
> +		 * the 'anon_vma' always changing address.
>  		 */
> -		spin_lock(&anon_vma->lock);
> +		while (!spin_trylock(&anon_vma->lock))
> +			cpu_relax();
>  		/*
>  		 * We can safely modify head.next after taking the
>  		 * anon_vma->lock. If some other vma in this mm shares
> @@ -2310,7 +2314,12 @@ static void vm_lock_mapping(struct addre
>  		 */
>  		if (test_and_set_bit(AS_MM_ALL_LOCKS, &mapping->flags))
>  			BUG();
> -		spin_lock(&mapping->i_mmap_lock);
> +		/*
> +		 * spin_lock would confuse lockdep who doesn't notice
> +		 * the 'mapping' always changing address.
> +		 */
> +		while (!spin_trylock(&mapping->i_mmap_lock))
> +			cpu_relax();
>  	}
>  }
>  

