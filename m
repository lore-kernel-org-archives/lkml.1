Return-Path: <linux-kernel-owner+w=401wt.eu-S1762130AbXEJV2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762130AbXEJV2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 17:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758631AbXEJV2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 17:28:12 -0400
Received: from gw.goop.org ([64.81.55.164]:38058 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758618AbXEJV2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 17:28:08 -0400
Message-ID: <46438E65.8000001@goop.org>
Date: Thu, 10 May 2007 14:28:05 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: Christoph Lameter <clameter@sgi.com>, Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: slub-i386-support.patch
References: <Pine.LNX.4.64.0705102028550.25681@blonde.wat.veritas.com> <20070510203102.GO19966@holomorphy.com> <Pine.LNX.4.64.0705101333420.11826@schroedinger.engr.sgi.com> <20070510210935.GP19966@holomorphy.com>
In-Reply-To: <20070510210935.GP19966@holomorphy.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> On Thu, 10 May 2007, William Lee Irwin III wrote:
>   
>>> This is wrong; pgd's are smaller than PAGE_SIZE on PAE. Burning lowmem
>>> like this is very, very bad for such systems. pmd_cache is rather
>>> trivial to convert to quicklists, since all it does is zero pages. I
>>> still don't approve of even the !SHARED_KERNEL_PMD case using PAGE_SIZE
>>> -sized pgd's. Xen should really be fixed to avoid requiring guests to
>>> have recursive pagetables or whatever it's doing.
>>>       
>
> On Thu, May 10, 2007 at 01:35:25PM -0700, Christoph Lameter wrote:
>   
>> But the Xen guys need the full sized pgd?
>>     
>
> Xen is not mandatory as it now stands.
?  I'm hoping to merge the Xen code in the next couple of days, so I'd
appreciate it if we don't break the foundations just before building the
building.

>  Also, I intend to fix up Xen
> at some point so it doesn't need this.
>   

As I mentioned in the previous mail, its only really necessary for a
32-bit guest under a 32-bit hypervisor.  While that's going to be a
supported configuration for a long time, we expect that people will
increasingly use 64-bit hypervisors on new machines, so this will become
less of an issue.

We're also looking at shadowing the 4 top-level PAE entries rather than
using them directly, since the shadows only need to be updated when
reloading cr3.  This would allow us to use compact pgds, so long as
there's some other way to maintain the pgd list (ideally, something that
can be shared with non-PAE).

Or did I miss something?  Is pgd_list being maintained some other way
with slub/quicklists?

> The alternative was 64-bit generation numbers incremented at the time
> of change_page_attr(). If generation numbers were used, it would be
> possible to dispose of the list altogether. Given the awkwardness of
> the list maintenance for Xen, it may be worth using them now. PAE
> pgd's could merely double in size to maintain those for the unshared
> kernel pmd case, and remain 32B otherwise. Full PAGE_SIZE -sized pgd's
> for 2-level pagetables could distribute the generation number across
> page->index and page->private, or any other fields available.
>   

If you use page->index for that, how does pgd_list get linked together
for vmalloc syncing?

    J
