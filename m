Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781AbZI2VAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbZI2VAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 17:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbZI2VAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 17:00:49 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:60997 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752039AbZI2VAs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 17:00:48 -0400
From: Bhavesh Davda <bhavesh@vmware.com>
To: Chris Wright <chrisw@sous-sol.org>
CC: Shreyas Bhatewara <sbhatewara@vmware.com>,
       "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>,
       "David S. Miller" <davem@davemloft.net>
Date: Tue, 29 Sep 2009 14:00:49 -0700
Subject: RE: [Pv-drivers] [PATCH 2.6.31-rc9] net: VMware virtual Ethernet
	NIC driver: vmxnet3
Thread-Topic: [Pv-drivers] [PATCH 2.6.31-rc9] net: VMware virtual Ethernet
	NIC driver: vmxnet3
Thread-Index: AcpBQ7sFDhFEdp4VTeqMcLkrMQWZPAAAfUAA
Message-ID: <8B1F619C9F5F454E81D90D3C161698D7017DB765E8@EXCH-MBX-3.vmware.com>
References: <89E2752CFA8EC044846EB849981913410173CDFAF6@EXCH-MBX-4.vmware.com>
 <20090929085333.GC3958@sequoia.sous-sol.org>
 <8B1F619C9F5F454E81D90D3C161698D7017DB76576@EXCH-MBX-3.vmware.com>
 <20090929203018.GG3958@sequoia.sous-sol.org>
In-Reply-To: <20090929203018.GG3958@sequoia.sous-sol.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Thanks a bunch for your really thorough review! I'll answer some of
> your questions here. Shreyas can respond to your comments about some of
> the coding style/comments/etc. in a separate mail.
> 
> The style is less important at this stage, but certainly eases review
> to make it more consistent w/ Linux code.  The StudlyCaps, extra macros
> (screaming caps) and inconistent space/tabs are visual distractions,
> that's all.

Agreed, but we'll definitely address all the style issues in our subsequent patch posts. Actually Shreyas showed me his raw patch and it had tabs and not spaces, so we're trying to figure out if either Outlook (corporate blessed) or our Exchange server is converting those tabs to spaces or something.

> > We do have an internal prototype of a Linux vmxnet3 driver with 4 Tx
> queues and 4 Rx queues, using 9 MSI-X vectors, but it needs some work
> before calling it production ready.
> 
> I'd expect once you switch to alloc_etherdev_mq(), make napi work per
> rx queue, and fix MSI-X allocation (all needed for 4/4), you should
> have enough to support the max of 16/8 (IOW, 4/4 still sounds like an
> aritificial limitation).

Absolutely: 4/4 was simply a prototype to see if it helps with performance any with certain benchmarks. So far it looks like there's a small performance gain with microbenchmarks like netperf, but we're hoping having multiple queues with multiple vectors might have some promise with macro benchmarks like SPECjbb. If it pans out, we'll most likely make it a module_param with some reasonable defaults, possibly just 1/1 by default.

> > > How about GRO conversion?
> >
> > Looks attractive, and we'll work on that in a subsequent patch.
> Again, when we first wrote the driver, the NETIF_F_GRO stuff didn't
> exist in Linux.
> 
> OK, shouldn't be too much work.
> 
> Another thing I forgot to mention is that net_device now has
> net_device_stats in it.  So you shouldn't need net_device_stats in
> vmxnet3_adapter.

Cool. Will do.

> > > > +#define UPT1_MAX_TX_QUEUES  64
> > > > +#define UPT1_MAX_RX_QUEUES  64
> > >
> > > This is different than the 16/8 described above (and seemingly all
> moot
> > > since it becomes a single queue device).
> >
> > Nice catch! Those are not even used and are from the earliest days of
> our driver development. We'll nuke those.
> 
> Could you describe the UPT layer a bit?  There were a number of
> constants that didn't appear to be used.

UPT stands for Uniform Pass Thru, a spec/framework VMware developed with its IHV partners to implement the fast path (Tx/Rx) features of vmxnet3 in silicon. Some of these #defines that appear not to be used are based on this initial spec that VMware shared with its IHV partners.

We divided the emulated vmxnet3 PCIe device's registers into two sets on two separate BARs: BAR 0 for the UPT registers we asked IHV partners to implement that we emulate in our hypervisor if no physical device compliant with the UPT spec is available to pass thru from a virtual machine, and BAR 1 for registers we always emulate for slow path/control operations like setting the MAC address, or activating/quiescing/resetting the device, etc.

> > > > +static void
> > > > +vmxnet3_process_events(struct vmxnet3_adapter *adapter)
> > >
> > > Should be trivial to break out to it's own MSI-X vector, basically
> set
> > > up to do that already.
> >
> > Yes, and the device is configurable to use any vector for any
> "events", but didn't see any compelling reason to do so. "ECR" events
> are extremely rare and we've got a shadow copy of the ECR register that
> avoids an expensive round trip to the device, stored in adapter-
> >shared->ecr. So we can cheaply handle events on the hot Tx/Rx path
> with minimal overhead. But if you really see a compelling reason to
> allocate a separate MSI-X vector for events, we can certainly do that.
> 
> Nah, just thinking outloud while trying to understand the driver.  I
> figured it'd be the + 1 vector (16 + 8 + 1).

Great. In that case we'll stay with not allocating a separate vector for events for now.

Thanks!

- Bhavesh

> 
> thanks,
> -chris
