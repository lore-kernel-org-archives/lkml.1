Return-Path: <linux-kernel-owner+w=401wt.eu-S1754431AbZGVWJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbZGVWJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 18:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbZGVWJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 18:09:21 -0400
Received: from smtp104.sbc.mail.gq1.yahoo.com ([67.195.15.63]:21996 "HELO
	smtp104.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754002AbZGVWJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 18:09:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ZPrH8vNuP2aLVrK5pAcskdeqSPlVD4UGJDAxvUiH88DUDb2uo0E7nSWZD4p/NmoVS51WUF6ilHFnUrzufVfP1EcTkZPrNdIDATYkfuJ/2wMmgx95oXvTNF5XQb1SEnIBFVOQpSlrgNT/rfZ0c++28mGZ3wjn3IP8PbXrBckDWvo=  ;
X-Yahoo-SMTP: HIlLYKCswBDnjrunw3O.NnLyvismjGf1HBYfVTvuneM-
X-YMail-OSG: oda5BS0VM1lmk4Vym3CrAbzx1qkaanUbqDDuUHq.6.Ugqc0PbFDqnE.GHvybVVhU1am93B.cpqDXGg6tMcoTUdNRndGO7lM7Xpb0d8Ox2qb594I4Y0jF2UIxsLH6Smyw8vXzIlVwe_evxl6ZI2Yc.HadofZuG4uvDGgAV8REp00vQ1_eMRbA1MpGUnT3qW4f_J2q6ORIrf6EksEKxd4r7YIrtVhowx7ozE_kdvKnpzDvv0kNzI0RIRZJ4BZHt3.TLpla_PcY9CFUrFxE
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Threaded interrupts for synaptic touchscreen in HTC dream
Date: Wed, 22 Jul 2009 15:09:17 -0700
User-Agent: KMail/1.9.10
Cc: Peter Zijlstra <peterz@infradead.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       "Arve Hj?nnev?g" <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-i2c@vger.kernel.org,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       Daniel Ribeiro <drwyrm@gmail.com>
References: <5d5443650907151033w36008b71pe4b32bcea9489b75@mail.gmail.com> <200907220957.16499.david-b@pacbell.net> <alpine.LFD.2.00.0907222226270.2813@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0907222226270.2813@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907221509.18387.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 July 2009, Thomas Gleixner wrote:
> Ok, so let me summarize what we came up with so far.
> 
> 1) handle_level_oneshot_irq is the correct answer to the problem of
> those "I'm behind a slow bus" interrupt controllers.

Where "slow" means "access needs to sleep" ... preventing
register access from hardirq contexts.

I think you must mean "IRQ source" not controller; in
the examples so far on this thread, the irq_chip in
these cases has been a typical SoC/ASIC thing, but the
device issuing the IRQ is over I2C/etc.  (When the
irq_chip itself is across I2C/etc, #3 applies.)


> 2) Some mechanism to request ONESHOT from the driver level is
> required. Preferrably via a flag on request_threaded_irq

Preferably "explicit"; a flag implementation suffices.  Yes.


> 3) a function which allows to express the nested thread irq nature of
> the interrupt controller and its subdevices.

That's one possible implementation.  Basically, irq chaining
should work for threaded IRQs; some irq_chip devices will be
across sleeping/slow busses.  Some will even chain to another
level of irq_chip across such a bus.


> 4) a generic serializing mechanism which is implemented via irq_chip
> functions to solve the chip->mask/unmask issue for the demultiplexed
> interrupts. Something like the bus_lock/bus_sync_unlock patch I posted
> earlier.

In general, all irq_chip methods would need to use the sleeping/slow
bus ... like set_type(), and more.

That patch somewhat resembles the twl4030_sih_irq_chip stuff.


> 5) a common function which allows to call the thread handler of the
> subdevice interrupts in the context of the main thread which takes
> care of serialization against disable/enable/request/free irq et al.

A mechanism like that, yes.  ISTR sending a patch a while back with
a handle_threaded_irq() flow handler which you'd suggested.  I can dig
that up if you like, but I suspect you've had more thoughts about it
since that time.


> Any more ?

Not that comes quickly to mind.  If genirq can do all that, then
a lot of drivers/mfd/twl4030-irq.c can vanish ... I mention that
as probably the strongest "acceptance test" that's handy.

If you like to work with concrete use cases, that's one.  Also, a
simpler "slow irq_chip" device is the mcp23s08 GPIO expander.

- Dave


