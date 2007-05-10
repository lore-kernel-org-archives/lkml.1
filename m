Return-Path: <linux-kernel-owner+w=401wt.eu-S1760949AbXEJXem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760949AbXEJXem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 19:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755555AbXEJXef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 19:34:35 -0400
Received: from holomorphy.com ([66.93.40.71]:39063 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376AbXEJXef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 19:34:35 -0400
Date: Thu, 10 May 2007 16:35:10 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Christoph Lameter <clameter@sgi.com>, Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: slub-i386-support.patch
Message-ID: <20070510233510.GQ19966@holomorphy.com>
References: <Pine.LNX.4.64.0705102028550.25681@blonde.wat.veritas.com> <20070510203102.GO19966@holomorphy.com> <Pine.LNX.4.64.0705101333420.11826@schroedinger.engr.sgi.com> <20070510210935.GP19966@holomorphy.com> <46438E65.8000001@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46438E65.8000001@goop.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
>> Xen is not mandatory as it now stands.

On Thu, May 10, 2007 at 02:28:05PM -0700, Jeremy Fitzhardinge wrote:
> ?  I'm hoping to merge the Xen code in the next couple of days, so I'd
> appreciate it if we don't break the foundations just before building the
> building.

CONFIG_X86_PAE without CONFIG_PARAVIRT is the case in question here.
What's done in that case can't break Xen because it doesn't run under
Xen.


William Lee Irwin III wrote:
>>  Also, I intend to fix up Xen
>> at some point so it doesn't need this.

On Thu, May 10, 2007 at 02:28:05PM -0700, Jeremy Fitzhardinge wrote:
> As I mentioned in the previous mail, its only really necessary for a
> 32-bit guest under a 32-bit hypervisor.  While that's going to be a
> supported configuration for a long time, we expect that people will
> increasingly use 64-bit hypervisors on new machines, so this will become
> less of an issue.
> We're also looking at shadowing the 4 top-level PAE entries rather than
> using them directly, since the shadows only need to be updated when
> reloading cr3.  This would allow us to use compact pgds, so long as
> there's some other way to maintain the pgd list (ideally, something that
> can be shared with non-PAE).

ISTR you describing this method earlier. This is what I had in mind
for fixing up Xen not to need full PAGE_SIZE-sized pgd's.


On Thu, May 10, 2007 at 02:28:05PM -0700, Jeremy Fitzhardinge wrote:
> Or did I miss something?  Is pgd_list being maintained some other way
> with slub/quicklists?

No, it's identical. clameter's code makes PAGE_SIZE-sized pgd's
unconditional for CONFIG_X86_PAE, which is what bothered me.


William Lee Irwin III wrote:
>> The alternative was 64-bit generation numbers incremented at the time
>> of change_page_attr(). If generation numbers were used, it would be
>> possible to dispose of the list altogether. Given the awkwardness of
>> the list maintenance for Xen, it may be worth using them now. PAE
>> pgd's could merely double in size to maintain those for the unshared
>> kernel pmd case, and remain 32B otherwise. Full PAGE_SIZE -sized pgd's
>> for 2-level pagetables could distribute the generation number across
>> page->index and page->private, or any other fields available.

On Thu, May 10, 2007 at 02:28:05PM -0700, Jeremy Fitzhardinge wrote:
> If you use page->index for that, how does pgd_list get linked together
> for vmalloc syncing?

It doesn't need to be linked together for vmalloc_sync(). Just increment
the generation number and walk the mmlist the same as for pageattr.c


-- wli
