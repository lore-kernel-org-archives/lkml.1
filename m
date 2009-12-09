Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbZLIRgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbZLIRgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 12:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbZLIRgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 12:36:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbZLIRgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 12:36:51 -0500
Message-ID: <4B1FE022.1030704@redhat.com>
Date: Wed, 09 Dec 2009 12:36:34 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Jason Baron <jbaron@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip 0/8] perf-probe updates
References: <20091208220232.10142.2643.stgit@dhcp-100-2-132.bos.redhat.com> <20091209072220.GA4328@elte.hu> <20091209084341.GA21333@elte.hu>
In-Reply-To: <20091209084341.GA21333@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Thank you for error reporting :-)

Ingo Molnar wrote:
> There's another small hickup i had - when i typoed 'perf probe -', it
> gave me:
>
>   # perf probe -
>   No dwarf info found in the vmlinux - please rebuild with CONFIG_DEBUG_INFO.
>   An error occurred in debuginfo analysis. Try to use symbols.
>     Fatal: Failed to write event: Invalid argument

OK, perhaps, you are expecting "perf probe -" works similar to "perf record -",
but that's not implemented yet...
Anyway, I think "perf probe -" should show a usage and return.


> Similar thing happens if i try to probe a non-existent symbol:
>
>   # perf probe test
>   No dwarf info found in the vmlinux - please rebuild with CONFIG_DEBUG_INFO.
>   An error occurred in debuginfo analysis. Try to use symbols.
>     Fatal: Failed to write event: Invalid argument
>
> I think we should print something more helpful, such as:
>
>   # perf probe test
>   Fatal: Kernel symbol 'test' not found - probe not added.
>
> the debuginfo printout is not helpful in this case - we should fall back
> to symbols silently, unless the nature of the error indicates that we
> fail _because_ there's no debuginfo.

OK.

> Here the failure was because the symbol does not exist.

Yeah, so that's what I'm expecting to be implemented with below item :-)

   - Symbol search by libelf/kallsyms

I guess it will be done by using symbol.c.
(Actually, current

781 221 7109

>
> There's similar problems in most other failure cases. Trying to remove a
> non-existent probe gives:
>
>   # perf probe -d test
>   Warning: event "probe:test" is not found.
>
> It should say something like:
>
>   # perf probe -d test
>   Info: event "probe:test" does not exist, could not remove it.

Sure.

> Also, it's possible to add multiple probes to the same function, using
> 'perf probe schedule' + 'perf probe schedule', etc. While in general it
> makes sense to allow it, by default we should refuse the second,
> identical probe on the symbol - and add a -f/--force option to force
> duplicate probes. I.e. the second probe should print:
>
>   # perf probe schedule
>   Info: event "probe:schedule" already exists. (Use -f to force a duplicate.)
>
> etc.

Hmm, if you mean 'refusing the second issued command',
it might be good, because it can avoid to add events with
unwilling names.

However, I don't think it's so useful generally, because
some code lines can be expanded to several addresses.
In that case, we need to add several events at once,
and each event has different names.
e.g.

# ./perf probe schedule:10
Added new event:
   probe:schedule                           (on schedule+1)
Added new event:
   probe:schedule_1                         (on schedule+19)
Added new event:
   probe:schedule_2                         (on schedule+19)
Added new event:
   probe:schedule_3                         (on schedule+28)
Added new event:
   probe:schedule_4                         (on schedule+38)

You can now use it on all perf tools, such as:

         perf record -e probe:schedule_4 -a sleep 1
---
Same things happens when probing inlined functions.

I guess this issue might be solved by below items;
   - Support glob expression with --del option (like --del "*")
   - Support event/group name specifying for new events

e.g.
Adding new events with another name.

# perf probe --add mygroup:sched_enter=schedule
Added new event:
   mygroup:sched_enter                      (on schedule+0)

# perf probe --add mygroup:sched_event=schedule:10
Added new event:
   mygroup:sched_event                      (on schedule+1)
Added new event:
   mygroup:sched_event_1                    (on schedule+19)
Added new event:
   mygroup:sched_event_2                    (on schedule+19)
Added new event:
   mygroup:sched_event_3                    (on schedule+28)
Added new event:
   mygroup:sched_event_4                    (on schedule+38)

And record it by glob specifying.

# perf record -e mygroup:sched_event* -a sleep 1

or

# perf record -e mygroup:sched_enter* -a sleep 1

What would you think about it?

> Please try out various sensible and also less sensible options of
> this tool and try to make it break - and see whether the behavior is
> intuitive and obvious to users - whether the messages are consistent,
> etc. etc.

OK, actually, perf-probe needs to be brushed up. Any comments, reports
and opinions are welcome. I'd like to update todo list, based on what
is useful and which is important for users.

Thank you,

>
> 	Ingo

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

