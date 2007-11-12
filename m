Return-Path: <linux-kernel-owner+w=401wt.eu-S1758471AbXKLVRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471AbXKLVRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 16:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbXKLVQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 16:16:46 -0500
Received: from cantor.suse.de ([195.135.220.2]:35399 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbXKLVQp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 16:16:45 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] x86: fix taking DNA during 64bit sigreturn
Date: Mon, 12 Nov 2007 22:16:40 +0100
User-Agent: KMail/1.9.6
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, akpm@linux-foundation.org
References: <20071111192758.GA21851@linux-os.sc.intel.com> <alpine.LFD.0.9999.0711121044130.30499@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0711121044130.30499@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200711122216.40663.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> The *real* fix for this is almost certainly to just get rid of the 64-bit 
> code entirely, and use the 32-bit code as the base for one single unified 
> setup.

That would likely break the ABI. x86-64 ABI is completely different here --
no ibcs, just pure x86 ISA.

I always thought direct FXSAVE from/to user space to be a cute trick, but yes 
the exception Suresh noticed makes it lose some of its beauty.

> The 32-bit code should be largely a superset of the 64-bit code  
> anyway, since it has to handle more cases, and does it more cleanly.

If you consider compat code 64bit handles as many cases as 32bit.
 
> which isn't exactly pretty, but the memory address generation works fine 
> in 32-bit code too, and the rex override is easily done with
> 
> 	#ifdef CONFIG_X86_64
> 	  #define REX64 "rex64/"
> 	#else
> 	  #define REX64 ""
> 	#endif
> 
> and then you just use
> 
> 	REX64 "fxsave"

That didn't work on older assemblers.

> But maybe I'm missing some reason why it doesn't matter. The 32-bit code 
> was fixed back in 2003 (commit 5bff44fc272b948a85e893a007d01b9dfb3ad04f 

64bit FPU semantics are somewhat different. I don't remember if this
particular issue was addressed or not, but I fixed a few shared
bugs in a quite different way on 64bit vs 32bit. If anybody wants
to change something here don't assume they are the same.

>From a cursory look it's probably broken though.

-Andi
