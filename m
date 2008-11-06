Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbYKFX5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbYKFX5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 18:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbYKFX5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 18:57:21 -0500
Received: from smtp-out.google.com ([216.239.33.17]:45379 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbYKFX5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 18:57:20 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:from:to:cc:in-reply-to:references:content-type:
	organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=uH/U9JFZxsmtVNWxKPsLOo41k2bDvm5e3O5z4UoD4Hwflh2OVK1FbdVHB124D1dgP
	NxzjYy7QIS0TmH03T552A==
Subject: Re: regression introduced by - timers: fix itimer/many thread hang
From: Frank Mayhar <fmayhar@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Doug Chapman <doug.chapman@hp.com>, mingo@elte.hu, roland@redhat.com,
       adobriyan@gmail.com, akpm@linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1225984098.7803.4642.camel@twins>
References: <1224694989.8431.23.camel@oberon>
	 <1225132746.14792.13.camel@bobble.smo.corp.google.com>
	 <1225219114.24204.37.camel@oberon>
	 <1225936715.27507.44.camel@bobble.smo.corp.google.com>
	 <1225969420.7803.4366.camel@twins>
	 <Pine.LNX.4.64.0811060900450.3595@quilx.com>
	 <1225984098.7803.4642.camel@twins>
Content-Type: text/plain
Organization: Google, Inc.
Date: Thu, 06 Nov 2008 15:52:48 -0800
Message-Id: <1226015568.2186.20.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-06 at 16:08 +0100, Peter Zijlstra wrote: 
> On Thu, 2008-11-06 at 09:03 -0600, Christoph Lameter wrote:
> > On Thu, 6 Nov 2008, Peter Zijlstra wrote:
> > 
> > > Also, you just introduced per-cpu allocations for each thread-group,
> > > while Christoph is reworking the per-cpu allocator, with one unfortunate
> > > side-effect - its going to have a limited size pool. Therefore this will
> > > limit the number of thread-groups we can have.
> > 
> > Patches exist that implement a dynamically growable percpu pool (using
> > virtual mappings though). If the cost of the additional complexity /
> > overhead is justifiable then we can make the percpu pool dynamically
> > extendable.
> 
> Right, but I don't think the patch under consideration will fly anyway,
> doing a for_each_possible_cpu() loop on every tick on all cpus isn't
> really healthy, even for moderate sized machines.

I personally think that you're overstating this.  First, the current
implementation walks all threads for each tick, which is simply not
scalable and results in soft lockups with large numbers of threads.
This patch fixes a real bug.  Second, this only happens "on every tick"
for processes that have more than one thread _and_ that use posix
interval timers.  Roland and I went to some effort to keep loops like
the on you're referring to out of the common paths.

In any event, while this particular implementation may not be optimal,
at least it's _right_.  Whatever happened to "make it right, then make
it fast?"
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

