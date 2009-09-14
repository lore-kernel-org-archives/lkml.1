Return-Path: <linux-kernel-owner+w=401wt.eu-S1755885AbZINPzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbZINPzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 11:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849AbZINPzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 11:55:10 -0400
Received: from mail-a02.ithnet.com ([217.64.83.97]:34590 "HELO ithnet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755798AbZINPzI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 11:55:08 -0400
X-Sender-Authentication: net64
Date: Mon, 14 Sep 2009 17:55:05 +0200
From: Stephan von Krawczynski <skraw@ithnet.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: ipv4 regression in 2.6.31 ?
Message-Id: <20090914175505.a3f132ee.skraw@ithnet.com>
In-Reply-To: <4AAE4BAF.2010406@gmail.com>
References: <20090914150935.cc895a3c.skraw@ithnet.com>
	<4AAE4BAF.2010406@gmail.com>
Organization: ith Kommunikationstechnik GmbH
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Sep 2009 15:57:03 +0200
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Stephan von Krawczynski a écrit :
> > Hello all,
> > 
> > today we experienced some sort of regression in 2.6.31 ipv4 implementation, or
> > at least some incompatibility with former 2.6.30.X kernels.
> > 
> > We have the following situation:
> > 
> >                                        ---------- vlan1@eth0 192.168.2.1/24
> >                                       /
> > host A 192.168.1.1/24 eth0  -------<router>            host B
> >                                       \
> >                                        ---------- eth1 192.168.3.1/24
> > 
> > 
> > Now, if you route 192.168.1.0/24 via interface vlan1@eth0 on host B and let
> > host A ping 192.168.2.1 everything works. But if you route 192.168.1.0/24 via
> > interface eth1 on host B and let host A ping 192.168.2.1 you get no reply.
> > With tcpdump we see the icmp packets arrive at vlan1@eth0, but no icmp echo
> > reply being generated neither on vlan1 nor eth1.
> > Kernels 2.6.30.X and below do not show this behaviour.
> > Is this intended? Do we need to reconfigure something to restore the old
> > behaviour?
> > 
> 
> Asymetric routing ?
> 
> Check your rp_filter settings
> 
> grep . `find /proc/sys/net -name rp_filter`
> 
> rp_filter - INTEGER
>         0 - No source validation.
>         1 - Strict mode as defined in RFC3704 Strict Reverse Path
>             Each incoming packet is tested against the FIB and if the interface
>             is not the best reverse path the packet check will fail.
>             By default failed packets are discarded.
>         2 - Loose mode as defined in RFC3704 Loose Reverse Path
>             Each incoming packet's source address is also tested against the FIB
>             and if the source address is not reachable via any interface
>             the packet check will fail.
> 
>         Current recommended practice in RFC3704 is to enable strict mode
>         to prevent IP spoofing from DDos attacks. If using asymmetric routing
>         or other complicated routing, then loose mode is recommended.
> 
>         conf/all/rp_filter must also be set to non-zero to do source validation
>         on the interface
> 
>         Default value is 0. Note that some distributions enable it
>         in startup scripts.

Ok, here you can see 2.6.31 values from the discussed box:
(remember, no ping reply in this setup)

/proc/sys/net/ipv4/conf/all/rp_filter:1
/proc/sys/net/ipv4/conf/default/rp_filter:0
/proc/sys/net/ipv4/conf/lo/rp_filter:0
/proc/sys/net/ipv4/conf/eth2/rp_filter:0
/proc/sys/net/ipv4/conf/eth0/rp_filter:0
/proc/sys/net/ipv4/conf/eth1/rp_filter:0
/proc/sys/net/ipv4/conf/vlan1/rp_filter:0


And these are from the same box with 2.6.30.5:
(ping reply works)

/proc/sys/net/ipv4/conf/all/rp_filter:1
/proc/sys/net/ipv4/conf/default/rp_filter:0
/proc/sys/net/ipv4/conf/lo/rp_filter:0
/proc/sys/net/ipv4/conf/eth2/rp_filter:0
/proc/sys/net/ipv4/conf/eth0/rp_filter:0
/proc/sys/net/ipv4/conf/eth1/rp_filter:0
/proc/sys/net/ipv4/conf/vlan1/rp_filter:0

As you can see they're all the same. Does this mean that rp_filter never
really worked as intended before 2.6.31 ? Or does it mean that rp_filter=0
(eth1 and vlan1) gets overriden by all/rp_filter=1 in 2.6.31 and not before?

--
Regards,
Stephan

