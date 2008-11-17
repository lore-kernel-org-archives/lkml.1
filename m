Return-Path: <linux-kernel-owner+w=401wt.eu-S1753287AbYKQVZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbYKQVZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 16:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbYKQVZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 16:25:34 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:61158 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbYKQVZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 16:25:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=e8vXOJIKrPJpG31/xyOV7a7ky3BSkw7FuRTXplBs1HQpmJbgs0lctw9IkntEqI1dkm
         ndwWoNyucEgoWbZp2opRBv0WrnCudpWCnA6wRBgM/xKXv7tBI+i/66K6vBZiM6NwyYW2
         sBMlwy/2JOz5bC6MgN/I7KoFY5W2HIGTWPdVQ=
Message-ID: <84144f020811171325m5eabca71ge525ea643dbe8209@mail.gmail.com>
Date: Mon, 17 Nov 2008 23:25:30 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Large stack usage in fs code (especially for PPC64)
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Paul Mackerras" <paulus@samba.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <alpine.LFD.2.00.0811171309580.18283@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.1.10.0811171508300.8722@gandalf.stny.rr.com>
	 <alpine.DEB.1.10.0811171557370.26123@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.0811171309580.18283@nehalem.linux-foundation.org>
X-Google-Sender-Auth: c7cefc1530c66b98
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2008 at 11:18 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> I do wonder just _what_ it is that causes the stack frames to be so
> horrid. For example, you have
>
>         18)     8896     160   .kmem_cache_alloc+0xfc/0x140
>
> and I'm looking at my x86-64 compile, and it has a stack frame of just 8
> bytes (!) for local variables plus the save/restore area (which looks like
> three registers plus frame pointer plus return address). IOW, if I'm
> looking at the code right (so big caveat: I did _not_ do a real stack
> dump!) the x86-64 stack cost for that same function is on the order of 48
> bytes. Not 160.
>
> Where does that factor-of-three+ difference come from? From the numbers, I
> suspect ppc64 has a 32-byte stack alignment, which may be part of it, and
> I guess the compiler is more eager to use all those extra registers and
> will happily have many more callee-saved regs that are actually used.
>
> But that still a _lot_ of extra stack.
>
> Of course, you may have things like spinlock debugging etc enabled. Some
> of our debugging options do tend to blow things up.

Note that kmem_cache_alloc() is likely to contain lots of inlined
functions for both SLAB and SLUB. Perhaps that blows up stack usage on
ppc?
