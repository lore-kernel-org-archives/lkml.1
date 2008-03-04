Return-Path: <linux-kernel-owner+w=401wt.eu-S1763338AbYCDVTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763338AbYCDVTP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 16:19:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762165AbYCDVS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 16:18:56 -0500
Received: from gw.goop.org ([64.81.55.164]:36426 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753767AbYCDVSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 16:18:54 -0500
Message-ID: <47CDBB87.8090906@goop.org>
Date: Tue, 04 Mar 2008 13:13:43 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: preempt bug in set_pmd_pfn?
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think set_pmd_pfn, which is only called by __set_fixmap, might have a 
preempt bug in it.

It can be executed with preemption enabled, but what if it gets preempted

	set_pmd(pmd, pfn_pmd(pfn, flags));
	/*
	 * It's enough to flush this one mapping.
	 * (PGE mappings get flushed as well)
	 */
>here<
	__flush_tlb_one(vaddr);
}

?


Won't this leave a stale tlb on the old processor?

I noticed this because the Xen tlb flushing code effectively has a 
smp_processor_id(), which provokes a warning when preemption is 
enabled.  It seems to me that it never makes sense to be doing a tlb 
flush unless you know which processor you're actually running on...

    J
