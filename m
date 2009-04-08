Return-Path: <linux-kernel-owner+w=401wt.eu-S1764069AbZDHMzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764069AbZDHMzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756919AbZDHMze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:55:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37690 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753698AbZDHMzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:55:33 -0400
Date: Wed, 8 Apr 2009 14:54:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 2/2] irq: only update affinity in chip set_affinity()
Message-ID: <20090408125415.GJ18581@elte.hu>
References: <49D68FBC.7010602@kernel.org> <49D6900B.2020107@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D6900B.2020107@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> Impact: keep affinity consistent
> 
> irq_set_affinity() and move_masked_irq() try to assign affinity 
> before calling chip set_affinity(). some archs are assigning again 
> in set_affinity again.
> 
> something like:
> cpumask_cpy(desc->affinity, mask);
> desc->chip->set_affinity(mask);
> 
> in the failing path, affinity should not be touched.
> 
> also set_extra_move_desc() ( called by set_affinity) will rely on 
> the old affinity to decide if need to move irq_desc to different 
> node when logical flat apic mode is used.
> 
> So try remove those assignment, and make some missed arch to 
> assign affinity in their set_affinity.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> --
>  arch/alpha/kernel/sys_dp264.c         |    6 ++++--
>  arch/alpha/kernel/sys_titan.c         |    3 ++-
>  arch/arm/common/gic.c                 |    1 +
>  arch/cris/arch-v32/kernel/irq.c       |    1 +
>  arch/ia64/kernel/iosapic.c            |    3 +++
>  arch/ia64/sn/kernel/irq.c             |    3 +++
>  arch/mips/cavium-octeon/octeon-irq.c  |    6 ++++++
>  arch/mips/sibyte/bcm1480/irq.c        |    2 ++
>  arch/mips/sibyte/sb1250/irq.c         |    2 ++
>  arch/powerpc/platforms/pseries/xics.c |    5 +++++
>  arch/powerpc/sysdev/mpic.c            |    2 ++
>  arch/sparc/kernel/irq_64.c            |    7 +++++++
>  drivers/xen/events.c                  |    2 ++
>  kernel/irq/manage.c                   |    6 ++----
>  kernel/irq/migration.c                |    8 +++-----
>  15 files changed, 45 insertions(+), 12 deletions(-)

Hm, this spreads a lot of instances of identical lines:

   cpumask_copy(irq_desc[irq].affinity, mask_val);

all around architectures. How is that an improvement?

	Ingo
