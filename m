Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbYAXTVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbYAXTVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 14:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbYAXTVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 14:21:05 -0500
Received: from gw.goop.org ([64.81.55.164]:59394 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313AbYAXTVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:21:02 -0500
Message-ID: <4798E51C.4000209@goop.org>
Date: Thu, 24 Jan 2008 11:21:00 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH UPDATE] x86: ignore spurious faults
References: <4797D64D.1060105@goop.org> <1201133916.16972.124.camel@brick>	 <4797DBA0.5020909@goop.org> <1201202046.3897.41.camel@cinder.waste.org>
In-Reply-To: <1201202046.3897.41.camel@cinder.waste.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> There's perhaps an opportunity to do this lazy TLB trick in the mmap
> path as well, where RW mappings are initially mapped as RO so we can
> catch processes dirtying them and then switched to RW. If the mapping is
> shared across threads on multiple cores, we can defer synchronizing the
> TLBs on the others.
>   

I think spurious usermode faults are already dealt with.  
handle_pte_fault() does essentially the same thing as this patch:

	if (ptep_set_access_flags(vma, address, pte, entry, write_access)) {
		update_mmu_cache(vma, address, entry);
	} else {
		/*
		 * This is needed only for protection faults but the arch code
		 * is not yet telling us if this is a protection fault or not.
		 * This still avoids useless tlb flushes for .text page faults
		 * with threads.
		 */
		if (write_access)
			flush_tlb_page(vma, address);
	}



    J
