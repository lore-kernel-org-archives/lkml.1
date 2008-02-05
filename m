Return-Path: <linux-kernel-owner+w=401wt.eu-S1759275AbYBESSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275AbYBESSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 13:18:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759123AbYBESS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 13:18:26 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36861 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759116AbYBESSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:18:25 -0500
Subject: Re: [patch 1/6] mmu_notifier: Core code
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrea Arcangeli <andrea@qumranet.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
In-Reply-To: <20080205180557.GC29502@shadowen.org>
References: <20080128202840.974253868@sgi.com>
	 <20080128202923.609249585@sgi.com>  <20080205180557.GC29502@shadowen.org>
Content-Type: text/plain
Date: Tue, 05 Feb 2008 19:17:52 +0100
Message-Id: <1202235473.19243.25.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-05 at 18:05 +0000, Andy Whitcroft wrote:

> > +	if (unlikely(!hlist_empty(&mm->mmu_notifier.head))) {
> > +		rcu_read_lock();
> > +		hlist_for_each_entry_safe_rcu(mn, n, t,
> > +					  &mm->mmu_notifier.head, hlist) {
> > +			if (mn->ops->release)
> > +				mn->ops->release(mn, mm);
> 
> Does this ->release actually release the 'nm' and its associated hlist?
> I see in this thread that this ordering is deemed "use after free" which
> implies so.
> 
> If it does that seems wrong.  This is an RCU hlist, therefore the list
> integrity must be maintained through the next grace period in case there
> are parallell readers using the element, in particular its forward
> pointer for traversal.

That is not quite so, list elements must be preserved, not the list
order.

> 
> > +			hlist_del(&mn->hlist);
> 
> For this to be updating the list, you must have some form of "write-side"
> exclusion as these primatives are not "parallel write safe".  It would
> be helpful for this routine to state what that write side exclusion is.

Yeah, has been noticed, read on in the thread :-)

> I am not sure it makes sense to add a _safe_rcu variant.  As I understand
> things an _safe variant is used where we are going to remove the current
> list element in the middle of a list walk.  However the key feature of an
> RCU data structure is that it will always be in a "safe" state until any
> parallel readers have completed.  For an hlist this means that the removed
> entry and its forward link must remain valid for as long as there may be
> a parallel reader traversing this list, ie. until the next grace period.
> If this link is valid for the parallel reader, then it must be valid for
> us, and if so it feels that hlist_for_each_entry_rcu should be sufficient
> to cope in the face of entries being unlinked as we traverse the list.

It does make sense, hlist_del_rcu() maintains the fwd reference, but it
does unlink it from the list proper. As long as there is a write side
exclusion around the actual removal as you noted.

rcu_read_lock();
hlist_for_each_entry_safe_rcu(tpos, pos, n, head, member) {

	if (foo) {
		spin_lock(write_lock);
		hlist_del_rcu(tpos);
		spin_unlock(write_unlock);
	}
}
rcu_read_unlock();

is a safe construct in that the list itself stays a proper list, and
even items that might be caught in the to-be-deleted entries will have a
fwd way out.

