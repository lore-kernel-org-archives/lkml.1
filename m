Return-Path: <linux-kernel-owner+w=401wt.eu-S1757122AbYH1XAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122AbYH1XAB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 19:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbYH1W7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 18:59:50 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:57189 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525AbYH1W7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 18:59:48 -0400
Subject: Re: [PATCH -V3 01/11] percpu_counters: make fbc->count read atomic
	on 32 bit architecture
From: Mingming Cao <cmm@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, tytso@mit.edu,
       sandeen@redhat.com, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080827210925.b4846037.akpm@linux-foundation.org>
References: <1219850916-8986-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <20080827120553.9c9d6690.akpm@linux-foundation.org>
	 <1219870912.6395.45.camel@twins>
	 <20080827142250.7397a1a7.akpm@linux-foundation.org>
	 <20080828035200.GB6440@skywalker>
	 <20080827210925.b4846037.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Organization: IBM
Date: Thu, 28 Aug 2008 15:59:46 -0700
Message-Id: <1219964386.6384.63.camel@mingming-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


在 2008-08-27三的 21:09 -0700，Andrew Morton写道：
> On Thu, 28 Aug 2008 09:22:00 +0530 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> 
> > On Wed, Aug 27, 2008 at 02:22:50PM -0700, Andrew Morton wrote:
> > > On Wed, 27 Aug 2008 23:01:52 +0200
> > > Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > 
> > > > > 
> > > > > > +static inline s64 percpu_counter_read(struct percpu_counter *fbc)
> > > > > > +{
> > > > > > +	return fbc_count(fbc);
> > > > > > +}
> > > > > 
> > > > > This change means that a percpu_counter_read() from interrupt context
> > > > > on a 32-bit machine is now deadlockable, whereas it previously was not
> > > > > deadlockable on either 32-bit or 64-bit.
> > > > > 
> > > > > This flows on to the lib/proportions.c, which uses
> > > > > percpu_counter_read() and also does spin_lock_irqsave() internally,
> > > > > indicating that it is (or was) designed to be used in IRQ contexts.
> > > > 
> > > > percpu_counter() never was irq safe, which is why the proportion stuff
> > > > does all the irq disabling bits by hand.
> > > 
> > > percpu_counter_read() was irq-safe.  That changes here.  Needs careful
> > > review, changelogging and, preferably, runtime checks.  But perhaps
> > > they should be inside some CONFIG_thing which won't normally be done in
> > > production.
> > > 
> > > otoh, percpu_counter_read() is in fact a rare operation, so a bit of
> > > overhead probably won't matter.
> > > 
> > > (write-often, read-rarely is the whole point.  This patch's changelog's
> > > assertion that "Since fbc->count is read more frequently and updated
> > > rarely" is probably wrong.  Most percpu_counters will have their
> > > fbc->count modified far more frequently than having it read from).
> > 
> > we may actually be doing percpu_counter_add. But that doesn't update
> > fbc->count. Only if the local percpu values cross FBC_BATCH we update
> > fbc->count. If we are modifying fbc->count more frequently than
> > reading fbc->count then i guess we would be contenting of fbc->lock more.
> > 
> > 
> 
> Yep.  The frequency of modification of fbc->count is of the order of a
> tenth or a hundredth of the frequency of
> precpu_counter_<modification>() calls.
> 
> But in many cases the frequency of percpu_counter_read() calls is far
> far less than this.  For example, the percpu_counter_read() may only
> happen when userspace polls a /proc file.
> 
> 

The global counter is is much more frequently accessed with delalloc.:(

With delayed allocation, we have to do read the free blocks counter  at
each write_begin(),  to make sure there is enough free blocks to do
block reservation to prevent lately writepages returns ENOSPC.

Mingming

