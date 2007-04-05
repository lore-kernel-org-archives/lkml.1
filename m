Return-Path: <linux-kernel-owner+w=401wt.eu-S1766991AbXDEOBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766991AbXDEOBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 10:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766992AbXDEOBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 10:01:39 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:16290 "EHLO
	outbound5-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766991AbXDEOBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 10:01:38 -0400
X-BigFish: VP
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Thu, 5 Apr 2007 16:00:45 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: linux-kernel@vger.kernel.org, "Andi Kleen" <ak@suse.de>
Subject: [PATCH] x86: limit mwait_idle to Intel CPUs
Message-ID: <20070405140045.GN6356@alberich.amd.com>
MIME-Version: 1.0
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 05 Apr 2007 14:00:40.0875 (UTC)
 FILETIME=[CB9F37B0:01C7778A]
X-WSS-ID: 6A0BDEB22EW3252065-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Commit 991528d7348667924176f3e29addea0675298944
introduced mwait_idle which is supposed to work
for Intel CPUs starting with Core Duo.

AMD Fam10 processors won't enter C1 on mwait.
This patch will enable default_idle for non-Intel
CPUs even if mwait is supported.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/i386/kernel/process.c   |    4 +++-
 arch/x86_64/kernel/process.c |    3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/i386/kernel/process.c b/arch/i386/kernel/process.c
index 393a67d..e3067e4 100644
--- a/arch/i386/kernel/process.c
+++ b/arch/i386/kernel/process.c
@@ -259,7 +259,9 @@ static void mwait_idle(void)
 
 void __devinit select_idle_routine(const struct cpuinfo_x86 *c)
 {
-	if (cpu_has(c, X86_FEATURE_MWAIT)) {
+	if (cpu_has(c, X86_FEATURE_MWAIT) &&
+	    (c->x86_vendor == X86_VENDOR_INTEL)) {
+
 		printk("monitor/mwait feature present.\n");
 		/*
 		 * Skip, if setup has overridden idle.
diff --git a/arch/x86_64/kernel/process.c b/arch/x86_64/kernel/process.c
index d8d5ccc..fed830c 100644
--- a/arch/x86_64/kernel/process.c
+++ b/arch/x86_64/kernel/process.c
@@ -271,7 +271,8 @@ static void mwait_idle(void)
 void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 {
 	static int printed;
-	if (cpu_has(c, X86_FEATURE_MWAIT)) {
+	if (cpu_has(c, X86_FEATURE_MWAIT) &&
+	    (c->x86_vendor == X86_VENDOR_INTEL)) {
 		/*
 		 * Skip, if setup has overridden idle.
 		 * One CPU supports mwait => All CPUs supports mwait
-- 
1.5.0.6




