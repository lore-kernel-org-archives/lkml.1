Return-Path: <linux-kernel-owner+w=401wt.eu-S1761163AbZCYRzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761163AbZCYRzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755113AbZCYRzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:55:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:51471 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbZCYRzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:55:03 -0400
Date: Wed, 25 Mar 2009 17:51:28 GMT
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, rusty@rustcorp.com.au, ebiederm@xmission.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, rusty@rustcorp.com.au, ebiederm@xmission.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49C94DDF.2010703@kernel.org>
References: <49C94DDF.2010703@kernel.org>
Subject: [tip:x86/apic] x86: Correct behaviour of irq affinity
Message-ID: <tip-e06b1b56f9bfcc91e1f175fe8d8bf3e35dafa080@git.kernel.org>
Git-Commit-ID: e06b1b56f9bfcc91e1f175fe8d8bf3e35dafa080
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 17:51:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e06b1b56f9bfcc91e1f175fe8d8bf3e35dafa080
Gitweb:     http://git.kernel.org/tip/e06b1b56f9bfcc91e1f175fe8d8bf3e35dafa080
Author:     Rusty Russell <rusty@rustcorp.com.au>
AuthorDate: Tue, 24 Mar 2009 14:17:19 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Mar 2009 18:48:29 +0100

x86: Correct behaviour of irq affinity

Impact: get correct smp_affinity as user requested

The effect of setting desc->affinity (ie. from userspace via sysfs) has
varied over time.  In 2.6.27, the 32-bit code anded the value with
cpu_online_map, and both 32 and 64-bit did that anding whenever a cpu
was unplugged.

2.6.29 consolidated this into one routine (and fixed hotplug) but
introduced another variation: anding the affinity with cfg->domain.

We should just set it to what the user said - if possible.

(cpu_mask_to_apicid_and already takes cpu_online_mask into account)

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <49C94DDF.2010703@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/io_apic.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 1ed6c06..d990408 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -594,9 +594,10 @@ set_desc_affinity(struct irq_desc *desc, const struct cpumask *mask)
 
 	/* check that before desc->addinity get updated */
 	set_extra_move_desc(desc, mask);
-	cpumask_and(desc->affinity, cfg->domain, mask);
 
-	return apic->cpu_mask_to_apicid_and(desc->affinity, cpu_online_mask);
+	cpumask_copy(desc->affinity, mask);
+
+	return apic->cpu_mask_to_apicid_and(desc->affinity, cfg->domain);
 }
 
 static void
