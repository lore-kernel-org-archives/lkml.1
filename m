Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab0CDKkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 05:40:37 -0500
Received: from trinity.develer.com ([83.149.158.210]:55293 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab0CDKkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 05:40:32 -0500
From: Andrea Righi <arighi@develer.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       Greg Thelen <gthelen@google.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [PATCH -mmotm 0/4] memcg: per cgroup dirty limit (v4)
Date: Thu,  4 Mar 2010 11:40:11 +0100
Message-Id: <1267699215-4101-1-git-send-email-arighi@develer.com>
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
dirty pages defined by the /proc/sys/vm/dirty_ratio|dirty_bytes and
/proc/sys/vm/dirty_background_ratio|dirty_background_bytes limits.

Changelog (v3 -> v4)
~~~~~~~~~~~~~~~~~~~~~~
 * handle the migration of tasks across different cgroups
   NOTE: at the moment we don't move charges of file cache pages, so this
   functionality is not immediately necessary. However, since the migration of
   file cache pages is in plan, it is better to start handling file pages
   anyway.
 * properly account dirty pages in nilfs2
   (thanks to Kirill A. Shutemov <kirill@shutemov.name>)
 * lockless access to dirty memory parameters
 * fix: page_cgroup lock must not be acquired under mapping->tree_lock
   (thanks to Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> and
    KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>)
 * code restyling

-Andrea
