Return-Path: <linux-kernel-owner+w=401wt.eu-S1761835AbXKPToQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761835AbXKPToQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 14:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbXKPToB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 14:44:01 -0500
Received: from gw.goop.org ([64.81.55.164]:56977 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbXKPToB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 14:44:01 -0500
Message-ID: <473DF2EF.70404@goop.org>
Date: Fri, 16 Nov 2007 11:43:43 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: William Lee Irwin III <wli@holomorphy.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Why preallocate pmd in x86 32-bit PAE?
References: <473CC0AC.3020500@goop.org> <alpine.LFD.0.9999.0711151403000.4260@woody.linux-foundation.org> <473DCF73.4070401@goop.org> <alpine.LFD.0.9999.0711160921510.4260@woody.linux-foundation.org> <473DEC1C.8080506@goop.org> <alpine.LFD.0.9999.0711161118160.4260@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0711161118160.4260@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Fri, 16 Nov 2007, Jeremy Fitzhardinge wrote:
>   
>> If you happened to do a 1G munmap, it may end up freeing and 
>> reallocating them, but that's going to be very rare.
>>     
>
> I don't think we ever free the pmd's now, do we?
>
> (Except for the *final* free, of course, when we release the whole VM).

Not for 32-bit at the moment, but it does in principle.  munmap ends up
calling free_pgtables, and so ends up calling pmd_free_range.  That will
do a pud_clear to detach the pmd from the pagetable and call
__pmd_free_tlb, which ends up doing tlb_remove_page ->
free_page_and_swap_cache.  32-bit knobbles all this at the moment, but
it looks to me like it wouldn't be hard to make this work if the code is
all common with 64-bit.

    J
