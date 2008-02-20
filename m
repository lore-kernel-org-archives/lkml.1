Return-Path: <linux-kernel-owner+w=401wt.eu-S933191AbYBTVDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933191AbYBTVDx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 16:03:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753665AbYBTVDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 16:03:43 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53628 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752743AbYBTVDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 16:03:41 -0500
Date: Wed, 20 Feb 2008 15:03:39 -0600
From: Jack Steiner <steiner@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Nick Piggin <npiggin@suse.de>, akpm@linux-foundation.org,
       Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] mmu notifiers #v6
Message-ID: <20080220210339.GA25659@sgi.com>
References: <20080219084357.GA22249@wotan.suse.de> <20080219135851.GI7128@v2.random> <20080219231157.GC18912@wotan.suse.de> <20080220010941.GR7128@v2.random> <20080220103942.GU7128@v2.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080220103942.GU7128@v2.random>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 11:39:42AM +0100, Andrea Arcangeli wrote:
> Given Nick's comments I ported my version of the mmu notifiers to
> latest mainline. There are no known bugs AFIK and it's obviously safe
> (nothing is allowed to schedule inside rcu_read_lock taken by
> mmu_notifier() with my patch).
> ....

I ported the GRU driver to use the latest #v6 patch and ran a series of
tests on it using our system simulator. The simulator is slow so true
stress or swapping is not possible - at least within a finite amount of
time.

Functionally, the #v6 patch seems to work for the GRU. However, I did
notice two significant differences that make the #v6 performance worse for
the GRU than Christoph's patch.  I think one difference is easily fixable
but the other is more difficult:

	- the location of the mmu_notifier_release() callout is at a
	  different place in the 2 patches. Christoph has the callout
	  BEFORE the call to unmap_vmas() whereas you have it AFTER. The
	  net result is that the GRU does a LOT of 1-page TLB flushes
	  during process teardown.  These flushes are not done with
	  Christops's patch.

	- the range callouts in Christoph's patch benefit the GRU because
	  multiple TLB entries can be flushed with a single GRU
	  instruction (the GRU hardware supports a range flush using a
	  vaddr & length).  The #v6 patch does a TLB flush for each page in
	  the range.  Flushing on the GRU is slow so being able to flush
	  multiple pages with a single request is a benefit.

Seems like the latter difference could be significant for other users
of mmu notifiers.


--- jack
