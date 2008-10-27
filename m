Return-Path: <linux-kernel-owner+w=401wt.eu-S1752362AbYJ0GOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbYJ0GOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 02:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbYJ0GOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 02:14:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54330 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbYJ0GOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 02:14:10 -0400
Message-ID: <49055BA5.4040702@cn.fujitsu.com>
Date: Mon, 27 Oct 2008 14:11:49 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
CC: Alexey Dobriyan <adobriyan@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH resend] x86/proc: fix /proc/cpuinfo cpu offline bug
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In my test, I found that if a cpu has been offline,
the next cpus may not be shown in the /proc/cpuinfo.

if one read() cannot consume the whole /proc/cpuinfo file,
c_start() will be called again in the next read() calls.
And *pos has been increased by 1 by the caller(seq_read()).
if this time the cpu#*pos is offline, c_start() will return
NULL, and the next cpus can not be shown.

this fix uses next_cpu_nr(*pos - 1, cpu_online_map) to
search the next unshown cpu.

the way to reproduce this bug:
(cpu#0 cpu#1 cpu#2 must be online before test)

step 1) offline cpu#1
step 2) dd ibs=2 if=/proc/cpuinfo

now, only cpu#0 's cpuinfo is shown.
cpu#2 and cpu#3 .... cannot be shown in /proc/cpuinfo
it's a bug.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index a26c480..01b1244 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -160,14 +160,16 @@ static void *c_start(struct seq_file *m, loff_t *pos)
 {
 	if (*pos == 0)	/* just in case, cpu 0 is not the first */
 		*pos = first_cpu(cpu_online_map);
-	if ((*pos) < nr_cpu_ids && cpu_online(*pos))
+	else
+		*pos = next_cpu_nr(*pos - 1, cpu_online_map);
+	if ((*pos) < nr_cpu_ids)
 		return &cpu_data(*pos);
 	return NULL;
 }
 
 static void *c_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	*pos = next_cpu(*pos, cpu_online_map);
+	(*pos)++;
 	return c_start(m, pos);
 }
 

