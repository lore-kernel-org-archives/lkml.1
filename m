Return-Path: <linux-kernel-owner+w=401wt.eu-S2992853AbXCIBK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992853AbXCIBK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 20:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992855AbXCIBK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 20:10:57 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:63293 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992853AbXCIBK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 20:10:56 -0500
Date: Thu, 08 Mar 2007 19:10:39 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Sleeping thread not receive signal until it wakes up
In-reply-to: <fa.ygLhZcCLgDxnwAYYVse/Xshr9IE@ifi.uio.no>
To: Luong Ngo <luong.ngo@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: tglx@linutronix.de
Message-id: <45F0B40F.7070301@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.kb3wuhac4W+1DqK61+sKe9uZwto@ifi.uio.no>
 <fa.cyXmbtXvYymKHdI0rEXZCxyk+KE@ifi.uio.no>
 <fa.zPDT1vfJF5MjVXXQH/l+YSaLl84@ifi.uio.no>
 <fa.HmQN7RhZNBRsiJYADMOsY8DL67k@ifi.uio.no>
 <fa.PDmHwxZ3arhmED5SLuEONyxUlz4@ifi.uio.no>
 <fa.ygLhZcCLgDxnwAYYVse/Xshr9IE@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Luong Ngo wrote:
> Hi Thomas and Dick,
> I appreciate all the responses. They are very good information to me.
> Actually, it wasn't me working on the driver but it's been there long
> time. I thought I just need to add the signal and signal handling
> part, not expecting it would lead me to the driver space.
> Here is what I have in the driver. Maybe racing condition could happen
> in scenario that the ioctl realease the lock but befor going to sleep,
> the ISR is invoked and call waking up on the queue, hence the ioctl
> will not be waken up since the wak up cal already executed. But I
> believe in our system, this could be tolerant since the hardware would
> keep raising interrupt if the abnormal condition still exists (Due to
> the ioctl being blocked so user app nevers get a chance to service the
> device). But is this the reason why my signal handler not get executed
> at all? Theoretically, according to the Richard Stevens book, I think
> the process should be waken up and received the signal even if it gets
> blocked in the IOCTL call, am i right?

..

> static int ats89_ioctl(struct inode *inode, struct file *file, u_int
> cmd, u_long arg)
> {
> 
>          switch(cmd){
>           case GET_IRQ_CMD: {
>            u32  regMask32;
> 
>           spin_lock_irq(dev->lock);
>           while ((dev->irqMask & dev->irqEvent) == 0) {
>                 // Sleep until board interrupt happens
>                 spin_unlock_irq(dev->lock);
>                 interruptible_sleep_on(&(dev->boardIRQWaitQueue));
>                 if (uncond_wakeup) {
>                     /* don't go back to loop */
>                     break;
>                 }
>                 spin_lock_irq(dev->lock);
>             }

Kernel code does not get pre-empted by signals. If the code needs to be 
interruptible by signals this has to be handled explicitly. 
interruptible_sleep on will stop waiting if your task gets a signal, but 
your code doesn't check the signal_pending flag to know whether it 
should exit the loop. If signal_pending(current) is set after the sleep 
you should likely be returning -ERESTARTSYS to allow the task to handle 
the signal. Then after the signal handler from the task returns, the 
ioctl will get called again.

Also, as was pointed out, you should not use the sleep_on family of 
functions, use the wait_event functions intead. sleep_on is racy, if the 
interrupt happened just before you do the sleep, you'll sit there 
waiting for something that already occurred.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

