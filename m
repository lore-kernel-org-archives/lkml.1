Return-Path: <linux-kernel-owner+w=401wt.eu-S1754343AbZKMIHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbZKMIHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 03:07:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbZKMIHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 03:07:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:52335 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbZKMIHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 03:07:35 -0500
Subject: Re: perf stat output
From: Peter Zijlstra <peterz@infradead.org>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <193b0f820911121403w35c57158kf3721309e1f2ebd7@mail.gmail.com>
References: <193b0f820911121403w35c57158kf3721309e1f2ebd7@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Nov 2009 09:07:35 +0100
Message-ID: <1258099655.4039.998.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-12 at 20:03 -0200, Lucas De Marchi wrote:
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
> Why do we have both L1-dcache-loads and  L1-dcache-load-misses with
> 0.000 M/sec? Also, why do we have 0 M/s when running "perf stat -a -e
> cache-misses -e cache-references" but values different than 0 when
> running "perf stat -a" without selecting the events?

No idea, you'd have to look at the code computing this M/sec stuff. I
think Ingo wrote that, so he might have an idea.

> The last question: what does the  "scaled from X%" mean? Is it related
> to the maximum number of performance registers a processor can count
> at a time?

Yes, if the hardware has only 2 counters and you specify 4, we'll
round-robin those 4 onto the 2. In that case you'll see things like
scaled from ~50% because each counter will only have been on the actual
PMU for about 50% of the time.

(RR happens with tick granularity, so if your runtime is of that order
or shorter you can get funny results with some counters being 0).

