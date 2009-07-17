Return-Path: <linux-kernel-owner+w=401wt.eu-S934445AbZGQLKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934445AbZGQLKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 07:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934411AbZGQLKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 07:10:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56497 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934420AbZGQLKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 07:10:46 -0400
Date: Fri, 17 Jul 2009 13:10:25 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: dont reset set_ftrace_filter/notrace when
	opened with r/w perm
Message-ID: <20090717111025.GC2891@jolsa.lab.eng.brq.redhat.com>
References: <20090716165135.GA4739@jolsa.lab.eng.brq.redhat.com> <4A604654.1090303@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A604654.1090303@cn.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 17, 2009 at 05:37:24PM +0800, Li Zefan wrote:
> Jiri Olsa wrote:
> > If user setup set_ftrace_filter/set_ftrace_notrace files and then opens them
> > with read&write permissions, the previous setup will be removed.
> > 
> 
> Currently:
> 
>  # echo 'sys_open sys_close' > set_ftrace_filter
>  # cat set_ftrace_filter
>  sys_open
>  sys_close
> 
> After your patch:
> 
>  # echo 'sys_open sys_close' > set_ftrace_filter
>  # cat set_ftrace_filter
>  sys_close
> 

oops, sry I missed this..

Following patch adds new FTRACE_ITER_RESET flag, as the decision needs
to be taken in "open" and applied in "write".  I'm not sure whats the
policy for adding new flags, but it looks ok to me.

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4521c77..29c4b67 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1364,6 +1364,7 @@ enum {
 	FTRACE_ITER_FAILURES	= (1 << 3),
 	FTRACE_ITER_PRINTALL	= (1 << 4),
 	FTRACE_ITER_HASH	= (1 << 5),
+	FTRACE_ITER_RESET	= (1 << 6),
 };
 
 #define FTRACE_BUFF_MAX (KSYM_SYMBOL_LEN+4) /* room for wildcards */
@@ -1663,11 +1664,11 @@ ftrace_regex_open(struct inode *inode, struct file *file, int enable)
 	mutex_lock(&ftrace_regex_lock);
 	if ((file->f_mode & FMODE_WRITE) &&
 	    !(file->f_flags & O_APPEND))
-		ftrace_filter_reset(enable);
+		iter->flags |= FTRACE_ITER_RESET;
 
 	if (file->f_mode & FMODE_READ) {
 		iter->pg = ftrace_pages_start;
-		iter->flags = enable ? FTRACE_ITER_FILTER :
+		iter->flags |= enable ? FTRACE_ITER_FILTER :
 			FTRACE_ITER_NOTRACE;
 
 		ret = seq_open(file, &show_ftrace_seq_ops);
@@ -2267,6 +2268,11 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 	} else
 		iter = file->private_data;
 
+	if (iter->flags & FTRACE_ITER_RESET) {
+		ftrace_filter_reset(enable);
+		iter->flags &= ~FTRACE_ITER_RESET;
+	}
+
 	if (!*ppos) {
 		iter->flags &= ~FTRACE_ITER_CONT;
 		iter->buffer_idx = 0;
