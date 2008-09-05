Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbYIENTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbYIENTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 09:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbYIENTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 09:19:01 -0400
Received: from trinity.fluff.org ([89.145.97.151]:35051 "EHLO
	trinity.fluff.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbYIENTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 09:19:00 -0400
Date: Fri, 5 Sep 2008 14:18:56 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Christer Weinigel <christer@weinigel.se>
Cc: linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
       Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: Proposed SDIO layer rework
Message-ID: <20080905131855.GY26082@trinity.fluff.org>
References: <48C11BF3.2060609@weinigel.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C11BF3.2060609@weinigel.se>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2008 at 01:45:55PM +0200, Christer Weinigel wrote:
> Hi Pierre,
> 
> I said I wanted to argue a bit about the SDIO layer, and here it is. :-)
> 
> Ben, this is about the s3cmci driver, so I guess you might be interested.
> 
> I've been trying to make SDIO run and run fast on a small embedded 
> system with a Samsung S3C24A0 processor with 200 MHz ARM926 core.  While 
> doing this I've discovered some changes that I'd like to make to the 
> generic SDIO layer.

Many of the PDA class SoC are often in the 200-400 MHz class, although
faster variants are turning up there's an large contingent of similar
devices already out there.
 
> First some measurements.  I've connected the SDIO bus to an Agilent 
> scope to get some pretty plots.  To measure CPU load I have a small test 
> program which just counts how many gettimeofday calls I can do in one 
> second.  On on idle system I get the following:
> 
> 269648 kcycles in 1.000 s, 269 kcycles/s
> 
> I've written a test firmware for one of our SDIO chips which streams out 
> data using the SDIO Bluetooth Type A protocol, at 250 packets per 
> second, 2 kByte per packet for a total of about 4 MBit transfer rate.
> 
> The device driver I'm using is the s3cmci driver from Ben Dooks together 
> with my patches to do SDIO and with a working SDIO interrupt.  The 
> driver does not support DMA yet.  I've limited the SDIO bus clock to
> 10 MHz just to avoid any errors when connecting the scope probes.

Well, it isn't really from me, I've been doing the maintainance and required
cleanup after the original driver wsa released.
 
> If I use a test driver which just copies these packets to userspace and 
> then discards them (the logic in the test driver is basically the same 
> as in the btsdio driver), this is what I see on a scope:
> 
> http://zoo.weinigel.se/s3cmci/timing-normal.png
> 
> D4 is the CMD line and D5 is the CLK line.  D0 to D3 are the data lines. 
>  The SDIO interrupt is signalled on D1 and then you can see the 
> different SDIO transactions on the bus:
> 
> 1. SDIO layer reads the interrupt register in function 0
> 2. Driver reads the BT function nterrupt register
> 3. Driver clears the BT function interrupt register and
>    you can see the interrupt line going high again.
> 4. Driver reads the SDIO BT Type A header, you can see
>    the data transaction on the D0-D3 wires.
> 5. Driver reads the payload which is 2kBytes.
> 6. Driver acknowledges the packet.
> 
> Each transaction requires the SDIO irq thread to wake up, and at 250 
> packets times 6 operations per packet, that is 1500 wakeups per second, 
> not including the initial wakeup for the SDIO interrupt itself. The gaps 
> when the CLK line stops in the 2kByte data transfer is probably due to 
> scheduling latencies before the pio_tasklet in the s3cmci driver is run.
> As you can see, the latency from the interrupt being signalled to the 
> interrupt being cleared is about 340 us.  The cpu load program reports:
> 
> 130674 kcycles in 1.000 s, 154 kcycles/s
> 
> so about 45% of the CPU is spent just transferring data into kernel 
> space.  Another problem is that the reference board I'm using has a SMC 
> ethernet chip which is extremely slow, it can spend up to a dozen 
> milliseconds just reading data from the chip.  Since network traffic has 
> higher priority than the SDIO irq worker thread, if there is almost any 
> network traffic at all, the SDIO interrupt latency is awful, it often 
> reaches 10 or 20 ms.
> 
> To speed things up slightly, I removed the pio_tasklet in the s3cmci 
> driver and just called the function to read from the fifo directly from 
> the interrupt handler:

I've never really liked that PIO tasklet, and was planning on vanquishing
it (or at least allowing it to be configured off) in the next release, I
also belive that we can probably improve the code in that region anyway.
 
> http://zoo.weinigel.se/s3cmci/timing-no-tasklet.png
> 156078 kcycles in 1.000 s, 156 kcycles/s
> 
> So the CPU load is slightly lower and it looks as if the clock never 
> stops during the 2kByte transfer.  The latency is 320 us but this 
> difference is negligible, it is well within the variation I see when 
> looking at the the scope.
> 
> So, what I did next was to go through the whole SDIO layer, adding 
> asynchronous I/O operations all over the place.  So an asynchronouse 
> call to sdio_readb looks like this:
> 
>         ...
>         sdio_readb_start(func, address, done_callback);
> }
> 
> And then I of course need a callback:
> 
> void done_callback(struct sdio_func *func)
> {
>         u8 intrd;
>         int ret;
> 
>         value = sdio_readb_complete(func, &ret);
>         ...
> 
> So instead of sleeping, it registers a callback function which will be 
> called directly from the host interrupt handler when the SDIO transfer 
> finishes.  I also changed the SDIO interrupt handling so that the 
> interrupt handler is called directly from the mmc_signal_sdio_irq 
> function, instead of running from a thread.  This made an enormous 
> difference on the latency, it's down to 132 us, and the CPU load is down 
> as well:
> 
> http://zoo.weinigel.se/s3cmci/timing-async.png
> 185000 kcycles in 1.000 s, 185 kcycles/s
> 
> Most of the CPU is probably spent doing PIO transfers to the SDIO 
> controller, if DMA starts working in the s3cmci driver, the CPU load 
> difference will be even larger.

I'm not sure if I'll get the time to look at this before the new kernel
is released... anyway DMA may not be much of a win for smaller transfers
anyway, since the setup (the cache will need to be cleaned out or the
transfer memory made unbuffered)  and complete time will add another
IRQ's worth of response time. This means small transfers are probably
better off using PIO.

> Since more and more high speed chips are being connected to embedded 
> devices using SDIO, I belive that to get good SDIO performance, the SDIO 
> layer has to be changed not to use a worker thread.  This is 
> unfortunately rather painful since it means that we have to add 
> asynchronous variants of all the I/O operations, and the sdio_irq thread 
> has to be totally redone, and the sdio IRQ enabling and disablin turned 
> out to be a bit tricky.
> 
> So, do you think that it is worth it to make such a major change to the 
> SDIO subsystem?  I belive so, but I guess I'm a bit biased.  I can clean 
> up the work I've done and make sure that everything is backwards 
> compatible so that existing SDIO function drivers keep working (my 
> current hack to the sdio_irq thread breaks existing drivers, and it is 
> too ugly to live anyway so I don't even want to show it to you yet), and 
> add a demo driver which shows how to use the asynchronous functions.
> 
> But if you don't like this idea at all, I'll probably just keep it as a 
> patch and not bother as much with backwards compatibility.  This is a 
> lot more work for me though, and I'd much prefer to get it into the 
> official kernel.
> 
> Comments?
> 
>   /Christer
> 
> ps. I've tested the same driver on a Lenovo laptop with the SDHCI driver 
> and it works fine, but it doesn't make as big a difference there.  The 
> CPU load isn't big enough to matter even with the normal drivers, but 
> the latency gets slightly but not significantly better.

-- 
-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

