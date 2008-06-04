Return-Path: <linux-kernel-owner+w=401wt.eu-S1757566AbYFDExJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbYFDExJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 00:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbYFDEw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 00:52:57 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48365 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbYFDEw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 00:52:56 -0400
Date: Wed, 4 Jun 2008 13:58:15 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "menage@google.com" <menage@google.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>
Subject: [RFC][PATCH 0/2] memcg: hierarchy support (v3)
Message-Id: <20080604135815.498eaf82.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, this is third version.

While small changes in codes, the whole _tone_ of code is changed.
I'm not in hurry, any comments are welcome.

based on 2.6.26-rc2-mm1 + memcg patches in -mm queue.

Changes from v2:
 - Named as HardWall policy.
 - rewrote the code to be read easily. changed the name of functions.
 - Added text.
 - supported hierarchy_model parameter.
   Now, no_hierarchy and hardwall_hierarchy is implemented.

HardWall Policy:
  - designed for strict resource isolation under hierarchy.
    Usually, automatic load balancing between cgroup can break the
    users assumption even if it's implemented very well.
  - parent overcommits all children
     parent->usage = resource used by itself + resource moved to children.
     Of course, parent->limit > parent->usage. 
  - when child's limit is set, the resouce moves.
  - no automatic resource moving between parent <-> child

Example)
  1) Assume a cgroup with 1GB limits. (and no tasks belongs to this, now)
     - group_A limit=1G,usage=0M.

  2) create group B, C under A.
     - group A limit=1G, usage=0M
          - group B limit=0M, usage=0M.
          - group C limit=0M, usage=0M.

  3) increase group B's limit to 300M.
     - group A limit=1G, usage=300M.
          - group B limit=300M, usage=0M.
          - group C limit=0M, usage=0M.

  4) increase group C's limit to 500M
     - group A limit=1G, usage=800M.
          - group B limit=300M, usage=0M.
          - group C limit=500M, usage=0M.

  5) reduce group B's limit to 100M
     - group A limit=1G, usage=600M.
          - group B limit=100M, usage=0M.
          - group C limit=500M, usage=0M.


Thanks,
-Kame

