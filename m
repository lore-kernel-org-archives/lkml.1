Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbYIHPMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbYIHPMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 11:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbYIHPMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 11:12:30 -0400
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:57704 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbYIHPMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 11:12:30 -0400
Message-ID: <48C540DC.3070306@weinigel.se>
Date: Mon, 08 Sep 2008 17:12:28 +0200
From: Christer Weinigel <christer@weinigel.se>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ben Dooks <ben-linux@fluff.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] s3cmci - call pio_tasklet from IRQ
References: <20080908124848.541807034@zoo.weinigel.se> <20080908124909.554600509@zoo.weinigel.se> <20080908134656.GB30478@trinity.fluff.org>
In-Reply-To: <20080908134656.GB30478@trinity.fluff.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Dooks wrote:
> On Mon, Sep 08, 2008 at 02:48:50PM +0200, Christer Weinigel wrote:
>> Scheduling a tasklet to perform the pio transfer introduces a bit of
>> extra processing, just call pio_tasklet directly from the interrupt
>> instead.  Writing up to 64 bytes to a FIFO is probably uses less CPU
>> than scheduling a tasklet anyway.
> 
> Hmm, i'd be interested to find out how long these are taking... I might
> try and rig up something to test the time being taken via an SMDK.
> 
> If the fifo read/writes are taking significant amounts of time, then the
> pio tasklet will at least improve the interrupt latencies invloved, as
> iirc we're currently running the main irq handler in IRQ_DISABLED mode
> to stop any problems with re-enternancy.... I'll check this and see what
> is going on.

Ok, I just measured this on the 200 MHz S3C24A0, when running the SDIO 
bus at 10 MHz, the longest time I saw the driver spend in the pio_read 
function was ~10us.  I guess that means that the hardware managed to 
empty the fifo enough to do yet another spin through the loop.  So with 
a faster SDIO clock the time spent in pio_read ought to go up, and for a 
long transfer it could grow without bounds.

I also tried to run the code with the schedule_tasklet still there, and 
then I saw ~13us as the longest time spent in the loop, and every now 
and then there was a ~10ms gap when the clock stopped.

If we have working DMA, I think the PIO tasklet is unneccesary, then 
we'll do PIO for short transfers which won't affect latency much, and 
use DMA for long transfers that would have affected latency if done with 
PIO from interrupt context.

   /Christer

