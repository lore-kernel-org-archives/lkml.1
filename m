Return-Path: <linux-kernel-owner+w=401wt.eu-S1761861AbXK2UDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761861AbXK2UDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 15:03:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932200AbXK2UC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 15:02:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33262 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242AbXK2UC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:02:58 -0500
Message-ID: <474F1AB1.1060300@zytor.com>
Date: Thu, 29 Nov 2007 12:01:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, zach@vmware.com
Subject: Re: [PATCH x86/mm 6/6] x86-64 ia32 ptrace get/putreg32 current task
References: <20071129003849.428E026F8E7@magilla.localdomain> <20071129004222.E49AD26F8E7@magilla.localdomain> <474EF824.3020806@redhat.com> <alpine.LFD.0.9999.0711290958110.8458@woody.linux-foundation.org> <474F01F6.2030509@zytor.com> <alpine.LFD.0.9999.0711291027070.8458@woody.linux-foundation.org> <474F08E1.2090806@zytor.com> <alpine.LFD.0.9999.0711291057320.8458@woody.linux-foundation.org> <474F1027.2020801@zytor.com> <20071129192721.GP24223@one.firstfloor.org> <20071129194416.GB15245@elte.hu>
In-Reply-To: <20071129194416.GB15245@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
>> For i386 iirc Jeremy/Zach did the benchmarking and they settled on %fs 
>> because it was faster for something (originally it was %gs too)
> 
> yep. IIRC, some CPUs only optimize %fs because that's what Windows uses 
> and leaves Linux with %gs out in the cold. There's also a performance 
> penalty for overlapping segment use, if the segment cache is single 
> entry only with an additional optimization for NULL [which just hides 
> the segment cache].
> 

For the 32-bit case, which is the only one that can be changed at all:

I guess, specifically, that assuming a sysenter implementation (meaning 
CS is handled ad hoc by the sysenter/sysexit instructions) we have 
USER_DS, KERNEL_DS, and the kernel thread pointer.  If the segments 
don't overlap, the user thread pointer gets loaded once per exec or task 
switch, and doesn't change in between.  If they do, the user thread 
pointer has to be reloaded on system call exit.

A nonzero segment load involves a memory reference followed by 
data-dependent traps on that reference, so the amount of reordering the 
CPU can do to hide that latency is limited.  A zero segment load doesn't 
  perform the memory reference at all.

Note that a segment cache (a proper cache, not the segment descriptor 
registers that the Intel docs bogusly call a "cache") does *not* save 
the memory reference, since if the descriptor has changed in memory it 
*has* to be honoured; it only allows it to be performed lazily (assume 
the cache is valid, then throw an internal exception and don't commit 
state if the descriptor stored in the cache tag doesn't match the 
descriptor loaded from memory.)

	-hpa

