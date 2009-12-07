Return-Path: <linux-kernel-owner+w=401wt.eu-S1757294AbZLGOgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294AbZLGOgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 09:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756515AbZLGOgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 09:36:31 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:55804 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491AbZLGOga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 09:36:30 -0500
Message-ID: <4B1D12E7.4070701@linux.vnet.ibm.com>
Date: Mon, 07 Dec 2009 15:36:23 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>, Elladan <elladan@eskimo.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>
CC: epasch@de.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Increased Buffers due to patch 56e49d (vmscan: evict use-once pages
 first), but why exactly?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
commit 56e49d - "vmscan: evict use-once pages first" changed behavior of 
memory management quite a bit which should be fine.
But while tracking down a performance regression I was on the wrong path 
for a while suspecting this patch is causing the regression.
Fortunately this was not the case, but I got some interesting data which 
I couldn't explain completely and I thought maybe its worth to get it 
clarified publicly in case someone else looks at similar data again :-)

All is about the increased amount of "Buffers" accounted as active while 
loosing the same portion from "Cache" accounted as inactive in 
/proc/meminfo.
I understand that with the patch applied there will be some more 
pressure to file pages until the balance of active/inactive file pages 
is reached.
But I didn't get how this prefers buffers compared to cache pages (I 
assume dropping inactive before active was the case all the time so that 
can't be the only difference between buffers/cache).

The scenario I'm running is a low memory system (256M total), that does 
sequential I/O with parallel iozone processes.
One process per disk, each process reading a 2Gb file. The issue occurs 
independent type of disks I use. File system is ext2.
While bisecting even 4 parallel reads from 2Gb files in /tmp were enough 
to see a different amount of buffers in /proc/meminfo.

Looking at the data I got from /proc/meminfo (only significant changes):
                     before    with 56e49d  large devs
MemTotal:         250136 kB      250136 kB
MemFree:            6760 kB        6608 kB
Buffers:            2324 kB       34960 kB      +32636
Cached:            84296 kB       45860 kB      -38436
SwapCached:          392 kB        1416 kB
Active:             6292 kB       38388 kB      +32096
Inactive:          89360 kB       51232 kB      -38128
Active(anon):       4004 kB        3496 kB
Inactive(anon):     8824 kB        9164 kB
Active(file):       2288 kB       34892 kB      +32604
Inactive(file):    80536 kB       42068 kB      -38468
Slab:             106624 kB      112364 kB       +5740
SReclaimable:       5856 kB       11860 kB       +6004
[...]

 From slabinfo I know that the slab increase is just secondary due to 
more structures to e.g. organize the buffers (buffer_head).
I would understand if file associated memory would now shrink in favor 
of non file memory after this patch.
But I can't really see in the code where buffers are favored in 
comparison to cached pages - (it very probably makes sense to do so, as 
they might contain e.g. the inode data about the files in cache).
I think an explanation how that works might be useful for more people 
than just me, so comments welcome.

Kind regards,
Christian

-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, Open Virtualization 

