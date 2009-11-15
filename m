Return-Path: <linux-kernel-owner+w=401wt.eu-S1752480AbZKOJN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbZKOJN6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 04:13:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbZKOJN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 04:13:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51171 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbZKOJNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 04:13:54 -0500
Date: Sun, 15 Nov 2009 10:13:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: perf stat output
Message-ID: <20091115091343.GA17358@elte.hu>
References: <193b0f820911121403w35c57158kf3721309e1f2ebd7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <193b0f820911121403w35c57158kf3721309e1f2ebd7@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lucas De Marchi <lucas.de.marchi@gmail.com> wrote:

> Hi all!
> 
> Some questions about perf stat output. See example:
> 
> 
> lucas@LMS-linux:~/programming/testprograms> perf stat -e
> L1-dcache-loads -e L1-dcache-load-misses -- make -j
> gcc test_schedchanges.c -o test_schedchanges
> gcc -pthread test_taskaff1.c -o test_taskaff1
> gcc -pthread test_taskaff2.c -o test_taskaff2
> gcc -pthread test_taskaff3.c -o test_taskaff3
> 
>  Performance counter stats for 'make -j':
> 
>        161384667  L1-dcache-loads          #      0.000 M/sec
>               24853791  L1-dcache-load-misses    #      0.000 M/sec
> 
> 	          0.066893389  seconds time elapsed
> 
> Why do we have both L1-dcache-loads and L1-dcache-load-misses with 
> 0.000 M/sec? Also, why do we have 0 M/s when running "perf stat -a -e 
> cache-misses -e cache-references" but values different than 0 when 
> running "perf stat -a" without selecting the events?

You need the 'task-clock' event to be able to see M/sec metrics. I.e.:

$ perf stat -e L1-dcache-loads -e L1-dcache-load-misses -e task-clock sleep 1

 Performance counter stats for 'sleep 1':

         201330  L1-dcache-loads          #    566.234 M/sec
          29916  L1-dcache-load-misses    #     84.138 M/sec
       0.355560  task-clock-msecs         #      0.000 CPUs 

    1.000621650  seconds time elapsed

I agree with you that seeing '0.000 M/sec' is confusing and incorrect as 
well. One solution would be to skip the printout in that case.

You can find the latest 'perf' code in:

  http://people.redhat.com/mingo/tip.git/README

( the tools/perf/ bits are backwards compatible with any perf kernel you 
  are running right now, so no reboot is needed. )

You can find the stats printing in tools/perf/builtin-stat.c, in the 
abs_printout() function:

        } else {
                total = avg_stats(&runtime_nsecs_stats);

                if (total)
                        ratio = 1000.0 * avg / total;

                fprintf(stderr, " # %10.3f M/sec", ratio);

I think if runtime_nsecs_stats is zero (i.e. if no 'task-clock' events 
were measured), then we might be able to skip the printout via doing 
something like:

        } else if (runtime_nsecs_stats.n != 0) {

Would you be interested in sending a (tested) patch for that? In theory 
only that oneliner change should suffice - but i have not tested it.

	Ingo
