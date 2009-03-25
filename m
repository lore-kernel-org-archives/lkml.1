Return-Path: <linux-kernel-owner+w=401wt.eu-S1760567AbZCYLrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760567AbZCYLrz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 07:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758141AbZCYLrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 07:47:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35376 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758658AbZCYLro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 07:47:44 -0400
Date: Wed, 25 Mar 2009 12:47:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] blktrace: fix the original blktrace
Message-ID: <20090325114720.GA9762@elte.hu>
References: <49C9F700.9070609@cn.fujitsu.com> <49C9F796.9040503@cn.fujitsu.com> <20090325101451.GK2341@elte.hu> <20090325101747.GL27476@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325101747.GL27476@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Wed, Mar 25 2009, Ingo Molnar wrote:
> > 
> > * Li Zefan <lizf@cn.fujitsu.com> wrote:
> > 
> > > Currently the original blktrace, which is using relay and is used 
> > > via ioctl, is broken. You can use ftrace to see the output of 
> > > blktrace, but user-space blktrace is unusable.
> > 
> > good catch, thanks Li!
> > 
> > Jens, Arnaldo, do these fixes look good to you too?
> 
> Look fine, but I'm very worried about the state of the current 
> code. I mean, this last round of fixes got the timestamp correct 
> and made blktrace work again. [...]

Correct. I tested it on a 16way box (see the blkparse output below). 
If you can see any sort of anomaly please let us know so we can fix 
it.

> [...] Those are something that should have been caught even before 
> the whole thing was posted, let alone merged. When do you plan on 
> pushing this upstream? Looks like 2.6.31 to me, it's clearly not 
> ready for 2.6.30 by any stretch.

Well, apparently nobody tried ioctl based blktrace+blkparse on -tip 
or linux-next in the past ~1 month. The relayfs portion was (meant 
to be) kept largely untouched but this bug still crept in.

Li started looking into it and found the bug. I tested the ftrace 
plugin side regularly, but you are right that this bug took too long 
to find (over a month) - from now on i'll check the ioctl side more 
regularly too, for all tracing and relayfs changes as well.

	Ingo

---------------->
  8,0   13        1     0.000000000  6219  A   R 20475199 + 128 <- (8,1) 20475136
  8,0   13        2     0.000000721  6219  Q   R 20475199 + 128 [cc1]
  8,0   13        3     0.000008680  6219  G   R 20475199 + 128 [cc1]
  8,0   13        4     0.000010792  6219  P   N [cc1]
  8,0   13        5     0.000012401  6219  I   R 20475199 + 128 [cc1]
  8,0   13        6     0.000016097  6219  U   N [cc1] 1
  8,0   13        7     0.000023499  6219  D   R 20475199 + 128 [cc1]
  8,0   10        1     0.018127785     0  C   R 20475199 + 128 [0]
  8,0   10        2     0.347266011  1059  A   W 20423 + 8 <- (8,1) 20360
  8,0   10        3     0.347266724  1059  Q   W 20423 + 8 [kjournald]
  8,0   10        4     0.347271298  1059  G   W 20423 + 8 [kjournald]
  8,0   10        5     0.347273197  1059  P   N [kjournald]
  8,0   10        6     0.347274678  1059  I   W 20423 + 8 [kjournald]
  8,0   10        7     0.347315501  1059  A   W 20431 + 8 <- (8,1) 20368
  8,0   10        8     0.347315665  1059  Q   W 20431 + 8 [kjournald]
  [...]
  8,0   10    17481    16.338721149  1059  M   W 22047 + 8 [kjournald]
  8,0   10    17482    16.338721545  1059  A   W 22055 + 8 <- (8,1) 21992
  8,0   10    17483    16.338721701  1059  Q   W 22055 + 8 [kjournald]
  8,0   10    17484    16.338721887  1059  M   W 22055 + 8 [kjournald]
  8,0   10    17485    16.338722389  1059  A   W 22063 + 8 <- (8,1) 22000
  8,0   10    17486    16.338722551  1059  Q   W 22063 + 8 [kjournald]
  8,0   10    17487    16.338722810  1059  M   W 22063 + 8 [kjournald]
  8,0   10    17488    16.338723586  1059  A   W 22071 + 8 <- (8,1) 22008
  8,0   10    17489    16.338723764  1059  Q   W 22071 + 8 [kjournald]
  8,0   10    17490    16.338723989  1059  M   W 22071 + 8 [kjournald]
  8,0   10    17491    16.338724547  1059  A   W 22079 + 8 <- (8,1) 22016
  8,0   10    17492    16.338724724  1059  Q   W 22079 + 8 [kjournald]
  8,0   10    17493    16.338724989  1059  M   W 22079 + 8 [kjournald]
  8,0   10    17494    16.338725489  1059  A   W 22087 + 8 <- (8,1) 22024
  8,0   10    17495    16.338725656  1059  Q   W 22087 + 8 [kjournald]
  8,0   10    17496    16.338725863  1059  M   W 22087 + 8 [kjournald]
  8,0   10    17497    16.338726383  1059  A   W 22095 + 8 <- (8,1) 22032
  8,0   10    17498    16.338726540  1059  Q   W 22095 + 8 [kjournald]
  8,0   10    17499    16.338726819  1059  M   W 22095 + 8 [kjournald]
  8,0   10    17500    16.338727300  1059  A   W 22103 + 8 <- (8,1) 22040
  8,0   10    17501    16.338727448  1059  Q   W 22103 + 8 [kjournald]
  8,0   10    17502    16.338727651  1059  M   W 22103 + 8 [kjournald]
  8,0   10    17503    16.338728145  1059  A   W 22111 + 8 <- (8,1) 22048
  8,0   10    17504    16.338728304  1059  Q   W 22111 + 8 [kjournald]
  8,0   10    17505    16.338728568  1059  M   W 22111 + 8 [kjournald]
  8,0   10    17506    16.338729100  1059  A   W 22119 + 8 <- (8,1) 22056
  8,0   10    17507    16.338729251  1059  Q   W 22119 + 8 [kjournald]
  8,0   10    17508    16.338729469  1059  M   W 22119 + 8 [kjournald]
  8,0   10    17509    16.338729980  1059  A   W 22127 + 8 <- (8,1) 22064
  8,0   10    17510    16.338730133  1059  Q   W 22127 + 8 [kjournald]
  8,0   10    17511    16.338730381  1059  M   W 22127 + 8 [kjournald]
  8,0   10    17512    16.338731606  1059  U   N [kjournald] 1
  8,0   10    17513    16.338740396  1059  D   W 21679 + 456 [kjournald]
  8,0   10    17514    16.341011279  7516  C   W 21679 + 456 [0]
  8,0   10    17515    16.341075110  1059  A   W 22135 + 8 <- (8,1) 22072
  8,0   10    17516    16.341075415  1059  Q   W 22135 + 8 [kjournald]
  8,0   10    17517    16.341077704  1059  G   W 22135 + 8 [kjournald]
  8,0   10    17518    16.341079074  1059  P   N [kjournald]
  8,0   10    17519    16.341079897  1059  I   W 22135 + 8 [kjournald]
  8,0   10    17520    16.341082865  1059  U   N [kjournald] 1
  8,0   10    17521    16.341088012  1059  D   W 22135 + 8 [kjournald]
  8,0   10    17522    16.341507489  7516  C   W 22135 + 8 [0]
  8,0    0        1    16.849527724  6225  U   N [distccd] 0
CPU0 (sda):
 Reads Queued:           0,        0KiB	 Writes Queued:           0,        0KiB
 Read Dispatches:        0,        0KiB	 Write Dispatches:        0,        0KiB
 Reads Requeued:         0		 Writes Requeued:         0
 Reads Completed:        0,        0KiB	 Writes Completed:        0,        0KiB
 Read Merges:            0,        0KiB	 Write Merges:            0,        0KiB
 Read depth:             1        	 Write depth:            32
 IO unplugs:             1        	 Timer unplugs:           0
CPU1 (sda):
 Reads Queued:           0,        0KiB	 Writes Queued:           0,        0KiB
 Read Dispatches:        0,        0KiB	 Write Dispatches:        0,        0KiB
 Reads Requeued:         0		 Writes Requeued:         0
 Reads Completed:        0,        0KiB	 Writes Completed:        0,        0KiB
 Read Merges:            0,        0KiB	 Write Merges:            0,        0KiB
 Read depth:             1        	 Write depth:            32
 IO unplugs:             2        	 Timer unplugs:           0
CPU5 (sda):
 Reads Queued:           0,        0KiB	 Writes Queued:           0,        0KiB
 Read Dispatches:        0,        0KiB	 Write Dispatches:        0,        0KiB
 Reads Requeued:         0		 Writes Requeued:         0
 Reads Completed:        0,        0KiB	 Writes Completed:        0,        0KiB
 Read Merges:            0,        0KiB	 Write Merges:            0,        0KiB
 Read depth:             1        	 Write depth:            32
 IO unplugs:             1        	 Timer unplugs:           0
CPU6 (sda):
 Reads Queued:           0,        0KiB	 Writes Queued:           0,        0KiB
 Read Dispatches:        0,        0KiB	 Write Dispatches:        0,        0KiB
 Reads Requeued:         0		 Writes Requeued:         0
 Reads Completed:        0,        0KiB	 Writes Completed:        0,        0KiB
 Read Merges:            0,        0KiB	 Write Merges:            0,        0KiB
 Read depth:             1        	 Write depth:            32
 IO unplugs:             3        	 Timer unplugs:           0
CPU8 (sda):
 Reads Queued:           0,        0KiB	 Writes Queued:           0,        0KiB
 Read Dispatches:        0,        0KiB	 Write Dispatches:        0,        0KiB
 Reads Requeued:         0		 Writes Requeued:         0
 Reads Completed:        0,        0KiB	 Writes Completed:        0,        0KiB
 Read Merges:            0,        0KiB	 Write Merges:            0,        0KiB
 Read depth:             1        	 Write depth:            32
 IO unplugs:             8        	 Timer unplugs:           0
CPU9 (sda):
 Reads Queued:           1,        4KiB	 Writes Queued:           0,        0KiB
 Read Dispatches:        1,        4KiB	 Write Dispatches:        0,        0KiB
 Reads Requeued:         0		 Writes Requeued:         0
 Reads Completed:        0,        0KiB	 Writes Completed:        0,        0KiB
 Read Merges:            0,        0KiB	 Write Merges:            0,        0KiB
 Read depth:             1        	 Write depth:            32
 IO unplugs:            20        	 Timer unplugs:           0
CPU10 (sda):
 Reads Queued:           1,       24KiB	 Writes Queued:       5,647,   22,588KiB
 Read Dispatches:        1,       24KiB	 Write Dispatches:      160,   22,588KiB
 Reads Requeued:         0		 Writes Requeued:         0
 Reads Completed:        4,      108KiB	 Writes Completed:      184,   22,684KiB
 Read Merges:            0,        0KiB	 Write Merges:        5,487,   21,948KiB
 Read depth:             1        	 Write depth:            32
 IO unplugs:            35        	 Timer unplugs:           0
CPU11 (sda):
 Reads Queued:           0,        0KiB	 Writes Queued:          24,       96KiB
 Read Dispatches:        0,        0KiB	 Write Dispatches:       24,       96KiB
 Reads Requeued:         0		 Writes Requeued:         0
 Reads Completed:        0,        0KiB	 Writes Completed:        0,        0KiB
 Read Merges:            0,        0KiB	 Write Merges:            0,        0KiB
 Read depth:             1        	 Write depth:            32
 IO unplugs:             1        	 Timer unplugs:           0
CPU12 (sda):
 Reads Queued:           0,        0KiB	 Writes Queued:           0,        0KiB
 Read Dispatches:        0,        0KiB	 Write Dispatches:        0,        0KiB
 Reads Requeued:         0		 Writes Requeued:         0
 Reads Completed:        0,        0KiB	 Writes Completed:        0,        0KiB
 Read Merges:            0,        0KiB	 Write Merges:            0,        0KiB
 Read depth:             1        	 Write depth:            32
 IO unplugs:             3        	 Timer unplugs:           0
CPU13 (sda):
 Reads Queued:           2,       80KiB	 Writes Queued:           0,        0KiB
 Read Dispatches:        2,       80KiB	 Write Dispatches:        0,        0KiB
 Reads Requeued:         0		 Writes Requeued:         0
 Reads Completed:        0,        0KiB	 Writes Completed:        0,        0KiB
 Read Merges:            0,        0KiB	 Write Merges:            0,        0KiB
 Read depth:             1        	 Write depth:            32
 IO unplugs:            15        	 Timer unplugs:           0
CPU15 (sda):
 Reads Queued:           0,        0KiB	 Writes Queued:           0,        0KiB
 Read Dispatches:        0,        0KiB	 Write Dispatches:        0,        0KiB
 Reads Requeued:         0		 Writes Requeued:         0
 Reads Completed:        0,        0KiB	 Writes Completed:        0,        0KiB
 Read Merges:            0,        0KiB	 Write Merges:            0,        0KiB
 Read depth:             1        	 Write depth:            32
 IO unplugs:             3        	 Timer unplugs:           0

Total (sda):
 Reads Queued:           4,      108KiB	 Writes Queued:       5,671,   22,684KiB
 Read Dispatches:        4,      108KiB	 Write Dispatches:      184,   22,684KiB
 Reads Requeued:         0		 Writes Requeued:         0
 Reads Completed:        4,      108KiB	 Writes Completed:      184,   22,684KiB
 Read Merges:            0,        0KiB	 Write Merges:        5,487,   21,948KiB
 IO unplugs:            92        	 Timer unplugs:           0

Throughput (R/W): 6KiB/s / 1,346KiB/s
Events (sda): 17,723 entries
Skips: 0 forward (0 -   0.0%)
Input file sda.blktrace.0 added
Input file sda.blktrace.1 added
Input file sda.blktrace.5 added
Input file sda.blktrace.6 added
Input file sda.blktrace.8 added
Input file sda.blktrace.9 added
Input file sda.blktrace.10 added
Input file sda.blktrace.11 added
Input file sda.blktrace.12 added
Input file sda.blktrace.13 added
Input file sda.blktrace.15 added
