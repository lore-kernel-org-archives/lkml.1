Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab0BUP0N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 10:26:13 -0500
Received: from trinity.develer.com ([83.149.158.210]:49249 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab0BUP0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 10:26:11 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Feb 2010 10:26:11 EST
From: Andrea Righi <arighi@develer.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Suleiman Souhlal <suleiman@google.com>, Vivek Goyal <vgoyal@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [RFC] [PATCH 0/2] memcg: per cgroup dirty limit
Date: Sun, 21 Feb 2010 16:18:43 +0100
Message-Id: <1266765525-30890-1-git-send-email-arighi@develer.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Control the maximum amount of dirty pages a cgroup can have at any given time.

Per cgroup dirty limit is like fixing the max amount of dirty (hard to reclaim)
page cache used by any cgroup. So, in case of multiple cgroup writers, they
will not be able to consume more than their designated share of dirty pages and
will be forced to perform write-out if they cross that limit.

The overall design is the following:

 - account dirty pages per cgroup
 - limit the number of dirty pages via memory.dirty_bytes in cgroupfs
 - start to write-out in balance_dirty_pages() when the cgroup or global limit
   is exceeded

This feature is supposed to be strictly connected to any underlying IO
controller implementation, so we can stop increasing dirty pages in VM layer
and enforce a write-out before any cgroup will consume the global amount of
dirty pages defined by the /proc/sys/vm/dirty_ratio|dirty_bytes limit.

TODO:
 - handle the migration of tasks across different cgroups (a page may be set
   dirty when a task runs in a cgroup and cleared after the task is moved to
   another cgroup).
 - provide an appropriate documentation (in Documentation/cgroups/memory.txt)

-Andrea
