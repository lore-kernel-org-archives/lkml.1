Return-Path: <linux-kernel-owner+w=401wt.eu-S1760372AbXEJVWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760372AbXEJVWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 17:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762099AbXEJVWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 17:22:16 -0400
Received: from gw.goop.org ([64.81.55.164]:49381 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932700AbXEJVWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 17:22:14 -0400
Message-ID: <46438D03.8030100@goop.org>
Date: Thu, 10 May 2007 14:22:11 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: William Lee Irwin III <wli@holomorphy.com>,
       Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: slub-i386-support.patch
References: <Pine.LNX.4.64.0705102028550.25681@blonde.wat.veritas.com> <20070510203102.GO19966@holomorphy.com> <Pine.LNX.4.64.0705101333420.11826@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0705101333420.11826@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
>> This is wrong; pgd's are smaller than PAGE_SIZE on PAE. Burning lowmem
>> like this is very, very bad for such systems. pmd_cache is rather
>> trivial to convert to quicklists, since all it does is zero pages. I
>> still don't approve of even the !SHARED_KERNEL_PMD case using PAGE_SIZE
>> -sized pgd's. Xen should really be fixed to avoid requiring guests to
>> have recursive pagetables or whatever it's doing.
>>     
>
> But the Xen guys need the full sized pgd?
>   

Yes, Xen needs a page-sized PGD.  There are two reasons:

   1. Xen inherently needs a whole page for the pgd, because it
      classifies pages by type, and the pgd is a pagetable-typed page.
   2. When the kernel mappings are not being shared between processes,
      as in non-PAE or PAE with !SHARED_KERNEL_PMD, it maintains a
      pgd_list linked though the index field in the page structure's
      index field.  For this to work, you can't have more than one pgd
      per page.  The pgd_list is needed to sync the vmalloc mappings
      across all the pagetables.

Xen needs to set !SHARED_KERNEL_PMD for PAE when running a 32-bit kernel
under a 32-bit hypervisor; when running under a 64-bit hypervisor,
there's no need to steal any guest address space for the hypervisor.  (I
haven't implemented this on the Linux side yet.)

    J
