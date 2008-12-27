Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbYL0PyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbYL0PyT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 10:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbYL0PyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 10:54:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57064 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082AbYL0PyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 10:54:06 -0500
Date: Sat, 27 Dec 2008 16:53:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Brian Gerst <brgerst@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86-64: Convert the PDA to percpu.
Message-ID: <20081227155339.GA17851@elte.hu>
References: <1230052506-5041-1-git-send-email-brgerst@gmail.com> <20081227104123.GH14639@elte.hu> <73c1f2160812270730w249eabb4labaa4fa3bc6a6ddd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73c1f2160812270730w249eabb4labaa4fa3bc6a6ddd@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Brian Gerst <brgerst@gmail.com> wrote:

> On Sat, Dec 27, 2008 at 5:41 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > (Cc:-ed a few more people who might be interested in this)
> >
> > * Brian Gerst <brgerst@gmail.com> wrote:
> >
> >> This patch makes the PDA a normal per-cpu variable, allowing the
> >> removal of the special allocator code.  %gs still points to the
> >> base of the PDA.
> >>
> >> Tested on a dual-core AMD64 system.
> >>
> >> Signed-off-by: Brian Gerst <brgerst@gmail.com>
> >> ---
> >>  arch/x86/include/asm/pda.h     |    3 --
> >>  arch/x86/include/asm/percpu.h  |    3 --
> >>  arch/x86/include/asm/setup.h   |    1 -
> >>  arch/x86/kernel/cpu/common.c   |    6 ++--
> >>  arch/x86/kernel/dumpstack_64.c |    8 ++--
> >>  arch/x86/kernel/head64.c       |   23 +------------
> >>  arch/x86/kernel/irq.c          |    2 +-
> >>  arch/x86/kernel/nmi.c          |    2 +-
> >>  arch/x86/kernel/setup_percpu.c |   70 ++++++++--------------------------------
> >>  arch/x86/kernel/smpboot.c      |   58 +--------------------------------
> >>  arch/x86/xen/enlighten.c       |    2 +-
> >>  arch/x86/xen/smp.c             |   12 +------
> >>  12 files changed, 27 insertions(+), 163 deletions(-)
> >
> > the simplification factor is significant. I'm wondering, have you measured
> > the code size impact of this on say the defconfig x86 kernel? That will
> > generally tell us how much worse optimizations the compiler does under
> > this scheme.
> >
> >        Ingo
> >
> 
> Patch #1 by itself doesn't change how the PDA is accessed, only how it
> is allocated.  The text size goes down significantly with patch #1,
> but data goes up.  Changing the PDA to cacheline-aligned (1a) brings
> it back in line.
> 
>    text	   data	    bss	    dec	    hex	filename
> 7033648	1754476	 758508	9546632	 91ab88	vmlinux.0   (vanilla 2.6.28)
> 7029563	1758428	 758508	9546499	 91ab03	vmlinux.1   (with patch #1)
> 7029563	1754460	 758508	9542531	 919b83	vmlinux.1a  (with patch #1 cache align)
> 7036694	1758428	 758508	9553630	 91c6de	vmlinux.3   (with all three patches)
> 
> I think the first patch (with the alignment fix) is a clear win.  As for 
> the other patches, they add about 8 bytes per use of a PDA variable.  
> cpu_number is used 903 times in this compile, so this is likely the most 
> extreme example.  I have an idea to optimize this particular case 
> further that I'd like to look at which would lessen the impact.

curious, what idea is that?

	Ingo
