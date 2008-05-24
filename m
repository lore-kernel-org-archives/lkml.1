Return-Path: <linux-kernel-owner+w=401wt.eu-S1760945AbYEXR1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760945AbYEXR1R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 13:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757677AbYEXR1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 13:27:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58258 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757347AbYEXR1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 13:27:06 -0400
Date: Sat, 24 May 2008 10:25:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hugh@veritas.com>,
       Zachary Amsden <zach@vmware.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 0 of 4] mm+paravirt+xen: add pte read-modify-write
 abstraction
In-Reply-To: <48372C2F.1090704@goop.org>
Message-ID: <alpine.LFD.1.10.0805241022210.3081@woody.linux-foundation.org>
References: <patchbomb.1211552448@localhost> <alpine.LFD.1.10.0805231133130.3081@woody.linux-foundation.org> <48372C2F.1090704@goop.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 23 May 2008, Jeremy Fitzhardinge wrote:
> 
> Well, you could use it to update the page and protection bits while preserving
> the AD bits, but I don't think that's very useful.

It's not that it's not "very useful" - it's that it would be TOTALLY 
WRONG.

If you change the page and the AD bits can change randomly while you do 
so, that means that the AD bits are now _undefined_. Which of the two 
pages did it happen to? The old one? The new one? Nobody can know. So 
you'd effectively have dirty bits that could be associated with the wrong 
physical page, which means that some page may be dirty, but the kernel 
would have it marked clean.

That would be beyond bad. That would be a *serious* VM bug, with very 
subtle data corruption issues.

So no, you cannot, and absolutely must not use this to update the actual 
page mapping. Ever. It is only valid for the protection bits.

		Linus
