Return-Path: <linux-kernel-owner+w=401wt.eu-S1761508AbZJIVgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761508AbZJIVgp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 17:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761496AbZJIVgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 17:36:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37830 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761495AbZJIVgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 17:36:42 -0400
Date: Fri, 9 Oct 2009 14:35:38 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Shreyas Bhatewara <sbhatewara@vmware.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Jeff Garzik <jgarzik@pobox.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       pv-drivers <pv-drivers@vmware.com>
Subject: Re: [PATCH 2.6.32-rc3] net: VMware virtual Ethernet NIC driver:
 vmxnet3
Message-ID: <20091009143538.644844aa@nehalam>
In-Reply-To: <alpine.LRH.2.00.0910081053460.19107@localhost.localdomain>
References: <alpine.LRH.2.00.0910061202510.24669@localhost.localdomain>
	<alpine.LRH.2.00.0910081053460.19107@localhost.localdomain>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Oct 2009 10:59:26 -0700 (PDT)
Shreyas Bhatewara <sbhatewara@vmware.com> wrote:

> Hello all,
> 
> I do not mean to be bothersome but this thread has been unusually silent.
> Could you please review the patch for me and reply with your comments / 
> acks ?
> 
> Thanks.
> ->Shreyas  


Looks fine, but just a minor style nit (can be changed after insertion in mainline).

The code:

static void
vmxnet3_do_poll(struct vmxnet3_adapter *adapter, int budget, int *txd_done,
		int *rxd_done)
{
	if (unlikely(adapter->shared->ecr))
		vmxnet3_process_events(adapter);

	*txd_done = vmxnet3_tq_tx_complete(&adapter->tx_queue, adapter);
	*rxd_done = vmxnet3_rq_rx_complete(&adapter->rx_queue, adapter, budget);
}


static int
vmxnet3_poll(struct napi_struct *napi, int budget)
{
	struct vmxnet3_adapter *adapter = container_of(napi,
					  struct vmxnet3_adapter, napi);
	int rxd_done, txd_done;

	vmxnet3_do_poll(adapter, budget, &txd_done, &rxd_done);

	if (rxd_done < budget) {
		napi_complete(napi);
		vmxnet3_enable_intr(adapter, 0);
	}
	return rxd_done;
}


Is simpler if you just have do_poll return rx done value. Probably Gcc
inline's it all anyway.

static int
vmxnet3_do_poll(struct vmxnet3_adapter *adapter, int budget)
{
	if (unlikely(adapter->shared->ecr))
		vmxnet3_process_events(adapter);

	vmxnet3_tq_tx_complete(&adapter->tx_queue, adapter);
	return vmxnet3_rq_rx_complete(&adapter->rx_queue, adapter, budget);
}


static int
vmxnet3_poll(struct napi_struct *napi, int budget)
{
	struct vmxnet3_adapter *adapter = container_of(napi,
					  struct vmxnet3_adapter, napi);
	int rxd_done;

	rxd_done = vmxnet3_do_poll(adapter, budget);
	if (rxd_done < budget) {
		napi_complete(napi);
		vmxnet3_enable_intr(adapter, 0);
	}
	return rxd_done;
}
