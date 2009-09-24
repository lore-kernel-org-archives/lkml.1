Return-Path: <linux-kernel-owner+w=401wt.eu-S1752973AbZIXXym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbZIXXym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 19:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbZIXXym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 19:54:42 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42619 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbZIXXyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 19:54:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4ABC068A.6070704@jp.fujitsu.com>
Date: Fri, 25 Sep 2009 08:53:46 +0900
From: sat <takeuchi_satoru@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, Con Kolivas <kernel@kolivas.org>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Raistlin <raistlin@linux.it>
Subject: massive_intr on CFS, BFS, and EDF
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tried massive_intr, a process scheduler's fairness and throughtput testing
program for massive interactive processes, on vanilla 2.6.31, 2.6.31-bfs211
(with BFS) and 2.6.31-edf(latest linus tree + EDF patch).

CFS and BFS look good. CFS has better fairness, and BFS has better throughput.
EDF looks unfair and is unstable. I tested 3 times and the tendency was the
same.

  NOTE:

  - BFS patch is applied to 2.6.31, but EDF patch is applied to latest linus
    tree, so they can't compare strictly. This report is just FYI.

  - EDF kernel shows some strange behavior as follows:

     * aptitude(debian package management tool) stacks on the way
     * oocalc doesn't start

  - I dont't subscribe lkml now. So if you reply, pleas CC me.

Thanks,
Satoru

===============================================================================

[ test envinronment ]

A laptop machine with x86_64 dual core CPU

[ test program ]

 # CFS and BFS:
 $ massive_intr 30 30

 # EDF
 $ schedtool -E -d 100000 -b 25000 -e ./massive_intr 30 30

It means running 30 interactive processes simultaneously for 30 secs.
Full description of this program is on the comments of source code.

URL:
http://people.redhat.com/mingo/cfs-scheduler/tools/massive_intr.c

[ test result ]

+---------------+-----------+---------+---------+---------+-----------+
| kernel        | scheduler | avg(*1) | min(*2) | max(*3) | stdev(*4) |
+---------------+-----------+---------+---------+---------+-----------+
| 2.6.31        |       CFS |     246 |     240 |     247 |       1.3 |
| 2.6.31-bfs211 |       BFS |     254 |     241 |     268 |       7.1 |
+---------------+-----------+---------+---------+---------+-----------+
| 2.6.31-edf(*5)|       EDF |     440 |     154 |    1405 |     444.8 |
+---------------+-----------+---------+---------+---------+-----------+

*1) average number of loops among all processes
*2) minimum number of loops among all processes
*3) maximum number of loops among all processes
*4) standard deviation
*5) EDF kernel hanged up on the way. The data is only among 7 threads.

High average means good throughput, and low stdev means good fairness.

[raw data]

# vanilla 2.6.31 (CFS)
sat@debian:~/practice/bfs$ uname -r
2.6.31
sat@debian:~/practice/bfs$ ./massive_intr 30 30
003873	00000246
003893	00000246
003898	00000240
003876	00000245
003888	00000245
003870	00000245
003882	00000247
003890	00000245
003872	00000245
003880	00000246
003895	00000246
003892	00000246
003878	00000246
003874	00000246
003896	00000246
003897	00000246
003884	00000246
003891	00000246
003894	00000246
003871	00000246
003886	00000247
003877	00000246
003879	00000246
003889	00000246
003881	00000246
003899	00000244
003887	00000247
003875	00000247
003885	00000247
003883	00000247

# 2.6.31-bfs211
sat@debian:~/practice/bfs$ uname -r
2.6.31-bfs211
sat@debian:~/practice/bfs$ ./massive_intr 30 30
004143	00000248
004127	00000241
004154	00000252
004145	00000255
004137	00000251
004148	00000263
004135	00000261
004153	00000247
004132	00000250
004146	00000248
004140	00000251
004130	00000245
004138	00000267
004136	00000249
004139	00000262
004141	00000255
004147	00000251
004131	00000253
004150	00000254
004152	00000254
004129	00000253
004142	00000242
004151	00000268
004128	00000263
004134	00000260
004144	00000252
004133	00000254
004149	00000265
004126	00000252
004125	00000246

# 2.6.31-edf (latest linus tree + edf patch)
sat@debian:~/practice/bfs$ uname -r
2.6.31-edf
sat@debian:~/practice/bfs$ schedtool-edf/schedtool -E -d 100000 -b
25000 -e ./massive_intr 30 30
Dumping mode: 0xa
Dumping affinity: 0xffffffff
We have 3 args to do
Dump arg 0: ./massive_intr
Dump arg 1: 30
Dump arg 2: 30
003915	00000541
003914	00001405
003916	00000310
003924	00000177
003923	00000154
003917	00000280
003918	00000211
# <kernel hunged up here>



