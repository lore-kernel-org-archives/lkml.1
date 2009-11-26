Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbZKZMnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbZKZMnE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 07:43:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbZKZMnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 07:43:03 -0500
Received: from mail1.radix.net ([207.192.128.31]:43637 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbZKZMnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 07:43:02 -0500
Subject: Re: linux-next: workqueues tree build failure
From: Andy Walls <awalls@radix.net>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <4B0E467A.8080201@kernel.org>
References: <20091126190050.3f9d7fef.sfr@canb.auug.org.au>
	 <4B0E3677.6000603@kernel.org> <200911261016.58810.peter.ujfalusi@nokia.com>
	 <4B0E467A.8080201@kernel.org>
Content-Type: text/plain
Date: Thu, 26 Nov 2009 07:40:25 -0500
Message-Id: <1259239225.3062.16.camel@palomino.walls.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 18:12 +0900, Tejun Heo wrote:
> Hello,
> 
> 11/26/2009 05:16 PM, Peter Ujfalusi wrote:
> >> Takashi, RT workqueue is going away.  Do you really need it?
> > 
> > What can be used instead of RT workqueue?
> > The tlv320dac33 needs RT workqueue because I need to send the I2C
> > command with minimum delay to the codec. If this can not be done
> > (the workqueue is delayed), and the codec does not receive the
> > command in time, it will literally die.  What are the options to
> > replace the RT workqueue?
> 
> The problem with RT workqueue is that RT and queue don't really mix
> well.  To act in real time, it requires all the resource pre-allocated
> and dedicated to it making queueing or pooling meaningless.  The
> original workqueue code created dedicated pool of threads for each
> workqueue so it could be used for RT but new implementation uses
> shared worker pool, so it can't be used as an interface to dedicated
> threads.
> 
> I haven't read the code but,
> 
> * If you need to respond fast, wouldn't you be doing that from IRQ
>   handler or softirq?  Do you need task context?

Hi Tejun,

I'm not sure doing things like I2C transactions in the in the top half
of the IRQ handler is generally viable.  On shared IRQ lines, wouldn't
this hold off the interrupt for another device for too long?

For example, I already ran across the case of an error path in the ahci
disk controller driver interrupt handler holding off interrupts from the
cx18 driver longer than the CX23418 firmware would tolerate on a shared
interrupt line.

Workhandlers for deferring work are a nice way to avoid such bad system
level interactions.

Regards,
Andy


> * Or is it that it's not triggered by IRQ but once the transfer
>   started it can't be interrupted?  But in this case preempt_disable()
>   or local_irq_disable() should suffice.
> 
> Thanks.


