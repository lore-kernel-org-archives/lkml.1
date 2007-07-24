Return-Path: <linux-kernel-owner+w=401wt.eu-S1757834AbYLLBaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834AbYLLBaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 20:30:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754765AbYLLBaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 20:30:05 -0500
Received: from smtp112.mail.mud.yahoo.com ([209.191.84.65]:44614 "HELO
	smtp112.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751838AbYLLBaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 20:30:04 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=2fRmW4fVwt5BJZHqGf9F8/mq/v/ozAfByJTEOQ8L/fkKdZUr1SuSXeujM5r6yT1n4H1s7//NykMXk5bpRAlwUmvuq1dAm9jdT5k7Me2e3QgeAef4x+l4E+WMHjyuBbF5hGIPAVNdSNoV50dYfTM1UcArTDjlzd6fxb6fAhJNN1E=  ;
X-YMail-OSG: qbdxVwIVM1lpp5ToM1El6V.qCh6BqL0WnOar8zhFG1IIKeUC_Zl0KzAQ_8tt1T8BG6ytrao_3hOCHoxQJl4n4SJmSVN4NS.t_ehHU1nNPil4wnJv_wqnDIPfYOqF_5hhJq_sRQPjJx1XoyE7Gl7ksL1uPdZ0TL_P2UmBiscK
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH RFC] vm_unmap_aliases: allow callers to inhibit TLB flush
Date: Tue, 24 Jul 2007 10:52:13 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
References: <49416494.6040009@goop.org>
In-Reply-To: <49416494.6040009@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707241052.13825.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 12 December 2008 06:05, Jeremy Fitzhardinge wrote:
> Hi Nick,
>
> In Xen when we're killing the lazy vmalloc aliases, we're only concerned
> about the pagetable references to the mapped pages, not the TLB entries.

Hm? Why is that? Why wouldn't it matter if some page table page gets
written to via a stale TLB?


> For the most part eliminating the TLB flushes would be a performance
> optimisation, but there's at least one case where we need to shoot down
> aliases in an interrupt-disabled section, so the TLB shootdown IPIs
> would potentially deadlock.

So... 2.6.28 is deadlocky for you?


> I'm wondering what your thoughts are about this approach?

Doesn't work, because that's allowing virtual addresses to be reused
before they have TLBs flushed.

You could have a xen specific function which goes through the lazy maps
and unmaps their page tables, but leaves them in the virtual address
allocator (so a subsequent lazy flush will still do the TLB flush before
allowing the addresses to be reused).


> I'm not super-happy with the changes to __purge_vmap_area_lazy(), but
> given that we need a tri-state policy selection there, adding an enum is
> clearer than adding another boolean argument.
>
> It also raises the question of how many callers of vm_unmap_aliases()
> really care about flushing the tlbs. Presumably if we're shooting down
> some stray vmalloc mappings then nobody is actually using them at the
> time, and any corresponding TLB entries are residual. Or does leaving
> them around leave open the possibility of unwanted speculative
> references which could violate memory type rules?  Perhaps callers who
> care about that could arrange their own tlb flush?

The whole lazy flush requires the TLB flush because the core vmalloc
code needs to flush before reallocating. So it can't really go into
the caller.

PAT needs the TLBs flushed, definitely.

I'm surprised that Xen doesn't... but let's hear it :)
