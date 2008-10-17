Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbYJQI5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbYJQI5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 04:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbYJQI5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 04:57:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63711 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752029AbYJQI5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 04:57:34 -0400
Message-ID: <48F852FD.7070108@cn.fujitsu.com>
Date: Fri, 17 Oct 2008 16:55:25 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/proc: fix /proc/cpuinfo cpu offline bug
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In my test, I found that if a cpu has been offline,
the next cpus may not be shown in the /proc/cpuinfo.

trivially reproduce this bug:

1) add these lines in the end of show_cpuinfo()
	if (m->size - m->count - 20 > 0)
		seq_printf(m, "%*s", (int)(m->size - m->count - 20), "show bug\n");

2) rebuilt kernel & reboot
3) offline cpu#1
4) cat /proc/cpuinfo
   cpu#2 and cpu#3 .... cannot be shown in /proc/cpuinfo

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
 



