Return-Path: <linux-kernel-owner+w=401wt.eu-S932684AbXBYUGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684AbXBYUGa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 15:06:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964777AbXBYUGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 15:06:30 -0500
Received: from mail.screens.ru ([213.234.233.54]:36238 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932684AbXBYUGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 15:06:30 -0500
Date: Sun, 25 Feb 2007 23:05:50 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Hugh Dickins <hugh@veritas.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, dipankar@in.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: PREEMPT_RCU breaks anon_vma locking ?
Message-ID: <20070225200550.GA497@tv-sign.ru>
References: <20070223212303.GA423@tv-sign.ru> <Pine.LNX.4.64.0702242203080.4370@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702242203080.4370@blonde.wat.veritas.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24, Hugh Dickins wrote:
>
> On Sat, 24 Feb 2007, Oleg Nesterov wrote:
> 
> > So page_lock_anon_vma() works correctly due to SLAB_DESTROY_BY_RCU even if
> > anon_vma_unlink() has already freed anon_vma. In that case we should see
> > list_empty(&anon_vma->head), we are safe.
> 
> (It doesn't affect your argument, but we won't necessarily see list_empty
> there: the anon_vma slot may already have got reused for a different
> bundle of vmas completely; but its lock remains a lock and its list
> remains a list of vmas, and the worst that happens is that
> page_referenced_anon or try_to_unmap_anon wanders through an irrelevant
> bundle of vmas, looking for a page that cannot be found there.)

Yes, but in that case we are safe, right? We hold the lock, anon_vma can't be
freed. But thanks for clarification! Somehow I missed that not only unlock()
is unsafe (in theory). If anon_vma's memory was re-used for something else, we
can't assume that we will see list_empty(&anon_vma->head).

> > 	static inline void page_lock_anon_vma(struct anon_vma *anon_vma)
> 
> It might be wiser to call that one page_unlock_anon_vma ;)

Congratulations, you passed the test! Paul didn't :)

> (I'm slightly disgruntled that page_lock_anon_vma takes a struct page *,
> but page_unlock_anon_vma no struct page *.  But it would be silly to do
> it differently, or mess with the naming: besides, it's a static function
> and the prototype guards against error anyway.)

OK. I thought about "unlock_anon_vma", but symmetry is good indeed.

Oleg.

