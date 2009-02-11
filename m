Return-Path: <linux-kernel-owner+w=401wt.eu-S1756575AbZBKK6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbZBKK6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 05:58:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbZBKK5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 05:57:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36422 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbZBKK5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 05:57:53 -0500
Date: Wed, 11 Feb 2009 11:57:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: hpa@zytor.com, jeremy@goop.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, x86@kernel.org, rusty@rustcorp.com.au
Subject: Re: [PATCHSET x86/master] add stack protector support for x86_32
Message-ID: <20090211105729.GO20518@elte.hu>
References: <1234186798-16820-1-git-send-email-tj@kernel.org> <20090209135557.GB14785@elte.hu> <20090209141209.GA24323@elte.hu> <499186FB.4070506@kernel.org> <49918C3C.8030208@kernel.org> <20090210142026.GD16147@elte.hu> <49918E86.4020304@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49918E86.4020304@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Ingo Molnar wrote:
> >>> I'll try other compilers but which version are you using?  The
> >>> difference is that before the patchset, -fno-stack-protector was
> >>> always added whether stackprotector was enabled or not so this problem
> >>> wasn't visible (at the cost of bogus stackprotector of course).  We'll
> >>> probably need to add __stack_chk_guard or disable if gcc generates
> >>> such symbol.  I'll play with different gccs.
> >> Can't reproduce with gcc-4.1 or 4.2.  Any chance you're using distcc
> >> w/ a build machine w/ glibc < 2.4?  __stack_chk_guard is the symbol
> >> gcc fetches stack canary from if TLS is not supported, so somehow gcc
> >> thought that TLS wasn't available while building head64.
> > 
> > yeah - i also used distcc. Maybe the nostackp makefile magic gets confused
> > about that?
> 
> It seems that even with the same gcc versions, gcc built against libc
> w/o TLS support generates __stack_chk_guard, so if you mix the two
> flavors, the has-stack-protector check can be compiled on machines w/
> TLS while some other files end up being built on machines w/o TLS
> support thus circumventing the support check.  Can you please see
> whether non-distcc build fails too?

That build succeeds:

rhea:~/tip> make -j30 bzImage ARCH=x86_64 CROSS_COMPILE='/opt/crosstool/gcc-4.2.3-glibc-2.3.6/x86_64-unknown-linux-gnu/bin/x86_64-unknown-linux-gnu-'
/home/mingo/tip/arch/x86/Makefile:82: stack protector enabled but no compiler support
  CHK     include/linux/version.h
[...]
BFD: arch/x86/boot/compressed/vmlinux.bin: warning: allocated section `.bss' not in segment
[...]
Root device is (8, 3)
Setup is 11996 bytes (padded to 12288 bytes).
System is 5690 kB
CRC be1b2e21
Kernel: arch/x86/boot/bzImage is ready  (#3)

Some shell variable expansion bug? If CROSS_COMPILE is not a single word
we fail to detect the compiler borkage at arch/x86/Makefile line 82?

	Ingo
