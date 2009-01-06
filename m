Return-Path: <linux-kernel-owner+w=401wt.eu-S1753685AbZAFQVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbZAFQVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 11:21:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbZAFQVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 11:21:17 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:58661 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbZAFQVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 11:21:16 -0500
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>, Nick Piggin <npiggin@suse.de>
In-Reply-To: <alpine.LFD.2.00.0901060750410.3057@localhost.localdomain>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	 <20081231104533.abfb1cf9.akpm@linux-foundation.org>
	 <1230765549.7538.8.camel@think.oraclecorp.com>
	 <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org>
	 <1231093310.27690.5.camel@twins> <20090104184103.GE2002@parisc-linux.org>
	 <1231242031.11687.97.camel@twins> <20090106121052.GA27232@elte.hu>
	 <alpine.LFD.2.00.0901060750410.3057@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 11:19:49 -0500
Message-Id: <1231258789.4290.158.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010208.496384AA.002E:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-06 at 07:55 -0800, Linus Torvalds wrote:
> 
> On Tue, 6 Jan 2009, Ingo Molnar wrote:
> > 
> > The thing i like most about Peter's patch (compared to most other adaptive 
> > spinning approaches i've seen, which all sucked as they included various 
> > ugly heuristics complicating the whole thing) is that it solves the "how 
> > long should we spin" question elegantly: we spin until the owner runs on a 
> > CPU.
> 
> The other way around, you mean: we spin until the owner is no longer 
> holding a cpu.
> 
> I agree that it's better than the normal "spin for some random time" 
> model, but I can't say I like the "return 0" cases where it just retries 
> the whole loop if the semaphore was gotten by somebody else instead. 
> Sounds like an easyish live-lock to me. 
> 
> I also still strongly suspect that whatever lock actually needs this, 
> should be seriously re-thought. 
> 
> But apart from the "return 0" craziness I at least dont' _hate_ this 
> patch. Do we have numbers? Do we know which locks this matters on?

This discussion was kicked off by an unconditional spin (512 tries)
against mutex_trylock in the btrfs tree locking code.

Btrfs is using mutexes to protect the btree blocks, and btree searching
often hits hot nodes that are always in cache.  For these nodes, the
spinning is much faster, but btrfs also needs to be able to sleep with
the locks held so it can read from the disk and do other complex
operations.

For btrfs, dbench 50 performance doubles with the unconditional spin,
mostly because that workload is almost all in ram.

For 50 procs creating 4k files in parallel, the spin is 30-50% faster.
This workload is a mixture of disk bound and CPU bound.

Yes, there is definitely some low hanging fruit to tune the btrfs btree
searches and locking.  But, I think the adaptive model is a good fit for
on disk btrees in general.

-chris


