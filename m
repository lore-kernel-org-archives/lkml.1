Return-Path: <linux-kernel-owner+w=401wt.eu-S937709AbYEVAtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937709AbYEVAtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 20:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934876AbYEVAsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 20:48:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934805AbYEVAsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 20:48:36 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Mikael Pettersson <mikpe@it.uu.se>, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       drepper@redhat.com, Hongjiu.lu@intel.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, rmk+lkml@arm.linux.org.uk, dan@debian.org,
       asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
In-Reply-To: H. Peter Anvin's message of  Wednesday, 21 May 2008 17:05:47 -0700 <4834B8DB.6030504@zytor.com>
References: <20080513011030.GA31448@linux-os.sc.intel.com>
	<18477.35703.679574.760417@harpo.it.uu.se>
	<20080518013416.GB30034@linux-os.sc.intel.com>
	<18481.37905.297556.288317@harpo.it.uu.se>
	<20080520015723.GD30034@linux-os.sc.intel.com>
	<4832A173.6020203@firstfloor.org>
	<4832E672.3090702@zytor.com>
	<4832E85B.4080303@firstfloor.org>
	<20080520201044.ED62B26FA1C@magilla.localdomain>
	<4834B8DB.6030504@zytor.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20080522004752.C399426FA24@magilla.localdomain>
Date: Wed, 21 May 2008 17:47:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1. potential information leak out of the kernel if the memory area isn't 
> zeroed before the first FXSAVE - I haven't verified if so is the case. 
> This would be a (potentially very serious) security hole.

Not a problem (see init_fpu).

> 2. Hidden state in the kernel - this means user space can set 
> nonarchitectural state in the kernel.  There are a few risks with that:
> 
>     a. Malware might use it to hide state.

Meh.  You can already use FP reg space when abusing non-FP-using programs
(via ptrace or signal frame clobbering).  Via ptrace, you can use %db[0-3]
without setting %db7 to make them affect hardware.  etc, etc.

>     b. The possibility of using the stability or lack thereof of this
>        state to extract information about kernel internals and/or
>        provide a covert channel in the presence of hardware changes.
>     c. It is not certain that future architectures will not have
>        off-limit fields here, like the equivalent of MXCSR.  This is
>        somewhat of a tricky judgement, of course, but it seems safer
>        to me if we would explicitly list the modifiable fields.

Meh.  The status quo is that (aside from initialization) it gets
whatever the hardware does.  FXRSTOR is an unprivileged instruction.
AFAIK the only reason we control the MXCSR value is because we don't
want to handle a #GP in context switch.  That would happen if reserved
bits were set in MXCSR.  We already have code to do fxrstor and handle
it, which sigreturn uses.  We could just use that if it weren't so
trivial to keep MXCSR safe--but since it is, why not keep one fewer
entry in the exception fixup table?

The hardware people know that it is unprivileged and is used in this way
where privileged code uses a data block received from unprivileged code.
If they add things that can make the data lead to new kinds of
exceptions, they will make it require the OS enable something, just like
we already have to set OSFXSR for the MXCSR reserved bits #GP case to be
possible.

Any piece of software state we start using in this buffer just has to
meet these same expectations.  (i.e. if any value could cause lossage to
anything but the user's own memory and user-mode CPU state, then we have
to police it at sigreturn/user_regset.set time.)


Thanks,
Roland
