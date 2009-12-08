Return-Path: <linux-kernel-owner+w=401wt.eu-S935742AbZLHAH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935742AbZLHAH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 19:07:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935551AbZLHAH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 19:07:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935337AbZLHAHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 19:07:51 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] cfq-iosched: reduce write depth only if sync was delayed
References: <4b1a3d84.0d0db80a.39d0.ffff814a@mx.google.com>
	<4e5e476b0912050313k280caa8bjf7c2cf1c5d19c88c@mail.gmail.com>
	<4e5e476b0912060245x4d64300hb9689243bd712f2c@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 07 Dec 2009 19:07:51 -0500
In-Reply-To: <4e5e476b0912060245x4d64300hb9689243bd712f2c@mail.gmail.com>
	(Corrado Zoccolo's message of "Sun, 6 Dec 2009 11:45:16 +0100")
Message-ID: <x49ein6nx9k.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo <czoccolo@gmail.com> writes:

> Hi Jeff, I remember you saw large performance drop on your SAN for
> sequential writes with low_latency=1.  Can you test if Shaohua's and
> this patch fix allow to recover some bandwidth?  I think that enabling
> the queue depth ramp up only if a sync request was delayed should
> disable it for fast hardware like yours, so you should not be seeing
> the slowdown any more.

Average of 10 runs.  Low latency set to 0:

Unit information
================
File size = megabytes
Blk Size  = bytes
Rate      = megabytes per second
CPU%      = percentage of CPU used during the test
Latency   = milliseconds
Lat%      = percent of requests that took longer than X seconds
CPU Eff   = Rate divided by CPU% - throughput per cpu load

Sequential Reads
                              File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
Identifier                    Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
---------------------------- ------ ----- ---  ------ ------ --------- -----------  -------- -------- -----
2.6.32                        8192  65536   8   90.08 94.51%    51.316    10268.25   0.00000  0.00000    95
2.6.32                        8192  65536  16   99.36 199.8%    89.248    13883.81   0.00000  0.00000    50

Random Reads
                              File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
Identifier                    Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
---------------------------- ------ ----- ---  ------ ------ --------- -----------  -------- -------- -----
2.6.32                        8192  65536   8   81.16 85.90%    45.672     5963.19   0.00000  0.00000    94
2.6.32                        8192  65536  16  116.32 230.3%    58.371     6098.36   0.00000  0.00000    51

Sequential Writes
                              File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
Identifier                    Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
---------------------------- ------ ----- ---  ------ ------ --------- -----------  -------- -------- -----
2.6.32                        8192  65536   8  112.17 1085.%    42.623    17114.54   0.00152  0.00000    10
2.6.32                        8192  65536  16  111.26 2117.%    84.964    26480.60   0.03202  0.00000     5

Random Writes
                              File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
Identifier                    Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
---------------------------- ------ ----- ---  ------ ------ --------- -----------  -------- -------- -----
2.6.32                        8192  65536   8  162.48 887.1%     6.106      313.54   0.00000  0.00000    18
2.6.32                        8192  65536  16  156.38 1767.%    14.077     1254.62   0.00000  0.00000     9


Average of 10 runs.  Low latency set to 1:

Unit information
================
File size = megabytes
Blk Size  = bytes
Rate      = megabytes per second
CPU%      = percentage of CPU used during the test
Latency   = milliseconds
Lat%      = percent of requests that took longer than X seconds
CPU Eff   = Rate divided by CPU% - throughput per cpu load

Sequential Reads
                              File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
Identifier                    Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
---------------------------- ------ ----- ---  ------ ------ --------- -----------  -------- -------- -----
2.6.32                        8192  65536   8   92.23 100.1%    52.119     6920.18   0.00000  0.00000    92
2.6.32                        8192  65536  16   97.88 217.0%    99.691     7453.18   0.00000  0.00000    45

Random Reads
                              File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
Identifier                    Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
---------------------------- ------ ----- ---  ------ ------ --------- -----------  -------- -------- -----
2.6.32                        8192  65536   8   98.70 107.5%    42.994     3409.08   0.00000  0.00000    92
2.6.32                        8192  65536  16  140.41 323.9%    59.616     4525.46   0.00000  0.00000    43

Sequential Writes
                              File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
Identifier                    Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
---------------------------- ------ ----- ---  ------ ------ --------- -----------  -------- -------- -----
2.6.32                        8192  65536   8  112.33 1076.%    42.617    17072.28   0.00076  0.00000    10
2.6.32                        8192  65536  16  111.84 2097.%    85.156    28221.77   0.02976  0.00000     5

Random Writes
                              File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
Identifier                    Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
---------------------------- ------ ----- ---  ------ ------ --------- -----------  -------- -------- -----
2.6.32                        8192  65536   8  159.33 870.5%     6.469      765.50   0.00000  0.00000    18
2.6.32                        8192  65536  16  141.60 1632.%    15.364     2337.57   0.00000  0.00000     9


Cheers,
Jeff
