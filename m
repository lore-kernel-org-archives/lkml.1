Return-Path: <linux-kernel-owner+w=401wt.eu-S1754381AbZHLQ2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbZHLQ2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 12:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbZHLQ2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 12:28:03 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50017 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278AbZHLQ2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 12:28:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Fischer, Anna" <anna.fischer@hp.com>
Subject: Re: [PATCH][RFC] net/bridge: add basic VEPA support
Date: Wed, 12 Aug 2009 18:27:28 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.3.0; x86_64; ; )
Cc: "Paul Congdon (UC Davis)" <ptcongdon@ucdavis.edu>,
       "'Stephen Hemminger'" <shemminger@linux-foundation.org>,
       "bridge@lists.linux-foundation.org" 
	<bridge@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "evb@yahoogroups.com" <evb@yahoogroups.com>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "kaber@trash.net" <kaber@trash.net>,
       "adobriyan@gmail.com" <adobriyan@gmail.com>,
       "'Eric Biederman'" <ebiederm@xmission.com>
References: <0199E0D51A61344794750DC57738F58E67D2DCECBB@GVW1118EXC.americas.hpqcorp.net> <200908121519.36808.arnd@arndb.de> <0199E0D51A61344794750DC57738F58E6D6AE9A0C1@GVW1118EXC.americas.hpqcorp.net>
In-Reply-To: <0199E0D51A61344794750DC57738F58E6D6AE9A0C1@GVW1118EXC.americas.hpqcorp.net>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908121827.28905.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+Kphbk1+s+Ho/qgfiEP/W3tp2mP6gfVV02l0u
 Y090hilwZZlkwvzA/87ouX8+y31eif7alWDbz+PkDMt6HJiUXd
 iIkRoKFXk4sL9S+qtuEFA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 August 2009, Fischer, Anna wrote:
> Yes, for the basic VEPA this is not important. For MultiChannel VEPA, it 
> would be nice if a macvlan device could operate as VEPA and as a typical
> VEB (VEB = traditional bridge but no learning).

Right, this would be a logical extension in that scenario. I would imagine
that in many scenarios running a VEB also means that you want to use
the advanced ebtables/iptables filtering of the bridge subsystem, but
if all guests trust each other, using macvlan to bridge between them
sounds useful as well, if only for simplicity.

> Basically, what we would need to be able to support is running a VEB and
> a VEPA simultaneously on the same uplink port (e.g. the physical device). 
> A new component (called the S-Component) would then multiplex frames
> to the VEB or the VEPA based on a tagging scheme.

You can of course do that by adding one port of the S-component to
a port of a bridge, and using another port of the S-component to
create macvlan devices, or you could have multiple ports of the
S-component each with a macvlan multiplexor.

Just to make sure I get the chain right, would it look like this?
(adapted from Paul's PDF)

eth0 (external) ---scomponent0 --- vlan2 --- macvlan0 
                 |              |         \- macvlan1
                 |               \-vlan3 --- macvlan2
                 |-scomponent1 --- vlan2 --- br0 --- tap0
                 |                             \ --- tap1
                 |-scomponent2 --- vlan3 --- macvlan3
                 \-scomponent3 ---  ---  --- macvlan4

In this scenario, tap0 and tap1 could communicate over the bridge without
tagging, while any data going out through the S-Component gets tagged
with both a 802.1q Q-Tag and an S-Tag. 

macvlan4 would be a guest that does its own tagging, and the external
switch would need to check the VLAN IDs, but it could communicate with
any other guest by tagging the frames as 2 or 3.

macvlan2 and macvlan3 could communicate with each other and with external
guests in vlan3.

Guests on scomponent1 and scomponent3 could in theory have
subdivisions of the network with macvlan running in the guest
to run containers.

> I think the question here was whether there is a way for a macvlan interface
> to be set to promiscuous mode. At the moment, I believe a macvlan interface
> only receives packets based on its destination address (this is for unicast
> packets now). What if a macvlan interface wanted to get all packets that
> are being received (either on the physical device, or on a particular
> VLAN if using macvlan nested in vlan). Would this work easily? Imagine
> you have a virtual machine attached to that macvlan / macvtap device and
> this VM wants to do packet inspection or network traffic monitoring on 
> all packets flowing through the virtualized server.

Ok, I see. As I said, the host could easily get access to all frames
on macvlan downstream ports by opening a raw socket on the upstream
port (with some extra work if we want to support this in bridge mode).

If you want the inspection to be done in a guest rather than the host,
the easiest way to achieve that would be to connect that raw socket
to the guest using Or's raw frontend for qemu.

	Arnd <><
