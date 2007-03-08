Return-Path: <linux-kernel-owner+w=401wt.eu-S1030839AbXCHWwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030839AbXCHWwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 17:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030840AbXCHWwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 17:52:17 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:21947 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030839AbXCHWwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 17:52:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BD9tkD/uPfc1RDcjR/OaJMt0QlNaEGPBtURX8ed+xLo9L9LAlX2YptevDBxl674ZjXiNWbyRMKWZYVhTNFI9sdq48XNHLYrX7MC82XzSkPoceTlH61PjQPqdPZvFfRykn2Y88SKn1mJcStc9vCaedX1L2dw9cH4cfBHTFW3Q0pc=
Message-ID: <1b2aacd80703081452s2fff09b7lea97245e337b1d2b@mail.gmail.com>
Date: Thu, 8 Mar 2007 14:52:07 -0800
From: "Luong Ngo" <luong.ngo@gmail.com>
To: tglx@linutronix.de
Subject: Re: Sleeping thread not receive signal until it wakes up
Cc: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       "Linux kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <1173362032.24738.1058.camel@localhost.localdomain>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/8/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 2007-03-08 at 08:01 -0500, linux-os (Dick Johnson) wrote:
> > > Anything kernel configuration I need to be aware of to enable
> > > preemption in kernel?
> > >
> > >
> > > Thank you,
> > > LNgo
> > >
> >
> > First, in the ioctl, if you need spin-locks, you need to use
> > spin_lock_irqsave/spin_unlock/irqrestore. The ones that don't
> > save and restore are for the ISR where we know that the interrupts
> > are already off and don't intend to turn them on. Further, make
>
> As usual completely wrong:
>
> ioctl code is called with interrupts enabled. So if you need to protect
> against interrupts it is completely correct to use spin_lock_irq /
> spin_unlock_irq. There is nothing to save and nothing to restore.
>
> > sure that you don't try to schedule() with the interrupts off.
> >
> > interruptible_sleep_on(&qu);
> >                          ^______ Where is this?
>
> Not included in the pseudo code.
>
> > This must be accessible both in the ISR and in the ioctl(). It
> > also needs to have been properly initialized when your module
> > was installed (see numerious code samples in the kernel).
>
> Instead of blurbing about obvious things you should point Luong to the
> real problems:
>
> include/linux/wait.h:
> /*
>  * These are the old interfaces to sleep waiting for an event.
>  * They are racy.  DO NOT use them, use the wait_event* interfaces above.
>  * We plan to remove these interfaces during 2.7.
>  */
> extern void FASTCALL(sleep_on(wait_queue_head_t *q));
> extern long FASTCALL(sleep_on_timeout(wait_queue_head_t *q,
>                                      signed long timeout));
> extern void FASTCALL(interruptible_sleep_on(wait_queue_head_t *q));
> extern long FASTCALL(interruptible_sleep_on_timeout(wait_queue_head_t *q,
>                                                    signed long timeout));
>
> Luong, please use wait_event_interruptible() instead.
>
>        spin_lock_irq(dev->lock);
>        do_whatever_you_need_to_initialize(dev);
>        dev->event_happened = 0;
>        spin_unlock_irq(dev->lock);
>
>        res = wait_event_interruptible(&dev->queue, dev->event_happened != 0);
>
> Thanks,
>
>        tglx
>
>
>

Hi Thomas and Dick,
I appreciate all the responses. They are very good information to me.
Actually, it wasn't me working on the driver but it's been there long
time. I thought I just need to add the signal and signal handling
part, not expecting it would lead me to the driver space.
Here is what I have in the driver. Maybe racing condition could happen
in scenario that the ioctl realease the lock but befor going to sleep,
the ISR is invoked and call waking up on the queue, hence the ioctl
will not be waken up since the wak up cal already executed. But I
believe in our system, this could be tolerant since the hardware would
keep raising interrupt if the abnormal condition still exists (Due to
the ioctl being blocked so user app nevers get a chance to service the
device). But is this the reason why my signal handler not get executed
at all? Theoretically, according to the Richard Stevens book, I think
the process should be waken up and received the signal even if it gets
blocked in the IOCTL call, am i right?

static irqreturn board_isr(int irq, void *dev_id, struct pt_regs* regs)
{
 spin_lock(&dev->lock);
   if (dev->irqMask & (1 << irqBit)) {
    // Set the interrupt event mask
    dev->irqEvent |= (1 << irqBit);

    // Disable this irq, it will be reenabled after processed by board task
    disable_irq(irq);
    // Wake up Board thread that calling IOCTL
    wake_up(&(dev->boardIRQWaitQueue));
  }
  spin_unlock(&dev->lock);

  return IRQ_HANDLED;

}

static int ats89_ioctl(struct inode *inode, struct file *file, u_int
cmd, u_long arg)
{

          switch(cmd){
           case GET_IRQ_CMD: {
            u32  regMask32;

           spin_lock_irq(dev->lock);
           while ((dev->irqMask & dev->irqEvent) == 0) {
                 // Sleep until board interrupt happens
                 spin_unlock_irq(dev->lock);
                 interruptible_sleep_on(&(dev->boardIRQWaitQueue));
                 if (uncond_wakeup) {
                     /* don't go back to loop */
                     break;
                 }
                 spin_lock_irq(dev->lock);
             }

            uncond_wakeup = 0;

             // Board interrupt happened
            regMask32 = dev->irqMask & dev->irqEvent;
             if(copy_to_user(&(((ATS89_IOCTL_S *)arg)->mask32),
&regMask32, sizeof(u32))) {
                 spin_unlock_irq(dev->lock);
                 return -EAGAIN;
             }

             // Clear the event mask
             dev->irqEvent = 0;
             spin_unlock_irq(dev->lock);
        }
        break;


           }
}


Could you tell me why the blocking call to ioctl(GET_IRQ_CMD) in the
user space would block the whole process/thread to receive an alarm
signal delievered to it?

By the way, in my kernel, the lock_kernel, unlock_kernel are defined
as nothing just a simple do while loop and return right away, the
kernel_locked always return 1. There is know CONFIG_KERNEL_PREEMPT or
the likes CONFIG flag in my config file.

Thank you very much

LNgo
