Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbXJWQYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbXJWQYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 12:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbXJWQYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 12:24:23 -0400
Received: from smtp28.orange.fr ([80.12.242.99]:59151 "EHLO smtp28.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbXJWQYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 12:24:22 -0400
X-ME-UUID: 20071023161747531.81D577000097@mwinf2821.orange.fr
Date: Tue, 23 Oct 2007 18:13:21 +0200
From: Philippe Elie <phil.el@wanadoo.fr>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sami Farin <safari-kernel@safari.iki.fi>
Subject: Re: [patch 1/2] oProfile: oops when profile_pc() return ~0LU
Message-ID: <20071023161321.GA2884@zaniah>
References: <20071021120842.GA2886@zaniah> <alpine.LFD.0.999.0710221936130.30120@woody.linux-foundation.org> <20071023101007.3y62tufa6yxrqk4w@m.safari.iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023101007.3y62tufa6yxrqk4w@m.safari.iki.fi>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007 at 13:10 +0000, Sami Farin wrote:

> On Mon, Oct 22, 2007 at 19:38:10 -0700, Linus Torvalds wrote:
> > 
> > This set of two patches look ok by me, but I'd like sign-offs.. Also, were 
> > they tested and found to fix the problem by Sami?
> > 
> > 		Linus

For the signed-offs I thought the From: was an implicit Signed-offs.

Test was done privately, Sami helped to narrow down the trouble, but
he didn't test the last patch, nothing bad on Sami side, I was too
confident the fix was obvious after narrowing it.

> 
> The previous patch I tested by Philippe, oprof-fix-profile_pc-use.patch,
> worked ok, but with this latest patch oprofiled aborts.
> But kernel does not oops or print msgs.

argh, I just moved the wrong eip from kernel to user space where the same
problem occur too, *sighs*, since I can't reproduce Sami problem, my own
test obviously worked...

Sami, can you test this new patch. After testing can you report
the contents of /dev/oprofile/stats/cpu*/sample_invalid_eip ?

Linus, there is two way to fix this problem, the attached patch fix it
by sanitizing the sampled eip, the other is to replace the use of
profile_pc(); by instruction_pointer(); in cpu_buffer.c, that one was
tested by Sami  but 1) it'll break the 'use oprofile as a sort of lockometer'
2) I think sanitizing the eip will be necessary anyway as I'm not really
confident than instruction_pointer() can never return weird eip on some
weird arch and/or some weird circumstances.

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

