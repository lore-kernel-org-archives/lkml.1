Return-Path: <linux-kernel-owner+w=401wt.eu-S1762115AbXF0TJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762115AbXF0TJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 15:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757872AbXF0TJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 15:09:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:29485 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757259AbXF0TJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 15:09:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,467,1175497200"; 
   d="scan'208";a="259588733"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC PATCH 0/2] An evolutionary change to the raid456 queuing model
To: neilb@suse.de, raziebe@gmail.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 27 Jun 2007 12:09:23 -0700
Message-ID: <20070627190534.5685.34447.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Raz's stripe-deadline patch illuminated the fact that the current
queuing model leaves write performance on the table in some cases.  The
following patches introduce a new queuing model which attempts to
recover this performance.

On an ARM based iop13xx platform I see an averaged %14.7 increase in
throughput as reported by the following simple test:

	for i in `seq 1 10`; do dd if=/dev/zero of=/dev/md0 bs=1024k count=512; done

This was performed on a default configured 4-disk SATA array (chunksize=64k
stripe_cache_size=256)

However, a test with an ext2 filesystem and tiobench showed negligible
changes.  My suspicion is that the new queuing model, as it currently stands,
can extract some more performance when full stripe writes are present, but in
the tiobench case there is not enough to take advantage of the queue's preread
prevention logic (improving this case is the goal of releasing this version of
the patches).

These patches are on top of the md-accel series.  I will spin a complete
set based on 2.6.22 once it goes final (2.6.22-iop1 to be released on
SourceForge).  Until then the complete series is available via git:

	git://lost.foo-projects.org/~dwillia2/git/iop md-accel+experimental

Not to be confused with the acceleration patch set released yesterday which is
targetted at 2.6.23.  These queuing changes need some more time to cook.

-- 
Dan
