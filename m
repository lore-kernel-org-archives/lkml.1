Return-Path: <linux-kernel-owner+w=401wt.eu-S1751833AbXCNPrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbXCNPrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbXCNPru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:47:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755AbXCNPrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:47:49 -0400
Message-ID: <45F8186A.6090408@redhat.com>
Date: Wed, 14 Mar 2007 16:44:42 +0100
From: Michal Schmidt <mschmidt@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH 58/59] sysctl: Reimplement the sysctl proc support
References: <m1ac0jc4no.fsf@ebiederm.dsl.xmission.com> <11689657073389-git-send-email-ebiederm@xmission.com> <20070314103832.GA16104@elte.hu> <b6fcc0a0703140348o18a4b24fye3dcbad593cf83a5@mail.gmail.com> <20070314122453.GA5775@elte.hu>
In-Reply-To: <20070314122453.GA5775@elte.hu>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Alexey Dobriyan <adobriyan@gmail.com> wrote:
>   
>> Use register_sysctl_table() for sysctls.
>>     
>
> yes - i just wanted to point out the incompatibility and subtle breakage 
> that this change caused. I'll now have to convert the current code over 
> to sysctl_table, which isnt that hard but not trivial either, and i 
> certainly could make use that time for other purposes.
>
> 	Ingo
>   

How about this? It works for me.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>

diff --git a/kernel/latency_trace.c b/kernel/latency_trace.c
index e07bb95..a13d001 100644
--- a/kernel/latency_trace.c
+++ b/kernel/latency_trace.c
@@ -19,7 +19,7 @@
 #include <linux/seq_file.h>
 #include <linux/interrupt.h>
 #include <linux/clocksource.h>
-#include <linux/proc_fs.h>
+#include <linux/sysctl.h>
 #include <linux/latency_hist.h>
 #include <linux/utsrelease.h>
 #include <asm/uaccess.h>
@@ -2661,66 +2661,94 @@ void print_traces(struct task_struct *task)
 }
 #endif
 
-static int preempt_read_proc(char *page, char **start, off_t off,
-			     int count, int *eof, void *data)
+#if defined(CONFIG_WAKEUP_TIMING) || defined(CONFIG_EVENT_TRACE)
+
+static int preempt_proc_handler(ctl_table *table, int write, struct file *filp,
+				void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-	cycle_t *max = data;
+#define TMPBUFLEN 21
+	char buf[TMPBUFLEN];
+	size_t left = *lenp;
+	cycle_t *max = table->data;
 
-	return sprintf(page, "%ld\n", cycles_to_usecs(*max));
-}
+	if (!table->data || table->maxlen!=sizeof(cycles_t) || !*lenp ||
+			(*ppos && !write)) {
+		*lenp = 0;
+		return 0;
+	}
 
-static int preempt_write_proc(struct file *file, const char __user *buffer,
-			      unsigned long count, void *data)
-{
-	unsigned int c, done = 0, val, sum = 0;
-	cycle_t *max = data;
+	if (!write) {
+		int len;
 
-	while (count) {
-		if (get_user(c, buffer))
-			return -EFAULT;
-		val = c - '0';
-		buffer++;
-		done++;
-		count--;
-		if (c == 0 || c == '\n')
-			break;
-		if (val > 9)
+		len = snprintf(buf, TMPBUFLEN, "%ld\n", cycles_to_usecs(*max));
+		if (len >= TMPBUFLEN)
 			return -EINVAL;
-		sum *= 10;
-		sum += val;
+		if (len > left)
+			len = left;
+		if (copy_to_user(buffer, buf, len))
+			return -EFAULT;
+		left -= len;
+	} else {
+		unsigned int c, val, sum = 0;
+
+		while (left) {
+			if (get_user(c, (char __user *)buffer))
+				return -EFAULT;
+			val = c - '0';
+			buffer++;
+			left--;
+			if (c == 0 || c == '\n')
+				break;
+			if (val > 9)
+				return -EINVAL;
+			sum *= 10;
+			sum += val;
+		}
+		*max = usecs_to_cycles(sum);
 	}
-	*max = usecs_to_cycles(sum);
-	return done;
+
+	*lenp -= left;
+	*ppos += *lenp;
+	return 0;
 }
 
-#if defined(CONFIG_WAKEUP_TIMING) || defined(CONFIG_EVENT_TRACE)
+static ctl_table preempt_latency_table[] = {
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "preempt_max_latency",
+		.data		= &preempt_max_latency,
+		.maxlen		= sizeof(cycles_t),
+		.mode		= 0644,
+		.proc_handler	= &preempt_proc_handler,
+	},
+#ifdef CONFIG_EVENT_TRACE
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "preempt_thresh",
+		.data		= &preempt_thresh,
+		.maxlen		= sizeof(cycles_t),
+		.mode		= 0644,
+		.proc_handler	= &preempt_proc_handler,
+	},
+#endif
+	{ .ctl_name = 0 }
+};
 
-#define	PROCNAME_PML	"sys/kernel/preempt_max_latency"
-#define PROCNAME_PT	"sys/kernel/preempt_thresh"
+static ctl_table kernel_root[] = {
+	{
+		.ctl_name	= CTL_KERN,
+		.procname	= "kernel",
+		.mode		= 0555,
+		.child		= preempt_latency_table,
+	},
+	{ .ctl_name = 0 }
+};
+
+static struct ctl_table_header *sysctl_header;
 
 static __init int latency_fs_init(void)
 {
-	struct proc_dir_entry *entry;
-
-	if (!(entry = create_proc_entry(PROCNAME_PML, 0644, NULL)))
-		printk("latency_fs_init(): can't create %s\n", PROCNAME_PML);
-	else {
-		entry->nlink = 1;
-		entry->data = &preempt_max_latency;
-		entry->read_proc = preempt_read_proc;
-		entry->write_proc = preempt_write_proc;
-	}
-
-#ifdef CONFIG_EVENT_TRACE
-	if (!(entry = create_proc_entry(PROCNAME_PT, 0644, NULL)))
-		printk("latency_fs_init(): can't create %s\n", PROCNAME_PT);
-	else {
-		entry->nlink = 1;
-		entry->data = &preempt_thresh;
-		entry->read_proc = preempt_read_proc;
-		entry->write_proc = preempt_write_proc;
-	}
-#endif
+	sysctl_header = register_sysctl_table(kernel_root);
 	return 0;
 }
 __initcall(latency_fs_init);



-- 
Michal Schmidt             Kernel Developer
mschmidt@redhat.com    Red Hat Czech s.r.o.

