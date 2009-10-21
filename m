Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbZJUWCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbZJUWCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 18:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754924AbZJUWCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 18:02:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754726AbZJUWCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 18:02:23 -0400
Date: Thu, 22 Oct 2009 00:02:04 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] tracing: fix trace_seq_printf return value
Message-ID: <20091021220204.GA2462@jolsa.redhat.com>
References: <1256135801-1849-1-git-send-email-jolsa@redhat.com> <1256135801-1849-3-git-send-email-jolsa@redhat.com> <1256142035.18347.3133.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256142035.18347.3133.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 21, 2009 at 12:20:35PM -0400, Steven Rostedt wrote:
> On Wed, 2009-10-21 at 16:36 +0200, Jiri Olsa wrote:
> > I believe we want to return the number of written characters,
> > instead of the available buffer length.
> > 
> > wbr,
> > jirka
> > 
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > ---
> >  kernel/trace/trace_output.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
> > index ed17565..e871125 100644
> > --- a/kernel/trace/trace_output.c
> > +++ b/kernel/trace/trace_output.c
> > @@ -95,7 +95,7 @@ trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
> >  
> >  	s->len += ret;
> >  
> > -	return len;
> > +	return ret;
> 
> Actually the return value here is ambiguous. Returning len is actually
> safer. It probably should only return 0 (buffer not big enough to write
> to) or 1 (buffer is big enough).
> 
> Because this should actually return non zero:
> 
>   trace_seq_printf(s, "");
> 
> -- Steve
> 
> >  }
> >  EXPORT_SYMBOL_GPL(trace_seq_printf);
> >  
>

I made the suggested fix, plus spot not used function.

---
Making trace_seq_printf return 0 if the trace oversizes the buffer's free
space, 1 otherwise.  Removing not used trace_seq_vprintf function.

wbr,
jirka

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 include/linux/trace_seq.h   |    2 --
 kernel/trace/trace_output.c |   37 ++++---------------------------------
 2 files changed, 4 insertions(+), 35 deletions(-)

diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index c134dd1..6fc4651 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -29,8 +29,6 @@ trace_seq_init(struct trace_seq *s)
 #ifdef CONFIG_TRACING
 extern int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 	__attribute__ ((format (printf, 2, 3)));
-extern int trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
-	__attribute__ ((format (printf, 2, 0)));
 extern int
 trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary);
 extern void trace_print_seq(struct seq_file *m, struct trace_seq *s);
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index ed17565..11bd0e5 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -69,6 +69,9 @@ enum print_line_t trace_print_printk_msg_only(struct trace_iterator *iter)
  * @s: trace sequence descriptor
  * @fmt: printf format string
  *
+ * It returns 0 if the trace oversizes the buffer's free
+ * space, 1 otherwise.
+ *
  * The tracer may use either sequence operations or its own
  * copy to user routines. To simplify formating of a trace
  * trace_seq_printf is used to store strings into a special
@@ -95,42 +98,10 @@ trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 
 	s->len += ret;
 
-	return len;
+	return 1;
 }
 EXPORT_SYMBOL_GPL(trace_seq_printf);
 
-/**
- * trace_seq_vprintf - sequence printing of trace information
- * @s: trace sequence descriptor
- * @fmt: printf format string
- *
- * The tracer may use either sequence operations or its own
- * copy to user routines. To simplify formating of a trace
- * trace_seq_printf is used to store strings into a special
- * buffer (@s). Then the output may be either used by
- * the sequencer or pulled into another buffer.
- */
-int
-trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
-{
-	int len = (PAGE_SIZE - 1) - s->len;
-	int ret;
-
-	if (!len)
-		return 0;
-
-	ret = vsnprintf(s->buffer + s->len, len, fmt, args);
-
-	/* If we can't write it all, don't bother writing anything */
-	if (ret >= len)
-		return 0;
-
-	s->len += ret;
-
-	return len;
-}
-EXPORT_SYMBOL_GPL(trace_seq_vprintf);
-
 int trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
 {
 	int len = (PAGE_SIZE - 1) - s->len;
 
