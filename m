Return-Path: <linux-kernel-owner+w=401wt.eu-S1756030AbYE3Bhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbYE3Bhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 21:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbYE3Bho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 21:37:44 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54488 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbYE3Bhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 21:37:40 -0400
Date: Fri, 30 May 2008 10:43:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "menage@google.com" <menage@google.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Subject: [RFC][PATCH 0/2] memcg: simple hierarchy (v2)
Message-Id: <20080530104312.4b20cc60.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is rewritten version of memcg hierarchy handling.
...and I'm sorry tons of typos in v1.

Changelog:
  - fixed typo.
  - removed meaningless params (borrow)
  - renamed structure members.

not-for-test. just for discussion.  (I'll rewrite when our direction is fixed.)

Implemented Policy:
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

Why this is enough ?
  - A middleware can do various kind of resource balancing only by reseting "limit"
    in userland.


TODO(maybe)
  - rewrite force_empty to move the resource to the parent.

Thanks,
-Kame

