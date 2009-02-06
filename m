Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbZBFBi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbZBFBi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 20:38:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbZBFBiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 20:38:19 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56224 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbZBFBiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 20:38:18 -0500
Date: Fri, 6 Feb 2009 02:38:05 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Robin Holt <holt@sgi.com>, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [Patch] mmu_notifiers destroyed by __mmu_notifier_release()
	retain extra mm_count.
Message-ID: <20090206013805.GL14011@random.random>
References: <20090205172303.GB8559@sgi.com> <alpine.DEB.1.10.0902051427280.13692@qirst.com> <20090205200214.GN8577@sgi.com> <alpine.DEB.1.10.0902051844390.17441@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902051844390.17441@qirst.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 06:54:33PM -0500, Christoph Lameter wrote:
> One also needs to wonder why we acquire the refcount for the mmu
> notifier on the mmstruct at all. Maybe remove the
> 
> 	atomic_inc()
> 
> from mmu_notifier_register() instead? Looks strange there especially since
> we have a BUG_ON there as well that verifies that the number of refcount
> is already above 0.
> 
> How about this patch instead?

Surely you have to remove mmdrop from mmu_notifier_unregister if you
do that. But with the other patch that mmdrop should also be mvoed up
now that I think about it. So both patches looks wrong.


Ok I think the issue here is that with the current code the unregister
call is mandatory to avoid memleak, if you do like KVM does everything
is fine, even if ->release fires through exit_mmap, later unregister
is called when the fd is closed so all works fine then.

The reason of the mm_count pin is to avoid the driver having to
increase mm_count itself _before_ mmu_notifier_register, basically the
mm has to exist as long as any mmu notifier is attached to an mm, if
mm goes away, clearly the notifier list gets corrupted.

It all boils down if unregister is mandatory or not. If it's mandatory
current code is ok, if it's not, then you've to decide if to remove
both mmdrop and atomic_inc and have the caller handle it (which is
likely ok with kvm) or to add mmdrop to the auto-disarming code, and
then move the mmdrop up in the !hlist_unhashed path of unregister
(which was missing from Robin's patch and could trigger a double
mmdrop if one always calls unregister unconditionally which is meant
to be allowed with current code and that's the kvm usage model too).
