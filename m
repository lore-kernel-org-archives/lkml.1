Return-Path: <linux-kernel-owner+w=401wt.eu-S934644AbZJIXwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934644AbZJIXwu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934629AbZJIXwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:52:49 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:37839 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934618AbZJIXws convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:52:48 -0400
From: Shreyas Bhatewara <sbhatewara@vmware.com>
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Jeff Garzik <jgarzik@pobox.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       pv-drivers <pv-drivers@vmware.com>
Date: Fri, 9 Oct 2009 16:52:09 -0700
Subject: RE: [PATCH 2.6.32-rc3] net: VMware virtual Ethernet NIC driver:
 vmxnet3
Thread-Topic: [PATCH 2.6.32-rc3] net: VMware virtual Ethernet NIC driver:
 vmxnet3
Thread-Index: AcpJKJ+lrQ9f7pWSTxKPDRUMSasBcgAEUfow
Message-ID: <89E2752CFA8EC044846EB849981913410174041DA5@EXCH-MBX-4.vmware.com>
References: <alpine.LRH.2.00.0910061202510.24669@localhost.localdomain>
	<alpine.LRH.2.00.0910081053460.19107@localhost.localdomain>
 <20091009143538.644844aa@nehalam>
In-Reply-To: <20091009143538.644844aa@nehalam>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Stephen Hemminger [mailto:shemminger@linux-foundation.org]
> Sent: Friday, October 09, 2009 2:36 PM
> To: Shreyas Bhatewara
> Cc: linux-kernel; netdev; David S. Miller; Jeff Garzik; Anthony
> Liguori; Chris Wright; Greg Kroah-Hartman; Andrew Morton;
> virtualization; pv-drivers
> Subject: Re: [PATCH 2.6.32-rc3] net: VMware virtual Ethernet NIC
> driver: vmxnet3
> 
> On Thu, 8 Oct 2009 10:59:26 -0700 (PDT)
> Shreyas Bhatewara <sbhatewara@vmware.com> wrote:
> 
> > Hello all,
> >
> > I do not mean to be bothersome but this thread has been unusually
> silent.
> > Could you please review the patch for me and reply with your comments
> /
> > acks ?
> >
> > Thanks.
> > ->Shreyas
> 
> 
> Looks fine, but just a minor style nit (can be changed after insertion
> in mainline).
> 
> The code:
> 
> static void
> vmxnet3_do_poll(struct vmxnet3_adapter *adapter, int budget, int
> *txd_done,
> 		int *rxd_done)
> {
> 	if (unlikely(adapter->shared->ecr))
> 		vmxnet3_process_events(adapter);
> 
> 	*txd_done = vmxnet3_tq_tx_complete(&adapter->tx_queue, adapter);
> 	*rxd_done = vmxnet3_rq_rx_complete(&adapter->rx_queue, adapter,
> budget);
> }
> 
> 
> static int
> vmxnet3_poll(struct napi_struct *napi, int budget)
> {
> 	struct vmxnet3_adapter *adapter = container_of(napi,
> 					  struct vmxnet3_adapter, napi);
> 	int rxd_done, txd_done;
> 
> 	vmxnet3_do_poll(adapter, budget, &txd_done, &rxd_done);
> 
> 	if (rxd_done < budget) {
> 		napi_complete(napi);
> 		vmxnet3_enable_intr(adapter, 0);
> 	}
> 	return rxd_done;
> }
> 
> 
> Is simpler if you just have do_poll return rx done value. Probably Gcc
> inline's it all anyway.
> 
> static int
> vmxnet3_do_poll(struct vmxnet3_adapter *adapter, int budget)
> {
> 	if (unlikely(adapter->shared->ecr))
> 		vmxnet3_process_events(adapter);
> 
> 	vmxnet3_tq_tx_complete(&adapter->tx_queue, adapter);
> 	return vmxnet3_rq_rx_complete(&adapter->rx_queue, adapter,
> budget);
> }
> 
> 
> static int
> vmxnet3_poll(struct napi_struct *napi, int budget)
> {
> 	struct vmxnet3_adapter *adapter = container_of(napi,
> 					  struct vmxnet3_adapter, napi);
> 	int rxd_done;
> 
> 	rxd_done = vmxnet3_do_poll(adapter, budget);
> 	if (rxd_done < budget) {
> 		napi_complete(napi);
> 		vmxnet3_enable_intr(adapter, 0);
> 	}
> 	return rxd_done;
> }



Thanks Stephen.

Yes, the vmxnet3_do_poll() was an inline function in the very first patch. It was thought of as a better idea to let gcc handle the inlining.
I will piggyback this nit on a forthcoming change.

->Shreyas


