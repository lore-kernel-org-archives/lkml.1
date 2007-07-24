Return-Path: <linux-kernel-owner+w=401wt.eu-S1762387AbXGXNtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762387AbXGXNtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 09:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbXGXNtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 09:49:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35980 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbXGXNtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 09:49:06 -0400
Subject: Re: [PATCH] LinuxPPS - definitive version
From: David Woodhouse <dwmw2@infradead.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070724080013.GA22171@gundam.enneenne.com>
References: <20070717180550.GA24759@enneenne.com>
	 <1185197716.14697.244.camel@pmac.infradead.org>
	 <20070724080013.GA22171@gundam.enneenne.com>
Content-Type: text/plain
Date: Tue, 24 Jul 2007 14:49:02 +0100
Message-Id: <1185284942.14697.319.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-24 at 10:00 +0200, Rodolfo Giometti wrote:
> On Mon, Jul 23, 2007 at 02:35:16PM +0100, David Woodhouse wrote:
> >
> > s/Documentaion/Documentation/ in the last line of Documentation/pps/pps.txt
> 
> Fixed.

Also 's/unknow /unknown /' (2 instances)

> > Please feed it to scripts/checkpatch.pl -- you can ignore all the
> > warnings about lines greater than 80 characters, and the complete crap
> > about "declaring multiple variables together should be avoided", but
> 
> Done. Most fixed.

Looks better.

> > some of what it points out is valid. Including the one about 'volatile'
> > -- your explanation lacked credibility. If you really need 'volatile'
> > then put it at the places you actually need it; not the declaration of
> > the structure. 
> 
> Can you please explain better where should I put the 'volatile'
> attribute? :-o

Am I right in thinking that the only place it matters is within
pps_event()? In that case, at the very least you should probably remove
the 'volatile' from the definition of the structure, and _cast_ to
volatile where you want it treated that way.

But I don't see why you can't protect it with a spinlock. As long as you
acquire that spinlock _after_ your call to getnstimeofday() what's the
problem?

> > ...
> This should be not needed due new 'struct pps_ktime'.
> > ...
> These typedefs are into timepps.h which is an userland file (located
> into Documentation/pps/) and are requested by the RFC.

Sorry, yes. I shouldn't have been looking at that as if it was kernel
code.

I think you still haven't quite got the 32-bit vs. 64-bit compatibility
right. Remember that on i386, the alignment of a uint64_t is only 4
bytes, while on most other architectures it's 8 bytes. On i386, there
will be no padding between the two consecutive 'struct pps_ktime'
members of struct pps_kinfo and struct pps_kparams. But on most
platforms there will be padding to ensure correct alignment.

The simple fix is probably to make the 'nsec' member a 64-bit integer
too. Then it'll be the same for i386 and x86_64 and you won't need a
compatibility syscall routine.

In order for your handling of 'pps_source[source].info' to be safe with
respect to pps_unregister_source(), you have to guarantee that
pps_event() has finished -- and can't be in progress on another CPU --
by the time your client's call to pps_unregister_source() completes. At
first glance I think your existing clients have that right (you have
del_timer_sync() before pps_unregister_source() in ktimer.c, for
example). But you should make sure it's clearly documented for new
clients.

Shouldn't your PPS_CLIENT_LP and PPS_CLIENT_UART options depend on
PARPORT and SERIAL_CORE respectively?

-- 
dwmw2

