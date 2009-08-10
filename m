Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbZHJNQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbZHJNQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 09:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbZHJNQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 09:16:34 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:40231 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190AbZHJNQe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 09:16:34 -0400
From: "Fischer, Anna" <anna.fischer@hp.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "'Stephen Hemminger'" <shemminger@linux-foundation.org>,
       "Fischer, Anna" <anna.fischer@hp.com>,
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
       "Paul Congdon (UC Davis)" <ptcongdon@ucdavis.edu>
Date: Mon, 10 Aug 2009 13:16:00 +0000
Subject: RE: [PATCH][RFC] net/bridge: add basic VEPA support
Thread-Topic: [PATCH][RFC] net/bridge: add basic VEPA support
Thread-Index: AcoYDYnGxtlWOIc2SYu1zaGA5pZFcABqkijg
Message-ID: <0199E0D51A61344794750DC57738F58E6D6AE99743@GVW1118EXC.americas.hpqcorp.net>
References: <0199E0D51A61344794750DC57738F58E67D2DCECBB@GVW1118EXC.americas.hpqcorp.net>
 <20090806210002.75beb7c6@nehalam> <004e01ca1790$fec36c30$fc4a4490$@edu>
 <200908081149.27409.arnd@arndb.de>
In-Reply-To: <200908081149.27409.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: Re: [PATCH][RFC] net/bridge: add basic VEPA support
> 
> On Friday 07 August 2009, Paul Congdon (UC Davis) wrote:
> > As I understand the macvlan code, it currently doesn't allow two VMs
> on the
> > same machine to communicate with one another.
> 
> There are patches to do that. I think if we add that, there should be
> a way to choose the behavior between either bridging between the
> guests or VEPA.

If you implement this direct bridging capability between local VMs for 
macvlan, then would this not break existing applications that currently
use it? It would be quite a significant change to how macvlan works 
today. I guess, ideally, you would want to have macvlan work in 
separate modes, e.g. traditional macvlan, bridging, and VEPA.

 
> > I could imagine a hairpin mode on the adjacent bridge making this
> > possible, but the macvlan code would need to be updated to filter
> > reflected frames so a source did not receive his own packet.
> 
> Right, I missed this point so far. I'll follow up with a patch
> to do that.

Can you maybe point me to the missing patches for macvlan that you
have mentioned in other emails, and the one you mention above? 
E.g. enabling multicast distribution and allowing local bridging etc.
I could not find any of those in the archives. Thanks.

 
> > I could imagine this being done as well, but to also
> > support selective multicast usage, something similar to the bridge
> > forwarding table would be needed.  I think putting VEPA into a new
> driver
> > would cause you to implement many things the bridge code already
> supports.
> > Given that we expect the bridge standard to ultimately include VEPA,
> and the
> > new functions are basic forwarding operations, it seems to make most
> sense
> > to keep this consistent with the bridge module.
> 
> This is the interesting part of the discussion. The bridge and macvlan
> drivers certainly have an overlap in functionality and you can argue
> that you only need one. Then again, the bridge code is a little crufty
> and we might not want to add much more to it for functionality that can
> be implemented in a much simpler way elsewhere. My preferred way would
> be to use bridge when you really need 802.1d MAC learning, netfilter-
> bridge
> and STP, while we put the optimizations for stuff like VMDq, zero-copy
> and multiqueue guest adapters only into the macvlan code.

I can see this being a possible solution. 

My concern with putting VEPA into macvlan instead of the bridging code
is that there will be more work required to make it usable for other
virtualization solution as macvtap will only work for KVM type setups. 
Basically, VEPA capabilities would rely on someone developing further
drivers to connect macvlan to different backend interfaces, e.g. one for
KVM (macvtap), one for Xen PV drivers, one for virtio, and whatever else
is out there, or will be there in the future. The bridging code is
already very generic in that respect, and all virtualization layers
can deal with connecting interfaces to a bridge. 

Our extensions to the bridging code to enable VEPA for the Linux kernel
are only very minimal code changes and would allow to make VEPA available
to most virtualization solutions today.

Anna
