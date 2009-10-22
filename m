Return-Path: <linux-kernel-owner+w=401wt.eu-S1755259AbZJVMKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbZJVMKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 08:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbZJVMKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 08:10:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbZJVMKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 08:10:50 -0400
Date: Thu, 22 Oct 2009 14:09:58 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] tracing: fix trace_seq_printf return value
Message-ID: <20091022120958.GB2311@jolsa.redhat.com>
References: <1256135801-1849-1-git-send-email-jolsa@redhat.com> <1256135801-1849-3-git-send-email-jolsa@redhat.com> <1256142035.18347.3133.camel@gandalf.stny.rr.com> <20091021220204.GA2462@jolsa.redhat.com> <1256163247.18347.3544.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256163247.18347.3544.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 21, 2009 at 06:14:07PM -0400, Steven Rostedt wrote:
> On Thu, 2009-10-22 at 00:02 +0200, Jiri Olsa wrote:
> > On Wed, Oct 21, 2009 at 12:20:35PM -0400, Steven Rostedt wrote:
> > > On Wed, 2009-10-21 at 16:36 +0200, Jiri Olsa wrote:
> > > > I believe we want to return the number of written characters,
> > > > instead of the available buffer length.
> > > > 
> > > > wbr,
> > > > jirka
> > > > 
> > > > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > > > ---
> > > >  kernel/trace/trace_output.c |    2 +-
> > > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > > 
> > > > diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
> > > > index ed17565..e871125 100644
> > > > --- a/kernel/trace/trace_output.c
> > > > +++ b/kernel/trace/trace_output.c
> > > > @@ -95,7 +95,7 @@ trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
> > > >  
> > > >  	s->len += ret;
> > > >  
> > > > -	return len;
> > > > +	return ret;
> > > 
> > > Actually the return value here is ambiguous. Returning len is actually
> > > safer. It probably should only return 0 (buffer not big enough to write
> > > to) or 1 (buffer is big enough).
> > > 
> > > Because this should actually return non zero:
> > > 
> > >   trace_seq_printf(s, "");
> > > 
> > > -- Steve
> > > 
> > > >  }
> > > >  EXPORT_SYMBOL_GPL(trace_seq_printf);
> > > >  
> > >
> > 
> > I made the suggested fix, plus spot not used function.
> > 
> > ---
> > Making trace_seq_printf return 0 if the trace oversizes the buffer's free
> > space, 1 otherwise.  Removing not used trace_seq_vprintf function.
> 
> err, I hate to remove that function. This is a utility file that is
> exported for other parts of the kernel to use. At least make that a
> separate patch.
np, sending out just the first part

jirka

---

Making trace_seq_printf return 0 if the trace oversizes the buffer's free
space, 1 otherwise.

wbr,
jirka

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index ed17565..b6c12c6 100644
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
@@ -95,7 +98,7 @@ trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 
 	s->len += ret;
 
-	return len;
+	return 1;
 }
 EXPORT_SYMBOL_GPL(trace_seq_printf);
 
