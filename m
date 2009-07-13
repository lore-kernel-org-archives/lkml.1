Return-Path: <linux-kernel-owner+w=401wt.eu-S1753873AbZGMGpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbZGMGpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 02:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbZGMGp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 02:45:28 -0400
Received: from elasmtp-scoter.atl.sa.earthlink.net ([209.86.89.67]:51197 "EHLO
	elasmtp-scoter.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752322AbZGMGp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 02:45:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=jH3FZ8+9S8fWPIvJCAHKPiH5HqNRfhsOddBbia7OWmMVei/amwj6RDBVqVIIFjkZ;
  h=Received:Message-Id:From:To:Content-Type:Content-Transfer-Encoding:Mime-Version:Subject:Date:X-Mailer:X-ELNK-Trace:X-Originating-IP;
Message-Id: <23666D7E-F36B-432E-A134-AFB826E996EA@earthlink.net>
From: Mitchell Erblich <erblichs@earthlink.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Suggested code change: slab.c : Moderately simple : reap based on last access time and show LAST access AGE
Date: Sun, 12 Jul 2009 23:45:26 -0700
X-Mailer: Apple Mail (2.930.3)
X-ELNK-Trace: 074f60c55517ea841aa676d7e74259b7b3291a7d08dfec7948af9e6e812430b5d0f0c5d6accc71eb350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 98.234.127.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	* The basis of the below changes deal with STANDARD rules that caches
	are time dependent when dealing with their objects. We assume re-use
	shortly after frees and as time moves forward a lower percentage of  
objects
	will be re-used.

	If I understand the Linux SLAB implementation then ..

	SLAB Caches IMO should NORMALLY be reaped ONLY after X time has  
passed after
	the last object is freed and movement of the slab to the freelist.

	It is logical that on a freq alloc/free/alloc repeated sequences that a
	reasonable time has NOT passed and the drain_freelist() will release
	a slab that would be re-used for the next alloc.

	Secondly, if and when CERTAIN events are pending (ie: extremely low  
free memory)
	then the time since should be ignored and all available free slabs  
should be
	re-used / slab_destroy().

	Suggested something like code:

	To add flexibility : add a /proc variable for "X time"
	OR
	#define   FREE_SLAB_AFTER 10	/*secs */

	Thus ..

		in struct slab : add an entry : unsigned long went_free;   /* time  
slab went free */
		Use ALSO as last object inuse changes
		

	drain_freelist():

		Add a boolean arg to drain_freelist() FREE_SOME_EMPTYS or  
FREE_ALL_EMPTYS
		and FUNCTION_CALLERS
		and convert the tofree to the boolean
	
		
		/* After X secs have passed or FREE_ALL_EMPTYS, then destroy/re-use */
		if (  (! (time_after(jiffies, slabp->went_free ) &&  
(FREE_SOME_EMPTYS)))
		    continue;


	TODO:   set jiffy time ONLY when it when it changes  (slabp->inuse =  
0;) and ++ / --
		       slabp->went_free = jiffies;
		alloc_slabmgt();
		slab_get_object();
		slab_put_object();


	/* By adding a jiffies slab struct item */
	/* Adding debug set of the jiffies anytime the SLAB is accessed and a  
like drain
		function looking for leaks say every hour could be done.
	Locating these slabs could then SET WARNings, as it indicates a  
MEMORY LEAK?
	Could be done in check_slabp for age greater than 1 hr

	and s_show() can print the age of the slab .. convert jiffies...
	SHOWS age and last usage..

	Mitchell Erblich
	



	
