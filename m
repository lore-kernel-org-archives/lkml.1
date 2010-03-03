Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab0CCBcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 20:32:21 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36381 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab0CCBcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 20:32:20 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 3 Mar 2010 10:28:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, haicheng.li@intel.com
Subject: Re: [patch] slab: add memory hotplug support
Message-Id: <20100303102844.fe740203.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1003021419020.30059@router.home>
References: <20100215105253.GE21783@one.firstfloor.org>
	<20100215110135.GN5723@laptop>
	<alpine.DEB.2.00.1002191222320.26567@router.home>
	<20100220090154.GB11287@basil.fritz.box>
	<alpine.DEB.2.00.1002240949140.26771@router.home>
	<4B862623.5090608@cs.helsinki.fi>
	<alpine.DEB.2.00.1002242357450.26099@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1002251228140.18861@router.home>
	<20100226114136.GA16335@basil.fritz.box>
	<alpine.DEB.2.00.1002260904311.6641@router.home>
	<20100226155755.GE16335@basil.fritz.box>
	<alpine.DEB.2.00.1002261123520.7719@router.home>
	<alpine.DEB.2.00.1002261555030.32111@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1003010224170.26824@chino.kir.corp.google.com>
	<4B8CA7F5.1030802@cs.helsinki.fi>
	<alpine.DEB.2.00.1003021419020.30059@router.home>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Mar 2010 14:20:06 -0600 (CST)
Christoph Lameter <cl@linux-foundation.org> wrote:

> 
> Not sure how this would sync with slab use during node bootstrap and
> shutdown. Kame-san?
> 
> Otherwise
> 
> Acked-by: Christoph Lameter <cl@linux-foundation.org>
> 

What this patch fixes ? Maybe I miss something...

At node hot-add

 * pgdat is allocated from other node (because we have no memory for "nid")
 * memmap for the first section (and possiby others) will be allocated from
   other nodes.
 * Once a section for the node is onlined, any memory can be allocated localy.

   (Allocating memory from local node requires some new implementation as
    bootmem allocater, we didn't that.)

 Before this patch, slab's control layer is allocated by cpuhotplug.
 So, at least keeping this order,
    memory online -> cpu online
 slab's control layer is allocated from local node.

 When node-hotadd is done in this order
    cpu online -> memory online
 kmalloc_node() will allocate memory from other node via fallback.

 After this patch, slab's control layer is allocated by memory hotplug.
 Then, in any order, slab's control will be allocated via fallback routine.

If this patch is an alternative fix for Andi's this logic
==
Index: linux-2.6.32-memhotadd/mm/slab.c
===================================================================
--- linux-2.6.32-memhotadd.orig/mm/slab.c
+++ linux-2.6.32-memhotadd/mm/slab.c
@@ -4093,6 +4093,9 @@ static void cache_reap(struct work_struc
 		 * we can do some work if the lock was obtained.
 		 */
 		l3 = searchp->nodelists[node];
+		/* Note node yet set up */
+		if (!l3)
+			break;
==
I'm not sure this really happens.

cache_reap() is for checking local node. The caller is set up by
CPU_ONLINE. searchp->nodelists[] is filled by CPU_PREPARE.

Then, cpu for the node should be onlined. (and it's done under proper mutex.)

I'm sorry if I miss something important. But how anyone cause this ?

Thanks,
-Kame



