Return-Path: <linux-kernel-owner+w=401wt.eu-S1755818AbZINPO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbZINPO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 11:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754661AbZINPO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 11:14:28 -0400
Received: from mail-a02.ithnet.com ([217.64.83.97]:48166 "HELO ithnet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752425AbZINPO1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 11:14:27 -0400
X-Sender-Authentication: net64
Date: Mon, 14 Sep 2009 17:10:01 +0200
From: Stephan von Krawczynski <skraw@ithnet.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: ipv4 regression in 2.6.31 ?
Message-Id: <20090914171001.47371b3d.skraw@ithnet.com>
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

Problem is this:
Kernel 2.6.30.X and below work flawlessly in this setup, only kernel 2.6.31
acts different. Is this an intended change in policy?

-- 
Regards,
Stephan
