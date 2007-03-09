Return-Path: <linux-kernel-owner+w=401wt.eu-S2992923AbXCIDYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992923AbXCIDYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 22:24:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992927AbXCIDYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 22:24:14 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:52376 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992923AbXCIDYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 22:24:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oAgGqqhItsd8WCkCR9tL3YewqrMvW4OHknj5c8pHOFD5wC8nF/uZ9xkdl522ySuWcIPWJsHF0gmzHCLUfWiByE6KlFXbAXLooIYQdnnB1xNFwOZnxuOV2y1qQ0T4nieKp/NOv40fwNkdLxR/ssFFaHDA6Ca4oc2Kc673o2lUngg=
Message-ID: <1b2aacd80703081924w44652c71yb8a16e005247a55a@mail.gmail.com>
Date: Thu, 8 Mar 2007 19:24:10 -0800
From: "Luong Ngo" <luong.ngo@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: Sleeping thread not receive signal until it wakes up
Cc: linux-kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de
In-Reply-To: <45F0B40F.7070301@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.kb3wuhac4W+1DqK61+sKe9uZwto@ifi.uio.no>
	 <fa.cyXmbtXvYymKHdI0rEXZCxyk+KE@ifi.uio.no>
	 <fa.zPDT1vfJF5MjVXXQH/l+YSaLl84@ifi.uio.no>
	 <fa.HmQN7RhZNBRsiJYADMOsY8DL67k@ifi.uio.no>
	 <fa.PDmHwxZ3arhmED5SLuEONyxUlz4@ifi.uio.no>
	 <fa.ygLhZcCLgDxnwAYYVse/Xshr9IE@ifi.uio.no> <45F0B40F.7070301@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/8/07, Robert Hancock <hancockr@shaw.ca> wrote:
> Luong Ngo wrote:
> > Hi Thomas and Dick,
> > I appreciate all the responses. They are very good information to me.
> > Actually, it wasn't me working on the driver but it's been there long
> > time. I thought I just need to add the signal and signal handling
> > part, not expecting it would lead me to the driver space.
> > Here is what I have in the driver. Maybe racing condition could happen
> > in scenario that the ioctl realease the lock but befor going to sleep,
> > the ISR is invoked and call waking up on the queue, hence the ioctl
> > will not be waken up since the wak up cal already executed. But I
> > believe in our system, this could be tolerant since the hardware would
> > keep raising interrupt if the abnormal condition still exists (Due to
> > the ioctl being blocked so user app nevers get a chance to service the
> > device). But is this the reason why my signal handler not get executed
> > at all? Theoretically, according to the Richard Stevens book, I think
> > the process should be waken up and received the signal even if it gets
> > blocked in the IOCTL call, am i right?
>
> ..
>
> > static int ats89_ioctl(struct inode *inode, struct file *file, u_int
> > cmd, u_long arg)
> > {
> >
> >          switch(cmd){
> >           case GET_IRQ_CMD: {
> >            u32  regMask32;
> >
> >           spin_lock_irq(dev->lock);
> >           while ((dev->irqMask & dev->irqEvent) == 0) {
> >                 // Sleep until board interrupt happens
> >                 spin_unlock_irq(dev->lock);
> >                 interruptible_sleep_on(&(dev->boardIRQWaitQueue));
> >                 if (uncond_wakeup) {
> >                     /* don't go back to loop */
> >                     break;
> >                 }
> >                 spin_lock_irq(dev->lock);
> >             }
>
> Kernel code does not get pre-empted by signals. If the code needs to be
> interruptible by signals this has to be handled explicitly.
> interruptible_sleep on will stop waiting if your task gets a signal, but
> your code doesn't check the signal_pending flag to know whether it
> should exit the loop. If signal_pending(current) is set after the sleep
> you should likely be returning -ERESTARTSYS to allow the task to handle
> the signal. Then after the signal handler from the task returns, the
> ioctl will get called again.
>
> Also, as was pointed out, you should not use the sleep_on family of
> functions, use the wait_event functions intead. sleep_on is racy, if the
> interrupt happened just before you do the sleep, you'll sit there
> waiting for something that already occurred.
>
> --
> Robert Hancock      Saskatoon, SK, Canada
> To email, remove "nospam" from hancockr@nospamshaw.ca
> Home Page: http://www.roberthancock.com/
>
>
Robert, thanks a lot for your suggestion
But I have added the signal_pending(current) check and signal handler
is not invoked

           spin_lock_irq(dev->lock);
           while ((dev->irqMask & dev->irqEvent) == 0) {
                 // Sleep until board interrupt happens
                 spin_unlock_irq(dev->lock);
                 interruptible_sleep_on(&(dev->boardIRQWaitQueue));

                 if(signal_pending(current) {
                           return -ERESTARTSYS;
                 }

                 if (uncond_wakeup) {
                     /* don't go back to loop */
                     break;
                 }
                 spin_lock_irq(dev->lock);
             }
Still no luck yet.
LNgo
