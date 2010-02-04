Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596Ab0BDXJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 18:09:06 -0500
Received: from sentry-three.sandia.gov ([132.175.109.17]:43177 "EHLO
	sentry-three.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889Ab0BDXJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 18:09:04 -0500
X-WSS-ID: 0KXCAZ9-08-3QH-02
X-M-MSG: 
X-Server-Uuid: AF72F651-81B1-4134-BA8C-A8E1A4E620FF
Subject: Re: [PATCH] seastar - SeaStar Ethernet driver
From: "Kevin Pedretti" <ktpedre@sandia.gov>
To: "David Miller" <davem@davemloft.net>
cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100202.174045.135005544.davem@davemloft.net>
References: <20100202205845.GE5246@hawkeye.sandia.gov>
 <20100202.134251.15604523.davem@davemloft.net>
 <1265160242.15726.20.camel@hawkeye.sandia.gov>
 <20100202.174045.135005544.davem@davemloft.net>
Date: Thu, 4 Feb 2010 16:01:04 -0700
Message-ID: <1265324464.23523.51.camel@hawkeye.sandia.gov>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.1
X-TMWD-Spam-Summary: TS=20100204230856; ID=1; SEV=2.3.1;
 DFV=B2010020419; IFV=NA; AIF=B2010020419; RPD=5.03.0010; ENG=NA;
 RPDID=7374723D303030312E30413031303230322E34423642353338382E303032333A534346535441543838363133332C73733D312C6667733D30;
 CAT=NONE; CON=NONE; SIG=AAAAAAAAAAAAAAAAAAAAAAAAfQ==
X-MMS-Spam-Filter-ID: B2010020419_5.03.0010
X-WSS-ID: 67758C0C2DG2131795-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-02 at 18:40 -0700, David Miller wrote:
> From: "Kevin Pedretti" <ktpedre@sandia.gov>
> Date: Tue, 2 Feb 2010 18:24:02 -0700
> 
> > 4. Device only supports IPv4? -> Yes, that's correct. No IPv6 support.
> > The driver squashes everything but IPv4 in eth2ss().
> 
> Not just IPV6, what about other ethernet protocols?
> 
> What about ARP?  How does IPV4 work if you only accept ETH_P_IP?  You
> need to accept at least ETH_P_ARP for things to work.


The only thing the driver supports currently is point-to-point IPv4,
nothing else.  The limitation is that the header format for datagram
messages is fixed, and it isn't really setup for Ethernet encapsulation:

Ethernet Frame:     [6 bytes h_dest][6 bytes h_source][2 bytes h_proto][data...]
SeaStar DG Message: [2 bytes length][1 byte MBZ][1 byte msg type (2 << 5) for IP)][data...]

I think it would be possible to re-factor it so that the Ethernet frame
is encapsulated in its entirety within a seastar message, rather than
the current scheme of jamming the critical info from the Ethernet header
into the seastar datagram header.  I will pursue that if you want... the
drawback is that it would break compatibility with Cray's existing
proprietary IP over SeaStar driver, making this driver pretty much
useless for the kinds of things us and others would like to do (e.g.,
leave service nodes booted with Cray's proprietary software stack and
talking to compute nodes running this driver).

As far as ARP goes, it isn't supported since the underlying network is
point-to-point only with no hardware broadcast.  At bootup, each node's
ARP table is pre-populated with entries for every node in the system,
and each node's MAC address encodes its node ID on the mesh.  This
driver uses the NID in the target MAC address to know who to send the
skb to.

I think it would be possible to emulate ARP in software using
point-to-point messages (send this packet to my 6 nearest neighbors,
neighbors send to their neighbors, etc.) but that would be quite a bit
more complicated compared to the static ARP table solution.  Again, it
would also break compatibility with Cray's proprietary driver.

Please let me know if these issues are show-stoppers as far as inclusion
goes.  We would like to get this open-source driver into the kernel so
us and others with Cray XT systems can start to benefit from it, and
continue to automatically track kernel API changes. 

Kevin


