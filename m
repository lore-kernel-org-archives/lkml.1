Return-Path: <linux-kernel-owner+w=401wt.eu-S1753728AbXGIHkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbXGIHkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 03:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbXGIHkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 03:40:07 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:21129 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751205AbXGIHkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 03:40:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=lTS80LeZj50rq8wnjN3AvIUNmeUrTGdbqzH3fwyEjjzjpM4s6ZOO6aTqkxSXU5XCNBW/d8NoP+SVCITZTSZKVsH0jf5bz//BjT0yufdfwx9xluCRkXrXzeAznMCz4J54lDepoCTdJB0L0IUCEUbxq2VwdBuSXx4tOjoQ6GcuTUI=  ;
X-YMail-OSG: dKg7CtQVM1kbA4UuZVJL_FhFnxAc1DD5C2cN76_sjZU62h31XPzfHVeKEaRJ2wE.kXejiJMweA--
Message-ID: <4691E64F.5070506@yahoo.com.au>
Date: Mon, 09 Jul 2007 17:39:59 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linux-mm@kvack.org, Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH] Use mmu_gather for fork() instead of flush_tlb_mm()
References: <1183952874.3388.349.camel@localhost.localdomain>	 <1183962981.5961.3.camel@localhost.localdomain> <1183963544.5961.6.camel@localhost.localdomain>
In-Reply-To: <1183963544.5961.6.camel@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> Use mmu_gather for fork() instead of flush_tlb_mm()
> 
> This patch uses an mmu_gather for copying page tables instead of
> flush_tlb_mm(). This allows archs like ppc32 with hash table to
> avoid walking the page tables a second time to invalidate hash
> entries, and to only flush PTEs that have actually been changed
> from RW to RO.
> 
> Note that this contain a small change to the mmu gather stuff,
> it must not call free_pages_and_swap_cache() if no page have been
> queued up for freeing (if we are only invalidating PTEs). Calling
> it on fork can deadlock (I haven't dug why but it looks like a
> good idea to test anyway if we're going to use the mmu_gather for
> more than just removing pages).
> 
> If the patch gets accepted, I will split that bit from the rest
> of the patch and send it separately.
> 
> The main possible issue I see is with huge pages. Arch code might
> have relied on flush_tlb_mm() and might not cope with
> tlb_remove_tlb_entry() called for huge PTEs.
> 
> Other possible issues are if archs make assumptions about
> flush_tlb_mm() being called in fork for different unrelated reasons.
> 
> Ah also, we could probably improve the tracking of start/end, in
> the case of lock breaking, the outside function will still finish
> the batch with the entire range. It doesn't matter on ppc and x86
> I think though.

Would it be better off to start off with a new API for this? The
mmu gather I think is traditionally entirely for dealing with
page removal...

-- 
SUSE Labs, Novell Inc.
