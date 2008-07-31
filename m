Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbYGaLyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbYGaLyi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 07:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbYGaLya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 07:54:30 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37013 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbYGaLy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 07:54:29 -0400
Date: Thu, 31 Jul 2008 20:50:55 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Badari Pulavarty <pbadari@us.ibm.com>
Subject: [RFC:Patch: 000/008](memory hotplug) rough idea of pgdat removing
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-mm <linux-mm@kvack.org>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080731203549.2A3F.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

This patch set is first trial and to describe my rough idea of
"how to remove pgdat".

I would like to confirm "current my idea is good way or not" by this post.
This patch is incomplete and not tested yet, If my idea is good way,
I'll continue to make them and test.

I think pgdat removing is diffcult issue,
because any code doesn't know pgdat will be removed, and access
them without any locking now. But the pgdat remover must wait their access,
because the node may be removed electrically after it soon.

Current my idea is using RCU feature for waiting them.
Because it is the least impact against reader's performance,
and pgdat remover can wait finish of reader's access to pgdat
which is removing by synchronize_sched().

So, I made followings read_lock for accessing pgdat.
  - pgdat_remove_read_lock()/unlock()
  - pgdat_remove_read_lock_sleepable()/unlock_sleepable()
These definishions use rcu_read_lock and srcu_read_lock().

Writer uses node_set_offline() which uses clear_bit(),
and build_all_zonelists() with stop_machine_run().


There are a few types of pgdat access.

  1) via node_online_bitmap.
     Many code use for_each_xxx_node(), for_each_zone(), and so on.
     These code must be used with pgdat_remove_read_lock/unlock().

  2) mempolicy
     There are callback interface when memory offline works. mempolicy
     must use callbacks for disable removing node.
     This patch set includes quite simple (sample) patch to point
     what will be required. However more detail specification will be necessary.
     (ex, When preffered node of mempolicy is removing, how does kernel should do?)
  
  3) zonelist
     alloc_pages access zones via zonelist. However, zone may be removed
     by pgdat remover too. It must be check zones might be removed
     before accessing zonliest which is guarded between pgdat_remove_read_lock()
     and unlock().

  4) via NODE_DATA() with node_id.
     This type access is called with numa_node_id() in many case.
     Basically, CPUs on the removing node must be removed before removing node.
     So, I used BUG_ON() when numa_node_id() is points offlined node.
     
     If node id is specified by other way, offline_node must be checked and
     escape when it is offline...


If my idea is bad way, other way I can tell is...
  - read_write_lock(). (It should n't be used...)
  - collect pgdats on one node (depends on performance)

If you have better idea, please let me know.


Note: 
  - I don't add pgdat_remove_read_lock() on boot code.
    Because pgdat hot-removing will not work at boot time.
    (But I may overlook some places which must use pgdat_remove_read_lock() yet.)


Thanks.


-- 
Yasunori Goto 


