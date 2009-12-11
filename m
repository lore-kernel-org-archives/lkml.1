Return-Path: <linux-kernel-owner+w=401wt.eu-S1755071AbZLKDEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbZLKDEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 22:04:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbZLKDEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 22:04:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55544 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbZLKDEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 22:04:33 -0500
X-Authority-Analysis: v=1.0 c=1 a=nFhjYqsp-egA:10 a=7U3hwN5JcxgA:10 a=omOdbC7AAAAA:8 a=bpbDTeYapZeK2qlEkgkA:9 a=_Zy3LV5AFZAh7Sg2yogA:7 a=yXUBHRyz27nPrWaViYcEDVOM8f0A:4 a=LvAoGXetm6j9ApYY:21 a=5gDhQM8kU3Frybk_:21
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 07/10] trace_syscalls: init print_fmt
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B21B172.2080500@cn.fujitsu.com>
References: <4B1F4EA6.5080105@cn.fujitsu.com>
	 <1260491698.2146.322.camel@gandalf.stny.rr.com>
	 <4B21B172.2080500@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 10 Dec 2009 22:04:30 -0500
Message-ID: <1260500670.2146.337.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-11 at 10:41 +0800, Lai Jiangshan wrote:
> Steven Rostedt wrote:
> > On Wed, 2009-12-09 at 15:15 +0800, Lai Jiangshan wrote:
> >> Init print_fmt for trace_syscalls.
> >> It will be used for replacing ->show_format().
> > 
> > This needs more explanation too.
> > 
> >> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> >> ---
> >> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> >> index 75289f3..dcd8699 100644
> >> --- a/kernel/trace/trace_syscalls.c
> >> +++ b/kernel/trace/trace_syscalls.c
> >> @@ -191,6 +191,61 @@ int syscall_enter_format(struct ftrace_event_call *call, struct trace_seq *s)
> >>  	return trace_seq_putc(s, '\n');
> >>  }
> >>  
> >> +static
> >> +int  __set_enter_print_fmt(struct syscall_metadata *entry, char *buf, int len)
> >> +{
> >> +	int i;
> >> +	int pos = 0;
> >> +
> >> +	pos += snprintf(buf + pos, len > pos ? len - pos : 0, "\"");
> >> +	for (i = 0; i < entry->nb_args; i++) {
> >> +		pos += snprintf(buf + pos, len > pos ? len - pos : 0,
> >> +				"%s: 0x%%0%zulx%s", entry->args[i],
> >> +				sizeof(unsigned long),
> >> +				i == entry->nb_args - 1 ? "" : ", ");
> >> +	}
> >> +	pos += snprintf(buf + pos, len > pos ? len - pos : 0, "\"");
> >> +
> >> +	for (i = 0; i < entry->nb_args; i++) {
> >> +		pos += snprintf(buf + pos, len > pos ? len - pos : 0,
> >> +				", ((unsigned long)(REC->%s))", entry->args[i]);
> > 
> > Yuck! 4 snprintf(buf + pos, len > pos ? len - pos: 0 ...
> > 
> > Please make a wrapper for that.
> 
> Do you mind if I use a macro?
> Readability are still the same... 
> 
> static
> int  __set_enter_print_fmt(struct syscall_metadata *entry, char *buf, int len)
> {
> 	int i;
> 	int pos = 0;
> 
> #define BUF_PRINTF(fmt...)						\
> do {									\
> 	pos += snprintf(buf + pos, len > pos ? len - pos : 0, fmt);	\
> } while (0)
> 
> 	BUF_PRINTF("\"");
> 	for (i = 0; i < entry->nb_args; i++) {
> 		BUF_PRINTF("%s: 0x%%0%zulx%s", entry->args[i],
> 				sizeof(unsigned long),
> 				i == entry->nb_args - 1 ? "\"" : ", ");
> 	}
> 
> 	for (i = 0; i < entry->nb_args; i++)
> 		BUF_PRINTF(", ((unsigned long)(REC->%s))", entry->args[i]);
> 
> #under BUF_PRINTF
> 
> 	/* return the length of print_fmt */
> 	return pos;
> }
> 
> > 
> > Actually, this could use the new trace_seq code if I separate the
> > buffer. You would just need to do:
> > 
> > 	struct trace_seq s;
> 
> I think trace_seq can not help.
> __set_enter_print_fmt() is called twice.
> We calculate the length at the first time(don't write any thing),
> then allocate memory and then really "snprintf" string into the buffer.
> 

Oh God, I see what you are doing. Too many side effects here.

This code needs major comments. Anyway, you already calculated the
length that is needed, you can just do "len ? len - pos : 0".

First, please comment what it is doing (that it gets called twice, once
with 0 length to calculate the needed length and once with the
calculated length).

Then just make the test a macro:

#define LEN_OR_ZERO (len ? len - pos : 0)

	pos += snprintf(buf + pos, LEN_OR_ZERO, fmt);

...

#undef LEN_OR_ZERO


With comments explaining what is happening and this macro, it can make
reading the code a bit easier to understand what is going on.

-- Steve




> -- Lai
> 
> > 
> > 	trace_seq_init(&s, buf, len);
> > 
> > 	trace_seq_putc(&s, '"');
> > 	for (i = 0; i < entry->nb_args; i++)
> > 		trace_seq_printf(&s, "%s: 0x%%0%zulx%s", entry->args[i],
> > 				sizeof(unsigned long),
> > 				i == entry->nb_args - 1 ? "" : ", ");
> > 
> > 	trace_seq_putc(&s, '"');
> > 
> > 	for (i = 0; i < entry->nb_args; i++)
> > 		trace_seq_printf(&s, ", ((unsigned long)(REC->%s)",
> > 				entry->args[i]);
> > 
> > 	return s.len;
> > 
> > 
> > Looks much better, and less error prone.
> > 
> > -- Steve
> > 


