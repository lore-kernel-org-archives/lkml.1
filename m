Return-Path: <linux-kernel-owner+w=401wt.eu-S1752959AbZIYIaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbZIYIaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 04:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbZIYIaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 04:30:23 -0400
Received: from mail.crca.org.au ([67.207.131.56]:60381 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257AbZIYIaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 04:30:21 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4ABC7FBC.4050409@crca.org.au>
Date: Fri, 25 Sep 2009 18:30:52 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: No more bits in vm_area_struct's vm_flags.
References: <4AB9A0D6.1090004@crca.org.au> <Pine.LNX.4.64.0909232056020.3360@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0909232056020.3360@sister.anvils>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Hugh Dickins wrote:
> On Wed, 23 Sep 2009, Nigel Cunningham wrote:
>> With the addition of the VM_MERGEABLE flag to vm_flags post-2.6.31, the
>> last bit in vm_flags has been used.
> 
> Yes, it was rather selfish to take that, without even pointing out
> that was the last of 32 bits in the changelog, and without mapping
> out where to go next - sorry.

Not at all! I'm only asking because I wasn't sure where to go next.

>> I have some code in TuxOnIce that needs a bit too (explicitly mark the
>> VMA as needing to be atomically copied, for GEM objects), and am not
> 
> (I wonder what atomically copied means there.)

Copied together, with interrupts disabled (to get as consistent an image
as possible). Swsusp and uswsusp atomically copy everything, and so
don't need this flag. TuxOnIce relies on the freezer to stop userspace
pages changing, and saves them separately in order to get a full image
of memory. The flag is needed because these pages would otherwise not be
included in the set of pages that are atomic copied.

>> sure what the canonical way to proceed is. Should a new unsigned long be
>> added? The difficulty I see with that is that my flag was used in
>> shmem_file_setup's flags parameter (drm_gem_object_alloc), so that
>> function would need an extra parameter too..
> 
> I've assumed that, when necessary, we'll retype vm_flags from
> unsigned long to unsigned long long (or u64).  But I've not yet
> checked how much bloat that would add to 32-bit code: whether we
> should put it off as long as we can, or be lazy and do it soon.
> 
> I'm thinking that we should use the full 32-bit vm_flags as a
> prompt to dispose of a few.  VM_RESERVED is the one I always claim
> I'm going to remove, then more important jobs intervene; and we seem
> to have grown more weird variants of VM_PFNMAP than I care for in
> the last year or two.  Suspect VM_PFN_AT_MMAP could make reasonable
> use of VM_NONLINEAR, but probably not without some small change.
> 
> Does TuxOnIce rely on CONFIG_MMU?  If so, then the TuxOnIce patch
> could presumably reuse VM_MAPPED_COPY for now - but don't be
> surprised if that's one we clean away later on.

Hmm. I'm not sure. The requirements are the same as for swsusp and
uswsusp. Is there some tool to graph config dependencies?

Regards,

Nigel

