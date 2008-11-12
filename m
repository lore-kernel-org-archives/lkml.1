Return-Path: <linux-kernel-owner+w=401wt.eu-S1752944AbYKLMeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944AbYKLMeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 07:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbYKLMeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 07:34:05 -0500
Received: from aun.it.uu.se ([130.238.12.36]:38548 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbYKLMeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 07:34:04 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18714.52512.213371.33245@harpo.it.uu.se>
Date: Wed, 12 Nov 2008 13:33:36 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Ingo Molnar <mingo@elte.hu>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: ia32_signal: remove unnecessary padding
In-Reply-To: <20081112112937.GA6372@elte.hu>
References: <491A48E9.8020909@ct.jp.nec.com>
	<491A496B.5010505@ct.jp.nec.com>
	<20081112112937.GA6372@elte.hu>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:
 > 
 > * Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:
 > 
 > > From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
 > > 
 > > Impact: cleanup
 > > 
 > > Remove unnecessary paddings, this saves 4 bytes.
 > > 
 > > Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
 > > ---
 > >  arch/x86/ia32/ia32_signal.c |    5 +----
 > >  1 files changed, 1 insertions(+), 4 deletions(-)
 > 
 > applied your patches to tip/x86/signal:
 > 
 >  9cc3c49: x86: ia32_signal: remove unnecessary padding
 >  4a61204: x86: signal_32: introduce retcode and rt_retcode
 > 
 > thanks!
 > 
 > A question - this change:
 > 
 > > @@ -427,12 +427,10 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 > >  		u16 poplmovl;
 > >  		u32 val;
 > >  		u16 int80;
 > > -		u16 pad;
 > >  	} __attribute__((packed)) code = {
 > >  		0xb858,		 /* popl %eax ; movl $...,%eax */
 > >  		__NR_ia32_sigreturn,
 > >  		0x80cd,		/* int $0x80 */
 > > -		0,
 > >  	};
 > >  
 > >  	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate);
 > > @@ -508,8 +506,7 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 > >  		u8 movl;
 > >  		u32 val;
 > >  		u16 int80;
 > > -		u16 pad;
 > > -		u8  pad2;
 > > +		u8  pad;
 > >  	} __attribute__((packed)) code = {
 > >  		0xb8,
 > >  		__NR_ia32_rt_sigreturn,
 > 
 > does not impact any ABI, because it's only about the signal trampoline 
 > the kernel pushes to the user-space stack - not about any 
 > userspace-visible signal frame detail, right?

As long as the 'char retcode[8]' field isn't reduced in size
(you can _never_ do that!), and the initial instruction
sequence up to the 'int $0x80' isn't changed (you can't change
that either), I believe this is safe.

It does cause each signal delivery to leak 2 uninitialised
kernel bytes to the end of retcode[], which seems unnecessary.
