Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966503Ab0BZWxB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 17:53:01 -0500
Received: from trinity.develer.com ([83.149.158.210]:37474 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966490Ab0BZWxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 17:53:00 -0500
From: Andrea Righi <arighi@develer.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Suleiman Souhlal <suleiman@google.com>, Vivek Goyal <vgoyal@redhat.com>,
       Greg Thelen <gthelen@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [PATCH -mmotm 0/2] memcg: per cgroup dirty limit (v2)
Date: Fri, 26 Feb 2010 23:52:29 +0100
Message-Id: <1267224751-6382-1-git-send-email-arighi@develer.com>
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
 - limit the number of dirty pages via memory.dirty_ratio / memory.dirty_bytes
   and memory.dirty_background_ratio / memory.dirty_background_bytes in
   cgroupfs
 - start to write-out (background or actively) when the cgroup limits are
   exceeded

This feature is supposed to be strictly connected to any underlying IO
controller implementation, so we can stop increasing dirty pages in VM layer
and enforce a write-out before any cgroup will consume the global amount of
dirty pages.

Changelog (v1 -> v2)
~~~~~~~~~~~~~~~~~~~~~~
 * rebased to -mmotm
 * properly handle hierarchical accounting
 * added the same system-wide interfaces to set dirty limits
   (memory.dirty_ratio / memory.dirty_bytes, memory.dirty_background_ratio, memory.dirty_background_bytes)
 * other minor fixes and improvements based on the received feedbacks

TODO:
 - handle the migration of tasks across different cgroups (maybe adding
   DIRTY/WRITEBACK/UNSTABLE flag to struct page_cgroup)
 - provide an appropriate documentation (in Documentation/cgroups/memory.txt)
