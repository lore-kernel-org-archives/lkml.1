Return-Path: <linux-kernel-owner+w=401wt.eu-S1756123AbZHGWJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbZHGWJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 18:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbZHGWJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 18:09:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:63961 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430AbZHGWJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 18:09:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Paul Congdon \(UC Davis\)" <ptcongdon@ucdavis.edu>
Subject: Re: [Bridge] [PATCH] macvlan: add tap device backend
Date: Sat, 8 Aug 2009 00:05:32 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.2.98; x86_64; ; )
Cc: drobbins@funtoo.org, "'Fischer, Anna'" <anna.fischer@hp.com>,
       herbert@gondor.apana.org.au, mst@redhat.com, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       ogerlitz@voltaire.com, evb@yahoogroups.com, davem@davemloft.net
References: <0199E0D51A61344794750DC57738F58E6D6A6CD7F6@GVW1118EXC.americas.hpqcorp.net> <004f01ca1792$b24a7a90$16df6fb0$@edu>
In-Reply-To: <004f01ca1792$b24a7a90$16df6fb0$@edu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200908080005.32443.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18Tsxtliaj9Go/65PJQ2bHGcCijG/41JpnFocb
 maQYqicarCUc8PBdp7MEfCyRQ/gXcKcyv32ZZ4ode2D4QKb+FE
 5fMoeNf8cTiGU/s20Uj7g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 August 2009, Paul Congdon (UC Davis) wrote:
> Responding to Daniel's questions...

Thanks for the detailed responses. I'll add some more about the
specifics of the macvlan implementation that differs from the
bridge based VEPA implementation.

> > Is this new interface to be used within a virtual machine or 
> > container, on the master node, or both?
> 
> It is really an interface to a new type of virtual switch.  When
> you create virtual network, I would imagine it being a new mode
> of operation (bridge, NAT, VEPA, etc).

I think the question was whether the patch needs to applied in the
host or the guest. Both the implementation that you and Anna did
and the one that I posted only apply to the *host* (master node),
the virtual machine does not need to know about it.

> > What interface(s) would need to be configured for a single virtual 
> > machine to use VEPA to access the network?
> 
> It would be the same as if that machine were configure to use a
> bridge to access the network, but the bridge mode would be different.

Right, with the bridge based VEPA, you would set up a kvm guest
or a container with the regular tools, then use the sysfs interface
to put the bridge device into VEPA mode.

With the macvlan based mode, you use 'ip link' to add a new tap
device to an external network interface and not use a bridge at
all. Then you configure KVM to use that tap device instead of the
regular bridge/tap setup.

> > What are the current flexibility, security or performance limitations 
> > of tun/tap and bridge that make this new interface necessary or 
> > beneficial?
> 
> If you have VMs that will be communicating with one another on
> the same physical machine, and you want their traffic to be
> exposed to an in-line network device such as a application
> firewall/IPS/content-filter (without this feature) you will have
> to have this device co-located within the same physical server.
> This will use up CPU cycles that you presumable purchased to run
> applications, it will require a lot of consistent configuration
> on all physical machines, it could invoke potentially a lot of
> software licensing, additional cost, etc..  Everything would
> need to be replicated on each physical machine.  With the VEPA
> capability, you can leverage all this functionality in an
> external network device and have it managed and configured in
> one place.  The external implementation is likely a higher
> performance, silicon based implementation.  It should make it
> easier to migrate machines from one physical server to another
> and maintain the same network policy enforcement.

It's worth noting that depending on your network connectivity,
performance is likely to go down significantly with VEPA over the
existing bridge/tap setup, because all frames have to be sent
twice through an external wire that has a limited capacity, so you may
lose inter-guest bandwidth and get more latency in many cases, while
you free up CPU cycles. With the bridge based VEPA, you might not
even gain many cycles because much of the overhead is still there.
On the cost side, external switches can also get quite expensive
compared to x86 servers. 

IMHO the real win of VEPA is on the management side, where you can
use a single set of tool for managing the network, rather than
having your network admins deal with both the external switches
and the setup of linux netfilter rules etc.

The macvlan based VEPA has the same features as the bridge based
VEPA, but much simpler code, which allows a number of shortcuts
to save CPU cycles.

> The isolation in the outbound direction is created by the way frames
> are forwarded.  They are simply dropped on the wire, so no VMs can
> talk directly to one another without their traffic first going
> external.  In the inbound direction, the isolation is created using
> the forwarding table.  

Right. Note that in the macvlan case, the filtering on inbound data is an inherent
part of the macvlan setup, it does use the dynamic forwarding table of the
bridge driver.

> > Are there any associated user-space tools required for configuring a 
> > VEPA?
> >
> 
> The standard brctl utility has been augmented to enable/disable the capability.

That is for the bridge based VEPA, while my patch uses the 'ip link'
command that ships with most distros. It does not need any modifications
right now, but might need them if we add other features like support for
multiple MAC addresses in a single guest.

	Arnd <><
