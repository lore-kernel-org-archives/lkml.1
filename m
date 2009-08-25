Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbZHYHHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbZHYHHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 03:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbZHYHHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 03:07:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53806 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858AbZHYHHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 03:07:40 -0400
Date: Tue, 25 Aug 2009 09:07:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mundt <lethal@linux-sh.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] timekeeping: Fix up read_persistent_clock()
	breakage on sh.
Message-ID: <20090825070731.GD14286@elte.hu>
References: <20090824223239.GB20832@linux-sh.org> <20090825064458.GC14286@elte.hu> <20090825065212.GA31462@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825065212.GA31462@linux-sh.org>
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


* Paul Mundt <lethal@linux-sh.org> wrote:

> On Tue, Aug 25, 2009 at 08:44:58AM +0200, Ingo Molnar wrote:
> > 
> > * Paul Mundt <lethal@linux-sh.org> wrote:
> > 
> > > The recent commit "timekeeping: Increase granularity of
> > > read_persistent_clock()" introduced read_persistent_clock() rework which
> > > inadvertently broke the sh conversion:
> > > 
> > > 	arch/sh/kernel/time.c:45: error: passing argument 1 of 'rtc_sh_get_time' from incompatible pointer type
> > > 	distcc[13470] ERROR: compile arch/sh/kernel/time.c on sprygo/32 failed
> > > 	make[2]: *** [arch/sh/kernel/time.o] Error 1
> > > 
> > > This trivial fix gets it working again.
> > > 
> > > Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> > > Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > > Cc: Ingo Molnar <mingo@elte.hu>
> > > 
> > > ---
> > > 
> > >  arch/sh/kernel/time.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > applied, thanks Paul!
> > 
> > I'm wondering, why did my cross-build of the SH defconfig in the 
> > timer tree not catch this? All i get (and got) are these warnings:
> > 
> > /home/mingo/tip/arch/sh/kernel/cpu/clock-cpg.c: In function 'cpg_clk_init':
> > /home/mingo/tip/arch/sh/kernel/cpu/clock-cpg.c:242: warning: 'arch_init_clk_ops' is deprecated (declared at /home/mingo/tip/arch/sh/include/asm/clock.h:58)
> > /home/mingo/tip/arch/sh/kernel/cpu/clock-cpg.c: In function 'arch_clk_init':
> > /home/mingo/tip/arch/sh/kernel/cpu/clock-cpg.c:256: warning: 'cpg_clk_init' is deprecated (declared at /home/mingo/tip/arch/sh/kernel/cpu/clock-cpg.c:237)
> > 
> > and time.o built without errors or warnings:
> > 
> >   CC      arch/sh/kernel/time.o
> 
> That would be because read_persistent_clock() is only used 
> conditionally on SH, the defconfig itself does not make use of it, 
> while the dreamcast and sh03 defconfigs do. SH has a lot of 
> variation across its defconfigs, so it's pretty difficult to catch 
> everything, this is largely what we rely on randconfigs and 
> allmod/yes/noconfigs for, which are all part of the regular daily 
> builds, in addition to the 50 or so other configs.
> 
> The defconfig itself is aimed at covering the common cases. Config 
> options that people will generally have enabled, and are likely to 
> run in to issues with. Anything else we just have to fix up 
> incrementally and hope that daily builds/regression testing 
> catches the rest.
> 
> ARM suffers from the same problem in that it's really impossible 
> to get decent coverage in a single config.

Yeah - x86 is really similar as well.

So the general policy we typically follow is to expect this from 
developers:

 - test the patch on their own favorite config[s] they actually use, 
   on the architecture[s] they care about personally.

 - do and send clean patches, use git grep, etc.

And then we couple that with fast patch and fix propagation pathways 
into integration trees, which then do stronger testing.

It would be a mistake to expect all kernel developers that submit 
patches to build all the 300+ defconfigs that are in the upstream 
kernel currently (!) - in fact it's a waste of resources to expect 
them to 'always' build configs they dont actually use. (They dont 
have the hardware to do such testing and they dont have the time and 
interest to do such testing.)

And, since Linux changes/adds/removes ~1 million lines of code in 
every development cycle, we should expect breakages and should 
handle them quickly - not put pressure on developers to find bugs 
they have no chance to trigger realistically.

Lets face it, the 22 Linux architectures we have are an exponential 
testing nightmare. There's not even a common set of cross-compilers 
from-x86-to-arch for people to use, one has to build it from source 
one by one, and (here i speak from experience) GCC rarely builds 
cross-compilers out of box without some kind of build/bootstrap 
trouble. There's architectures where neither gcc-trunk, 4.4, 4.3, 
4.2 nor 4.1 builds a cross-compiler correctly - only some old 3.x 
compiler works.

(And even if we had correctly packaged, readily available 
cross-compilers for x86, it would still slow down the testing of 
patches 20-fold.)

	Ingo
