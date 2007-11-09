Return-Path: <linux-kernel-owner+w=401wt.eu-S1761714AbXKILQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761714AbXKILQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 06:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbXKILQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 06:16:14 -0500
Received: from smtp2a.orange.fr ([80.12.242.139]:18438 "EHLO smtp2a.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbXKILQN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 06:16:13 -0500
X-ME-UUID: 20071109111611476.745A7700008F@mwinf2a07.orange.fr
Date: Fri, 9 Nov 2007 12:11:29 +0100
From: Philippe Elie <phil.el@wanadoo.fr>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sami Farin <safari-kernel@safari.iki.fi>
Subject: [PATCH 1/1]: oProfile: oops when profile_pc() return ~0LU
Message-ID: <20071109111129.GB2890@zaniah>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Elie <phil.el@wanadoo.fr>

Instruction pointer returned by profile_pc() can be a random value. This
break the assumption than we can safely set struct op_sample.eip field to
a magic value to signal to the per-cpu buffer reader side special event
like task switch ending up in a segfault in get_task_mm() when profile_pc()
return ~0UL. Fixed by sanitizing the sampled eip and reject/log invalid eip.

Problem reported by Sami Farin, patch tested by him.

Signed-off-by: Philippe Elie <phil.el@wanadoo.fr>

---

 drivers/oprofile/cpu_buffer.c     |    7 +++++++
 drivers/oprofile/cpu_buffer.h     |    1 +
 drivers/oprofile/oprofile_stats.c |    4 ++++
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index a83c3db..c93d3d2 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -64,6 +64,8 @@ int alloc_cpu_buffers(void)
 		b->head_pos = 0;
 		b->sample_received = 0;
 		b->sample_lost_overflow = 0;
+		b->backtrace_aborted = 0;
+		b->sample_invalid_eip = 0;
 		b->cpu = i;
 		INIT_DELAYED_WORK(&b->work, wq_sync_buffer);
 	}
@@ -175,6 +177,11 @@ static int log_sample(struct oprofile_cpu_buffer * cpu_buf, unsigned long pc,
 
 	cpu_buf->sample_received++;
 
+	if (pc == ESCAPE_CODE) {
+		cpu_buf->sample_invalid_eip++;
+		return 0;
+	}
+
 	if (nr_available_slots(cpu_buf) < 3) {
 		cpu_buf->sample_lost_overflow++;
 		return 0;
diff --git a/drivers/oprofile/cpu_buffer.h b/drivers/oprofile/cpu_buffer.h
index 49900d9..c66c025 100644
--- a/drivers/oprofile/cpu_buffer.h
+++ b/drivers/oprofile/cpu_buffer.h
@@ -42,6 +42,7 @@ struct oprofile_cpu_buffer {
 	unsigned long sample_received;
 	unsigned long sample_lost_overflow;
 	unsigned long backtrace_aborted;
+	unsigned long sample_invalid_eip;
 	int cpu;
 	struct delayed_work work;
 } ____cacheline_aligned;
diff --git a/drivers/oprofile/oprofile_stats.c b/drivers/oprofile/oprofile_stats.c
index f0acb66..d1f6d77 100644
--- a/drivers/oprofile/oprofile_stats.c
+++ b/drivers/oprofile/oprofile_stats.c
@@ -26,6 +26,8 @@ void oprofile_reset_stats(void)
 		cpu_buf = &cpu_buffer[i]; 
 		cpu_buf->sample_received = 0;
 		cpu_buf->sample_lost_overflow = 0;
+		cpu_buf->backtrace_aborted = 0;
+		cpu_buf->sample_invalid_eip = 0;
 	}
  
 	atomic_set(&oprofile_stats.sample_lost_no_mm, 0);
@@ -61,6 +63,8 @@ void oprofile_create_stats_files(struct super_block * sb, struct dentry * root)
 			&cpu_buf->sample_lost_overflow);
 		oprofilefs_create_ro_ulong(sb, cpudir, "backtrace_aborted",
 			&cpu_buf->backtrace_aborted);
+		oprofilefs_create_ro_ulong(sb, cpudir, "sample_invalid_eip",
+			&cpu_buf->sample_invalid_eip);
 	}
  
 	oprofilefs_create_ro_atomic(sb, dir, "sample_lost_no_mm",

