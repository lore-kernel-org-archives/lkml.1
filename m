Return-Path: <linux-kernel-owner+w=401wt.eu-S1752281AbYKNLVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281AbYKNLVd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 06:21:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbYKNLVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 06:21:23 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:45544 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbYKNLVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 06:21:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xYb7Kh7TupumgG+En6QvhNCU2odbPsK+QKa1UnJJv8REbvZX+NSFmawkSM//cblfnk
         lhqbKFGsvlKNAjnnvAz6pzgdx7eUuSvJWRs/xwSungEipL9lgV5YOUsjAFNqMh22WTJN
         bmfaLrpKOCB4UxWG3g7HoX/ZUZ3X8U0fiTNx4=
Message-ID: <c62985530811140321p481354f9j489955c1e9ee1f3f@mail.gmail.com>
Date: Fri, 14 Nov 2008 12:21:20 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] ftrace: Add debug_print trace to print data from kernel to userspace
Cc: rostedt@goodmis.org, mingo@elte.hu, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1226659566-28168-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226659566-28168-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1226659566-28168-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Aneesh!

2008/11/14 Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>:
> The trace add a new interface debug_print() which can be used
> to dump data from kernel to user space using ftrace framework.


The actual "nop tracer" which is the default selected (if trace_boot
is not configured) let
the tracing engine able to receive and handle TRACE_PRINT events.
Even if nop tracer doesn't handle its output itself, the TRACE_PRINT
event output is relayed by
print_trace_fmt() in trace.c

Your output does almost the same but it is already implemented.



> +static void dp_trace_ctrl_update(struct trace_array *tr)
> +{
> +       /* When starting a new trace, reset the buffers */
> +       if (tr->ctrl)
> +               start_dp_trace(tr);
> +       else
> +               stop_dp_trace(tr);
> +}


BTW, ctrl_update() have been removed very recently.
Perhaps are you implementing this against the mainline? Its a better idea to
submit a new tracer against latest -tip tree.

> +
> +#ifdef CONFIG_NOP_TRACER
> +int
> +trace_selftest_startup_dp(struct tracer *trace, struct trace_array *tr)
> +{
> +       /* What could possibly go wrong? */
> +       return 0;
> +}
> +#endif


CONFIG_NOP_TRACER ?
Wouldn't it rather depend on CONFIG_FTRACE_SELFTEST? :-)

That would perhaps have been better to raise a ftrace_printk to make a test.
If you don't do anything in your selftest, then it is unnecessary to
implement one for
your tracer.


> +static enum print_line_t debug_print_line(struct trace_iterator *iter)
> +{
> +       struct trace_seq *s = &iter->seq;
> +       struct trace_entry *entry;
> +
> +       entry = iter->ent;
> +       switch (entry->type) {
> +       case TRACE_PRINT: {
> +               struct print_entry *field;
> +               trace_assign_type(field, entry);
> +
> +               trace_seq_printf(s, "%s", field->buf);
> +               if (entry->flags & TRACE_FLAG_CONT)
> +                       trace_seq_print_cont(s, iter);
> +               break;


You should test if trace_seq_printf successed to print the whole line.
If not, that's better to return TRACE_TYPE_PARTIAL_LINE, then the
output will be retried later.



> +       }
> +       default:
> +               printk(KERN_INFO "Unsupported type in debug_print\n");
> +               return TRACE_TYPE_UNHANDLED;
> +       }
> +
> +       return TRACE_TYPE_HANDLED;
> +}
> +
> +struct tracer dp_trace __read_mostly =
> +{
> +       .name           = "debug_print",
> +       .init           = dp_trace_init,
> +       .reset          = dp_trace_reset,
> +       .ctrl_update    = dp_trace_ctrl_update,
> +#ifdef CONFIG_FTRACE_SELFTEST
> +       .selftest       = trace_selftest_startup_dp,
> +#endif
> +       .print_line     = debug_print_line,
> +};
> +
> +__init static int init_dp_trace(void)
> +{
> +       return register_tracer(&dp_trace);
> +}
> +device_initcall(init_dp_trace);


Primarily, such a debug tracer is not a bad idea, IMHO.
And note that all of I just wrote in this answer in only my opinion.
Perhaps other people
would find other uses of this tracer that actual default output of the
tracing engine doesn't handle well, or trace.c is
would not be the right place for further enhancements that could
happen on debug entries if you need to.

But the actual simple output that you are submitting along this tracer
is already handled by the default output of the tracing internals.
