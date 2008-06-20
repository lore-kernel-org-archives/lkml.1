Return-Path: <linux-kernel-owner+w=401wt.eu-S1752247AbYFTKF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbYFTKF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 06:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754253AbYFTKFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 06:05:42 -0400
Received: from host102-127-dynamic.20-87-r.retail.telecomitalia.it ([87.20.127.102]:23688
	"EHLO linux.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754234AbYFTKFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 06:05:39 -0400
From: Andrea Righi <righi.andrea@gmail.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Menage <menage@google.com>,
       Carl Henrik Lunde <chlunde@ping.uio.no>
Cc: axboe@kernel.dk, matt@bluehost.com, roberto@unbit.it,
       randy.dunlap@oracle.com, Divyesh Shah <dpshah@google.com>,
       akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] cgroup: block device i/o bandwidth controller (v3)
Date: Fri, 20 Jun 2008 12:05:32 +0200
Message-Id: <1213956335-29866-1-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The goal of the i/o bandwidth controller is to improve i/o performance
predictability and provide better QoS for different cgroups sharing the same
block devices.

Respect to other priority/weight-based solutions the approach used by this
controller is to explicitly choke applications' requests that directly (or
indirectly) generate i/o activity in the system.

The direct bandwidth limiting method has the advantage of improving the
performance predictability at the cost of reducing, in general, the overall
performance of the system (in terms of throughput).

Detailed informations about design, its goal and usage are described in the
documentation.

Tested against latest git (2.6.26-rc6).

The all-in-one patch (and previous versions) can be found at:
http://download.systemimager.org/~arighi/linux/patches/io-throttle/

Changelog: (v2 -> v3)
  - scalability improvement: replaced the rbtree structure with a linked list
    to store multiple per block device I/O limiting rules; this allows to use
    RCU to protect the whole list structure, since the elements in the list are
    supposed to change rarely (this also provides zero overhead for cgroups
    that don't use any I/O limitation)
  - improved user interface
      - now it's possible to specify a suffix k, K, m, M, g, G to express
        bandwidth values in KB/s, MB/s or GB/s
      - current per block device I/O usage is reported in blockio.bandwidth
  - renamed cgroup_io_account() in cgroup_io_throttle()
  - updated the documentation

TODO:
  - implement I/O throttling using a token bucket algorithm, as suggested by
    Carl Henrik Lunde, in addition to the current leaky bucket approach
  - provide a modular interface to switch between different i/o throttling
    algorithms at run-time

-Andrea
