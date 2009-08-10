Return-Path: <linux-kernel-owner+w=401wt.eu-S1754453AbZHJMk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbZHJMk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 08:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754357AbZHJMk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 08:40:57 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:28087 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312AbZHJMk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 08:40:56 -0400
From: "Fischer, Anna" <anna.fischer@hp.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "Paul Congdon (UC Davis)" <ptcongdon@ucdavis.edu>,
       "drobbins@funtoo.org" <drobbins@funtoo.org>,
       "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
       "mst@redhat.com" <mst@redhat.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "bridge@lists.linux-foundation.org" 
	<bridge@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ogerlitz@voltaire.com" <ogerlitz@voltaire.com>,
       "evb@yahoogroups.com" <evb@yahoogroups.com>,
       "davem@davemloft.net" <davem@davemloft.net>
Date: Mon, 10 Aug 2009 12:40:27 +0000
Subject: RE: [Bridge] [PATCH] macvlan: add tap device backend
Thread-Topic: [Bridge] [PATCH] macvlan: add tap device backend
Thread-Index: AcoXqzSHEpepV3VSR2Socpoq75bT9QCAYAPQ
Message-ID: <0199E0D51A61344794750DC57738F58E6D6AE99700@GVW1118EXC.americas.hpqcorp.net>
References: <0199E0D51A61344794750DC57738F58E6D6A6CD7F6@GVW1118EXC.americas.hpqcorp.net>
 <004f01ca1792$b24a7a90$16df6fb0$@edu> <200908080005.32443.arnd@arndb.de>
In-Reply-To: <200908080005.32443.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n7ACfF7T000554

> Subject: Re: [Bridge] [PATCH] macvlan: add tap device backend
> 
> On Friday 07 August 2009, Paul Congdon (UC Davis) wrote:
> > Responding to Daniel's questions...
> 
> Thanks for the detailed responses. I'll add some more about the
> specifics of the macvlan implementation that differs from the
> bridge based VEPA implementation.
> 
> > > Is this new interface to be used within a virtual machine or
> > > container, on the master node, or both?
> >
> > It is really an interface to a new type of virtual switch.  When
> > you create virtual network, I would imagine it being a new mode
> > of operation (bridge, NAT, VEPA, etc).
> 
> I think the question was whether the patch needs to applied in the
> host or the guest. Both the implementation that you and Anna did
> and the one that I posted only apply to the *host* (master node),
> the virtual machine does not need to know about it.
> 
> > > What interface(s) would need to be configured for a single virtual
> > > machine to use VEPA to access the network?
> >
> > It would be the same as if that machine were configure to use a
> > bridge to access the network, but the bridge mode would be different.
> 
> Right, with the bridge based VEPA, you would set up a kvm guest
> or a container with the regular tools, then use the sysfs interface
> to put the bridge device into VEPA mode.
> 
> With the macvlan based mode, you use 'ip link' to add a new tap
> device to an external network interface and not use a bridge at
> all. Then you configure KVM to use that tap device instead of the
> regular bridge/tap setup.
> 
> > > What are the current flexibility, security or performance
> limitations
> > > of tun/tap and bridge that make this new interface necessary or
> > > beneficial?
> >
> > If you have VMs that will be communicating with one another on
> > the same physical machine, and you want their traffic to be
> > exposed to an in-line network device such as a application
> > firewall/IPS/content-filter (without this feature) you will have
> > to have this device co-located within the same physical server.
> > This will use up CPU cycles that you presumable purchased to run
> > applications, it will require a lot of consistent configuration
> > on all physical machines, it could invoke potentially a lot of
> > software licensing, additional cost, etc..  Everything would
> > need to be replicated on each physical machine.  With the VEPA
> > capability, you can leverage all this functionality in an
> > external network device and have it managed and configured in
> > one place.  The external implementation is likely a higher
> > performance, silicon based implementation.  It should make it
> > easier to migrate machines from one physical server to another
> > and maintain the same network policy enforcement.
> 
> It's worth noting that depending on your network connectivity,
> performance is likely to go down significantly with VEPA over the
> existing bridge/tap setup, because all frames have to be sent
> twice through an external wire that has a limited capacity, so you may
> lose inter-guest bandwidth and get more latency in many cases, while
> you free up CPU cycles. With the bridge based VEPA, you might not
> even gain many cycles because much of the overhead is still there.
> On the cost side, external switches can also get quite expensive
> compared to x86 servers.
> 
> IMHO the real win of VEPA is on the management side, where you can
> use a single set of tool for managing the network, rather than
> having your network admins deal with both the external switches
> and the setup of linux netfilter rules etc.
> 
> The macvlan based VEPA has the same features as the bridge based
> VEPA, but much simpler code, which allows a number of shortcuts
> to save CPU cycles.

I am not yet convinced that the macvlan based VEPA would be significantly
better from a performance point-of-view. Really, once you have 
implemented all the missing bits and pieces to make the macvlan
driver a VEPA-compatible device, the code path for packet processing
will be very similar. Also, I think you have to keep in mind that,
ultimately, if a user is seriously concerned about high performance, 
then they would go for a hardware-based solution, e.g. a SRIOV NIC
with VEPA capabilities. Once you have made the decision for a software-
based approach, tiny performance differences should not have such a
big impact, and so I don't think that this should influence too much
the design decision on where VEPA capabilities should be placed in
the kernel.

If you compare macvtap with traditional QEMU networking interfaces that
are typically used in current bridged setups, then yes, performance will be
different. However, I think that this is not necessarily a fair 
comparison, and the performance difference does not come from the 
bridge being slow, but simply because you have implemented a better
solution to connect a virtual interface to a backend device that
can be assigned to a VM. There is no reason why you could not do this
for a bridge port as well.

Anna
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
