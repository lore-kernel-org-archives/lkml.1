Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbZHYGwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbZHYGwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 02:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbZHYGwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 02:52:13 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:56322 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbZHYGwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 02:52:12 -0400
Date: Tue, 25 Aug 2009 15:52:12 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] timekeeping: Fix up read_persistent_clock() breakage on sh.
Message-ID: <20090825065212.GA31462@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Ingo Molnar <mingo@elte.hu>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	linux-kernel@vger.kernel.org
References: <20090824223239.GB20832@linux-sh.org> <20090825064458.GC14286@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825064458.GC14286@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 08:44:58AM +0200, Ingo Molnar wrote:
> 
> * Paul Mundt <lethal@linux-sh.org> wrote:
> 
> > The recent commit "timekeeping: Increase granularity of
> > read_persistent_clock()" introduced read_persistent_clock() rework which
> > inadvertently broke the sh conversion:
> > 
> > 	arch/sh/kernel/time.c:45: error: passing argument 1 of 'rtc_sh_get_time' from incompatible pointer type
> > 	distcc[13470] ERROR: compile arch/sh/kernel/time.c on sprygo/32 failed
> > 	make[2]: *** [arch/sh/kernel/time.o] Error 1
> > 
> > This trivial fix gets it working again.
> > 
> > Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> > Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > 
> > ---
> > 
> >  arch/sh/kernel/time.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> applied, thanks Paul!
> 
> I'm wondering, why did my cross-build of the SH defconfig in the 
> timer tree not catch this? All i get (and got) are these warnings:
> 
> /home/mingo/tip/arch/sh/kernel/cpu/clock-cpg.c: In function 'cpg_clk_init':
> /home/mingo/tip/arch/sh/kernel/cpu/clock-cpg.c:242: warning: 'arch_init_clk_ops' is deprecated (declared at /home/mingo/tip/arch/sh/include/asm/clock.h:58)
> /home/mingo/tip/arch/sh/kernel/cpu/clock-cpg.c: In function 'arch_clk_init':
> /home/mingo/tip/arch/sh/kernel/cpu/clock-cpg.c:256: warning: 'cpg_clk_init' is deprecated (declared at /home/mingo/tip/arch/sh/kernel/cpu/clock-cpg.c:237)
> 
> and time.o built without errors or warnings:
> 
>   CC      arch/sh/kernel/time.o
> 
That would be because read_persistent_clock() is only used conditionally
on SH, the defconfig itself does not make use of it, while the dreamcast
and sh03 defconfigs do. SH has a lot of variation across its defconfigs,
so it's pretty difficult to catch everything, this is largely what we
rely on randconfigs and allmod/yes/noconfigs for, which are all part of
the regular daily builds, in addition to the 50 or so other configs.

The defconfig itself is aimed at covering the common cases. Config
options that people will generally have enabled, and are likely to run in
to issues with. Anything else we just have to fix up incrementally and
hope that daily builds/regression testing catches the rest.

ARM suffers from the same problem in that it's really impossible to get
decent coverage in a single config.
