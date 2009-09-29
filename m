Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbZI2TpD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbZI2TpD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 15:45:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbZI2TpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 15:45:01 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:52026 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753353AbZI2TpA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 15:45:00 -0400
From: Bhavesh Davda <bhavesh@vmware.com>
To: Chris Wright <chrisw@sous-sol.org>,
       Shreyas Bhatewara <sbhatewara@vmware.com>
CC: "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>,
       "David S. Miller" <davem@davemloft.net>
Date: Tue, 29 Sep 2009 12:45:01 -0700
Subject: RE: [Pv-drivers] [PATCH 2.6.31-rc9] net: VMware virtual Ethernet
	NIC driver:	vmxnet3
Thread-Topic: [Pv-drivers] [PATCH 2.6.31-rc9] net: VMware virtual Ethernet
	NIC driver:	vmxnet3
Thread-Index: AcpA4ovXmIY3SJrGRsC6G0ZCbcC9vwAVDmtQ
Message-ID: <8B1F619C9F5F454E81D90D3C161698D7017DB76576@EXCH-MBX-3.vmware.com>
References: <89E2752CFA8EC044846EB849981913410173CDFAF6@EXCH-MBX-4.vmware.com>
 <20090929085333.GC3958@sequoia.sous-sol.org>
In-Reply-To: <20090929085333.GC3958@sequoia.sous-sol.org>
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

Hi Chris,

Thanks a bunch for your really thorough review! I'll answer some of your questions here. Shreyas can respond to your comments about some of the coding style/comments/etc. in a separate mail.

> >         INTx, MSI, MSI-X (25 vectors) interrupts
> >         16 Rx queues, 8 Tx queues
> 
> Driver doesn't appear to actually support more than a single MSI-X
> interrupt.
> What is your plan for doing real multiqueue?

When we first wrote the driver a couple of years ago, Linux lacked proper multiqueue support, hence we chose to use only a single queue though the emulated device does support 16 Rx and 8 Tx queues, and 25 MSI-X vectors: 16 for Rx, 8 for Tx and 1 for other asynchronous event notifications, by design. Actually a driver can repurpose any of the 25 vectors for any notifications; just explaining the rationale for desiging the device with 25 MSI-X vectors.

We do have an internal prototype of a Linux vmxnet3 driver with 4 Tx queues and 4 Rx queues, using 9 MSI-X vectors, but it needs some work before calling it production ready.

> How about GRO conversion?

Looks attractive, and we'll work on that in a subsequent patch. Again, when we first wrote the driver, the NETIF_F_GRO stuff didn't exist in Linux.

> Also, heavy use of BUG_ON() (counted 51 of them), are you sure that
> none
> of them can be triggered by guest or remote (esp. the ones that happen
> in interrupt context)?  Some initial thoughts below.

We'll definitely audit all the BUG_ONs again to make sure they can't be exploited.

> > --- /dev/null
> > +++ b/drivers/net/vmxnet3/upt1_defs.h
> > +#define UPT1_MAX_TX_QUEUES  64
> > +#define UPT1_MAX_RX_QUEUES  64
> 
> This is different than the 16/8 described above (and seemingly all moot
> since it becomes a single queue device).

Nice catch! Those are not even used and are from the earliest days of our driver development. We'll nuke those.

> > +/* interrupt moderation level */
> > +#define UPT1_IML_NONE     0 /* no interrupt moderation */
> > +#define UPT1_IML_HIGHEST  7 /* least intr generated */
> > +#define UPT1_IML_ADAPTIVE 8 /* adpative intr moderation */
> 
> enum?  also only appears to support adaptive mode?

Yes, the Linux driver currently only asks for adaptive mode, but the device supports 8 interrupt moderation levels.

> > --- /dev/null
> > +++ b/drivers/net/vmxnet3/vmxnet3_defs.h
> > +struct Vmxnet3_MiscConf {
> > +       struct Vmxnet3_DriverInfo driverInfo;
> > +       uint64_t             uptFeatures;
> > +       uint64_t             ddPA;         /* driver data PA */
> > +       uint64_t             queueDescPA;  /* queue descriptor table
> PA */
> > +       uint32_t             ddLen;        /* driver data len */
> > +       uint32_t             queueDescLen; /* queue desc. table len
> in bytes */
> > +       uint32_t             mtu;
> > +       uint16_t             maxNumRxSG;
> > +       uint8_t              numTxQueues;
> > +       uint8_t              numRxQueues;
> > +       uint32_t             reserved[4];
> > +};
> 
> should this be packed (or others that are shared w/ device)?  i assume
> you've already done 32 vs 64 here
> 

No need for packing since the fields are naturally 64-bit aligned. True for all structures shared between the driver and device.

> > +#define VMXNET3_MAX_TX_QUEUES  8
> > +#define VMXNET3_MAX_RX_QUEUES  16
> 
> different to UPT, I must've missed some layering here

These are the authoritiative #defines. Ignore the UPT ones.

> > --- /dev/null
> > +++ b/drivers/net/vmxnet3/vmxnet3_drv.c
> > +       VMXNET3_WRITE_BAR0_REG(adapter, VMXNET3_REG_IMR + intr_idx *
> 8, 0);
> 
> 	writel(0, adapter->hw_addr0 + VMXNET3_REG_IMR + intr_idx * 8)
> seems just as clear to me.

Fair enough. We were just trying to clearly show which register accesses go to BAR 0 versus BAR 1.

> only ever num_intrs=1, so there's some plan to bump this up and make
> these wrappers useful?

Yes.

> > +static void
> > +vmxnet3_process_events(struct vmxnet3_adapter *adapter)
> 
> Should be trivial to break out to it's own MSI-X vector, basically set
> up to do that already.

Yes, and the device is configurable to use any vector for any "events", but didn't see any compelling reason to do so. "ECR" events are extremely rare and we've got a shadow copy of the ECR register that avoids an expensive round trip to the device, stored in adapter->shared->ecr. So we can cheaply handle events on the hot Tx/Rx path with minimal overhead. But if you really see a compelling reason to allocate a separate MSI-X vector for events, we can certainly do that.

> 
> Plan to switch to GRO?

Already answered.

Thanks

- Bhavesh
