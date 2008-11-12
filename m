Return-Path: <linux-kernel-owner+w=401wt.eu-S1754471AbYKLWJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbYKLWJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 17:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbYKLWJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 17:09:13 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:8132 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbYKLWJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 17:09:12 -0500
Subject: Re: [PATCH 2/4] Add replace_page(), change the mapping of pte from
	one page into another
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Izik Eidus <ieidus@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kvm@vger.kernel.org, chrisw@redhat.com,
       avi@redhat.com, izike@qumranet.com
In-Reply-To: <Pine.LNX.4.64.0811121412130.31606@quilx.com>
References: <1226409701-14831-3-git-send-email-ieidus@redhat.com>
	 <20081111114555.eb808843.akpm@linux-foundation.org>
	 <20081111210655.GG10818@random.random>
	 <Pine.LNX.4.64.0811111522150.27767@quilx.com>
	 <20081111221753.GK10818@random.random>
	 <Pine.LNX.4.64.0811111626520.29222@quilx.com>
	 <20081111231722.GR10818@random.random>
	 <Pine.LNX.4.64.0811111823030.31625@quilx.com>
	 <20081112022701.GT10818@random.random>
	 <Pine.LNX.4.64.0811112109390.10501@quilx.com>
	 <20081112173258.GX10818@random.random>
	 <Pine.LNX.4.64.0811121412130.31606@quilx.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Wed, 12 Nov 2008 17:09:03 -0500
Message-Id: <1226527744.7560.93.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-12 at 14:27 -0600, Christoph Lameter wrote:
> On Wed, 12 Nov 2008, Andrea Arcangeli wrote:
> 
> > On Tue, Nov 11, 2008 at 09:10:45PM -0600, Christoph Lameter wrote:
> > > get_user_pages() cannot get to it since the pagetables have already been
> > > modified. If get_user_pages runs then the fault handling will occur
> > > which will block the thread until migration is complete.
> >
> > migrate.c does nothing for ptes pointing to swap entries and
> > do_swap_page won't wait for them either. Assume follow_page in
> 
> If a anonymous page is a swap page then it has a mapping.
> migrate_page_move_mapping() will lock the radix tree and ensure that no
> additional reference (like done by do_swap_page) is established during
> migration.

So, it's Nick's reference freezing you asked about in response to my
mail that prevents do_swap_page() from getting another reference on the
page in the swap cache just after migrate_page_move_mapping() checks the
ref count and replaces the slot with new swap pte.  Radix tree lock just
prevents other threads from modifying the slot, right?  [Hmmm, looks
like we need to update the reference to "write lock" in the comments on
the 'deref_slot() and _replace_slot() definitions in radix-tree.h.]  

Therefore, do_swap_page() will either get the old page and raise the ref
before migration check, or it will [possibly loop in find_get_page() and
then] get the new page.

Migration will bail out, for this pass anyway, in the former case.  In
the second case, do_swap_page() will wait on the new page lock until
migration completes, deferring any direct IO. 

Or am I still missing something?

> 
> > However it's not exactly the same bug as the one in fork, I was
> > talking about before, it's also not o_direct specific. Still
> 
> So far I have seen wild ideas not bugs.

Maybe not so wild, given the complexity of these interactions... 

Later,
Lee


