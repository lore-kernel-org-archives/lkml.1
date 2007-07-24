Return-Path: <linux-kernel-owner+w=401wt.eu-S1763613AbXGXOTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763613AbXGXOTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 10:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757522AbXGXOTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 10:19:44 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:39364 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756712AbXGXOTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 10:19:44 -0400
Date: Tue, 24 Jul 2007 16:20:50 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070724142050.GD4074@enneenne.com>
References: <20070717180550.GA24759@enneenne.com> <1185197716.14697.244.camel@pmac.infradead.org> <20070724080013.GA22171@gundam.enneenne.com> <1185284942.14697.319.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185284942.14697.319.camel@pmac.infradead.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] LinuxPPS - definitive version
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 02:49:02PM +0100, David Woodhouse wrote:

> Also 's/unknow /unknown /' (2 instances)

?? I didn't find them:

   $ grep 'unknow ' Documentation/pps/pps.txt

> Am I right in thinking that the only place it matters is within
> pps_event()? In that case, at the very least you should probably remove
> the 'volatile' from the definition of the structure, and _cast_ to
> volatile where you want it treated that way.

Ok, I see.

> But I don't see why you can't protect it with a spinlock. As long as you
> acquire that spinlock _after_ your call to getnstimeofday() what's the
> problem?

The problem is that we can have several PPS sources into a system and
all these sources will arise their IRQ line (quasi)simultaneously and
I don't wish a CPU may delay one of these IRQ handler due a spinlock
into the pps_event().

That's why I'm trying to avoid any lock into pps_event().

> I think you still haven't quite got the 32-bit vs. 64-bit compatibility
> right. Remember that on i386, the alignment of a uint64_t is only 4
> bytes, while on most other architectures it's 8 bytes. On i386, there
> will be no padding between the two consecutive 'struct pps_ktime'
> members of struct pps_kinfo and struct pps_kparams. But on most
> platforms there will be padding to ensure correct alignment.
> 
> The simple fix is probably to make the 'nsec' member a 64-bit integer
> too. Then it'll be the same for i386 and x86_64 and you won't need a
> compatibility syscall routine.

Ok. I'll add your comment too.

> In order for your handling of 'pps_source[source].info' to be safe with
> respect to pps_unregister_source(), you have to guarantee that
> pps_event() has finished -- and can't be in progress on another CPU --
> by the time your client's call to pps_unregister_source() completes. At
> first glance I think your existing clients have that right (you have
> del_timer_sync() before pps_unregister_source() in ktimer.c, for
> example). But you should make sure it's clearly documented for new
> clients.

This can be done only with locks, but it's not necessary since even if
a pps_unregister_source() runs while pps_event() executes on another
CPU the latter will write always on a valid area (even if it could be
a dummy one) and the data are not corrupted (note also that the data
will be, in any case, discarted since we are executing a
pps_unregister_source()).

> Shouldn't your PPS_CLIENT_LP and PPS_CLIENT_UART options depend on
> PARPORT and SERIAL_CORE respectively?

No. These options can be enabled but if no serial/parallel driver is
loaded no PPS source is registered.

Thanks,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
