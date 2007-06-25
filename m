Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702AbXFYV4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbXFYV4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 17:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbXFYV4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 17:56:05 -0400
Received: from dsl.myri.com ([64.172.73.26]:1931 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751152AbXFYV4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 17:56:04 -0400
X-Greylist: delayed 1010 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Jun 2007 17:56:04 EDT
Message-ID: <468035BC.9080008@myri.com>
Date: Mon, 25 Jun 2007 17:38:04 -0400
From: Loic Prylli <loic@myri.com>
User-Agent: Thunderbird/2.0.0.4 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] MTRR: Fix race causing set_mtrr to go into infinite loop
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Processors synchronization in set_mtrr requires the .gate field
to be set after .count field is properly initialized. Without an explicit
barrier, the compiler was reordering those memory stores. That was sometimes
causing a processor (in ipi_handler) to see the .gate change and
decrement .count before the latter is set by set_mtrr() (which
then hangs in a infinite loop with irqs disabled).

Signed-off-by: Loic Prylli <loic@myri.com>
---
 arch/i386/kernel/cpu/mtrr/main.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/i386/kernel/cpu/mtrr/main.c b/arch/i386/kernel/cpu/mtrr/main.c
index 55b0051..75dc6d5 100644
--- a/arch/i386/kernel/cpu/mtrr/main.c
+++ b/arch/i386/kernel/cpu/mtrr/main.c
@@ -229,6 +229,8 @@ static void set_mtrr(unsigned int reg, unsigned long base,
 	data.smp_size = size;
 	data.smp_type = type;
 	atomic_set(&data.count, num_booting_cpus() - 1);
+	/* make sure data.count is visible before unleashing other CPUs */
+	smp_wmb();
 	atomic_set(&data.gate,0);
 
 	/*  Start the ball rolling on other CPUs  */
@@ -242,6 +244,7 @@ static void set_mtrr(unsigned int reg, unsigned long base,
 
 	/* ok, reset count and toggle gate */
 	atomic_set(&data.count, num_booting_cpus() - 1);
+	smp_wmb();
 	atomic_set(&data.gate,1);
 
 	/* do our MTRR business */
@@ -260,6 +263,7 @@ static void set_mtrr(unsigned int reg, unsigned long base,
 		cpu_relax();
 
 	atomic_set(&data.count, num_booting_cpus() - 1);
+	smp_wmb();
 	atomic_set(&data.gate,0);
 
 	/*
-- 1.5.2.2 

