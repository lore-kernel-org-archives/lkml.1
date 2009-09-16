Return-Path: <linux-kernel-owner+w=401wt.eu-S1757962AbZIPAYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962AbZIPAYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 20:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbZIPAYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 20:24:11 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:19717 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753141AbZIPAYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 20:24:10 -0400
X-Trace: 259194392/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.4.183/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.4.183
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAIjMr0pPRQS3/2dsb2JhbACBU94KhBcF
X-IronPort-AV: E=Sophos;i="4.44,393,1249254000"; 
   d="scan'208";a="259194392"
Date: Wed, 16 Sep 2009 01:23:26 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Ingo Molnar <mingo@elte.hu>
cc: Yinghai Lu <yinghai@kernel.org>, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Zachary Amsden <zach@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Xiao Guangrong <xiaooguangrong@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: linux-next: reservetop fix disables mem=
In-Reply-To: <20090824182713.GB9785@elte.hu>
Message-ID: <Pine.LNX.4.64.0909160117260.6814@sister.anvils>
References: <Pine.LNX.4.64.0908241736520.32764@sister.anvils>
 <4A92D029.8090807@kernel.org> <20090824182713.GB9785@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Aug 2009, Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> > Hugh Dickins wrote:
> > > I find the "mem=" boot parameter disabled in today's linux-next:
> > > reverting the tip commit below fixes that.
> > > 
> > > Hugh
> > > 
> > > From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> > > Date: Thu, 20 Aug 2009 12:23:11 +0000 (+0800)
> > > Subject: x86: Fix system crash when loading with "reservetop" parameter
> > > X-Git-Url: http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Fmingo%2Flinux-2.6-x86.git;a=commitdiff_plain;h=8126dec32738421afa362114337331337b4be17f
> > > 
> > > x86: Fix system crash when loading with "reservetop" parameter
> > > 
> > > The system will die if the kernel is booted with "reservetop"
> > > parameter, in present code, parse "reservetop" parameter after
> > > early_ioremap_init(), and some function still use
> > > early_ioremap() after it.
> > > 
> > > The problem is, "reservetop" parameter can modify
> > > 'FIXADDR_TOP', then the virtual address got by early_ioremap()
> > > is base on old 'FIXADDR_TOP', but the page mapping is base on
> > > new 'FIXADDR_TOP', it will occur page fault, and the IDT is not
> > > prepare yet, so, the system is dead.
> > > 
> > > So, put parse_early_param() in the front of
> > > early_ioremap_init() in this patch.
> > > 
> > > Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> > > Cc: yinghai@kernel.org
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > LKML-Reference: <4A8D402F.4080805@cn.fujitsu.com>
> > > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > > ---
> > > 
> > > diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> > > index 63f32d2..02643cc 100644
> > > --- a/arch/x86/kernel/setup.c
> > > +++ b/arch/x86/kernel/setup.c
> > > @@ -711,6 +711,11 @@ void __init setup_arch(char **cmdline_p)
> > >  	printk(KERN_INFO "Command line: %s\n", boot_command_line);
> > >  #endif
> > >  
> > > +	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
> > > +	*cmdline_p = command_line;
> > > +
> > > +	parse_early_param();
> > > +
> > >  	/* VMI may relocate the fixmap; do this before touching ioremap area */
> > >  	vmi_init();
> > >  
> > > @@ -793,11 +798,6 @@ void __init setup_arch(char **cmdline_p)
> > >  #endif
> > >  #endif
> > >  
> > > -	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
> > > -	*cmdline_p = command_line;
> > > -
> > > -	parse_early_param();
> > > -
> > >  #ifdef CONFIG_X86_64
> > >  	check_efer();
> > >  #endif
> > 
> > yes, that patch will break other built-in command too.
> > 
> > need drop that patch.
> 
> done. Was nervous about the patch already:

Somehow it seems to have undropped itself, so mem= stopped working
again in recent mmotm/linux-next; and it looks like today the
undropped patch has made its way to Linus - I've not built current
git to check, but I think you'll find mem= is now broken there.

Hugh

> 
>   http://lkml.org/lkml/2009/8/21/127
> 
> > also the problem was caused by vmi patch, and that commit should 
> > be reverted.
> >
> > commit ae8d04e2ecbb233926860e9ce145eac19c7835dc
> > Author: Zachary Amsden <zach@vmware.com>
> > Date:   Sat Dec 13 12:36:58 2008 -0800
> > 
> >     x86 Fix VMI crash on boot in 2.6.28-rc8
> >     
> >     VMI initialiation can relocate the fixmap, causing early_ioremap to
> >     malfunction if it is initialized before the relocation.  To fix this,
> >     VMI activation is split into two phases; the detection, which must
> >     happen before setting up ioremap, and the activation, which must happen
> >     after parsing early boot parameters.
> >     
> >     This fixes a crash on boot when VMI is enabled under VMware.
> >     
> >     Signed-off-by: Zachary Amsden <zach@vmware.com>
> >     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > 
> > diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> > index 9d5674f..bdec76e 100644
> > --- a/arch/x86/kernel/setup.c
> > +++ b/arch/x86/kernel/setup.c
> > @@ -794,6 +794,9 @@ void __init setup_arch(char **cmdline_p)
> >         printk(KERN_INFO "Command line: %s\n", boot_command_line);
> >  #endif
> >  
> > +       /* VMI may relocate the fixmap; do this before touching ioremap area */
> > +       vmi_init();
> > +
> >         early_cpu_init();
> >         early_ioremap_init();
> >  
> > @@ -880,13 +883,8 @@ void __init setup_arch(char **cmdline_p)
> >         check_efer();
> >  #endif
> >  
> > -#if defined(CONFIG_VMI) && defined(CONFIG_X86_32)
> > -       /*
> > -        * Must be before kernel pagetables are setup
> > -        * or fixmap area is touched.
> > -        */
> > -       vmi_init();
> > -#endif
> > +       /* Must be before kernel pagetables are setup */
> > +       vmi_activate();
> >  
> >         /* after early param, so could get panic from serial */
> >         reserve_early_setup_data();
> > 
> > 
> > and according to
> > http://lkml.org/lkml/2008/12/10/388
> > http://lkml.org/lkml/2008/12/10/456
> > 
> > Zachary should split reserve_top_address() to two functions... 
> > before sending that patch to Linus
> 
> mind looking at this yourself if interested? Zachary has not been 
> active for quite some time.
> 
> 	Ingo
