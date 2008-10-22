Return-Path: <linux-kernel-owner+w=401wt.eu-S1752562AbYJVEot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbYJVEot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 00:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbYJVEol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 00:44:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56234 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbYJVEok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 00:44:40 -0400
Message-ID: <48FEAF36.9010003@cn.fujitsu.com>
Date: Wed, 22 Oct 2008 12:42:30 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/proc: fix /proc/cpuinfo cpu offline bug
References: <48F852FD.7070108@cn.fujitsu.com>	 <20081017114132.GA18994@x200.localdomain> <e7baa9c80810170544q1eaec469vc3a1ad2cba8e4ee0@mail.gmail.com> <48FEAE6B.70809@cn.fujitsu.com>
In-Reply-To: <48FEAE6B.70809@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan wrote:
> Hi, Ingo and Alexey,
> 
> I have changed my changelog. please review again.
> 
> Thanks, Lai.
> 


In my test, I found that if a cpu has been offline,
the next cpus may not be shown in the /proc/cpuinfo.

if one read() cannot consume the whole /proc/cpuinfo,
c_start() will be called again in the next read() calls.
And *pos has been increased by 1 by the caller(seq_read()).
if this time the cpu#*pos is offline, c_start() will return
NULL, and the next cpus can not be shown.

this fix use next_cpu_nr(*pos - 1, cpu_online_map) to
search the next unshown cpu.

the most easy way to reproduce this bug:
1) offline cpu#1             (cpu#0 is online)
2) dd ibs=2 if=/proc/cpuinfo
   the result is that only cpu#0 is shown.
   cpu#2 and cpu#3 .... cannot be shown in /proc/cpuinfo
   it's bug.

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
 



