Return-Path: <linux-kernel-owner+w=401wt.eu-S1762047AbYDVUb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762047AbYDVUb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 16:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287AbYDVUbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 16:31:16 -0400
Received: from relay2.sgi.com ([192.48.171.30]:48216 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751122AbYDVUbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 16:31:15 -0400
Date: Tue, 22 Apr 2008 15:31:14 -0500
From: Robin Holt <holt@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrea Arcangeli <andrea@qumranet.com>, Nick Piggin <npiggin@suse.de>,
       Jack Steiner <steiner@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Hugh Dickins <hugh@veritas.com>, akpm@linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 01 of 12] Core of mmu notifiers
Message-ID: <20080422203114.GQ30298@sgi.com>
References: <ea87c15371b1bd49380c.1208872277@duo.random> <Pine.LNX.4.64.0804221315160.3640@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804221315160.3640@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 01:19:29PM -0700, Christoph Lameter wrote:
> Thanks for adding most of my enhancements. But
> 
> 1. There is no real need for invalidate_page(). Can be done with 
> 	invalidate_start/end. Needlessly complicates the API. One
> 	of the objections by Andrew was that there mere multiple
> 	callbacks that perform similar functions.

While I agree with that reading of Andrew's email about invalidate_page,
I think the GRU hardware makes a strong enough case to justify the two
seperate callouts.

Due to the GRU hardware, we can assure that invalidate_page terminates all
pending GRU faults (that includes faults that are just beginning) and can
therefore be completed without needing any locking.  The invalidate_page()
callout gets turned into a GRU flush instruction and we return.

Because the invalidate_range_start() leaves the page table information
available, we can not use a single page _start to mimick that
functionality.  Therefore, there is a documented case justifying the
seperate callouts.

I agree the case is fairly weak, but it does exist.  Given Andrea's
unwillingness to move and Jack's documented case, it is my opinion the
most likely compromise is to leave in the invalidate_page() callout.

Thanks,
Robin
