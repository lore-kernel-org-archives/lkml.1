Return-Path: <linux-kernel-owner+w=401wt.eu-S1759302AbYAXXlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759302AbYAXXlj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 18:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbYAXXl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 18:41:29 -0500
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:46186 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758877AbYAXXl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 18:41:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=fAL11qQbra3BL/UQ73ZKc66QkCRkhWWjO+UhR3l1DoT23NHlPTq+f0TOMQ2LYX/ekjnpDMEhvJV0NaXdKZ/t049yfaThxNFU8kB4oyssqy+UKKMvyw6ECPg9xS9YA/WwDk4X/Zull0B2rY8xwicMXT2HE9qHfw4Gj7RBGAqUrCk=  ;
X-YMail-OSG: _9xmbsQVM1nJ3xg4DsTtya5x3fAsDhFFxKIFdYpge4Edp4SZh626fUHhmhQ5Mky786JsvYVVXQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH UPDATE] x86: ignore spurious faults
Date: Fri, 25 Jan 2008 10:41:16 +1100
User-Agent: KMail/1.9.5
Cc: Matt Mackall <mpm@selenic.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
References: <4797D64D.1060105@goop.org> <1201202046.3897.41.camel@cinder.waste.org> <4798E51C.4000209@goop.org>
In-Reply-To: <4798E51C.4000209@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801251041.17392.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 January 2008 06:21, Jeremy Fitzhardinge wrote:
> Matt Mackall wrote:
> > There's perhaps an opportunity to do this lazy TLB trick in the mmap
> > path as well, where RW mappings are initially mapped as RO so we can
> > catch processes dirtying them and then switched to RW. If the mapping is
> > shared across threads on multiple cores, we can defer synchronizing the
> > TLBs on the others.
>
> I think spurious usermode faults are already dealt with.
> handle_pte_fault() does essentially the same thing as this patch:
>
> 	if (ptep_set_access_flags(vma, address, pte, entry, write_access)) {
> 		update_mmu_cache(vma, address, entry);
> 	} else {
> 		/*
> 		 * This is needed only for protection faults but the arch code
> 		 * is not yet telling us if this is a protection fault or not.
> 		 * This still avoids useless tlb flushes for .text page faults
> 		 * with threads.
> 		 */
> 		if (write_access)
> 			flush_tlb_page(vma, address);
> 	}

I (obviously) don't know exactly how the TLB works in x86, but I
thought that on a miss, the CPU walks the pagetables first before
faulting? Maybe that's not the case if there is an RO entry
actually in the TLB?
