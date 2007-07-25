Return-Path: <linux-kernel-owner+w=401wt.eu-S1761450AbXGYHJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761450AbXGYHJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 03:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754129AbXGYHJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 03:09:46 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:29308 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750944AbXGYHJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 03:09:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type;
  b=D5/lDAv+6E2pjdk1z/rlxns7t3aA6CJt95v4Hkg5dd1ltOYlUjYMoI68u3SjWFNtq89Xv4kIhKbp2fxKRI8Brm9ppVyy/jDOV65zwjvyPYbc5hkLS9RDpQs6Y0q1g6SRQwyn/v1Q42t7IZarZqnulcMzUDO7h4AyyYMTtsnmut8=  ;
X-YMail-OSG: Q36z8fIVM1mgAoyhKBzsYVmxuE51rNslli67Tw2Vck7y2JzL91FedhM1dPGvbHW3tVpv7FgyWg--
Message-ID: <46A6F732.3080905@yahoo.com.au>
Date: Wed, 25 Jul 2007 17:09:38 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Eric St-Laurent <ericstl34@sympatico.ca>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Fengguang Wu <fengguang.wu@gmail.com>, Dave Jones <davej@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>, riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tim Pepper <lnxninja@us.ibm.com>, Chris Snook <csnook@redhat.com>
Subject: Re: [PATCH 0/3] readahead drop behind and size adjustment
References: <20070721210005.000228000@chello.nl>	 <20070722023923.GA6438@mail.ustc.edu.cn> <20070722024428.GA724@redhat.com>	 <20070722081010.GA6317@mail.ustc.edu.cn>	 <1185093236.6344.87.camel@localhost.localdomain>	 <46A46E4B.7050007@yahoo.com.au> <1185338106.7105.44.camel@perkele>	 <46A6DD7F.1050505@yahoo.com.au> <1185344325.7105.91.camel@perkele>
In-Reply-To: <1185344325.7105.91.camel@perkele>
Content-Type: multipart/mixed;
 boundary="------------060602030106040203020802"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060602030106040203020802
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Eric St-Laurent wrote:
> On Wed, 2007-25-07 at 15:19 +1000, Nick Piggin wrote:
> 
> 
>>What *I* think is supposed to happen is that newly read in pages get
>>put on the inactive list, and unless they get accessed againbefore
>>being reclaimed, they are allowed to fall off the end of the list
>>without disturbing active data too much.
>>
>>I think there is a missing piece here, that we used to ease the reclaim
>>pressure off the active list when the inactive list grows relatively
>>much larger than it (which could indicate a lot of use-once pages in
>>the system).
> 
> 
> Maybe a new list should be added to put newly read pages in it. If they
> are not used or used once after a certain period, they can be moved to
> the inactive list (or whatever).
> 
> Newly read pages...
> 
> - ... not used after this period are excessive readahead, we discard
> immediately.
> - ... used only once after this period, we discard soon.
> - ... used many/frequently are moved to active list.
> 
> Surely the scan rate (do I make sense?) should be different for this
> newly-read list and the inactive list. 

A new list could be a possibility. One problem with adding lists is just
trying to work out how to balance scanning rates between them, another
problem is CPU overhead of moving pages from one to another... but don't
let me stop you if you want to jump in and try something :)


> I also remember your split mapped/unmapped active list patches from a
> while ago.
> 
> Can someone point me to a up-to-date documentation about the Linux VM?
> The books and documents I've seen are outdated.

If you just want to play with page reclaim algorithms, try reading over
mm/vmscan.c. If you don't know much about the Linux VM internals before,
don't worry too much about the fine details and start by getting an idea
of how pages move between the active and inactive lists.

I have Mel Gorman's, but I don't recall whether it covers the fine details
of page reclaim. But anyway it is still a good book.


>>I think I've been banned from touching vmscan.c, but if you're keen to
>>try a patch, I might be convinced to come out of retirement :)
> 
> 
> I'm more than willing!  Now that CFS is merged, redirect your energies
> from nicksched to nick-vm ;)
> 
> Patches against any tree (stable, linus, mm, rt) are good. But I prefer
> the last stable release because it narrows down the possible problems
> that a moving target like the development tree may have.
> 
> I test this on my main system, so patches with basic testing and
> reasonable stability are preferred. I just want to avoid data corruption
> bugs. FYI, I used to run the -rt tree most of the time.

OK here is one which just changes the rate that the active and inactive
lists get scanned. Data corruption bugs should be minimal ;)

-- 
SUSE Labs, Novell Inc.

--------------060602030106040203020802
Content-Type: text/plain;
 name="inactive-useonce.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="inactive-useonce.patch"

Index: linux-2.6/mm/vmscan.c
===================================================================
--- linux-2.6.orig/mm/vmscan.c
+++ linux-2.6/mm/vmscan.c
@@ -1011,6 +1011,8 @@ static unsigned long shrink_zone(int pri
 {
 	unsigned long nr_active;
 	unsigned long nr_inactive;
+	unsigned long scan_active;
+	unsigned long scan_inactive;
 	unsigned long nr_to_scan;
 	unsigned long nr_reclaimed = 0;
 
@@ -1020,34 +1022,47 @@ static unsigned long shrink_zone(int pri
 	 * Add one to `nr_to_scan' just to make sure that the kernel will
 	 * slowly sift through the active list.
 	 */
-	zone->nr_scan_active +=
-		(zone_page_state(zone, NR_ACTIVE) >> priority) + 1;
-	nr_active = zone->nr_scan_active;
-	if (nr_active >= sc->swap_cluster_max)
+	nr_active = zone_page_state(zone, NR_INACTIVE);
+	nr_inactive = zone_page_state(zone, NR_ACTIVE);
+
+	scan_inactive = (nr_inactive >> priority) + 1;
+
+	if (nr_active >= 4*(nr_inactive*2 + 1))
+		scan_active = 4*scan_inactive;
+	else {
+		unsigned long long tmp;
+
+		tmp = (unsigned long long)scan_inactive * nr_active;
+		do_div(tmp, nr_inactive*2 + 1);
+		scan_active = (unsigned long)tmp + 1;
+	}
+
+	zone->nr_scan_active += scan_active;
+	scan_active = zone->nr_scan_active;
+	if (scan_active >= sc->swap_cluster_max)
 		zone->nr_scan_active = 0;
 	else
-		nr_active = 0;
+		scan_active = 0;
 
-	zone->nr_scan_inactive +=
-		(zone_page_state(zone, NR_INACTIVE) >> priority) + 1;
-	nr_inactive = zone->nr_scan_inactive;
-	if (nr_inactive >= sc->swap_cluster_max)
+	zone->nr_scan_inactive += scan_inactive;
+	scan_inactive = zone->nr_scan_inactive;
+	if (scan_inactive >= sc->swap_cluster_max)
 		zone->nr_scan_inactive = 0;
 	else
-		nr_inactive = 0;
+		scan_inactive = 0;
 
-	while (nr_active || nr_inactive) {
-		if (nr_active) {
-			nr_to_scan = min(nr_active,
+	while (scan_active || scan_inactive) {
+		if (scan_active) {
+			nr_to_scan = min(scan_active,
 					(unsigned long)sc->swap_cluster_max);
-			nr_active -= nr_to_scan;
+			scan_active -= nr_to_scan;
 			shrink_active_list(nr_to_scan, zone, sc, priority);
 		}
 
-		if (nr_inactive) {
-			nr_to_scan = min(nr_inactive,
+		if (scan_inactive) {
+			nr_to_scan = min(scan_inactive,
 					(unsigned long)sc->swap_cluster_max);
-			nr_inactive -= nr_to_scan;
+			scan_inactive -= nr_to_scan;
 			nr_reclaimed += shrink_inactive_list(nr_to_scan, zone,
 								sc);
 		}

--------------060602030106040203020802--
