Return-Path: <linux-kernel-owner+w=401wt.eu-S1763486AbZAHWyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763486AbZAHWyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 17:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754333AbZAHWyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 17:54:09 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:38815 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbZAHWyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 17:54:08 -0500
Message-ID: <496683D0.6000509@caviumnetworks.com>
Date: Thu, 08 Jan 2009 14:53:04 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mike Travis <travis@sgi.com>, linux-mips <linux-mips@linux-mips.org>
Subject: [PATCH 0/2] cpumask fallout: Initialize irq_default_affinity earlier
 et al.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jan 2009 22:53:04.0638 (UTC) FILETIME=[DD9DA1E0:01C971E3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As I said in 2/2:

    Move the initialization of irq_default_affinity to early_irq_init
    as core_initcall is too late.

    irq_default_affinity can be used in init_IRQ and potentially timer
    and SMP init as well.  All of these happen before core_initcall.
    Moving the initialization to early_irq_init ensures that it is
    initialized before it is used.

Mike Travis pointed out that irq_default_affinity depends on
CONFIG_GENERIC_HARDIRQS in addition to CONFIG_SMP.  So to make things
consistent, I added 1/2 so that the irq_*_affinity functions and
irq_default_affinity are defined for the same conditions that they are
declared.

I Took Linus' suggestion to move init_irq_default_affinity over to
kernel/irq/handle.c, however due to the way that cpumask_*() are
defined, it is still necessary to have the ugly ifdefs, but now they
are localized to init_irq_default_affinity.

Mike Travis also suggested that alloc_bootmem_cpumask_var() be used in
preference to alloc_cpumask_var, so I incorporated that suggestion as
well.

I tested both with and without CONFIG_SMP, on mips/cavium_octeon, Mike
tested a similar(but not identical patch) on x86_64.

I will reply with the two patches.

David Daney (2):
  Make irq_*_affinity depend on CONFIG_GENERIC_HARDIRQS too.
  cpumask fallout: Initialize irq_default_affinity earlier (v2).

 kernel/irq/handle.c |   12 ++++++++++++
 kernel/irq/manage.c |   10 +---------
 2 files changed, 13 insertions(+), 9 deletions(-)

