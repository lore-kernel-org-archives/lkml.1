Return-Path: <linux-kernel-owner+w=401wt.eu-S1762616AbYBSJKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762616AbYBSJKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 04:10:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754318AbYBSJJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 04:09:58 -0500
Received: from n28.bullet.mail.mud.yahoo.com ([68.142.200.143]:38301 "HELO
	n28.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761039AbYBSJJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 04:09:50 -0500
X-Yahoo-Newman-Id: 373767.69101.bm@omp413.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=R7XG9GGtec8J/Llh9JxppauEO6z70YtSD3Qrn0BbxGD/G1+X1nS2ynuoIEFXai4hCIzVmxjDdhpvgtXibibtQibN8Y6A7UdgxTn5qEJlp5FDJdJhOUiirosmsD+Vls5qep3KNj+voDRwf4QvdLllOF1gM5PkpFznIukVIWmwuK0=  ;
X-YMail-OSG: u6JrOsUVM1laf3N.pjC8OO3mC0W61etMhAWl6nAzhw_KOurP
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 2/6] mmu_notifier: Callbacks to invalidate address ranges
Date: Tue, 19 Feb 2008 19:54:14 +1100
User-Agent: KMail/1.9.5
Cc: akpm@linux-foundation.org, Andrea Arcangeli <andrea@qumranet.com>,
       Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
References: <20080215064859.384203497@sgi.com> <20080215064932.620773824@sgi.com>
In-Reply-To: <20080215064932.620773824@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200802191954.14874.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 February 2008 17:49, Christoph Lameter wrote:
> The invalidation of address ranges in a mm_struct needs to be
> performed when pages are removed or permissions etc change.
>
> If invalidate_range_begin() is called with locks held then we
> pass a flag into invalidate_range() to indicate that no sleeping is
> possible. Locks are only held for truncate and huge pages.
>
> In two cases we use invalidate_range_begin/end to invalidate
> single pages because the pair allows holding off new references
> (idea by Robin Holt).
>
> do_wp_page(): We hold off new references while we update the pte.
>
> xip_unmap: We are not taking the PageLock so we cannot
> use the invalidate_page mmu_rmap_notifier. invalidate_range_begin/end
> stands in.

This whole thing would be much better if you didn't rely on the page
lock at all, but either a) used the same locking as Linux does for its
ptes/tlbs, or b) have some locking that is private to the mmu notifier
code. Then there is not all this new stuff that has to be understood in
the core VM.

Also, why do you have to "invalidate" ranges when switching to a
_more_ permissive state? This stuff should basically be the same as
(a subset of) the TLB flushing API AFAIKS. Anything more is a pretty
big burden to put in the core VM.

See my alternative patch I posted -- I can't see why it won't work
just like a TLB.

As far as sleeping inside callbacks goes... I think there are big
problems with the patch (the sleeping patch and the external rmap
patch). I don't think it is workable in its current state. Either
we have to make some big changes to the core VM, or we have to turn
some locks into sleeping locks to do it properly AFAIKS. Neither
one is good.

But anyway, I don't really think the two approaches (Andrea's
notifiers vs sleeping/xrmap) should be tangled up too much. I
think Andrea's can possibly be quite unintrusive and useful very
soon.

