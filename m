Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbZCXVS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbZCXVS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754360AbZCXVQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:16:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:60235 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196AbZCXVQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:16:15 -0400
Date: Tue, 24 Mar 2009 21:15:31 GMT
From: Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, rusty@rustcorp.com.au, ebiederm@xmission.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, rusty@rustcorp.com.au, ebiederm@xmission.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49C94134.4000408@kernel.org>
References: <49C94134.4000408@kernel.org>
Subject: [tip:x86/apic] x86: fix set_extra_move_desc calling
Message-ID: <tip-fa74c9073370e57fa28e02aff13f4d7b1806505c@git.kernel.org>
Git-Commit-ID: fa74c9073370e57fa28e02aff13f4d7b1806505c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Mar 2009 21:15:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa74c9073370e57fa28e02aff13f4d7b1806505c
Gitweb:     http://git.kernel.org/tip/fa74c9073370e57fa28e02aff13f4d7b1806505c
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Tue, 24 Mar 2009 13:23:16 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 Mar 2009 22:12:10 +0100

x86: fix set_extra_move_desc calling

Impact: fix bug with irq-descriptor moving when logical flat

Rusty observed:

> The effect of setting desc->affinity (ie. from userspace via sysfs) has varied
> over time.  In 2.6.27, the 32-bit code anded the value with cpu_online_map,
> and both 32 and 64-bit did that anding whenever a cpu was unplugged.
>
> 2.6.29 consolidated this into one routine (and fixed hotplug) but introduced
> another variation: anding the affinity with cfg->domain.  Is this right, or
> should we just set it to what the user said?  Or as now, indicate that we're
> restricting it.

Eric pointed out that desc->affinity should be what the user requested,
if it is at all possible to honor the user space request.

This bug got introduced by commit 22f65d31b "x86: Update io_apic.c to use
new cpumask API".

Fix it by moving the masking to before the descriptor moving ...

Reported-by: Rusty Russell <rusty@rustcorp.com.au>
Reported-by: Eric W. Biederman <ebiederm@xmission.com>
LKML-Reference: <49C94134.4000408@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/io_apic.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 86827d8..1ed6c06 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -592,8 +592,9 @@ set_desc_affinity(struct irq_desc *desc, const struct cpumask *mask)
 	if (assign_irq_vector(irq, cfg, mask))
 		return BAD_APICID;
 
-	cpumask_and(desc->affinity, cfg->domain, mask);
+	/* check that before desc->addinity get updated */
 	set_extra_move_desc(desc, mask);
+	cpumask_and(desc->affinity, cfg->domain, mask);
 
 	return apic->cpu_mask_to_apicid_and(desc->affinity, cpu_online_mask);
 }
