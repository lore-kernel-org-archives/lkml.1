Return-Path: <linux-kernel-owner+w=401wt.eu-S1762036AbXHCM2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762036AbXHCM2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 08:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760072AbXHCM2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 08:28:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37753 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925AbXHCM2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 08:28:31 -0400
Subject: Re: Distributed storage.
From: Peter Zijlstra <peterz@infradead.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Daniel Phillips <phillips@phunq.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
In-Reply-To: <20070803105747.GE10089@2ka.mipt.ru>
References: <20070731171347.GA14267@2ka.mipt.ru>
	 <200708021408.24876.phillips@phunq.net>
	 <20070803102629.GB10089@2ka.mipt.ru>  <20070803105747.GE10089@2ka.mipt.ru>
Content-Type: text/plain
Date: Fri, 03 Aug 2007 14:27:52 +0200
Message-Id: <1186144072.11797.55.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-03 at 14:57 +0400, Evgeniy Polyakov wrote:

> For receiving situation is worse, since system does not know in advance
> to which socket given packet will belong to, so it must allocate from
> global pool (and thus there must be independent global reserve), and
> then exchange part of the socket's reserve to the global one (or just
> copy packet to the new one, allocated from socket's reseve is it was
> setup, or drop it otherwise). Global independent reserve is what I
> proposed when stopped to advertise network allocator, but it seems that
> it was not taken into account, and reserve was always allocated only
> when system has serious memory pressure in Peter's patches without any
> meaning for per-socket reservation.

This is not true. I have a global reserve which is set-up a priori. You
cannot allocate a reserve when under pressure, that does not make sense.

Let me explain my approach once again.

At swapon(8) time we allocate a global reserve. And associate the needed
sockets with it. The size of this global reserve is make up of two
parts:
  - TX
  - RX

The RX pool is the most interresting part. It again is made up of two
parts:
  - skb
  - auxilary data

The skb part is scaled such that it can overflow the IP fragment
reassembly, the aux pool such that it can overflow the route cache (that
was the largest other allocator in the RX path)

All (reserve) RX skb allocations are accounted, so as to never allocate
more than we reserved.

All packets are received (given the limit) and are processed up to
socket demux. At that point all packets not targeted at an associated
socket are dropped and the skb memory freed - ready for another packet.

All packets targeted for associated sockets get processed. This requires
that this packet processing happens in-kernel. Since we are swapping
user-space might be waiting for this data, and we'd deadlock.


I'm not quite sure why you need per socket reservations.

