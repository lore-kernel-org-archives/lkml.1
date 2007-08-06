Return-Path: <linux-kernel-owner+w=401wt.eu-S1761299AbXHFIVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761299AbXHFIVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 04:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759436AbXHFIVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 04:21:09 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:19428 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896AbXHFIVG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 04:21:06 -0400
From: Jan-Bernd Themann <ossthema@de.ibm.com>
To: =?utf-8?q?J=C3=B6rn_Engel?= <joern@logfs.org>
Subject: Re: [PATCH 1/1] lro: Generic Large Receive Offload for TCP traffic
Date: Mon, 6 Aug 2007 09:51:11 +0200
User-Agent: KMail/1.8.2
Cc: David Miller <davem@davemloft.net>, Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>, netdev <netdev@vger.kernel.org>,
       Andrew Gallatin <gallatin@myri.com>, Jeff Garzik <jeff@garzik.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200708031441.20632.ossthema@de.ibm.com> <20070803134150.GH19344@lazybastard.org>
In-Reply-To: <20070803134150.GH19344@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708060951.12408.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jörn

On Friday 03 August 2007 15:41, Jörn Engel wrote:
> On Fri, 3 August 2007 14:41:19 +0200, Jan-Bernd Themann wrote:
> > 
> > This patch provides generic Large Receive Offload (LRO) functionality
> > for IPv4/TCP traffic.
> > 
> > LRO combines received tcp packets to a single larger tcp packet and 
> > passes them then to the network stack in order to increase performance
> > (throughput). The interface supports two modes: Drivers can either pass
> > SKBs or fragment lists to the LRO engine. 
> 
> Maybe this is a stupid question, but why is LRO done at the device
> driver level?
> 
> If it is a unversal performance benefit, I would have expected it to be
> done generically, i.e. have all packets moved into network layer pass
> through LRO instead.

The driver seems to be the right place:
-  There is the "page mode" interface that accepts fragment lists instead of
   SKBs and does generate SKBs only in the end (see Andrew Gallatins 
   mails where he described the advantages of this approach)

-  Some drivers (in particular for 10G NICs which actually could benefit
   from LRO) have multiple HW receive queues that do some sort of sorting,
   thus using one lro_mgr per queue increases the likelyhood of beeing able
   to do efficient LRO.
   

> > +void lro_flush_pkt(struct net_lro_mgr *lro_mgr,
> > +		   struct iphdr *iph, struct tcphdr *tcph);

> In particular this bit looks like it should be driven by a timeout,
> which would be settable via /proc/sys/net/core/lro_timeout or similar.

No, this function is needed for "page mode" as some HW provides
extra handling for small packets where packets are not stored in preallocated 
pages but in extra queues. Thus the driver needs a way to flush old sessions
for this connection and handle these packets in a different way (for example 
create a SKB and copy the data there).

Timeouts are not used at all. Experiments showed that flushing at the end 
of a NAPI poll round seems to be sufficient (see Andrew's test results)
and does not affect the latency too badly.

Regards,
Jan-Bernd
