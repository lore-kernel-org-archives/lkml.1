Return-Path: <linux-kernel-owner+w=401wt.eu-S1767502AbXCITuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767502AbXCITuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 14:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767521AbXCITuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 14:50:40 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:8080 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767502AbXCITui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 14:50:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mSHe6KZgb21pzMRZb165ZYBum/1wy72O5c4njPpCkaMZmjbHRdR08g7+Gu8LE8WOyhy//00jVuuJG84wPOT9lWft/Tb6cQVomwE/xJDVIAQVETxZGEoeCQmXw+vwIv1IH86ZusZAyOamC/8WDQvYIYzrAr5o+M8ZZjzxSN9EWRk=
Message-ID: <1b2aacd80703091150h7842732fqb9a0ae80e5295948@mail.gmail.com>
Date: Fri, 9 Mar 2007 11:50:35 -0800
From: "Luong Ngo" <luong.ngo@gmail.com>
To: "Sergey Vlasov" <vsu@altlinux.ru>
Subject: Re: Sleeping thread not receive signal until it wakes up
Cc: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       "Linux kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070309175852.581a6162.vsu@altlinux.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1b2aacd80703062131g6c8578fgf200dd05a502c49f@mail.gmail.com>
	 <Pine.LNX.4.61.0703070813070.12338@chaos.analogic.com>
	 <1b2aacd80703071128v5227382do2277d0b85ca3b20c@mail.gmail.com>
	 <Pine.LNX.4.61.0703071457060.13923@chaos.analogic.com>
	 <1b2aacd80703071628y29b7d862h84eb5e853dd6f4d7@mail.gmail.com>
	 <Pine.LNX.4.61.0703080752570.17167@chaos.analogic.com>
	 <1173362032.24738.1058.camel@localhost.localdomain>
	 <1b2aacd80703081452s2fff09b7lea97245e337b1d2b@mail.gmail.com>
	 <20070309175852.581a6162.vsu@altlinux.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/9/07, Sergey Vlasov <vsu@altlinux.ru> wrote:
> On Thu, 8 Mar 2007 14:52:07 -0800 Luong Ngo wrote:
>
> [...]
> > static irqreturn board_isr(int irq, void *dev_id, struct pt_regs* regs)
> > {
> >  spin_lock(&dev->lock);
> >    if (dev->irqMask & (1 << irqBit)) {
> >     // Set the interrupt event mask
> >     dev->irqEvent |= (1 << irqBit);
> >
> >     // Disable this irq, it will be reenabled after processed by board task
> >     disable_irq(irq);
>
> I assume that your device does not support shared interrupts?  If it
> does (and a PCI device is required to support them), you cannot use
> disable_irq() here (and you need to check a register in the device to
> find out if it really did generate an IRQ)...

  Yes, the device does not share interrupt.

> > static int ats89_ioctl(struct inode *inode, struct file *file, u_int
> > cmd, u_long arg)
> > {
> >
> >           switch(cmd){
> >            case GET_IRQ_CMD: {
> >             u32  regMask32;
> >
> >            spin_lock_irq(dev->lock);
> >            while ((dev->irqMask & dev->irqEvent) == 0) {
> >                  // Sleep until board interrupt happens
> >                  spin_unlock_irq(dev->lock);
> >                  interruptible_sleep_on(&(dev->boardIRQWaitQueue));
> >                  if (uncond_wakeup) {
> >                      /* don't go back to loop */
> >                      break;
> >                  }
> >                  spin_lock_irq(dev->lock);
> >              }
> >
> >             uncond_wakeup = 0;
> >
> >              // Board interrupt happened
> >             regMask32 = dev->irqMask & dev->irqEvent;
> >              if(copy_to_user(&(((ATS89_IOCTL_S *)arg)->mask32),
> > &regMask32, sizeof(u32))) {
> >                  spin_unlock_irq(dev->lock);
> >                  return -EAGAIN;
> >              }
> >
> >              // Clear the event mask
> >              dev->irqEvent = 0;
> >              spin_unlock_irq(dev->lock);
> >         }
> >         break;
> >
> >
> >            }
> > }
>
> And this code is full of bugs:
>
>  1) As you have been told already, interruptible_sleep_on() and
>    sleep_on() functions are broken and should not be used (they are
>    left in the kernel only to support some obsolete code).  Either
>    use wait_event_interruptible() or work with wait queues directly
>    (prepare_to_wait(), finish_wait(), ...).
>
     I agree.but as I said our hardware will repeatedly raising
interrupts until it's serviced, the missing wakeup call would be
repeated also, so this should still wake up the sleep_on call. But we
would change it definitely.


>  2) The code to handle pending signals is missing - you need to have
>    this after wait_event_interruptible():
>
>                if (signal_pending(current))
>                        return -ERESTARTSYS;
>
>    (but be careful - you might need to clean up something before
>    returning).
>
>    This is what causes your problem - interruptible_sleep_on()
>    returns if a signal is pending, but your code does not check for
>    signals and therefore invokes interruptible_sleep_on() again; but
>    if a signal is pending, interruptible_sleep_on() returns
>    immediately, causing your driver to eat 100% CPU looping in kernel
>    mode until some device event finally happens.
>
     As pointed out by Robert, I added the checking
                   if(signal_pending(current))
                       return -ERESTARTSYS;
right after the line interruptible_sleep_on , but I don't see any
difference yet.

>  3) If uncond_wakeup is set, you break out of the loop with dev->lock
>    unlocked; however, if dev->irqEvent gets set, you exit the loop
>    with dev->lock locked.  The subsequent code always unlocks
>    dev->lock, so in the uncond_wakeup case you have double unlock.
>
  Thanks for catching it

>  4) You are doing copy_to_user() while holding a spinlock - this is
>    prohibited (as any other form of sleep inside a spinlock).
>
     Thanks again. But may I ask if it is prohibited, how come it has
been running without any error?

>  5) The return code for the copy_to_user() failure is wrong - it
>    should be -EFAULT (this is not a fatal bug, but an annoyance for
>    users of your driver, who might get such nonstandard error codes
>    while debugging their programs and wonder what is going on).
>
    changed.


Thank you for your input.

-LNgo
