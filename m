Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbZAVJCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbZAVJCn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 04:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbZAVJC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 04:02:28 -0500
Received: from mail-ew0-f20.google.com ([209.85.219.20]:47241 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbZAVJC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 04:02:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pY2mOPZbK7UbVLec8hnA18aJ3E70IwEFIC992voV+g2FkH4ybrhTzCSDot8ooCbItc
         0WMahAZAQytOaUl2RxNlaHcenOpftjqLRnVGqmPMptyI4BntdHV7myM+07jXzl3pGuRc
         DeH3lp3wPnRRm+hT9UtvRlgA0BcgPrneTCcl8=
Date: Thu, 22 Jan 2009 10:02:22 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing/function-graph-tracer: various fixes and
	features
Message-ID: <20090122090221.GA5891@nowhere>
References: <4977cacb.1358560a.19ec.ffffcb09@mx.google.com> <alpine.DEB.1.10.0901212037090.1737@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901212037090.1737@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 08:43:24PM -0500, Steven Rostedt wrote:
> 
> On Wed, 21 Jan 2009, Frederic Weisbecker wrote:
> 
> > I thought I would have the time to implement the callbacks in trace_event too but I
> > really have to sleep :-(
> > That will be for later.
> 
> No need to rush. Get to sleep.
> 
> > --
> > 
> > This patch brings various bugfixes:
> > 
> > _ Drop the first irrelevant task switch on the very beginning of a trace.
> >   But actually that only solves the first time one does print the trace file.
> >   I have to fix the others cases too.
> 
> I'm not sure what you mean by the first time here. Can you explain it
> a bit better.


On the very first time one cat the trace file, the per cpu pid array is init to -1.
So the comparison between the current pid and the previous one (-1) is always false
and then a task switch is printed.
This one is fixed.

The other cases are when one cat the trace file after closing it.
The pid array is not anymore filled with -1 values but with old traced pid, and then
a task switch is printed here too.
I will have to hook on open and reset the pid table to -1 to fix that.

 
> > _ Drop the OVERHEAD word from the headers, the DURATION word is sufficient and will not
> >   overlap other columns.
> > _ Make the headers fit well their respective columns whatever the selected options.
> > 
> > Ie, default options:
> > 
> > # tracer: function_graph
> > #
> > # CPU  DURATION                  FUNCTION CALLS
> > # |     |   |                     |   |   |   |
> > 
> >  1)   0.646 us    |                    }
> >  1)               |                    mem_cgroup_del_lru_list() {
> >  1)   0.624 us    |                      lookup_page_cgroup();
> >  1)   1.970 us    |                    }
> > 
> > echo funcgraph-proc > trace_options
> > 
> > # tracer: function_graph
> > #
> > # CPU  TASK/PID        DURATION                  FUNCTION CALLS
> > # |    |    |           |   |                     |   |   |   |
> > 
> >  0)   bash-2937    |   0.895 us    |                }
> >  0)   bash-2937    |   0.888 us    |                __rcu_read_unlock();
> >  0)   bash-2937    |   0.864 us    |                conv_uni_to_pc();
> >  0)   bash-2937    |   1.015 us    |                __rcu_read_lock();
> > 
> > echo nofuncgraph-cpu > trace_options
> > echo nofuncgraph-proc > trace_options
> > 
> > # tracer: function_graph
> > #
> > #   DURATION                  FUNCTION CALLS
> > #    |   |                     |   |   |   |
> > 
> >   3.752 us    |                  native_pud_val();
> >   0.616 us    |                  native_pud_val();
> >   0.624 us    |                  native_pmd_val();
> > 
> > 
> > About features, one can now disable the duration (this will hide the overhead too
> > for convenient reasons and because on  doesn't need overhead if it hasn't the duration
> > 
> > echo nofuncgraph-duration > trace_options
> > 
> > # tracer: function_graph
> > #
> > #                FUNCTION CALLS
> > #                |   |   |   |
> > 
> >           cap_vm_enough_memory() {
> >             __vm_enough_memory() {
> >               vm_acct_memory();
> >             }
> >           }
> >         }
> > 
> > And at last, an option to print the absolute time:
> > 
> > //Restart from default options
> > echo funcgraph-abstime > trace_options
> > 
> > # tracer: function_graph
> > #
> > #      TIME       CPU  DURATION                  FUNCTION CALLS
> > #       |         |     |   |                     |   |   |   |
> > 
> >   261.339774 |   1) + 42.823 us   |    }
> >   261.339775 |   1)   1.045 us    |    _spin_lock_irq();
> >   261.339777 |   1)   0.940 us    |    _spin_lock_irqsave();
> >   261.339778 |   1)   0.752 us    |    _spin_unlock_irqrestore();
> >   261.339780 |   1)   0.857 us    |    _spin_unlock_irq();
> >   261.339782 |   1)               |    flush_to_ldisc() {
> >   261.339783 |   1)               |      tty_ldisc_ref() {
> >   261.339783 |   1)               |        tty_ldisc_try() {
> >   261.339784 |   1)   1.075 us    |          _spin_lock_irqsave();
> >   261.339786 |   1)   0.842 us    |          _spin_unlock_irqrestore();
> >   261.339788 |   1)   4.211 us    |        }
> >   261.339788 |   1)   5.662 us    |      }
> > 
> > The format is seconds.usecs
> > I guess no one needs the nanosec precision here, the main goal is to find when happened
> > the events on a cpu when the trace switches from one cpu to another.
> > 
> > ie:
> > 
> >   274.874760 |   1)   0.676 us    |      _spin_unlock();
> >   274.874762 |   1)   0.609 us    |      native_load_sp0();
> >   274.874763 |   1)   0.602 us    |      native_load_tls();
> >   274.878739 |   0)   0.722 us    |                  }
> >   274.878740 |   0)   0.714 us    |                  native_pmd_val();
> >   274.878741 |   0)   0.730 us    |                  native_pmd_val();
> > 
> > Here there is a 4000 usecs difference when we switch the cpu.
> 
> These examples will most likely be cut from the change log. Updating
> ftrace.txt would be nice ;-)


Yes, definetly. I didn't drop my hands into this yet because of my
messy english :-)
But I know some people who could review it :-)


> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  kernel/trace/trace_functions_graph.c |  245 +++++++++++++++++++++-------------
> >  1 files changed, 151 insertions(+), 94 deletions(-)
> > 
> 
> -- Steve
> 

Thanks.

