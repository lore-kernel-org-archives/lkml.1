Return-Path: <linux-kernel-owner+w=401wt.eu-S1763860AbYCEAx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763860AbYCEAx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 19:53:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935713AbYCEAws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 19:52:48 -0500
Received: from n30.bullet.mail.mud.yahoo.com ([68.142.200.153]:36363 "HELO
	n30.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S935604AbYCEAwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 19:52:46 -0500
X-Yahoo-Newman-Id: 680839.26688.bm@omp412.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mFIA7r9ONxGbcFjo+tXKmMITX8Mwl3ghba8a0rhLLgghPXc+kaosjQMu0U7DdX1eJuZx73N8c2Mx0gJDBMTcpXFHcbutQ6H/d6y5MfJjQyF9RGSOE5XvoJl0gEZYMWbj4G2E5SYH8o44Q0B8GwEgsPsZajaLBnhXyQpbokZXu9k=  ;
X-YMail-OSG: JIu9S3cVM1m1a7uqtsTNJg.bM8Z1RoWZydRl6ZtuW7DU6idWtjNE13RYNYfPQ0XQ3Fse7VdSPQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 2/6] mmu_notifier: Callbacks to invalidate address ranges
Date: Wed, 5 Mar 2008 11:52:13 +1100
User-Agent: KMail/1.9.5
Cc: akpm@linux-foundation.org, Andrea Arcangeli <andrea@qumranet.com>,
       Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
References: <20080215064859.384203497@sgi.com> <200803040650.11942.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0803041054210.13957@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0803041054210.13957@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803051152.15160.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 March 2008 05:58, Christoph Lameter wrote:
> On Tue, 4 Mar 2008, Nick Piggin wrote:
> > > Then put it into the arch code for TLB invalidation. Paravirt ops gives
> > > good examples on how to do that.
> >
> > Put what into arch code?
>
> The mmu notifier code.

It isn't arch specific.


> > > > What about a completely different approach... XPmem runs over
> > > > NUMAlink, right? Why not provide some non-sleeping way to basically
> > > > IPI remote nodes over the NUMAlink where they can process the
> > > > invalidation? If you intra-node cache coherency has to run over this
> > > > link anyway, then presumably it is capable.
> > >
> > > There is another Linux instance at the remote end that first has to
> > > remove its own ptes.
> >
> > Yeah, what's the problem?
>
> The remote end has to invalidate the page which involves locking etc.

I don't see what the problem is.


> > > Also would not work for Inifiniband and other
> > > solutions.
> >
> > infiniband doesn't want it. Other solutions is just handwaving,
> > because if we don't know what the other soloutions are, then we can't
> > make any sort of informed choices.
>
> We need a solution in general to avoid the pinning problems. Infiniband
> has those too.
>
> > > All the approaches that require evictions in an atomic context
> > > are limiting the approach and do not allow the generic functionality
> > > that we want in order to not add alternate APIs for this.
> >
> > The only generic way to do this that I have seen (and the only proposed
> > way that doesn't add alternate APIs for that matter) is turning VM locks
> > into sleeping locks. In which case, Andrea's notifiers will work just
> > fine (except for relatively minor details like rcu list scanning).
>
> No they wont. As you pointed out the callback need RCU locking.

That can be fixed easily.


> > > The good enough solution right now is to pin pages by elevating
> > > refcounts.
> >
> > Which kind of leads to the question of why do you need any further
> > kernel patches if that is good enough?
>
> Well its good enough with severe problems during reclaim, livelocks etc.
> One could improve on that scheme through Rik's work trying to add a new
> page flag that mark pinned pages and then keep them off the LRUs and
> limiting their number. Having pinned page would limit the ability to
> reclaim by the VM and make page migration, memory unplug etc impossible.

Well not impossible. You could have a callback to invalidate the remote
TLB and drop the pin on a given page.


> It is better to have notifier scheme that allows to tell a device driver
> to free up the memory it has mapped.

Yeah, it would be nice for those people with clusters of Altixes. Doesn't
mean it has to go upstream, though.

