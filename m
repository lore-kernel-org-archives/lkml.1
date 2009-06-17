Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbZFQV0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbZFQV0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 17:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbZFQV0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 17:26:44 -0400
Received: from ishtar.tlinx.org ([64.81.245.74]:40629 "EHLO Ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444AbZFQV0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 17:26:43 -0400
Message-ID: <4A395F80.7060504@tlinx.org>
Date: Wed, 17 Jun 2009 14:26:24 -0700
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: non-standard config in my running distro Default kernel: Effect?
X-Stationery: 0.4.9
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I found what appears to be a "non-standard configuration" in a
distro's "Default-SMP", non-Xen kernel, where /proc/config.gz
from the running kernel has (I only ran into this doing a diff between
a manually constructed config and my running kernel):

    CONFIG_X86_SMP=y
    CONFIG_X86_64_SMP=y

But does NOT have:

    CONFIG_USE_GENERIC_SMP_HELPERS=y

 From what I can tell, this shouldn't be a possible configuration, since
CONFIG_X86_SMP should force it to be set to 'y' (not unset).

Would this config, (SMP='y', generic_smp_helpers=(undef) ) have any
odd effects?  Is there a specific "effect" or "feature" one gets
by having 'smp=y' but not having the smp_helpers enabled?

In my x86_64 arch, the places I see it tested are:

block/blk-softirq.c:
    #if defined(CONFIG_SMP) && defined(CONFIG_USE_GENERIC_SMP_HELPERS)
    #else /* CONFIG_SMP && CONFIG_USE_GENERIC_SMP_HELPERS */
block/blk-sysfs.c:
    #if defined(CONFIG_USE_GENERIC_SMP_HELPERS)
include/linux/smp.h:
    #ifdef CONFIG_USE_GENERIC_SMP_HELPERS
/kernel/Kconfig.hz:
    def_bool HIGH_RES_TIMERS && (!SMP || USE_GENERIC_SMP_HELPERS)
kernel/softirq.c:
    #ifdef CONFIG_USE_GENERIC_SMP_HELPERS
    #else /* CONFIG_USE_GENERIC_SMP_HELPERS */

---
It appears it may disable some softirq routines.

In include/linux/smp.h, having it undefined would disable the definition 
of the functions:
  generic_smp_call_function_single_interrupt,
  generic_smp_call_function_interrupt,
  ipi_call_lock,      ipi_call_unlock,
  ipi_call_lock_irq & ipi_call_unlock_irq

Does this have any performance or integrity (lost interrupt)
implications?











