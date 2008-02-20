Return-Path: <linux-kernel-owner+w=401wt.eu-S1762878AbYBTCqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762878AbYBTCqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 21:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757035AbYBTCqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 21:46:08 -0500
Received: from relay1.sgi.com ([192.48.171.29]:57574 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755594AbYBTCqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 21:46:07 -0500
Date: Tue, 19 Feb 2008 20:46:03 -0600
From: Robin Holt <holt@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Nick Piggin <npiggin@suse.de>, Jack Steiner <steiner@sgi.com>,
       akpm@linux-foundation.org, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch] my mmu notifiers
Message-ID: <20080220024602.GA11364@sgi.com>
References: <20080219084357.GA22249@wotan.suse.de> <20080219135851.GI7128@v2.random> <20080219142725.GA23200@sgi.com> <20080219230427.GB18912@wotan.suse.de> <20080220005206.GP7128@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080220005206.GP7128@v2.random>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 01:52:06AM +0100, Andrea Arcangeli wrote:
> On Wed, Feb 20, 2008 at 12:04:27AM +0100, Nick Piggin wrote:
> > OK (thanks to Robin as well). Now I understand why you are using it,
> > but I don't understand why you don't defer new TLBs after the point
> > where the linux pte changes. If you can do that, then you look and
> > act much more like a TLB from the point of view of the Linux vm.
> 
> Christoph was forced to put the invalidate_range callback _after_
> dropping the PT lock because xpmem has to wait I/O there. But
> invalidate_range is called after freeing the VM reference on the pages
> so then GRU needed a _range_begin too because GRU has to flush the tlb
> before the VM reference on the page is released (xpmem and KVM pin the
> pages mapped by the secondary mmu, GRU doesn't). So then
> invalidate_range was renamed to invalidate_range_end.

Currently, xpmem blocks faults for the range specified at the _begin
callout, then shoots down remote TLBs and does the put_page for all the
pages in the specified range.  The _end callout merely removes the block.
We do not do any wait for I/O.  By the time we return from the _begin
callout, all activity by the remotes is stopped, pages are dereferenced,
and future faults are blocked until released by the _end callout.

Thanks,
Robin
