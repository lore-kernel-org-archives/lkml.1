Return-Path: <linux-kernel-owner+w=401wt.eu-S1751040AbXBZBxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751040AbXBZBxP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 20:53:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbXBZBxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 20:53:15 -0500
Received: from pool-71-111-73-6.ptldor.dsl-w.verizon.net ([71.111.73.6]:27964
	"EHLO IBM-8EC8B5596CA.beaverton.ibm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751037AbXBZBxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 20:53:14 -0500
Date: Sun, 25 Feb 2007 17:53:22 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Hugh Dickins <hugh@veritas.com>, dipankar@in.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: PREEMPT_RCU breaks anon_vma locking ?
Message-ID: <20070226015322.GO5049@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070223212303.GA423@tv-sign.ru> <Pine.LNX.4.64.0702242203080.4370@blonde.wat.veritas.com> <20070225200550.GA497@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070225200550.GA497@tv-sign.ru>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 25, 2007 at 11:05:50PM +0300, Oleg Nesterov wrote:
> On 02/24, Hugh Dickins wrote:
> >
> > On Sat, 24 Feb 2007, Oleg Nesterov wrote:
> > 
> > > So page_lock_anon_vma() works correctly due to SLAB_DESTROY_BY_RCU even if
> > > anon_vma_unlink() has already freed anon_vma. In that case we should see
> > > list_empty(&anon_vma->head), we are safe.
> > 
> > (It doesn't affect your argument, but we won't necessarily see list_empty
> > there: the anon_vma slot may already have got reused for a different
> > bundle of vmas completely; but its lock remains a lock and its list
> > remains a list of vmas, and the worst that happens is that
> > page_referenced_anon or try_to_unmap_anon wanders through an irrelevant
> > bundle of vmas, looking for a page that cannot be found there.)
> 
> Yes, but in that case we are safe, right? We hold the lock, anon_vma can't be
> freed. But thanks for clarification! Somehow I missed that not only unlock()
> is unsafe (in theory). If anon_vma's memory was re-used for something else, we
> can't assume that we will see list_empty(&anon_vma->head).
> 
> > > 	static inline void page_lock_anon_vma(struct anon_vma *anon_vma)
> > 
> > It might be wiser to call that one page_unlock_anon_vma ;)
> 
> Congratulations, you passed the test! Paul didn't :)

What is in a name?  ;-)

						Thanx, Paul

> > (I'm slightly disgruntled that page_lock_anon_vma takes a struct page *,
> > but page_unlock_anon_vma no struct page *.  But it would be silly to do
> > it differently, or mess with the naming: besides, it's a static function
> > and the prototype guards against error anyway.)
> 
> OK. I thought about "unlock_anon_vma", but symmetry is good indeed.
> 
> Oleg.
> 
