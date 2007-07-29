Return-Path: <linux-kernel-owner+w=401wt.eu-S1765217AbXG2QHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765217AbXG2QHm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 12:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762921AbXG2QHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 12:07:32 -0400
Received: from 1wt.eu ([62.212.114.60]:4063 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762613AbXG2QHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 12:07:31 -0400
Date: Sun, 29 Jul 2007 18:07:22 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: "Darryl L. Miles" <darryl-mailinglists@netbauds.net>,
       linux-kernel@vger.kernel.org, Netdev <netdev@vger.kernel.org>
Subject: Re: TCP SACK issue, hung connection, tcpdump included
Message-ID: <20070729160721.GA31276@1wt.eu>
References: <46AC2CBE.5010500@netbauds.net> <20070729064511.GA18718@1wt.eu> <Pine.LNX.4.64.0707291052300.10340@kivilampi-30.cs.helsinki.fi> <20070729085427.GA22784@1wt.eu> <Pine.LNX.4.64.0707291208230.10340@kivilampi-30.cs.helsinki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0707291208230.10340@kivilampi-30.cs.helsinki.fi>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2007 at 12:28:04PM +0300, Ilpo Järvinen wrote:
(...)
> > > Limitation for 48 byte segments? You have to be kidding... :-) But yes,
> > > it seems that one of the directions is dropping packets for some reason 
> > > though I would not assume MTU limitation... Or did you mean some other 
> > > segment?
> > 
> > No, I was talking about the 1448 bytes segments. But in fact I don't
> > believe it much because the SACKs are always retransmitted just afterwards.
> 
> Ah, but it's ACKed correctly right below it...:
> 
> [...snip...]
> > > > > 09:21:39.490740 IP SERVER.ssh > CLIENT.50727: P 18200:18464(264) ack 2991 
> > > > > win 2728 <nop,nop,timestamp 7692910 800001727>
> > > > > 09:21:39.490775 IP CLIENT.50727 > SERVER.ssh: . ack 18464 win 378 
> > > > > <nop,nop,timestamp 800001755 7692910>
> > > > > 09:21:39.860245 IP SERVER.ssh > CLIENT.50727: . 12408:13856(1448) ack 2991 
> > > > > win 2728 <nop,nop,timestamp 7693293 800001749>
> 
> ...segment below snd_una arrived => snd_una remains 18464, receiver 
> generates a duplicate ACK:
>  
> > > > > 09:21:39.860302 IP CLIENT.50727 > SERVER.ssh: . ack 18464 win 378 
> > > > > <nop,nop,timestamp 800001847 7692910,nop,nop,sack sack 1 {12408:13856} >
> 
> The cumulative ACK field of it covers _everything_ below 18464 (i.e., it 
> ACKs them), including the 1448 bytes in 12408:13856... In addition, the 
> SACK block is DSACK information [RFC2883] telling explicitly the address 
> of the received duplicate block. However, if this ACK doesn't reach the 
> SERVER TCP, RTO is triggered and the first not yet cumulatively ACKed 
> segment is retransmitted (I guess cumulative ACKs up to 12408 arrived 
> without problems to the SERVER):

Oh yes, you're damn right. I did not notice that the ACK was higher than
the SACK, I'm more used to read traces with absolute rather than relative
seq/acks.

So I agree, it is this ACK which is lost between client and server,
reinforcing the supposition about the location of the capture (client side).

> [...snip...]
> 
> > BTW, some information are missing. It would have been better if the trace
> > had been read with tcpdump -Svv. We would have got seq numbers and ttl.
> > Also, we do not know if there's a firewall between both sides. Sometimes,
> > some IDS identify attacks in crypted traffic and kill connections. It
> > might have been the case here, with the connection closed one way on an
> > intermediate firewall.
> 
> Yeah, firewall or some other issue, I'd say it's quite unlikely a bug in 
> TCP because behavior to both directions indicate client -> sender 
> blackhole independently of each other...

It would also be possible that something stupid between both ends simply
drops packets with the SACK option set. Also something which sometimes
happen is that some firewalls automatically translate sequence numbers
but not necessarily SACK values, which could pretty well lead to this
packet being received but ignored on the server side.

I'm pretty sure that the same trace taken on the server side will reveal
the reason for the problem.

Willy

