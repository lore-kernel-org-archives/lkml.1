Return-Path: <linux-kernel-owner+w=401wt.eu-S1752136Ab0ANFNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab0ANFNM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 00:13:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056Ab0ANFNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 00:13:11 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42001 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856Ab0ANFNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 00:13:10 -0500
Date: Thu, 14 Jan 2010 16:13:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jason Wessel <jason.wessel@windriver.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: linux-next: manual merge of the tip tree with the kgdb tree
Message-Id: <20100114161302.285ebe27.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the tip tree got a conflict in
kernel/trace/trace.c between commit
d304af88a0105ff5b64cffc9108636ecad1fdd78 ("ftrace,kdb: Extend kdb to be
able to dump the ftrace buffer") from the kgdb tree and commit
7e53bd42d14c75192b99674c40fcc359392da59d ("tracing: Consolidate
protection of reader access to the ring buffer") from the tip tree.

Just context changes (I think).  I fixed it up (see below) and can carry
the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/trace/trace.c
index b3c786a,5314c90..0000000
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@@ -100,11 -101,11 +101,8 @@@ static inline void ftrace_enable_cpu(vo
  	preempt_enable();
  }
  
 -static cpumask_var_t __read_mostly	tracing_buffer_mask;
 -
 -#define for_each_tracing_cpu(cpu)	\
 -	for_each_cpu(cpu, tracing_buffer_mask)
 +cpumask_var_t __read_mostly	tracing_buffer_mask;
  
- /* Define which cpu buffers are currently read in trace_pipe */
- static cpumask_var_t			tracing_reader_cpumask;
- 
  /*
   * ftrace_dump_on_oops - variable to dump ftrace buffer on oops
   *
@@@ -3066,7 -3131,8 +3123,8 @@@ waitagain
  	iter->pos = -1;
  
  	trace_event_read_lock();
+ 	trace_access_lock(iter->cpu_file);
 -	while (find_next_entry_inc(iter) != NULL) {
 +	while (trace_find_next_entry_inc(iter) != NULL) {
  		enum print_line_t ret;
  		int len = iter->seq.len;
  
