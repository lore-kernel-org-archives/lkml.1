Return-Path: <linux-kernel-owner+w=401wt.eu-S1757606AbZGMWl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606AbZGMWl7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 18:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757598AbZGMWl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 18:41:58 -0400
Received: from elasmtp-masked.atl.sa.earthlink.net ([209.86.89.68]:51145 "EHLO
	elasmtp-masked.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753562AbZGMWl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 18:41:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=WzUTkrnULUOv1DDpcNAqYjFK9fquMxxZsHX9VkDsA+hAVQq90TcYnsIkZwRnXZqj;
  h=Received:Cc:Message-Id:From:To:In-Reply-To:Content-Type:Content-Transfer-Encoding:Mime-Version:Subject:Date:References:X-Mailer:X-ELNK-Trace:X-Originating-IP;
Cc: linux-kernel@vger.kernel.org
Message-Id: <36700971-D87E-4EEA-A490-93C97F0625F8@earthlink.net>
From: Mitchell Erblich <erblichs@earthlink.net>
To: Mitchell Erblich <erblichs@earthlink.net>
In-Reply-To: <23666D7E-F36B-432E-A134-AFB826E996EA@earthlink.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Suggested code change: slab.c : #2 Moderately simple : reaping based on AGE since empty
Date: Mon, 13 Jul 2009 15:41:53 -0700
References: <23666D7E-F36B-432E-A134-AFB826E996EA@earthlink.net>
X-Mailer: Apple Mail (2.930.3)
X-ELNK-Trace: 074f60c55517ea841aa676d7e74259b7b3291a7d08dfec79dc0e5607893a52e877edc4b6d3424a66350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 98.234.127.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Group,

	Step two.. My guess will require maybe 15-20 steps

	Continuing with the back end of the Linux slab allocator.

	First, if we really want a general idea, we/I am currently suggesting  
a set of
	changes dealing with attempting to match AGE of empty slabs with  
possible
	working sets and allowing future allocs to reclaim emptys if they  
occur within
	a timeframe.

	We will consume more CPU cycles to attempt to reach a stasis of aged  
emptys
	but we won't reclaim them until they have a min age. Thus, don't reap  
infant
	empty's while at high memory, but do some reaping so we don't consume
	enough solely due to caching / emptys.

	But since we are dealing with an active system, available memory  
levels will
	change and FREE_SOME_EMPTYs will relate to the low watermark. Above  
high
	watermark we search mainly for memory leaks and reclaim above 30sec  
of empty
	slabs. At Low we reclaim the emptys at 10+ or what was set. At the  
min watermark
	we default to the orig logic, but the tofree gets ignored and we  
attempt to walk and
	reclaim all empty's.

	so,

	the defs now become
	#define FREE_SLAB_AT_MIN_MEM		0	/* secs */
	#define FREE_SLAB_AT_LOW_MEM		10	/* "    "   */
	#define FREE_SLAB_AT_HIGH_MEM		30	/*  "   "    */

	Mitchell Erblich
	PS: My intention is to submit the code changes (diffs/patch) at the  
end of the year, if their is
		interest, with benchmarks.     PS (/* jiffies*/ /went_free * HZ  
equals secs..
	===========================================
							

	Now, the past #1 gave us two reaping watermarks
On Jul 12, 2009, at 11:45 PM, Mitchell Erblich wrote:

>
> 	* The basis of the below changes deal with STANDARD rules that caches
> 	are time dependent when dealing with their objects. We assume re-use
> 	shortly after frees and as time moves forward a lower percentage of  
> objects
> 	will be re-used.
>
> 	If I understand the Linux SLAB implementation then ..
>
> 	SLAB Caches IMO should NORMALLY be reaped ONLY after X time has  
> passed after
> 	the last object is freed and movement of the slab to the freelist.
>
> 	It is logical that on a freq alloc/free/alloc repeated sequences  
> that a
> 	reasonable time has NOT passed and the drain_freelist() will release
> 	a slab that would be re-used for the next alloc.
>
> 	Secondly, if and when CERTAIN events are pending (ie: extremely low  
> free memory)
> 	then the time since should be ignored and all available free slabs  
> should be
> 	re-used / slab_destroy().
>
> 	Suggested something like code:
>
> 	To add flexibility : add a /proc variable for "X time"
> 	OR
> 	#define   FREE_SLAB_AFTER 10	/*secs */
>
> 	Thus ..
>
> 		in struct slab : add an entry : unsigned long went_free;   /* time  
> slab went free */
> 		Use ALSO as last object inuse changes
> 		
>
> 	drain_freelist():
>
> 		Add a boolean arg to drain_freelist() FREE_SOME_EMPTYS or  
> FREE_ALL_EMPTYS
> 		and FUNCTION_CALLERS
> 		and convert the tofree to the boolean
> 	
> 		
> 		/* After X secs have passed or FREE_ALL_EMPTYS, then destroy/re- 
> use */
> 		if (  (! (time_after(jiffies, slabp->went_free ) &&  
> (FREE_SOME_EMPTYS)))
> 		    continue;
>
>
> 	TODO:   set jiffy time ONLY when it when it changes  (slabp->inuse  
> = 0;) and ++ / --
> 		       slabp->went_free = jiffies;
> 		alloc_slabmgt();
> 		slab_get_object();
> 		slab_put_object();
>
>
> 	/* By adding a jiffies slab struct item */
> 	/* Adding debug set of the jiffies anytime the SLAB is accessed and  
> a like drain
> 		function looking for leaks say every hour could be done.
> 	Locating these slabs could then SET WARNings, as it indicates a  
> MEMORY LEAK?
> 	Could be done in check_slabp for age greater than 1 hr
>
> 	and s_show() can print the age of the slab .. convert jiffies...
> 	SHOWS age and last usage..
>
> 	Mitchell Erblich
> 	
>
>
>
> 	

