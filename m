Return-Path: <linux-kernel-owner+w=401wt.eu-S1758201AbZKJWYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201AbZKJWYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:24:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757537AbZKJWYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:24:14 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:3389 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757513AbZKJWYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:24:14 -0500
X-Trace: 287965742/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.44.180/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.44.180
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjkFAEZ3+UpPRSy0/2dsb2JhbACBTt08hD4E
X-IronPort-AV: E=Sophos;i="4.44,718,1249254000"; 
   d="scan'208";a="287965742"
Date: Tue, 10 Nov 2009 22:24:18 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Peter Zijlstra <peterz@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Izik Eidus <ieidus@redhat.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 5/6] mm: stop ptlock enlarging struct page
In-Reply-To: <1257890959.4108.496.camel@laptop>
Message-ID: <Pine.LNX.4.64.0911102214550.6355@sister.anvils>
References: <Pine.LNX.4.64.0911102142570.2272@sister.anvils> 
 <Pine.LNX.4.64.0911102200480.2816@sister.anvils> <1257890959.4108.496.camel@laptop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Nov 2009, Peter Zijlstra wrote:
> On Tue, 2009-11-10 at 22:02 +0000, Hugh Dickins wrote:
> > 
> > Take the easy way out: switch off SPLIT_PTLOCK_CPUS when DEBUG_SPINLOCK
> > or DEBUG_LOCK_ALLOC is in force.  I've sometimes tried to be cleverer,
> > kmallocing a cacheline for the spinlock when it doesn't fit, but given
> > up each time.  Falling back to mm->page_table_lock (as we do when ptlock
> > is not split) lets lockdep check out the strictest path anyway.
> 
> Why? we know lockdep bloats stuff we never cared.. and hiding a popular
> CONFIG option from lockdep doesn't seem like a good idea to me.

That's a fair opinion, and indeed I Cc'ed you in case it were yours.

I'd like to see how other people feel about it.  Personally I detest
and regret that bloat to struct page, when there's only one particular
use of a page that remotely excuses it.

If it were less tiresome, I'd have gone for the dynamic kmalloc; but
it seemed silly to make that effort when the Kconfig mod is so easy.

But so far as letting lockdep do its job goes, we're actually better
off using page_table_lock there, as I tried to explain: since that
lock is used for a few other purposes, lockdep is more likely to
catch an issue which the SPLIT_PTLOCK case could be hiding.

Hugh
