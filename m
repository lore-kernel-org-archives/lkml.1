Return-Path: <linux-kernel-owner+w=401wt.eu-S937671AbXG3Pyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937671AbXG3Pyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 11:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935415AbXG3PyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 11:54:04 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:37938 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933439AbXG3PyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 11:54:01 -0400
From: Jan-Bernd Themann <ossthema@de.ibm.com>
Subject: [PATCH 0/4][RFC] lro: Generic Large Receive Offload for TCP traffic
Date: Mon, 30 Jul 2007 17:24:33 +0200
User-Agent: KMail/1.8.2
MIME-Version: 1.0
Content-Disposition: inline
To: netdev <netdev@vger.kernel.org>
Cc: Christoph Raisch <raisch@de.ibm.com>,
       "Jan-Bernd Themann" <themann@de.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ppc" <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       David Miller <davem@davemloft.net>, Andrew Gallatin <gallatin@myri.com>,
       Jeff Garzik <jeff@garzik.org>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707301724.33865.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patch set contains the latest generic LRO code, a Kconfig / Makefile
and an eHEA patch demonstrating how the "aggregate SKB" interface has to
to be used.
Drew, could you provide a patch for the myri10ge driver to show how the
"receive in page" interface works?

Please check the Kconfig / Makefile patch. Is that the right place for
the LRO entries?

There is still one open question for the "receive in page" mode:
How many data (length) has to be copied to skb->data for packets that
do not work for LRO (other protocols?). Currently I choose 64 as default.
Is that ok?

Thanks,
Jan-Bernd

[PATCH 1/4][RFC] lro: Generic Large Receive Offload for TCP traffic
[PATCH 2/4][RFC] lro: Kconfig and Makefile
[PATCH 3/4][RFC] ehea: LRO support
[PATCH 4/4][RFC] ehea: Kconfig


Changes to http://www.spinics.net/lists/netdev/msg36912.html

1) A new field called "features" has been added to the net_lro_mgr struct.
   It is set by the driver to indicate:
   - LRO_F_NAPI:            Use NAPI / netif_rx to pass packets to stack

   - LRO_F_EXTRACT_VLAN_ID: Set by driver if HW extracts VLAN IDs for VLAN
        packets but does not modify ETH protocol (ETH_P_8021Q)

2) Padded frames are not aggregated for now. Bug fixed

3) Correct header length now used. No minimal header length for aggregated
   packets used anymore.

4) Statistic counters were introduced. They are stored in a new struct in
   the net_lro_mgr. This has the advantage that no locking is required in
   cases where the driver uses multiple lro_mgrs for different receive queues.
   Thus we get the following statistics per lro_mgr / eth device:
   - Number of aggregated packets
   - Number of flushed packets
   - Number of times we run out of lro_desc.

   The ratio of "aggregated packets" and "flushed packets" give you an
   idea how well LRO is working.
