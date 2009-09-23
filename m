Return-Path: <linux-kernel-owner+w=401wt.eu-S1751678AbZIWUXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678AbZIWUXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 16:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbZIWUXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 16:23:48 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:24888 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751105AbZIWUXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 16:23:47 -0400
X-Trace: 265268902/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.47.138/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.47.138
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArsFAEggukpPRS+K/2dsb2JhbACBUdYfhBsF
X-IronPort-AV: E=Sophos;i="4.44,440,1249254000"; 
   d="scan'208";a="265268902"
Date: Wed, 23 Sep 2009 21:23:40 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Nigel Cunningham <ncunningham@crca.org.au>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: No more bits in vm_area_struct's vm_flags.
In-Reply-To: <4AB9A0D6.1090004@crca.org.au>
Message-ID: <Pine.LNX.4.64.0909232056020.3360@sister.anvils>
References: <4AB9A0D6.1090004@crca.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Sep 2009, Nigel Cunningham wrote:
> 
> With the addition of the VM_MERGEABLE flag to vm_flags post-2.6.31, the
> last bit in vm_flags has been used.

Yes, it was rather selfish to take that, without even pointing out
that was the last of 32 bits in the changelog, and without mapping
out where to go next - sorry.

> 
> I have some code in TuxOnIce that needs a bit too (explicitly mark the
> VMA as needing to be atomically copied, for GEM objects), and am not

(I wonder what atomically copied means there.)

> sure what the canonical way to proceed is. Should a new unsigned long be
> added? The difficulty I see with that is that my flag was used in
> shmem_file_setup's flags parameter (drm_gem_object_alloc), so that
> function would need an extra parameter too..

I've assumed that, when necessary, we'll retype vm_flags from
unsigned long to unsigned long long (or u64).  But I've not yet
checked how much bloat that would add to 32-bit code: whether we
should put it off as long as we can, or be lazy and do it soon.

I'm thinking that we should use the full 32-bit vm_flags as a
prompt to dispose of a few.  VM_RESERVED is the one I always claim
I'm going to remove, then more important jobs intervene; and we seem
to have grown more weird variants of VM_PFNMAP than I care for in
the last year or two.  Suspect VM_PFN_AT_MMAP could make reasonable
use of VM_NONLINEAR, but probably not without some small change.

Does TuxOnIce rely on CONFIG_MMU?  If so, then the TuxOnIce patch
could presumably reuse VM_MAPPED_COPY for now - but don't be
surprised if that's one we clean away later on.

Hugh
