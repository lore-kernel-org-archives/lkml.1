Return-Path: <linux-kernel-owner+w=401wt.eu-S1752939AbZLaSGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbZLaSGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 13:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbZLaSGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 13:06:20 -0500
Received: from mail1.radix.net ([207.192.128.31]:40881 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752883AbZLaSGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 13:06:20 -0500
Subject: Re: [PATCH] [0/6] kfifo fixes/improvements
From: Andy Walls <awalls@radix.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Vikram Dhillon <dhillonv10@gmail.com>,
       Stefani Seibold <stefani@seibold.net>, Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@osdl.org" <akpm@osdl.org>
In-Reply-To: <20091231073547.GA14333@core.coreip.homeip.net>
References: <20091228145749.GD4994@basil.fritz.box>
	 <1262016510.12656.25.camel@wall-e> <20091228172651.GE4994@basil.fritz.box>
	 <1262030653.15368.37.camel@wall-e> <20091228204003.GH4994@basil.fritz.box>
	 <1262076056.23095.21.camel@wall-e>
	 <64D5262E-28CF-41E8-9425-F8C5DD0A2265@gmail.com>
	 <ea6602020912291718n103694aft78ef15b65081a996@mail.gmail.com>
	 <20091230020830.GA7049@core.coreip.homeip.net>
	 <1262194152.5645.10.camel@palomino.walls.org>
	 <20091231073547.GA14333@core.coreip.homeip.net>
Content-Type: text/plain
Date: Thu, 31 Dec 2009 13:03:53 -0500
Message-Id: <1262282633.3055.40.camel@palomino.walls.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-30 at 23:35 -0800, Dmitry Torokhov wrote:
> On Wed, Dec 30, 2009 at 12:29:12PM -0500, Andy Walls wrote:
> > On Tue, 2009-12-29 at 18:08 -0800, Dmitry Torokhov wrote:
> > > A: http://en.wikipedia.org/wiki/Top_post
> > > Q: Were do I find info about this thing called top-posting?
> > > A: Because it messes up the order in which people normally read text.
> > > Q: Why is top-posting such a bad thing?
> > > 
> > > On Tue, Dec 29, 2009 at 08:18:50PM -0500, Vikram Dhillon wrote:
> > > > IMHO you can process elements rather than bytes, which is a good
> > > > improvement, but then again its my opinion, if others don't like it
> > > > then we can always change it :D
> > > 
> > > Right, I was not arguing against having a record-oriented interface, I
> > > was questioning the utility of processing several records at a time.
> > > Kfifo users that I have seen so far were working in a record-at-a-time
> > > mode.
> > 
> > I have a use case in linux/drivers/media/video/cx23885/cx23888-ir.c
> > right now.
> > 
> > I have a hardware fifo that can hold up to 8 values, 17 bits each - and
> > the high bit of the value is a flag indicating if more data is in the
> > hardware fifo.
> > 
> > The hardware fifo watermark for generating an interrupt is 4 or more
> > values in the hardware fifo.
> > 
> > I use a kfifo that needs to be protected with a spinlock.
> > 
> > It in much better in the IRQ context to drain the hardware fifo and then
> > put records in the kfifo all at once (or at least in groups of 8 or less
> > but usually greater than 1).
> 
> Hmm, so there you have a local buffer that you fill by reading from the
> device word by word, then you copy that data over into fifo and then you
> upper layer again fetches that fifo as byte stream...

Well technically the upper layer should be fetching data as a 4 byte
(u32 record) stream, but at the time I wrote my usage, kfifo only had
byte oriented usage for reading out of the kfifo.

Now that the spinlock has moved out of kfifo, I suppose when I convert
to record based usage, I don't strictly need multiple record puts into
the kfifo.  Since now my code can have fine grained control of when the
spinlock is taken and released, when I move to record based, I could
just put records into the kfifo one at a time with little penalty.

It really doesn't matter to me since the spinlock acquire and release,
saving and restoring the processor flags, was the big penalty.


> I'd probably simply move the processing that you are doing in
> cx23888_ir_rx_read() into cx23888_ir_irq_handler() (since it is very
> simple) and then used kfifo in simple byte mode (since that is what
> upper layer seem to expect).

Well, the the upper layer is really in a work handler that calls

	cx23885-input.c:cx23885_input_process_pulse_widths_rc5()

for RC-5 decoding for example.  It ends up calling cx23888_ir_rx_read()
to read in a number of 4 bytes (u32) pulse width records in a batch.  It
then feeds those records through the RC-5 decoding process one record at
a time (because that was the simple way to implement a decoding state
machine).

The idea was to avoid all the spinlock acquire release penalties
associtaed with accessing the kfifo, and to avoid contention with the
IRQ handler.


(BTW, I split the unit conversion work out to cx23888_ir_rx_read() with
IRQ latency in mind.  Since this is a video capture card with other,
more important interrupts to service, I just didn't want to spend any
extra CPU cycles in the cx23888_ir_irq_handler than necessary.  A work
handler context calling into cx23888_ir_rx_read() is a preferable
context in which to perform unit conversions compared to an IRQ context,
IMO.)
	


So in summary, I think any need I had for multiple record kfifo access
can be worked around by having the spinlock separate from the kfifo
calls.  However, with multiple record kfifo access methods available,
I'd likely find a convenient use for such methods.

Regards,
Andy

