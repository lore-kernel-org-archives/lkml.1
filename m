Return-Path: <linux-kernel-owner+w=401wt.eu-S1161137AbXCVWNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161137AbXCVWNl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 18:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161141AbXCVWNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 18:13:40 -0400
Received: from mga05.intel.com ([192.55.52.89]:37171 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161137AbXCVWNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 18:13:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,316,1170662400"; 
   d="scan'208"; a="217511160:sNHT25011217"
Subject: RSDL 0.31 causes slowdown
From: Tim Chen <tim.c.chen@linux.intel.com>
Reply-To: tim.c.chen@linux.intel.com
To: ck@vds.kolivas.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Intel
Date: Thu, 22 Mar 2007 13:21:46 -0800
Message-Id: <1174598506.23795.62.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con,

I've tried running Volanomark and found a 80% regression
with RSDL 0.31 scheduler on 2.6.21-rc4 on a 2 socket Core 2 quad cpu
system (4 cpus per socket, 8 cpus for system). 

The results are sensitive to rr_interval. Using Con's patch to increase
rr_interval to a large value of 100, 
the regression reduced to 30% instead of 80%.

I ran Volanomark in loopback mode with 10 chatrooms 
(20 clients per chatroom) configuration, with each client sending
out 10000 messages. 

http://www.volano.com/benchmarks.html

There are significant differences in the vmstat runqueue profile 
between the 2.6.21-rc4 and the one with RSDL.  

There are a lot less runnable jobs (see col 2) with RSDL 0.31  (rr_interval=15)
and higher idle time.

2.6.21-rc4 (original)
Time	procs -----------memory---------- ---swap-- -----io---- --system-- ----cpu----
(sec)	r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa st

10	 2  3      0 2642376  15320 194612    0    0   161   875   44   70  1  1 92  5  0
20	379  0      0 1573484  15680 195152    0    0    46   237  350 152686  9  8 81  2  0
30	395  0      0 1579056  15704 195152    0    0     0    30  284 1017337 44 48  8  0  0
40	469  0      0 1586368  15744 195144    0    0     0    50  284 1075456 42 51  7  0  0
50	425  0      0 1593628  15756 195156    0    0     0    40  289 1108785 41 52  6  0  0
60	394  0      0 1599452  15772 195156    0    0     0    31  284 1160316 41 53  5  0  0
70	65  0      0 1599684  15788 195160    0    0     0    20  284 1075719 40 52  8  0  0
80	424  0      0 1599320  15928 195168    0    0     1   122  314 1187583 41 54  4  0  0
90	438  0      0 1600188  15944 195164    0    0     0    41  289 1171807 40 53  6  0  0
100	412  0      0 1599312  15968 195160    0    0     0    22  284 1183832 41 54  5  0  0
110	398  0      0 1599716  15976 195176    0    0     0     6  283 1227036 42 55  3  0  0
120	382  0      0 1599468  15992 195180    0    0     0    23  286 1160802 40 54  6  0  0
130	370  0      0 1599912  16008 195180    0    0     0    10  284 1159618 42 52  7  0  0

2.6.21-rc4 with RSDL 0.31 
Time	procs -----------memory---------- ---swap-- -----io---- --system-- ----cpu----
(sec)	r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa st
10	 2  3      0 2644892  15316 194612    0    0   160   869   44   64  1  1 92  5  0
20	 2  0      0 1577512  15388 194984    0    0    24    93  293 3935  3  2 95  1  0
30	 2  0      0 1583888  15412 194984    0    0     0    33  284 638668 28 39 33  0  0
40	 2  0      0 1591208  15444 194972    0    0     0    50  284 307181 19 28 53  0  0
50	 4  0      0 1598364  15460 194980    0    0     0    39  285 311971 18 29 53  0  0
60	 8  0      0 1604108  15476 194980    0    0     0    29  284 308109 18 29 53  0  0
70	 9  0      0 1603792  15492 194992    0    0     0     8  283 315947 18 29 52  0  0
80	11  0      0 1602440  15784 195032    0    0    20   161  342 310849 18 29 52  1  0
90	 1  0      0 1602504  15792 195160    0    0     0    37  287 317667 18 29 53  0  0
100	 1  0      0 1603140  15824 195144    0    0     0    25  284 319106 18 30 52  0  0
110	 7  0      0 1602760  15832 195160    0    0     0     6  283 316589 17 29 53  0  0
120	12  0      0 1602644  15848 195164    0    0     0    22  285 320019 17 30 52  0  0
130	 1  0      0 1602644  15864 195164    0    0     0    10  283 319537 17 30 53  0  0
140	 6  0      0 1601744  16016 195176    0    0     2   104  312 316836 18 30 52  0  0

2.6.21-rc4 with RSDL 0.31, rr_interval = 100

Time	procs -----------memory---------- ---swap-- -----io---- --system-- ----cpu----
(sec)	r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa st
10       4  2      0 2679976  16696 195380    0    0    65   353   40   33  0  1 97  2  0
20      296  0      0 1602676  16780 195764    0    0    22   104  294 151873  8  9 82  1  0
30      298  0      0 1601280  16808 195756    0    0     0    14  284 1164355 41 56  3  0  0
40      272  0      0 1600108  16832 195764    0    0     0    12  284 1205454 42 57  1  0  0
50      321  0      0 1599128  16848 195760    0    0     0    25  287 1209822 41 58  1  0  0
60      281  0      0 1598764  16864 195760    0    0     0    12  283 1206452 41 57  2  0  0
70      287  0      0 1598888  16880 195764    0    0     0    15  284 1206103 40 58  2  0  0
80      276  0      0 1597764  16904 195776    0    0     0    33  285 1193156 39 58  3  0  0
90      293  0      0 1598144  16920 195780    0    0     0    14  284 1215350 39 59  2  0  0
100     287  0      0 1598260  16936 195780    0    0     0    11  283 1236433 40 58  2  0  0
110     257  0      0 1597872  16952 195784    0    0     0    10  283 1234983 40 59  1  0  0
120     255  0      0 1598640  16968 195784    0    0     0    16  284 1178551 39 58  3  0  0
130     200  0      0 1598764  16984 195788    0    0     0    13  284 1223963 39 59  2  0  0
140     274  0      0 1598632  17008 195792    0    0     0    22  284 1179931 40 57  3  0  0
150     278  0      0 1598616  17024 195792    0    0     0    21  286 1215157 39 59  2  0  0

- Tim 
