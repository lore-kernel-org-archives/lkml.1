Return-Path: <linux-kernel-owner+w=401wt.eu-S1753561AbYJNPNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbYJNPNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 11:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbYJNPNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 11:13:39 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:55444 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbYJNPNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 11:13:38 -0400
Subject: Re: [PATCH]IB/ehca:reject dynamic memory add/remove
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Stefan Roscher <stefan.roscher@vnet.de.ibm.com>
Cc: Stefan Roscher <ossrosch@linux.vnet.ibm.com>,
       Roland Dreier <rolandd@cisco.com>, general@lists.openfabrics.org,
       LinuxPPC-Dev <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>, hnguyen@de.ibm.com
In-Reply-To: <200810141423.48111.stefan.roscher@vnet.de.ibm.com>
References: <200810131310.34413.ossrosch@linux.vnet.ibm.com>
	 <1223917766.29877.17.camel@nimitz>
	 <200810141423.48111.stefan.roscher@vnet.de.ibm.com>
Content-Type: text/plain
Date: Tue, 14 Oct 2008 08:13:32 -0700
Message-Id: <1223997212.29877.98.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-14 at 14:23 +0200, Stefan Roscher wrote:
> On Monday 13 October 2008 07:09:26 pm Dave Hansen wrote:
> > On Mon, 2008-10-13 at 13:10 +0200, Stefan Roscher wrote:
> > > Since the ehca device driver does not support dynamic memory add and remove
> > > operations, the driver must explicitly reject such requests in order to prevent
> > > unpredictable behaviors related to memory regions already occupied and being
> > > used by InfiniBand applications.
> > > The solution is to add a memory notifier to the ehca device driver and if a request
> > > for dynamic memory add or remove comes in, ehca will always reject it.
> > 
> > Why doesn't the driver support it?
> > 
> > This seems like an awfully extreme action to take.  Do you have plans to
> > support this in the driver soon?
> > 
> There is currently a slight incompatibility how openfabrics uses MRs and how System p does DMEM add/remove,
> which basically disables this support.
> If you want to talk to the firmware developpers, I can give you the right contacts.

OK, Stefan and Christoph have very patiently explained the whole
situation to me.

The ehca driver needs to register any memory to which it might write
with the hypervisor (which then talks to the hardware).  For normal apps,
it does get_user_pages() on the userspace memory and tells the
hypervisor which pages it got.

But, there are in-kernel users of the hardware as well like NFS and the
IP stack.  These might potentially write anywhere in memory since, for
instance, an skbuf can be allocated anywhere.  Due to limitations in the
Infiniband software stack, all these users must all share the same
"L_KEY", which is basically the identifier of the individual Infiniband
"user".

So, ehca registers all of the partition's memory with the hypervisor
when it is loaded to prepare for these in-kernel users.  (I think of
this as mmap("/dev/mem") from a device to kernel memory.) The size of
this table is restricted by the starting size of the physical memory
allocated to the partition, so we can't oversize it and just fill it in
later as memory is added (hypervisor limitation).  We also can't resize
it at runtime because of other hypervisor limitations.

The only way to change it is basically to shut the adapter down, which
Infiniband wouldn't deal well with since it doesn't have any
retransmitting (Infiniband limitation).

We could restrict the kernel area to which the ehca driver could write.
We would then just bounce buffer things in and out of it.  But, that'd
be a latency and complexity nightmare.  We could probably also modify
each of the existing in-kernel users (NFS, etc...) to check to see
whether the memory they're about to touch has been registered with the
hypervisor.  They could only bounce in cases where it hadn't.  We could
probably also detect these in-kernel users and only deny hotplugging in
case one of them is actually active.  

But, for now, we take the cowardly approach and simply disable memory
hotplug.  You can still hotplug to the system, you just need to
un-hotplug the ehca adapter from the partition, first.  This will, of
course be well documented in the already huge IBM manual. :)

Back to the patch...  Could we be a bit more explicit that a user can go
to the HMC (the IBM control console) and remove the adapter?  I'm just
trying to think of the poor user looking at dmesg.  The dude/dudette
doing this is going to be sitting at the HMC.  Can we get an helpful
message to pop up to them?  Will they even see dmesg output?

-- Dave

