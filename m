Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbYIRUnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbYIRUnz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 16:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbYIRUnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 16:43:47 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:61487 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbYIRUnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 16:43:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=OZ4PQ2nw/91vp5z73TaNnMR7OZPihziyW9uYUwwR5k3VSjilqLk5HQ5QxaJXTYa68E
         7ZsWO3jbsh//2yF7bQKIFZqr8b7AbqY6yuTh8rfzxt/1JFVowvS3wluOMScEPC1cTELA
         NVMjkbhdlzxu/Nfx7zK606Q0Mz2VPWf6Pl2Wc=
Message-ID: <48D2BD7C.4070300@gmail.com>
Date: Thu, 18 Sep 2008 22:43:40 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: davej@codemonkey.org.uk, Andrew Morton <akpm@linux-foundation.org>
CC: cpufreq@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm] cpufreq: BUG: using smp_processor_id() in preemptible
 code
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use get_cpu()/put_cpu() in cpufreq_ondemand init routine, instead of
smp_processor_id() to avoid the following BUG:

[   35.313118] BUG: using smp_processor_id() in preemptible [00000000] code: modprobe/4952
[   35.313132] caller is cpufreq_gov_dbs_init+0xa/0x8f [cpufreq_ondemand]
[   35.313140] Pid: 4952, comm: modprobe Not tainted 2.6.27-rc5-mm1 #23
[   35.313145] Call Trace:
[   35.313158]  [<ffffffff80361ff7>] debug_smp_processor_id+0xd7/0xe0
[   35.313167]  [<ffffffffa010800a>] cpufreq_gov_dbs_init+0xa/0x8f [cpufreq_ondemand]
[   35.313176]  [<ffffffff8020903b>] _stext+0x3b/0x160
[   35.313185]  [<ffffffff804768c5>] __mutex_unlock_slowpath+0xe5/0x190
[   35.313195]  [<ffffffff8026236a>] trace_hardirqs_on_caller+0xca/0x140
[   35.313205]  [<ffffffff8026ef4c>] sys_init_module+0xdc/0x210
[   35.313212]  [<ffffffff8020b7cb>] system_call_fastpath+0x16/0x1b

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 drivers/cpufreq/cpufreq_ondemand.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index aaa9e19..3098a94 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -638,8 +638,11 @@ static int __init cpufreq_gov_dbs_init(void)
 {
 	int err;
 	cputime64_t wall;
-	u64 idle_time = get_cpu_idle_time_us(smp_processor_id(), &wall);
+	u64 idle_time;
+	int cpu = get_cpu();
 
+	idle_time = get_cpu_idle_time_us(cpu, &wall);
+	put_cpu();
 	if (idle_time != -1ULL) {
 		/* Idle micro accounting is supported. Use finer thresholds */
 		dbs_tuners_ins.up_threshold = MICRO_FREQUENCY_UP_THRESHOLD;
-- 
1.5.4.3
