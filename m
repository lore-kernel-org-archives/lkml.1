Return-Path: <linux-kernel-owner+w=401wt.eu-S1764371AbYBLX5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764371AbYBLX5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:57:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761978AbYBLX4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:56:54 -0500
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:49585 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763472AbYBLX4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:56:52 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAJLBsUdMQWYv/2dsb2JhbACBWat5gXA
Date: Tue, 12 Feb 2008 18:56:50 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] spufs support multiple probes markers
Message-ID: <20080212235650.GA23693@Krystal>
References: <20080212152245.2d816143.akpm@linux-foundation.org> <20080212233914.GA22966@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080212233914.GA22966@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:52:42 up 1 day, 19:53,  3 users,  load average: 2.51, 0.66,
	0.47
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> * Andrew Morton (akpm@linux-foundation.org) wrote:
> > 
> > fyi, I have this on hold because I spotted spufs build breakage,
> > but I haven't had time to investigate.  powerpc allmodconfig, iirc.
> 
> Christoph told me he would update his sputrace accordingly. Christoph,
> should I do the changes or let you do it ?
> 
> It's mostly the probe function prototype which changes from 
> 
> -typedef void marker_probe_func(const struct marker *mdata,
> -       void *private_data, const char *fmt, ...);
> 
> to
> 
> +typedef void marker_probe_func(void *probe_private, void *call_private,
> +               const char *fmt, va_list *args);
> 
> Where you receive an already ready va_list instead of having to call
> va_start/va_end in the probe.
> 
> Also, there is no more marker_arm/marker_disarm. It is now automatically
> done upon register/unregister.
> 
> Mathieu
> 

Update spufs to the new linux kernel markers API, which supports connecting
more than one probe to a single marker.

(compile-tested only)

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Christoph Hellwig <hch@infradead.org>
CC: "Frank Ch. Eigler" <fche@redhat.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 arch/powerpc/platforms/cell/spufs/sputrace.c |   31 +++++++++------------------
 1 file changed, 11 insertions(+), 20 deletions(-)

Index: linux-2.6-lttng/arch/powerpc/platforms/cell/spufs/sputrace.c
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/platforms/cell/spufs/sputrace.c	2008-02-12 15:07:25.000000000 -0500
+++ linux-2.6-lttng/arch/powerpc/platforms/cell/spufs/sputrace.c	2008-02-12 15:11:39.000000000 -0500
@@ -146,34 +146,28 @@
 	wake_up(&sputrace_wait);
 }
 
-static void spu_context_event(const struct marker *mdata,
-		void *private, const char *format, ...)
+static void spu_context_event(void *probe_private, void *call_data,
+		const char *format, va_list *args)
 {
-	struct spu_probe *p = mdata->private;
-	va_list ap;
+	struct spu_probe *p = probe_private;
 	struct spu_context *ctx;
 	struct spu *spu;
 
-	va_start(ap, format);
-	ctx = va_arg(ap, struct spu_context *);
-	spu = va_arg(ap, struct spu *);
+	ctx = va_arg(*args, struct spu_context *);
+	spu = va_arg(*args, struct spu *);
 
 	sputrace_log_item(p->name, ctx, spu);
-	va_end(ap);
 }
 
-static void spu_context_nospu_event(const struct marker *mdata,
-		void *private, const char *format, ...)
+static void spu_context_nospu_event(void *probe_private, void *call_data,
+		const char *format, va_list *args)
 {
-	struct spu_probe *p = mdata->private;
-	va_list ap;
+	struct spu_probe *p = probe_private;
 	struct spu_context *ctx;
 
-	va_start(ap, format);
-	ctx = va_arg(ap, struct spu_context *);
+	ctx = va_arg(*args, struct spu_context *);
 
 	sputrace_log_item(p->name, ctx, NULL);
-	va_end(ap);
 }
 
 struct spu_probe spu_probes[] = {
@@ -219,10 +213,6 @@
 		if (error)
 			printk(KERN_INFO "Unable to register probe %s\n",
 					p->name);
-
-		error = marker_arm(p->name);
-		if (error)
-			printk(KERN_INFO "Unable to arm probe %s\n", p->name);
 	}
 
 	return 0;
@@ -238,7 +228,8 @@
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(spu_probes); i++)
-		marker_probe_unregister(spu_probes[i].name);
+		marker_probe_unregister(spu_probes[i].name,
+			spu_probes[i].probe_func, &spu_probes[i]);
 
 	remove_proc_entry("sputrace", NULL);
 	kfree(sputrace_log);


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
