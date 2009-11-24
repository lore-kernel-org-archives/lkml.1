Return-Path: <linux-kernel-owner+w=401wt.eu-S932477AbZKXJjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477AbZKXJjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 04:39:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932401AbZKXJjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 04:39:10 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59715 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932400AbZKXJjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 04:39:09 -0500
Message-ID: <4B0BA99D.5020602@cn.fujitsu.com>
Date: Tue, 24 Nov 2009 17:38:37 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/5] perf kmem: Add more functions and show more statistics
References: <4B0B6E44.6090106@cn.fujitsu.com> <20091124090425.GF21991@elte.hu>
In-Reply-To: <20091124090425.GF21991@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> a few more UI suggestions for 'perf kmem':
> 

Thanks for the suggestions!

> I think it should look similar to how 'perf' and 'perf sched' prints 
> sub-commands with increasing specificity, which means that we display a 
> list of subcommands and options when typed:
> 

Yes, I'd like to make the usage and output format similar to perf-sched.

> $ perf sched
> 
>  usage: perf sched [<options>] {record|latency|map|replay|trace}
> 
>     -i, --input <file>    input file name
>     -v, --verbose         be more verbose (show symbol address, etc)
>     -D, --dump-raw-trace  dump raw trace in ASCII
> 
> 
> For 'perf kmem' we could print something like:
> 
> $ perf kmem
> 
>  usage: perf kmem [<options>] {record|report|trace}
> 
>     -i, --input <file>    input file name
>     -v, --verbose         be more verbose (show symbol address, etc)
>     -D, --dump-raw-trace  dump raw trace in ASCII
> 
> The advantage is that right now, when a new user sees the subcommand in 
> 'perf' output:
> 
>  $ perf
>  ...
>    kmem           Tool to trace/measure kernel memory(slab) properties
>  ...
> 
> And types 'perf kmem', the following is displayed currently:
> 
>  $ perf kmem
> 
>  SUMMARY
>  =======
>  Total bytes requested: 0
>  Total bytes allocated: 0
>  Total bytes wasted on internal fragmentation: 0
>  Internal fragmentation: 0.000000%
>  Cross CPU allocations: 0/0
> 
> That's not very useful to someone who tries to figure out how to use 
> this command. A summary page would be more useful - and that would 
> advertise all the commands in a really short summary form (shorter than 
> -h/--help).
> 

perf-timechart acts similarly - it won't show help page by "perf timechart"

 # ./perf timechart
 0xbc480 [0x18]: skipping unknown header type: 2
 0xbc488 [(nil)]: skipping unknown header type: 238
 0xbc490 [(nil)]: skipping unknown header type: 20034
 Written 1.0 seconds of trace to output.svg.

But sure, I can change this for perf-kmem. So, do we want to do the same
for perf-timechart too?

> The other thing is that if someone types 'perf kmem record', the command 
> seems 'hung':
> 
>  $ perf kmem record
>  <hang>
> 
> Now if i Ctrl-C it i see that a recording session was going on:
> 
>  $ perf kmem record
>  ^C[ perf record: Woken up 10 times to write data ]
>  [ perf record: Captured and wrote 1.327 MB perf.data (~57984 samples) ]
> 
> but this was not apparent from the tool output and the user was left 
> wondering about what is going on.
> 
> I think at minimum we should print a:
> 
> 	[ Recording all kmem events in the system, Ctrl-C to stop. ]
> 
> line. (on a related note, 'perf sched record' needs such a fix too.)
> 

Yes, I followed perf-sched and perf-timechart. ;)

I'll fix it for these tools.

> Another solution would be for 'perf kmem record' to work analogous to 
> 'perf record': it could display a short help page by default, something 
> like:
> 
>  $ perf kmem record
> 
>   usage: perf kmem record [<options>] [<command>]
> 
>   example: perf kmem record -a sleep 10  # capture all events for 10 seconds
>            perf kmem record /bin/ls      # capture events of this command
>            perf kmem record -p 1234      # capture events of PID 1234
> 
> What do you think?
> 

But I'm not sure I like this, actually I prefer to just print
a line to explain what's going on.

> Also, a handful of mini-bugreports wrt. usability:
> 
> 1)
> 
> running 'perf kmem' without having a perf.data gives:
> 
> earth4:~/tip/tools/perf> ./perf kmem
> Failed to open file: perf.data  (try 'perf record' first)
> 
> SUMMARY
> =======
> Total bytes requested: 0
> Total bytes allocated: 0
> Total bytes wasted on internal fragmentation: 0
> Internal fragmentation: 0.000000%
> Cross CPU allocations: 0/0
> 

Again, this issue exists in perf-sched too..

So we need to fix not only perf-kmem.

> 2)
> 
> running 'perf kmem record' on a box without kmem events gives:
> 
> earth4:~/tip/tools/perf> ./perf kmem record
> invalid or unsupported event: 'kmem:kmalloc'
> Run 'perf list' for a list of valid events
> 
> i think we want to print something kmem specific - and tell the user how 
> to enable kmem events or so - 'perf list' is not a solution to him.
> 

ditto

> 3)
> 
> it doesnt seem to be working on one of my boxes, which has perf and kmem 
> events as well:
> 
> aldebaran:~/linux/linux/tools/perf> perf kmem record
> ^C[ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.050 MB perf.data (~2172 samples) ]
> 

Seems no kmem event is recorded. No sure what happened here.

Might be that the parameters that perf-kmem passes to perf-record
are not properly selected?

Do perf-sched and perf-timechart work on this box?

> aldebaran:~/linux/linux/tools/perf> perf kmem
> 
> SUMMARY
> =======
> Total bytes requested: 0
> Total bytes allocated: 0
> Total bytes wasted on internal fragmentation: 0
> Internal fragmentation: 0.000000%
> Cross CPU allocations: 0/0
> aldebaran:~/linux/linux/tools/perf> 
> 
