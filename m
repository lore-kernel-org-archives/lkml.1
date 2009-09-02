Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbZIBXRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbZIBXRG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 19:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753802AbZIBXRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 19:17:05 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:61837 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753AbZIBXRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 19:17:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=IviBxH9p6JABq3Zdk6AtwBFrJZULc8QKG7CgJClLfnwGeXyxB58DBPnCloYlnkt0Dq
         08yU9ztHkP6WZa0tUyR48jn49lFNI7QNr5ajUTyUGMOjMkWUg6Ynhrg11Nf5y1yTf4ff
         W5RazRGMZk7Y5odYRUg0lSx3JPL+KjRIAVBSw=
Date: Thu, 3 Sep 2009 08:15:48 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: [RESEND][PATCH mmotm] Fix NUMA accounting in numastat.txt
Message-Id: <20090903081548.482b8771.minchan.kim@barrios-desktop>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In Documentation/numastat.txt, it confused me.
For example, there are nodes [0,1] in system.

barrios:~$ cat /proc/zoneinfo | egrep 'numa|zone'
Node 0, zone	DMA
	numa_hit	33226
	numa_miss	1739
	numa_foreign	27978
	..
	..
Node 1, zone	DMA
	numa_hit	307
	numa_miss	46900
	numa_foreign	0

1) In node 0,  NUMA_MISS means it wanted to allocate page
in node 1 but ended up with page in node 0

2) In node 0, NUMA_FOREIGN means it wanted to allocate page
in node 0 but ended up with page from Node 1.

But now, numastat explains it oppositely about (MISS, FOREIGN).
Let's fix up with viewpoint of zone. 

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
---
 Documentation/numastat.txt |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/numastat.txt b/Documentation/numastat.txt
index 80133ac..9fcc9a6 100644
--- a/Documentation/numastat.txt
+++ b/Documentation/numastat.txt
@@ -7,10 +7,10 @@ All units are pages. Hugepages have separate counters.

 numa_hit			A process wanted to allocate memory from this node,
 					and succeeded.
-numa_miss			A process wanted to allocate memory from this node,
-					but ended up with memory from another.
-numa_foreign		A process wanted to allocate on another node,
-				    but ended up with memory from this one.
+numa_miss			A process wanted to allocate memory from another node,
+					but ended up with memory from this node.
+numa_foreign		A process wanted to allocate on this node,
+				    but ended up with memory from another one.
 local_node			A process ran on this node and got memory from it.
 other_node			A process ran on this node and got memory from another node.
 interleave_hit 		Interleaving wanted to allocate from this node
--
1.5.4.3



-- 
Kind regards,
Minchan Kim


-- 
Kind regards,
Minchan Kim
