Return-Path: <linux-kernel-owner+w=401wt.eu-S940851AbXGTQKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940851AbXGTQKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 12:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940225AbXGTQJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 12:09:37 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:16183 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760244AbXGTQJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 12:09:35 -0400
From: Jan-Bernd Themann <ossthema@de.ibm.com>
Subject: [RFC 0/1] lro: Generic Large Receive Offload for TCP traffic
Date: Fri, 20 Jul 2007 17:41:44 +0200
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
       David Miller <davem@davemloft.net>, Jeff Garzik <jeff@garzik.org>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707201741.45079.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks a lot for your comments so far.
This generic LRO patch differs from the last one in several points.
A new interface for a "receive in pages" mode has been added and tested
with an eHEA prototype. Seems to work well.

Does this extended interface seem to be sufficient?

Below some more explanations:

Thanks,
Jan-Bernd


Changes to http://www.spinics.net/lists/netdev/msg35490.html :

- Interfaces are changed to allow later support for IPv6 / UDP
- New interface to support "receive in pages"
- TCP checksums are updated properly
- TCP packets with push flag are aggregated now
- Timestamps are now compared using after()


The additional interface to support "receive in pages":

void lro_receive_frags(struct net_lro_mgr *lro_mgr,
                       struct skb_frag_struct *frags,
                       int len, int true_size, void *priv);

void lro_vlan_hwaccel_receive_frags(struct net_lro_mgr *lro_mgr,
                                    struct skb_frag_struct *frags,
                                    int len,
                                    int true_size,
                                    struct vlan_group *vgrp,
                                    u16 vlan_tag,
                                    void *priv);

These functions generate SKBs only for the first packet of an
LRO session. The next fragment list to be aggregated will be
added in the fragment list of that SKB.

The reason why this is a smart approach is described in:
http://www.spinics.net/lists/netdev/msg35634.html

All other packets that do not match the LRO requirements are
put in an SKB and sent to the stack.

Packets that are received in an extra buffer (small packets) and
thus not in an skb fragment can be sent by the driver to the stack
after flushing the appropriate LRO sessions:

void lro_flush_pkt(struct net_lro_mgr *lro_mgr,
                   struct iphdr *iph, struct tcphdr *tcph);

or

void lro_flush_all(struct net_lro_mgr *lro_mgr);

