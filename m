Return-Path: <linux-kernel-owner+w=401wt.eu-S1752815AbZKCOmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbZKCOmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 09:42:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbZKCOmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 09:42:04 -0500
Received: from mga09.intel.com ([134.134.136.24]:31194 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbZKCOmD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 09:42:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,674,1249282800"; 
   d="scan'208";a="566081108"
From: "Shi, Alex" <alex.shi@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 3 Nov 2009 22:42:03 +0800
Subject: kernel building regression on 32-rc5 kernel 
Thread-Topic: kernel building regression on 32-rc5 kernel 
Thread-Index: Acpck88uviHr1QQwRnK4Dz5qxJJPCQ==
Message-ID: <F7C8A4D3A9905B45A80E4C194793FA651553C00D40@PDSMSX501.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found the kernel building will have about 20%~ 30% regressions on our NHM machines. My kernel build do the following things 15 times: 
make mrproper; echo \"3\">/proc/sys/vm/drop_caches; make defconfig; make -j${2timescpunumbers}
Bisect found it is due to the commitment: 
commit a6151c3a5c8e1ff5a28450bc8d6a99a2a0add0a7
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Wed Oct 7 20:02:57 2009 +0200
 
    cfq-iosched: apply bool value where we return 0/1

It quite makes me confused, but after reverting this patch the performance recovered. I analyzed the vmstat and "perf record" results, But did not find something strange. Just the "perf stat" shows something different.  
 

Perf stat output of Rc5 kernel: 

  850121.335684  task-clock-msecs         #      1.035 CPUs
         867280  context-switches         #      0.001 M/sec
         266319  CPU-migrations           #      0.000 M/sec
       76663435  page-faults              #      0.090 M/sec
  2697372004020  cycles                   #   3172.926 M/sec  (scaled from 100.00%)
  2779762582367  instructions             #      1.031 IPC    (scaled from 100.00%)
    14230675659  cache-references         #     16.740 M/sec  (scaled from 100.00%)
     3048368747  cache-misses             #      3.586 M/sec  (scaled from 100.00%)
 
821.432570507  seconds time elapsed

 Perf stat output of rc5 without the commit kernel:
  900054.808787  task-clock-msecs         #      1.237 CPUs
         845152  context-switches         #      0.001 M/sec
         252689  CPU-migrations           #      0.000 M/sec
       77495232  page-faults              #      0.086 M/sec
  2470286471361  cycles                   #   2744.596 M/sec
  2684134677043  instructions             #      1.087 IPC
    14685367142  cache-references         #     16.316 M/sec
     2869381827  cache-misses             #      3.188 M/sec
 
  727.415980216  seconds time elapsed

BRG
Alex
