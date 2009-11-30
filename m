Return-Path: <linux-kernel-owner+w=401wt.eu-S1752503AbZK3LyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbZK3LyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 06:54:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbZK3LyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 06:54:21 -0500
Received: from cantor.suse.de ([195.135.220.2]:41120 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbZK3LyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 06:54:21 -0500
Date: Mon, 30 Nov 2009 12:54:25 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Mark Veltzer <mark.veltzer@gmail.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: get_user_pages question
Message-ID: <20091130115425.GA21639@wotan.suse.de>
References: <200911090850.26724.mark.veltzer@gmail.com> <87skco59jl.fsf@basil.nowhere.org> <Pine.LNX.4.64.0911091031460.15199@sister.anvils> <200911100013.31768.mark.veltzer@gmail.com> <Pine.LNX.4.64.0911101613080.22198@sister.anvils> <20091128185052.GB30235@random.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091128185052.GB30235@random.random>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 28, 2009 at 07:50:52PM +0100, Andrea Arcangeli wrote:
> All other patches floating around spread an mm-wide semaphore over
> fork fast path, and across O_DIRECT, nfs, and aio, and they most
> certainly didn't fix the two races for all gup users, and they weren't
> stable because of having to identify the closure of the I/O across all
> possible put_page. That approach kind of opens a can of worms and it
> looks the wrong way to go to me, and I think they scale worse too for
> the fast path (no O_DIRECT or no fork). Identifying the gup closure
> points and replacing the raw put_page with gup_put_page would not be
> an useless effort though and I felt if the gup API was just a little
> bit more sophisticated I could simplify a bit the put_compound_page to
> serialize the race against split_huge_page_refcount, but this is an
> orthogonal issue with the mm-wide semaphore release addition which I
> personally dislike.

IIRC, the last time this came up, it kind of became stalled on this
point. Linus hated our "preemptive cow" approaches, and thought the
above approach was better.

I don't think we need to bother arguing details between our former
approaches until we get past this sticking point.

FWIW, I need to change get_user_pages semantics somewhat because we
have filesystems that cannot tolerate a set_page_dirty() to dirty a
clean page (it must only be dirtied with page_mkwrite).

This should probably require converting callers to use put_user_pages
and disallowing lock_page, mmap_sem, user-copy etc. within these
sections.

