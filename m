Return-Path: <linux-kernel-owner+w=401wt.eu-S1752677AbZCHXtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbZCHXtV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 19:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560AbZCHXtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 19:49:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:65375 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbZCHXtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 19:49:12 -0400
Date: Sun, 8 Mar 2009 19:49:08 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Sitsofe Wheeler <sitsofe@yahoo.com>
cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [TIP,BISECTED] Negative nice values have become big positive
 numbers
In-Reply-To: <20090308231850.GB24445@silver.sucs.org>
Message-ID: <alpine.DEB.2.00.0903081944470.2203@gandalf.stny.rr.com>
References: <20090308231850.GB24445@silver.sucs.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 8 Mar 2009, Sitsofe Wheeler wrote:

> (Forgot to cc lkml. Resending...)
> 
> Formally negative nice values have started become very big in positive
> integers in -tip kernels:
> 
>     2 root      15 2147483647     0    0    0 S  0.0  0.0   0:00.00 kthreadd    

Is this the output of top?

> 
> I've just finished bisecting down to this commit:
> 
> commit 1427cdf0592368bdec57276edaf714040ee8744f
> Author: Lai Jiangshan <laijs@cn.fujitsu.com>
> Date:   Fri Mar 6 17:21:47 2009 +0100

$ git show 1427cdf0592368bdec57276edaf714040ee8744f  | diffstat
 include/linux/ftrace.h       |    3 +
 kernel/trace/Kconfig         |    6 ++
 kernel/trace/Makefile        |    1 
 kernel/trace/trace.c         |   56 +++++++++++++++++++++++++++
 kernel/trace/trace.h         |   12 +++++
 kernel/trace/trace_bprintk.c |   87 
+++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace_output.c  |   75 +++++++++++++++++++++++++++++++++++++
 7 files changed, 240 insertions(+)

I find it hard to believe that this would cause normal nice values to be 
messed up. The only file that could could come close to messing with nice 
values in top is ftrace.h:


diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 4987694..1c9cdca 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -223,6 +223,9 @@ extern int ftrace_make_nop(struct module *mod,
  */
 extern int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr);
 
+#ifdef CONFIG_TRACE_BPRINTK
+extern int trace_vbprintk(unsigned long ip, const char *fmt, va_list args);
+#endif
 
 /* May be defined in arch */
 extern int ftrace_arch_read_dyn_info(char *buf, int size);



And that too would be hard to affect nice values. Do you have a config 
that I could test with?

Thanks,

-- Steve

