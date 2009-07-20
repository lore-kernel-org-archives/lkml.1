Return-Path: <linux-kernel-owner+w=401wt.eu-S1752924AbZGTR0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbZGTR0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 13:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbZGTR0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 13:26:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44916 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbZGTR0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 13:26:12 -0400
Date: Mon, 20 Jul 2009 13:26:10 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] tracing: use defined fields to print formats
In-Reply-To: <4A5F38F9.7060002@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0907201319190.7595@gandalf.stny.rr.com>
References: <4A5F38F9.7060002@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 16 Jul 2009, Lai Jiangshan wrote:

> 
> It seems that ftrace_format_##call() and ftrace_define_fields_##call()
> are duplicate more or less.
> 
> trace_define_field() defines fields and links them into
> strcut ftrace_event_call. We reuse them to print formats
> and remove ftrace_format_##call(). It make all things simpler.
> 
> TRACE_EVENT_FORMAT_NOFILTER is dropped. Because we should
> "trace_define_field()" fields for all struct ftrace_event_call,
> even it's no filter.

OK, I added this and did a diff of the formats before this patch and 
after the patch. Here they are (with a lot of duplicats cut out).

[
  '<' represents the old format
  '>' represents the new format (with patch applied)
]

4c4
< 	field:unsigned short common_type;	offset:0;	size:2;
---
> 	field:int common_type;	offset:0;	size:2;

We changed the common type from "unsigned short" to "int"?

45,46c45,46
< 	field:char rwbs[6];	offset:32;	size:6;
< 	field:char comm[TASK_COMM_LEN];	offset:38;	size:16;
---
> 	field:char[6] rwbs;	offset:32;	size:6;
> 	field:char[TASK_COMM_LEN] comm;	offset:38;	size:16;

I have several parsers that expect the '[6]' to come after the 
declaration.


390c390
< print fmt: "type:%u call_site:%lx ptr:%p"
---
> print fmt: type:%u call_site:%lx ptr:%p

The 'ftrace' events lost their quotes around the print format.

394c394
< 	field:unsigned short common_type;	offset:0;	size:2;
---
> 	field:unsigned char common_type;	offset:0;	size:2;

And the ftrace events also now use "unsigned char" for the common_type 
instead of unsigned short?


408c408
< print fmt: "type:%u call_site:%lx ptr:%p req:%lu alloc:%lu flags:%x node:%d"
---
> print fmt: type:%u call_site:%lx ptr:%p req:%lu alloc:%lu flags:%x node:%d

423c423
< print fmt: "%llx->%llx type:%u state:%u"
---
> print fmt: %llx->%llx type:%u state:%u

436c436
< print fmt: "from: %llx to: %llx"
---
> print fmt: from: %llx to: %llx


Lots more quotes missing (I'll cut out the rest of the diff of quotes 
missing).

447,448c447,448
< 	field special:char func[TRACE_FUNC_SIZE+1];	offset:16;	size:31;
< 	field special:char file[TRACE_FUNC_SIZE+1];	offset:47;	size:21;
---
> 	field:char func[TRACE_FUNC_SIZE+1][TRACE_FUNC_SIZE+1] func;	offset:16;	size:31;
> 	field:char file[TRACE_FUNC_SIZE+1][TRACE_FUNC_SIZE+1] file;	offset:47;	size:21;

This is interesting.


> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

I really like the clean up this patch does, but it must not modify the 
current format of the files unless there is a really good reason to do so.

Thanks,

-- Steve
