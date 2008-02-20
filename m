Return-Path: <linux-kernel-owner+w=401wt.eu-S1761755AbYBTSJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761755AbYBTSJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 13:09:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755198AbYBTSIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 13:08:49 -0500
Received: from www.tglx.de ([62.245.132.106]:57835 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855AbYBTSIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 13:08:48 -0500
Date: Wed, 20 Feb 2008 19:08:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arne Georg Gleditsch <arne.gleditsch@dolphinics.no>
cc: LKML <linux-kernel@vger.kernel.org>, Roman Zippel <zippel@linux-m68k.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: arch/x86/kernel/vsyscall_64.c: overeager NOP of syscalls
In-Reply-To: <kjm4pc3d92p.fsf@pelargir.dolphinics.no>
Message-ID: <alpine.LFD.1.00.0802201836480.7583@apollo.tec.linutronix.de>
References: <kjm4pc3d92p.fsf@pelargir.dolphinics.no>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arne,

On Wed, 20 Feb 2008, Arne Georg Gleditsch wrote:
> I'm looking at 2.6.25-rc2.  vsyscall_sysctl_change contains code to NOP
> out the actual system call instructions of the vsyscall page when
> vsyscall64 is enabled.  This seems to interact badly with the fallback
> code in do_vgettimeofday which tries to call gettimeofday if the
> configured clock source does not support vread.  (In effect,
> gettimeofday() becomes a nop and time() always returns 0.  Not very
> useful.)

Indeed.
 
> Is there a good reason to keep this?  Aren't the instructions in
> question avoided (or invoked) according to the vsyscall64 flag by the
> surrounding logic anyway?

The initial intent of this was to make it harder for malicious code to
attack via the vsysall area.

But you are right, the code is indeed fundamentally unsafe in various
aspects:

1) the patching code runs without synchronizing other CPUs

2) it inserts NOPs even if there is no clock source which provides
vread

3) when the clock source changes to one without vread we run in
exactly the same problem as in #2

The correct solution is randomizing that area, but that's definitely
not an ad hoc fix.

Thanks for pointing this out. I'm looking into fixing this ASAP.

       tglx
