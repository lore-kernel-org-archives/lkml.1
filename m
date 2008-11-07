Return-Path: <linux-kernel-owner+w=401wt.eu-S1752913AbYKGKTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbYKGKTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 05:19:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbYKGKSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 05:18:54 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47109 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbYKGKSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 05:18:54 -0500
Subject: Re: [PATCH] revert: timers: fix itimer/many thread hang
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frank Mayhar <fmayhar@google.com>,
       Doug Chapman <doug.chapman@hp.com>, roland@redhat.com,
       adobriyan@gmail.com, akpm@linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0811061552590.14566@quilx.com>
References: <1224694989.8431.23.camel@oberon>
	 <1225132746.14792.13.camel@bobble.smo.corp.google.com>
	 <1225219114.24204.37.camel@oberon>
	 <1225936715.27507.44.camel@bobble.smo.corp.google.com>
	 <1225969420.7803.4366.camel@twins> <1225989102.7803.4749.camel@twins>
	 <20081106214434.GA5999@elte.hu>
	 <Pine.LNX.4.64.0811061552590.14566@quilx.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 07 Nov 2008 11:19:32 +0100
Message-Id: <1226053172.7803.5832.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-06 at 15:53 -0600, Christoph Lameter wrote:
> On Thu, 6 Nov 2008, Ingo Molnar wrote:
> 
> > That loop could _perhaps_ be avoided by maintaining the sums from the
> > scheduler tick: by just adding the latest delta values for the current
> > task to times->*time. Plus at exit time cleaning up the remaining
> > delta. That would be a far smaller patch.
> 
> That is a similar scheme to the ZVC (see mm/vmstat.c). Peter: Dont you
> have an implementation of a ZVC like scheme for you dirty throttling
> patchset that may be useful here?

Sure, we can do something similar to that, but mind you, that's an
approximation. Approximations work just fine for vmstats and dirty
balancing, I'm just not sure its something people appreciate wrt
timers :-)

The trick is to only update the sum when a per-cpu delta overflows,
which means the sum will have an error in the order of cpus*delta/2.

