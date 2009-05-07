Return-Path: <linux-kernel-owner+w=401wt.eu-S1762378AbZEGJc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762378AbZEGJc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762047AbZEGJ0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:26:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:45174 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762049AbZEGJ0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:26:24 -0400
Date: Thu, 7 May 2009 09:25:47 GMT
From: tip-bot for Markus Metzger <markus.t.metzger@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090424094309.A30145@sedona.ch.intel.com>
References: <20090424094309.A30145@sedona.ch.intel.com>
Subject: [tip:tracing/core] x86, ds: fix buffer alignment in debug store selftest
Message-ID: <tip-782cc5ae6331d63b4febaa312c9d14493aafa9b8@git.kernel.org>
Git-Commit-ID: 782cc5ae6331d63b4febaa312c9d14493aafa9b8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 07 May 2009 09:25:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  782cc5ae6331d63b4febaa312c9d14493aafa9b8
Gitweb:     http://git.kernel.org/tip/782cc5ae6331d63b4febaa312c9d14493aafa9b8
Author:     Markus Metzger <markus.t.metzger@intel.com>
AuthorDate: Fri, 24 Apr 2009 09:43:09 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 24 Apr 2009 10:18:51 +0200

x86, ds: fix buffer alignment in debug store selftest

The debug store selftest code uses a stack-allocated buffer, which is
not necessarily correctly aligned.

For tests using a buffer to hold a single entry, the buffer that is
passed to ds_request must already be suitably aligned.

Pass a suitably aligned portion of the bigger buffer.

[ Impact: fix hw-branch-tracer self-test failure ]

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Cc: markus.t.metzger@gmail.com
LKML-Reference: <20090424094309.A30145@sedona.ch.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/ds_selftest.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ds_selftest.c b/arch/x86/kernel/ds_selftest.c
index 5f104a0..6bc7c19 100644
--- a/arch/x86/kernel/ds_selftest.c
+++ b/arch/x86/kernel/ds_selftest.c
@@ -323,13 +323,15 @@ static int ds_selftest_bts_bad_request_task(void *buffer)
 int ds_selftest_bts(void)
 {
 	struct ds_selftest_bts_conf conf;
-	unsigned char buffer[BUFFER_SIZE];
+	unsigned char buffer[BUFFER_SIZE], *small_buffer;
 	unsigned long irq;
 	int cpu;
 
 	printk(KERN_INFO "[ds] bts selftest...");
 	conf.error = 0;
 
+	small_buffer = (unsigned char *)ALIGN((unsigned long)buffer, 8) + 8;
+
 	get_online_cpus();
 	for_each_online_cpu(cpu) {
 		conf.suspend = ds_suspend_bts_wrap;
@@ -381,7 +383,7 @@ int ds_selftest_bts(void)
 	conf.suspend = ds_suspend_bts_noirq;
 	conf.resume = ds_resume_bts_noirq;
 	conf.tracer =
-		ds_request_bts_task(current, buffer, SMALL_BUFFER_SIZE,
+		ds_request_bts_task(current, small_buffer, SMALL_BUFFER_SIZE,
 				   NULL, (size_t)-1, BTS_KERNEL);
 	local_irq_save(irq);
 	ds_selftest_bts_cpu(&conf);
