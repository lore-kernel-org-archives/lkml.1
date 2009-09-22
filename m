Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbZIVGjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbZIVGjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 02:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755202AbZIVGjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 02:39:09 -0400
Received: from viefep18-int.chello.at ([62.179.121.38]:48483 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162AbZIVGjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 02:39:08 -0400
X-SourceIP: 213.93.53.227
Subject: Re: regression in page writeback
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, richard@rsk.demon.co.uk,
       jens.axboe@oracle.com, akpm@linux-foundation.org,
       Chris Mason <chris.mason@oracle.com>,
       Wu Fengguang <fengguang.wu@intel.com>
In-Reply-To: <20090922054913.GA27260@sli10-desk.sh.intel.com>
References: <20090922054913.GA27260@sli10-desk.sh.intel.com>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 08:40:12 +0200
Message-Id: <1253601612.8439.274.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 13:49 +0800, Shaohua Li wrote:
> Hi,
> Commit d7831a0bdf06b9f722b947bb0c205ff7d77cebd8 causes disk io regression
> in my test.
> My system has 12 disks, each disk has two partitions. System runs fio sequence
> write on all partitions, each partion has 8 jobs.
> 2.6.31-rc1, fio gives 460m/s disk io
> 2.6.31-rc2, fio gives about 400m/s disk io. Revert the patch, speed back to
> 460m/s
> 
> Under latest git: fio gives 450m/s disk io; If reverting the patch, the speed
> is 484m/s.
> 
> With the patch, fio reports less io merge and more interrupts. My naive
> analysis is the patch makes balance_dirty_pages_ratelimited_nr() limits
> write chunk to 8 pages and then soon go to sleep in balance_dirty_pages(),
> because most time the bdi_nr_reclaimable < bdi_thresh, and so when write
> the pages out, the chunk is 8 pages long instead of 4M long. Without the patch,
> thread can write 8 pages and then move some pages to writeback, and then
> continue doing write. The patch seems to break this.
> 
> Unfortunatelly I can't figure out a fix for this issue, hopefully you have more
> ideas.

This whole writeback business is very fragile, the patch does indeed
cure a few cases and compounds a few other cases, typical trade off.

People are looking at it.

