Return-Path: <linux-kernel-owner+w=401wt.eu-S1761939AbXKTS1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761939AbXKTS1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:27:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760932AbXKTS0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:26:01 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60134 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760903AbXKTS0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:26:00 -0500
Date: Tue, 20 Nov 2007 10:23:18 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, phil.el@wanadoo.fr,
       safari-kernel@safari.iki.fi
Subject: [patch 05/29] oProfile: oops when profile_pc() returns ~0LU
Message-ID: <20071120182318.GF28611@kroah.com>
References: <20071120181733.702234406@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="oprofile-oops-when-profile_pc-returns-0lu.patch"
In-Reply-To: <20071120182248.GA28611@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Philippe Elie <phil.el@wanadoo.fr>

patch df9d177aa28d50e64bae6fbd6b263833079e3571 in mainline.

Instruction pointer returned by profile_pc() can be a random value.  This
break the assumption than we can safely set struct op_sample.eip field to a
magic value to signal to the per-cpu buffer reader side special event like
task switch ending up in a segfault in get_task_mm() when profile_pc()
return ~0UL.  Fixed by sanitizing the sampled eip and reject/log invalid
eip.

Problem reported by Sami Farin, patch tested by him.

Signed-off-by: Philippe Elie <phil.el@wanadoo.fr>
Tested-by: Sami Farin <safari-kernel@safari.iki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/oprofile/cpu_buffer.c     |    7 +++++++
 drivers/oprofile/cpu_buffer.h     |    1 +
 drivers/oprofile/oprofile_stats.c |    4 ++++
 3 files changed, 12 insertions(+)

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
@@ -175,6 +177,11 @@ static int log_sample(struct oprofile_cp
 
 	cpu_buf->sample_received++;
 
+	if (pc == ESCAPE_CODE) {
+		cpu_buf->sample_invalid_eip++;
+		return 0;
+	}
+
 	if (nr_available_slots(cpu_buf) < 3) {
 		cpu_buf->sample_lost_overflow++;
 		return 0;
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
@@ -61,6 +63,8 @@ void oprofile_create_stats_files(struct 
 			&cpu_buf->sample_lost_overflow);
 		oprofilefs_create_ro_ulong(sb, cpudir, "backtrace_aborted",
 			&cpu_buf->backtrace_aborted);
+		oprofilefs_create_ro_ulong(sb, cpudir, "sample_invalid_eip",
+			&cpu_buf->sample_invalid_eip);
 	}
  
 	oprofilefs_create_ro_atomic(sb, dir, "sample_lost_no_mm",

-- 
