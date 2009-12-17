Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbZLQPvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbZLQPvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 10:51:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbZLQPve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 10:51:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55822 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbZLQPvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 10:51:33 -0500
X-Authority-Analysis: v=1.0 c=1 a=n6DixmMQ78wA:10 a=7U3hwN5JcxgA:10 a=VnNF1IyMAAAA:8 a=bN9ah6iaku8DJRTz7uAA:9 a=4zK8p5Ha8P8IqmXaoa0A:7 a=vpi6jqkqD0f2fytAzQfTsuCfMHsA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 2/2 V2] tracecmd: Start of a tracecmd swig wrapper for
 python
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Darren Hart <dvhltc@us.ibm.com>
Cc: "lkml," <linux-kernel@vger.kernel.org>
In-Reply-To: <4B2A0539.3040401@us.ibm.com>
References: <4B297C79.2090004@us.ibm.com> <4B297CE3.6040600@us.ibm.com>
	 <4B2A0539.3040401@us.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 17 Dec 2009 10:51:30 -0500
Message-ID: <1261065090.2146.470.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-17 at 02:17 -0800, Darren Hart wrote:
> >From bae09bb458b68d152c5fd353fa0797a52207c2b1 Mon Sep 17 00:00:00 2001
> From: Darren Hart <dvhltc@us.ibm.com>
> Date: Wed, 16 Dec 2009 15:25:30 -0800
> Subject: [PATCH 2/2 V2] tracecmd: Start of a tracecmd swig wrapper for python
> 
> Introduce a python tracecmd module for use in rapidly prototyping
> tracing applications. The interface description is provided in
> tracecmd.i, it identifies which functions are available from within
> python. A test python script is provided as tracecmd-test.py.
> 
> These bindings are expected to change significantly. Eventually I
> would like to wrap this automated binding with more pythonic objects,
> most likely including Trace and Event objects which merge the
> functionality of tracecmd-input, pevent, record, and event structures.
> This will make development of python apps much more accessible to many
> application developers.
> 
> For now, this is mostly a proof of concept and is no where near
> complete. It can however open a trace file and read all the events from
> it, displaying them by CPU in chronological order.
> 
> V2: simplified interface file with some SWIG ifdefs in the header files
> 
> Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
> ---
>  parse-events.h   |    9 +++++++++
>  swig.sh          |   19 +++++++++++++++++++
>  trace-cmd.h      |    2 ++
>  tracecmd-test.py |   38 ++++++++++++++++++++++++++++++++++++++
>  tracecmd.i       |   12 ++++++++++++
>  5 files changed, 80 insertions(+), 0 deletions(-)
>  create mode 100755 swig.sh
>  create mode 100755 tracecmd-test.py
>  create mode 100644 tracecmd.i
> 
> diff --git a/parse-events.h b/parse-events.h
> index e6f5806..0d68f23 100644
> --- a/parse-events.h
> +++ b/parse-events.h
> @@ -42,6 +42,8 @@ trace_seq_init(struct trace_seq *s)
>  	s->full = 0;
>  }
>  
> +/* SWIG doesn't like the __attribute__, don't export trace_seq to python */

Perhaps we should do something like:

#ifdef SWIG
# define __print_attribute(x)
#else
# define __print_attribute(x) __attribute__ ((x))
#endif

and here we can do:

extern int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
	__print_attribute(format (printf, 2, 3));

> +#ifndef SWIG
>  extern int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
>  	__attribute__ ((format (printf, 2, 3)));
>  extern int trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
> @@ -53,6 +55,7 @@ extern int trace_seq_putc(struct trace_seq *s, unsigned char c);
>  extern void trace_seq_terminate(struct trace_seq *s);
>  
>  extern int trace_seq_do_printf(struct trace_seq *s);
> +#endif
>  
> 
>  /* ----------------------- pevent ----------------------- */
> @@ -275,7 +278,10 @@ struct pevent {
>  	struct format_field *bprint_buf_field;
>  };
>  
> +/* this doesn't appear to be defined anywhere... */
> +#ifndef SWIG
>  void parse_set_info(struct pevent *pevent, int nr_cpus, int long_sz);
> +#endif

Ug, that's leftover. You can just delete it.

>  
>  void die(char *fmt, ...);
>  void *malloc_or_die(unsigned int size);
> @@ -374,8 +380,11 @@ struct event *pevent_find_event(struct pevent *pevent, int id);
>  struct event *
>  pevent_find_event_by_name(struct pevent *pevent, const char *sys, const char *name);
>  
> +/* SWIG doesn't like __unused */
> +#ifndef SWIG
>  void pevent_data_lat_fmt(struct pevent *pevent,
>  			 struct trace_seq *s, void *data, int size __unused);
> +#endif

Again, we should put an #ifdef  SWIG around the definition of __unused.

>  int pevent_data_type(struct pevent *pevent, struct record *rec);
>  struct event *pevent_data_event_from_type(struct pevent *pevent, int type);
>  int pevent_data_pid(struct pevent *pevent, struct record *rec);
> diff --git a/swig.sh b/swig.sh
> new file mode 100755
> index 0000000..9a77ec2
> --- /dev/null
> +++ b/swig.sh
> @@ -0,0 +1,19 @@
> +#!/bin/sh
> +
> +# Temporary hack of a build script, eventually we'll incoroporate this
> +# into the Makefile. You may have to update the includes to point to your
> +# python installation.
> +
> +rm tracecmd_wrap.c tracecmd_wrap.o _tracecmd.so &> /dev/null
> +
> +swig -Wall -python tracecmd.i
> +
> +gcc -fpic -c  -I/usr/include/python2.6/ -I/usr/lib/python2.6/config \
> +    parse_events.c trace-read.c trace-output.c trace-cmd.c \
> +    trace-record.c trace-input.c tracecmd_wrap.c
> +
> +gcc -shared trace-ftrace.o trace-seq.o trace-util.o \
> +    parse-events.o trace-read.o trace-output.o trace-cmd.o \
> +    trace-record.o trace-input.o tracecmd_wrap.o \
> +    -o _tracecmd.so
> +
> diff --git a/trace-cmd.h b/trace-cmd.h
> index 1c4d359..6f645c5 100644
> --- a/trace-cmd.h
> +++ b/trace-cmd.h
> @@ -83,8 +83,10 @@ int tracecmd_set_cpu_to_timestamp(struct tracecmd_input *handle,
>  int tracecmd_ftrace_overrides(struct tracecmd_input *handle);
>  struct pevent *tracecmd_get_pevent(struct tracecmd_input *handle);
>  
> +#ifndef SWIG
>  /* hack for function graph work around */
>  extern __thread struct tracecmd_input *tracecmd_curr_thread_handle;

Same for __thread

> +#endif
>  
> 
>  /* --- Creating and Writing the trace.dat file --- */
> diff --git a/tracecmd-test.py b/tracecmd-test.py
> new file mode 100755
> index 0000000..dd0a583
> --- /dev/null
> +++ b/tracecmd-test.py
> @@ -0,0 +1,38 @@
> +#!/usr/bin/env python
> +
> +from tracecmd import *
> +# import the struct_member_get() wrappers
> +from _tracecmd import *
> +
> +# Let's move the following into a new Trace object constructor
> +filename = "trace.dat"
> +trace_file = open(filename)
> +handle = tracecmd_open(trace_file.fileno())
> +tracecmd_read_headers(handle)
> +tracecmd_init_data(handle)
> +
> +# These should be members, i.e. Trace.cpus
> +pe = tracecmd_get_pevent(handle)
> +cpus = tracecmd_cpus(handle)
> +print "Trace %s contains data for %d cpus" % (filename, cpus) 
> +
> +# FIXME: this doesn't print anything...
> +tracecmd_print_events(handle)
> +
> +print "Cycling through the events for each CPU"
> +for cpu in range(0,cpus):
> +    print "CPU", cpu
> +    rec = tracecmd_read_data(handle, cpu)
> +    while True:
> +        if rec:
> +            # these should be members of a Record object
> +            pid = pevent_data_pid(pe, rec)
> +            comm = pevent_data_comm_from_pid(pe, pid)
> +            type = pevent_data_type(pe, rec)
> +            event = pevent_data_event_from_type(pe, type)
> +            print "\t%f %s: pid=%d comm=%s type=%d" % \
> +                  (record_ts_get(rec), event_name_get(event), pid, comm, type)
> +
> +            rec = tracecmd_read_data(handle, cpu)
> +        else:
> +            break
> diff --git a/tracecmd.i b/tracecmd.i
> new file mode 100644
> index 0000000..0245552
> --- /dev/null
> +++ b/tracecmd.i
> @@ -0,0 +1,12 @@
> +// tracecmd.i
> +%module tracecmd
> +
> +%{
> +#include "trace-cmd.h"
> +%}
> +
> +%inline %{
> +%}
> +
> +%include "trace-cmd.h"
> +%include "parse-events.h"

Otherwise, looks good!

-- Steve


