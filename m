Return-Path: <linux-kernel-owner+w=401wt.eu-S1761374AbYBBIMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761374AbYBBIMe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 03:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756620AbYBBIMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 03:12:25 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38851 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756570AbYBBIMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 03:12:24 -0500
Date: Sat, 02 Feb 2008 17:12:30 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Andi Kleen <andi@firstfloor.org>
Subject: [2.6.24-rc8-mm1][regression?] numactl --interleave=all doesn't works on memoryless node.
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20080202165054.F491.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I tested numactl on 2.6.24-rc8-mm1.
and I found strange behavior.

test method and result.

	$ numactl --interleave=all ls
	set_mempolicy: Invalid argument
	setting interleave mask: Invalid argument

numactl command download from
	ftp://ftp.suse.com/pub/people/ak/numa/
	(I choice numactl-1.0.2)


Of course, older kernel(RHEL5.1) works good.



more detail:

1. my machine node and memory.

$ numactl --hardware
available: 16 nodes (0-15)
node 0 size: 0 MB
node 0 free: 0 MB
node 1 size: 0 MB
node 1 free: 0 MB
node 2 size: 3872 MB
node 2 free: 1487 MB
node 3 size: 4032 MB
node 3 free: 3671 MB
node 4 size: 0 MB
node 4 free: 0 MB
node 5 size: 0 MB
node 5 free: 0 MB
node 6 size: 0 MB
node 6 free: 0 MB
node 7 size: 0 MB
node 7 free: 0 MB
node 8 size: 0 MB
node 8 free: 0 MB
node 9 size: 0 MB
node 9 free: 0 MB
node 10 size: 0 MB
node 10 free: 0 MB
node 11 size: 0 MB
node 11 free: 0 MB
node 12 size: 0 MB
node 12 free: 0 MB
node 13 size: 0 MB
node 13 free: 0 MB
node 14 size: 0 MB
node 14 free: 0 MB
node 15 size: 0 MB
node 15 free: 0 MB


2. numactl behavior of --interleave=all
   2.1  scan "/sys/devices/system/node" dir
   2.2  calculate max node number
   2.3  all bit turn on of existing node.
        (i.e. 0xFF generated on my environment.)
   2.4  call set_mempolicy()

3. 2.6.24-rc8-mm1 set_mempolicy(2) behavior
   3.1 check nodesubset(nodemask argument, node_states[N_HIGH_MEMORY])
       in mpol_check_policy()

	-> check failed when memmoryless node exist.
           (i.e. node_states[N_HIGH_MEMORY] of my machine is 0xc)

4. RHEL5.1 set_mempolicy(2) behavior
   4.1 check nodesubset(nodemask argument, node_online_map)
       in mpol_check_policy().

	-> check success.


I don't know wrong either kernel or libnuma.
Please any comments!


- kosaki



