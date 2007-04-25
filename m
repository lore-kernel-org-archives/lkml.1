Return-Path: <linux-kernel-owner+w=401wt.eu-S2992642AbXDYLRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992642AbXDYLRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 07:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992578AbXDYLRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 07:17:38 -0400
Received: from wasp.net.au ([203.190.192.17]:48634 "EHLO wasp.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992642AbXDYLRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 07:17:37 -0400
Message-ID: <462F38CA.5070107@wasp.net.au>
Date: Wed, 25 Apr 2007 15:17:30 +0400
From: Brad Campbell <brad@wasp.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Degraded RAID performance - Was : Re: [OOPS] 2.6.21-rc6-git5 in cfq_dispatch_insert
References: <4621FAF0.7000705@wasp.net.au>	<46220339.9080205@wasp.net.au>	<4623FB29.1000603@redhat.com>	<17956.22235.574867.179016@notabene.brown>	<20070418123757.GC3796@kernel.dk>	<46261ACE.1050407@wasp.net.au>	<20070418132157.GC3720@kernel.dk>	<462B10C3.1030906@wasp.net.au>	<20070423073543.GE5311@kernel.dk>	<462E5D38.5000801@wasp.net.au>	<17967.4734.783140.512857@notabene.brown>	<462F2810.6000909@wasp.net.au> <17967.13461.154177.135843@notabene.brown>
In-Reply-To: <17967.13461.154177.135843@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown wrote:
> I wonder if we should avoid bypassing the stripe cache if the needed stripes
> are already in the cache... or if at least one needed stripe is.... or
> if the array is degraded...
> Probably in the degraded case we should never bypass the cache, as if
> we do, then a sequential read of a full stripe will read every block
> twice.  I'd better to some performance measurements.

Ok, that would explain some odd performance issues I've noticed.
Let's say I run

dstat -D sda,sdb,sdc,sdd,md0 5
----total-cpu-usage---- --disk/sda----disk/sdb----disk/sdc----disk/sdd----disk/md0- -net/total- 
---paging-- ---system--
usr sys idl wai hiq siq|_read write _read write _read write _read write _read write|_recv 
_send|__in_ _out_|_int_ _csw_
  25  22   0  47   0   6|20.1M    0 :20.2M    0 :20.1M    0 :   0     0 :40.2M    0 | 146B  662B| 
0     0 |1186   661
  26  20   0  46   0   8|19.4M    0 :19.4M    0 :19.4M    0 :   0     0 :38.9M    0 | 160B  549B| 
0     0 |1365   650

Given I'm doing a read, I would have expected a read to consist of 2 direct reads, one parity read 
and some calculation. The numbers I'm seeing however show 3 reads for 2 reads worth of bandwidth.

root@storage2:~# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sda[0] sdc[2] sdb[1]
       585934080 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]

(Dropped Jens and Chuck from the cc as this likely has little interest for them)

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
