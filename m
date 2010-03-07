Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab0CGU6l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 15:58:41 -0500
Received: from trinity.develer.com ([83.149.158.210]:38720 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab0CGU6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 15:58:39 -0500
From: Andrea Righi <arighi@develer.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Vivek Goyal <vgoyal@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       Greg Thelen <gthelen@google.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [PATCH -mmotm 0/4] memcg: per cgroup dirty limit (v5)
Date: Sun,  7 Mar 2010 21:57:50 +0100
Message-Id: <1267995474-9117-1-git-send-email-arighi@develer.com>
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
 - start to write-out (directly or background) when the cgroup limits are
   exceeded

This feature is supposed to be strictly connected to any underlying IO
controller implementation, so we can stop increasing dirty pages in VM layer
and enforce a write-out before any cgroup will consume the global amount of
dirty pages defined by /proc/sys/vm/dirty_ratio|dirty_bytes and
/proc/sys/vm/dirty_background_ratio|dirty_background_bytes.

Changelog (v4 -> v5)
~~~~~~~~~~~~~~~~~~~~~~
 * fixed a potential deadlock between lock_page_cgroup and mapping->tree_lock
   (I'm not sure I did the right thing for this point, so review and tests are
   very welcome)
 * introduce inc/dec functions to update file cache accounting
 * export only a restricted subset of mem_cgroup_stat_index flags
 * fixed a bug in determine_dirtyable_memory() to correctly return the local
   memcg dirtyable memory
 * always use global dirty memory settings in calc_period_shift()

-Andrea
