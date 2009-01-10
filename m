Return-Path: <linux-kernel-owner+w=401wt.eu-S1756478AbZAJWiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478AbZAJWiz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 17:38:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754057AbZAJWid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 17:38:33 -0500
Received: from relay3.sgi.com ([192.48.171.31]:60578 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753999AbZAJWic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 17:38:32 -0500
Message-Id: <20090110223818.459493000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 10 Jan 2009 14:38:18 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Yinghai Lu <yinghai@kernel.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] irq: change irq_desc and kstat_irq_legacy to variable sized arrays
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patches change irq_desc and kstat_irq_legacy into
variable sized arrays based on nr_cpu_ids when CONFIG_SPARSE_IRQS=y.

    irq: change references from NR_IRQS to nr_irqs
    irq: allocate irq_desc_ptrs array based on nr_irqs
    irq: initialize nr_irqs based on nr_cpu_ids
    kstat: modify kstat_irqs_legacy to be variable sized

Based on: tip/cpus4096 @ v2.6.28-6140-g36c401a

(Ingo - I will push these to your tip/cpus4096 branch via my cpus4096-for-ingo
	git tree.)

Signed-off-by: Mike Travis <travis@sgi.com>
---

Affects of the SPARSE changes on NR_CPUS values.

    1 - 128-defconfig (non-SPARSE)
    2 - 4k-defconfig (non-SPARSE)
    3 - 4k-defconfig (SPARSE)

====== Data

      .1.        .2.        .3.    ..final..
  1114112          .   -1114112      .  -100%  irq_desc(.data.cacheline_aligned)
   208896     -69632    -138752    512   -99%  irq_cfgx(.data)
    34816          .     -34816      .  -100%  irq_timer_state(.bss)
    17480          .     -17480      .  -100%  per_cpu__kstat(.data.percpu)
        0          .      +4096   4096      .  irq_desc_legacy(.data.cacheline_aligned)

====== Sections

        .1.       .2.        .3.    ..final..
    1140032   +459264   -1110016      489280   -57%  .data.cacheline_aligned
      34408     +6768        +16       41192   +19%  .data.read_mostly

====== PerCPU () 

      .1.     .2.      .3.    ..final..
    18432   -2048   -16384         .  -100%  kstat
    10240       .    -2048      8192   -20%  init_tss

====== MemInfo () 

Static memory available at boot time:

             .1.           .2.         .3.    ..final..
      8069795840     -10207232   +10575872    8070164480(+368640) MemFree
      8263630848      -9310208   +10260480    8264581120(+950272) MemTotal

-- 
