Return-Path: <linux-kernel-owner+w=401wt.eu-S934268AbZDJDBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934268AbZDJDBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 23:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759571AbZDJDBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 23:01:23 -0400
Received: from mga10.intel.com ([192.55.52.92]:24114 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763594AbZDJDBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 23:01:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,164,1239001200"; 
   d="scan'208";a="446690091"
Subject: sysbench(oltp)+mysql 10% regression with 2.6.30-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 10 Apr 2009 11:01:58 +0800
Message-Id: <1239332518.2567.781.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comparing with 2.6.29, oltp (sysbench+mysql) has 10% regression with
2.6.30-rc1 on 4*2 core stoakley. It's more than 10% on 4*4 core tigerton.
Bisect located below patch.

e52fb7c097238d34f4d8e2a596f8a3f85b0c0565 is first bad commit
commit e52fb7c097238d34f4d8e2a596f8a3f85b0c0565
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Wed Jan 14 12:39:19 2009 +0100

    sched: prefer wakers
    
    Prefer tasks that wake other tasks to preempt quickly. This improves
    performance because more work is available sooner.
    
    The workload that prompted this patch was a kernel build over NFS4 (for some
    curious and not understood reason we had to revert commit:
    18de9735300756e3ca9c361ef58409d8561dfe0d to make any progress at all)
    
    Without this patch a make -j8 bzImage (of x86-64 defconfig) would take
    3m30-ish, with this patch we're down to 2m50-ish.
    
    psql-sysbench/mysql-sysbench show a slight improvement in peak performance as
    well, tbench and vmark seemed to not care.


I run the testing with many thread numbers, such like 8, 12 16, 32, 64. The small
thread number has no much regression. Most regression is created with thread 32
and thread 64.

If the patch is reverted, the regression becomes very small.

With 2.6.30-rc1, tbench has about 1% improvement on stoakley and 2% on tigerton. If
I revert above patch, 1% improvement disappears.

yanmin


