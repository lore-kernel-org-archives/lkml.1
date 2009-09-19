Return-Path: <linux-kernel-owner+w=401wt.eu-S1751380AbZISRzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380AbZISRzo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 13:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbZISRzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 13:55:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46591 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbZISRzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 13:55:43 -0400
Date: Sat, 19 Sep 2009 19:55:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Yinghai Lu <yinghai@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Zachary Amsden <zach@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Xiao Guangrong <xiaooguangrong@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: linux-next: reservetop fix disables mem=
Message-ID: <20090919175504.GJ5366@elte.hu>
References: <Pine.LNX.4.64.0908241736520.32764@sister.anvils> <4A92D029.8090807@kernel.org> <20090824182713.GB9785@elte.hu> <Pine.LNX.4.64.0909160117260.6814@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0909160117260.6814@sister.anvils>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:

> On Mon, 24 Aug 2009, Ingo Molnar wrote:
> > * Yinghai Lu <yinghai@kernel.org> wrote:
> > > Hugh Dickins wrote:
> > > > I find the "mem=" boot parameter disabled in today's linux-next:
> > > > reverting the tip commit below fixes that.
> > > > 
> > > > Hugh
> > > > 
> > > > From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> > > > Date: Thu, 20 Aug 2009 12:23:11 +0000 (+0800)
> > > > Subject: x86: Fix system crash when loading with "reservetop" parameter
> > > > X-Git-Url: http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Fmingo%2Flinux-2.6-x86.git;a=commitdiff_plain;h=8126dec32738421afa362114337331337b4be17f
> > > > 
> > > > x86: Fix system crash when loading with "reservetop" parameter
> > > > 
> > > > The system will die if the kernel is booted with "reservetop"
> > > > parameter, in present code, parse "reservetop" parameter after
> > > > early_ioremap_init(), and some function still use
> > > > early_ioremap() after it.
> > > > 
> > > > The problem is, "reservetop" parameter can modify
> > > > 'FIXADDR_TOP', then the virtual address got by early_ioremap()
> > > > is base on old 'FIXADDR_TOP', but the page mapping is base on
> > > > new 'FIXADDR_TOP', it will occur page fault, and the IDT is not
> > > > prepare yet, so, the system is dead.
> > > > 
> > > > So, put parse_early_param() in the front of
> > > > early_ioremap_init() in this patch.
> > > > 
> > > > Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> > > > Cc: yinghai@kernel.org
> > > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > > LKML-Reference: <4A8D402F.4080805@cn.fujitsu.com>
> > > > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > > > ---
> > > > 
> > > > diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> > > > index 63f32d2..02643cc 100644
> > > > --- a/arch/x86/kernel/setup.c
> > > > +++ b/arch/x86/kernel/setup.c
> > > > @@ -711,6 +711,11 @@ void __init setup_arch(char **cmdline_p)
> > > >  	printk(KERN_INFO "Command line: %s\n", boot_command_line);
> > > >  #endif
> > > >  
> > > > +	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
> > > > +	*cmdline_p = command_line;
> > > > +
> > > > +	parse_early_param();
> > > > +
> > > >  	/* VMI may relocate the fixmap; do this before touching ioremap area */
> > > >  	vmi_init();
> > > >  
> > > > @@ -793,11 +798,6 @@ void __init setup_arch(char **cmdline_p)
> > > >  #endif
> > > >  #endif
> > > >  
> > > > -	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
> > > > -	*cmdline_p = command_line;
> > > > -
> > > > -	parse_early_param();
> > > > -
> > > >  #ifdef CONFIG_X86_64
> > > >  	check_efer();
> > > >  #endif
> > > 
> > > yes, that patch will break other built-in command too.
> > > 
> > > need drop that patch.
> > 
> > done. Was nervous about the patch already:
> 
> Somehow it seems to have undropped itself, so mem= stopped working 
> again in recent mmotm/linux-next; and it looks like today the 
> undropped patch has made its way to Linus - I've not built current git 
> to check, but I think you'll find mem= is now broken there.

I thoroughly zapped it. Do you know about any commit ID where it snuck 
in?

	Ingo
