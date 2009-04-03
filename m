Return-Path: <linux-kernel-owner+w=401wt.eu-S1758307AbZDCIK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307AbZDCIK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 04:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbZDCIKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 04:10:10 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47195 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbZDCIKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 04:10:06 -0400
Date: Fri, 3 Apr 2009 17:08:35 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: [RFC][PATCH 0/9] memcg soft limit v2 (new design)
Message-Id: <20090403170835.a2d6cbc3.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Memory cgroup's soft limit feature is a feature to tell global LRU 
"please reclaim from this memcg at memory shortage".

This is v2. Fixed some troubles under hierarchy. and increase soft limit
update hooks to proper places.

This patch is on to
  mmotom-Mar23 + memcg-cleanup-cache_charge.patch
  + vmscan-fix-it-to-take-care-of-nodemask.patch

So, not for wide use ;)

This patch tries to avoid to use existing memcg's reclaim routine and
just tell "Hints" to global LRU. This patch is briefly tested and shows
good result to me. (But may not to you. plz brame me.)

Major characteristic is.
 - memcg will be inserted to softlimit-queue at charge() if usage excess
   soft limit.
 - softlimit-queue is a queue with priority. priority is detemined by size
   of excessing usage.
 - memcg's soft limit hooks is called by shrink_xxx_list() to show hints.
 - Behavior is affected by vm.swappiness and LRU scan rate is determined by
   global LRU's status.

In this v2.
 - problems under use_hierarchy=1 case are fixed.
 - more hooks are added.
 - codes are cleaned up.

Shows good results on my private box test under several work loads.

But in special artificial case, when victim memcg's Active/Inactive ratio of
ANON is very different from global LRU, the result seems not very good.
i.e.
  under vicitm memcg, ACTIVE_ANON=100%, INACTIVE=0% (access memory in busy loop)
  under global, ACTIVE_ANON=10%, INACTIVE=90% (almost all processes are sleeping.)
memory can be swapped out from global LRU, not from vicitm.
(If there are file cache in victims, file cacahes will be out.)

But, in this case, even if we successfully swap out anon pages under victime memcg,
they will come back to memory soon and can show heavy slashing.

While using soft limit, I felt this is useful feature :)
But keep this RFC for a while. I'll prepare Documentation until the next post.

Thanks,
-Kame

