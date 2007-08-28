Return-Path: <linux-kernel-owner+w=401wt.eu-S1763418AbXH1Tib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763418AbXH1Tib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755062AbXH1TiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:38:16 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:37169 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbXH1TiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:38:14 -0400
X-IronPort-AV: i="4.19,318,1183359600"; 
   d="scan'208"; a="518060091:sNHT52149968"
To: David Miller <davem@davemloft.net>
Cc: tom@opengridcomputing.com, jeff@garzik.org, swise@opengridcomputing.com,
       mshefty@ichips.intel.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCP ports from the host TCP port space.
X-Message-Flag: Warning: May contain useful information
References: <adatzqxwh56.fsf@cisco.com>
	<20070817.234405.66176298.davem@davemloft.net>
	<adalkc5u1o9.fsf@cisco.com>
	<20070820.235804.85409183.davem@davemloft.net>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 28 Aug 2007 12:38:07 -0700
In-Reply-To: <20070820.235804.85409183.davem@davemloft.net> (David Miller's message of "Mon, 20 Aug 2007 23:58:04 -0700 (PDT)")
Message-ID: <adair6zjvq8.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Aug 2007 19:38:08.0181 (UTC) FILETIME=[F5DAAE50:01C7E9AA]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the long latency, I was at the beach all last week.

 > > And direct data placement really does give you a factor of two at
 > > least, because otherwise you're stuck receiving the data in one
 > > buffer, looking at some of the data at least, and then figuring out
 > > where to copy it.  And memory bandwidth is if anything becoming more
 > > valuable; maybe LRO + header splitting + page remapping tricks can get
 > > you somewhere but as NCPUS grows then it seems the TLB shootdown cost
 > > of page flipping is only going to get worse.

 > As Herbert has said already, people can code for this just like
 > they have to code for RDMA.

No argument, you need to change the interface to take advantage of RDMA.

 > There is no fundamental difference from converting an application
 > to sendfile or similar.

Yes, on the transmit side, there's not much difference from sendfile
or splice, although RDMA may give a slightly nicer interface that also
gives basically the equivalent of AIO.

 > The only thing this needs is a
 > "recvmsg_I_dont_care_where_the_data_is()" call.  There are no alignment
 > issues unless you are trying to push this data directly into the
 > page cache.

I don't understand how this gives you the same thing as direct data
placement (DDP).  There are many situations where the sender knows
where the data has to go and if there's some way to pass that to the
receiver, so that info can be used in the receive path to put the data
in the right place, the receiver can save a copy.  This is
fundamentally the same "offload" that an FC HBA does -- the SCSI
midlayer queues up commands like "read block A and put the data at
address X" and "read block B and put the data at address Y" and the
HBA matches tags on incoming data to put the blocks at the right
addresses, even if block B is received before block A.

RFC 4297 has some discussion of the various approaches, and while you
might not agree with their conclusions, it is interesting reading.

 > Couple this with a card that makes sure that on a per-page basis, only
 > data for a particular flow (or group of flows) will accumulate.

It seems that the NIC would also have to look into a TCP stream (and
handle out of order segments etc) to find message boundaries for this
to be equivalent to what an RDMA NIC does.

 - R.
