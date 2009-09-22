Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbZIVFtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbZIVFtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 01:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbZIVFtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 01:49:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:55017 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbZIVFtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 01:49:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,429,1249282800"; 
   d="scan'208";a="450537667"
Date: Tue, 22 Sep 2009 13:49:13 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: linux-kernel@vger.kernel.org
Cc: richard@rsk.demon.co.uk, a.p.zijlstra@chello.nl, jens.axboe@oracle.com,
       akpm@linux-foundation.org
Subject: regression in page writeback
Message-ID: <20090922054913.GA27260@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Commit d7831a0bdf06b9f722b947bb0c205ff7d77cebd8 causes disk io regression
in my test.
My system has 12 disks, each disk has two partitions. System runs fio sequence
write on all partitions, each partion has 8 jobs.
2.6.31-rc1, fio gives 460m/s disk io
2.6.31-rc2, fio gives about 400m/s disk io. Revert the patch, speed back to
460m/s

Under latest git: fio gives 450m/s disk io; If reverting the patch, the speed
is 484m/s.

With the patch, fio reports less io merge and more interrupts. My naive
analysis is the patch makes balance_dirty_pages_ratelimited_nr() limits
write chunk to 8 pages and then soon go to sleep in balance_dirty_pages(),
because most time the bdi_nr_reclaimable < bdi_thresh, and so when write
the pages out, the chunk is 8 pages long instead of 4M long. Without the patch,
thread can write 8 pages and then move some pages to writeback, and then
continue doing write. The patch seems to break this.

Unfortunatelly I can't figure out a fix for this issue, hopefully you have more
ideas.

Thanks,
Shaohua
