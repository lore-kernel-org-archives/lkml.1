Return-Path: <linux-kernel-owner+w=401wt.eu-S1757993AbYBPLvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993AbYBPLvz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 06:51:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754620AbYBPLvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 06:51:44 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58154 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753849AbYBPLvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 06:51:43 -0500
Date: Sat, 16 Feb 2008 05:51:38 -0600
From: Robin Holt <holt@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [PATCH] KVM swapping with MMU Notifiers V7
Message-ID: <20080216115138.GA11391@sgi.com>
References: <20080215064859.384203497@sgi.com> <20080216104827.GI11732@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080216104827.GI11732@v2.random>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2008 at 11:48:27AM +0100, Andrea Arcangeli wrote:
> Those below two patches enable KVM to swap the guest physical memory
> through Christoph's V7.
> 
> There's one last _purely_theoretical_ race condition I figured out and
> that I'm wondering how to best fix. The race condition worst case is
> that a few guest physical pages could remain pinned by sptes. The race
> can materialize if the linux pte is zapped after get_user_pages
> returns but before the page is mapped by the spte and tracked by
> rmap. The invalidate_ calls can also likely be optimized further but
> it's not a fast path so it's not urgent.

I am doing this in xpmem with a stack-based structure in the function
calling get_user_pages.  That structure describes the start and
end address of the range we are doing the get_user_pages on.  If an
invalidate_range_begin comes in while we are off to the kernel doing
the get_user_pages, the invalidate_range_begin marks that structure
indicating an invalidate came in.  When the get_user_pages gets the
structures relocked, it checks that flag (really a generation counter)
and if it is set, retries the get_user_pages.  After 3 retries, it
returns -EAGAIN and the fault is started over from the remote side.

Thanks,
Robin
