Return-Path: <linux-kernel-owner+w=401wt.eu-S1750925AbXCIO66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750925AbXCIO66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 09:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932529AbXCIO66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 09:58:58 -0500
Received: from mivlgu.ru ([81.18.140.87]:47366 "EHLO mail.mivlgu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbXCIO65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 09:58:57 -0500
Date: Fri, 9 Mar 2007 17:58:52 +0300
From: Sergey Vlasov <vsu@altlinux.ru>
To: "Luong Ngo" <luong.ngo@gmail.com>
Cc: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       "Linux kernel" <linux-kernel@vger.kernel.org>
Subject: Re: Sleeping thread not receive signal until it wakes up
Message-Id: <20070309175852.581a6162.vsu@altlinux.ru>
In-Reply-To: <1b2aacd80703081452s2fff09b7lea97245e337b1d2b@mail.gmail.com>
References: <1b2aacd80703062131g6c8578fgf200dd05a502c49f@mail.gmail.com>
	<Pine.LNX.4.61.0703070813070.12338@chaos.analogic.com>
	<1b2aacd80703071128v5227382do2277d0b85ca3b20c@mail.gmail.com>
	<Pine.LNX.4.61.0703071457060.13923@chaos.analogic.com>
	<1b2aacd80703071628y29b7d862h84eb5e853dd6f4d7@mail.gmail.com>
	<Pine.LNX.4.61.0703080752570.17167@chaos.analogic.com>
	<1173362032.24738.1058.camel@localhost.localdomain>
	<1b2aacd80703081452s2fff09b7lea97245e337b1d2b@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.9 (GTK+ 2.10.6; i586-alt-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2007 14:52:07 -0800 Luong Ngo wrote:

[...]
> static irqreturn board_isr(int irq, void *dev_id, struct pt_regs* regs)
> {
>  spin_lock(&dev->lock);
>    if (dev->irqMask & (1 << irqBit)) {
>     // Set the interrupt event mask
>     dev->irqEvent |= (1 << irqBit);
> 
>     // Disable this irq, it will be reenabled after processed by board task
>     disable_irq(irq);

I assume that your device does not support shared interrupts?  If it
does (and a PCI device is required to support them), you cannot use
disable_irq() here (and you need to check a register in the device to
find out if it really did generate an IRQ)...

>     // Wake up Board thread that calling IOCTL
>     wake_up(&(dev->boardIRQWaitQueue));
>   }
>   spin_unlock(&dev->lock);
> 
>   return IRQ_HANDLED;

...and return IRQ_NONE here if the IRQ is not from your device.

> 
> }
> 
> static int ats89_ioctl(struct inode *inode, struct file *file, u_int
> cmd, u_long arg)
> {
> 
>           switch(cmd){
>            case GET_IRQ_CMD: {
>             u32  regMask32;
> 
>            spin_lock_irq(dev->lock);
>            while ((dev->irqMask & dev->irqEvent) == 0) {
>                  // Sleep until board interrupt happens
>                  spin_unlock_irq(dev->lock);
>                  interruptible_sleep_on(&(dev->boardIRQWaitQueue));
>                  if (uncond_wakeup) {
>                      /* don't go back to loop */
>                      break;
>                  }
>                  spin_lock_irq(dev->lock);
>              }
> 
>             uncond_wakeup = 0;
> 
>              // Board interrupt happened
>             regMask32 = dev->irqMask & dev->irqEvent;
>              if(copy_to_user(&(((ATS89_IOCTL_S *)arg)->mask32),
> &regMask32, sizeof(u32))) {
>                  spin_unlock_irq(dev->lock);
>                  return -EAGAIN;
>              }
> 
>              // Clear the event mask
>              dev->irqEvent = 0;
>              spin_unlock_irq(dev->lock);
>         }
>         break;
> 
> 
>            }
> }

And this code is full of bugs:

 1) As you have been told already, interruptible_sleep_on() and
    sleep_on() functions are broken and should not be used (they are
    left in the kernel only to support some obsolete code).  Either
    use wait_event_interruptible() or work with wait queues directly
    (prepare_to_wait(), finish_wait(), ...).

 2) The code to handle pending signals is missing - you need to have
    this after wait_event_interruptible():

		if (signal_pending(current))
			return -ERESTARTSYS;

    (but be careful - you might need to clean up something before
    returning).

    This is what causes your problem - interruptible_sleep_on()
    returns if a signal is pending, but your code does not check for
    signals and therefore invokes interruptible_sleep_on() again; but
    if a signal is pending, interruptible_sleep_on() returns
    immediately, causing your driver to eat 100% CPU looping in kernel
    mode until some device event finally happens.

 3) If uncond_wakeup is set, you break out of the loop with dev->lock
    unlocked; however, if dev->irqEvent gets set, you exit the loop
    with dev->lock locked.  The subsequent code always unlocks
    dev->lock, so in the uncond_wakeup case you have double unlock.

 4) You are doing copy_to_user() while holding a spinlock - this is
    prohibited (as any other form of sleep inside a spinlock).

 5) The return code for the copy_to_user() failure is wrong - it
    should be -EFAULT (this is not a fatal bug, but an annoyance for
    users of your driver, who might get such nonstandard error codes
    while debugging their programs and wonder what is going on).
