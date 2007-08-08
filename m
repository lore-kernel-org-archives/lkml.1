Return-Path: <linux-kernel-owner+w=401wt.eu-S1762825AbXHHWPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762825AbXHHWPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 18:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbXHHWPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 18:15:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44631 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753845AbXHHWPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 18:15:35 -0400
Date: Wed, 8 Aug 2007 15:14:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: kvm warning
Message-Id: <20070808151446.9a4eebda.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ia64 allmodconfig says

drivers/kvm/Kconfig:14:warning: 'select' used by config symbol 'KVM' refers to undefined symbol 'PREEMPT_NOTIFIERS'

Because of

commit 8928fb48c7a7f9053a55f1d0023cbc533f2b3663
Author: Avi Kivity <avi@qumranet.com>
Date:   Wed Jul 11 18:17:21 2007 +0300

    KVM: Use the scheduler preemption notifiers to make kvm preemptible
    
    Current kvm disables preemption while the new virtualization registers are
    in use.  This of course is not very good for latency sensitive workloads (on
    use of virtualization is to offload user interface and other latency
    insensitive stuff to a container, so that it is easier to analyze the
    remaining workload).  This patch re-enables preemption for kvm; preemption
    is now only disabled when switching the registers in and out, and during
    the switch to guest mode and back.
    
    Contains fixes from Shaohua Li <shaohua.li@intel.com>.
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

--- a/drivers/kvm/Kconfig
+++ b/drivers/kvm/Kconfig
@@ -11,6 +11,7 @@ if VIRTUALIZATION
 config KVM
        tristate "Kernel-based Virtual Machine (KVM) support"
        depends on X86 && EXPERIMENTAL
+       select PREEMPT_NOTIFIERS
        select ANON_INODES
        ---help---
          Support hosting fully virtualized guest machines using hardware
...


a) is kvm supported on ia64 at all??

b) `select' is evil.  Just Don't Do It.

c) `select' is especially evil when it's done on some kernel-internal
   secret symbol like PREEMPT_NOTIFIERS.

d) I can't see anything else in the kernel which sets or clears
   PREEMPT_NOTIFIERS so I'm rather wonderring why the config option exists
   at all.

e) sched developers may not like KVM reaching over and twiddling their
   knobs for them.


It all needs more thought, I think...

