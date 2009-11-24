Return-Path: <linux-kernel-owner+w=401wt.eu-S932397AbZKXJEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397AbZKXJEe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 04:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932363AbZKXJEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 04:04:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59313 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932216AbZKXJEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 04:04:31 -0500
Date: Tue, 24 Nov 2009 10:04:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/5] perf kmem: Add more functions and show more
 statistics
Message-ID: <20091124090425.GF21991@elte.hu>
References: <4B0B6E44.6090106@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0B6E44.6090106@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


a few more UI suggestions for 'perf kmem':

I think it should look similar to how 'perf' and 'perf sched' prints 
sub-commands with increasing specificity, which means that we display a 
list of subcommands and options when typed:

$ perf sched

 usage: perf sched [<options>] {record|latency|map|replay|trace}

    -i, --input <file>    input file name
    -v, --verbose         be more verbose (show symbol address, etc)
    -D, --dump-raw-trace  dump raw trace in ASCII


For 'perf kmem' we could print something like:

$ perf kmem

 usage: perf kmem [<options>] {record|report|trace}

    -i, --input <file>    input file name
    -v, --verbose         be more verbose (show symbol address, etc)
    -D, --dump-raw-trace  dump raw trace in ASCII

The advantage is that right now, when a new user sees the subcommand in 
'perf' output:

 $ perf
 ...
   kmem           Tool to trace/measure kernel memory(slab) properties
 ...

And types 'perf kmem', the following is displayed currently:

 $ perf kmem

 SUMMARY
 =======
 Total bytes requested: 0
 Total bytes allocated: 0
 Total bytes wasted on internal fragmentation: 0
 Internal fragmentation: 0.000000%
 Cross CPU allocations: 0/0

That's not very useful to someone who tries to figure out how to use 
this command. A summary page would be more useful - and that would 
advertise all the commands in a really short summary form (shorter than 
-h/--help).

The other thing is that if someone types 'perf kmem record', the command 
seems 'hung':

 $ perf kmem record
 <hang>

Now if i Ctrl-C it i see that a recording session was going on:

 $ perf kmem record
 ^C[ perf record: Woken up 10 times to write data ]
 [ perf record: Captured and wrote 1.327 MB perf.data (~57984 samples) ]

but this was not apparent from the tool output and the user was left 
wondering about what is going on.

I think at minimum we should print a:

	[ Recording all kmem events in the system, Ctrl-C to stop. ]

line. (on a related note, 'perf sched record' needs such a fix too.)

Another solution would be for 'perf kmem record' to work analogous to 
'perf record': it could display a short help page by default, something 
like:

 $ perf kmem record

  usage: perf kmem record [<options>] [<command>]

  example: perf kmem record -a sleep 10  # capture all events for 10 seconds
           perf kmem record /bin/ls      # capture events of this command
           perf kmem record -p 1234      # capture events of PID 1234

What do you think?

Also, a handful of mini-bugreports wrt. usability:

1)

running 'perf kmem' without having a perf.data gives:

earth4:~/tip/tools/perf> ./perf kmem
Failed to open file: perf.data  (try 'perf record' first)

SUMMARY
=======
Total bytes requested: 0
Total bytes allocated: 0
Total bytes wasted on internal fragmentation: 0
Internal fragmentation: 0.000000%
Cross CPU allocations: 0/0

2)

running 'perf kmem record' on a box without kmem events gives:

earth4:~/tip/tools/perf> ./perf kmem record
invalid or unsupported event: 'kmem:kmalloc'
Run 'perf list' for a list of valid events

i think we want to print something kmem specific - and tell the user how 
to enable kmem events or so - 'perf list' is not a solution to him.

3)

it doesnt seem to be working on one of my boxes, which has perf and kmem 
events as well:

aldebaran:~/linux/linux/tools/perf> perf kmem record
^C[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.050 MB perf.data (~2172 samples) ]

aldebaran:~/linux/linux/tools/perf> perf kmem

SUMMARY
=======
Total bytes requested: 0
Total bytes allocated: 0
Total bytes wasted on internal fragmentation: 0
Internal fragmentation: 0.000000%
Cross CPU allocations: 0/0
aldebaran:~/linux/linux/tools/perf> 

	Ingo
