Return-Path: <linux-kernel-owner+w=401wt.eu-S1753407AbZC0PKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbZC0PKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 11:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756260AbZC0PKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 11:10:23 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:57712 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757265AbZC0PKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 11:10:20 -0400
Message-Id: <20090327150905.819861420@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Mar 2009 16:09:05 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org
Cc: frankeh@watson.ibm.com, akpm@osdl.org, nickpiggin@yahoo.com.au,
       hugh@veritas.com, riel@redhat.com
Subject: [patch 0/6] Guest page hinting version 7.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,
the circus is back in town -- another version of the guest page hinting
patches. The patches differ from version 6 only in the kernel version,
they apply against 2.6.29. My short sniff test showed that the code
is still working as expected.

To recap (you can skip this if you read the boiler plate of the last
version of the patches):
The main benefit for guest page hinting vs. the ballooner is that there
is no need for a monitor that keeps track of the memory usage of all the
guests, a complex algorithm that calculates the working set sizes and for
the calls into the guest kernel to control the size of the balloons.
The host just does normal LRU based paging. If the host picks one of the
pages the guest can recreate, the host can throw it away instead of writing
it to the paging device. Simple and elegant.
The main disadvantage is the added complexity that is introduced to the
guests memory management code to do the page state changes and to deal
with discard faults.


Right after booting the page states on my 256 MB z/VM guest looked like
this (r=resident, p=preserved, z=zero, S=stable, U=unused,
P=potentially volatile, V=volatile):

<state>|--tot--|---r---|---p---|---z---|
    S  |  19719|  19673|      0|     46|
    U  | 235416|   2734|      0| 232682|
    P  |      1|      1|      0|      0|
    V  |   7008|   7008|      0|      0|
tot->  | 262144|  29416|      0| 232728|

about 25% of the pages are in voltile state. After grepping through the
linux source tree this picture changes:

<state>|--tot--|---r---|---p---|---z---|
    S  |  43784|  43744|      0|     40|
    U  |  78631|   2397|      0|  76234|
    P  |      2|      2|      0|      0|
    V  | 139727| 139727|      0|      0|
tot->  | 262144| 185870|      0|  76274|

about 75% of the pages are now volatile. Depending on the workload you
will get different results.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

