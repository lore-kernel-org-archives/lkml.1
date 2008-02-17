Return-Path: <linux-kernel-owner+w=401wt.eu-S1757802AbYBQMZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802AbYBQMZR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756718AbYBQMXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:23:04 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:38327 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755105AbYBQMW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:22:56 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH 07/27] cpu: fix section mismatch warnings in *cpu_down
Date: Sun, 17 Feb 2008 13:22:44 +0100
Message-Id: <1203250984-11285-7-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <20080217121255.GA10519@uranus.ravnborg.org>
References: <20080217121255.GA10519@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warnings:
WARNING: vmlinux.o(.text+0x75c8d): Section mismatch in reference from the function take_cpu_down() to the variable .cpuinit.data:cpu_chain
WARNING: vmlinux.o(.text+0x75d2a): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain
WARNING: vmlinux.o(.text+0x75d4d): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain
WARNING: vmlinux.o(.text+0x75de4): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain
WARNING: vmlinux.o(.text+0x75e33): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain

cpu_down is only used from code surrounded by HOTPLUG_CPU
so any references to __cpuinit is OK.
Add a few __ref to tech modpost to ignore the references.

This is just papering over the fact that the cpu hotplug
code is fragile with respect to use of HOTPLUG_CPU and
in many cases rely on __cpuinit to get rid of code
when HOTPLUG_CPU is not enabled.
For now this is the least invasive change.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>
---
 kernel/cpu.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index cdebf33..74827bf 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -180,7 +180,7 @@ struct take_cpu_down_param {
 };
 
 /* Take this CPU down. */
-static int take_cpu_down(void *_param)
+static int __ref take_cpu_down(void *_param)
 {
 	struct take_cpu_down_param *param = _param;
 	int err;
@@ -199,7 +199,7 @@ static int take_cpu_down(void *_param)
 }
 
 /* Requires cpu_add_remove_lock to be held */
-static int _cpu_down(unsigned int cpu, int tasks_frozen)
+static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 {
 	int err, nr_calls = 0;
 	struct task_struct *p;
@@ -274,7 +274,7 @@ out_release:
 	return err;
 }
 
-int cpu_down(unsigned int cpu)
+int __ref cpu_down(unsigned int cpu)
 {
 	int err = 0;
 
-- 
1.5.4.rc3.14.g44397

