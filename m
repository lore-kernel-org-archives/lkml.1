Return-Path: <linux-kernel-owner+w=401wt.eu-S1757477AbZJPIdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477AbZJPIdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 04:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbZJPIda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 04:33:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46627 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbZJPId3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 04:33:29 -0400
Date: Fri, 16 Oct 2009 10:32:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@lst.de>
Cc: fweisbec@gmail.com, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: perf trace errors
Message-ID: <20091016083242.GA11174@elte.hu>
References: <20091011025441.GA18152@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091011025441.GA18152@lst.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@lst.de> wrote:

> I get some rather interesting errors using perf trace with the block
> tracepoints on current mainline, e.g.:
> 
> perf record -f -e 'block:block_bio_queue:record' -R -F 1 -a -s
> <do some disk I/O end then ctrl+c>
> ^C[ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.237 MB perf.data (~10362 samples) ]
> 
> brick:/home/hch# perf trace
>   Fatal: unknown op '-'
>           xfssyncd-4232  [000]    87.798249255: block_bio_queue: 253,
> 
> There are lots of occurances of that exactly same warning in 
> builtin-trace.c, and the code sourrouning them is sufficiently enough 
> convoluted that I'm not able to track it down.

FYI, these bugs are fixed in latest -tip, your testcase works for me:

aldebaran:~/linux/linux/tools/perf> perf record -f -e 'block:block_bio_queue:record' -R -F 1 -a -s
^C[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.027 MB perf.data (~1168 samples) ]

aldebaran:~/linux/linux/tools/perf> perf trace
       kjournald-1406  [000] 10900.853086: block_bio_queue: 8,0 W 68735 + 8 [kjournald]
       kjournald-1406  [000] 10900.853097: block_bio_queue: 8,0 W 68743 + 8 [kjournald]
       kjournald-1406  [000] 10900.853100: block_bio_queue: 8,0 W 68751 + 8 [kjournald]
       kjournald-1406  [000] 10900.853103: block_bio_queue: 8,0 W 68759 + 8 [kjournald]
       flush-8:0-20110 [007] 10900.853117: block_bio_queue: 8,0 W 64487535 + 8 [flush-8:0]
       flush-8:0-20110 [007] 10900.853129: block_bio_queue: 8,0 W 64487551 + 8 [flush-8:0]
       flush-8:0-20110 [007] 10900.853138: block_bio_queue: 8,0 W 64487559 + 8 [flush-8:0]
       flush-8:0-20110 [007] 10900.853149: block_bio_queue: 8,0 W 64700511 + 8 [flush-8:0]
            sync-16876 [008] 10900.851948: block_bio_queue: 8,0 R 3218919 + 40 [sync]
            sync-16876 [008] 10900.853062: block_bio_queue: 8,0 W 63 + 8 [sync]
            sync-16876 [008] 10900.853067: block_bio_queue: 8,0 W 71 + 8 [sync]
            sync-16876 [008] 10900.853071: block_bio_queue: 8,0 W 79 + 8 [sync]
            sync-16876 [008] 10900.853077: block_bio_queue: 8,0 W 15466559 + 8 [sync]
            sync-16876 [011] 10900.840473: block_bio_queue: 8,0 R 3218887 + 32 [bash]

Mind checking whether it works for you?

Thanks,

	Ingo
