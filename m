Return-Path: <linux-kernel-owner+w=401wt.eu-S1757158AbZKRXSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158AbZKRXSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 18:18:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690AbZKRXSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 18:18:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53034 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753685AbZKRXSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 18:18:07 -0500
Date: Wed, 18 Nov 2009 15:18:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH]  [for mmotm-1113] mm: Simplify try_to_unmap_one()
Message-Id: <20091118151803.35f55ca3.akpm@linux-foundation.org>
In-Reply-To: <20091117173759.3DF6.A69D9226@jp.fujitsu.com>
References: <20091117173759.3DF6.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Nov 2009 17:39:27 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> +out_mlock:
> +	pte_unmap_unlock(pte, ptl);
> +
> +	if (down_read_trylock(&vma->vm_mm->mmap_sem)) {
> +		if (vma->vm_flags & VM_LOCKED) {
> +			mlock_vma_page(page);
> +			ret = SWAP_MLOCK;
>  		}
> +		up_read(&vma->vm_mm->mmap_sem);

It's somewhat unobvious why we're using a trylock here.  Ranking versus
lock_page(), perhaps?

In general I think a trylock should have an associated comment which explains

a) why it is being used at this site and

b) what happens when the trylock fails - why this isn't a
   bug, how the kernel recovers from the inconsistency, what its
   overall effect is, etc.

<wonders why we need to take mmap_sem here at all>
