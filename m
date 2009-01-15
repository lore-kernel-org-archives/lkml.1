Return-Path: <linux-kernel-owner+w=401wt.eu-S1765154AbZAOT2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765154AbZAOT2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 14:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757299AbZAOT1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 14:27:54 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:19562 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757155AbZAOT1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 14:27:53 -0500
Subject: Re: [GIT PULL] adaptive spinning mutexes
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <alpine.LFD.2.00.0901151015270.6528@localhost.localdomain>
References: <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins>
	 <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain>
	 <1231867314.7141.16.camel@twins> <1231952436.14825.28.camel@laptop>
	 <20090114183319.GA18630@elte.hu> <20090114184746.GA21334@elte.hu>
	 <20090114192811.GA19691@elte.hu> <20090115174440.GF29283@parisc-linux.org>
	 <alpine.LFD.2.00.0901150958300.6528@localhost.localdomain>
	 <20090115180844.GL22472@elte.hu>
	 <alpine.LFD.2.00.0901151015270.6528@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 15 Jan 2009 14:26:58 -0500
Message-Id: <1232047618.8269.93.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.496F8E09.0054:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-15 at 10:16 -0800, Linus Torvalds wrote:
> 
> On Thu, 15 Jan 2009, Ingo Molnar wrote:
> > 
> > btw., i think spin-mutexes have a design advantage here: in a lot of code 
> > areas it's quite difficult to use spinlocks - cannot allocate memory, 
> > cannot call any code that can sporadically block (but does not _normally_ 
> > block), etc.
> > 
> > With mutexes those atomicity constraints go away - and the performance 
> > profile should now be quite close to that of spinlocks as well.
> 
> Umm. Except if you wrote the code nicely and used spinlocks, you wouldn't 
> hold the lock over all those unnecessary and complex operations.
> 

While this is true, there are examples of places we should expect
speedups for this today.

Concurrent file creation/deletion in a single dir will often find things
hot in cache and not have to block anywhere (mail spools).

Concurrent O_DIRECT aio writes to the same file, where i_mutex is
dropped early on.

pipes should see a huge improvement.

I'll kick off some runs of my three benchmarks on ext3 for comparison.
If there are things less synthetic people would like to see, please let
me know.

-chris


