Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab0BWXyx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 18:54:53 -0500
Received: from borg.medozas.de ([188.40.89.202]:44509 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754758Ab0BWXyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 18:54:52 -0500
Date: Wed, 24 Feb 2010 00:54:51 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>
Subject: Re: tools/perf: libraries must come after objects
In-Reply-To: <20100222134754.GA8559@elte.hu>
Message-ID: <alpine.LSU.2.01.1002240049280.16982@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.1002110124030.13770@obet.zrqbmnf.qr> <20100222105025.GA25661@elte.hu> <alpine.LSU.2.01.1002221430440.23762@obet.zrqbmnf.qr> <20100222134754.GA8559@elte.hu>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2010-02-22 14:47, Ingo Molnar wrote:
>> >> tools/perf: libraries must come after objects
>> >> 
>> >> Link order matters, especially now since distributions are
>> >> using -Wl,--as-needed.

>> >>  tools/perf/Makefile |   16 ++++++++--------
>> >>  1 files changed, 8 insertions(+), 8 deletions(-)
>> >
>> >FYI, this patch doesnt apply to the latest version of perf:
>> >  http://people.redhat.com/mingo/tip.git/README

Seems like it was already merged - half of it.

There is this perl linking error now remaining, because
libperf.a comes after the perl part, and I am not sure
how to fix cleanly that Makefile without making more
mess of it.

$ make CC=gcc-4.4
touch .perf.dev.null
gcc-4.4 -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 -Wformat -Wformat-security -Wformat-y2k -Wshadow -Winit-self -Wpacked -Wredundant-decls -Wstack-protector -Wstrict-aliasing=3 -Wswitch-default -Wswitch-enum -Wno-system-headers -Wundef -Wvolatile-register-var -Wwrite-strings -Wbad-function-cast -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wold-style-definition -Wstrict-prototypes -Wdeclaration-after-statement  -fstack-protector-all -Iutil/include -I/usr/include/libdwarf -DSHA1_HEADER='<openssl/sha.h>'  -o perf perf.o \
		 builtin-annotate.o builtin-bench.o bench/sched-messaging.o bench/sched-pipe.o bench/mem-memcpy.o builtin-diff.o builtin-help.o builtin-sched.o builtin-buildid-list.o builtin-buildid-cache.o builtin-list.o builtin-record.o builtin-report.o builtin-stat.o builtin-timechart.o builtin-top.o builtin-trace.o builtin-probe.o builtin-kmem.o builtin-lock.o  `perl -MExtUtils::Embed -e ldopts 2>/dev/null`  libperf.a -lpthread -lrt -lelf -lm -lelf -ldwarf -lbfd -liberty -lz 
libperf.a(trace-event-perl.o): In function `define_flag_value':
/home/jengelh/code/linux/tools/perf/util/trace-event-perl.c:125: undefined reference to `Perl_push_scope'
[...]
/home/jengelh/code/linux/tools/perf/Context.c:54: undefined reference to `Perl_croak_nocontext'
collect2: ld returned 1 exit status
make: *** [perf] Error 1
rm .perf.dev.null

$ perl -MExtUtils::Embed -e ldopts
-Wl,-E
-Wl,-rpath,/usr/lib/perl5/5.10.0/x86_64-linux-thread-multi/CORE
-L/usr/local/lib64
-L/usr/lib/perl5/5.10.0/x86_64-linux-thread-multi/CORE -lperl -lm
-ldl -lcrypt -lpthread
