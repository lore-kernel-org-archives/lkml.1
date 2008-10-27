Return-Path: <linux-kernel-owner+w=401wt.eu-S1752825AbYJ0Jyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbYJ0Jyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 05:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbYJ0Jyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 05:54:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53012 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbYJ0Jyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 05:54:47 -0400
Date: Mon, 27 Oct 2008 10:54:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH resend] x86/proc: fix /proc/cpuinfo cpu offline bug
Message-ID: <20081027095430.GB6969@elte.hu>
References: <49055BA5.4040702@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49055BA5.4040702@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> In my test, I found that if a cpu has been offline,
> the next cpus may not be shown in the /proc/cpuinfo.

fix is already upstream - see below.

	Ingo

-------------------->
Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=bc8bcc79ea4203c7d04309f1307ab88c86f0b0cf
Commit:     bc8bcc79ea4203c7d04309f1307ab88c86f0b0cf
Parent:     35af28219e684a36cc8b1ff456c370ce22be157d
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Wed Oct 22 12:42:30 2008 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed Oct 22 14:29:37 2008 +0200

    x86/proc: fix /proc/cpuinfo cpu offline bug
    
    Impact: fix missing CPUs in /proc/cpuinfo after CPU hotunplug/hotreplug
    
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
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/proc.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

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
 
