Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbYENUrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbYENUrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 16:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYENUq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 16:46:56 -0400
Received: from relay1.sgi.com ([192.48.171.29]:37289 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751184AbYENUqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 16:46:54 -0400
Date: Wed, 14 May 2008 13:46:52 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, mpm@selenic.com,
       Matthew Wilcox <matthew@wil.cx>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
In-Reply-To: <Pine.LNX.4.64.0805141104260.15633@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0805141333550.18231@schroedinger.engr.sgi.com>
References: <20080510030831.796641881@sgi.com>  <20080510030919.604216074@sgi.com>
 <4825709A.2020407@firstfloor.org>  <20080510221515.3540a6cc@bree.surriel.com>
  <2f11576a0805120038s334dc56cuaf16b8b7c6f87098@mail.gmail.com>
 <84144f020805120054t1370236ei5ff52279457e026e@mail.gmail.com>
 <Pine.LNX.4.64.0805141009210.15194@schroedinger.engr.sgi.com>
 <482B2617.5010605@firstfloor.org> <Pine.LNX.4.64.0805141104260.15633@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some more on SMP scaling:

There is also the issue in SLAB that global locks (SMP case) need to be 
taken for a pretty long timeframe. With a sufficiently high allocation 
frequency from multiple processors you can cause lock contention on the 
list_lock that will then degrade performance.

SLUB does not take global locks for continued allocations. Global locks 
are taken for a short time frame if the partial lists need to be updated 
(which is avoided as much as possible with various measures). This can 
yield orders of magnitude higher performance

The above is possible because of locking at the page level. A queue must 
either be processor specific or global (or per node) and then would 
need locks.

Another issue is storage density. SLAB needs a metadata structure that 
either is placed in the slab page itself or in a separate slab cache. In 
some cases this is advantageous over SLUB (f.e. a series of pointers to 
objects exist in a single cacheline thus allocation of objects that are 
not immediately used could be faster) in others it is not (because it 
increases cache footprint, requires the touching of two slabcaches if the 
metadata is off slab, makes alignment of objects in the slab pages 
difficult and increases memory overhead, SLUB generally is faster if the 
object is/was immediately used since the freepointer overlays the data 
and thus the cacheline is hot both on alloc and free).
