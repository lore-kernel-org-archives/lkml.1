Return-Path: <linux-kernel-owner+w=401wt.eu-S1761398AbXKPRMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761398AbXKPRMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 12:12:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbXKPRMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 12:12:40 -0500
Received: from gw.goop.org ([64.81.55.164]:55794 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809AbXKPRMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 12:12:39 -0500
Message-ID: <473DCF73.4070401@goop.org>
Date: Fri, 16 Nov 2007 09:12:19 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: William Lee Irwin III <wli@holomorphy.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Why preallocate pmd in x86 32-bit PAE?
References: <473CC0AC.3020500@goop.org> <alpine.LFD.0.9999.0711151403000.4260@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0711151403000.4260@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Thu, 15 Nov 2007, Jeremy Fitzhardinge wrote:
>   
>> Once difference is that 64-bit incrementally allocates all levels of the
>> pagetable, whereas 32-bit PAE preallocates the 4 pmds when it allocates
>> the pgd.  What's the rationale for this?  What pitfalls would there be
>> in making them incrementally allocated?
>>     
>
> IIRC, the present bit is ignored in the magic 4-entry PGD.  All entries 
> have to be present.
>   

Hm, do you recall what processors that might affect?  As far as I know,
current processors will ignore non-present top-level entries.  Anyway,
we can point them not present to empty_zero_page, so testing the present
bit will still be sufficient to tell if we need to allocate a new pmd,
but if the hardware decides to follow the page reference there's no harm
done.  (Hm, unless the hardware decides it wants to set A or D bits in
empty_zero_page for some reason...)

> What earlier CPU's did was to basically load all four values into the CPU 
> when you loaded %cr3. There was no "three-level page table walker" at all: 
> it was still a two-level page table walker, there were just for magic 
> internal page tables that were indexed off the two high bits.
>   

That just means we need to reload cr3 after populating the pgd with a
new pmd, right?

    J
