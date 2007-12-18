Return-Path: <linux-kernel-owner+w=401wt.eu-S1753013AbXLRIbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbXLRIbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 03:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbXLRIbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 03:31:47 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:58079 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbXLRIbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 03:31:46 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Roland Dreier <rdreier@cisco.com>, venkatesh.pallipadi@intel.com,
       ak@muc.de, torvalds@linux-foundation.org, gregkh@suse.de,
       airlied@skynet.ie, davej@redhat.com, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, arjan@infradead.org,
       jesse.barnes@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 06/12] PAT 64b: Add ioremap_wc support
References: <20071213235543.568682000@intel.com>
	<20071213235712.339088000@intel.com> <ada8x3x7vw5.fsf@cisco.com>
	<m1sl25q4rc.fsf@ebiederm.dsl.xmission.com> <ada4pel7v6a.fsf@cisco.com>
	<m1odctq3tn.fsf@ebiederm.dsl.xmission.com>
	<20071214214026.GC717@linux-os.sc.intel.com>
Date: Tue, 18 Dec 2007 01:29:45 -0700
In-Reply-To: <20071214214026.GC717@linux-os.sc.intel.com> (Suresh B. Siddha's
	message of "Fri, 14 Dec 2007 13:40:27 -0800")
Message-ID: <m1fxy0be2u.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Siddha, Suresh B" <suresh.b.siddha@intel.com> writes:

> Yes. We are looking for comments for our proposal to track the
> reserved/non-reserved regions some what different.
> This is the critical issue which had been holding off PAT for years now...

The mattr infrastructure appears to do a decent job of handling the
reserved page mapping case.  It essentially reinvents struct
vm_area_struct, and so I expect we can do things a little more easily
if we use the existing vm_area_struct with it's vm_page_prot member
for our checks, all rooted at a dummy reserved page inode.  That way
we don't need to do anything special on unmap.

For normal pages we always have them in the kernel mapping and
we use them there.  change_page_attr also comes in from the AGP
drivers and changes the caching attributes on a few of those.  So when
mapping a normal page we need to require it to be write-back or
whatever change_page_attr has set it to.  I expect 2 bits 
of page->flags with the proper default can handle that.

change_page_attr needs to check non kernel mappings of a page 
and either fix them or fail.

If we perform the checks I have described for normal pages
in /dev/mem (in remap_pfn_pages?) that should be our
most difficult case handled.

Eric

> <snip from the other mails>
>
> Change x86_64 identity map to only map non-reserved memory. This helps
> to handle UC/WC mapping of reserved region in a much simple manner
> (we don't have to do cpa any more, as such not keep track of the actual
> reference counts. We still track all the usages to keep the mappings
> consistent. We just avoid the headache of splitting mattr regions for
> managing ref counts for every individual usage of the reserved
> area).

Well we do want to early map the ``isa'' region.
>
> For now, we don't track RAM pages using memattr infrastructure. This is because,
> memattr infrastructure is not enough. i.e., while the page is getting
> tracked using memattr infrastructure, potentially the page can get
> freed(a bug that we need to catch, to avoid attribute aliasing).
> For example, a driver does ioremap_uc and an application mapped the
> same page using /dev/mem. When the driver does iounamp and free the page,
> /dev/mem mapping is still live and we run into aliasing issue.

/dev/mem is particular weird because it doesn't own the page, and thus
will always be the second user if we are talking about pages in ram.

> Can we use the existing page struct to keep track of the attribute
> and usage?

Yes but not the way you describe below.

> /dev/mem mappings then can increment the page ref count and not
> allow to free the page while the /dev/mem mappings are active. And allow
> /dev/mem to map only those pages which are marked reserved (which the driver
> does before doing iomap).

Part of the usefulness of /dev/mem is that it can do silly things like
map pages someone else in the kernel is using.  /dev/mem by it's very
nature does not own ram pages so we need to handle that differently.

> Or when a WB mapping through /dev/mem is active, don't allow any driver
> to map the page as UC.. Can we do this tracking for RAM pages through
> struct page. Or there any issues we should keep in mind..

I think some bits in page->flags should do the trick.  The semantics
of change_page_attr are interesting in this case.

Eric
