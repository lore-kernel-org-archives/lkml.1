Return-Path: <linux-kernel-owner+w=401wt.eu-S1762033AbYCGSqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762033AbYCGSqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 13:46:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757423AbYCGSpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 13:45:55 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:41889
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756857AbYCGSpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 13:45:54 -0500
Date: Fri, 7 Mar 2008 19:45:52 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Nick Piggin <npiggin@suse.de>, akpm@linux-foundation.org,
       Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       kvm-devel@lists.sourceforge.net, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [PATCH] 3/4 combine RCU with seqlock to allow mmu notifier
	methods to sleep (#v9 was 1/4)
Message-ID: <20080307184552.GL24114@v2.random>
References: <Pine.LNX.4.64.0803032327470.9642@schroedinger.engr.sgi.com> <20080304133020.GC5301@v2.random> <Pine.LNX.4.64.0803041059110.13957@schroedinger.engr.sgi.com> <20080304222030.GB8951@v2.random> <Pine.LNX.4.64.0803041422070.20821@schroedinger.engr.sgi.com> <20080307151722.GD24114@v2.random> <20080307152328.GE24114@v2.random> <1204908762.8514.114.camel@twins> <20080307175019.GK24114@v2.random> <1204912895.8514.120.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204912895.8514.120.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2008 at 07:01:35PM +0100, Peter Zijlstra wrote:
> The reason Christoph can do without RCU is because he doesn't allow
> unregister, and as soon as you drop that you'll end up with something

Not sure to follow, what do you mean "he doesn't allow"? We'll also
have to rip unregister regardless after you pointed out the ->release
won't be called after calling my mmu_notifier_unregister in 3/4. If
you figured out how to retain mmu_notifier_unregister I'm not seeing
it anymore.

> Curious problem indeed. Would it make sense to require registering these
> MMU notifiers when the process is still single threaded along with the
> requirement that they can never be removed again from a running process?

I'm afraid that won't help much (even if the mmu notifiers users could
cope with that restriction like KVM can) because the VM will run
concurrently in another CPU despite the task is single threaded. See
2/4 in try_to_unmap_cluster: _start/end are not only invoked in the
context of the current task.

PS. this problem I pointed out of _end possibly called before _begin
is the same for #v9 and EMM V1 as far as I can tell.
