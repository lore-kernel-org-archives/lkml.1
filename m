Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbZFHNBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbZFHNBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 09:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbZFHNBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 09:01:31 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53613 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587AbZFHNBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 09:01:30 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>, yanmin.zhang@intel.com,
       Wu Fengguang <fengguang.wu@intel.com>, linuxram@us.ibm.com
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] [RFC] Functional fix to zone_reclaim() and bring behaviour more in line with expectations
Date: Mon,  8 Jun 2009 14:01:27 +0100
Message-Id: <1244466090-10711-1-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bug was brought to my attention against a distro kernel but it affects
mainline and I believe problems like this have been reported in various guises
on the mailing lists although I don't have specific examples at the moment.

The problem that was reported that led to this patchset was that malloc()
stalled for a long time (minutes in some cases) if a large tmpfs mount
was occupying a large percentage of memory overall. The pages did not get
cleaned or reclaimed by zone_reclaim() because the zone_reclaim_mode was
unsuitable, but the lists are uselessly scanned frequencly making the CPU
spin at near 100%.

I do not have the bug resolved yet although I believe patch 1 of this series
addresses it and am waiting to hear back from the bug reporter. However,
the fix should work two other patches in this series also should bring
zone_reclaim() more in line with expectations.

Patch 1 reintroduces zone_reclaim_interval to catch the situation where
	zone_reclaim() cannot tell in advance that the scan is a waste
	of time.

Patch 2 alters the heuristics that zone_reclaim() uses to determine if the
	scan should go ahead. Currently, it is basically assuming
	zone_reclaim_mode is 1

Patch 3 notes that zone_reclaim() returning a failure automatically means
	the zone is marked full. This is not always true. It could have failed
	because the GFP mask or zone_reclaim_mode are unsuitable. The patch
	makes zone_reclaim() more careful about marking zones temporarily full

Note, this patchset has not been tested heavily.

Comments?

 Documentation/sysctl/vm.txt |   13 +++++++++++
 include/linux/mmzone.h      |    9 ++++++++
 include/linux/swap.h        |    1 +
 kernel/sysctl.c             |    9 ++++++++
 mm/internal.h               |    4 +++
 mm/page_alloc.c             |   26 +++++++++++++++++++---
 mm/vmscan.c                 |   48 +++++++++++++++++++++++++++++++++++++-----
 7 files changed, 100 insertions(+), 10 deletions(-)

