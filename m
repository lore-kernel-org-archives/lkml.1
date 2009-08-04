Return-Path: <linux-kernel-owner+w=401wt.eu-S932901AbZHDPdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901AbZHDPdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 11:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932890AbZHDPdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 11:33:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:40009 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932856AbZHDPdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 11:33:11 -0400
Date: Tue, 4 Aug 2009 15:32:28 GMT
From: tip-bot for Jack Steiner <steiner@sgi.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090720142840.GA8885@sgi.com>
References: <20090720142840.GA8885@sgi.com>
Subject: [tip:x86/urgent] x86, UV: Complete IRQ interrupt migration in arch_enable_uv_irq()
Message-ID: <tip-2a5ef41661b56cf4eee042a6967c4e14b63e8eac@git.kernel.org>
Git-Commit-ID: 2a5ef41661b56cf4eee042a6967c4e14b63e8eac
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 04 Aug 2009 15:32:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2a5ef41661b56cf4eee042a6967c4e14b63e8eac
Gitweb:     http://git.kernel.org/tip/2a5ef41661b56cf4eee042a6967c4e14b63e8eac
Author:     Jack Steiner <steiner@sgi.com>
AuthorDate: Mon, 20 Jul 2009 09:28:41 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 4 Aug 2009 16:32:52 +0200

x86, UV: Complete IRQ interrupt migration in arch_enable_uv_irq()

In uv_setup_irq(), the call to create_irq() initially assigns
IRQ vectors to cpu 0. The subsequent call to
assign_irq_vector() in arch_enable_uv_irq() migrates the IRQ to
another cpu and frees the cpu 0 vector - at least it will be
freed as soon as the "IRQ move" completes.

arch_enable_uv_irq() needs to send a cleanup IPI to complete
the IRQ move. Otherwise, assignment of GRU interrupts on large
systems (>200 cpus) will exhaust the cpu 0 interrupt vectors
and initialization of the GRU driver will fail.

Signed-off-by: Jack Steiner <steiner@sgi.com>
LKML-Reference: <20090720142840.GA8885@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/io_apic.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 2284a48..d2ed6c5 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3793,6 +3793,9 @@ int arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
 	mmr_pnode = uv_blade_to_pnode(mmr_blade);
 	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
 
+	if (cfg->move_in_progress)
+		send_cleanup_vector(cfg);
+
 	return irq;
 }
 
