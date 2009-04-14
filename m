Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbZDNOk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbZDNOk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 10:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbZDNOkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 10:40:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45212 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbZDNOkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 10:40:09 -0400
Date: Tue, 14 Apr 2009 16:38:29 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Jeff Moyer <jmoyer@redhat.com>, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>
Subject: Re: [RFC][PATCH v3 1/6] mm: Don't unmap gup()ed page
Message-ID: <20090414143829.GG28265@random.random>
References: <20090414151204.C647.A69D9226@jp.fujitsu.com> <20090414151554.C64A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414151554.C64A.A69D9226@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 03:16:52PM +0900, KOSAKI Motohiro wrote:
> +	if (PageSwapCache(page) &&
> +	    page_count(page) != page_mapcount(page) + 2) {
> +		ret = SWAP_FAIL;
> +		goto out_unmap;
> +	}
> +

Besides the race pointed out by Nick, this also would break KVM
swapping with mmu notifier. mmu_notifier_invalidate_page must be
invoked before reading page_count for this to work. However the
invalidate has to be moved below the
mlock/ptep_clear_flush_young_notify, no point to get rid of sptes if
any of the spte or the pte is still young.
