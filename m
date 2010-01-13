Return-Path: <linux-kernel-owner+w=401wt.eu-S1756649Ab0AMXge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab0AMXge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 18:36:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756638Ab0AMXgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 18:36:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61472 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577Ab0AMXgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 18:36:31 -0500
X-Authority-Analysis: v=1.0 c=1 a=g2MyM69NJrgA:10 a=7U3hwN5JcxgA:10 a=nUN8mt6XobZj91-GOjUA:9 a=TsIIgr700hBpY5sEwjgA:7 a=D60AG33OuecLzq4EmG1fIbEq5HIA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC] [PATCH 7/7] Ftrace plugin for Uprobes
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Maneesh Soni <maneesh@in.ibm.com>,
       Mark Wielaard <mjw@redhat.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B4E4551.2010302@redhat.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122608.22050.94088.sendpatchset@srikar.in.ibm.com>
	 <20100112045454.GJ5243@nowhere>
	 <1263272933.28171.3804.camel@gandalf.stny.rr.com>
	 <4B4E41FF.4020800@redhat.com>  <4B4E4551.2010302@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 13 Jan 2010 18:36:27 -0500
Message-ID: <1263425787.28171.3830.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-13 at 17:12 -0500, Masami Hiramatsu wrote:
> Masami Hiramatsu wrote:
> > Steven Rostedt wrote:
> >> On Tue, 2010-01-12 at 05:54 +0100, Frederic Weisbecker wrote:
> >>
> >>> Now what if I want to launch ls and want to profile a function
> >>> inside. What can I do with a trace event. I can't create the
> >>> probe event based on a pid as I don't know it in advance.
> >>> I could give it the ls cmdline and it manages to activate
> >>> on the next ls launched. This is racy as another ls can
> >>> be launched concurrently.
> >>
> >> You make a wrapper script:
> >>
> >> #!/bin/sh
> >> <add probe to ls with pid> $$
> >> exec $*
> >>
> >> I do this all the time to limit the function tracer to a specific app.
> >>
> >> #!/bin/sh
> >> echo $$ > /debug/tracing/set_ftrace_pid
> >> echo function > /debug/tracing/current_tracer
> >> exec $*
> > 
> > I recommend you to add below line at the end of the script,
> > from my experience. :)
> > 
> > echo nop > /debug/tracing/current_tracer
> 
> Oops, my bad, it doesn't work after exec...
> But, it is very important to disable function tracer after
> tracing target process.
> 
> So, perhaps, below script may work.
> 
> #!/bin/sh
> (echo $BASHPID > /debug/tracing/set_ftrace_pid
>  echo function > /debug/tracing/current_tracer
>  exec $*)
> echo nop > /debug/tracing/current_tracer

Unfortunately, that would lose the entire trace you just recorded.

So perhaps adding:

 trace-cmd extract
 echo nop > /debug/tracing/current_tracer

would work better. The extract feature of trace-cmd pulls the data from
the kernel buffer and saves it in a file format.

-- Steve


