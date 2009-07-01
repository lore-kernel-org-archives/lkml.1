Return-Path: <linux-kernel-owner+w=401wt.eu-S1758231AbZGADZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231AbZGADZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 23:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754799AbZGADZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 23:25:10 -0400
Received: from mga07.intel.com ([143.182.124.22]:58950 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753884AbZGADZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 23:25:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,320,1243839600"; 
   d="scan'208";a="160307111"
Subject: fio sync read 4k block size 35% regression
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Nick Piggin <npiggin@suse.de>, Ying Han <yinghan@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 01 Jul 2009 11:25:33 +0800
Message-Id: <1246418733.2560.468.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comapraing with 2.6.30, fio sync read (block size 4k) has about 35% regression
with kernel 2.6.31-rc1 ﻿on my stoakley machine with a JBOD (13 SCSI disks).

Every disk has 1 partition and 4 1-GB files. Start 10 processes per disk to
do sy﻿nc read sequentinally.

Bisected down to below patch.

51daa88ebd8e0d437289f589af29d4b39379ea76 is first bad commit
commit 51daa88ebd8e0d437289f589af29d4b39379ea76
Author: Wu Fengguang <fengguang.wu@intel.com>
Date:   Tue Jun 16 15:31:24 2009 -0700

    readahead: remove sync/async readahead call dependency

    The readahead call scheme is error-prone in that it expects the call sites
    to check for async readahead after doing a sync one.  I.e.

                        if (!page)
                                page_cache_sync_readahead();
                        page = find_get_page();
                        if (page && PageReadahead(page))
                                page_cache_async_readahead();


I also test block size 64k and 128k, but they don't have regression. Perhaps
the default read_ahead_kb is equal to 128?

Other 2 machines have no such regression. The JBODS of the 2 machines consists
of 12 and 7 SATA/SAS disks while every disk has 2 partitions.



