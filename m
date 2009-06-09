Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbZFIQfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbZFIQfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 12:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756694AbZFIQfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 12:35:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:40615 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655AbZFIQfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 12:35:08 -0400
Date: Tue, 9 Jun 2009 18:35:08 +0200
From: Nick Piggin <npiggin@suse.de>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andi Kleen <andi@firstfloor.org>, riel@redhat.com, chris.mason@oracle.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com
Subject: Re: [PATCH] [13/16] HWPOISON: The high level memory error handler in the VM v5
Message-ID: <20090609163508.GD9211@wotan.suse.de>
References: <20090603846.816684333@firstfloor.org> <20090603184648.2E2131D028F@basil.firstfloor.org> <20090609100922.GF14820@wotan.suse.de> <Pine.LNX.4.64.0906091637430.13213@sister.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0906091637430.13213@sister.anvils>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 05:05:53PM +0100, Hugh Dickins wrote:
> On Tue, 9 Jun 2009, Nick Piggin wrote:
> > On Wed, Jun 03, 2009 at 08:46:47PM +0200, Andi Kleen wrote:
> > 
> > Why not have this in rmap.c and not export the locking?
> > I don't know.. does Hugh care?
> 
> Thanks for catching my eye with this, Nick.
> 
> As I've said to Andi, I don't actually have time to study all this.
> To me, it's just another layer of complexity and maintenance burden
> that one special-interest group is imposing upon mm, and I can't
> keep up with it myself.

I know how it feels. But the problem with unreviewed patches is
just that eventually you find yourself needing to review it in
6 months and find the problems then.

There are a few options. Further question the cost/benefit of
a feature; slow down merging until it is satisfactorily reviewed;
or merge it anyway (aka. creative definition of satisfactory).

Not for me to decide, sorry. I'm nearly always further to
conservative with merging features than popular opinion (except
perhaps performance improvements, which are my weakness!)

 
> But looking at this one set of extracts: you're right that I'm much
> happier when page_lock_anon_vma() isn't leaked outside of mm/rmap.c,
> though I'd probably hate this whichever way round it was; and I
> share your lock ordering concern.
> 
> However, if I'm interpreting these extracts correctly, the whole
> thing looks very misguided to me.  Are we really going to kill any
> process that has a cousin who might once have mapped the page that's
> been found hwpoisonous?  The hwpoison secret police are dangerously
> out of control, I'd say.
> 
> The usual use of rmap lookup loops is to go on to look into the page
> table to see whether the page is actually mapped: I see no attempt
> at that here, just an assumption that anyone on the list is guilty
> of mapping the page and must be killed.  And even if it did go on
> to check if the page is there, maybe the process lost interest in
> that page several weeks ago, why kill it?
> 
> At least in the file's prio_tree case, we'll only be killing those
> who mmapped the range which happens to include the page.  But in the
> anon case, remember the anon_vma is just a bundle of "related" vmas
> outside of which the page will not be found; so if one process got a
> poisonous page through COW, all the other processes which happen to
> be sharing that anon_vma through fork or through adjacent merging,
> are going to get killed too.
> 
> Guilty by association.

That's a very good point and I didn't even really notice that
(I didn't come across a writeup of the intended policy/semantics
in case of a bad page, so I've not really been able to tell most
of the time whether code matches intention, but I would say you
are probably right about this case).

 
> I think a much more sensible approach would be to follow the page
> migration technique of replacing the page's ptes by a special swap-like
> entry, then do the killing from do_swap_page() if a process actually
> tries to access the page.
> 
> But perhaps that has already been discussed and found impossible,
> or I'm taking "kill" too seriously and other checks are done
> elsewhere, or...

No, I think this might be a very good suggestion.

