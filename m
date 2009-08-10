Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbZHJP7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbZHJP7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 11:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755438AbZHJP7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 11:59:35 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:40596 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257AbZHJP7e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 11:59:34 -0400
From: "Fischer, Anna" <anna.fischer@hp.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "evb@yahoogroups.com" <evb@yahoogroups.com>,
       "'Stephen Hemminger'" <shemminger@linux-foundation.org>,
       "Fischer, Anna" <anna.fischer@hp.com>,
       "bridge@lists.linux-foundation.org" 
	<bridge@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "kaber@trash.net" <kaber@trash.net>,
       "adobriyan@gmail.com" <adobriyan@gmail.com>,
       "'Or Gerlitz'" <ogerlitz@voltaire.com>,
       "Paul Congdon (UC Davis)" <ptcongdon@ucdavis.edu>
Date: Mon, 10 Aug 2009 15:59:04 +0000
Subject: RE: [evb] Re: [PATCH][RFC] net/bridge: add basic VEPA support
Thread-Topic: [evb] Re: [PATCH][RFC] net/bridge: add basic VEPA support
Thread-Index: AcoZzpe3s+X0KptfTBSmtTQqwsn5ygAAFiiA
Message-ID: <0199E0D51A61344794750DC57738F58E6D6AE99867@GVW1118EXC.americas.hpqcorp.net>
References: <0199E0D51A61344794750DC57738F58E67D2DCECBB@GVW1118EXC.americas.hpqcorp.net>
 <200908071329.44437.arnd@arndb.de> <005101ca1797$70dcf5b0$5296e110$@edu>
 <200908101723.10832.arnd@arndb.de>
In-Reply-To: <200908101723.10832.arnd@arndb.de>
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
> >
> > I don't think your scheme works too well because broadcast packet
> coming
> > from other interfaces on br0 would get replicated and sent across the
> wire
> > to ethB multiple times.
> 
> Right, that won't work. So the bridge patch for the hairpin turn
> is still the best solution. 

Yes, I think that we should separate the discussions between hairpin 
mode on the adjacent bridge and the VEPA filtering service residing
within the end-station. The hairpin feature really has to be
implemented in the bridging code.


> Btw, how will that interact with
> the bride-netfilter (ebtables) setup? Can you apply any filters
> that work on current bridges also between two VEPA ports while
> doing the hairpin turn?

The hairpin mode is implemented on the adjacent bridge. The only 
difference for a hairpin mode port vs. a normal bridge port is that
it can pass frames back out to the same port it came from. All the
netfilter hooks are still in place.

On the VEPA filtering service side, the only change we have implemented
in the bridging code is that in VEPA mode all frames are passed to the
uplink on TX. However, frames are still passed through the netfilter 
hooks before they go out on the wire. On the inbound path, there are
no changes to the way frames are processed (except the filtering for
the original source port), so netfilter hooks work in the same way
as for a normal bridge.

If a frame is reflected back because of a hairpin turn, then of course
the incoming port is the VEPA uplink port and not the port that
originally sent the frame. So if you are trying to enforce some
packet filtering on that inbound path, then you would have to do that
based on MAC addresses and not on bridge ports. But I would assume that
you would enforce the filtering already before you send out the frame
to the adjacent bridge. Apart from that, if you enable your bridge to
behave in VEPA mode, then you would typically do packet filtering etc
on the adjacent bridge and not use the netfilter hook. You can still use
both though, if you like.

Anna
