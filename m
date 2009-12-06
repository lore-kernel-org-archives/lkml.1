Return-Path: <linux-kernel-owner+w=401wt.eu-S1751371AbZLFFLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371AbZLFFLZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 00:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750961AbZLFFLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 00:11:18 -0500
Received: from lixom.net ([66.141.50.11]:53073 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbZLFFLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 00:11:17 -0500
Date: Sat, 5 Dec 2009 23:13:52 -0600
From: Olof Johansson <olof@lixom.net>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, Carsten.Emde@osadl.org, tglx@linutronix.de,
       C.Emde@osadl.org
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/urgent] tracing: Fix trace_marker output
Message-ID: <20091206051352.GA4628@lixom.net>
References: <4B01AE5D.1010801@osadl.org> <tip-c13d2f7c3231e873f30db92b96c8caa48f100f33@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-c13d2f7c3231e873f30db92b96c8caa48f100f33@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Nov 22, 2009 at 10:24:48AM +0000, tip-bot for Carsten Emde wrote:
> Commit-ID:  c13d2f7c3231e873f30db92b96c8caa48f100f33
> Gitweb:     http://git.kernel.org/tip/c13d2f7c3231e873f30db92b96c8caa48f100f33
> Author:     Carsten Emde <Carsten.Emde@osadl.org>
> AuthorDate: Mon, 16 Nov 2009 20:56:13 +0100
> Committer:  Steven Rostedt <rostedt@goodmis.org>
> CommitDate: Tue, 17 Nov 2009 09:19:06 -0500
> 
> tracing: Fix trace_marker output
> 
> When a string was written to <debugfs>/tracing/trace_marker, some
> strange characters appeared in the trace output instead of the
> string, since a vprint function erroneously called a vararg print
> function with a va_list argument. This patch fixes the problem and
> simplifies the related code.

[...]

> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 03c7fd5..12b49ca 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1361,10 +1361,11 @@ int trace_array_vprintk(struct trace_array *tr,
>  	pause_graph_tracing();
>  	raw_local_irq_save(irq_flags);
>  	__raw_spin_lock(&trace_buf_lock);
> -	len = vsnprintf(trace_buf, TRACE_BUF_SIZE, fmt, args);
> -
> -	len = min(len, TRACE_BUF_SIZE-1);
> -	trace_buf[len] = 0;
> +	if (args == NULL) {
> +		strncpy(trace_buf, fmt, TRACE_BUF_SIZE);
> +		len = strlen(trace_buf);
> +	} else
> +		len = vsnprintf(trace_buf, TRACE_BUF_SIZE, fmt, args);


Comparing a va_list with NULL is bogus. It's supposed to be treated like
an opaque type and only be manipulated with va_* accessors.

I wouldn't really care much, but it broke builds on some ARM platforms:

kernel/trace/trace.c: In function 'trace_array_vprintk':
kernel/trace/trace.c:1364: error: invalid operands to binary == (have 'va_list' and 'void *')
kernel/trace/trace.c: In function 'tracing_mark_write':
kernel/trace/trace.c:3349: error: incompatible type for argument 3 of 'trace_vprintk'

I see no real graceful way of solving this. What is really needed is a
trace_puts to output a string without applying format parsing to it.

I am going to do the lazy thing here, define a trace_puts() and call the
vprintk innards with it instead of duplicating code. It's probably not
the most graceful solution to the problem, but reporting a bug with a
bad patch tends to be better than reporting it without one at all. Better
suggestions are appreciated.

Oh, and I haven't had a chance to actually test and make sure it does
what is expected, since I don't have a testcase for it.


Signed-off-by: Olof Johansson <olof@lixom.net>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 874f289..9b5bb4c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1361,11 +1361,7 @@ int trace_array_vprintk(struct trace_array *tr,
 	pause_graph_tracing();
 	raw_local_irq_save(irq_flags);
 	__raw_spin_lock(&trace_buf_lock);
-	if (args == NULL) {
-		strncpy(trace_buf, fmt, TRACE_BUF_SIZE);
-		len = strlen(trace_buf);
-	} else
-		len = vsnprintf(trace_buf, TRACE_BUF_SIZE, fmt, args);
+	len = vsnprintf(trace_buf, TRACE_BUF_SIZE, fmt, args);
 
 	size = sizeof(*entry) + len + 1;
 	buffer = tr->buffer;
@@ -1398,6 +1394,22 @@ int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
 }
 EXPORT_SYMBOL_GPL(trace_vprintk);
 
+static int __trace_puts(unsigned long ip, ...)
+{
+	va_list ap;
+	int ret;
+
+	va_start(ap, ip);
+	ret = trace_vprintk(ip, "%s", ap);
+	va_end(ap);
+	return ret;
+}
+
+static int trace_puts(unsigned long ip, const char *str)
+{
+	return __trace_puts(ip, str);
+}
+
 enum trace_file_type {
 	TRACE_FILE_LAT_FMT	= 1,
 	TRACE_FILE_ANNOTATE	= 2,
@@ -3346,7 +3358,7 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 	} else
 		buf[cnt] = '\0';
 
-	cnt = trace_vprintk(0, buf, NULL);
+	cnt = trace_puts(0, buf);
 	kfree(buf);
 	*fpos += cnt;
 
