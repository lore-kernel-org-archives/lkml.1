Return-Path: <linux-kernel-owner+w=401wt.eu-S932112AbZHJPKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbZHJPKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 11:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755039AbZHJPKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 11:10:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51316 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbZHJPKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 11:10:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Fischer, Anna" <anna.fischer@hp.com>
Subject: Re: [PATCH][RFC] net/bridge: add basic VEPA support
Date: Mon, 10 Aug 2009 17:06:58 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.2.98; x86_64; ; )
Cc: "'Stephen Hemminger'" <shemminger@linux-foundation.org>,
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
       "Paul Congdon (UC Davis)" <ptcongdon@ucdavis.edu>,
       Eric Biederman <ebiederm@xmission.com>
References: <0199E0D51A61344794750DC57738F58E67D2DCECBB@GVW1118EXC.americas.hpqcorp.net> <200908081149.27409.arnd@arndb.de> <0199E0D51A61344794750DC57738F58E6D6AE99743@GVW1118EXC.americas.hpqcorp.net>
In-Reply-To: <0199E0D51A61344794750DC57738F58E6D6AE99743@GVW1118EXC.americas.hpqcorp.net>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908101706.58261.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18a6VIbUhvEbQgOLmI1gqwuWTLkR4mHPZgoVOp
 zfll1oa6yqVoDZDqHs9YcUxJeQUzA6GiwqNP3dmqwvYxZ/OtLZ
 BCDCcgM5s1r+PI/tRm0dQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 August 2009, Fischer, Anna wrote:
> > Subject: Re: [PATCH][RFC] net/bridge: add basic VEPA support
> > 
> > On Friday 07 August 2009, Paul Congdon (UC Davis) wrote:
> > > As I understand the macvlan code, it currently doesn't allow two VMs
> > on the
> > > same machine to communicate with one another.
> > 
> > There are patches to do that. I think if we add that, there should be
> > a way to choose the behavior between either bridging between the
> > guests or VEPA.
> 
> If you implement this direct bridging capability between local VMs for 
> macvlan, then would this not break existing applications that currently
> use it? It would be quite a significant change to how macvlan works 
> today. I guess, ideally, you would want to have macvlan work in 
> separate modes, e.g. traditional macvlan, bridging, and VEPA.

Right, that's what I meant with my sentence above. I'm not sure
if we need to differentiate traditional macvlan and VEPA though.
AFAICT, the only difference should be the handling of broadcast
and multicast frames returning from the hairpin turn. Since this
does not happen with a traditional macvlan, we can always send them
to all macvlan ports except the source port.

> > > I could imagine a hairpin mode on the adjacent bridge making this
> > > possible, but the macvlan code would need to be updated to filter
> > > reflected frames so a source did not receive his own packet.
> > 
> > Right, I missed this point so far. I'll follow up with a patch
> > to do that.
> 
> Can you maybe point me to the missing patches for macvlan that you
> have mentioned in other emails, and the one you mention above? 
> E.g. enabling multicast distribution and allowing local bridging etc.
> I could not find any of those in the archives. Thanks.

The patch from Eric Biederman to allow macvlan to bridge between
its slave ports is at

http://kerneltrap.org/mailarchive/linux-netdev/2009/3/9/5125774

I could not find any patches for the other features (or bugs).

> > This is the interesting part of the discussion. The bridge and macvlan
> > drivers certainly have an overlap in functionality and you can argue
> > that you only need one. Then again, the bridge code is a little crufty
> > and we might not want to add much more to it for functionality that can
> > be implemented in a much simpler way elsewhere. My preferred way would
> > be to use bridge when you really need 802.1d MAC learning, netfilter-
> > bridge
> > and STP, while we put the optimizations for stuff like VMDq, zero-copy
> > and multiqueue guest adapters only into the macvlan code.
> 
> I can see this being a possible solution. 
> 
> My concern with putting VEPA into macvlan instead of the bridging code
> is that there will be more work required to make it usable for other
> virtualization solution as macvtap will only work for KVM type setups.

Right, I understand.

> Basically, VEPA capabilities would rely on someone developing further
> drivers to connect macvlan to different backend interfaces, e.g. one for
> KVM (macvtap), one for Xen PV drivers, one for virtio, and whatever else
> is out there, or will be there in the future. The bridging code is
> already very generic in that respect, and all virtualization layers
> can deal with connecting interfaces to a bridge. 
> 
> Our extensions to the bridging code to enable VEPA for the Linux kernel
> are only very minimal code changes and would allow to make VEPA available
> to most virtualization solutions today.

I don't object to having VEPA supported in the bridge code at all.
I think your patch is simple enough so it won't hurt in the bridge
code. If Stephen prefers to do VEPA only in one component, we should
probably make it possible for that component to act as a bridge between
1+n existing interfaces as well. You can almost do that with the regular
macvlan and the bridge driver, like

      / macvlan0 - br0 - tap0
eth0 -- macvlan1 - br1 - tap1
      \ macvlan2 - br2 - tap2

Here, you can have two guests attached to tap devices (or xen net ...)
and the macvlan driver doing the VEPA. Of course this is not how bridge
works -- you would have the same mac addresses on two sides of
the bridge.

So we could have another macvlan backend (let's call it macvbridge)
so you can do this:

      / macvlan0 - 'qemu -net raw'
eth0 -- macvtap0 - 'qemu -net tap,fd=3 3<>/dev/net/macvtap0'
      \ macvbr0 -- tap0 - 'qemu -net tap'

The macvbr driver could this way be used to associate an existing
network device to a slave of a macvlan port. Not sure if this
has any significant advantage over your bridge patches, it does
have the obvious disadvantage that someone needs to implement
it first, while your patch is there ;-)

	Arnd <><
