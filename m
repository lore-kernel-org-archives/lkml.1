Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbZLIEUC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbZLIEUC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 23:20:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756732AbZLIET4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 23:19:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43241 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756670AbZLIETy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 23:19:54 -0500
X-Authority-Analysis: v=1.0 c=1 a=OAfDgOSDqgIA:10 a=7U3hwN5JcxgA:10 a=VwQbUJbxAAAA:8 a=D_SbEOMbAAAA:8 a=6zb38KopAAAA:8 a=meVymXHHAAAA:8 a=x-BYS2PKu1VL1BC2tboA:9 a=xmIU1i8davpO3SCJ1VwA:7 a=ejSfqrGq-vV8SUcSdZhUwIZ7kVIA:4 a=7KbvKZvEaC0A:10 a=D-PNlr3aaKoA:10 a=jeBq3FmKZ4MA:10 a=SQjbjRMzJwi4kYaS:21 a=5xnOtGUZNsdc-VTJ:21
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: [PATCH][GIT PULL][v2.6.33] tracing: Remove comparing of NULL to
 va_list in trace_array_vprintk()
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Carsten Emde <Carsten.Emde@osadl.org>, Olof Johansson <olof@lixom.net>,
       hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4B1BAB74.104@osadl.org>
References: <4B01AE5D.1010801@osadl.org>
	 <tip-c13d2f7c3231e873f30db92b96c8caa48f100f33@git.kernel.org>
	 <20091206051352.GA4628@lixom.net>  <4B1BAB74.104@osadl.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 08 Dec 2009 23:19:57 -0500
Message-ID: <1260332397.2146.38.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo,

This is an urgent fix that fixes a ARM build breakage. It is based on
the last pull request I had that fixes the function graph tracer output.


Ingo,

Please pull the latest tip/tracing/core2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core2


Carsten Emde (1):
      tracing: Remove comparing of NULL to va_list in trace_array_vprintk()

----
 kernel/trace/trace.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)
---------------------------
commit efcf61abeb355273bc8933faf426adc366b23153
Author: Carsten Emde <Carsten.Emde@osadl.org>
Date:   Sun Dec 6 14:02:44 2009 +0100

    tracing: Remove comparing of NULL to va_list in trace_array_vprintk()
    
    Olof Johansson stated the following:
    
      Comparing a va_list with NULL is bogus. It's supposed to be treated like
      an opaque type and only be manipulated with va_* accessors.
    
    Olof noticed that this code broke the ARM builds:
    
        kernel/trace/trace.c: In function 'trace_array_vprintk':
        kernel/trace/trace.c:1364: error: invalid operands to binary == (have 'va_list' and 'void *')
        kernel/trace/trace.c: In function 'tracing_mark_write':
        kernel/trace/trace.c:3349: error: incompatible type for argument 3 of 'trace_vprintk'
    
    This patch partly reverts c13d2f7c3231e873f30db92b96c8caa48f100f33 and
    re-installs the original mark_printk() mechanism.
    
    Reported-by: Olof Johansson <olof@lixom.net>
    Signed-off-by: Carsten Emde <C.Emde@osadl.org>
    LKML-Reference: <4B1BAB74.104@osadl.org>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 596dcf2..bf84e1a 100644
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
@@ -3353,6 +3349,16 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 	return cnt;
 }
 
+static int mark_printk(const char *fmt, ...)
+{
+	int ret;
+	va_list args;
+	va_start(args, fmt);
+	ret = trace_vprintk(0, fmt, args);
+	va_end(args);
+	return ret;
+}
+
 static ssize_t
 tracing_mark_write(struct file *filp, const char __user *ubuf,
 					size_t cnt, loff_t *fpos)
@@ -3379,7 +3385,7 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 	} else
 		buf[cnt] = '\0';
 
-	cnt = trace_vprintk(0, buf, NULL);
+	cnt = mark_printk("%s", buf);
 	kfree(buf);
 	*fpos += cnt;
 


