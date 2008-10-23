Return-Path: <linux-kernel-owner+w=401wt.eu-S1753236AbYJWOVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbYJWOVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 10:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbYJWOUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 10:20:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50045 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbYJWOUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 10:20:53 -0400
Date: Thu, 23 Oct 2008 16:20:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [bug #2] Re: [PATCH 00/35] cpumask: Replace cpumask_t with struct
	cpumask
Message-ID: <20081023142025.GA18804@elte.hu>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com> <20081023120322.GC25132@elte.hu> <20081023125529.GA18327@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023125529.GA18327@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thomas has started a -tip cross-build test, and there's massive 
cross-build failures as well due to the cpumask changes:

  http://www.tglx.de/autoqa-cgi/index?run=140&tree=8

   Run 140: 11 of 19 OK

8 architecture configs out of 19 fail to build, 7 of which failures is 
this patchset's fault:

powerpc, ps3_defconfig:

  http://www.tglx.de/autoqa-logs/000140-0008-0006.log
  
  /home/tglx/work/kernel/autoqa/linux-2.6-tip/
  arch/powerpc/platforms/cell/spu_base.c:117:
  error: implicit declaration of function '__cpus_setall'

m32r defconfig:

  http://www.tglx.de/autoqa-logs/000140-0008-0013.log

  from /home/tglx/work/kernel/autoqa/linux-2.6-tip/arch/m32r/kernel/smp.c:18:
  include2/asm/smp.h:66: error: expected ')' before '*' token
  include2/asm/smp.h:66: error: expected ')' before 'cpu_possible_mask'
  include2/asm/smp.h:67: error: expected ')' before '*' token
  include2/asm/smp.h:67: error: expected ')' before 'cpu_present_mask'

xtensa defconfig:

  from /home/tglx/work/kernel/autoqa/linux-2.6-tip/arch/xtensa/k
  ernel/asm-offsets.c:20:
  /home/tglx/work/kernel/autoqa/linux-2.6-tip/include/linux/cpumask.h:109: 
  error:
   'CONFIG_NR_CPUS' undeclared here (not in a function)

powerpc mpc5200_defconfig:

  http://www.tglx.de/autoqa-logs/000140-0008-0014.log

  kernel/asm-offsets.c:22:
  /home/tglx/work/kernel/autoqa/linux-2.6-tip/include/linux/mm.h:922:5: 
  warning: "CONFIG_NR_CPUS" is not defined
  make[2]: *** [arch/powerpc/kernel/asm-offsets.s] Error 1
  make[1]: *** [prepare0] Error 2

sparc32 defconfig:

  http://www.tglx.de/autoqa-logs/000140-0008-0020.log

  /home/tglx/work/kernel/autoqa/linux-2.6-tip/arch/sparc/kernel/asm-offsets.c:13:
  /home/tglx/work/kernel/autoqa/linux-2.6-tip/include/linux/cpumask.h:109: 
  error: 'CONFIG_NR_CPUS' undeclared here (not in a function)

powerpc ppc64_defconfig:

   http://www.tglx.de/autoqa-logs/000140-0008-0022.log

   /home/tglx/work/kernel/autoqa/linux-2.6-tip/arch/powerpc/platforms/cell/spu_bas
    e.c:117: error: implicit declaration of function '__cpus_setall'
   make[3]: *** [arch/powerpc/platforms/cell/spu_base.o] Error 1

s390 defconfig:

   http://www.tglx.de/autoqa-logs/000140-0008-0025.log

  /home/tglx/work/kernel/autoqa/linux-2.6-tip/arch/s390/kernel/smp.c: In 
  function '__smp_call_function_map':
  /home/tglx/work/kernel/autoqa/linux-2.6-tip/arch/s390/kernel/smp.c:120: 
  error: request for member 'bits' in something not a structure or union

it seems to me that this commit is massively borked:

  4a792c2: cpumask: make CONFIG_NR_CPUS always valid

but some of the others seems to be suspect as well - there's at least 3 
different failure patterns.

	Ingo
