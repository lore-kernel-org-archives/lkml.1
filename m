Return-Path: <linux-kernel-owner+w=401wt.eu-S1752452Ab0A0Ljk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab0A0Ljk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 06:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437Ab0A0Ljc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 06:39:32 -0500
Received: from cantor.suse.de ([195.135.220.2]:49744 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab0A0Ljb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 06:39:31 -0500
Date: Wed, 27 Jan 2010 22:39:22 +1100
From: Nick Piggin <npiggin@suse.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH RFC tip/core/rcu] accelerate grace period if last
 non-dynticked CPU
Message-ID: <20100127113922.GB14790@laptop>
References: <20100125034816.GA14043@linux.vnet.ibm.com>
 <873a1sft9q.fsf@basil.nowhere.org>
 <20100127052050.GC6807@linux.vnet.ibm.com>
 <20100127094336.GA12522@basil.fritz.box>
 <1264585850.4283.1992.camel@laptop>
 <20100127100434.GN6807@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100127100434.GN6807@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 02:04:34AM -0800, Paul E. McKenney wrote:
> I could indeed do that.  However, there is nothing stopping the
> more-active CPU from going into dynticks-idle mode between the time
> that I decide to push the callback to it and the time I actually do
> the pushing.  :-(
> 
> I considered pushing the callbacks to the orphanage, but that is a
> global lock that I would rather not acquire on each dyntick-idle
> transition.

Well we already have to do atomic operations on the nohz mask, so
maybe it would be acceptable to actually have a spinlock there to
serialise operations on the nohz mask and also allow some subsystem
specific things (synchronisation here should allow either one of
those above approaches).

It's not going to be zero cost, but seeing as there is already the
contended cacheline there, it's not going to introduce a
fundamentally new bottleneck.

