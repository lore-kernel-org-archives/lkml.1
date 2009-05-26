Return-Path: <linux-kernel-owner+w=401wt.eu-S1759905AbZEZXTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759905AbZEZXTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758857AbZEZXSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:18:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53149 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758978AbZEZXSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:18:30 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 01/17] x86: MCE: Initial steps to make 64bit mce code 32bit clean
Date: Wed, 27 May 2009 01:18:00 +0200
Message-Id: <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1243379896-26869-1-git-send-email-andi@firstfloor.org>
References: <1243379896-26869-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Replace unsigned long with u64s if they need to contain 64bit values.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 868c6a2..08ffe55 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -156,15 +156,15 @@ static void print_mce(struct mce *m)
 	       "and contact your hardware vendor\n");
 }
 
-static void mce_panic(char *msg, struct mce *backup, unsigned long start)
+static void mce_panic(char *msg, struct mce *backup, u64 start)
 {
 	int i;
 
 	oops_begin();
 	for (i = 0; i < MCE_LOG_LEN; i++) {
-		unsigned long tsc = mcelog.entry[i].tsc;
+		u64 tsc = mcelog.entry[i].tsc;
 
-		if (time_before(tsc, start))
+		if ((s64)(tsc - start) < 0)
 			continue;
 		print_mce(&mcelog.entry[i]);
 		if (backup && mcelog.entry[i].tsc == backup->tsc)
@@ -971,13 +971,13 @@ void (*threshold_cpu_callback)(unsigned long action, unsigned int cpu);
 	static ssize_t show_ ## name(struct sys_device *s,		\
 				     struct sysdev_attribute *attr,	\
 				     char *buf) {			\
-		return sprintf(buf, "%lx\n", (unsigned long)var);	\
+		return sprintf(buf, "%Lx\n", (u64)var);			\
 	}								\
 	static ssize_t set_ ## name(struct sys_device *s,		\
 				    struct sysdev_attribute *attr,	\
 				    const char *buf, size_t siz) {	\
 		char *end;						\
-		unsigned long new = simple_strtoul(buf, &end, 0);	\
+		u64 new = simple_strtoull(buf, &end, 0);		\
 									\
 		if (end == buf)						\
 			return -EINVAL;					\
-- 
1.6.0.2

