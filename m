Return-Path: <linux-kernel-owner+w=401wt.eu-S1752855Ab0AKV3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab0AKV3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:29:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366Ab0AKV1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:27:38 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:35385 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab0AKV1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:27:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=VVpCL1SiM8KKTHVKGTYcO1NlQuTFHWd9uBX+dZcT9BewNxVfjuOC5hgUFgfDP2iC8w
         QnP16nwM+I0PjBzzRkgvBiyNqbTpftbyxUewPwi5yHiHARVo78i/v947yDy28mAub2J/
         jHxopT/BjGUa9ISFusTbY4L/pS2Fol+ChxF88=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 18/26] x86 - nmi: Convert nmi_lock to raw_spinlock
Date: Mon, 11 Jan 2010 22:26:48 +0100
Message-Id: <1263245216-14754-19-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263245216-14754-18-git-send-email-jkacur@redhat.com>
References: <1263245216-14754-1-git-send-email-jkacur@redhat.com>
 <1263245216-14754-2-git-send-email-jkacur@redhat.com>
 <1263245216-14754-3-git-send-email-jkacur@redhat.com>
 <1263245216-14754-4-git-send-email-jkacur@redhat.com>
 <1263245216-14754-5-git-send-email-jkacur@redhat.com>
 <1263245216-14754-6-git-send-email-jkacur@redhat.com>
 <1263245216-14754-7-git-send-email-jkacur@redhat.com>
 <1263245216-14754-8-git-send-email-jkacur@redhat.com>
 <1263245216-14754-9-git-send-email-jkacur@redhat.com>
 <1263245216-14754-10-git-send-email-jkacur@redhat.com>
 <1263245216-14754-11-git-send-email-jkacur@redhat.com>
 <1263245216-14754-12-git-send-email-jkacur@redhat.com>
 <1263245216-14754-13-git-send-email-jkacur@redhat.com>
 <1263245216-14754-14-git-send-email-jkacur@redhat.com>
 <1263245216-14754-15-git-send-email-jkacur@redhat.com>
 <1263245216-14754-16-git-send-email-jkacur@redhat.com>
 <1263245216-14754-17-git-send-email-jkacur@redhat.com>
 <1263245216-14754-18-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert locks that cannot sleep in preempt-rt to raw_spinlocks

See also: a76dd8f3ffcbb1bb446a9ca059b77f40fe100bf1

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 arch/x86/kernel/apic/nmi.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index 0159a69..51bc6a6 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -416,13 +416,13 @@ nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 
 	/* We can be called before check_nmi_watchdog, hence NULL check. */
 	if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
-		static DEFINE_SPINLOCK(lock);	/* Serialise the printks */
+		static DEFINE_RAW_SPINLOCK(lock);	/* Serialise the printks */
 
-		spin_lock(&lock);
+		raw_spin_lock(&lock);
 		printk(KERN_WARNING "NMI backtrace for cpu %d\n", cpu);
 		show_regs(regs);
 		dump_stack();
-		spin_unlock(&lock);
+		raw_spin_unlock(&lock);
 		cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
 
 		rc = 1;
-- 
1.6.5.2

