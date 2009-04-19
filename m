Return-Path: <linux-kernel-owner+w=401wt.eu-S1752910AbZDSWCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbZDSWCv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 18:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbZDSWCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 18:02:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55501 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbZDSWCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 18:02:42 -0400
Message-ID: <49EB9F59.4080904@zytor.com>
Date: Sun, 19 Apr 2009 15:02:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Roland Dreier <rdreier@cisco.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Hitoshi Mitake <h.mitake@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: arch/x86/Kconfig selects invalid HAVE_READQ, HAVE_WRITEQ vars
References: <alpine.LFD.2.00.0904191543530.11789@localhost.localdomain> <adaab6c1h7c.fsf@cisco.com> <20090419214602.GA21527@elte.hu>
In-Reply-To: <20090419214602.GA21527@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> Look at the drivers that define their own wrappers:
> 
> #ifndef readq
> static inline unsigned long long readq(void __iomem *addr)
> {
>         return readl(addr) | (((unsigned long long)readl(addr + 4)) << 32LL);
> }
> #endif
> 
> ... it's the obvious 32-bit semantics for reading a 64-bit value 
> from an mmio address. We made that available on 32-bit too.
> 
> It's being used ... and has been in use for some time. Where's the 
> problem? readl is serializing on all default-ioremap mmio targets on 
> x86 so there's no ambiguity in ordering.
> 

I think his point is that they're not atomic.  For what it's worth,
atomic readq()/writeq() *are* possible with any x86-32 CPU which
supports MMX, but it is very costly to do in the kernel since it
involves touching the FPU state.

For the vast number of users, a non-atomic primitive which is available
for both 32- and 64-bit x86 is a win.  For a small number of users,
it'll be confusing, and for a very small minority it's going to be
desirable to have the atomic primitive.

The reason the non-atomic is generally fine is because most device
drivers are inherently single-threaded on a per-hardware device basis.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

