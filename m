Return-Path: <linux-kernel-owner+w=401wt.eu-S1751809Ab0ALFgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809Ab0ALFgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 00:36:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277Ab0ALFgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 00:36:06 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:59410 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab0ALFgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 00:36:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UIYORliBJdtpaFDNXqDawIiQlsBnqWqGT4QybyEGfIH8lIt5syCfs7nzx5SvwTbShv
         9fAo3yaoO+IOesNCQS9S1G5dEAjCBiqvHRF52U3nEQIFfs0kvVyMR2FD6sl0nZW24jr/
         3IToexZ/ZjMt4kwgOS7/AIESJZfYjJjuBTM3w=
Date: Tue, 12 Jan 2010 06:36:00 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Jim Keniston <jkenisto@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 4/7] Uprobes Implementation
Message-ID: <20100112053559.GL5243@nowhere>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com> <20100111122553.22050.46895.sendpatchset@srikar.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100111122553.22050.46895.sendpatchset@srikar.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 05:55:53PM +0530, Srikar Dronamraju wrote:
> +static const struct utrace_engine_ops uprobe_utrace_ops = {
> +	.report_quiesce = uprobe_report_quiesce,
> +	.report_signal = uprobe_report_signal,
> +	.report_exit = uprobe_report_exit,
> +	.report_clone = uprobe_report_clone,
> +	.report_exec = uprobe_report_exec
> +};


So, as stated before, uprobe seems to handle too much standalone
policies such as freeing on exec, always inherit on clone and never
on fork. Such rules should be decided from uprobe clients not
from uprobe itself and that makes it not enough flexible to
be usable for now.

For example if we want it to be usable by perf, we have two ways:

- a trace event. Unfortunately, like I explained in a previous
  mail, this doesn't seem to be a suitable interface for this
  particular case.

- a performance monitoring unit, with the existing unified interface
  struct pmu, usable by perf.


Typically, to use it with perf toward a pmu, perf tools need to
create a uprobe on perf process and activate its hook on the next exec.
Thereafter, it's up to perf to decide if we inherit through clone
and fork.

Here I fear utrace and perf are going to collide.

See how could be the final struct pmu (we need to extend it
to support utrace):

struct pmu {
	enable() -> called we schedule in a context where we want
                    a uprobe to be active. Called very often
        disable() -> the above opposite

        /* Not yet existing callbacks */

        hook_task() -> called when a process is created which
                       we want to activate our hook
                       would be typically called once on
                       exec if we have set enable_on_exec
                       and also on clone()/fork()
                       if we want to inherit.
}


The above hook_task (could be divided in more precise callback events
like hook_on_exec, hook_on_clone, etc...) would be needed by perf
to drive correctly utrace and this is going to collide with utrace
callbacks that notify execs and forks.

Probably utrace can be kept for all the utrace breakpoint signal
handling an so. But I guess the rest can be implemented on top
of a struct pmu and driven by perf like we did with hardware
breakpoints re-implementation.

Just an idea.

