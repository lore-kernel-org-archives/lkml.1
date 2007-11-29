Return-Path: <linux-kernel-owner+w=401wt.eu-S932919AbXK2TvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932919AbXK2TvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 14:51:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758126AbXK2Tu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 14:50:57 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51429 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758115AbXK2Tu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 14:50:56 -0500
Date: Thu, 29 Nov 2007 11:49:39 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>, zach@vmware.com
Subject: Re: [PATCH x86/mm 6/6] x86-64 ia32 ptrace get/putreg32 current
 task
In-Reply-To: <20071129192721.GP24223@one.firstfloor.org>
Message-ID: <alpine.LFD.0.9999.0711291139290.8458@woody.linux-foundation.org>
References: <20071129003849.428E026F8E7@magilla.localdomain> <20071129004222.E49AD26F8E7@magilla.localdomain> <474EF824.3020806@redhat.com> <alpine.LFD.0.9999.0711290958110.8458@woody.linux-foundation.org> <474F01F6.2030509@zytor.com>
 <alpine.LFD.0.9999.0711291027070.8458@woody.linux-foundation.org> <474F08E1.2090806@zytor.com> <alpine.LFD.0.9999.0711291057320.8458@woody.linux-foundation.org> <474F1027.2020801@zytor.com> <20071129192721.GP24223@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 29 Nov 2007, Andi Kleen wrote:
> 
> For i386 iirc Jeremy/Zach did the benchmarking and they settled
> on %fs because it was faster for something (originally it was %gs too) 

Hmm. Context switching ends up having to switch the segment that we do 
*not* use for the kernel, and the context switching can be faster for the 
case where

 (a) the segment selector is identical in both source and destination
*AND*
 (b) the selector is either zero or points to a GDT entry.

So yes, context switching can be faster for a NUL selector if both old and 
new threads use it, and in fact that's the onle case we check right now:

	/*
	 * Restore %gs if needed (which is common)
	 */
	if (prev->gs | next->gs)
		loadsegment(gs, next->gs);

for the 32-bit case. That is faster if "gs" is normally zero, since that 
means that we can avoid that loadsegment.

HOWEVER. That is actually not the right (well, "complete") conditional, 
since it's only one sub-case of the thing that matters. The right 
conditional is probably

	/*
	 * Restore %gs if needed (which is common).
	 * We can avoid it if they are identical, and
	 * point to the GDT.
	 */
	if ((prev->gs ^ next->gs) | (next->gs & 4))
		loadsegment(gs, next->gs);

At that point, we would only have to reload stuff if the user actually 
uses a local descriptor table entry (which does happen for threaded apps, 
I guess, but at least we avoid it for all the common traditional UNIX 
processes).

			Linus
