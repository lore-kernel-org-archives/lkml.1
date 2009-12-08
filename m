Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbZLHMLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbZLHMLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 07:11:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbZLHMLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 07:11:07 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44049 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbZLHMLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 07:11:06 -0500
Subject: Re: [PATCH 4/7] sched: implement force_cpus_allowed()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: tglx@linutronix.de, mingo@elte.hu, avi@redhat.com, efault@gmx.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4B1E3EE0.7030001@kernel.org>
References: <1259726212-30259-1-git-send-email-tj@kernel.org>
	 <1259726212-30259-5-git-send-email-tj@kernel.org>
	 <1259923259.3977.1928.camel@laptop> <1259923381.3977.1934.camel@laptop>
	 <4B1C85D3.3080401@kernel.org> <1260174900.8223.1159.camel@laptop>
	 <4B1CDA1C.3000802@kernel.org> <1260183278.8223.1500.camel@laptop>
	 <4B1CE1E8.2070803@kernel.org>  <4B1E1130.9050108@kernel.org>
	 <1260262963.3935.1002.camel@laptop>  <4B1E189B.1070204@kernel.org>
	 <1260268453.3935.1106.camel@laptop>  <4B1E378A.5050101@kernel.org>
	 <1260272885.3935.1189.camel@laptop>  <4B1E3EE0.7030001@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Dec 2009 13:10:32 +0100
Message-ID: <1260274232.3935.1223.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-08 at 20:56 +0900, Tejun Heo wrote:
> Hello,
> 
> On 12/08/2009 08:48 PM, Peter Zijlstra wrote:
> > Why bother with that?
> > 
> > workqueue's CPU_POST_DEAD will flush the workqueue and destroy all
> > threads under cpu_add_remove_lock, which excludes the cpu from coming
> > back up before its fully destroyed.
> > 
> > So there's no remaining tasks to be migrated back.
> > 
> > Changing that semantics is not worthwhile.
> 
> It is worthwhile because the goal is to unify all worker pool
> mechanisms.  So, slow_work or whatnot (scsi EHs, FS specific worker
> pools, async workers used for parallel probing) will all be converted
> to use workqueue instead and with that we can't afford to wait for all
> works to flush to down a cpu.  All that's necessary to implement that
> is migrating back the unbound workers which can be implemented as a
> separate piece of code apart from regular operation.  It would even
> benefit the current implementation as it makes cpu up/down operations
> much more deterministic.

Hotplug and deterministic are not to be used in the same sentence, its
an utter slow path and I'd much rather have simple code than clever code
there -- there's been way too many 'interesting' hotplug problems.

If there is work being enqueued that takes more than a few seconds to
complete then I'm thinking there's something seriously wrong and up to
that point its perfectly fine to simply wait for it.

Furthermore if it's objective is to cater to generic thread pools then I
think its an utter fail simply because it mandates strict cpu affinity,
that basically requires you to write a work scheduler to balance work
load etc.. Much easier is a simple unbounded thread pool that gets
balanced by the regular scheduler.

/me liking this stuff less and less :/

